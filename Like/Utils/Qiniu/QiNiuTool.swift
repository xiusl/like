//
//  QiNiuTool.swift
//  Like
//
//  Created by xiu on 2019/11/25.
//  Copyright © 2019 likeeee. All rights reserved.
//

import Foundation
















let kQNBlockSize: Int  = 4 * 1024 * 1024;

func qu_eTag(data: Data) -> String {
    if data.count == 0 {
        return "Fto5o-5ea0sNMlW_75VgGJCv2AcJ"
    }
    
    let len = data.count
    let count = (len + kQNBlockSize - 1) / kQNBlockSize
    
    let retData: Data = Data.init(count: Int(CC_SHA1_DIGEST_LENGTH+1))
    
    var ret = [UInt8](retData)
    var blocksSha1: Data? = nil
    var pblocksSha1: [UInt8] = Array(ret[1..<ret.count])
    
    if count > 1 {
        blocksSha1 = Data(count: Int(CC_SHA1_DIGEST_LENGTH)*count)
        pblocksSha1 = [UInt8](blocksSha1!)
    }
    
    for i in 0..<count {
        let offset: Int = i * kQNBlockSize
        let size: Int = (len - offset) > kQNBlockSize ? kQNBlockSize : (len - offset);
        let end = offset+size
        var d: Data = data.subdata(in: offset..<end)
        
        CC_SHA1(d.withUnsafeMutableBytes({ (bytes) -> UnsafeMutablePointer<UInt8> in
            return bytes
        }), CC_LONG(size), &pblocksSha1[i * Int(CC_SHA1_DIGEST_LENGTH)])
//        CC_SHA1(d.bytes, (CC_LONG)size, pblocksSha1 + i * CC_SHA1_DIGEST_LENGTH)
    }
    
    if count == 1 {
        ret[0] = 0x16
    } else {
        ret[0] = 0x96
        CC_SHA1(pblocksSha1, CC_LONG(Int(CC_SHA1_DIGEST_LENGTH) * count), &ret[1]);
        
    }
    
    for i in 0..<ret.count {
        print("sda:\(ret[i])")
    }
    let ad = Data(ret)
    
    var td = ad.base64EncodedString()
    
    td = td.replacingOccurrences(of: "+", with: "-")
    td = td.replacingOccurrences(of: "/", with: "_")
    
    return td
}
// lqD9xp4LwUkqqSzsgO7CzWiYsgG_

// lqD9xp4LwUkqqSzsgO7CzWiYsgG_

/*
 NSUInteger QN_CalcEncodedLength(NSUInteger srcLen, BOOL padded) {
     NSUInteger intermediate_result = 8 * srcLen + 5;
     NSUInteger len = intermediate_result / 6;
     if (padded) {
         len = ((len + 3) / 4) * 4;
     }
     return len;
 }
 */

func encodeData(data: Data) -> String {
    var result = ""
    
//    let length = data.count
//    let intermediate_result = 8 * length + 5
//    var len = intermediate_result / 6
//    len = ((len + 3) / 4) * 4;
//    let maxLength = len
//
//    var result: Data = Data()
//    result.count = len
    
//    let converted: Data =
//
//    result = String(data: converted, encoding: .ascii)
    
    return result
}

/*
 - 0 : 150
 - 1 : 160
 - 2 : 253
 - 3 : 198
 - 4 : 158
 - 5 : 11
 - 6 : 193
 - 7 : 73
 - 8 : 42
 - 9 : 169
 - 10 : 44
 - 11 : 236
 - 12 : 128
 - 13 : 238
 - 14 : 194
 - 15 : 205
 - 16 : 104
 - 17 : 152
 - 18 : 178
 - 19 : 1
 - 20 : 191
 */
