//
//  RootClass.swift
//  Model Generated using http://www.jsoncafe.com/
//  Created on April 14, 2020

import Foundation
import SwiftyJSON


class Status : NSObject, NSCoding{

    var buryCount : Int!
    var content : String!
    var createdAt : String!
    var id : String!
    var images : [Image]!
    var isLiked : Bool!
    var likeCount : Int!
    var status : Int!
    var updatedAt : String!
    var user : User!

    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        buryCount = json["bury_count"].intValue
        content = json["content"].stringValue
        createdAt = json["created_at"].stringValue
        id = json["id"].stringValue
        images = [Image]()
        let imagesArray = json["images"].arrayValue
        for imagesJson in imagesArray{
            let value = Image(fromJson: imagesJson)
            images.append(value)
        }
        isLiked = json["is_liked"].boolValue
        likeCount = json["like_count"].intValue
        status = json["status"].intValue
        updatedAt = json["updated_at"].stringValue
        let userJson = json["user"]
        if !userJson.isEmpty{
            user = User(fromJson: userJson)
        }
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if buryCount != nil{
            dictionary["bury_count"] = buryCount
        }
        if content != nil{
            dictionary["content"] = content
        }
        if createdAt != nil{
            dictionary["created_at"] = createdAt
        }
        if id != nil{
            dictionary["id"] = id
        }
        if images != nil{
        var dictionaryElements = [[String:Any]]()
        for imagesElement in images {
            dictionaryElements.append(imagesElement.toDictionary())
        }
        dictionary["images"] = dictionaryElements
        }
        if isLiked != nil{
            dictionary["is_liked"] = isLiked
        }
        if likeCount != nil{
            dictionary["like_count"] = likeCount
        }
        if status != nil{
            dictionary["status"] = status
        }
        if updatedAt != nil{
            dictionary["updated_at"] = updatedAt
        }
        if user != nil{
            dictionary["user"] = user.toDictionary()
        }
        return dictionary
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
        buryCount = aDecoder.decodeObject(forKey: "bury_count") as? Int
        content = aDecoder.decodeObject(forKey: "content") as? String
        createdAt = aDecoder.decodeObject(forKey: "created_at") as? String
        id = aDecoder.decodeObject(forKey: "id") as? String
        images = aDecoder.decodeObject(forKey: "images") as? [Image]
        isLiked = aDecoder.decodeObject(forKey: "is_liked") as? Bool
        likeCount = aDecoder.decodeObject(forKey: "like_count") as? Int
        status = aDecoder.decodeObject(forKey: "status") as? Int
        updatedAt = aDecoder.decodeObject(forKey: "updated_at") as? String
        user = aDecoder.decodeObject(forKey: "user") as? User
    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
    {
        if buryCount != nil{
            aCoder.encode(buryCount, forKey: "bury_count")
        }
        if content != nil{
            aCoder.encode(content, forKey: "content")
        }
        if createdAt != nil{
            aCoder.encode(createdAt, forKey: "created_at")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if images != nil{
            aCoder.encode(images, forKey: "images")
        }
        if isLiked != nil{
            aCoder.encode(isLiked, forKey: "is_liked")
        }
        if likeCount != nil{
            aCoder.encode(likeCount, forKey: "like_count")
        }
        if status != nil{
            aCoder.encode(status, forKey: "status")
        }
        if updatedAt != nil{
            aCoder.encode(updatedAt, forKey: "updated_at")
        }
        if user != nil{
            aCoder.encode(user, forKey: "user")
        }

    }

}


class Image : NSObject, NSCoding{

    var height : Int!
    var url : String!
    var width : Int!

    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        height = json["height"].intValue
        url = json["url"].stringValue
        width = json["width"].intValue
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if height != nil{
            dictionary["height"] = height
        }
        if url != nil{
            dictionary["url"] = url
        }
        if width != nil{
            dictionary["width"] = width
        }
        return dictionary
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
        height = aDecoder.decodeObject(forKey: "height") as? Int
        url = aDecoder.decodeObject(forKey: "url") as? String
        width = aDecoder.decodeObject(forKey: "width") as? Int
    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
    {
        if height != nil{
            aCoder.encode(height, forKey: "height")
        }
        if url != nil{
            aCoder.encode(url, forKey: "url")
        }
        if width != nil{
            aCoder.encode(width, forKey: "width")
        }

    }

}
