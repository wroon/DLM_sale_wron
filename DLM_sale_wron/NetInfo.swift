//
//  NetInfo.swift
//  DLM_sale_wron
//
//  Created by 王荣 on 16/2/16.
//  Copyright © 2016年 zhjt. All rights reserved.
//

import Foundation

struct NetInfo {
    //服务器端口信息
    static let IP = (NSUserDefaults.standardUserDefaults().valueForKey("ip") as? String)!
    static let PORT = (NSUserDefaults.standardUserDefaults().valueForKey("port") as? String)!
    static let PROJECT_NAME = (NSUserDefaults.standardUserDefaults().valueForKey("projectName") as? String)!
    //接口地址信息
    static let GET_CUS_LIST = "/IOSCustomerIntentionController/queryPageList.iosaction"
    static let GET_CITIES = "/IOSCommonUtilsController/getProvincesCitiesDistricts.iosaction"
    static let GET_DICMAP = "/IOSCacheController/querydicmaplist.iosaction"
    static let GET_VERSION = "/IOSCommonUtilsController/getLatestVersion.iosaction"
    static let GET_CARINFO = "/IOSCacheController/querydicmaplist.iosaction"
    //接口url，在GetThePostResult方法中直接调用
    static let GET_CUS_LIST_urlString = "http://\(IP):\(PORT)/\(PROJECT_NAME)\(GET_CUS_LIST)"
    static let GET_CITIES_urlString = "http://\(IP):\(PORT)/\(PROJECT_NAME)\(GET_CITIES)"
    static let GET_VERSION_urlString = "http://\(IP):\(PORT)/\(PROJECT_NAME)\(GET_VERSION)"
    static let GET_DICMAP_urlString = "http://\(IP):\(PORT)/\(PROJECT_NAME)\(GET_DICMAP)"
    static let GET_CARINFO_urlString = "http://\(IP):\(PORT)/\(PROJECT_NAME)\(GET_CARINFO)"
    
}