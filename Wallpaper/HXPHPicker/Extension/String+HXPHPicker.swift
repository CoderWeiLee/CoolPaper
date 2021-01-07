//
//  String+HXPHPicker.swift
//  HXPHPickerExample
//
//  Created by Silence on 2020/11/13.
//  Copyright © 2020 Silence. All rights reserved.
//

import UIKit
import CommonCrypto

public extension String {
    
    var localized: String {
        get {
            return Bundle.localizedString(for: self)
        }
    }
    
    var color: UIColor {
        get {
            return UIColor.init(hexString: self)
        }
    }
    
    var image: UIImage? {
        get {
            return UIImage.image(for: self)
        }
    }
    static func fileName(suffix: String) -> String {
        var uuid = UUID().uuidString
        uuid = uuid.replacingOccurrences(of: "-", with: "").lowercased()
        var fileName = uuid
        let nowDate = Date().timeIntervalSince1970
        
        fileName.append(String(format: "%d", arguments: [nowDate]))
        fileName.append(String(format: "%d", arguments: [arc4random()%10000]))
        return fileName.md5() + "." + suffix
    }
    private func md5() -> String {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        free(result)
        return String(format: hash as String)
    }
    func width(ofFont font: UIFont, maxHeight: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: CGFloat(MAXFLOAT), height: maxHeight)
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.size.width
    }
    
    func width(ofSize size: CGFloat, maxHeight: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: CGFloat(MAXFLOAT), height: maxHeight)
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: size)], context: nil)
        return boundingBox.size.width
    }
    
    func height(ofFont font: UIFont, maxWidth: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: maxWidth, height: CGFloat(MAXFLOAT))
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.size.height
    }
    
    func height(ofSize size: CGFloat, maxWidth: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: maxWidth, height: CGFloat(MAXFLOAT))
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: size)], context: nil)
        return boundingBox.size.height
    }
}
