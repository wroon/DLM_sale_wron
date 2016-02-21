//
//  RequestClient.swift
//  DLM_sale_wron
//
//  Created by wangrong on 16/2/15.
//  Copyright © 2016年 zhjt. All rights reserved.
//

import UIKit

class RequestClient: AFHTTPSessionManager {
    class var sharedInstance: RequestClient {
        struct Static {
            static var onceToken:dispatch_once_t = 0
            static  var instance:RequestClient? = nil
        }
        dispatch_once(&Static.onceToken, {() -> Void in
            let url:NSURL = NSURL(string: "")!
            Static.instance = RequestClient(baseURL: url)
        })
        return Static.instance!
    }
}
