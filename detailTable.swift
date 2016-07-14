//
//  detailTable.swift
//  DropTV_2.0
//
//  Created by tw itri on 2016/2/19.
//  Copyright © 2016年 tw_itri. All rights reserved.
//

import UIKit

class detailTable: UITableViewController {
    var tagID:Int = 0
    let appdelegateObj = UIApplication.sharedApplication().delegate as! AppDelegate
    var myImages = [UIImage]()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appdelegateObj.detailVC = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadData:", name:"reload detail data", object: nil)
        print(tagID)
        
        //將tabbar隱藏
       
        //self.tabBarController!.tabBar.hidden = true
         self.navigationController!.setToolbarHidden(false, animated: true)
        
        
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
        
        appdelegateObj.getTagDetail(tagID)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.hidesBottomBarWhenPushed = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
            self.tableView.reloadData()
            return
        })
    
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section==0 {
        let cell = tableView.dequeueReusableCellWithIdentifier("headCell", forIndexPath: indexPath) as! headCell
        cell.myTitle.text = appdelegateObj.titleStr
        cell.mySubTitle.text = appdelegateObj.subTitleStr

        return cell
        }
        else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCellWithIdentifier("topTagInfoCell", forIndexPath: indexPath) as! topTagInfoCell
            print(indexPath.row)
            
            if appdelegateObj.topimageArray.count > 0{
                //print(appdelegateObj.topimageArray[0])
                if let url = NSURL(string: appdelegateObj.topimageArray[indexPath.row]) {
                    if let data = NSData(contentsOfURL: url) {
                        cell.myImage.image = UIImage(data: data)
                    }
                }
            }
            return cell
        }
        else if indexPath.section == 2{
            let cell = tableView.dequeueReusableCellWithIdentifier("fieldCell", forIndexPath: indexPath) as! fieldCell
            if appdelegateObj.fieldArray.count > 0{
                print("index",indexPath.row)
                cell.myButton.setTitle(appdelegateObj.fieldArray[indexPath.row], forState: UIControlState.Normal)
                cell.myButton.tag = indexPath.row
                cell.myButton.addTarget(self, action: "fieldTab:", forControlEvents: .TouchUpInside)
                let index = appdelegateObj.fieldArray[indexPath.row].startIndex.advancedBy(2)
                let urlStr = appdelegateObj.fieldArray[indexPath.row].substringFromIndex(index)
                print (urlStr)
            }
            return cell
        }
        else{
            print("tagInfo")
            
            let cell = tableView.dequeueReusableCellWithIdentifier("tagInfoCell", forIndexPath: indexPath) as! tagInfoCell
            if appdelegateObj.infoCount > 0{
                if myImages.count == 0{
                    getImageUrl()
                }
                cell.myButton.tag = indexPath.row
                cell.myButton.addTarget(self, action: "didTab:", forControlEvents: .TouchUpInside)
                
                let height = myImages[indexPath.row].size.height
                let width = myImages[indexPath.row].size.width
                print(height,width)
                cell.myButton.frame = CGRectMake(5, 5, width, height)
                cell.myButton.setBackgroundImage(myImages[indexPath.row], forState: .Normal)
                
            }
            return cell
        }
        
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 100
        }
        else if indexPath.section == 1 {
            return 200
        }
        else if indexPath.section == 2 {
            return 50
        }
        else {
            return 200
        }
    }
    
    //將image存入array裡，較快
    func getImageUrl(){
        for var index = 0; index < appdelegateObj.infoCount; index++ {
            if let url = NSURL(string: appdelegateObj.infoImgArray[index]){
                if let data = NSData(contentsOfURL: url){
                    myImages.append(UIImage(data: data)!)
                }
            }
        }
    }
    
    func fieldUrlCtr(index:Int){
        
    
    }
    func fieldTab(sender: AnyObject) {
        var urlStr = appdelegateObj.fieldArray[sender.tag]
        let index = urlStr.startIndex.advancedBy(2)
        urlStr = urlStr.substringFromIndex(index)
        print(urlStr)
        UIApplication.sharedApplication().openURL(NSURL(string: urlStr)!)
    }
    func didTab(sender: AnyObject) {
        
        let urlStr = appdelegateObj.infoUrlArray[sender.tag]
        //urlStr = urlStr.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
        print(urlStr)
       UIApplication.sharedApplication().openURL(NSURL(string: urlStr)!)
    }

    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
