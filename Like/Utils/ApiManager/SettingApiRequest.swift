//
//  SettingApiRequest.swift
//  Like
//
//  Created by xiusl on 2019/10/16.
//  Copyright © 2019 likeeee. All rights reserved.
//

import UIKit

enum SettingApiRequest {
    case ping(Void)
    case qiniuToken(Void)
    case deafultApi(Void)
}

extension SettingApiRequest: ApiRequest {
    var type: RequestType {
        switch self {
        default:
            return .get
        }
    }
    
    var baseUrl: String {
        return ApiManager.baseUrl
    }
    
    var path: String {
        switch self {
        case .ping():
            return "setting/ping"
        case .qiniuToken():
            return "qiniu/token"
        default:
            return ""
        }
    }
    
    var params: Any {
        switch self {
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
