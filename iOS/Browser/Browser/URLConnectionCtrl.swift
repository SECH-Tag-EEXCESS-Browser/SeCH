//
//  URLConnectionCtrl.swift
//  Browser
//
//  Created by Andreas Ziemer on 10.05.16.
//  Copyright © 2016 SECH-Tag-EEXCESS-Browser. All rights reserved.
//

import Foundation

class URLConnectionCtrl:AbstractConnectionCtrl {
    
    let builders:[AbstractURLBuilder] = [FarooURLBuilder(),DuckDuckGoURLBuilder()]

    override func post(query:SearchQuery,postCompleted : (succeeded: Bool, result: SearchResult?) -> ()){
        
        for builder in builders {
            let request = NSMutableURLRequest(URL: NSURL(string: builder.generateURL(query))!)
            request.addValue(builder.getContentType(), forHTTPHeaderField: "Content-Type")
            request.addValue(builder.getAcceptType(), forHTTPHeaderField: "Accept")
            
            request.HTTPMethod = builder.getHTTPMethod()
            post(request, parser: builder.getParser(query), postCompleted: postCompleted)
        }
    }
}