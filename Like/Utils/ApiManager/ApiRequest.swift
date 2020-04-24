//
//  ApiRequest.swift
//  XiaoQinTong
//
//  Created by xiusl on 2019/9/17.
//  Copyright © 2019 yueyilan. All rights reserved.
//

import UIKit
import Alamofire

public enum RequestType: Int {
    case get = 0
    case post = 1
    case bodyPost = 2
    case uploadImage = 5
    case delete = 3
    case put = 4
}

protocol ApiRequest {
    var type: RequestType {get}
    
    var baseUrl: String { get }
    
    var path: String { get }
    
    var params: Any {get}
    
    var headers: [String: String] {get}
    
    var isShowHUD: Bool {get}
}


enum ArtApiRequest {
    case getArticles(Void)
    case spiderArticle(url: String)
    case defaultOne(Void)
}

extension ArtApiRequest: ApiRequest {
    var type: RequestType {
        switch self {
        case .getArticles():
            return .get
        case .spiderArticle(_):
            return .bodyPost
        default:
            return .get
        }
    }
    
    var baseUrl: String {
        return ApiManager.baseUrl
    }
    
    var path: String {
        switch self {
        case .getArticles():
            return "articles"
        case .spiderArticle(_):
            return "articles/spider"
        default:
            return ""
        }
    }
    
    var params: Any {
        switch self {
        case .getArticles():
            return "articles"
        case .spiderArticle(let url):
            return ["url": url]
        default:
            return []
        }
    }
    
    var headers: [String : String] {
        switch self {
        case .getArticles():
            return [:]
        default:
            return [:]
        }
    }
    
    var isShowHUD: Bool {
        return false
    }
    
}



enum AppApiRequest {
    case createFeedback(conetnt: String, contact: String)
    case getFeedbacks(userId: String, page: Int, count: Int)
    case getAllFeedbacks(page: Int, count: Int)
    case deafultApi(Void)
}

extension AppApiRequest: ApiRequest {
    var type: RequestType {
        switch self {
        case .createFeedback(_, _):
            return .bodyPost
        default:
            return .get
        }
    }
    
    var baseUrl: String {
        return ApiManager.baseUrl
    }
    
    var path: String {
        switch self {
        case .createFeedback(_, _):
            return "/feedbacks"
        case .getFeedbacks(let userId, _, _):
            return "/users/\(userId)/feedbacks"
        case .getAllFeedbacks(_, _):
            return "/feedbacks"
        default:
            return ""
        }
    }
    
    var params: Any {
        switch self {
        case .createFeedback(let content, let contact):
            return ["content": content, "contact": contact]
        case .getFeedbacks(_, let page, let count):
            return ["page": page, "count": count]
        case .getAllFeedbacks(let page, let count):
            return ["page": page, "count": count]
        default:
            return []
        }
    }
    
    var headers: [String : String] {
        return [:]
    }
    
    var isShowHUD: Bool {
        return false
    }

}
