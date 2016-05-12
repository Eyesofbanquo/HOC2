//
//  TwitchPastBroadcastTableViewCell.swift
//  HOC2
//
//  Created by Markim Shaw on 5/2/16.
//  Copyright © 2016 Markim Shaw. All rights reserved.
//

import UIKit

class TwitchPastBroadcastTableViewCell: UITableViewCell {
    
    @IBOutlet weak var _broadcastImagePreview:UIImageView!
    @IBOutlet weak var _broadcastTitle:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
