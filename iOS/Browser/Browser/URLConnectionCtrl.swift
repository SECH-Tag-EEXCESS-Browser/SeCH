//
//  URLConnectionCtrl.swift
//  Browser
//
//  Created by Burak Erol on 10.05.16.
//  Copyright © 2016 SECH-Tag-EEXCESS-Browser. All rights reserved.
//

import Foundation

class URLConnectionCtrl:AbstractConnectionCtrl {
    
    let builders:[AbstractURLBuilder] = [DuckDuckGoURLBuilder() , FarooURLBuilder()]

    override func post(query:SearchQuery,postCompleted : (succeeded: Bool, result: SearchResult?) -> ()){
        
        for builder in builders {
            // Achtung auf Umlaute in der URI ...
            let str = builder.generateURL(query)
            let path = str.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
            let url = NSURL(string: path)!
            
            let request = NSMutableURLRequest(URL: url)
            request.addValue(builder.getContentType(), forHTTPHeaderField: "Content-Type")
            request.addValue(builder.getAcceptType(), forHTTPHeaderField: "Accept")
            
            request.HTTPMethod = builder.getHTTPMethod()
            post(request, parser: builder.getParser(query), postCompleted: postCompleted)
        }
    }
}