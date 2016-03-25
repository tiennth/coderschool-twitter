//
//  Tweet.swift
//  Twitter
//
//  Created by Tien on 3/25/16.
//  Copyright © 2016 tiennth. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    private static var dateFormatter = NSDateFormatter()
    var text: String?
    var timeStamp: NSDate?
    var reTweetCount: Int = 0
    var favouriteCount: Int = 0
    var user: User?
    
    init(json: NSDictionary) {
        text = json["text"] as? String
        if let timeStampString = json["created_at"] as? String {
            // Tue Aug 28 21:08:15 +0000 2012
            Tweet.dateFormatter.dateFormat = "EEE MMM dd hh:mm:ss yyyy"
            timeStamp = Tweet.dateFormatter.dateFromString(timeStampString)
        }
        if let userDic = json["user"] as? NSDictionary {
            user = User(json: userDic)
        }
        
        reTweetCount = json["retweet_count"] as? Int ?? 0
        favouriteCount = json["favourites_count"] as? Int ?? 0
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets:[Tweet] = []
        for dictionary in dictionaries {
            let tweet = Tweet(json: dictionary)
            tweets.append(tweet)
        }
        return tweets
    }
}
