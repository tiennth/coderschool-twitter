//
//  TweetCell.swift
//  Twitter
//
//  Created by Tien on 3/25/16.
//  Copyright © 2016 tiennth. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    // View outlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleNameLabel: UILabel!
    @IBOutlet weak var createdLabel: UILabel!
    @IBOutlet weak var tweetMessageLabel: UILabel!
    
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    
    // Data
    var tweet:Tweet! {
        didSet {
            self.nameLabel.text = "This is name"
            self.handleNameLabel.text = "@twitterhandle"
            self.tweetMessageLabel.text = self.tweet.text
            self.retweetCountLabel.text = self.tweet.reTweetCount > 0 ? "\(self.tweet.reTweetCount)": ""
            self.likeCountLabel.text = self.tweet.favouriteCount > 0 ? "\(self.tweet.favouriteCount)": ""
            
            if let user = self.tweet.user {
                self.bindUserData(user)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.profileImageView.layer.masksToBounds = true
        self.profileImageView.layer.cornerRadius = 8
    }

    @IBAction func replyButtonClicked(sender: UIButton) {
    }
    
    @IBAction func retweetButtonClicked(sender: UIButton) {
    }
    
    @IBAction func likeButtonClicked(sender: UIButton) {
    }
    
    func bindUserData(user:User) {
        if let profileImageUrl = user.profileImageURL {
            self.profileImageView.setImageWithURL(profileImageUrl)
        }
        if let name = user.name {
            self.nameLabel.text = name
        }
        if let handle = user.screenName {
            self.handleNameLabel.text = "@\(handle)"
        }
    }
}
