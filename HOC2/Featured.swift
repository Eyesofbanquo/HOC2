//
//  Featured.swift
//  HOC2
//
//  Created by Markim Shaw on 4/27/16.
//  Copyright © 2016 Markim Shaw. All rights reserved.
//


import UIKit
import Alamofire
import CoreData


class Featured: UIViewController, UITableViewDelegate, UITableViewDataSource, YTPlayerViewDelegate {
    
    /* Interface builder properties */
    @IBOutlet weak var _youtubeVideosTable:UITableView!
    @IBOutlet weak var _menuButton:UIBarButtonItem!
    var refreshControl:UIRefreshControl?
    
    
    //Youtube video player
    var playerView:YTPlayerView!
    
    var _events:[Event] = []
    var _events2:[Events] = []
    
    /***
 
 
        Scroller Channel information
 
    ***/
    let YTAPIKEY = "AIzaSyCX9srp3Wu-yoJVU6JjmBkQ_IYvhFqCAXo"
    let CHAPIKEY = "lli6e86AWtO5K1H3tXVevzbAIPz8ytsCwjP6LFVJ"
    let desiredChannelsArray = ["Google", "Apple", "Bum1six3"]
    let channelIndex = 0
    var channelsDataArray:Array<Dictionary<NSObject, AnyObject>> = [] //NSObject is going to be equal to 0 in this case since I'm only adding one channel. If I were to add two channels then I could change this value which would make NSObject the index
    
    var videosArray: Array<Dictionary<NSObject, AnyObject>> = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self._youtubeVideosTable.delegate = self
        self._youtubeVideosTable.dataSource = self
        
        //Connect this view to the SWRevealViewController
        if self.revealViewController() != nil {
            self._menuButton.target = self.revealViewController()
            self._menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        //Create a refresh view for pull down refresh
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.attributedTitle = NSAttributedString(string: "Pull down to refresh")
        self.refreshControl?.addTarget(self, action: #selector(Featured.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self._youtubeVideosTable.addSubview(self.refreshControl!)
        
        print(self._events.count)
        
        if (videosArray.count == 0) {
            self.loadYoutubeVideos()
        } else {
            self._youtubeVideosTable.reloadData()
        }


        // Do any additional setup after loading the view.
    }
    
    func refresh(sender:AnyObject){
        self.videosArray = []
        self._events = []
        self._youtubeVideosTable.reloadData()
        self.loadYoutubeVideos()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    override func viewWillAppear(animated: Bool) {
       /* let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest = NSFetchRequest(entityName: "YTVideo")
        
        //3
        do {
            let results =
                try managedContext.executeFetchRequest(fetchRequest)
            print(results)
            //print(results["videoId"] as? String)
            //self._events = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }*/
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        //self._youtubeVideosTable.hidden = true
        
        /*for i in 0..<self._events.count {
            let appDelegate =
                UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext
            let entity =  NSEntityDescription.entityForName("YTVideo",
                                                            inManagedObjectContext:managedContext)
            let video = NSManagedObject(entity: entity!,
                                        insertIntoManagedObjectContext: managedContext)
            self._events2[i].title! = self._events[i]._titleText!
            self._events2[i].videoId! = self._events[i]._video_id!
            
            //video.setValue(self._events[i]._video_id, forKey: "videoId")
            //video.setValue(self._events[i]._titleText, forKey: "title")
            //video.setValue(
            
            do {
                try managedContext.save()
                print("saved")
            } catch let _ as NSError{
                print("Something went wrong here")
            }
        }*/
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //self._youtubeVideosTable.hidden = false
        //self._youtubeVideosTable.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("eventRow", forIndexPath: indexPath) 
        
        //viewWithTag(1) returns the title
        //viewWithTag(2) returns the description
        //viewWithTag(3) returns the image
        /*Testing the calls */
        let title = cell.viewWithTag(1) as! UILabel
        let image = cell.viewWithTag(2) as! UIImageView
        
        //let yt_image = UIImage(data: NSData(contentsOfURL: NSURL(string:(videosArray[indexPath.row]["thumbnail"] as? String)! )!)!)!
        
        
        
        title.text = self._events[indexPath.row]._titleText
        //image.image = self._events[indexPath.row]._video_image!.image
        if self._events[indexPath.row]._video_image != nil {
            image.image = self._events[indexPath.row]._video_image!.image
        }
        
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.dequeueReusableCellWithIdentifier("eventRow", forIndexPath: indexPath)
        performSegueWithIdentifier("playVidSegue", sender: cell)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //return videosArray.count
        return self._events.count
        
    }
    
    
    //This function sets up the scroller at the top view by syncing 
    //the user's scrolling with the page control view
    //The scroller can only hold 3 videos
    func scrollerSetup(){
    }


    
    func loadYoutubeVideos(){
        //Make youtube request -- hardcoding for now
        Alamofire.request(.GET,"https://www.googleapis.com/youtube/v3/channels", parameters:["part":"contentDetails,snippet","forUsername":"Bum1six3", "key":YTAPIKEY]).responseJSON { response in
            
            if (response.response!.statusCode == 200 && response.result.error == nil){
                //print("let")
                do
                {
                    let resultsDict = try NSJSONSerialization.JSONObjectWithData(response.data!, options: []) as! Dictionary<NSObject, AnyObject>
                    let items: AnyObject! = resultsDict["items"] as AnyObject!
                    //get the first dictionary item from the returned JSON response
                    let firstItemDict = (items as! Array<AnyObject>)[0] as! Dictionary<NSObject, AnyObject>
                    
                    let snippetDict = firstItemDict["snippet"] as! Dictionary<NSObject, AnyObject>
                    
                    var desiredValuesDict:Dictionary<NSObject, AnyObject> = Dictionary<NSObject, AnyObject>()
                    desiredValuesDict["title"] = snippetDict["title"]
                    desiredValuesDict["description"] = snippetDict["description"]
                    //desiredValuesDict["thumbnail"] = snippetDict["thumbnail"]
                    desiredValuesDict["playlistId"] = ((firstItemDict["contentDetails"] as! Dictionary<NSObject, AnyObject>)["relatedPlaylists"] as! Dictionary<NSObject,AnyObject>)["uploads"]
                    
                    self.channelsDataArray.append(desiredValuesDict)

                    self._youtubeVideosTable.reloadData()

                    self.getVideosFromChannel()

                    
                } catch {
                    
                }
            }
        }
        
    }
    
    func getVideosFromChannel(){
        Alamofire.request(.GET, "https://www.googleapis.com/youtube/v3/playlistItems", parameters: ["part":"snippet","key":YTAPIKEY,"playlistId":channelsDataArray[0]["playlistId"]! as! String]).responseJSON {
            response in
            
            if response.response!.statusCode == 200 && response.result.error == nil {
                do{
                    let resultsDict = try NSJSONSerialization.JSONObjectWithData(response.data!, options: []) as! Dictionary<NSObject, AnyObject>
                    
                    let items: Array<Dictionary<NSObject, AnyObject>> = resultsDict["items"] as! Array<Dictionary<NSObject, AnyObject>>
                    
                    for i in 0 ..< items.count {
                        let playlistSnippetDict = (items[i] as Dictionary<NSObject, AnyObject>)["snippet"] as! Dictionary<NSObject, AnyObject>
                        var desiredPlaylistDict = Dictionary<NSObject, AnyObject>()
                        
                        desiredPlaylistDict["title"] = playlistSnippetDict["title"]
                        desiredPlaylistDict["thumbnail"] = ((playlistSnippetDict["thumbnails"] as! Dictionary<NSObject, AnyObject>)["maxres"] as! Dictionary<NSObject, AnyObject>)["url"]
                        desiredPlaylistDict["videoId"] = (playlistSnippetDict["resourceId"] as! Dictionary<NSObject, AnyObject>)["videoId"]
                        
                        self.videosArray.append(desiredPlaylistDict)
                        let event = Event(title: (desiredPlaylistDict["title"] as? String)!, video_id: desiredPlaylistDict["thumbnail"] as! String, parent: self)
                        self._events += [event]
                        
                        /*do {
                            
                            /*async programming
                             This grabs the URL of each TwitchBroadcast object and displays the
                             image after instantiating each object. This is where you want to edit
                             the TwitchBroadcast object*/
                            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0)){
                                    let image_url = NSURL(string: desiredPlaylistDict["videoId"] as! String)
                                
                                    let data = NSData(contentsOfURL: image_url!)
                                    dispatch_async(dispatch_get_main_queue(), {
                                        let image = UIImageView()
                                        image.image = UIImage(data: data!)
                                        let event = Event(title: (desiredPlaylistDict["title"] as! String), image: UIImageView())
                                        self._events += [event]
                                    })
                            }
                    
                        }*/
                        
                        
                        //var event = Event(title: desiredPlaylistDict["title"], image: UIImageView(image:  UIImage(data: NSData(contentsOfURL: NSURL(string:(videosArray[i]["videoId"] as? String)! )!)!)!))
                        
                        //self._youtubeVideosTable.reloadData()
                    }

                } catch {
                }
                
                
                
            } else {
                //print("u")
                print(response.response!.statusCode)
                print(response.result.error)
                print(response.result)
            }
            
        }
        
        self.refreshControl?.endRefreshing()
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let cell = sender as? UITableViewCell {
            let i = self._youtubeVideosTable.indexPathForRowAtPoint(cell.center)!.row
            if segue.identifier == "playVidSegue" {
                let vidplaycontroller = segue.destinationViewController as! VideoPlayerController
                vidplaycontroller.videoId = self.videosArray[i]["videoId"] as! String
            }
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
