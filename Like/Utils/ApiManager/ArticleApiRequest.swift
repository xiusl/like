//
//  ArticleApiRequest.swift
//  Like
//
//  Created by tmt on 2020/4/14.
//  Copyright © 2020 likeeee. All rights reserved.
//

import UIKit

enum ArticleApiRequest {
    case getArticles(page: Int, count: Int)
    case getUserArticles(id: String, page: Int, count: Int)
    case deafultApi(Void)
}

extension ArticleApiRequest: ApiRequest {
    var type: RequestType {
        switch self {
        case .getArticles(_, _):
            return .get
        default:
            return .get
        }
    }
    
    var baseUrl: String {
        return ApiManager.baseUrl
    }
    
    var path: String {
        switch self {
        case .getArticles(_, _):
            return "articles"
        case .getUserArticles(let id, _, _):
            return "users/\(id)/articles"
        default:
            return ""
        }
    }
    
    var params: Any {
        switch self {
        case .getArticles(let page, let count):
            return ["page": page, "count": count]
        case .getUserArticles(_, let page, let count):
            return ["page": page, "count": count]
        default:
            return [:]
        }
    }
    
    var headers: [String : String] {
        return [:]
    }
    
    var isShowHUD: Bool {
        return false
    }
    

}
