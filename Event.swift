//
//  Events.swift
//  HOC2
//
//  Created by Markim Shaw on 4/27/16.
//  Copyright © 2016 Markim Shaw. All rights reserved.
//

import Foundation
import CoreData
import UIKit


class Event{
    
    var _descriptionText:String!
    var _titleText:String!
    var _video_id:String!
    var _video_image:UIImageView?
    var _parent:Featured!
    
    //var _affiliateImage:UIImage?
    
    init(title:String, video_id:String, parent:Featured){
        //super.init()
        self._video_id = video_id
        self._titleText = title
        self._parent = parent
        loadVideo()
    }
    
    private func loadVideo(){
        let image_url = NSURL(string: self._video_id)
        let data = NSData(contentsOfURL: image_url!)
        
        if (data != nil){
            /*dispatch_async(dispatch_get_main_queue(), {
             let image = UIImageView()
             image.image = UIImage(data: data!)
             self._video_image = image
             })*/
            let image = UIImageView()
            image.image = UIImage(data: data!)
            self._video_image = image
            self._parent._youtubeVideosTable.reloadData()
            return
        }
        /*dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),{
            let image_url = NSURL(string: self._video_id)
            let data = NSData(contentsOfURL: image_url!)
            
            if (data != nil){
                /*dispatch_async(dispatch_get_main_queue(), {
                    let image = UIImageView()
                    image.image = UIImage(data: data!)
                    self._video_image = image
                })*/
                let image = UIImageView()
                image.image = UIImage(data: data!)
                self._video_image = image
                self._parent._youtubeVideosTable.reloadData()
                return
            }
            
            
        })*/
    }
    
}