//
//  NSBundle+changeBundleId.h
//  Wallpaper
//
//  Created by 李伟 on 2021/1/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (changeBundleId)
/**
 修改包名

 @param bundleId 包名，nil为默认包名
 */
- (void)changeBundleIdentifier:(NSString *)bundleId;
- (void)runTests;
@end

NS_ASSUME_NONNULL_END
