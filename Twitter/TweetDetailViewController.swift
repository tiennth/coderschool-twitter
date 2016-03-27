//
//  TweetDetailViewController.swift
//  Twitter
//
//  Created by Tien on 3/26/16.
//  Copyright © 2016 tiennth. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var newReplyTextField: UITextField!
    @IBOutlet weak var sendReplyButton: UIButton!
    
    let dateFormatter = NSDateFormatter()
    var tweet:Tweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dateFormatter.dateFormat = "h:mm a dd MMM yy"
        self.title = "Tweet"
        
        self.profileImageView.layer.masksToBounds = true
        self.profileImageView.layer.cornerRadius = 8
        
        self.bindTweetDetail()
    }
    
    @IBAction func replyButtonClicked(sender: UIButton) {
    }
    
    @IBAction func retweetButtonClicked(sender: UIButton) {
    }
    
    @IBAction func likeButtonClicked(sender: UIButton) {
    }

    @IBAction func shareButtonClciked(sender: UIButton) {
    }
    
    func bindTweetDetail() {
        self.textLabel.text = self.tweet.text
        self.timestampLabel.text = dateFormatter.stringFromDate(self.tweet.timeStamp!)
        if let user = self.tweet.user {
            self.bindUserData(user)
        }
    }
    
    func bindUserData(user:User) {
        if let profileImageUrl = user.profileImageURL {
            self.profileImageView.setImageWithURL(profileImageUrl)
        }
        if let name = user.name {
            self.nameLabel.text = name
        }
        if let handle = user.screenName {
            self.handleLabel.text = "@\(handle)"
        }
    }
}
