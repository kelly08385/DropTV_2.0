//
//  pocketNavigationVC.swift
//  DropTV_2.0
//
//  Created by tw itri on 2016/2/26.
//  Copyright © 2016年 tw_itri. All rights reserved.
//

import UIKit

class pocketNavigationVC: UINavigationController {

    @IBOutlet weak var myToolbar: UIToolbar!
    var shopImg: UIImage = UIImage(named: "toolbar_shopping_icon-568h@2x.png")!
    var delImg: UIImage = UIImage(named: "toolbar_delete_icon-568h@2x.png")!
    var gooImg: UIImage = UIImage(named: "toolbar_google_icon-568h@2x.png")!
    var shareImg: UIImage = UIImage(named: "toolbar_share_icon-568h@2x.png")!
    var likeImg: UIImage = UIImage(named: "toolbar_like_icon-568h@2x.png")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // var items = [AnyObject]()
        
        let item1 = UIBarButtonItem(title: "Continue", style: .Plain, target: self, action: "test1:")
        let item2 = UIBarButtonItem(title: "Delete", style: .Plain, target: self, action: "test2:")
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            item1.setBackgroundImage(self.shopImg, forState: .Normal, barMetrics: .Default)
            item2.setBackgroundImage(self.delImg, forState: .Normal, barMetrics: .Default)
            return
        })
       
        
        myToolbar.setItems([item1,item2], animated: true)
        //myToolBar.setItems([item1,item2], animated: true)
        myToolbar.barTintColor = UIColor.redColor()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func test1(){
        print("hu")
    }
    func test2(){
        print("fr")
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
