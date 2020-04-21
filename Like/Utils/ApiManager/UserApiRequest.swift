//
//  UserApiRequest.swift
//  Like
//
//  Created by xiusl on 2019/10/12.
//  Copyright © 2019 likeeee. All rights reserved.
//

import UIKit

enum UserApiRequest {
    case login(account: String, password: String)
    case getVerifyCode(key: String)
    case resgiterOrLogin(phone: String, code: String)
    case getUser(id: String)
    case followUser(id: String, followed: Bool)
    case editUser(id: String, avatar: String, name: String)
    case deafultApi(Void)
}

extension UserApiRequest: ApiRequest {
    var type: RequestType {
        switch self {
        case .login(_, _):
            return .bodyPost
        case .resgiterOrLogin(_, _):
            return .bodyPost
        case .followUser(_, let followed):
            return followed ? .bodyPost : .delete
        case .editUser(_, _, _):
            return .bodyPost
        default:
            return .get
        }
    }
    
    var baseUrl: String {
//        return "http://127.0.0.1:5000/"
        return ApiManager.baseUrl
    }
    
    var path: String {
        switch self {
        case .login(_, _):
            return "authorizations"
        case .getVerifyCode(_):
            return "verifycodes"
        case .resgiterOrLogin(_, _):
            return "authorizations"
        case .getUser(let id):
            return "users/"+id
        case .followUser(let id, _):
            return "users/\(id)/followers"
        case .editUser(let id, _, _):
            return "users/"+id
        default:
            return ""
        }
    }
    
    var params: Any {
        switch self {
        case .login(let account, let password):
            return ["account": account, "password": password]
        case .getVerifyCode(let key):
            return ["key": key, "invitecode": ""]
        case .resgiterOrLogin(let phone, let code):
            return ["phone": phone, "code": code]
        case .editUser(_, let avatar, let name):
            return ["avatar": avatar, "name": name]
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
