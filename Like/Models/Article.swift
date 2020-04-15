//
//  Article.swift
//  Model Generated using http://www.jsoncafe.com/
//  Created on April 15, 2020

import Foundation
import SwiftyJSON


class Article : NSObject, NSCoding{

    var author : String!
    var authorIdf : String!
    var createdAt : String!
    var id : String!
    var images : [String]!
    var isSpider : Int!
    var originalId : String!
    var originalUrl : String!
    var publishedAt : String!
    var source : String!
    var status : Int!
    var title : String!
    var type : String!
    var url : String!
    var user : User!

    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        author = json["author"].stringValue
        authorIdf = json["author_idf"].stringValue
        createdAt = json["created_at"].stringValue
        id = json["id"].stringValue
        images = [String]()
        let imagesArray = json["images"].arrayValue
        for imagesJson in imagesArray{
            images.append(imagesJson.stringValue)
        }
        isSpider = json["is_spider"].intValue
        originalId = json["original_id"].stringValue
        originalUrl = json["original_url"].stringValue
        publishedAt = json["published_at"].stringValue
        source = json["source"].stringValue
        status = json["status"].intValue
        title = json["title"].stringValue
        type = json["type"].stringValue
        url = json["url"].stringValue
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
        if author != nil{
            dictionary["author"] = author
        }
        if authorIdf != nil{
            dictionary["author_idf"] = authorIdf
        }
        if createdAt != nil{
            dictionary["created_at"] = createdAt
        }
        if id != nil{
            dictionary["id"] = id
        }
        if images != nil{
            dictionary["images"] = images
        }
        if isSpider != nil{
            dictionary["is_spider"] = isSpider
        }
        if originalId != nil{
            dictionary["original_id"] = originalId
        }
        if originalUrl != nil{
            dictionary["original_url"] = originalUrl
        }
        if publishedAt != nil{
            dictionary["published_at"] = publishedAt
        }
        if source != nil{
            dictionary["source"] = source
        }
        if status != nil{
            dictionary["status"] = status
        }
        if title != nil{
            dictionary["title"] = title
        }
        if type != nil{
            dictionary["type"] = type
        }
        if url != nil{
            dictionary["url"] = url
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
        author = aDecoder.decodeObject(forKey: "author") as? String
        authorIdf = aDecoder.decodeObject(forKey: "author_idf") as? String
        createdAt = aDecoder.decodeObject(forKey: "created_at") as? String
        id = aDecoder.decodeObject(forKey: "id") as? String
        images = aDecoder.decodeObject(forKey: "images") as? [String]
        isSpider = aDecoder.decodeObject(forKey: "is_spider") as? Int
        originalId = aDecoder.decodeObject(forKey: "original_id") as? String
        originalUrl = aDecoder.decodeObject(forKey: "original_url") as? String
        publishedAt = aDecoder.decodeObject(forKey: "published_at") as? String
        source = aDecoder.decodeObject(forKey: "source") as? String
        status = aDecoder.decodeObject(forKey: "status") as? Int
        title = aDecoder.decodeObject(forKey: "title") as? String
        type = aDecoder.decodeObject(forKey: "type") as? String
        url = aDecoder.decodeObject(forKey: "url") as? String
        user = aDecoder.decodeObject(forKey: "user") as? User
    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
    {
        if author != nil{
            aCoder.encode(author, forKey: "author")
        }
        if authorIdf != nil{
            aCoder.encode(authorIdf, forKey: "author_idf")
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
        if isSpider != nil{
            aCoder.encode(isSpider, forKey: "is_spider")
        }
        if originalId != nil{
            aCoder.encode(originalId, forKey: "original_id")
        }
        if originalUrl != nil{
            aCoder.encode(originalUrl, forKey: "original_url")
        }
        if publishedAt != nil{
            aCoder.encode(publishedAt, forKey: "published_at")
        }
        if source != nil{
            aCoder.encode(source, forKey: "source")
        }
        if status != nil{
            aCoder.encode(status, forKey: "status")
        }
        if title != nil{
            aCoder.encode(title, forKey: "title")
        }
        if type != nil{
            aCoder.encode(type, forKey: "type")
        }
        if url != nil{
            aCoder.encode(url, forKey: "url")
        }
        if user != nil{
            aCoder.encode(user, forKey: "user")
        }

    }

}

