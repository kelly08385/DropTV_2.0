//
//  pocketVC.swift
//  DropTV_2.0
//
//  Created by tw itri on 2016/3/3.
//  Copyright © 2016年 tw_itri. All rights reserved.
//

import UIKit
import SDWebImage


class pocketVC: UIViewController , UITableViewDelegate, UITableViewDataSource,UIActionSheetDelegate,UIPopoverPresentationControllerDelegate{
    
    @IBOutlet weak var pocketTable: UITableView!
    @IBOutlet weak var delItem: UIBarButtonItem!
    @IBOutlet weak var classification: UIBarButtonItem!
    @IBOutlet weak var myToolbar: UIToolbar!
    @IBOutlet weak var moreBnt: UIBarButtonItem!
    
    //------------圖片宣告-----------
    let likeImage = UIImage(named: "listing_pocket_like_icon-568h@2x.png")?.imageWithRenderingMode(.AlwaysOriginal)
    let unlikeImage = UIImage(named:"listing_pocket_unlike_icon-568h@2x.png")?.imageWithRenderingMode(.AlwaysOriginal)
    let unselectImg = UIImage(named:"listing_pocket_check_box-568h@2x.png")?.imageWithRenderingMode(.AlwaysOriginal)
    let selectImg = UIImage(named:"listing_pocket_check_box_ok-568h@2x.png")?.imageWithRenderingMode(.AlwaysOriginal)
    let readImg = UIImage(named:"listing_pocket_unreader_icon-568h@2x.png")
    
    //-----------------------------
    
    let appdelegateObj = UIApplication.sharedApplication().delegate as! AppDelegate
    var rightbar:UIBarButtonItem?
    
  
    var isEdit:Bool = false
    var isAllSelect:Bool = false
    
    //是否要刪除
    var delArray = [Bool]()
    var delCount = 0
    var delList = [Int]()
    //---------
    
    //分類的index
    var menuNum:Int = 0
    var isSelectmenu:Bool = false
    var wantUpdate:Bool = false
    //-----------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("pockvc viewdidload")
        
        //------appdelegate可以呼叫func--------
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(pocketVC.reloadData(_:)), name:"reload pocketVC", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(pocketVC.loadSubview(_:)), name:"reload subview", object: nil)
        //-----------------------------------
        
        //------------------分類-------------------------
        classification.target = self.revealViewController()
        classification.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        //------------------------------------------------
        
        //------right bar-------
        rightbar = UIBarButtonItem(title: "選取", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(pocketVC.edit(_:)))
        self.navigationItem.setRightBarButtonItems([moreBnt,rightbar!], animated: true)
        //----------------------
        
        //tabbar 顯示，toolbar隱藏
        self.tabBarController!.tabBar.hidden = false
        self.myToolbar.hidden = true
        tabBadge()
        //--------------------
        
        appdelegateObj.mypocketVC = self
        pocketTable.delegate = self
        pocketTable.dataSource = self
        
        self.view.addSubview(self.noData)
        self.noData.hidden = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
       //從detail回來時，刪除detail所有資料
        removedetail()
        
        self.tabBarController!.tabBar.hidden = false
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.pocketTable.reloadData()
        })
        rightbar = UIBarButtonItem(title: "選取", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(pocketVC.edit(_:)))
        self.navigationItem.setRightBarButtonItems([moreBnt,rightbar!], animated: true)
    }
    override func viewDidAppear(animated: Bool) {
      
        print("pocket viewdidappear")
        //是不是有選擇menu，若沒有選擇，可以不用重跑reading list
        if wantUpdate == true {
            print("update")
            if menuNum == 0{
                appdelegateObj.getReadinglist(appdelegateObj.userUID)
            }
            else if menuNum == 1 {
                appdelegateObj.getReadinglistByFavorite(appdelegateObj.userUID)
            }
            else{
                appdelegateObj.getReadinglistByCategory(appdelegateObj.userUID,categoryid: menuNum-1)
            }
            wantUpdate = false
        }
        
        tabBadge()
    }
    
    //從detail 回來時刪除 detail所有資料
    func removedetail(){
        if appdelegateObj.titleStr != ""{
            appdelegateObj.titleStr = ""
            appdelegateObj.subTitleStr = ""
            
            //初始化
            //---------topCell-----------
            appdelegateObj.topUrlArray.removeAll()
            appdelegateObj.topimageArray.removeAll()
            appdelegateObj.topCount = 0
            //--------------------------
            
            //---------fieldCell--------
            appdelegateObj.fieldArray.removeAll()
            //--------------------------
            
            //---------infoCell---------
            appdelegateObj.infoUrlArray.removeAll()
            appdelegateObj.infoImgArray.removeAll()
            appdelegateObj.infoCount = 0
            //--------------------------
        }
        
    }
    
    //more選取
    @IBAction func moreSelect(sender: AnyObject) {
        performSegueWithIdentifier("morePush", sender: nil)
    }
    
    //rightbar選取
    func edit(sender:AnyObject){
        self.tabBarController!.tabBar.hidden = true
        self.myToolbar.hidden = false
        isEdit = true
        
        //重跑tableview
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.pocketTable.reloadData()
            print("reloadTable")
           // self.navigationItem.setLeftBarButtonItem(nil, animated: true)
            // self.navigationItem.leftBarButtonItem = nil
            self.navigationItem.leftBarButtonItem?.enabled = false
            
        })
        delCount = 0
        delItem.tintColor = UIColor.grayColor()
        rightbar?.title = "全選"
        rightbar?.action = #selector(pocketVC.allSelect(_:))
        
    }
    
    //全選
    func allSelect(sender:AnyObject){
        
        delCount = 0
        isAllSelect = true
        delItem.tintColor = UIColor.redColor()
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.pocketTable.reloadData()
            print("reloadTable")
            //self.navigationItem.setLeftBarButtonItem(nil, animated: true)
            // self.navigationItem.leftBarButtonItem = nil
        })
        
        
        rightbar?.title = "完成"
        rightbar?.action = #selector(pocketVC.overedit(_:))
    }
    
    //rightbar结束编辑
    func overedit(sender:AnyObject){
        
        self.tabBarController!.tabBar.hidden = false
        self.myToolbar.hidden = true
        isEdit = false
        isAllSelect = false
        
        //重跑tableview
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.pocketTable.reloadData()
            print("reloadTable")
            self.navigationItem.leftBarButtonItem?.enabled = true
        
        })
        rightbar?.title = "選取"
        rightbar?.action = #selector(pocketVC.edit(_:))
         
    }
    
    //更新table
    func reloadData(note: NSNotification){
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.pocketTable.hidden = false
            self.noData.hidden = true
            self.pocketTable.reloadData()
            
            print("reloadTable")
            
            self.tabBadge()
        })
    }
    
    //如果table沒有資料，顯示subview - "目前無任何資料"
    @IBOutlet weak var noData: UIView!
    func loadSubview(note: NSNotification){
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.pocketTable.hidden = true
            self.noData.hidden = false
           
            let moreItem = self.moreBnt
            self.navigationItem.setRightBarButtonItems([moreItem], animated: true)
            self.tabBadge()
        })
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appdelegateObj.titleArray.count
    }
    
    //table
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("pocketCell", forIndexPath: indexPath) as! pocketCell
        
        //顯示於Table View中
        cell.myTitle.text = appdelegateObj.titleArray[indexPath.row]
        cell.myCreateTime.text = appdelegateObj.createTimeArray[indexPath.row]
        
        //編輯｜最愛
        if isEdit {
            cell.myLikeButton.setImage(unselectImg, forState: .Normal)
            cell.myLikeButton.tag = indexPath.row
            delArray.append(false)
            cell.myLikeButton.addTarget(self, action: #selector(pocketVC.selectPress(_:)), forControlEvents: .TouchUpInside)
            
            //是否全選
            if isAllSelect {
                cell.myLikeButton.setImage(selectImg, forState: .Normal)
                delArray[indexPath.row] = true
                delCount += 1
            }
            
            //已讀|未讀
            if appdelegateObj.isRead[indexPath.row] == false{
                cell.isReadImg.image = readImg
            }
            else{
                cell.isReadImg.image = nil
            }
        }
        else{
            delArray.removeAll()
            //判斷每個cell是不是最愛
            
            if appdelegateObj.isFavorite[indexPath.row] == false{
                cell.myLikeButton.setImage(unlikeImage, forState: .Normal)
            }
            else{
                cell.myLikeButton.setImage(likeImage, forState: .Normal)
            }
            
            //判斷每個cell是不是已讀
            if appdelegateObj.isRead[indexPath.row] == false{
                cell.isReadImg.image = readImg
            }
            else{
                cell.isReadImg.image = nil
            }
            
            cell.myLikeButton.tag = indexPath.row
            cell.myLikeButton.addTarget(self, action: #selector(pocketVC.buttonPress(_:)), forControlEvents: .TouchUpInside)
        }
        
        //-----------load image-------------
        let imageView = cell.contentView.viewWithTag(100) as! UIImageView
        var urlStr:String
        urlStr = appdelegateObj.imageArray[indexPath.row]
        let url = NSURL(string: urlStr)
        imageView.sd_setImageWithURL(url, placeholderImage: nil)
        //----------------------------------
        
        return cell
    }
    
    
    //最愛 按鈕Action
    @IBAction func buttonPress(sender: AnyObject) {
        
        if isEdit{
            //確定不再編輯的頁面
        }
        else {
            let listID = appdelegateObj.listidArray[sender.tag]
            var status = 0
            
            if appdelegateObj.isFavorite[sender.tag] == true{
                appdelegateObj.isFavorite[sender.tag] = false
                sender.setImage(unlikeImage, forState: .Normal)
                status = 0
            }
            else{
                appdelegateObj.isFavorite[sender.tag] = true
                sender.setImage(likeImage, forState: .Normal)
                status = 1
            }
            appdelegateObj.UpdateReadinglistFavoriteStatus(appdelegateObj.userUID, listID: listID, status: status)
        }
    }
    
    //編輯 按鈕Action
    @IBAction func selectPress(sender: AnyObject) {
        
        if !isEdit{
            //確定在編輯頁面
        }
        else{
            if delArray[sender.tag] == false{
                sender.setImage(selectImg, forState: .Normal)
                delArray[sender.tag] = true
                delCount += 1
            }
            else{
                sender.setImage(unselectImg, forState: .Normal)
                delArray[sender.tag] = false
                delCount -= 1
            }
            
            //delItem顏色
            if delCount > 0 {
                delItem.tintColor = UIColor.redColor()
            }
            else{
                delItem.tintColor = UIColor.grayColor()
            }
        }
    }
    
    //刪除按下去，上浮選單
    @IBAction func delAct(sender: AnyObject) {
        if delCount > 0 {
            let alert=UIAlertController(title: "", message: "", preferredStyle: .ActionSheet)
            
            alert.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil));
            //event handler with closure
            alert.addAction(UIAlertAction(title: "刪除\(delCount)筆資料", style: UIAlertActionStyle.Destructive, handler: {(action:UIAlertAction) in
                var tempStr:String = ""
                
                for i in 0 ..< self.delArray.count {
                    if self.delArray[i] == true {
                        tempStr = tempStr + String(self.appdelegateObj.listidArray[i])
                        tempStr = tempStr + ","
                    }
                }
                let index = tempStr.startIndex.advancedBy(tempStr.characters.count - 1)
                tempStr = tempStr.substringToIndex(index)
                
                if(self.delCount == self.appdelegateObj.listidArray.count){
                    print("removeALL")
                    self.tabBarController!.tabBar.hidden = false
                    self.myToolbar.hidden = true
                    self.isEdit = false
                    self.isAllSelect = false
                }
                
                self.appdelegateObj.RemoveReadinglist(self.appdelegateObj.userUID,listID:tempStr)
                
                self.delCount = 0
                self.delArray.removeAll()
                self.delItem.tintColor = UIColor.grayColor()
                
                
                
            }));
            presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    // 刪除單個
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if !isEdit{
            if editingStyle == .Delete {
                appdelegateObj.titleArray.removeAtIndex(indexPath.row)
                let listID = appdelegateObj.listidArray[indexPath.row]
                appdelegateObj.RemoveReadinglist(appdelegateObj.userUID,listID: String(listID))
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                
                //-----------array刪除---------
                appdelegateObj.createTimeArray.removeAtIndex(indexPath.row)
                appdelegateObj.imageArray.removeAtIndex(indexPath.row)
                appdelegateObj.tagidArray.removeAtIndex(indexPath.row)
                appdelegateObj.listidArray.removeAtIndex(indexPath.row)
                appdelegateObj.isFavorite.removeAtIndex(indexPath.row)
                
                if appdelegateObj.isRead[indexPath.row] == false {
                    appdelegateObj.readNum-=1
                }
                appdelegateObj.isRead.removeAtIndex(indexPath.row)
                //----------------------------
                
            } else if editingStyle == .Insert {
                // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            }
        }
        
    }
    
    //判斷是不是進入編輯模式，不能push
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject!) -> Bool {
        
        let segueShouldOccur = isEdit
        if segueShouldOccur  {
            print("*** NOPE, segue wont occur")
            return false
        }
        else {
            print("*** YEP, segue will occur")
        }
        return true
    }
    
    //Push
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        //進入detail
        if segue.identifier == "seguePush" {
            let detailTableVC = segue.destinationViewController as! detailVC
            let row = self.pocketTable.indexPathForSelectedRow!.row
            let listID = appdelegateObj.listidArray[row]
            var favoriteStatus:Int = 0
            
            navigationItem.backBarButtonItem =  detailTableVC.delBnt
            detailTableVC.tagID = appdelegateObj.tagidArray[row]    //將tagID push 到 detail
            detailTableVC.listID = listID   //將listID push 到detail
            detailTableVC.detailRow = row   //將row push 到detail
            
            //點進去後設為已讀
            var status = 0
            if appdelegateObj.isRead[row] == false{
                appdelegateObj.isRead[row] = true
                appdelegateObj.readNum-=1
                status = 1
                appdelegateObj.UpdateReadinglistReadedStatus(appdelegateObj.userUID,listID: listID, status: status)
            }
            
            if appdelegateObj.isFavorite[row] == false{
                favoriteStatus = 1
            }
            detailTableVC.favoriteStatus = favoriteStatus
            
        }
            //more button push
        else if segue.identifier == "morePush"{
            let vc = segue.destinationViewController as! popTable
            let controller = vc.popoverPresentationController
            
            if controller != nil {
                controller?.delegate = self
            }
        }
    }
    
    //more popover
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
    
    //更新 tabbar badge number
    func tabBadge(){
        let tabArray = self.tabBarController?.tabBar.items as NSArray!
        let tabItem = tabArray.objectAtIndex(1) as! UITabBarItem
        if appdelegateObj.readNum > 0{
            tabItem.badgeValue = "\(appdelegateObj.readNum)"
        }
        else{
            tabItem.badgeValue = nil
        }
    }
    
}

