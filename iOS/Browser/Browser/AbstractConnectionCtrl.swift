//
//  AbstractConnectionCtrl.swift
//  Browser
//
//  Created by Burak Erol on 10.05.16.
//  Copyright © 2016 SECH-Tag-EEXCESS-Browser. All rights reserved.
//

import Foundation
/*
  AbstractConnectionCtrl is the superclass for all connectionctrls
*/
class AbstractConnectionCtrl {
    
    /*
        This abstract method for is for the childclasses
        
        postCompleted -> send a false and empty result -> abstract function
    */
    func post(query:SearchQuery,postCompleted : (succeeded: Bool, result: SearchResult?) -> (), abstractBuilder: AbstractBuilder){
        postCompleted(succeeded: false, result: SearchResult())
    }
    
    /*
        general part of the querysend-process
    */
    func post(request : NSMutableURLRequest,parser:AbstractResponseParser,postCompleted : (succeeded: Bool, result: SearchResult?) -> ())
    {
        print("start ")
        let session = NSURLSession.sharedSession()
        print("running")
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            print("stoped")
            let res = parser.parse(data!)
            postCompleted(succeeded: error == nil, result: res)
        })
        task.resume()
    }
}