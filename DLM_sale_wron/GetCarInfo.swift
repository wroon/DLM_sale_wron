//
//  GetCarInfo.swift
//  DLM_sale_wron
//
//  Created by 王荣 on 16/2/19.
//  Copyright © 2016年 zhjt. All rights reserved.
//
//
//  GetThePostResult.swift
//  DLM_sale_wron
//
//  Created by wangrong on 16/2/15.
//  Copyright © 2016年 zhjt. All rights reserved.
//

import UIKit
protocol GetCarInfoDelegate{
    func getCarInfoResult(result:AnyObject!)
}
class GetCarInfo {
    var delegate:GetCarInfoDelegate?
    var result:NSDictionary?
    func getCarInfoResult(urlString:String,sentData:NSDictionary){
        
        RequestAPI.POST(urlString, body: sentData, succeed: succeed, failed: failed)
        
    }
    
    func succeed(task:NSURLSessionDataTask!,responseObject:AnyObject!)->Void{
        print("获取车型基础数据成功")
        self.delegate?.getCarInfoResult(responseObject)
        
    }
    
    func failed(task:NSURLSessionDataTask!,error:NSError!)->Void{
        print("获取车型基础数据失败了")
        print(error.code)
        print(error.description)
    }
}