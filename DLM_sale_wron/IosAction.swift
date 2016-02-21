//
//  LoginAction.swift
//  DLM_sale_wron
//
//  Created by wangrong on 16/2/9.
//  Copyright © 2016年 zhjt. All rights reserved.
//

import Foundation

class IosAction:NSObject{
    
    var serverToken:String? = ""
    let urlString:String?
    let connUrl:ConnectHost!
    var resultDic:NSDictionary? = NSDictionary()
    init(ip:String,port:String,projectName:String,interfaceAction:String,serverToken:String){
        self.serverToken = serverToken
        self.connUrl = ConnectHost(ip: ip, port: port, projectName: projectName,interfaceAction: interfaceAction)
        self.urlString = "http://\(ip):\(port)/\(projectName)\(interfaceAction)"
    }
    init(ip:String,port:String,projectName:String,interfaceAction:String){
        self.connUrl = ConnectHost(ip: ip, port: port, projectName: projectName,interfaceAction: interfaceAction)
        self.urlString = "http://\(ip):\(port)/\(projectName)\(interfaceAction)"
    }
    //异步请求数据方法
    func getResult(sentData:NSDictionary)->NSDictionary{
        print("获取结果方法执行开使，调用的接口地址：\(self.connUrl.url)")
        let manager = AFHTTPRequestOperationManager()
        var getresult:NSDictionary?
        var faileresult = ["faile":"oo"]
        
        let globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        let group = dispatch_group_create()
        dispatch_group_async(group, globalQueue) { () -> Void in
            manager.POST(self.connUrl.url, parameters:sentData,success: {(requestOperation:AFHTTPRequestOperation!,result:AnyObject!)->Void in
                
                do{
                    let resultData:NSData! = try NSJSONSerialization.dataWithJSONObject(result, options: NSJSONWritingOptions.PrettyPrinted)
                    
                    let tempResultDic = try NSJSONSerialization.JSONObjectWithData(resultData, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
                    print("=-=-=-=-=-=-=-tempResult")
                    getresult = tempResultDic
                    print(getresult!["desc"])
                    print("获取结果方法结束-----------------------")
                    print("注册监听开始")
                    NSNotificationCenter.defaultCenter().postNotificationName("DownLoadNotification", object: self, userInfo: ["result":getresult!])
                    print("注册监听结束")
                }
                catch is NSError{
                }
                },
                failure: {(requerstOperation:AFHTTPRequestOperation!,error:NSError!)->Void in
                    getresult = ["result":"数据请求调用接口没成功"]
                    print("调用的接口地址：\(self.connUrl.url)获取信息失败")
                    print(error.domain)
            })
        }
        dispatch_group_notify(group, globalQueue) { () -> Void in
            print("123903012984094238490832095823042-3--=-=-==-")
        }
        
        if let re = getresult{
            print(getresult)
            return re
        }else{
            print(faileresult)
            return faileresult
        }
    }
    //下面是ios自带的url，可同步提交请求
    func userLoginNsurl(username:String,password:String){
        
        let sendData = "username=\(username)&password=\(password)&server_token=\(self.serverToken!)&ipadid=111&token=EAFFDB4A-64E6-C44D-8AB1-2B818EF35DC6".dataUsingEncoding(NSUTF8StringEncoding)
        var url:NSURL
        url = NSURL(string: self.urlString!)!
        let request = NSMutableURLRequest(URL: url, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringCacheData, timeoutInterval: 10)
        request.HTTPMethod = "POST"
        request.HTTPBody = sendData
        
        
        var response:NSURLResponse?
        
        do{
            let resultData:NSData? = try NSURLConnection.sendSynchronousRequest(request, returningResponse: &response)
            let send = NSString(data: sendData!, encoding: NSUTF8StringEncoding)
            self.resultDic = try NSJSONSerialization.JSONObjectWithData(resultData!, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
        }
        catch let error as NSError{
            print(error.code)
            print(error.debugDescription)
            self.resultDic = NSDictionary(object: "neterror", forKey: "reslut")
        }
    }
    
    //下面是ios自带的获取加密的servertoken
    func getServerToken(sentData:String){
        
        let sendDataUTF = sentData.dataUsingEncoding(NSUTF8StringEncoding)
        var url:NSURL
        url = NSURL(string: self.urlString!)!
        let request = NSMutableURLRequest(URL: url, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringCacheData, timeoutInterval: 10)
        request.HTTPMethod = "POST"
        request.HTTPBody = sendDataUTF
        
        
        var response:NSURLResponse?
        
        do{
            let resultData:NSData? = try NSURLConnection.sendSynchronousRequest(request, returningResponse: &response)
            let send = NSString(data: sendDataUTF!, encoding: NSUTF8StringEncoding)
            self.resultDic = try NSJSONSerialization.JSONObjectWithData(resultData!, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
        }
        catch let error as NSError{
            print(error.code)
            print(error.debugDescription)
            self.resultDic = NSDictionary(object: "neterror", forKey: "reslut")

        }
    }
}