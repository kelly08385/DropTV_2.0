//
//  programVC.swift
//  DropTV_2.0
//
//  Created by tw itri on 2016/2/15.
//  Copyright © 2016年 tw_itri. All rights reserved.
//

import Foundation
import SDWebImage

class programVC: UITableViewController,UIPopoverPresentationControllerDelegate {

    var dataArray = [AnyObject]()
    var myImages = [UIImage]()
    let appdelegateObj = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        appdelegateObj.programTable = self
        
        //設定reload data的通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(programVC.reloadData(_:)), name:"reload program data", object: nil)
        
        //去取program list
        if(appdelegateObj.pgNameArray.count == 0){
            appdelegateObj.getProgramList()
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //回傳有幾個節目
        return appdelegateObj.pgNameArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCellWithIdentifier("programCell", forIndexPath: indexPath) as! programCell
                
        if appdelegateObj.pgNameArray.count > 0 {
         
            var urlStr:String
            urlStr = appdelegateObj.pgImgArray[indexPath.row]
            let url = NSURL(string: urlStr)
            
            cell.myImage.sd_setImageWithURL(url, placeholderImage: nil)
            
            cell.myLabel.text = appdelegateObj.channelArray[indexPath.row] + "-" + appdelegateObj.pgNameArray[indexPath.row]
        }
        
        return cell
    }
    
    
    func reloadData(note: NSNotification){
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView.reloadData()
        })
    }
    
    //more popover------------------------
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
    //----------------------------------

}