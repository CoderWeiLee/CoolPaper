#!/bin/sh
set -e
set -u
set -o pipefail

function on_error {
  echo "$(realpath -mq "${0}"):$1: error: Unexpected failure"
}
trap 'on_error $LINENO' ERR


# This protects against multiple targets copying the same framework dependency at the same time. The solution
# was originally proposed here: https://lists.samba.org/archive/rsync/2008-February/020158.html
RSYNC_PROTECT_TMP_FILES=(--filter "P .*.??????")


copy_dir()
{
  local source="$1"
  local destination="$2"

  # Use filter instead of exclude so missing patterns don't throw errors.
  echo "rsync --delete -av "${RSYNC_PROTECT_TMP_FILES[@]}" --links --filter \"- CVS/\" --filter \"- .svn/\" --filter \"- .git/\" --filter \"- .hg/\" \"${source}\" \"${destination}\""
  rsync --delete -av "${RSYNC_PROTECT_TMP_FILES[@]}" --links --filter "- CVS/" --filter "- .svn/" --filter "- .git/" --filter "- .hg/" "${source}" "${destination}"
}

SELECT_SLICE_RETVAL=""

select_slice() {
  local paths=("$@")
  # Locate the correct slice of the .xcframework for the current architectures
  local target_path=""

  # Split archs on space so we can find a slice that has all the needed archs
  local target_archs=$(echo $ARCHS | tr " " "\n")

  local target_variant=""
  if [[ "$PLATFORM_NAME" == *"simulator" ]]; then
    target_variant="simulator"
  fi
  if [[ ! -z ${EFFECTIVE_PLATFORM_NAME+x} && "$EFFECTIVE_PLATFORM_NAME" == *"maccatalyst" ]]; then
    target_variant="maccatalyst"
  fi
  for i in ${!paths[@]}; do
    local matched_all_archs="1"
    for target_arch in $target_archs
    do
      if ! [[ "${paths[$i]}" == *"$target_variant"* ]]; then
        matched_all_archs="0"
        break
      fi

      # Verifies that the path contains the variant string (simulator or maccatalyst) if the variant is set.
      if [[ -z "$target_variant" && ("${paths[$i]}" == *"simulator"* || "${paths[$i]}" == *"maccatalyst"*) ]]; then
        matched_all_archs="0"
        break
      fi

      # This regex matches all possible variants of the arch in the folder name:
      # Let's say the folder name is: ios-armv7_armv7s_arm64_arm64e/CoconutLib.framework
      # We match the following: -armv7_, _armv7s_, _arm64_ and _arm64e/.
      # If we have a specific variant: ios-i386_x86_64-simulator/CoconutLib.framework
      # We match the following: -i386_ and _x86_64-
      # When the .xcframework wraps a static library, the folder name does not include
      # any .framework. In that case, the folder name can be: ios-arm64_armv7
      # We also match _armv7$ to handle that case.
      local target_arch_regex="[_\-]${target_arch}([\/_\-]|$)"
      if ! [[ "${paths[$i]}" =~ $target_arch_regex ]]; then
        matched_all_archs="0"
        break
      fi
    done

    if [[ "$matched_all_archs" == "1" ]]; then
      # Found a matching slice
      echo "Selected xcframework slice ${paths[$i]}"
      SELECT_SLICE_RETVAL=${paths[$i]}
      break
    fi
  done
}

install_library() {
  local source="$1"
  local name="$2"
  local destination="${PODS_XCFRAMEWORKS_BUILD_DIR}/${name}"

  # Libraries can contain headers, module maps, and a binary, so we'll copy everything in the folder over

  local source="$binary"
  echo "rsync --delete -av "${RSYNC_PROTECT_TMP_FILES[@]}" --links --filter \"- CVS/\" --filter \"- .svn/\" --filter \"- .git/\" --filter \"- .hg/\" \"${source}/*\" \"${destination}\""
  rsync --delete -av "${RSYNC_PROTECT_TMP_FILES[@]}" --links --filter "- CVS/" --filter "- .svn/" --filter "- .git/" --filter "- .hg/" "${source}/*" "${destination}"
}

# Copies a framework to derived data for use in later build phases
install_framework()
{
  local source="$1"
  local name="$2"
  local destination="${PODS_XCFRAMEWORKS_BUILD_DIR}/${name}"

  if [ ! -d "$destination" ]; then
    mkdir -p "$destination"
  fi

  copy_dir "$source" "$destination"
  echo "Copied $source to $destination"
}

install_xcframework_library() {
  local basepath="$1"
  local name="$2"
  local paths=("$@")

  # Locate the correct slice of the .xcframework for the current architectures
  select_slice "${paths[@]}"
  local target_path="$SELECT_SLICE_RETVAL"
  if [[ -z "$target_path" ]]; then
    echo "warning: [CP] Unable to find matching .xcframework slice in '${paths[@]}' for the current build architectures ($ARCHS)."
    return
  fi

  install_framework "$basepath/$target_path" "$name"
}

install_xcframework() {
  local basepath="$1"
  local name="$2"
  local package_type="$3"
  local paths=("$@")

  # Locate the correct slice of the .xcframework for the current architectures
  select_slice "${paths[@]}"
  local target_path="$SELECT_SLICE_RETVAL"
  if [[ -z "$target_path" ]]; then
    echo "warning: [CP] Unable to find matching .xcframework slice in '${paths[@]}' for the current build architectures ($ARCHS)."
    return
  fi
  local source="$basepath/$target_path"

  local destination="${PODS_XCFRAMEWORKS_BUILD_DIR}/${name}"

  if [ ! -d "$destination" ]; then
    mkdir -p "$destination"
  fi

  copy_dir "$source/" "$destination"

  echo "Copied $source to $destination"
}

install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full/mobileffmpeg.xcframework" "mobileffmpeg" "framework" "ios-arm64" "ios-x86_64-maccatalyst" "ios-x86_64-simulator"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full/libavcodec.xcframework" "libavcodec" "framework" "ios-arm64" "ios-x86_64-simulator" "ios-x86_64-maccatalyst"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full/libavdevice.xcframework" "libavdevice" "framework" "ios-arm64" "ios-x86_64-simulator" "ios-x86_64-maccatalyst"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full/libavfilter.xcframework" "libavfilter" "framework" "ios-arm64" "ios-x86_64-simulator" "ios-x86_64-maccatalyst"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full/libavformat.xcframework" "libavformat" "framework" "ios-x86_64-simulator" "ios-arm64" "ios-x86_64-maccatalyst"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full/libavutil.xcframework" "libavutil" "framework" "ios-x86_64-simulator" "ios-arm64" "ios-x86_64-maccatalyst"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full/libswresample.xcframework" "libswresample" "framework" "ios-arm64" "ios-x86_64-simulator" "ios-x86_64-maccatalyst"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full/libswscale.xcframework" "libswscale" "framework" "ios-x86_64-simulator" "ios-x86_64-maccatalyst" "ios-arm64"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full/expat.xcframework" "expat" "framework" "ios-x86_64-simulator" "ios-x86_64-maccatalyst" "ios-arm64"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full/fontconfig.xcframework" "fontconfig" "framework" "ios-x86_64-maccatalyst" "ios-x86_64-simulator" "ios-arm64"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full/freetype.xcframework" "freetype" "framework" "ios-x86_64-maccatalyst" "ios-x86_64-simulator" "ios-arm64"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full/fribidi.xcframework" "fribidi" "framework" "ios-x86_64-maccatalyst" "ios-x86_64-simulator" "ios-arm64"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full/giflib.xcframework" "giflib" "framework" "ios-arm64" "ios-x86_64-simulator" "ios-x86_64-maccatalyst"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full/gmp.xcframework" "gmp" "framework" "ios-x86_64-simulator" "ios-x86_64-maccatalyst" "ios-arm64"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full/gnutls.xcframework" "gnutls" "framework" "ios-arm64" "ios-x86_64-simulator" "ios-x86_64-maccatalyst"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full/jpeg.xcframework" "jpeg" "framework" "ios-x86_64-simulator" "ios-arm64" "ios-x86_64-maccatalyst"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full/kvazaar.xcframework" "kvazaar" "framework" "ios-x86_64-simulator" "ios-x86_64-maccatalyst" "ios-arm64"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full/lame.xcframework" "lame" "framework" "ios-x86_64-simulator" "ios-x86_64-maccatalyst" "ios-arm64"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full/libaom.xcframework" "libaom" "framework" "ios-x86_64-simulator" "ios-arm64" "ios-x86_64-maccatalyst"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full/libass.xcframework" "libass" "framework" "ios-arm64" "ios-x86_64-simulator" "ios-x86_64-maccatalyst"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full/libhogweed.xcframework" "libhogweed" "framework" "ios-arm64" "ios-x86_64-simulator" "ios-x86_64-maccatalyst"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full/libilbc.xcframework" "libilbc" "framework" "ios-x86_64-simulator" "ios-x86_64-maccatalyst" "ios-arm64"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full/libnettle.xcframework" "libnettle" "framework" "ios-arm64" "ios-x86_64-simulator" "ios-x86_64-maccatalyst"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full/libogg.xcframework" "libogg" "framework" "ios-x86_64-simulator" "ios-x86_64-maccatalyst" "ios-arm64"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full/libopencore-amrnb.xcframework" "libopencore-amrnb" "framework" "ios-arm64" "ios-x86_64-maccatalyst" "ios-x86_64-simulator"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full/libpng.xcframework" "libpng" "framework" "ios-x86_64-maccatalyst" "ios-x86_64-simulator" "ios-arm64"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full/libsndfile.xcframework" "libsndfile" "framework" "ios-x86_64-simulator" "ios-arm64" "ios-x86_64-maccatalyst"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full/libtheora.xcframework" "libtheora" "framework" "ios-x86_64-simulator" "ios-x86_64-maccatalyst" "ios-arm64"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full/libtheoradec.xcframework" "libtheoradec" "framework" "ios-x86_64-simulator" "ios-x86_64-maccatalyst" "ios-arm64"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full/libtheoraenc.xcframework" "libtheoraenc" "framework" "ios-x86_64-maccatalyst" "ios-x86_64-simulator" "ios-arm64"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full/libvorbis.xcframework" "libvorbis" "framework" "ios-x86_64-maccatalyst" "ios-x86_64-simulator" "ios-arm64"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full/libvorbisenc.xcframework" "libvorbisenc" "framework" "ios-arm64" "ios-x86_64-simulator" "ios-x86_64-maccatalyst"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full/libvorbisfile.xcframework" "libvorbisfile" "framework" "ios-x86_64-simulator" "ios-arm64" "ios-x86_64-maccatalyst"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full/libvpx.xcframework" "libvpx" "framework" "ios-arm64" "ios-x86_64-simulator" "ios-x86_64-maccatalyst"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full/libwebp.xcframework" "libwebp" "framework" "ios-arm64" "ios-x86_64-simulator" "ios-x86_64-maccatalyst"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full/libwebpmux.xcframework" "libwebpmux" "framework" "ios-x86_64-maccatalyst" "ios-arm64" "ios-x86_64-simulator"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full/libwebpdemux.xcframework" "libwebpdemux" "framework" "ios-arm64" "ios-x86_64-simulator" "ios-x86_64-maccatalyst"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full/libxml2.xcframework" "libxml2" "framework" "ios-x86_64-maccatalyst" "ios-arm64" "ios-x86_64-simulator"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full/opus.xcframework" "opus" "framework" "ios-x86_64-maccatalyst" "ios-x86_64-simulator" "ios-arm64"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full/shine.xcframework" "shine" "framework" "ios-arm64" "ios-x86_64-maccatalyst" "ios-x86_64-simulator"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full/snappy.xcframework" "snappy" "framework" "ios-x86_64-simulator" "ios-arm64" "ios-x86_64-maccatalyst"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full/soxr.xcframework" "soxr" "framework" "ios-x86_64-simulator" "ios-arm64" "ios-x86_64-maccatalyst"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full/speex.xcframework" "speex" "framework" "ios-x86_64-maccatalyst" "ios-x86_64-simulator" "ios-arm64"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full/tiff.xcframework" "tiff" "framework" "ios-arm64" "ios-x86_64-simulator" "ios-x86_64-maccatalyst"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full/twolame.xcframework" "twolame" "framework" "ios-x86_64-maccatalyst" "ios-arm64" "ios-x86_64-simulator"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full/vo-amrwbenc.xcframework" "vo-amrwbenc" "framework" "ios-x86_64-simulator" "ios-arm64" "ios-x86_64-maccatalyst"
install_xcframework "${PODS_ROOT}/mobile-ffmpeg-full/wavpack.xcframework" "wavpack" "framework" "ios-arm64" "ios-x86_64-maccatalyst" "ios-x86_64-simulator"

