//
//  ConnectionCtrl.swift
//  Browser
//
//  Created by Burak Erol on 10.12.15.
//  Copyright © 2015 SECH-Tag-EEXCESS-Browser. All rights reserved.
//

import Foundation

class JSONConnectionCtrl:ConnectionCtrl {
    override func post(params : AnyObject, url : String,
        postCompleted : (succeeded: Bool, data: NSData) -> ())
    {
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let data =  try! NSJSONSerialization.dataWithJSONObject(params, options: [NSJSONWritingOptions()])
        
        self.post(data, request: request, postCompleted: postCompleted)
    }
}

class ConnectionCtrl {
//    func post(params : AnyObject, url : String,
//        postCompleted : (succeeded: Bool, data: NSData) -> ())
//    {
//        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
//        request.HTTPMethod = "POST"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.addValue("application/json", forHTTPHeaderField: "Accept")
//        request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(params, options: [NSJSONWritingOptions()])
//        
//        let session = NSURLSession.sharedSession()
//        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
//            postCompleted(succeeded: error == nil, data: data!)
//        })
//        
//        
//        task.resume()
//
//    }
    func post(params : AnyObject, url : String,
        postCompleted : (succeeded: Bool, data: NSData) -> ()){
            postCompleted(succeeded: false,data: "Es wird die abstrakte Klasse ConnectionCtrl".dataUsingEncoding(NSUTF8StringEncoding)!)
    }
    
     private func post(data : NSData, request : NSMutableURLRequest,
        postCompleted : (succeeded: Bool, data: NSData) -> ())
     {print("start")
        request.HTTPMethod = "POST"
        request.HTTPBody = data
        
        let session = NSURLSession.sharedSession()
        print("running")
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            postCompleted(succeeded: error == nil, data: data!)
        })
        
        print("stoped")
        task.resume()
        
    }
}