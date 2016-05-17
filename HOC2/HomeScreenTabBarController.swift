//
//  HomeScreenTabBarController.swift
//  HOC2
//
//  Created by Markim Shaw on 4/27/16.
//  Copyright © 2016 Markim Shaw. All rights reserved.
//

import UIKit

class HomeScreenTabBarController: UITabBarController {

    //This adds the ability to change the default index in Storyboard
    @IBInspectable var defaultIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set the default tab bar to the second "Featured" tab
        //self.selectedIndex = 1
        self.selectedIndex = defaultIndex
        self.tabBar.tintColor = UIColor.purpleColor()
        
        
        //This will be used to change tab bar specific settings such as
        // their color, their image, etc etc
        
        //The first tab bar is the Twitch streaming tab bar
        /* This tab should be able to do the following:
            Use the HOC2 API to determine whether or not the stream is live
            Use a UIWebview to display the stream
            Show an offline image if the stream isn't currently live */
        /*var tabBarIndex = self.tabBar.items?.startIndex
        self.tabBar.items![tabBarIndex!].title = ""
        self.tabBar.items![tabBarIndex!].image = UIImage(named: "twitch_logo")
        self.tabBar.items![tabBarIndex!].selectedImage = UIImage(named: "twitch_logo")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        
        
        //This tab is the Youtube streaming tab bar
        /* This tab should have the following:
            Use the Youtube API to pull latest Youtube videos
            Show the videos in a tableview */
        tabBarIndex = tabBarIndex?.advancedBy(1)
        self.tabBar.items![tabBarIndex!].title = ""
        self.tabBar.items![tabBarIndex!].image = UIImage(named: "youtube_logo")
        self.tabBar.items![tabBarIndex!].selectedImage = UIImage(named: "youtube_logo")?.imageWithRenderingMode(.AlwaysOriginal)

        //Remove the tab bar line
       // self.tabBar.setValue(true, forUndefinedKey: "_hidesShadow")
        //self.tabBar.setValue(true, forKey: "_hidesShadow")
        //self.tabBar.backgroundImage = UIImage()
        //self.tabBar.shadowImage = UIImage()
        self.tabBar.translucent = true*/
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
