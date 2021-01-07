//
//  Bundle+HXPhotoPicker.swift
//  HXPHPickerExample
//
//  Created by Silence on 2020/11/15.
//  Copyright © 2020 Silence. All rights reserved.
//

import UIKit

public extension Bundle {
    
    class func localizedString(for key: String) -> String {
        return localizedString(for: key, value: nil)
    }
    
    class func localizedString(for key: String, value: String?) -> String {
        let bundle = HXPHManager.shared.languageBundle
        var newValue = bundle?.localizedString(forKey: key, value: value, table: nil)
        if newValue == nil {
            newValue = key
        }
        return newValue!
    }
}
