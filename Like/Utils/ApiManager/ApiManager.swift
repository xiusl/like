//
//  ApiManager.swift
//  XiaoQinTong
//
//  Created by xiusl on 2019/9/17.
//  Copyright © 2019 yueyilan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

typealias RequestSuccessBlock = (_ result: Any) -> Void
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
        case .bodyPost:
            self.POST(url: url, data: request.params, headers: request.headers, encoding: URLEncoding.queryString, success: success, failed: failed)
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
    
    fileprivate func POST(url: String,
                          data: Any,
                          headers: [String: String]?,
                          encoding: ParameterEncoding,
                          success: @escaping RequestSuccessBlock,
                          failed: @escaping RequestFailedBlock) {
        let request = self.bodyRequest(url: url, data: data, headers: headers)
        self.manager.request(request).validate().responseJSON { (response) in
            self.handleResponse(response: response, success: success, failed: failed)
        }
    }
    
    
    fileprivate func bodyRequest(url: String, data: Any, headers: [String: String]?) -> URLRequest {
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        if let headers = headers {
//            for (k, v) in headers {
//                request.setValue(v, forHTTPHeaderField: k)
//            }
//        }
        do {
            let json = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            request.httpBody = json
            return request
        } catch {
            debugPrint("post json `Serialization` error")
            return request
        }
    }
}



extension ApiManager {
    fileprivate func handleResponse(response: DataResponse<Any>,
                                    success: RequestSuccessBlock,
                                    failed: RequestFailedBlock) {
        if let _ = response.result.error {
            do {
            let json = try JSONSerialization.jsonObject(with: response.data ?? Data(), options: .mutableLeaves)
            print(json)
                let j = JSON(json)
                failed(j["error"].stringValue)
            } catch {
                failed("未知错误")
            }
            
        } else if let data = response.result.value {
            if (data as? NSDictionary) == nil {
                failed("data error")
            } else {
                let d = data as! [String: Any]
                
                success(d["data"] as! Any)
            }
        }
    }
}


