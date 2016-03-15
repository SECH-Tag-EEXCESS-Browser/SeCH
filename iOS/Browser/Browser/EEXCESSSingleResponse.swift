//
//  EexcessModel.swift
//  Browser
//
//  Created by Burak Erol on 10.12.15.
//  Copyright © 2015 SECH-Tag-EEXCESS-Browser. All rights reserved.
//

import Foundation

class EEXCESSSingleResponse : CustomStringConvertible {
    var title : String
    var provider : String
    var uri : String?
    var language: String
    var mediaType: String
    var avg:Double!
    
    var description: String {
        get {
            return "Title:\(title) -- Provider:\(provider) -- URI:\(uri)"
        }
    }
    init(title : String, provider : String, uri : String, language: String, mediaType: String)
    {
        self.title = title
        self.provider = provider
        self.uri = uri
        self.language = language
        self.mediaType = mediaType

    }
 
}

func < (left : EEXCESSSingleResponse, right : EEXCESSSingleResponse) -> Bool
{
    return left.avg < right.avg
}