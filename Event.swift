//
//  Events.swift
//  HOC2
//
//  Created by Markim Shaw on 4/27/16.
//  Copyright © 2016 Markim Shaw. All rights reserved.
//

import Foundation
import UIKit


class Event {
    
    var _descriptionText:String!
    var _titleText:String!
    //var _image:UIImage!
    
    //var _affiliateImage:UIImage?
    
    init(title:String /*image:UIImage*/, description descriptionText:String){
        self._descriptionText = descriptionText
        //self._image = image
        self._titleText = title
    }
    
}