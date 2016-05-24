//
//  JsonConnectionCtrl.swift
//  Browser
//
//  Created by Burak Erol on 10.05.16.
//  Copyright © 2016 SECH-Tag-EEXCESS-Browser. All rights reserved.
//

import Foundation

class JSONConnectionCtrl:AbstractConnectionCtrl {
    
    let builders = [EEXCESS_JSONBuilder()]
    
    override func post(query:SearchQuery,postCompleted : (succeeded: Bool, result: SearchResult?) -> ()){
        
        for builder in builders {
            let request = NSMutableURLRequest(URL: NSURL(string: builder.getURL())!)
            request.addValue(builder.getContentType(), forHTTPHeaderField: "Content-Type")
            request.addValue(builder.getAcceptType(), forHTTPHeaderField: "Accept")
            
            request.HTTPMethod = builder.getHTTPMethod()
            request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(builder.generateJSON(query), options: [NSJSONWritingOptions()])
            post(request, parser: builder.getParser(query), postCompleted: postCompleted)
        }
    }
}