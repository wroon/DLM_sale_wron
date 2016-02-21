//
//  SetViewController.swift
//  DLM_sale_wron
//
//  Created by wangrong on 16/2/11.
//  Copyright © 2016年 zhjt. All rights reserved.
//

import UIKit

class SetViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func longinOut(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().removeObjectForKey("USERNAME")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("PASSWORD")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("MOBILE")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("USERID")
        NSUserDefaults.standardUserDefaults().synchronize()
        print("iiiiiiiiiiiii")
        let sb = UIStoryboard(name: "Main", bundle:nil)
        let seSb = sb.instantiateViewControllerWithIdentifier("loginStory")
        self.presentViewController(seSb, animated: true, completion: nil)
        print("iiiiiiiiiiiii")
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
