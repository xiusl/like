//
//  StatusApiRequest.swift
//  Like
//
//  Created by xiusl on 2019/10/15.
//  Copyright © 2019 likeeee. All rights reserved.
//

import UIKit

enum StatusApiRequest {
    case postStatus(content: String, images: Array<[String: Any]>)
    case getStatuses(page: Int, count: Int)
    case likeStatus(id: String)
    case unlikeStatus(id: String)
    case likeAction(id: String, like: Bool)
    case getUserStatuses(userid: String, page: Int, count: Int)
    case defaultReq(Void)
}

extension StatusApiRequest: ApiRequest {
    var type: RequestType {
        switch self {
        case .postStatus(_, _):
            return .bodyPost
        case .getStatuses(_, _):
            return .get
        case .likeStatus(_):
            return .bodyPost
        case .unlikeStatus(_):
            return .delete
        case .likeAction(_, let like):
            return (like ? .bodyPost : .delete)
        default:
            return .get
        }
    }
    
    var baseUrl: String {
        return ApiManager.baseUrl
    }
    
    var path: String {
        switch self {
        case .postStatus(_, _):
            return "statuses"
        case .getStatuses(_, _):
            return "statuses"
        case .likeStatus(let id):
            return "statuses/"+id+"/likes"
        case .unlikeStatus(let id):
            return "statuses/"+id+"/likes"
        case .likeAction(let id, _):
            return "statuses/"+id+"/likes"
        case .getUserStatuses(let userid, _, _):
            return "users/\(userid)/statuses"
        default:
            return ""
        }
    }
    
    var params: Any {
        switch self {
        case .postStatus(let content, let images):
            return ["content": content, "images": images]
        case .getStatuses(let page, let count):
            return ["page": page, "count": count]
        case .getUserStatuses(_, let page, let count):
            return ["page": page, "count": count]
        default:
            return [:]
        }
    }
    
    var headers: [String : String] {
        switch self {
        default:
            return [:]
        }
    }
    
    var isShowHUD: Bool {
        return false
    }
    
    
}
