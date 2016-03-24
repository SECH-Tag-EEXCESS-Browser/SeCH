//
//  EEXCESSrecomendation.swift
//  SechQueryComposer
//
//  Copyright © 2015 Peter Stoehr. All rights reserved.
//

import Foundation

class EEXCESSRecommendation : NSObject {
    var title : String
    var provider : String
    var uri : String
    
    override var description: String {
        get {
            return "Title:\(title) -- Provider:\(provider) -- URI:\(uri)"
        }
    }
    init(title : String, provider : String, uri : String)
    {
        self.title = title
        self.provider = provider
        self.uri = uri
    }
    
    
}