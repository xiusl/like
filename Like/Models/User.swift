//
//  RootClass.swift
//  Model Generated using http://www.jsoncafe.com/
//  Created on October 14, 2019

import Foundation
import SwiftyJSON


class User : NSObject, NSCoding{

    var avatar : String!
    var createdAt : String!
    var desc : String!
    var email : String!
    var followedCount : Int!
    var followingCount : Int!
    var id : String!
    var isFollowed : Bool!
    var isFollowing : Bool!
    var level : Int!
    var name : String!
    var phone : String!
    var status : Int!
    var type : Int!
    var token : String!

    var isCurrnet: Bool {
        get {
            return User.current?.id == self.id
        }
    }
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        avatar = json["avatar"].stringValue
        createdAt = json["created_at"].stringValue
        desc = json["desc"].stringValue
        email = json["email"].stringValue
        followedCount = json["followed_count"].intValue
        followingCount = json["following_count"].intValue
        id = json["id"].stringValue
        isFollowed = json["is_followed"].boolValue
        isFollowing = json["is_following"].boolValue
        level = json["level"].intValue
        name = json["name"].stringValue
        phone = json["phone"].stringValue
        status = json["status"].intValue
        type = json["type"].intValue
        token = json["token"].stringValue
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if avatar != nil{
            dictionary["avatar"] = avatar
        }
        if createdAt != nil{
            dictionary["created_at"] = createdAt
        }
        if desc != nil{
            dictionary["desc"] = desc
        }
        if email != nil{
            dictionary["email"] = email
        }
        if followedCount != nil{
            dictionary["followed_count"] = followedCount
        }
        if followingCount != nil{
            dictionary["following_count"] = followingCount
        }
        if id != nil{
            dictionary["id"] = id
        }
        if isFollowed != nil{
            dictionary["is_followed"] = isFollowed
        }
        if isFollowing != nil{
            dictionary["is_following"] = isFollowing
        }
        if level != nil{
            dictionary["level"] = level
        }
        if name != nil{
            dictionary["name"] = name
        }
        if phone != nil{
            dictionary["phone"] = phone
        }
        if status != nil{
            dictionary["status"] = status
        }
        if type != nil{
            dictionary["type"] = type
        }
        if token != nil{
            dictionary["token"] = token
        }
        return dictionary
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
        avatar = aDecoder.decodeObject(forKey: "avatar") as? String
        createdAt = aDecoder.decodeObject(forKey: "created_at") as? String
        desc = aDecoder.decodeObject(forKey: "desc") as? String
        email = aDecoder.decodeObject(forKey: "email") as? String
        followedCount = aDecoder.decodeObject(forKey: "followed_count") as? Int
        followingCount = aDecoder.decodeObject(forKey: "following_count") as? Int
        id = aDecoder.decodeObject(forKey: "id") as? String
        isFollowed = aDecoder.decodeObject(forKey: "is_followed") as? Bool
        isFollowing = aDecoder.decodeObject(forKey: "is_following") as? Bool
        level = aDecoder.decodeObject(forKey: "level") as? Int
        name = aDecoder.decodeObject(forKey: "name") as? String
        phone = aDecoder.decodeObject(forKey: "phone") as? String
        status = aDecoder.decodeObject(forKey: "status") as? Int
        type = aDecoder.decodeObject(forKey: "type") as? Int
        token = aDecoder.decodeObject(forKey: "token") as? String
    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
    {
        if avatar != nil{
            aCoder.encode(avatar, forKey: "avatar")
        }
        if createdAt != nil{
            aCoder.encode(createdAt, forKey: "created_at")
        }
        if desc != nil{
            aCoder.encode(desc, forKey: "desc")
        }
        if email != nil{
            aCoder.encode(email, forKey: "email")
        }
        if followedCount != nil{
            aCoder.encode(followedCount, forKey: "followed_count")
        }
        if followingCount != nil{
            aCoder.encode(followingCount, forKey: "following_count")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if isFollowed != nil{
            aCoder.encode(isFollowed, forKey: "is_followed")
        }
        if isFollowing != nil{
            aCoder.encode(isFollowing, forKey: "is_following")
        }
        if level != nil{
            aCoder.encode(level, forKey: "level")
        }
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
        if phone != nil{
            aCoder.encode(phone, forKey: "phone")
        }
        if status != nil{
            aCoder.encode(status, forKey: "status")
        }
        if type != nil{
            aCoder.encode(type, forKey: "type")
        }
        if token != nil{
            aCoder.encode(token, forKey: "token")
        }
    }

    @discardableResult
    func save() -> Bool {
        User._user = self
        var filePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
        filePath.append("/account.d")
        return NSKeyedArchiver.archiveRootObject(self, toFile: filePath)
    }
    
    class func read() -> User? {
        var filePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
        filePath.append("/account.d")
        let user = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? User
        _user = user
        return user
    }
    
    class func delete() {
        _user = nil
        var filePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
        filePath.append("/account.d")
        let file = FileManager.default
        if file.fileExists(atPath: filePath) {
            do {
                try file.removeItem(atPath: filePath)
            } catch {
                debugPrint(error)
            }
        }
    }
    
    private static var _user: User?
    
    open class var `current`: User? {
        return _user
    }
    
    
    open class var isLogin: Bool {
        return _user != nil
    }
}
