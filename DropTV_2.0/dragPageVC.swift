//
//  dragPageVC.swift
//  DropTV_2.0
//
//  Created by tw itri on 2016/7/6.
//  Copyright © 2016年 tw_itri. All rights reserved.
//

import UIKit

class dragPageVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UIPopoverPresentationControllerDelegate {
    let appdelegateObj = UIApplication.sharedApplication().delegate as! AppDelegate
    
    @IBOutlet weak var dropCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        
        
    }
    override func viewDidAppear(animated: Bool) {
         self.dropCollection.reloadData()
        //tabbar badge 更新
        let tabArray = self.tabBarController?.tabBar.items as NSArray!
        let tabItem = tabArray.objectAtIndex(1) as! UITabBarItem
        if appdelegateObj.readNum > 0{
            tabItem.badgeValue = "\(appdelegateObj.readNum)"
        }
        else{
            tabItem.badgeValue = nil
        }
        
    }
    
    //show more popover
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showMore" {
            let vc = segue.destinationViewController as! popTable
            let controller = vc.popoverPresentationController
            
            if controller != nil {
                controller?.delegate = self
                
            }
            
        }
    }
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
    //----------------------------------------------
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        let frame  = self.view.frame;
        
        var width = frame.width
        //抓button自適應
        var cut:CGFloat = 12
        if (width < 400){
            cut = 4
        }
        var height = frame.height
        let tabbarH = (self.tabBarController?.tabBar.frame.size.height)!
        let navigationH = (self.navigationController?.navigationBar.frame.size.height)!
        
        width = CGFloat(Int((width - cut)/2))
        height = CGFloat((height - navigationH - tabbarH - 16)/4)
        
        return CGSize(width: width, height: height)
    }
    
   /* let sectionInsets = UIEdgeInsets(top:4, left: 4, bottom: 4, right: 4)
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets{
        return sectionInsets
    }*/
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.appdelegateObj.mqttTagid.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("dragPageCell", forIndexPath: indexPath) as! dragPageCell
        
        self.backgroundIcon(cell.dragBnt,chicon: self.appdelegateObj.mqttchicon[indexPath.row])
        cell.dragLb.text = self.appdelegateObj.mqttPgname[indexPath.row]
        
        cell.dragBnt.tag = self.appdelegateObj.mqttTagid[indexPath.row]
        cell.dragBnt.addTarget(self, action: #selector(self.numberClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        return cell
    }
    
    //點擊button時
    func numberClick(sender:UIButton){
        //新增至reading list
        appdelegateObj.AddReadinglist(appdelegateObj.userUID, tagid:sender.tag)
        
        //更新badge value
        let tabArray = self.tabBarController?.tabBar.items as NSArray!
        let tabItem = tabArray.objectAtIndex(1) as! UITabBarItem
        if appdelegateObj.readNum > 0{
            tabItem.badgeValue = "\(appdelegateObj.readNum)"
        }
        else{
            tabItem.badgeValue = nil
        }
        //-------------
    }
    
    //按鈕背景圖片
    func backgroundIcon(bnt:UIButton, chicon:String){
        switch chicon{
        case "00001":
            bnt.setBackgroundImage(UIImage(named: "drop_button_01-568h@2x.png"), forState: .Normal)
        case "00002":
            bnt.setBackgroundImage(UIImage(named: "drop_button_02-568h@2x.png"), forState: .Normal)
        case "00003":
            bnt.setBackgroundImage(UIImage(named: "drop_button_03-568h@2x.png"), forState: .Normal)
        case "00004":
            bnt.setBackgroundImage(UIImage(named: "drop_button_04-568h@2x.png"), forState: .Normal)
        case "00005":
            bnt.setBackgroundImage(UIImage(named: "drop_button_05-568h@2x.png"), forState: .Normal)
        case "00006":
            bnt.setBackgroundImage(UIImage(named: "drop_button_06-568h@2x.png"), forState: .Normal)
        case "00007":
            bnt.setBackgroundImage(UIImage(named: "drop_button_07-568h@2x.png"), forState: .Normal)
        case "00008":
            bnt.setBackgroundImage(UIImage(named: "drop_button_08-568h@2x.png"), forState: .Normal)
        case "00009":
            bnt.setBackgroundImage(UIImage(named: "drop_button_09-568h@2x.png"), forState: .Normal)
        case "00010":
            bnt.setBackgroundImage(UIImage(named: "drop_button_10-568h@2x.png"), forState: .Normal)
        case "00011":
            bnt.setBackgroundImage(UIImage(named: "drop_button_11-568h@2x.png"), forState: .Normal)
        case "00012":
            bnt.setBackgroundImage(UIImage(named: "drop_button_12-568h@2x.png"), forState: .Normal)
        case "00013":
            bnt.setBackgroundImage(UIImage(named: "drop_button_13-568h@2x.png"), forState: .Normal)
        case "00014":
            bnt.setBackgroundImage(UIImage(named: "drop_button_14-568h@2x.png"), forState: .Normal)
        case "00015":
            bnt.setBackgroundImage(UIImage(named: "drop_button_15-568h@2x.png"), forState: .Normal)
        case "00016":
            bnt.setBackgroundImage(UIImage(named: "drop_button_16-568h@2x.png"), forState: .Normal)
        case "00017":
            bnt.setBackgroundImage(UIImage(named: "drop_button_17-568h@2x.png"), forState: .Normal)
        case "00018":
            bnt.setBackgroundImage(UIImage(named: "drop_button_18-568h@2x.png"), forState: .Normal)
        case "00019":
            bnt.setBackgroundImage(UIImage(named: "drop_button_19-568h@2x.png"), forState: .Normal)
        case "00020":
            bnt.setBackgroundImage(UIImage(named: "drop_button_20-568h@2x.png"), forState: .Normal)
        case "00021":
            bnt.setBackgroundImage(UIImage(named: "drop_button_21-568h@2x.png"), forState: .Normal)
        case "00022":
            bnt.setBackgroundImage(UIImage(named: "drop_button_22-568h@2x.png"), forState: .Normal)
        case "00023":
            bnt.setBackgroundImage(UIImage(named: "drop_button_23-568h@2x.png"), forState: .Normal)
        case "00024":
            bnt.setBackgroundImage(UIImage(named: "drop_button_24-568h@2x.png"), forState: .Normal)
        case "00025":
            bnt.setBackgroundImage(UIImage(named: "drop_button_25-568h@2x.png"), forState: .Normal)
        case "00026":
            bnt.setBackgroundImage(UIImage(named: "drop_button_26-568h@2x.png"), forState: .Normal)
        case "00027":
            bnt.setBackgroundImage(UIImage(named: "drop_button_27-568h@2x.png"), forState: .Normal)
        case "00028":
            bnt.setBackgroundImage(UIImage(named: "drop_button_28-568h@2x.png"), forState: .Normal)
        case "00029":
            bnt.setBackgroundImage(UIImage(named: "drop_button_29-568h@2x.png"), forState: .Normal)
        case "00030":
            bnt.setBackgroundImage(UIImage(named: "drop_button_30-568h@2x.png"), forState: .Normal)
        case "00031":
            bnt.setBackgroundImage(UIImage(named: "drop_button_31-568h@2x.png"), forState: .Normal)
        case "00032":
            bnt.setBackgroundImage(UIImage(named: "drop_button_32-568h@2x.png"), forState: .Normal)
        case "00033":
            bnt.setBackgroundImage(UIImage(named: "drop_button_33-568h@2x.png"), forState: .Normal)
        case "00034":
            bnt.setBackgroundImage(UIImage(named: "drop_button_34-568h@2x.png"), forState: .Normal)
        case "00035":
            bnt.setBackgroundImage(UIImage(named: "drop_button_35-568h@2x.png"), forState: .Normal)
        case "00036":
            bnt.setBackgroundImage(UIImage(named: "drop_button_36-568h@2x.png"), forState: .Normal)
        case "00037":
            bnt.setBackgroundImage(UIImage(named: "drop_button_37-568h@2x.png"), forState: .Normal)
        case "00038":
            bnt.setBackgroundImage(UIImage(named: "drop_button_38-568h@2x.png"), forState: .Normal)
        case "00039":
            bnt.setBackgroundImage(UIImage(named: "drop_button_39-568h@2x.png"), forState: .Normal)
        case "00040":
            bnt.setBackgroundImage(UIImage(named: "drop_button_40-568h@2x.png"), forState: .Normal)
        default:
            bnt.setBackgroundImage(UIImage(named: "drop_button_01-568h@2x.png"), forState: .Normal)
        }
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
