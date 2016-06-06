//
//  URLConnectionCtrl.swift
//  Browser
//
//  Created by Burak Erol on 10.05.16.
//  Copyright © 2016 SECH-Tag-EEXCESS-Browser. All rights reserved.
//

import Foundation

class URLConnectionCtrl:AbstractConnectionCtrl {
    
    //var builders:[AbstractURLBuilder] = [DuckDuckGoURLBuilder()]

    override func post(query:SearchQuery,postCompleted : (succeeded: Bool, result: SearchResult?) -> (), builder: AbstractBuilder){

        let builder2 = builder as! AbstractURLBuilder
            // Achtung auf Umlaute in der URI ...
            let str = builder2.generateURL(query)
            let path = str.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
            let url = NSURL(string: path)!
            
            let request = NSMutableURLRequest(URL: url)
            request.addValue(builder2.getContentType(), forHTTPHeaderField: "Content-Type")
            request.addValue(builder2.getAcceptType(), forHTTPHeaderField: "Accept")
            
            request.HTTPMethod = builder2.getHTTPMethod()
            post(request, parser: builder2.getParser(query), postCompleted: postCompleted)
        
    }
}