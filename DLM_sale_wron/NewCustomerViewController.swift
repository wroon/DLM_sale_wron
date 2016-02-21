//
//  NewCustomerViewController.swift
//  DLM_sale_wron
//
//  Created by wangrong on 16/2/13.
//  Copyright © 2016年 zhjt. All rights reserved.
//

import UIKit

class NewCustomerViewController: UIViewController {
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var carType: UITextField!
    @IBOutlet weak var times: UITextField!
    @IBOutlet weak var level: UITextField!
    @IBOutlet weak var phone: UITextField!
    
    var newCustomer:Customer!
    var workvc = WorkTableViewController()
    var customerinfo:Dictionary<String,String>?
    
    override func viewDidLoad() {
        self.workvc.delegate = self
//        if let _ = customerinfo!["name"]{
//            self.name.text = customerinfo!["name"]}
//        if let _ = customerinfo!["phone"]{
//            self.phone.text = customerinfo!["phone"]}
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if(segue.identifier == "saveCustomer"){
            newCustomer = Customer(name:self.name.text!,phone:self.phone.text!,times:self.times.text!,level:self.level.text!,carType:self.carType.text!)

        }
    }
}
