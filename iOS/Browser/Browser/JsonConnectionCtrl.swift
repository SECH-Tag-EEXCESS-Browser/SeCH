//
//  JsonConnectionCtrl.swift
//  Browser
//
//  Created by Burak Erol on 10.05.16.
//  Copyright © 2016 SECH-Tag-EEXCESS-Browser. All rights reserved.
//

import Foundation

class JSONConnectionCtrl:AbstractConnectionCtrl {
    
    //let builders = [EEXCESS_JSONBuilder()]
    
    override func post(query:SearchQuery,postCompleted : (succeeded: Bool, result: SearchResult?) -> (), builder: AbstractBuilder){
        
        let builder2: EEXCESS_JSONBuilder = builder as! EEXCESS_JSONBuilder
        
            let request = NSMutableURLRequest(URL: NSURL(string: builder2.getURL())!)
            request.addValue(builder2.getContentType(), forHTTPHeaderField: "Content-Type")
            request.addValue(builder2.getAcceptType(), forHTTPHeaderField: "Accept")
            
            request.HTTPMethod = builder.getHTTPMethod()
            request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(builder2.generateJSON(query), options: [NSJSONWritingOptions()])
            post(request, parser: builder2.getParser(query), postCompleted: postCompleted)
        
    }
}