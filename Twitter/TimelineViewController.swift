//
//  TimelineViewController.swift
//  Twitter
//
//  Created by Tien on 3/25/16.
//  Copyright © 2016 tiennth. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController {

    var tweets:[Tweet]! = []
    
    @IBOutlet weak var tweetsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tweetsTableView.rowHeight = UITableViewAutomaticDimension
        self.tweetsTableView.estimatedRowHeight = 160
        
        self.loadTweets()
    }
    
    func loadTweets() {
        TwitterClient.sharedClient.homeTimeline({ (tweets: [Tweet]) in
            self.tweets = tweets;
            self.onLoadTweetsSuccess()
        }) { (error: NSError) in
            self.onLoadTweetsFailure(error)
        }
    }
    
    func onLoadTweetsSuccess() {
        self.tweetsTableView.reloadData()
    }
    
    func onLoadTweetsFailure(error: NSError) {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "showDetail") {
            let detailVc = segue.destinationViewController as! TweetDetailViewController
            let cell = sender as! UITableViewCell
            let indexPath = self.tweetsTableView.indexPathForCell(cell)
            detailVc.tweet = self.tweets[indexPath!.row];
        }
    }
}

extension TimelineViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tweetCell") as! TweetCell
        cell.tweet = self.tweets![indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
