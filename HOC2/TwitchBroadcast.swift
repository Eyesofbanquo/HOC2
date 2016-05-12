//
//  TwitchBroadcasts.swift
//  HOC2
//
//  Created by Markim Shaw on 5/2/16.
//  Copyright © 2016 Markim Shaw. All rights reserved.
//

import Foundation
import UIKit

class TwitchBroadcast {
    
    
   /* Properties */
    var _imagePreview:UIImageView!
    //var _broadcastURL:NSURL!
    var _broadcastTitle:String!
    var _broadcastURL:String!
    //var _broadcastDate:NSDate? --add this later
    
    init(imagePreview:UIImageView, broadcastTitle:String){
        self._imagePreview = imagePreview
        self._broadcastTitle = broadcastTitle
    }
    
    convenience init(imagePreview:UIImageView, broadcastTitle:String, videoUrl:String){
        self.init(imagePreview: imagePreview, broadcastTitle: broadcastTitle)
        self._broadcastURL = videoUrl
        
    }
}