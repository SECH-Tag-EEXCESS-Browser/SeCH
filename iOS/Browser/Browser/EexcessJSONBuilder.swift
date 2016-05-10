//
//  EexcessJSONBuilder.swift
//  Browser
//
//  Created by Burak Erol on 10.05.16.
//  Copyright © 2016 SECH-Tag-EEXCESS-Browser. All rights reserved.
//

import Foundation

class EEXCESS_JSONBuilder:AbstractJSONBuilder{
    
    func getPostMethod()->String{
        return "POST"
    }
    
    func getContentType()->String{
        return "application/json"
    }
    
    func getAcceptType()->String{
        return "application/json"
    }
    
    func getJSON()-> [String:AnyObject]{
        return [:]
    }
}