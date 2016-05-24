//
//  TaskCtrl.swift
//  Browser
//
//  Created by Burak Erol on 10.12.15.
//  Copyright © 2015 SECH-Tag-EEXCESS-Browser. All rights reserved.
//

import Foundation

class TaskCtrl {
    
    func getRecommendationsNew(searchModel:SEARCHModel, setRecommendations: (status:String,message: String, result: SearchResult? , searchModel:SEARCHModel) -> Void)
    {
        //-------------------------------- QueryBuild ----------------------------------------------
        // Generate SearchQuery
        let searchQuery = QueryBuildCtrl().buildQuery(searchModel)
        //-------------------------------- /QueryBuild ---------------------------------------------
        //-------------------------------- QueryResulution -----------------------------------------
        JSONConnectionCtrl().post(searchQuery, postCompleted: { (succeeded: Bool,result:SearchResult?) -> () in
            if (succeeded) {
                setRecommendations(status:"SUCCEDED",message: "Die Anfrage war erfolgreich", result: result,searchModel: searchModel)
            }
            else {
                setRecommendations(status: "FAILED",message: "Die Anfrage war nicht erfolgreich", result: nil,searchModel: searchModel)
            }
        })
        URLConnectionCtrl().post(searchQuery, postCompleted: { (succeeded: Bool,result:SearchResult?) -> () in
            if (succeeded) {
                setRecommendations(status:"SUCCEDED",message: "Die Anfrage war erfolgreich", result: result,searchModel: searchModel)
                    }
            else {
                setRecommendations(status: "FAILED",message: "Die Anfrage war nicht erfolgreich", result: nil,searchModel: searchModel)
                 }
         })
        //-------------------------------- /QueryResulution -----------------------------------------
    }
}
