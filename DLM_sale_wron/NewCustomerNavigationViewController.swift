//
//  NewCustomerNavigationViewController.swift
//  DLM_sale_wron
//
//  Created by 王荣 on 16/2/19.
//  Copyright © 2016年 zhjt. All rights reserved.
//

import UIKit

class NewCustomerNavigationViewController: UINavigationController,WorkTableViewControllerDelegate {

    override func viewDidLoad() {
        let sss = WorkTableViewController()
        sss.delegate = self
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func getCustomerinfo(customerinfo: Dictionary<String, String>) {
        print(customerinfo)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
