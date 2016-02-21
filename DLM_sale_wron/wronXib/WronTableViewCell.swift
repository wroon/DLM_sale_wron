//
//  WronTableViewCell.swift
//  DLM_sale_wron
//
//  Created by wangrong on 16/2/10.
//  Copyright © 2016年 zhjt. All rights reserved.
//

import UIKit

class WronTableViewCell: UITableViewCell {

    @IBOutlet weak var cusname: UILabel!
    @IBOutlet weak var times: UILabel!
    @IBOutlet weak var level: UILabel!
    @IBOutlet weak var cartype: UILabel!
    @IBOutlet weak var phone: UIButton!



    @IBOutlet weak var domore: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func doMore(sender: AnyObject) {
        
        print("点击了domore按钮")
    }
    @IBAction func phoneTouch(sender: AnyObject) {
        
    }
    
}
