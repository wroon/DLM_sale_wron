//
//  WorkTableViewController.swift
//  DLM_sale_wron
//
//  Created by wangrong on 16/2/10.
//  Copyright © 2016年 zhjt. All rights reserved.
//

import UIKit
//通过此协议进行客户信息的传值
protocol WorkTableViewControllerDelegate{
    func getCustomerinfo(customerinfo:Dictionary<String,String>)
}

class WorkTableViewController: UITableViewController,UISearchBarDelegate,UISearchDisplayDelegate,GetThePostResultDelegate {
    
    var delegate:WorkTableViewControllerDelegate!
    
    var customers = [Customer]()
        {didSet{
            self.topBar.title = "待跟进客户(\(customers.count))"
            self.tableView.reloadData()
            }
        }
    var filterCustomers = [Customer]()
    var cusList:NSDictionary?
    var PostCusListResult:NSDictionary?
    //接口请求data
     var sentData:NSDictionary = ["server_token":NSUserDefaults.standardUserDefaults().valueForKey("ServerToken")!,"params":"{'page':'1','rows':'100000',salesstaffid:'\(NSUserDefaults.standardUserDefaults().valueForKey("USERID")!)'}"]
    let getthepostRestul = GetThePostResult()
    //新建意向客户信息返回方法
    @IBAction func cancelToWorkTableViewController(segue:UIStoryboardSegue){}
    //新建意向客户信息时保存方法
    @IBAction func saveCustomer(segue:UIStoryboardSegue){

        if let theNewcustomerViewController = segue.sourceViewController as? NewCustomerViewController{

            customers.insert(theNewcustomerViewController.newCustomer, atIndex: 0)

            self.tableView.reloadData()
        }
        
    }
   
    //刷新方法
    
    @IBAction func refreshData(sender: UIRefreshControl) {
        //清空之前下载数据，重新获取数据
        sender.beginRefreshing()
        self.customers.removeAll()

       getthepostRestul.getResult(NetInfo.GET_CUS_LIST_urlString,sentData:self.sentData)
        sender.endRefreshing()

    }
    
    @IBOutlet weak var topBar: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置获取意向客户列表的代理为自己
        getthepostRestul.delegate = self
        getthepostRestul.getResult(NetInfo.GET_CUS_LIST_urlString,sentData:self.sentData)
        
        let nib = UINib(nibName: "WronTableViewCell" , bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "WronTableViewCell")
        self.topBar.title = "待跟进客户(\(customers.count))"
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    //此处需要添加根据当前视图返回行数，否则会出现数组越界的错误
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if tableView == self.searchDisplayController?.searchResultsTableView{
            return filterCustomers.count
        }else{
            return customers.count }
    }
    
   //需要判断当前视图是否点击搜索栏，如果是则显示搜索后的结果
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "WronTableViewCell"
        let cell = self.tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! WronTableViewCell
        
        var customer:Customer
        if tableView == self.searchDisplayController?.searchResultsTableView{
            customer = filterCustomers[indexPath.row]
        }else{
            customer = customers[indexPath.row]}
        cell.cusname.text = customer.name
        cell.times.text = customer.times
        cell.phone.setTitle(customer.phone, forState: UIControlState.Normal)
        cell.cartype.text = customer.carType
        cell.level.text = customer.level
        cell.backgroundColor = UIColor.clearColor()
    return cell
    }
    //通过tableviewrowAction实现左滑
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let followupAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "跟进") { (action:UITableViewRowAction!, indexPat:NSIndexPath) -> Void in
            print("跟进")
        }
        let dailephoneAction = UITableViewRowAction(style: UITableViewRowActionStyle.Destructive, title: "通话") { (action:UITableViewRowAction!, indexPat:NSIndexPath) -> Void in
            print("通话")
        }
        dailephoneAction.backgroundColor = UIColor.yellowColor()
        return [followupAction,dailephoneAction]
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
//    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("以选择第\(indexPath)行表格")
        let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! WronTableViewCell
        
         print("31029301283------=-=-=-=-=-=--=-=")
        var sendCustomerinfo:Dictionary<String,String>?
        for i in self.customers{
             print("31029301283------=-=-=-=-=-=--=-=")
            if i.name == cell.cusname.text!{
                 print("31029301283------=-=-=-=-=-=--=-=")
                //进行页面传值目前有问题，传输自定义对象时有问题！但传输string等类型没有问题
                sendCustomerinfo = ["name":i.name,"phone":i.phone,"carType":i.carType,"level":i.level,"times":i.times]
                print(sendCustomerinfo)
                        }
        }
        performSegueWithIdentifier("CellToNewCusview", sender: sendCustomerinfo)
//
//         print("31029301283------=-=-=-=-=-=--=-=")
//        print(cusDic)
//        //self.delegate.getCustomerinfo(cusDic)
//         print("31029301283------=-=-=-=-=-=--=-=")
//        topvc.name.text = "123"
//        print("3940893939999999999")
//        self.presentViewController(topvc, animated: true, completion: nil)
         print("31029301283------=-=-=-=-=-=--=-=")
        
    }
    //自定义过滤方法
    func filterContentForSearchText(searchText:String){
        print("开始执行过滤方法")
        self.filterCustomers = self.customers.filter({ (customer:Customer) -> Bool in
            let stringMatch = customer.phone.rangeOfString(searchText)
            print("执行过滤方法")
            return stringMatch != nil
        })
         print("结束执行过滤方法")
        print(filterCustomers)
    }
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String?) -> Bool {
        print("开始执行=========")
        self.filterContentForSearchText(searchString!)
        
        return true
    }
    
    func getResult(result: AnyObject!) {
        
        self.cusList = result as? NSDictionary

        //print(self.cusList)
        if let total = self.cusList!["result"]!["total"]{
            print("-=-=--==-=-=-=-=--=-++++++++++++++++")
            print(total)
        }
        if let userInfo = self.cusList{
        if let result = userInfo["result"]{
            let resultArray = result["rows"] as! NSArray
            for i in resultArray
            {
                var name:String? = i["customername"] as? String
                var phone:String? = i["telephone"] as? String
                var times:String? = i["followupnumber"] as? String
                var thelevel:String? = i["currentlevel"] as? String
                var carType:String? = i["cartype"] as? String
                if  let _ = name{
                    name = i["customername"] as? String
                }else{name = ""}
                
                if let _ = phone{
                    phone = i["telephone"] as? String
                }else{
                    phone = ""}
                if  let _ = times{
                    times = i["followupnumber"] as? String
                }else{times = ""}
                
                if let _ = thelevel{
                    thelevel = i["currentlevel"] as? String
                }else{
                    thelevel = ""}
                if let _ = carType{
                    carType = i["cartype"] as? String
                }else{
                    carType = ""}
                let customer = Customer(name: name!, phone: phone!, times: times!, level:thelevel!, carType: carType!)
                self.customers.append(customer)
            }
        }
        }
    }
        /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "CellToNewCusview"{
            //实例化第二个页面
            print("fjsdlajfosiajfoi092390293-00-")
            let toVC = segue.destinationViewController as! NewCustomerViewController
            toVC.customerinfo = sender as! Dictionary
        }
    }

    
}
