//
//  LoginViewController.swift
//  Twitter
//
//  Created by Tien on 3/25/16.
//  Copyright © 2016 tiennth. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonLogicClicked(sender: UIButton) {
        TwitterClient.sharedClient.loginWithSuccess({ 
//            self.performSegueWithIdentifier("loginSegue", sender: nil)
            TwitterClient.sharedClient.currentUser({ (user) in
                
                }, failure: { (error: NSError) in
                    
            })
            TwitterClient.sharedClient.homeTimeline({ (tweets: [Tweet]) in
                print(tweets)
                }, failure: { (error: NSError) in
                    
            })
            }) { (error) in
                
        }
    }
}
