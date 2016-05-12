//
//  CellAnimator.swift
//  HOC2
//
//  Created by Markim Shaw on 5/2/16.
//  Copyright © 2016 Markim Shaw. All rights reserved.
//

import UIKit

class CellAnimator{
    class func animate(cell:UITableViewCell, durationMultiplier:Int){
        let view = cell.contentView
        view.layer.opacity = 0.1
        UIView.animateWithDuration(0.5 + (Double(durationMultiplier) * 0.5)){
            view.layer.opacity = 1
        }
    }
}