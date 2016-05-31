//
//  SEARCHModel.swift
//  Browser
//
//  Created by Burak Erol on 10.12.15.
//  Copyright © 2015 SECH-Tag-EEXCESS-Browser. All rights reserved.
//
// This class is the Interface from the View to the QueryBuild.
// It sets the structure of the datamodel of search-models -tags and -model-collections.

import Foundation


//#########################################################################################################################################
//##########################################################___Collection_of_SearchModels___###############################################
//#########################################################################################################################################

class SEARCHModels {
    private let mSearchModels:[SEARCHModel]
    
    init(searchModels:[SEARCHModel]){
        self.mSearchModels = searchModels
    }
    
    init(){
        self.mSearchModels = []
    }
    
    func getSearchModels()->[SEARCHModel]{
        return self.mSearchModels
    }
}



//#########################################################################################################################################
//##########################################################___A_Single_Search_Model___####################################################
//#########################################################################################################################################

class SEARCHModel:Hashable,Equatable{
    static let LINK_TAG = "LINK"
    static let SECTION_TAG = "SECTION"
    static let HEAD_TAG = "HEAD"
    
    var url = String()
    var title = String()
    var index:Int!
    var tags = [String : Tag]() // String is id (link, section, head) and Tag is Tag-Object
    var filters = Filter()
    var provider: String!

    public var hashValue: Int {
        get {
            return url.hashValue + index
        }
    }

}

func ==(lhs: SEARCHModel, rhs: SEARCHModel) -> Bool{
    return lhs.index == rhs.index && lhs.url == rhs.url
}


//#########################################################################################################################################
//##########################################################___A_Single_Tag___#############################################################
//#########################################################################################################################################

class Tag {
    var topic = String()
    var type = String()
    
    func getValues()->[String:AnyObject]{
        return ["text":self.topic,"type":self.type]
    }
}



//#########################################################################################################################################
//##########################################################___A_Single_Filter___##########################################################
//#########################################################################################################################################

class Filter {
    var mediaType = String()
    var provider = String()
    var licence = String()
    
    func getValues()->[String:AnyObject]{
        return ["mediaType":self.mediaType,"provider":self.provider,"licence":self.licence]
    }
}