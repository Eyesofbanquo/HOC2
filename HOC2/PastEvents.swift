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
        
        
        
        self.navigationItem.title = "Past Broadcasts"
        
        _contentTable.delegate = self
        _contentTable.dataSource = self
        
        _twitchBroadcasts = []
        
        

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
        
        
        
       
        return cell
    }
    
    //* For cell animation *//
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        //CellAnimator.animate(cell, durationMultiplier: indexPath.row)
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
