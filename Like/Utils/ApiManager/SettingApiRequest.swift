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
        return "http://127.0.0.1:5000/"
//        return "https://ins-api.sleen.top/"
    }
    
    var path: String {
        switch self {
        case .ping():
            return "setting/ping"
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
