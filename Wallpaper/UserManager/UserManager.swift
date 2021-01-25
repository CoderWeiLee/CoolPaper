//
//  UserManager.swift
//  Wallpaper
//
//  Created by 李伟 on 2021/1/25.
//  用户管理类

import Foundation
class UserManager {
//    static let shared = UserManager()
//    private init() {}
    static let kUserType: String = "user"
    
    static let UserManagerUserToken: String = "UserManagerUserToken"
    
    static var _currentUser: User?
    static var _token: String?
    class public var token:String {
        get {
            return UserDefaults.standard.string(forKey: UserManager.UserManagerUserToken)!
        }
        set {
            UserManager._token = newValue
        }
    }
    
    class public var currentUser: User? {
        set {
            UserManager._currentUser = newValue
        }
        get {
            if (_currentUser != nil) {
                return _currentUser!
            }
            let dataCurentUser: NSData! = NSData(contentsOfFile: UserManager.pathWithObjectType(objectType: UserManager.kUserType))
            if (dataCurentUser != nil) {
                _currentUser = try? NSKeyedUnarchiver.unarchivedObject(ofClasses: [User.self], from: dataCurentUser as Data) as? User
                return _currentUser!
            }
            
            
            return nil
        }
    }
    
    class public func setCurrentUser(newCurrentUser: User?) {
        assert(newCurrentUser != nil, "Trying to set current user to nil! Use [UserManager logOutCurrentUser] instead!")
        _currentUser = newCurrentUser
        UserManager.saveCurrentUser()
    }
    
    class internal func saveCurrentUser() {
        if _currentUser == nil {
            assert(_currentUser != nil, "Error! Save current user: currentUser == nil!!")
            return
        }
        let path: String = UserManager.pathWithObjectType(objectType: UserManager.kUserType)
        let filemgr : FileManager = FileManager.default
        
        print ("PATH : \n%@", path)
        do {
            if filemgr.fileExists(atPath: path) {
                try filemgr.removeItem(atPath: path as String)
                print("Deleting previous user entry")
            }
        }
        catch {
            print ("Failed to Delete logged user")
        }
        
        let userData: Data? = try? NSKeyedArchiver.archivedData(withRootObject: _currentUser!, requiringSecureCoding: true) as Data
        
        do{
            try userData?.write(to: URL(fileURLWithPath: path), options: .atomic)
        }catch _ {
            debugPrint("Failed to write")
        }
    }
    
    class public func logOutCurrentUser() {
        let path:String = UserManager.pathWithObjectType(objectType: UserManager.kUserType)
        do {
            try FileManager.default.removeItem(atPath: path)
            if FileManager.default.fileExists(atPath: path) {
                print("Deleting previous user entry")
            }
        }
        catch {
            print("Failed to Delete user File")
        }
        _currentUser = nil
    }
    
    class public func logOutUserAndClearToken() {
        UserManager.logOutCurrentUser()
        UserManager.setCurrentUser(newCurrentUser: nil)
        UserManager.setToken(token: "")
    }
    
    class func isLogin() -> Bool {
        return _currentUser != nil && (_token?.count)!>0
    }
    
   class func setToken(token: String) {
        _token = token
    if _token != nil {
        UserDefaults.standard.setValue(_token, forKey: UserManagerUserToken)
    }else {
        UserDefaults.standard.removeObject(forKey: UserManagerUserToken)
    }
        UserDefaults.standard.synchronize()
   }
    
    class internal func pathWithObjectType(objectType: String) -> String {
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        let finalDatabaseURL = documentsDirectory?.appendingPathComponent("\(objectType).bin")
        return finalDatabaseURL!
    }
}


extension String {
    func appendingPathComponent(_ str: String) -> String {
        return (self as NSString).appendingPathComponent(str)
    }
}
