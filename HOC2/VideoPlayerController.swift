//
//  VideoPlayerController.swift
//  HOC2
//
//  Created by Markim Shaw on 4/28/16.
//  Copyright © 2016 Markim Shaw. All rights reserved.
//

import UIKit

class VideoPlayerController: UIViewController, YTPlayerViewDelegate {
    
    var videoId:String!
    
    @IBOutlet weak var playerView:YTPlayerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        playerView.delegate = self
        playerView.loadWithVideoId(videoId, playerVars: [
            "playsinline": 1,
            "controls": 1,
            "width": self.view.frame.width,
            "height": self.view.frame.height]
        )
        
        //playerView.loadWithVideoId(videoId)
        //playerView.playVideo()
        //playerView.

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func playerViewDidBecomeReady(playerView: YTPlayerView) {
        NSNotificationCenter.defaultCenter().postNotificationName("Playback started", object: self)
        self.playerView.playVideo()
    }
    
    func playerView(playerView: YTPlayerView, didChangeToState state: YTPlayerState) {
        
        //Tell the view to dimiss itself when the user pauses the video or if the video stops
        if state == YTPlayerState.Paused {
            self.dismissViewControllerAnimated(true, completion: {})
        } else if state == YTPlayerState.Ended {
            self.dismissViewControllerAnimated(true, completion: {})
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
