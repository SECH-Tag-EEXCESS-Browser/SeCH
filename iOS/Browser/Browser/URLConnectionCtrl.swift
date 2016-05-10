//
//  URLConnectionCtrl.swift
//  Browser
//
//  Created by Burak Erol on 10.05.16.
//  Copyright © 2016 SECH-Tag-EEXCESS-Browser. All rights reserved.
//

import Foundation

class URLConnectionCtrl:AbstractConnectionCtrl {
    
    func post(builder:AbstractURLBuilder,postCompleted : (succeeded: Bool, results: SearchResults) -> ()){
        postCompleted(succeeded: false,results: SearchResults(searchResults: []))
        
//        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.addValue("application/json", forHTTPHeaderField: "Accept")
//        
//        self.searchQuerys = data.0
//        request.HTTPMethod = "GET"
//        request.HTTPBody = data.1
    }
    
    func post(request : NSMutableURLRequest,postCompleted : (succeeded: Bool, data: NSData) -> ())
    {
        print("start")
        let session = NSURLSession.sharedSession()
        print("running")
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            print("stoped")
            postCompleted(succeeded: error == nil, data: data!)
        })
        task.resume()
    }
}