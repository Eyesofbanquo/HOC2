//
//  PastEvents.swift
//  HOC2
//
//  Created by Markim Shaw on 4/30/16.
//  Copyright © 2016 Markim Shaw. All rights reserved.
//

import UIKit
import Alamofire
import MediaPlayer
import AVKit




class PastEvents: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var _contentTable:UITableView!
    
    var _twitchBroadcasts:[TwitchBroadcast]!
    
    //Video player?
    var moviePlayer:AVPlayerViewController!
    var player:AVPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //self.navigationController!.navigationBar.
        self.navigationItem.title = "Past Broadcasts"
        
        _contentTable.delegate = self
        _contentTable.dataSource = self
        
        _twitchBroadcasts = []
        
        Alamofire.request(.GET, "https://protected-falls-32202.herokuapp.com/twitch-preview-thumbnails", parameters: [:]).responseJSON {
            response in
            do {
                let responseDict = try NSJSONSerialization.JSONObjectWithData(response.data!, options: []) as! Array<Dictionary<NSObject,AnyObject>>//Dictionary<NSObject,AnyObject>
                
                /*async programming
                 This grabs the URL of each TwitchBroadcast object and displays the
                 image after instantiating each object. This is where you want to edit
                 the TwitchBroadcast object*/
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0)){
                    for i in 0..<responseDict.count {
                        let url = NSURL(string: responseDict[i]["image_url"] as! String)
                        let data = NSData(contentsOfURL: url!)
                        dispatch_async(dispatch_get_main_queue(), {
                            var image = UIImageView()
                            image.image = UIImage(data: data!)
                            let newBroadcast = TwitchBroadcast(imagePreview: image, broadcastTitle: responseDict[i]["title"] as! String)
                            self._twitchBroadcasts! += [newBroadcast]
                            self._contentTable.reloadData()
                        })
                    }
                    
                }
            }catch {
                print("general error")
            }
        }
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self._twitchBroadcasts == nil {
            return 0
        }
        return self._twitchBroadcasts.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("pastBroadcast", forIndexPath: indexPath) as! TwitchPastBroadcastTableViewCell
        
        cell._broadcastImagePreview.image = self._twitchBroadcasts![indexPath.row]._imagePreview!.image
        cell._broadcastTitle.text = self._twitchBroadcasts[indexPath.row]._broadcastTitle
        
       // cell._broadcastImagePreview.makeBlurImage()
        //self.view.addSubview(cell._broadcastImagePreview)
        return cell
    }
    
    //* For cell animation *//
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        CellAnimator.animate(cell, durationMultiplier: indexPath.row)
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
