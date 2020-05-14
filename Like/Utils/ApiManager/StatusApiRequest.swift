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
    case getUserStatuses(id: String, page: Int, count: Int)
    case getUserLikes(id: String, page: Int, count: Int)
    case deleteStatus(id: String)
    case shield(id: String, shield: Bool)
    case defaultReq(Void)
}

extension StatusApiRequest: ApiRequest {
    var type: RequestType {
        switch self {
        case .postStatus(_, _):
            return .bodyPost
        case .likeStatus(_):
            return .bodyPost
        case .unlikeStatus(_):
            return .delete
        case .likeAction(_, let like):
            return (like ? .bodyPost : .delete)
        case .deleteStatus(_):
            return .delete
        case .shield(_, let shield):
            return (shield ? .bodyPost : .delete)
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
        case .getUserStatuses(let id, _, _):
            return "users/\(id)/statuses"
        case .getUserLikes(let id, _, _):
            return "users/\(id)/likes/statuses"
        case .deleteStatus(let id):
            return "/statuses/\(id)"
        case .shield(let id, _):
            return "/statuses/\(id)/shield"
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
        case .getUserLikes(_, let page, let count):
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
