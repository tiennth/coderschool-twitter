//
//  TweetComposeViewController.swift
//  Twitter
//
//  Created by Tien on 3/26/16.
//  Copyright © 2016 tiennth. All rights reserved.
//

import UIKit

let kMaxTweetLong = 140

protocol TweetComposerDelegate {
    func tweetComposerController(composer: TweetComposeViewController, didPostTweetMessage tweet:String)
}

class TweetComposeViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleNameLabel: UILabel!
    @IBOutlet weak var remainingCharacterLabel: UILabel!
    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var tweetButton: UIButton!
    
    var delegate: TweetComposerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.profileImageView.layer.masksToBounds = true
        self.profileImageView.layer.cornerRadius = 6
        self.tweetTextView.becomeFirstResponder()
        
        self.bindUserData()
        self.updateTweetButtonWithCharacterCount(0)
        self.updateRemainingCharacterCountLabelWithRemainingCount(kMaxTweetLong)
    }
    
    @IBAction func buttonCancelClicked(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func buttonTweetClicked(sender: UIButton) {
        
        TwitterClient.sharedClient.newSimpleTweet(self.tweetTextView.text!, success: { 
            self.delegate?.tweetComposerController(self, didPostTweetMessage: self.tweetTextView.text!)
            self.dismissViewControllerAnimated(true, completion: nil)
        }) { (error: NSError) in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
    }
    
    func bindUserData() {
        let user = User.currentUser!
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
    
    func updateTweetButtonWithCharacterCount(count:Int) {
        if count == 0 || count > 140 {
            self.tweetButton.enabled = false
        } else {
            self.tweetButton.enabled = true
        }
        
        if self.tweetButton.enabled {
            self.tweetButton.backgroundColor = UIColor.colorWithHex(0x58AFF0)
            self.tweetButton.alpha = 1
        } else {
            self.tweetButton.backgroundColor = UIColor.colorWithHex(0x1b95e0)
            self.tweetButton.alpha = 0.2
        }
        
    }
    
    func updateRemainingCharacterCountLabelWithRemainingCount(remainingCount:Int) {
        self.remainingCharacterLabel.text = "\(remainingCount)"
        if remainingCount < 10 {
            self.remainingCharacterLabel.textColor = UIColor.colorWithHex(0xd40d12)
        } else if remainingCount <= 20 {
            self.remainingCharacterLabel.textColor = UIColor.colorWithHex(0x5c0002)
        } else {
            self.remainingCharacterLabel.textColor = UIColor.colorWithHex(0x8899A6)
        }
    }
}

extension TweetComposeViewController: UITextViewDelegate {
    func textViewDidChange(textView: UITextView) {
        let characterCount = textView.text.characters.count
        let remainingCharacterCount = kMaxTweetLong - characterCount
        self.updateRemainingCharacterCountLabelWithRemainingCount(remainingCharacterCount)
        self.updateTweetButtonWithCharacterCount(characterCount)
    }
    
    
}
