//: Playground - noun: a place where people can play

import UIKit

var str:NSString = "Hello, playground"
var userDefault = NSUserDefaults.standardUserDefaults()
userDefault.setObject("haoao", forKey: "wang")
var re = userDefault.objectForKey("wang") as? String

userDefault.setFloat(3.2111, forKey: "Float")
var floatValue = userDefault.floatForKey("Float")



