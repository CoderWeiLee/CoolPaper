//
//  User.swift
//  Wallpaper
//
//  Created by 李伟 on 2021/1/25.
//

import Foundation
public final class User: NSObject, NSCoding {
    override init () {
        
    }
    
    public init?(coder: NSCoder) {
        self.email = coder.decodeObject(forKey: SerializationKeys.email) as? String
        self.id = coder.decodeObject(forKey: SerializationKeys.id) as? Int
        self.lastName = coder.decodeObject(forKey: SerializationKeys.lastName) as? String
        
        self.userName = coder.decodeObject(forKey: SerializationKeys.userName) as? String
        self.firstName = coder.decodeObject(forKey: SerializationKeys.firstName) as? String
    }
    
    private struct SerializationKeys {
      static let email = "email"
      static let id = "id"
      static let lastName = "lastName"
      static let userName = "userName"
      static let firstName = "firstName"
    }
    
    public var email: String?
    public var id: Int?
    public var lastName: String?
    public var userName: String?
    public var firstName: String?
    
    convenience init(_ dictionary: Dictionary<String, AnyObject>) {
        self.init()
        email = dictionary[SerializationKeys.email] as? String
        id = dictionary[SerializationKeys.id] as? Int
        lastName = dictionary[SerializationKeys.lastName] as? String
        firstName = dictionary[SerializationKeys.firstName] as? String
        userName = dictionary[SerializationKeys.userName] as? String
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(email, forKey: SerializationKeys.email)
        coder.encode(id, forKey: SerializationKeys.id)
        coder.encode(lastName, forKey: SerializationKeys.lastName)
        coder.encode(userName, forKey: SerializationKeys.userName)
        coder.encode(firstName, forKey: SerializationKeys.firstName)
    }
    
    
}
