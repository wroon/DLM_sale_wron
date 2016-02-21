//
//  WelcomeViewController.swift
//  DLM_sale_wron
//
//  Created by wangrong on 16/2/10.
//  Copyright © 2016年 zhjt. All rights reserved.
//

import UIKit
//第一次运行开屏页
class WelcomeViewController: UIViewController,UIScrollViewDelegate {
    var scrollView = UIScrollView()
    var pageController = UIPageControl()
    var btn = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageController.center = CGPointMake(self.view.frame.width/2, self.view.frame.height-30)
        pageController.currentPageIndicatorTintColor = UIColor.greenColor()
        pageController.pageIndicatorTintColor = UIColor.whiteColor()
        pageController.numberOfPages = 4 //小圆点的数量，及滑动页面的数量
        pageController.addTarget(self, action: "scrollViewDidEndDecelerating", forControlEvents: UIControlEvents.ValueChanged)
        
        scrollView.frame = self.view.bounds
        scrollView.contentSize = CGSizeMake(4*self.view.frame.width, 0)
        scrollView.pagingEnabled = true //允许分页
        scrollView.bounces = false //弹性效果
        scrollView.showsHorizontalScrollIndicator = false //显示水平的指示条
        scrollView.delegate = self
        self.view.addSubview(scrollView)
        for i in 1...4{
            let image = UIImage(named: "Welcome\(i)")
            print("Welcome\(i)")
            let imageView = UIImageView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
            imageView.image = image
            var frame = imageView.frame
            frame.origin.x = CGFloat(i-1)*frame.size.width
            imageView.frame = frame
            scrollView.addSubview(imageView)
            self.view.addSubview(pageController)
            
        }
    }
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x/self.view.frame.size.width)
        pageController.currentPage = index
        if (index == 3){
            self.btn.frame = CGRectMake(3*self.view.frame.width, self.view.frame.height, self.view.frame.width, 50)
            self.btn.setTitle("进入DLM", forState: UIControlState.Normal)
            self.btn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Highlighted)
            self.btn.backgroundColor = UIColor.orangeColor()
            self.btn.alpha = 0
            self.btn.addTarget(self, action: "btnClick:", forControlEvents: UIControlEvents.TouchUpInside)
            UIView.animateWithDuration(0.5, delay: 0.1, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                self.btn.frame = CGRectMake(3*self.view.frame.width, self.view.frame.height-150, self.view.frame.width, 50)
                self.btn.alpha = 1
                self.scrollView.addSubview(self.btn)
                }, completion: nil)
        }
        
    }
    
    func btnClick(button:UIButton){
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let seSb = sb.instantiateViewControllerWithIdentifier("loginStory")
        self.presentViewController(seSb, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

