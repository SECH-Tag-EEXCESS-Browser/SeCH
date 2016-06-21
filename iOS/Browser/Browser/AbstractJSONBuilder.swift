//
//  AbstractJSONBuilder.swift
//  Browser
//
//  Created by Burak Erol on 10.05.16.
//  Copyright © 2016 SECH-Tag-EEXCESS-Browser. All rights reserved.
//

import Foundation

/*
protocol for all JSONBuilder

super -> AbstractBuilder

*/
protocol AbstractJSONBuilder:AbstractBuilder {
    func getJSON(searchQuery:SearchQuery)-> [String:AnyObject]
    func getURL()->String
}