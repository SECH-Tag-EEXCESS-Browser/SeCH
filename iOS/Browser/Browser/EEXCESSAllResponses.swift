//
//  EEXCESSAllResponses.swift
//  Browser
//
//  Created by Burak Erol on 10.12.15.
//  Copyright © 2015 SECH-Tag-EEXCESS-Browser. All rights reserved.
//

import Foundation

class EEXCESSAllResponses {
    var responses: [EEXCESSSingleResponse]
    
    init(){
        responses = []
    }
    
    func appendSingleResponse(response: EEXCESSSingleResponse){
        responses.append(response)
    }
    
    func getSingleResponsesForSearchTag(indexPath: Int)->EEXCESSSingleResponse?{
        return responses[indexPath]
    }
}