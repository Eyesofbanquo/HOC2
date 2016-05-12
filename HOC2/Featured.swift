//
//  Featured.swift
//  HOC2
//
//  Created by Markim Shaw on 4/27/16.
//  Copyright © 2016 Markim Shaw. All rights reserved.
//


/* UITextView = tag == 1
 */

import UIKit
import Alamofire
import FBSDKShareKit
import FBSDKCoreKit
import FBSDKLoginKit

class Featured: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, YTPlayerViewDelegate {
    
    /* Interface builder properties */
    @IBOutlet weak var _upcomingEventsTable:UITableView!
    @IBOutlet weak var _featuredScroller:UIScrollView!
    @IBOutlet weak var _featuredScrollerPager:UIPageControl!
    
    //Youtube video player
    var playerView:YTPlayerView!
    
    var _events:[Event] = []
    
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
        
        
        
        //Hook up the tableview from the storyboard to the Featured class so that you can use
        //The UITableView's callback functions
        _upcomingEventsTable.delegate = self
        _upcomingEventsTable.dataSource = self
        _featuredScroller.delegate = self
        _featuredScrollerPager.currentPage = 0
        
        /*
         
         
         set up the featured scroller
         
         
         */
        _featuredScroller.pagingEnabled = true
        _featuredScroller.showsHorizontalScrollIndicator = false
        
        //Quick thing to populate the tableview to see how it works
        let event1 = Event(title: "HOC presents", description: "Dark Souls")
        let event2 = Event(title: "TSL #1", description: "Thursday tournament")
        let event3 = Event(title: "TSL #2", description: "Thursday tournament #2")
        let event4 = Event(title: "HOC presents", description: "Pokken")

        _events += [event1, event2, event3, event4]
        
        
        
        self.loadYoutubeVideos()
        

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.automaticallyAdjustsScrollViewInsets = false
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
        let description = cell.viewWithTag(2) as! UILabel
        
        //let channelDetails = channelsDataArray[indexPath.row]
        title.text = self._events[indexPath.row]._titleText
        description.text = self._events[indexPath.row]._descriptionText
        //title.text = channelDetails["title"] as? String
        //description.text = channelDetails["description"] as? String
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _events.count
        //return channelsDataArray.count
        
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let pageNumber = round(self._featuredScroller.contentOffset.x / self._featuredScroller.frame.size.width)
        self._featuredScrollerPager.currentPage = Int(pageNumber)
    }
    
    
    //This function sets up the scroller at the top view by syncing 
    //the user's scrolling with the page control view
    //The scroller can only hold 3 videos
    func scrollerSetup(){
        let parentHeight = self._featuredScroller.frame.height

        self._featuredScroller.frame = CGRect(x: 0,y: 0, width: self.view.frame.width, height: parentHeight)
        self._featuredScroller.contentSize = CGSize(width: self._featuredScroller.frame.width * 3, height: self._featuredScroller.frame.height)

        
        var imageOne = UIImageView(frame:CGRect(x: self._featuredScroller.frame.width * 0, y: 0, width: self._featuredScroller.frame.width, height: self._featuredScroller.frame.height))
        
        imageOne.image = UIImage(data: NSData(contentsOfURL: NSURL(string:(videosArray[0]["thumbnail"] as? String)! )!)!)!
        
        
        
        self._featuredScroller.addSubview(imageOne)
        
        var imageTwo = UIImageView()
        
        imageTwo.image = UIImage(data: NSData(contentsOfURL: NSURL(string:(videosArray[1]["thumbnail"] as? String)! )!)!)!
        
        imageTwo.frame = CGRect(x: self._featuredScroller.frame.width * 1, y: 0, width: self._featuredScroller.frame.width, height: self._featuredScroller.frame.height)
        
        self._featuredScroller.addSubview(imageTwo)
        
        var imageThree = UIImageView()
        
        imageThree.image = UIImage(data: NSData(contentsOfURL: NSURL(string:(videosArray[2]["thumbnail"] as? String)! )!)!)!
        
        imageThree.frame = CGRect(x: self._featuredScroller.frame.width * 2, y: 0, width: self._featuredScroller.frame.width, height: self._featuredScroller.frame.height)
        
        self._featuredScroller.addSubview(imageThree)

        
        let tap = UITapGestureRecognizer(target: self, action: #selector(Featured.playVid))
        tap.cancelsTouchesInView = false
        self._featuredScroller.addGestureRecognizer(tap)

    }
    
    func playVid(){
        performSegueWithIdentifier("playVidSegue", sender: self)
        /* going to just try to load the video in this controller without going to another controller */
        
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
                    
                    //now reload the table after we got all the data we needed
                    self._upcomingEventsTable.reloadData()
                    //print(self.channelsDataArray[0]["playlistID"]!)
                    
                    //self.getVideosFromChannel()
                    //print(self.videosArray)
                    self.getVideosFromChannel()

                    
                } catch {
                    
                }
            }
            
            /* if let JSON = response.result.value{
             print(JSON)
             }*/
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
                        
                        
                        //print(self.videosArray)

                    }
                    self.scrollerSetup()

                } catch {
                }
                
                
                
            } else {
                //print("u")
                print(response.response!.statusCode)
                print(response.result.error)
                print(response.result)
            }
            
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "playVidSegue" {
            let vidplaycontroller = segue.destinationViewController as! VideoPlayerController
            vidplaycontroller.videoId = videosArray[self._featuredScrollerPager.currentPage]["videoId"] as! String
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
