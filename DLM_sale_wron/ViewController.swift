//
//  ViewController.swift
//  DLM_sale_wron
//
//  Created by 王荣 on 16/2/3.
//  Copyright © 2016年 zhjt. All rights reserved.
//

import UIKit

class ViewController: UIViewController,NSURLSessionDelegate,NSURLSessionDataDelegate,GetThePostResultDelegate,GetDicMapDelegate,GetCarInfoDelegate {
    
    @IBOutlet weak var ipTextfiled: UITextField!
    @IBOutlet weak var portTextFiled: UITextField!
    @IBOutlet weak var projectTextFiled: UITextField!
    @IBOutlet weak var connButton: UIButton!
    @IBOutlet weak var setButton: UIButton!
    @IBOutlet weak var ipLabel: UILabel!
    @IBOutlet weak var stateLabe: UILabel!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    //    @IBOutlet weak var userLabel: UILabel!
    let mydefault = NSUserDefaults.standardUserDefaults()
    
    var iosAction:IosAction!
    var getServerToken:IosAction!
    var ip:String!
    var port:String!
    var projectName:String!
    var hostUrl:String!
    var serverToken:String?
    let iosLoginAction:String =  "/IOSLoginController/checklogin.iosaction"
    let getServerTokenAction = "/ServerTokenController/getServerToken.iosaction"
    let TOKEN = "server_token=EAFFDB4A-64E6-C44D-8AB1-2B818EF35DC6"
    var timer:NSTimer!
    var loginResult:NSDictionary?
    var isOK = false{
        didSet{
            if isOK {
                ipTextfiled.hidden = true
                portTextFiled.hidden = true
                projectTextFiled.hidden = true
                connButton.hidden = true
                ipLabel.hidden = true
                setButton.hidden = false
            } else {
                ipTextfiled.hidden = false
                portTextFiled.hidden = false
                projectTextFiled.hidden = false
                connButton.hidden = false
                ipLabel.hidden = false
                setButton.hidden = true
            }
        }
    }
    
    var citiesDic:NSDictionary?
    
    var paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
    var documentsDirectory:AnyObject?
    var path:String?
    var dicmappath:String?
    var carinfopath:String?
    let fileManager = NSFileManager.defaultManager()
    var citisFileExists = false
    var dicmapFileExists = false
    var urlisOK = true
    
    @IBAction func displaySet(sender: AnyObject) {
        isOK = false
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        ipTextfiled.text = "101.201.196.155"
        projectTextFiled.text = "dlmdealer"
        portTextFiled.text = "8080"
        if(mydefault.valueForKey("USERNAME") != nil){
            username.text = mydefault.valueForKey("USERNAME") as! String}
        if(mydefault.valueForKey("PASSWORD") != nil){
            password.text = mydefault.valueForKey("PASSWORD") as! String}
        
        isOK = true
        self.stateLabe.text = "已连接"
        if(mydefault.valueForKey("ServerToken") == nil){
            self.stateLabe.text = "未连接"
            connectUrl(connButton)
        }
        
        if(mydefault.valueForKey("USERNAME") as? String != nil){
            print("viewDI之行方法开始")
            LoadingView.shareInstance().showInView(self.view)
            LoadingView.shareInstance().showTitle("login")
            
            timer = NSTimer.scheduledTimerWithTimeInterval(0.0000001, target: self, selector: Selector("autoLogin"), userInfo: nil, repeats: false)
            LoadingView.shareInstance().hideView()
            print("viewDI之行方法开始")
        }
        if (urlisOK){
            //判断citis.plist文件是否存在
            self.documentsDirectory = self.paths[0]
            self.path = self.documentsDirectory!.stringByAppendingPathComponent("citis.plist")
            let sentData:NSDictionary = ["server_token":NSUserDefaults.standardUserDefaults().valueForKey("ServerToken")!]
            citisFileExists = fileManager.fileExistsAtPath(self.path!)
            //登录成功后判断是否存在citis.plist文件
            if citisFileExists == false{
                //获取基础数据
                let getpost = GetThePostResult()
                getpost.delegate = self
                print("-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-")
                getpost.getResult(NetInfo.GET_CITIES_urlString, sentData: sentData)
            }else{
                //获取目录下的所有文件
                do{
                    try fileManager.removeItemAtPath(self.path!)}catch let error as NSError{
                        print(error.code)
                        print(error.description)
                }
                let getpost = GetThePostResult()
                getpost.delegate = self
                print("-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-")
                //执行获取省市信息基础数据
                getpost.getResult(NetInfo.GET_CITIES_urlString, sentData: sentData)
            }
            //获取所有字典缓存数据
            self.dicmappath = self.documentsDirectory!.stringByAppendingPathComponent("dicmap.plist")
            citisFileExists = fileManager.fileExistsAtPath(self.dicmappath!)
            //登录成功后判断是否存在citis.plist文件
            if citisFileExists == false{
                //获取基础数据
                let getdicmap = GetDicMap()
                getdicmap.delegate = self
                print("-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-")
                getdicmap.getDicMapResult(NetInfo.GET_DICMAP_urlString, sentData: sentData)
            }else{
                do{
                    try fileManager.removeItemAtPath(self.dicmappath!)}catch let error as NSError{
                        print(error.code)
                        print(error.description)
                }
                let getdicmap = GetDicMap()
                getdicmap.delegate = self
                print("-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-")
                getdicmap.getDicMapResult(NetInfo.GET_DICMAP_urlString, sentData: sentData)
            }
            //获取车型基础数据
            self.carinfopath = self.documentsDirectory!.stringByAppendingPathComponent("carinfo.plist")
            citisFileExists = fileManager.fileExistsAtPath(self.carinfopath!)
            //登录成功后判断是否存在carinfo.plist文件
            if citisFileExists == false{
                //获取基础数据
                let getcarinfo = GetCarInfo()
                getcarinfo.delegate = self
                print("-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-")
                getcarinfo.getCarInfoResult(NetInfo.GET_CARINFO_urlString, sentData: sentData)
            }else{
                do{
                    try fileManager.removeItemAtPath(self.carinfopath!)}catch let error as NSError{
                        print(error.code)
                        print(error.description)
                }
                let getcarinfo = GetCarInfo()
                getcarinfo.delegate = self
                print("-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-")
                getcarinfo.getCarInfoResult(NetInfo.GET_CARINFO_urlString, sentData: sentData)
            }
        }
        //添加键盘弹出事件监听
        //        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillChange:", name: UIKeyboardWillChangeFrameNotification, object: nil)
        //测试获取省市县接口
        //        let getCity = GetCityBase()
        //        getCity.getCity()
        
    }
    //根据storyboardid定义视图并跳转
    func loginedSegue(){
        print("loginedSegue开始")
        let sb = self.storyboard!
        print(sb)
        let mainView = sb.instantiateViewControllerWithIdentifier("workmain") as? UITabBarController
        print("loginedSegue开始")
        self.presentViewController(mainView!, animated: true, completion: nil)
        print("loginedSegue结束")
    }
    var alertTest:UIAlertController!
    var session:NSURLSession!
    
    
    @IBAction func connectUrl(sender: AnyObject) {
        ip = ipTextfiled.text
        port = portTextFiled.text
        projectName = projectTextFiled.text
        self.getServerToken = IosAction(ip:self.ipTextfiled.text!, port: self.portTextFiled.text!, projectName: self.projectTextFiled.text!, interfaceAction:self.getServerTokenAction)
        self.getServerToken.getServerToken(self.TOKEN)
        
        if(self.getServerToken.resultDic!["reslut"] as? String == "neterror"){
            let alertController = UIAlertController(title: "网络错误", message: "服务器连接错误", preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            alertController.addAction(action)
            self.presentViewController(alertController, animated: true, completion: nil)
            self.urlisOK = false
            self.stateLabe.text = "未连接"
        }else{
            print("==============+++++++===servertoken")
            let server_TokenDic = self.getServerToken.resultDic!["result"] as! NSDictionary
            self.serverToken = server_TokenDic["server_token"] as? String
            self.stateLabe.text = "已连接"
            self.urlisOK = true
            mydefault.setObject(ip, forKey: "ip")
            mydefault.setObject(port, forKey: "port")
            mydefault.setObject(projectName, forKey: "projectName")
            mydefault.setObject(self.serverToken, forKey: "ServerToken")
            mydefault.synchronize()
        }
        isOK = true
    }
    
    func autoLogin(){
        print("执行自动登录方法开始")
        self.iosAction = IosAction(ip:self.ipTextfiled.text!, port: self.portTextFiled.text!, projectName: self.projectTextFiled.text!, interfaceAction:self.iosLoginAction, serverToken:(mydefault.valueForKey("ServerToken") as? String)!)
        print("loginAction实例华完成")
        self.iosAction.userLoginNsurl((mydefault.valueForKey("USERNAME") as? String)!, password: (mydefault.valueForKey("PASSWORD") as? String)!)
        getResult()
        print("执行自动登录方法完成")
    }
    @IBAction func userLoginButton(sender: AnyObject) {
        self.iosAction = IosAction(ip:self.ipTextfiled.text!, port: self.portTextFiled.text!, projectName: self.projectTextFiled.text!, interfaceAction:self.iosLoginAction, serverToken: (mydefault.valueForKey("ServerToken") as? String)!)
        print("loginAction实例华完成")
        self.iosAction.userLoginNsurl(self.username.text!, password: self.password.text!)
        print("调用userLogin接口完成")
        getResult()
        
    }
    func getResult(){
        self.loginResult = self.iosAction.resultDic!
        print("获取结果完成，下面是打印结果：")
        print(self.loginResult)
        if(self.loginResult!["reslut"] as? String == "neterror"){
            let alertController = UIAlertController(title: "网络错误", message: "请检查网络", preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            alertController.addAction(action)
            self.urlisOK = true
            self.stateLabe.text = "未连接"
            self.presentViewController(alertController, animated: true, completion: nil)
        }else if(self.loginResult!["statecode"] as? String == "false"){
            let alertController = UIAlertController(title: "用户名或密码错误", message: "请检查用户名或密码", preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            alertController.addAction(action)
            self.presentViewController(alertController, animated: true, completion: nil)
        }else if(self.loginResult!["statecode"] as? String == "1"){
            //如果登录成功则跳转到主页面
            let resultDic = self.loginResult!["result"] as? NSDictionary
            let userDic = resultDic!["user"] as! NSArray
            let userResult = userDic[0] as! NSDictionary
            print("-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-")
            self.urlisOK = true
            //将登录成功后的用户信息存储到userdefault
            mydefault.setObject("nihao", forKey: "you")
            mydefault.setObject(userResult["USERNAME"] as? String, forKey: "USERNAME")
            mydefault.setObject(userResult["PASSWORD"] as? String, forKey: "PASSWORD")
            mydefault.setObject(userResult["MOBILE"] as? String, forKey: "MOBILE")
            mydefault.setObject(userResult["ID"] as? String, forKey: "USERID")
            mydefault.synchronize()
            loginedSegue()
        }else if(self.loginResult!["statecode"] as? String == "2"){
            let alertController = UIAlertController(title: "用户名或密码错误", message: "请检查用户名或密码", preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            alertController.addAction(action)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    // MARK: - 实现代理方法
    
    //获取省市县基础数据，并保存到本地的citis.plist文件
    func getResult(result: AnyObject!) {
        NSLog("-==-=--=-=-=创建文件开始\(NSDate())")
        
        self.fileManager.createFileAtPath(path!, contents:nil, attributes: nil)
        NSLog("-==-=--=-=-=创建文件结束\(NSDate())")
        if let resultDic = result{
            NSLog("-=-=-=-=-=--==--=-=-=-=-==--=-=写入citis.plist数据开始\(NSDate())")
            let resultresultDic = resultDic["result"] as! NSDictionary
            resultresultDic.writeToFile(self.path!, atomically: true)
            NSLog("-=-=-=-=-=--==--=-=-=-=-==--=-=写入citis.plist数据结束\(NSDate())")
        }
    }
    //获取字典基础数据，并保存到本地的dicmap.plist文件
    func getDicMapResult(result: AnyObject!) {
        NSLog("-==-=--=-=-=创建文件开始dicmap.plist\(NSDate())")
        self.fileManager.createFileAtPath(dicmappath!, contents:nil, attributes: nil)
        NSLog("-==-=--=-=-=创建文件结束dicmap.plist\(NSDate())")
        if let resultDic = result{
            NSLog("-=-=-=-=-=--==--=-=-=-=-==--=-=写入dicmap.plist数据开始\(NSDate())")
            let resultresultDic = resultDic["result"] as! NSDictionary
            resultresultDic.writeToFile(self.dicmappath!, atomically: true)
            
             NSLog("-=-=-=-=-=--==--=-=-=-=-==--=-=写入dicmap.plist数据结束\(NSDate())")
            }
        NSLog("\(self.fileManager.subpathsAtPath(self.documentsDirectory as! String))")
    }
    
    func getCarInfoResult(result: AnyObject!) {
        NSLog("-==-=--=-=-=创建文件开始dicmap.plist\(NSDate())")
        self.fileManager.createFileAtPath(carinfopath!, contents:nil, attributes: nil)
        NSLog("-==-=--=-=-=创建文件结束dicmap.plist\(NSDate())")
        if let resultDic = result{
            NSLog("-=-=-=-=-=--==--=-=-=-=-==--=-=写入dicmap.plist数据开始\(NSDate())")
            let resultresultDic = resultDic["result"] as! NSDictionary
            resultresultDic.writeToFile(self.carinfopath!, atomically: true)
            NSLog("-=-=-=-=-=--==--=-=-=-=-==--=-=写入dicmap.plist数据结束\(NSDate())")
        }
    }
    //下面方法实现键盘自动跳转到密码输入框
    @IBAction func toPassword(sender: AnyObject) {
        self.username.resignFirstResponder()
        self.password.becomeFirstResponder()
    }
    //下面方法实现点击键盘go按钮后自动登录
    @IBAction func toLogin(sender: AnyObject) {
        userLoginButton(self.loginButton)
    }
    //下面方法实现点击空白处隐藏键盘
    @IBAction func closeKeyboard(sender: AnyObject) {
        username.resignFirstResponder()
        password.resignFirstResponder()
    }
    //弹出键盘改变布局
    @IBOutlet weak var constraints: NSLayoutConstraint!
    func keyboardWillChange(notification:NSNotification){
        print("到这里了吗")
        if let userInfo = notification.userInfo,
            value = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue,
            duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double,
            curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? UInt {
                
                let frame = value.CGRectValue()
                let intersection = CGRectIntersection(frame, self.view.frame)
                
                self.view.setNeedsLayout()
                //改变下约束
                self.constraints.constant = CGRectGetHeight(intersection)
                
                UIView.animateWithDuration(duration, delay: 0.0,
                    options: UIViewAnimationOptions(rawValue: curve), animations: {
                        _ in
                        self.view.setNeedsLayout()
                    }, completion: nil)
        }
    }
    
}