//
//  TaskCtrl.swift
//  Browser
//
//  Created by Burak Erol on 10.12.15.
//  Copyright © 2015 SECH-Tag-EEXCESS-Browser. All rights reserved.
//

import Foundation

class TaskCtrl {
    
    func getRecommendationsNew(searchModel:SEARCHModel, setRecommendations: (status:String,message: String, result: SearchResult?) -> Void)
    {
        //-------------------------------- QueryBuild ----------------------------------------------
        // Generate SearchQuery
        let searchQuery = QueryBuildCtrl().buildQuery(searchModel)
        //-------------------------------- /QueryBuild ---------------------------------------------
        //-------------------------------- QueryResulution -----------------------------------------
        JSONConnectionCtrl().post(searchQuery, postCompleted: { (succeeded: Bool,result:SearchResult?) -> () in
            if (succeeded) {
                setRecommendations(status:"SUCCEDED",message: "Die Anfrage war erfolgreich", result: result)
            }
            else {
                setRecommendations(status: "FAILED",message: "Die Anfrage war nicht erfolgreich", result: nil)
            }
        })
        URLConnectionCtrl().post(searchQuery, postCompleted: { (succeeded: Bool,result:SearchResult?) -> () in
            if (succeeded) {
                setRecommendations(status:"SUCCEDED",message: "Die Anfrage war erfolgreich", result: result)
                    }
            else {
                setRecommendations(status: "FAILED",message: "Die Anfrage war nicht erfolgreich", result: nil)
                 }
         })
        //-------------------------------- /QueryResulution -----------------------------------------
    }
}
