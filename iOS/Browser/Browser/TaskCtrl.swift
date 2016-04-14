//
//  TaskCtrl.swift
//  Browser
//
//  Created by Burak Erol on 10.12.15.
//  Copyright © 2015 SECH-Tag-EEXCESS-Browser. All rights reserved.
//

import Foundation

class TaskCtrl {
    
    let QUERY_URL: String = "https://eexcess-dev.joanneum.at/eexcess-privacy-proxy-issuer-1.0-SNAPSHOT/issuer/recommend"
    //let QUERY_URL: String = "https://eexcess.joanneum.at/eexcess-privacy-proxy-issuer-1.0-SNAPSHOT/issuer/recommend"
    
    func getRecommendations(webContent:WebContent, setRecommendations: (message: String, recommendationData: [EEXCESSAllResponses]?) -> Void)
    {
        let searchObjects = SEARCHManager().getSEARCHObjects(webContent)
        let c = JSONConnectionCtrl()
        let searchQuerys = QueryBuildCtrl().buildQuery(searchObjects)
        let json = EEXCESSRecommendationJSONCtrl().addKontextKeywords(searchQuerys)
        //let url = Preferences().url + "/recommend"
        print(json.1)
        c.post(json, url: QUERY_URL){ (succeeded: Bool, msg: NSData, url:String) -> () in
            if (succeeded) {
                guard let recommJson = EEXCESSRecommendationCtrl(data: msg,url: url) else
                {
                    print ("Versagen 1")
                    print(String(data: msg, encoding: NSUTF8StringEncoding)!)
                    return
                }
                
                let recomms: [EEXCESSAllResponses]? = recommJson.recommendations
                
                
                setRecommendations(message: "SUCCEDED", recommendationData: recomms)
                
                let sm = SettingsManager()
                sm.getPreferencesValues()

//                for i in recomms
//                {
//                    print ("\(i)")
//                }
            }
            else {
                print("Versagen 2")
            }
        }
    }
    
}
