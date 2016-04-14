//
//  SEARCHModel.swift
//  Browser
//
//  Created by Burak Erol on 10.12.15.
//  Copyright © 2015 SECH-Tag-EEXCESS-Browser. All rights reserved.
//

import Foundation


class SEARCHModels {
    private let mSearchModels:[SEARCHModel]
    
//   Wieso? https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/Properties.html Dafür gibt es Getter
//    var searchModels :[SEARCHModel]{
//        get{
//            return self.mSearchModels
//        }
//    }
    
    init(searchModels:[SEARCHModel]){
        self.mSearchModels = searchModels
    }
    
    func getSearchModels()->[SEARCHModel]{
        return self.mSearchModels
    }
}




class SEARCHModel {
    static let LINK_TAG = "LINK"
    static let SECTION_TAG = "SECTION"
    static let HEAD_TAG = "HEAD"
    
    var url = String()
    var title = String()
    var index:Int!
    var tags = [String : Tag]() // String is id (link, section, head) and Tag is Tag-Object
    var filters = Filter()

}

class Tag {
    var topic = String()
    var type = String()
    //var isMainTopic = Bool()
    
    func getValues()->[String:AnyObject]{
        return ["text":self.topic,"type":self.type]
    }
}

class Filter {
    var mediaType = String()
    var provider = String()
    var licence = String()
    
    func getValues()->[String:AnyObject]{
        return ["mediaType":self.mediaType,"provider":self.provider,"licence":self.licence]
    }
}