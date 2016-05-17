//
//  LiveStreamViewController.swift
//  HOC2
//
//  Created by Markim Shaw on 5/11/16.
//  Copyright © 2016 Markim Shaw. All rights reserved.
//

import UIKit
import Alamofire

class LiveStreamViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var _liveStreamVideo:UIWebView!
    @IBOutlet weak var _pastBroadcastTableView:UITableView!
    @IBOutlet weak var _streamTitle:UILabel!
    @IBOutlet weak var _streamDate:UILabel!
    @IBOutlet weak var _streamImage:UIImageView!
    @IBOutlet weak var _pastBroadcastView:UIView!
    @IBOutlet weak var _informationView:UIView!
    @IBOutlet weak var _menuButton:UIBarButtonItem!
    
    
    @IBAction func indexChanged(sender: UISegmentedControl){
        switch sender.selectedSegmentIndex {
        case 0:
            self._liveStreamVideo.loadRequest(NSURLRequest(URL: NSURL(string: "http://player.twitch.tv/?channel=bum1six3&autoplay=false")!))
        case 1:
            _pastBroadcastView.hidden = true
            _informationView.hidden = false
            
        case 2:
            _pastBroadcastView.hidden = false
            _informationView.hidden = true
        default: break
        }
    }
    /* ^^^ Outlets ^^^ */
    

    var _viewHeight:CGFloat!
    var _viewWidth:CGFloat!
    let DEFAULT_STREAM_STRING = "channel=nightblue3"
    var _pastBroadcasts:[TwitchBroadcast] = []
    /* ^^^ Properties ^^^ */
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            self._menuButton.target = self.revealViewController()
            self._menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        self.navigationItem.title = "Stream"
        self._pastBroadcastTableView.delegate = self
        self._pastBroadcastTableView.dataSource = self
        
        self._liveStreamVideo.allowsInlineMediaPlayback = true
        self._liveStreamVideo.scrollView.scrollEnabled = false
        self._liveStreamVideo.scrollView.bounces = false
        
        
        Alamofire.request(.GET, "https://protected-falls-32202.herokuapp.com/twitch", parameters: [:]).responseJSON{ response in
            do {
                let responseDict = try NSJSONSerialization.JSONObjectWithData(response.data!, options: []) as! Array<Dictionary<NSObject,AnyObject>>//Dictionary<NSObject,AnyObject>
                
                /*async programming
                 This grabs the URL of each TwitchBroadcast object and displays the
                 image after instantiating each object. This is where you want to edit
                 the TwitchBroadcast object*/
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0)){
                    for i in 0..<responseDict.count {
                        let image_url = NSURL(string: responseDict[i]["image_url"] as! String)
                        let broadcast_url = responseDict[i]["url"] as! String
                        
                        let data = NSData(contentsOfURL: image_url!)
                        dispatch_async(dispatch_get_main_queue(), {
                            let image = UIImageView()
                            image.image = UIImage(data: data!)
                            let newBroadcast = TwitchBroadcast(imagePreview: image, broadcastTitle: responseDict[i]["title"] as! String, videoUrl: broadcast_url)
                            self._pastBroadcasts += [newBroadcast]
                            self._pastBroadcastTableView.reloadData()
                        })
                    }
                    
                }
                
            }catch {
                print("general error")
            }
        }
        
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        self._liveStreamVideo.reload()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self._viewHeight = self._liveStreamVideo.frame.height
        self._viewWidth = self._liveStreamVideo.scrollView.frame.width
        print(String(self._viewWidth))
        //USing the Twitch iFrame from their API guide
        /*let embedVideo = "<html><body><iframe src=\"https://player.twitch.tv/?\(DEFAULT_STREAM_STRING)&amp;html5\" height=\"\(self._viewHeight)\" width=\"\(self._viewWidth)\" scrolling=\"no\" allowfullscreen=\"false\"</iframe></body></html>"
        let test_link:String = String(format: embedVideo)*/
        
        /*let request = Alamofire.request(.GET, "http://www.twitch.tv/nightblue3/embed", parameters: [:]).request! as NSURLRequest*/
        self._liveStreamVideo.loadRequest(NSURLRequest(URL: NSURL(string: "http://player.twitch.tv/?channel=bum1six3&autoplay=false")!))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _pastBroadcasts.count
    }
    

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let embedVideo = "<!DOCTYPE html><head><style>body { margin: 0; padding: 0; }</style></head><body><iframe webkit-playsinline src=\"https://player.twitch.tv/?video=v\(self._pastBroadcasts[indexPath.row]._broadcastURL)&amp;autoplay=false&amp;playsinline=1\" height=\"\(self._viewHeight)\" width=\"\(self._viewWidth)\" scrolling=\"no\" allowfullscreen=\"false\" frameborder=\"0\" autoplay=\"false\"</iframe></body></html>"
        //let test_link:String = String(format: embedVideo)
        self._liveStreamVideo.loadHTMLString(embedVideo, baseURL: nil)
        //let embedVideo2 = "<!DOCTYPE html><head><style>body{margin: 0; padding: 0;}</style></head><body>"
        //self._liveStreamVideo.loadRequest(NSURLRequest(URL:NSURL(string: "https://player.twitch.tv/?video=v\(self._pastBroadcasts[indexPath.row]._broadcastURL)*&autoplay=false")!))
        //self._liveStreamVideo.loadRequest(NSURLRequest(URL: NSURL(string: self._pastBroadcasts[indexPath.row]._broadcastURL + "/embed")!))
        //self._liveStreamVideo.loadRequest(NSURLRequest(URL: NSURL(string: "https://pacific-hollows-29177.herokuapp.com/iframe")!))
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("past_broadcast", forIndexPath: indexPath)
        /** Cell tags
        1 = image
        2 = title
        3 = date **/
        
        let image = cell.viewWithTag(1) as! UIImageView
        let title = cell.viewWithTag(2) as! UILabel
        let image_image = self._pastBroadcasts[indexPath.row]._imagePreview.image
        image.image = image_image
        title.text = self._pastBroadcasts[indexPath.row]._broadcastTitle
        //image.image = self._pastBroadcasts[indexPath.row]._imagePreview!
        //title.text = self._pastBroadcasts[indexPath.row].text

        
        return cell
    }
    /* ^^^ UITableView functions ^^^ */
    
    func loadPastBroadcasts(){
        
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
