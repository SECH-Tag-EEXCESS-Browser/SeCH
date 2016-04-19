//
//  ConnectionCtrl.swift
//  Browser
//
//  Created by Burak Erol on 10.12.15.
//  Copyright © 2015 SECH-Tag-EEXCESS-Browser. All rights reserved.
//

import Foundation

class JSONConnectionCtrl:ConnectionCtrl {
    
    override func post(params : (SearchQuerys,AnyObject), url : String,
        postCompleted : (succeeded: Bool, data: NSData, searchQuerys:SearchQuerys?) -> ())
    {
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let data =  try! NSJSONSerialization.dataWithJSONObject(params.1, options: [NSJSONWritingOptions()])
        
        self.post((params.0 ,data), request: request, postCompleted: postCompleted)
    }
}

class ConnectionCtrl {

    var searchQuerys:SearchQuerys?
    
    func post(params : (SearchQuerys,AnyObject), url : String,
        postCompleted : (succeeded: Bool, data: NSData, searchQuerys:SearchQuerys?) -> ()){
            postCompleted(succeeded: false,data: "Es wird die abstrakte Klasse ConnectionCtrl".dataUsingEncoding(NSUTF8StringEncoding)!,searchQuerys: nil)
    }
    
     private func post(data : (SearchQuerys,NSData), request : NSMutableURLRequest,
        postCompleted : (succeeded: Bool, data: NSData, searchQuerys:SearchQuerys?) -> ())
     {
        print("start")
        self.searchQuerys = data.0
        request.HTTPMethod = "POST"
        request.HTTPBody = data.1
        let session = NSURLSession.sharedSession()
        print("running")
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            print("stoped")
            postCompleted(succeeded: error == nil, data: data!,searchQuerys: self.searchQuerys!)
        })
        task.resume()
    }
}