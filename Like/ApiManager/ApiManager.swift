//
//  ApiManager.swift
//  XiaoQinTong
//
//  Created by xiusl on 2019/9/17.
//  Copyright © 2019 yueyilan. All rights reserved.
//

import UIKit
import Alamofire

typealias RequestSuccessBlock = (_ result: [String: Any]) -> Void
typealias RequestFailedBlock = (_ error: String) -> Void
typealias RequestProgressBlock = (Double) -> Void

public enum Method: String {
    case GET, POST, PUT, DELETE, PATCH
}

class ApiManager: NSObject {
    static let shared = ApiManager()
    
    private override init() {
        
    }
    
    private lazy var manager: Session = {
        let config: URLSessionConfiguration = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        
        let delegate: SessionDelegate = SessionDelegate()
        return Session(startRequestsImmediately: true, configuration: config, delegate: delegate, rootQueue: DispatchQueue.main, requestQueue: nil, serializationQueue: nil, adapter: nil, serverTrustManager: nil, retrier: nil, eventMonitors: [])
    }()
    
    public func request(request: ApiRequest, success: @escaping RequestSuccessBlock, failed: @escaping RequestFailedBlock) {
        let url = request.baseUrl + request.path
        switch request.type {
        case .get:
            self.GET(url: url, params: request.params as? Parameters, headers: request.headers, encoding: URLEncoding.queryString, success: success, failed: failed)
            break
        
        default:
            break
        }

    }
}


extension ApiManager {
    fileprivate func GET(url: String,
                         params: Parameters?,
                         headers: [String: String]?,
                         encoding: URLEncoding,
                         success: @escaping RequestSuccessBlock,
                         failed: @escaping RequestFailedBlock) {
//        self.manager.request(url, method: .get, parameters: params, encoder: encoding, headers: nil)
        self.manager.request(url, method: .get, parameters: params, encoding: encoding, headers: HTTPHeaders(headers ?? [:])).validate().responseJSON { (response) in
            debugPrint(response)
            self.handleResponse(response: response, success: success, failed: failed)
        }
        
    }
    
}



extension ApiManager {
    fileprivate func handleResponse(response: DataResponse<Any>,
                                    success: RequestSuccessBlock,
                                    failed: RequestFailedBlock) {
        if let error = response.result.error {
            failed(error.localizedDescription)
        } else if let data = response.result.value {
            if (data as? NSDictionary) == nil {
                
            } else {
                success(data as! [String : Any])
            }
        }
    }
}


