//
//  TimelineViewController.swift
//  Twitter
//
//  Created by Tien on 3/25/16.
//  Copyright © 2016 tiennth. All rights reserved.
//

import UIKit
import MBProgressHUD

class TimelineViewController: UIViewController {

    var tweets:[Tweet]! = []
    let refreshControl = UIRefreshControl()
    
    @IBOutlet weak var tweetsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initNavigationBar()
        self.initPullToRefreshControl()
        
        self.tweetsTableView.rowHeight = UITableViewAutomaticDimension
        self.tweetsTableView.estimatedRowHeight = 160
        
        self.loadTweets()
    }
    // MARK: - Initial controls
    // MARK: Navigation bar
    func initNavigationBar() {
        self.title = "Home"
        
        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .Compose, target: self, action: #selector(TimelineViewController.onRightBarButtonClick(_:)))
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    func onLeftBarButtonClick(sender: UIBarButtonItem) {
//        self.performSegueWithIdentifier("showTweetComposer", sender: self)
    }
    
    func onRightBarButtonClick(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("showTweetComposer", sender: self)
    }
    
    // MARK: Pull to refresh
    func initPullToRefreshControl() {
        self.refreshControl.addTarget(self, action: #selector(TimelineViewController.loadTweets), forControlEvents: .ValueChanged)
        self.tweetsTableView.insertSubview(self.refreshControl, atIndex: 0)
    }
    
    // MARK: - Data loading
    func loadTweets() {
        self.onPreLoadTweets()
        
        TwitterClient.sharedClient.homeTimeline({ (tweets: [Tweet]) in
            self.tweets = tweets;
            self.onLoadTweetsSuccess()
        }) { (error: NSError) in
            self.onLoadTweetsFailure(error)
        }
    }
    
    func onPreLoadTweets() {
        let mbLoadingView = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        mbLoadingView.mode = MBProgressHUDMode.Indeterminate;
    }
    
    func onLoadTweetsSuccess() {
        self.refreshControl.endRefreshing()
        self.tweetsTableView.reloadData()
        MBProgressHUD.hideHUDForView(self.view, animated: true)
    }
    
    func onLoadTweetsFailure(error: NSError) {
        self.refreshControl.endRefreshing()
        MBProgressHUD.hideHUDForView(self.view, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            let detailVc = segue.destinationViewController as! TweetDetailViewController
            let cell = sender as! UITableViewCell
            let indexPath = self.tweetsTableView.indexPathForCell(cell)
            detailVc.tweet = self.tweets[indexPath!.row];
        } else if segue.identifier == "showTweetComposer" {
            let composer = segue.destinationViewController as! TweetComposeViewController
            composer.delegate = self
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

extension TimelineViewController: TweetComposerDelegate {
    func tweetComposerController(composer: TweetComposeViewController, didPostTweetMessage tweet: String) {
        print("Posted \(tweet)")
    }
}
