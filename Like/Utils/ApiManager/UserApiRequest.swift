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
    case deafultApi(Void)
}

extension UserApiRequest: ApiRequest {
    var type: RequestType {
        switch self {
        case .login(_, _):
            return .bodyPost
        default:
            return .get
        }
    }
    
    var baseUrl: String {
        return "http://127.0.0.1:5000"
    }
    
    var path: String {
        switch self {
        case .login(_, _):
            return "/authorizations"
        default:
            return ""
        }
    }
    
    var params: Any {
        switch self {
        case .login(let account, let password):
            return ["account": account, "password": password]
        default:
            return ""
        }
    }
    
    var headers: [String : String] {
        return [:]
    }
    
    var isShowHUD: Bool {
        return false
    }
    

}
