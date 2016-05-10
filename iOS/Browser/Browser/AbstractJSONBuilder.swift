//
//  AbstractJSONBuilder.swift
//  Browser
//
//  Created by Burak Erol on 10.05.16.
//  Copyright © 2016 SECH-Tag-EEXCESS-Browser. All rights reserved.
//

import Foundation
// TODO:  Own File for AbstractBuilder
protocol AbstractBuilder {
    func getPostMethod()->String
    func getContentType()->String
    func getAcceptType()->String
}

protocol AbstractJSONBuilder:AbstractBuilder {
    func getJSON()-> [String:AnyObject]
}