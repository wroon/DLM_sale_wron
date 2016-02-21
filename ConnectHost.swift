//
//  File.swift
//  DLM_sale_wron
//
//  Created by wangrong on 16/2/4.
//  Copyright © 2016年 zhjt. All rights reserved.
//

import Foundation

class ConnectHost {
    
    var url:String!
    
    init(ip:String,port:String,projectName:String,interfaceAction:String){
        url = "http://"+ip+":"+port+"/"+projectName+interfaceAction
    }
}