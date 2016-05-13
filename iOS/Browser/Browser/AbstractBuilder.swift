//
//  AbstractBuilder.swift
//  Browser
//
//  Created by Burak Erol on 12.05.16.
//  Copyright © 2016 SECH-Tag-EEXCESS-Browser. All rights reserved.
//

import Foundation

protocol AbstractBuilder {
    func getHTTPMethod()->String
    func getContentType()->String
    func getAcceptType()->String
    func getParser(query:SearchQuery)->AbstractResponseParser
}