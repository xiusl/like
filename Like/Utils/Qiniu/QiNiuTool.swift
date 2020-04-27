//
//  QiNiuTool.swift
//  Like
//
//  Created by xiu on 2019/11/25.
//  Copyright © 2019 likeeee. All rights reserved.
//

import Foundation

fileprivate let kQNBlockSize: Int  = 4 * 1024 * 1024;

func qn_eTag(data: Data) -> String {
    let len = data.count
    if len == 0 {
        return "Fto5o-5ea0sNMlW_75VgGJCv2AcJ"
    }
    
    let count = (len + kQNBlockSize - 1) / kQNBlockSize
    
    let retData: Data = Data.init(count: Int(CC_SHA1_DIGEST_LENGTH+1))
    var ret = [UInt8](retData)
    if count == 1 {
//        let d: Data = data
//
//        var bytes = [UInt8](d)
//        let pointer: UnsafeMutablePointer<UInt8> = UnsafeMutablePointer(&bytes)
        
        let bytes = data.withUnsafeBytes {
            $0.baseAddress?.bindMemory(to: UInt8.self, capacity: 4)
        }
        
        
        CC_SHA1(bytes, CC_LONG(len), &ret[1])
        ret[0] = 0x16
    } else {
        let blocksSha1 = Data(count: Int(CC_SHA1_DIGEST_LENGTH)*count)
        var pblocksSha1 = [UInt8](blocksSha1)
        
        for i in 0..<count {
            let offset: Int = i * kQNBlockSize
            let size: Int = (len - offset) > kQNBlockSize ? kQNBlockSize : (len - offset);
            let end = offset+size
            let d: Data = data.subdata(in: offset..<end)
            
//            var bytes = [UInt8](d)
//            let pointer: UnsafeMutablePointer<UInt8> = UnsafeMutablePointer(&bytes)
            
            let bytes = d.withUnsafeBytes {
                $0.baseAddress?.bindMemory(to: UInt8.self, capacity: 4)
            }
            
            CC_SHA1(bytes, CC_LONG(size), &pblocksSha1[i * Int(CC_SHA1_DIGEST_LENGTH)])
            
            
        }
        CC_SHA1(pblocksSha1, CC_LONG(Int(CC_SHA1_DIGEST_LENGTH) * count), &ret[1]);
        ret[0] = 0x96
    }
    
    var tag = Data(ret).base64EncodedString()
    tag = tag.replacingOccurrences(of: "+", with: "-")
    tag = tag.replacingOccurrences(of: "/", with: "_")
    
    return tag
}


func qn_eTag1(data: Data) -> String {
    let len = data.count
    if len == 0 {
        return "Fto5o-5ea0sNMlW_75VgGJCv2AcJ"
    }
    
    let count = (len + kQNBlockSize - 1) / kQNBlockSize
    
    let retData: Data = Data.init(count: Int(CC_SHA1_DIGEST_LENGTH+1))
    var ret = [UInt8](retData)
    
    if count == 1 {
        let bytes = data.withUnsafeBytes {
            $0.bindMemory(to: UInt8.self).baseAddress
        }
   
        CC_SHA1(bytes, CC_LONG(len), &ret[1])
        ret[0] = 0x16
    } else {
        let blocksSha1 = Data(count: Int(CC_SHA1_DIGEST_LENGTH)*count)
        var pblocksSha1 = [UInt8](blocksSha1)
        
        for i in 0..<count {
            let offset: Int = i * kQNBlockSize
            let size: Int = (len - offset) > kQNBlockSize ? kQNBlockSize : (len - offset);
            let end = offset+size
            
            let d: Data = data.subdata(in: offset..<end)
            let bytes = d.withUnsafeBytes {
                $0.baseAddress?.bindMemory(to: UInt8.self, capacity: 4)
            }
            
            CC_SHA1(bytes, CC_LONG(size), &pblocksSha1[i * Int(CC_SHA1_DIGEST_LENGTH)])
        }
        CC_SHA1(pblocksSha1, CC_LONG(Int(CC_SHA1_DIGEST_LENGTH) * count), &ret[1]);
        ret[0] = 0x96
        
        
    }
    
    var tag = Data(ret).base64EncodedString()
    tag = tag.replacingOccurrences(of: "+", with: "-")
    tag = tag.replacingOccurrences(of: "/", with: "_")
    
    return tag
}
