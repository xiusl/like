//
//  Feedback.swift
//  Model Generated using http://www.jsoncafe.com/
//  Created on April 24, 2020

import Foundation
import SwiftyJSON


class Feedback : NSObject, NSCoding{

    var contact : String!
    var content : String!
    var createdAt : String!
    var id : String!
    var replay : String!
    var status : Int!
    var user : User!

    
    var displayTime: String = ""
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        contact = json["contact"].stringValue
        content = json["content"].stringValue
        createdAt = json["created_at"].stringValue
        id = json["id"].stringValue
        replay = json["replay"].stringValue
        status = json["status"].intValue
        let userJson = json["user"]
        if !userJson.isEmpty{
            user = User(fromJson: userJson)
        }
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        
        let dateFormat1 = DateFormatter()
        dateFormat1.dateFormat = "yyyy-MM-dd HH:mm"
        
        guard let date = dateFormat.date(from: createdAt) else {
            return
        }
        displayTime = dateFormat1.string(from: date)
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if contact != nil{
            dictionary["contact"] = contact
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
        if replay != nil{
            dictionary["replay"] = replay
        }
        if status != nil{
            dictionary["status"] = status
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
        contact = aDecoder.decodeObject(forKey: "contact") as? String
        content = aDecoder.decodeObject(forKey: "content") as? String
        createdAt = aDecoder.decodeObject(forKey: "created_at") as? String
        id = aDecoder.decodeObject(forKey: "id") as? String
        replay = aDecoder.decodeObject(forKey: "replay") as? String
        status = aDecoder.decodeObject(forKey: "status") as? Int
        user = aDecoder.decodeObject(forKey: "user") as? User
    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
    {
        if contact != nil{
            aCoder.encode(contact, forKey: "contact")
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
        if replay != nil{
            aCoder.encode(replay, forKey: "replay")
        }
        if status != nil{
            aCoder.encode(status, forKey: "status")
        }
        if user != nil{
            aCoder.encode(user, forKey: "user")
        }

    }

}
