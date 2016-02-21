//
//  GetThePostResult.swift
//  DLM_sale_wron
//
//  Created by wangrong on 16/2/15.
//  Copyright © 2016年 zhjt. All rights reserved.
//

import UIKit
protocol GetDicMapDelegate{
    func getDicMapResult(result:AnyObject!)
}
class GetDicMap {
    var delegate:GetDicMapDelegate?
    var result:NSDictionary?
    func getDicMapResult(urlString:String,sentData:NSDictionary){
        
        RequestAPI.POST(urlString, body: sentData, succeed: succeed, failed: failed)
        
    }
    
    func succeed(task:NSURLSessionDataTask!,responseObject:AnyObject!)->Void{
        print("获取数据成功")
        self.delegate?.getDicMapResult(responseObject)
        
    }
    
    func failed(task:NSURLSessionDataTask!,error:NSError!)->Void{
        print("失败了")
    }
}