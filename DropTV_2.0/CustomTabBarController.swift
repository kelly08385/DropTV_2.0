//
//  CustomTabBarController.swift
//  DropTV_2.0
//
//  Created by tw itri on 2016/2/25.
//  Copyright © 2016年 tw_itri. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appdelegateObj = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let allItems:[AnyObject] = self.tabBar.items!
        let item1:UITabBarItem = allItems[0] as! UITabBarItem
        let item2:UITabBarItem = allItems[1] as! UITabBarItem
        let item3:UITabBarItem = allItems[2] as! UITabBarItem
        
        item1.image = UIImage(named: "tabbar_drop_icon-568h@2x.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        item2.image = UIImage(named: "tabbar_listing_pocket_icon-568h@2x.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        item3.image = UIImage(named: "tabbar_cooperation_program_icon-568h@2x.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        
        //圖案變色
        item1.selectedImage = UIImage(named: "tabbar_drop_icon_f-568h@2x.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        item2.selectedImage = UIImage(named: "tabbar_listing_pocket_icon_f-568h@2x.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        item3.selectedImage = UIImage(named: "tabbar_cooperation_program_icon_f-568h@2x.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        
        //文字變色
        item1.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.darkGrayColor()], forState: UIControlState.Normal)
        item1.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor(red: 218, green: 0, blue: 0, alpha: 1)], forState: UIControlState.Selected)
        
        item2.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.darkGrayColor()], forState: UIControlState.Normal)
        item2.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor(red: 218, green: 0, blue: 0, alpha: 1)], forState: UIControlState.Selected)
        
        item3.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.darkGrayColor()], forState: UIControlState.Normal)
        item3.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor(red: 218, green: 0, blue: 0, alpha: 1)], forState: UIControlState.Selected)
        
        if appdelegateObj.readNum > 0{
            item2.badgeValue = "\(appdelegateObj.readNum)"
        }
        else{
            item2.badgeValue = nil
        }
       
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
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
