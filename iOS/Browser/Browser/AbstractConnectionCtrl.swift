//
//  AbstractConnectionCtrl.swift
//  Browser
//
//  Created by Burak Erol on 10.05.16.
//  Copyright © 2016 SECH-Tag-EEXCESS-Browser. All rights reserved.
//

import Foundation

class AbstractConnectionCtrl {
    
    func post(query:SearchQuery,postCompleted : (succeeded: Bool, result: SearchResult) -> ()){
        postCompleted(succeeded: false, result: SearchResult())
    }
    
    func post(request : NSMutableURLRequest,parser:AbstractResponseParser,postCompleted : (succeeded: Bool, result: SearchResult?) -> ())
    {
        print("start")
        let session = NSURLSession.sharedSession()
        print("running")
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            print("stoped")
            if let res = parser.parse(data!){
                postCompleted(succeeded: error == nil, result: res)
            }
            
        })
        task.resume()
    }
}