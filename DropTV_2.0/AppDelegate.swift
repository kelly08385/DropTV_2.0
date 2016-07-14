//
//  AppDelegate.swift
//  DropTV_2.0
//
//  Created by tw itri on 2016/2/6.
//  Copyright © 2016年 tw_itri. All rights reserved.
//

import UIKit
import Moscapsule

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    //mqtt連線參數--------------
    var mqttConfig: MQTTConfig! = nil
    var mqttClient: MQTTClient! = nil
    //---------------------------
    
    var window: UIWindow?
    
    var mypocketVC =  UIViewController()
    var detailVC = UIViewController()
    var programTable = UITableViewController()
    var dragVC = UIViewController()
    
    //---連到api參數----
    var apiUrl:String = "http://api.droptv.tv:8088/SmarttvWebServiceApiTopmso/"
    var totalUrl:String = ""
    var param:String = ""
    //------------------
    
    var tempStr:String = "" //用在mqtt
    var userUID:Int = 0 //用google登錄後得到的uid(使用者代號)
    
    //----------pocketTable----------
    var titleArray = [String]()
    var createTimeArray = [String]()
    var imageArray = [String]()
    var tagidArray = [Int]()
    var listidArray = [Int]()
    var isFavorite = [Bool]()
    var isRead = [Bool]()
    var readNum = 0
    //-------------------------------
    
    //---------headCell----------
    var titleStr:String = ""
    var subTitleStr:String = ""
    //---------------------------
    
    //---------topCell-----------
    var topUrlArray = [String]()
    var topimageArray = [String]()
    var topCount:Int = 0
    //--------------------------
    
    //---------fieldCell--------
    var fieldArray = [String]()
    //--------------------------
    
    //---------infoCell---------
    var infoUrlArray = [String]()
    var infoImgArray = [String]()
    var infoCount:Int = 0
    //--------------------------
    
    //--------program-----------
    var channelArray = [String]()
    var pgNameArray = [String]()
    var pgImgArray = [String]()
    //--------------------------
    
    //--------dragVC(mqtt)--------
    var mqttTagid = [Int]()
    var mqttProgram = [String]()
    var mqttColor = [String]()
    var mqttPgname = [String]()
    var mqttchicon = [String]()
    //--------------------------
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        // Initialize sign-in
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        GIDSignIn.sharedInstance().delegate = self
        
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        
    }
    
    //app一打開先進行mqtt連線和get reading list
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        if self.mqttTagid.count == 0{
            self.connect()
        }
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //google sign in--------------------
    func application(application: UIApplication,
                     openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        /*  var options: [String: AnyObject] = [UIApplicationOpenURLOptionsSourceApplicationKey: sourceApplication!,
         UIApplicationOpenURLOptionsAnnotationKey: annotation]*/
        
        return GIDSignIn.sharedInstance().handleURL(url,
                                                    sourceApplication: sourceApplication,
                                                    annotation: annotation)
    }
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!,
                withError error: NSError!) {
        //若成功登錄
        if (error == nil) {
            let givenName = user.profile.givenName
            let email = user.profile.email
            
            NSNotificationCenter.defaultCenter().postNotificationName(
                "ToggleAuthUINotification",
                object: nil,
                userInfo: ["statusText": "Signed in user:\n\(givenName)"])
            //-----畫面跳轉---
            let myStoryboard:UIStoryboard = UIStoryboard(name:"Main",bundle:nil)
            let tabbarPage = myStoryboard.instantiateViewControllerWithIdentifier("CustomTabBarController") as! CustomTabBarController
            self.window?.rootViewController = tabbarPage
            //---------------
            addUser(email)
            
        } else {
            print("\(error.localizedDescription)")
        }
    }
    
    //新增user，得到uid
    func addUser(email:String){
        totalUrl = "\(apiUrl)AddUser"
        param = "account=\(email)&customerno=AB1234&customeraccount=0937111111"
        let request:NSMutableURLRequest = self.urlRequest(totalUrl, paramStr: param)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                return
            }
            
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("responseString = \(responseString)")
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                if let users = json["user"] as? [[String:AnyObject]]{
                    
                    for user in users {
                        if let uid = user["uid"]as? Int{
                            self.userUID = uid
                        }
                    }
                }
                //得到那個user的reading list
                self.getReadinglist(self.userUID)
            }catch{
                print("error serializing JSON: \(error)")
            }
        }
        task.resume()
    }
    
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!,
                withError error: NSError!) {
        // Perform any operations when the user disconnects from app here.
        // [START_EXCLUDE]
        NSNotificationCenter.defaultCenter().postNotificationName(
            "ToggleAuthUINotification",
            object: nil,
            userInfo: ["statusText": "User has disconnected."])
        // [END_EXCLUDE]
    }
    //--------------------------------------------------
    
    //用post的方式傳遞資料
    func urlRequest(urlStr:String, paramStr:String)->NSMutableURLRequest{
        let url:NSURL = NSURL(string: urlStr)!;
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 10);
        request.HTTPMethod = "POST";
        request.HTTPBody = "\(paramStr)".dataUsingEncoding(NSUTF8StringEncoding)
        return request
    }
    
    //全部reading list
    func getReadinglist(uid:Int){
        
        //清除pocket array
        if titleArray.count > 0 {
            removeArray()
        }
        
        totalUrl = "\(apiUrl)GetReadinglist"
        param = "uid=\(uid)&index=1&num=10"
        
        let request:NSMutableURLRequest = self.urlRequest(totalUrl, paramStr: param)
        readinglistJsonFunc(request)
    }
    
    //分類reading list
    func getReadinglistByCategory(uid:Int, categoryid:Int){
        
        if titleArray.count > 0 {
            removeArray()
        }
        
        totalUrl = "\(apiUrl)GetReadinglistByCategory"
        param = "uid=\(uid)&categoryid=\(categoryid)&index=1&num=10"
        let request:NSMutableURLRequest = self.urlRequest(totalUrl, paramStr: param)
        readinglistJsonFunc(request)
        
    }
    
    //我的最愛reading list
    func getReadinglistByFavorite(uid:Int){
        if titleArray.count > 0 {
            removeArray()
        }
        
        totalUrl = "\(apiUrl)GetReadinglistByFavorite"
        param = "uid=\(uid)&index=1&num=10"
        let request:NSMutableURLRequest = self.urlRequest(totalUrl, paramStr: param)
        readinglistJsonFunc(request)
        
    }
    
    //清除pocket array
    func removeArray(){
        titleArray.removeAll()
        createTimeArray.removeAll()
        imageArray.removeAll()
        tagidArray.removeAll()
        listidArray.removeAll()
        isFavorite.removeAll()
        isRead.removeAll()
        self.readNum = 0
    }
    
    //reading list json 放到 array
    func readinglistJsonFunc(request:NSMutableURLRequest){
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                return
            }
            
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("responseString = \(responseString)")
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                
                if let readinglists = json["readinglist"] as? [[String: AnyObject]] {
                    for list in readinglists {
                        if let readinglistid = list["readinglistid"]as? Int{
                            self.listidArray.append(readinglistid)
                        }
                        if let title = list["title"] as? String {
                            self.titleArray.append(title)
                        }
                        if let image = list["img"] as? String{
                            self.imageArray.append(image)
                        }
                        if let tagid = list["tagid"] as? Int{
                            self.tagidArray.append(tagid)
                        }
                        if let createtime = list["createtime"] as? String{
                            self.createTimeArray.append(createtime)
                        }
                        if let isfavorite = list["isfavorite"] as? Bool {
                            self.isFavorite.append(isfavorite)
                        }
                        if let isReaded = list["isreaded"] as? Bool {
                            self.isRead.append(isReaded)
                            if isReaded == false{   //還沒讀
                                self.readNum+=1
                            }
                        }
                    }
                    
                }
            } catch {
                print("error serializing JSON: \(error)")
            }
            
            print("listarraycount:\(self.listidArray.count)")
            //若沒有資料需列出沒有資料
            if self.listidArray.count == 0{
                NSNotificationCenter.defaultCenter().postNotificationName("reload subview", object: nil)
            }
            else {
                NSNotificationCenter.defaultCenter().postNotificationName("reload pocketVC", object: nil)
            }
        }
        
        task.resume()
        
    }
    
    //點擊drag button加到pocket，更新reading list
    func AddReadinglist(uid:Int,tagid:Int){
        totalUrl = "\(apiUrl)AddReadinglist"
        param = "uid=\(uid)&tagid=\(tagid)"
        let request:NSMutableURLRequest = self.urlRequest(totalUrl, paramStr: param)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                return
            }
            
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("responseString = \(responseString)")
            self.getReadinglist(self.userUID)
        }
        
        task.resume()
    }
    
    //刪除pocket裡的某些資料，更新reading list
    func RemoveReadinglist(uid:Int,listID:String){
        totalUrl = "\(apiUrl)RemoveReadinglist"
        param = "uid=\(uid)&readinglistid=\(listID)"
        
        let request:NSMutableURLRequest = self.urlRequest(totalUrl, paramStr: param)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                return
            }
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("responseString = \(responseString)")
            self.getReadinglist(self.userUID)
        }
        task.resume();
    }
    
    //得到detail 並且存到array
    func getTagDetail(tagID:Int){
        totalUrl = "\(apiUrl)GetTagDetail"
        param = "tagid=\(tagID)"
        
        let request:NSMutableURLRequest = self.urlRequest(totalUrl, paramStr: param)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                return
            }
            
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                
                if let title = json["title"] as? String {
                    self.titleStr = title
                }
                if let subTitle = json["subtitle"] as? String{
                    self.subTitleStr = subTitle
                    
                }
                
                if let toptaginfos = json["toptaginfo"] as? [[String:AnyObject]]{
                    for toptaginfo in toptaginfos{
                        if let url = toptaginfo["url"]{
                            self.topUrlArray.append(url as! String)
                        }
                        if let img = toptaginfo["img"]{
                            self.topimageArray.append(img as! String)
                        }
                    }
                    self.topCount = self.topUrlArray.count
                }
                //field array 當field 有東西才存入
                if let field = json["field1"] as? String{
                    if !field.isEmpty{
                        self.fieldArray.append(field)
                    }
                }
                if let field = json["field2"] as? String{
                    if !field.isEmpty{
                        self.fieldArray.append(field)
                    }
                }
                if let field = json["field3"] as? String{
                    if !field.isEmpty{
                        self.fieldArray.append(field)
                    }
                }
                if let field = json["field4"] as? String{
                    if !field.isEmpty{
                        self.fieldArray.append(field)
                    }
                }
                if let field = json["field5"] as? String{
                    if !field.isEmpty{
                        self.fieldArray.append(field)
                    }
                }
                if let taginfos = json["taginfo"] as? [[String:AnyObject]]{
                    for taginfo in taginfos{
                        if let url = taginfo["url"]{
                            self.infoUrlArray.append(url as! String)
                        }
                        if let img = taginfo["img"]{
                            self.infoImgArray.append(img as! String)
                            
                        }
                    }
                    self.infoCount = self.infoImgArray.count
                }
                
            } catch {
                print("error serializing JSON: \(error)")
            }
            
            NSNotificationCenter.defaultCenter().postNotificationName("reload detail data", object: nil)
            
        }
        task.resume();
        
    }
    
    //更新favorite
    func UpdateReadinglistFavoriteStatus
        (uid:Int,listID:Int,status:Int){
        totalUrl = "\(apiUrl)UpdateReadinglistFavoriteStatus"
        param = "uid=\(uid)&readinglistid=\(listID)&status=\(status)"
        
        let request:NSMutableURLRequest = self.urlRequest(totalUrl, paramStr: param)
        doRequest(request)
    }
    
    //更新已讀
    func UpdateReadinglistReadedStatus(uid:Int,listID:Int,status:Int){
        totalUrl = "\(apiUrl)UpdateReadinglistReadedStatus"
        param = "uid=\(uid)&readinglistid=\(listID)&status=\(status)"
        
        let request:NSMutableURLRequest = self.urlRequest(totalUrl, paramStr: param)
        doRequest(request)
    }
    
    //做request
    func doRequest(request:NSMutableURLRequest){
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                return
            }
            
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("responseString = \(responseString)")
        }
        task.resume()
        
    }
    
    //getProgramList
    func getProgramList(){
        totalUrl = "\(apiUrl)GetProgramlist"
        param = "index=1&num=25"
        let request:NSMutableURLRequest = self.urlRequest(totalUrl, paramStr: param)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                return
            }
            
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("responseString = \(responseString)")
            
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                
                if let readinglists = json["program"] as? [[String: AnyObject]] {
                    for list in readinglists {
                        if let channelname = list["channelname"] as? String {
                            self.channelArray.append(channelname)
                        }
                        if let pgname = list["pgname"] as? String{
                            self.pgNameArray.append(pgname)
                        }
                        if let pgscreenshot = list["pgscreenshot"] as? String{
                            self.pgImgArray.append(pgscreenshot)
                        }
                    }
                }
            } catch {
                print("error serializing JSON: \(error)")
            }
            NSNotificationCenter.defaultCenter().postNotificationName("reload program data", object: nil)
        }
        task.resume();
    }
    
    //mqtt連線
    func connect(){
        self.mqttConfig = MQTTConfig(clientId: "cid", host: "warpush.openapis.io", port: 1883, keepAlive: 6000)
        self.mqttConfig.onPublishCallback = { messageId in
            print("success")
            print("published (mid=\(messageId))")
        }
        self.mqttConfig.onMessageCallback = { mqttMessage in
            
            self.tempStr = self.tempStr + mqttMessage.payloadString!
            
            self.jsonfunc(mqttMessage.payload)
        }
        
        self.mqttClient = MQTT.newConnection(self.mqttConfig)
        self.mqttClient.subscribe("#", qos: 2)
        
    }
    
    //mqtt 得到的資料存到array裡
    func jsonfunc(data:NSData){
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            
            if let tagid = json["tagid"]as? [Int]{
                if tagid != [] {
                    mqttTagid.append(tagid[0])
                    if let pgname = json["pgname"]as? String{
                        mqttPgname.append(pgname)
                    }
                    if let colorCode = json["colorCode"]as? String{
                        mqttColor.append(colorCode)
                    }
                    if let chicon = json["chicon"]as? String{
                        mqttchicon.append(chicon)
                    }
                }
            }
            
        }catch {
            print("error serializing JSON: \(error)")
        }
        
    }
    
}

