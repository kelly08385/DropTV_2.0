//
//  classifyVC.swift
//  DropTV_2.0
//
//  Created by tw itri on 2016/2/6.
//  Copyright © 2016年 tw_itri. All rights reserved.
//

import Foundation

//pocket中的分類table
class classifyVC: UITableViewController {
    
    var tableArray = [String]()
    var menuImgAry = [String]()
    var highmenuImgAry = [String]()
    
    
    override func viewDidLoad() {
        tableArray = ["全部","我的最愛",
                      "美食", "景點",
                      "人物介紹","女性時尚",
                      "男性時尚","美妝",
                      "運動", "3C",
                      "車款","好康",
                      "婦嬰","養生",
                      "居家","家電",
                      "影音","投票",
                      "節目資訊"]
        menuImgAry = ["menu_all_icon-568h@2x.png","menu_my_favorite_icon-568h@2x.png",
                      "menu_food_icon-568h@2x.png","menu_attractions_icon-568h@2x.png",
                      "menu_people_icon-568h@2x.png","menu_women_fashion_icon-568h@2x.png",
                      "menu_man_fashion_icon-568h@2x.png","menu_makeup_icon-568h@2x.png",
                      "menu_sport_icon-568h@2x.png", "menu_3c_icon-568h@2x.png",
                      "menu_car_icon-568h@2x.png", "menu_goodies_icon-568h@2x.png",
                      "menu_baby_icon-568h@2x.png","menu_health_icon-568h@2x.png",
                      "menu_home_icon-568h@2x.png","menu_appliances_icon-568h@2x.png",
                      "menu_video_icon-568h@2x.png","menu_vote_icon-568h@2x.png",
                      "menu_program_info_icon-568h@2x.png"]
        highmenuImgAry = ["menu_all_icon_f-568h@2x.png","menu_my_favorite_icon_f-568h@2x.png",
                      "menu_food_icon_f-568h@2x.png","menu_attractions_icon_f-568h@2x.png",
                      "menu_people_icon_f-568h@2x.png","menu_women_fashion_icon_f-568h@2x.png",
                      "menu_man_fashion_icon_f-568h@2x.png","menu_makeup_icon_f-568h@2x.png",
                      "menu_sport_icon_f-568h@2x.png", "menu_3c_icon_f-568h@2x.png",
                      "menu_car_icon_f-568h@2x.png", "menu_goodies_icon_f-568h@2x.png",
                      "menu_baby_icon_f-568h@2x.png","menu_health_icon_f-568h@2x.png",
                      "menu_home_icon_f-568h@2x.png","menu_appliances_icon_f-568h@2x.png",
                      "menu_video_icon_f-568h@2x.png","menu_vote_icon_f-568h@2x.png",
                      "menu_program_info_icon_f-568h@2x.png"]
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController!.tabBar.hidden = true
    }
    override func viewDidDisappear(animated: Bool) {
        self.tabBarController!.tabBar.hidden = false
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableArray.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("menucell", forIndexPath: indexPath) as! menuCell
        let image : UIImage = UIImage(named:"\(menuImgAry[indexPath.row])")!
        cell.menuImg.image = image
        cell.menuLb.text = tableArray[indexPath.row]
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red: 218/255, green: 59/255, blue: 38/255, alpha: 1)
        cell.selectedBackgroundView = backgroundView
        cell.menuImg.highlightedImage = UIImage(named: "\(highmenuImgAry[indexPath.row])")
        
        return cell
    }
    
    
    /* override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
     tableView.cellForRowAtIndexPath(indexPath)?.imageView?.tintColor = UIColor.whiteColor()
     
     //tableView.cellForRowAtIndexPath(indexPath)?.textLabel?.textColor = UIColor.whiteColor()
     }
     
     override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
     tableView.cellForRowAtIndexPath(indexPath)?.textLabel?.textColor = UIColor.blackColor()
     }*/
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "menuSegue" {
            let destVC = segue.destinationViewController as! pocketNav
            let indexPath:NSIndexPath = self.tableView.indexPathForSelectedRow!
            let DVC = destVC.viewControllers[0] as? pocketVC
            DVC!.menuNum = indexPath.row
            DVC!.wantUpdate = true
        }
        
    }
    
}