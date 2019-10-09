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
    case defaultOne(Void)
}

extension ArtApiRequest: ApiRequest {
    var type: RequestType {
        switch self {
        case .getArticles():
            return .get
        default:
            return .get
        }
    }
    
    var baseUrl: String {
        return "http://api.ins.com/"
    }
    
    var path: String {
        switch self {
        case .getArticles():
            return "articles"
        default:
            return ""
        }
    }
    
    var params: Any {
        switch self {
        case .getArticles():
            return "articles"
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
