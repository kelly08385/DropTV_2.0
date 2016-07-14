//
//  detailVC.swift
//  DropTV_2.0
//
//  Created by tw itri on 2016/2/26.
//  Copyright © 2016年 tw_itri. All rights reserved.
//

import UIKit
import SDWebImage

class detailVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var detailTable: UITableView!
    @IBOutlet weak var myToolbar: UIToolbar!
    
    var tagID:Int = 0
    var listID:Int = 0
    var detailRow:Int = 0
    var favoriteStatus:Int = 0
    let appdelegateObj = UIApplication.sharedApplication().delegate as! AppDelegate
    var myImages = [UIImage]()
    
    //-----------toolbar set-------------
    var shopImg: UIImage = UIImage(named: "toolbar_shopping_icon-568h@2x.png")!
    var delImg: UIImage = UIImage(named: "toolbar_delete_icon-568h@2x.png")!
    var gooImg: UIImage = UIImage(named: "toolbar_google_icon-568h@2x.png")!
    var shareImg: UIImage = UIImage(named: "toolbar_share_icon-568h@2x.png")!
    var likeImg: UIImage = UIImage(named: "toolbar_like_icon-568h@2x.png")!
    var unlikeImg:UIImage = UIImage(named: "toolbar_unlike_icon-568h@2x.png")!
    
    @IBOutlet weak var shopBnt: UIBarButtonItem!
    @IBOutlet weak var delBnt: UIBarButtonItem!
    @IBOutlet weak var gooBnt: UIBarButtonItem!
    @IBOutlet weak var shareBnt: UIBarButtonItem!
    @IBOutlet weak var likeBnt: UIBarButtonItem!
    //------------------------------------
    
    var webIcon: UIImage = UIImage(named: "detail_web_icon-568h@2x.png")!
    var addressIcon: UIImage = UIImage(named: "detail_address_icon-568h@2x.png")!
    var phoneIcon: UIImage = UIImage(named: "detail_phone_icon-568h@2x.png")!
    var timeIcon: UIImage = UIImage(named: "detail_time_icon-568h@2x.png")!
    var infoIcon: UIImage = UIImage(named: "detail_info_icon-568h@2x.png")!
    var playIcon: UIImage = UIImage(named: "detail_play_icon-568h@2x.png")!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         print("detail view did load")
        //reload table notification
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(detailVC.reloadData(_:)), name:"reload detail data", object: nil)
        
        //tab bar 隱藏
        self.tabBarController!.tabBar.hidden = true
        
        appdelegateObj.detailVC = self
        detailTable.delegate = self
        detailTable.dataSource = self
        
        detailTable.rowHeight = UITableViewAutomaticDimension
        detailTable.estimatedRowHeight = 200
       
      
        //我的最愛按鈕-------
        if favoriteStatus == 0 {
            likeBnt.image = likeImg
        }
        else{
            likeBnt.image = unlikeImg
        }
        //-----------------
        
    }
    override func viewWillAppear(animated: Bool) {
        print("detailview will appear")
        //利用tagID抓detail
        appdelegateObj.getTagDetail(tagID)
        detailTable.rowHeight = UITableViewAutomaticDimension
        detailTable.estimatedRowHeight = 200
    }
    override func viewDidAppear(animated: Bool) {
        print("detailview did appear")
        detailTable.reloadData()
    }
    
    @IBAction func shopAct(sender: AnyObject) {
        print("this is shop")
    }
    
    //刪除
    @IBAction func delAct(sender: AnyObject) {
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.appdelegateObj.RemoveReadinglist(self.appdelegateObj.userUID,listID: String(self.listID))
        })
        
        self.performSegueWithIdentifier("delSegue", sender: sender)
        
    }
    
    //利用title來做google搜尋
    @IBAction func gooAct(sender: AnyObject) {

        var urlString: String = appdelegateObj.titleStr
        
        urlString = urlString.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        urlString = urlString.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
        
        let url = NSURL(string: "http://www.google.com/webhp?sourceid=chrome-instant&ion=1&espv=2&ie=UTF-8#q=\(urlString)")
        
        UIApplication.sharedApplication().openURL(url!)
        
    }
    
    //share
    @IBAction func shareAct(sender: AnyObject) {
        let textToShare = "\(appdelegateObj.titleStr)"
        
            let objectsToShare = [textToShare]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            self.presentViewController(activityVC, animated: true, completion: nil)
       
    }
    
    //加入最愛
    @IBAction func likeAct(sender: AnyObject) {
        appdelegateObj.UpdateReadinglistFavoriteStatus(appdelegateObj.userUID,listID: listID, status: favoriteStatus)
        
        if favoriteStatus == 0 {
            favoriteStatus = 1
            likeBnt.image = unlikeImg
            appdelegateObj.isFavorite[detailRow] = false
        }
        else{
            favoriteStatus = 0
            likeBnt.image = likeImg
            appdelegateObj.isFavorite[detailRow] = true
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }
    
    //不同section的數量
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0{
            return 1
        }
        else if section == 1{
            return appdelegateObj.topCount
        }
        else if section == 2{
            return appdelegateObj.fieldArray.count
        }
        else{
            return appdelegateObj.infoCount
        }
    }
    func reloadData(note: NSNotification){
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.detailTable.reloadData()
            //return
        })
        
    }
    
    //不同section有不同view
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //標題
        if indexPath.section==0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("headCell", forIndexPath: indexPath) as! headCell
            cell.myTitle.text = appdelegateObj.titleStr
            cell.mySubTitle.text = appdelegateObj.subTitleStr
            
            return cell
        }
        //top tag info
        else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCellWithIdentifier("topTagInfoCell", forIndexPath: indexPath) as! topTagInfoCell
            
            //影片播放按鈕
            if appdelegateObj.topUrlArray[indexPath.row] != "" {
                cell.playBnt.setBackgroundImage(playIcon, forState: .Normal)
                cell.playBnt.tag = indexPath.row
                cell.playBnt.addTarget(self, action: #selector(detailVC.playVideo(_:)), forControlEvents: .TouchUpInside)
            }
            else{
                cell.playBnt.setBackgroundImage(nil, forState: .Normal)
            }
            
            //圖片設定
            var urlStr:String
            urlStr = appdelegateObj.topimageArray[indexPath.row]
            let url = NSURL(string: urlStr)
            cell.myImage.sd_setImageWithURL(url, placeholderImage: nil)
            
            return cell
        }
        //資訊
        else if indexPath.section == 2{
            let cell = tableView.dequeueReusableCellWithIdentifier("fieldCell", forIndexPath: indexPath) as! fieldCell
            
            if appdelegateObj.fieldArray.count > 0{
                
                var index = appdelegateObj.fieldArray[indexPath.row].startIndex.advancedBy(2)
                let urlStr = appdelegateObj.fieldArray[indexPath.row].substringFromIndex(index)
                index = appdelegateObj.fieldArray[indexPath.row].startIndex.advancedBy(0)
                let type:Character = appdelegateObj.fieldArray[indexPath.row][index]
                
                if type == "A" {
                    cell.iconImg.image = addressIcon
                }
                else if type == "P" {
                    cell.iconImg.image = phoneIcon
                }
                else if type == "T" {
                    cell.iconImg.image = timeIcon
                }
                else if type == "U" {
                    cell.iconImg.image = webIcon
                }
                else if type == "I" {
                    cell.iconImg.image = infoIcon
                }
                cell.iconImg.contentMode = .ScaleAspectFill
                cell.fieldInfo.text = urlStr
                
            }
            return cell
        }
        else{
            
          //  let testImg: UIImage = UIImage(named:"detail_no_photo_art-568h@2x.png")!
            let tempImg = UIImageView (image: UIImage (named: "detail_no_photo_art-568h@2x.png"))
            
            
            //tempImg.contentMode = .ScaleAspectFit
            
            let cell = tableView.dequeueReusableCellWithIdentifier("tagInfoCell", forIndexPath: indexPath) as! tagInfoCell
            cell.myButton.contentMode = .ScaleAspectFit
            //cell.myButton.contentVerticalAlignment = .Fill
             //   cell.myButton.contentHorizontalAlignment = .Fill
            if appdelegateObj.infoCount > 0{
                var urlStr:String
                urlStr = appdelegateObj.infoImgArray[indexPath.row]
                let url = NSURL(string: urlStr)
               
                cell.myButton.sd_setBackgroundImageWithURL(url, forState: .Normal, placeholderImage: tempImg.image)
                
                
                cell.myButton.tag = indexPath.row
                cell.myButton.addTarget(self, action: #selector(detailVC.didTab(_:)), forControlEvents: .TouchUpInside)
                
                
                
            }
            cell.setNeedsUpdateConstraints()
            cell.updateConstraintsIfNeeded()
            
            return cell
        }
    }
    
    //連到url網頁
    func didTab(sender: AnyObject) {
        
        let urlStr = appdelegateObj.infoUrlArray[sender.tag]
        UIApplication.sharedApplication().openURL(NSURL(string: urlStr)!)
    }
    
    //播放影片
    func playVideo(sender: AnyObject) {
        let urlStr = appdelegateObj.topUrlArray[sender.tag]
        UIApplication.sharedApplication().openURL(NSURL(string: urlStr)!)
    }
    
    
    //table view section row 高度(動態)
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 70
        }
        else if indexPath.section == 1 {
            return 250
        }
        else if indexPath.section == 2 {
            return UITableViewAutomaticDimension
        }
        else {
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 70
        }
        else if indexPath.section == 1 {
            return 250
        }
        else if indexPath.section == 2 {
            return UITableViewAutomaticDimension
        }
        else {
            return UITableViewAutomaticDimension
        }
    }
    //--------------------------------------
    
    
    
    
    
    
}
