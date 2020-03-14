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
    static let baseUrl = "https://ins-api.sleen.top/"
//    static let baseUrl = "http://127.0.0.1:5000/"
    private override init() {
        
    }
    
    private lazy var manager: Session = {
        let config: URLSessionConfiguration = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        
        let delegate: SessionDelegate = SessionDelegate()
        let tr = ServerTrustManager(evaluators: [
            "up-z2.qiniu.com": DisabledEvaluator(),
            "ins-api.sleen.top": DefaultTrustEvaluator()
        ])
        
        return Session(startRequestsImmediately: true, configuration: config, delegate: delegate, rootQueue: DispatchQueue.main, requestQueue: nil, serializationQueue: nil, adapter: nil, serverTrustManager: tr, retrier: nil, eventMonitors: [])
    }()
    
    public func request(request: ApiRequest, success: @escaping RequestSuccessBlock, failed: @escaping RequestFailedBlock) {
        let url = request.baseUrl + request.path
        switch request.type {
        case .get:
            self.GET(url: url, params: request.params as? Parameters, headers: request.headers, encoding: URLEncoding.queryString, success: success, failed: failed)
            break
        case .bodyPost:
            self.POST(url: url, data: request.params, headers: request.headers, encoding: URLEncoding.queryString, success: success, failed: failed)
        case .delete:
            self.DELETE(url: url, data: request.params, headers: request.headers, encoding: URLEncoding.queryString, success: success, failed: failed)
        default:
            break
        }

    }
    
    public func uploadImage(image: UIImage, token: String, success: @escaping RequestSuccessBlock, failed: @escaping RequestFailedBlock) {
        let url = "http://upload-z2.qiniup.com"
        self.manager.upload(multipartFormData: { (formData) in
            
            formData.append(token.data(using: .utf8)!, withName: "token")
            formData.append(image.jpegData(compressionQuality: 1)!, withName: "file")
            },
            usingThreshold: MultipartUpload.encodingMemoryThreshold, fileManager: .default, to: url, method: .post, headers: nil).validate().responseJSON { (response) in
                if let _ = response.result.error {
                    do {
                        let json = try JSONSerialization.jsonObject(with: response.data ?? Data(), options: .mutableLeaves)
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
                        print(d)
                    }
                }
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
        var h = headers ?? [:]
        h["X-Token"] = (User.current?.token ?? "")
        self.manager.request(url, method: .get, parameters: params, encoding: encoding, headers: HTTPHeaders(h)).validate().responseJSON { (response) in
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
    
    fileprivate func DELETE(url: String,
                          data: Any,
                          headers: [String: String]?,
                          encoding: ParameterEncoding,
                          success: @escaping RequestSuccessBlock,
                          failed: @escaping RequestFailedBlock) {
        var request = self.bodyRequest(url: url, data: data, headers: headers)
        request.httpMethod = HTTPMethod.delete.rawValue
        self.manager.request(request).validate().responseJSON { (response) in
            self.handleResponse(response: response, success: success, failed: failed)
        }
    }
    
    
    fileprivate func bodyRequest(url: String, data: Any, headers: [String: String]?) -> URLRequest {
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let headers = headers {
            for (k, v) in headers {
                request.setValue(v, forHTTPHeaderField: k)
            }
        }
        request.setValue((User.current?.token ?? ""), forHTTPHeaderField: "X-Token")
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
        debugPrint(response)
        if let _ = response.result.error {
            do {
                let json = try JSONSerialization.jsonObject(with: response.data ?? Data(), options: .mutableLeaves)
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
                
                success(d["data"] as Any)
            }
        }
    }
}


