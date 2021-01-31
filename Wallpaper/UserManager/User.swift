//
//  User.swift
//  Wallpaper
//
//  Created by 李伟 on 2021/1/25.
//

import Foundation
import KakaJSON
public class loginResponse: NSObject, Convertible {
    required public override init () {
        
    }
    var code: String?
    var msg: String?
    var time: String?
    var data: Dictionary<String, User>?
}
public final class User: NSObject, NSCoding, Convertible {
    public override init () {
        
    }
    
    public init?(coder: NSCoder) {
        self.id = coder.decodeObject(forKey: SerializationKeys.id) as? Int
        self.username = coder.decodeObject(forKey: SerializationKeys.username) as? String
        self.nickname = coder.decodeObject(forKey: SerializationKeys.nickname) as? String
        self.mobile = coder.decodeObject(forKey: SerializationKeys.mobile) as? String
        self.avatar = coder.decodeObject(forKey: SerializationKeys.avatar) as? String
        self.score = coder.decodeObject(forKey: SerializationKeys.score) as? Int
        self.token = coder.decodeObject(forKey: SerializationKeys.token) as? String
        self.user_id = coder.decodeObject(forKey: SerializationKeys.id) as? Int
        self.createtime = coder.decodeObject(forKey: SerializationKeys.createtime) as? String
        self.expiretime = coder.decodeObject(forKey: SerializationKeys.expiretime) as? String
        self.expires_in = coder.decodeObject(forKey: SerializationKeys.expires_in) as? String
    }
    
    private struct SerializationKeys {
      static let id = "id"
      static let username = "username"
      static let nickname = "nickname"
      static let mobile = "mobile"
      static let avatar = "avatar"
      static let score = "score"
      static let token = "token"
      static let user_id = "user_id"
      static let createtime = "createtime"
      static let expiretime = "expiretime"
      static let expires_in = "expires_in"
    }
    
    public var id: Int?
    public var username: String?
    public var nickname: String?
    public var mobile: String?
    public var avatar: String?
    public var score: Int?
    public var token: String?
    public var user_id: Int?
    public var createtime: String?
    public var expiretime: String?
    public var expires_in: String?
    
    convenience init(_ dictionary: Dictionary<String, AnyObject>) {
        self.init()
        id = dictionary[SerializationKeys.id] as? Int
        username = dictionary[SerializationKeys.username] as? String
        nickname = dictionary[SerializationKeys.nickname] as? String
        mobile = dictionary[SerializationKeys.mobile] as? String
        avatar = dictionary[SerializationKeys.avatar] as? String
        score = dictionary[SerializationKeys.score] as? Int
        token = dictionary[SerializationKeys.token] as? String
        user_id = dictionary[SerializationKeys.user_id] as? Int
        createtime = dictionary[SerializationKeys.createtime] as? String
        expiretime = dictionary[SerializationKeys.expiretime] as? String
        expires_in = dictionary[SerializationKeys.expires_in] as? String
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(id, forKey: SerializationKeys.id)
        coder.encode(username, forKey: SerializationKeys.username)
        coder.encode(nickname, forKey: SerializationKeys.nickname)
        coder.encode(mobile, forKey: SerializationKeys.mobile)
        coder.encode(avatar, forKey: SerializationKeys.avatar)
        coder.encode(score, forKey: SerializationKeys.score)
        coder.encode(token, forKey: SerializationKeys.token)
        coder.encode(user_id, forKey: SerializationKeys.user_id)
        coder.encode(createtime, forKey: SerializationKeys.createtime)
        coder.encode(expiretime, forKey: SerializationKeys.expiretime)
        coder.encode(expires_in, forKey: SerializationKeys.expires_in)
    }
    
    
}
