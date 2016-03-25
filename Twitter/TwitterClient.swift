//
//  TwitterClient.swift
//  Twitter
//
//  Created by Tien on 3/23/16.
//  Copyright © 2016 tiennth. All rights reserved.
//

import UIKit

import AFNetworking
import BDBOAuth1Manager

let twitterBaseUrl = "https://api.twitter.com/"
let twitterConsumerKey = "IJiEwmzlsTLqy35mjUMgQqPox"
let twitterConsumerSecret = "9ju2FgfIeOWglUxMaOW6fEOLQbMYEqEB4TqUaC2ZhNXSEI21hq"

class TwitterClient: NSObject {
    private var accessToken: String!
    private var accessSecret: String!
    private var oauthSessionManager: BDBOAuth1SessionManager!
    
    var loginSuccessClosure: (()->())?
    var loginFailureClosure: ((NSError)->())?
    
    class var sharedClient: TwitterClient {
        struct Static {
            static var onceToken:dispatch_once_t = 0
            static var instance: TwitterClient? = nil
        }
        dispatch_once(&Static.onceToken) { 
            Static.instance = TwitterClient(consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        return Static.instance!
    }
    
    init(consumerKey:String!, consumerSecret:String!) {
        let baseUrl = NSURL(string: twitterBaseUrl)
        oauthSessionManager = BDBOAuth1SessionManager(baseURL: baseUrl, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
    }
    
    func loginWithSuccess(success: ()->(), failure: (NSError)->()) {
        loginSuccessClosure = success
        loginFailureClosure = failure
        
        oauthSessionManager.deauthorize() // Just for testing.
        oauthSessionManager.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "xxxTwitter://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) in

            let authorizeUrl = NSURL(string: "\(twitterBaseUrl)oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(authorizeUrl!)
            
        }) { (error: NSError!) in
            self.loginFailureClosure?(error)
        }
    }
    
    func handleOpenUrl(url: NSURL) {
        let queryString = url.query
        let requestToken = BDBOAuth1Credential(queryString: queryString)
        oauthSessionManager.fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken:BDBOAuth1Credential!) in
            
            self.loginSuccessClosure?()
            
        }) { (error: NSError!) in
            self.loginFailureClosure?(error)
        }
    }
    
    func currentUser(success: (User)->(), failure: (NSError)->()) {
        oauthSessionManager.GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            let dic = response as! NSDictionary
            let user = User(json: dic)
            print(dic)
            success(user)
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            print("getAcccount error \(error)")
            failure(error)
        }
    }
    
    func homeTimeline(sucess:(([Tweet])->())?, failure: ((NSError)->())?) {
        oauthSessionManager.GET("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            let dics = response as! [NSDictionary]
            print(dics)
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            print("homeTimeline error \(error)")
        }
    }
}
