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
    
    func getRecommendations(seachData:[SEACHModel], setRecommendations: (message: String, recommendationData: [EEXCESSAllResponses]?) -> Void)
    {
        let c = JSONConnectionCtrl()
        let rec = EEXCESSRecommendationJSONCtrl(seachData: seachData)
        //let url = Preferences().url + "/recommend"
        print(rec.jsonObject)
        c.post(rec.jsonObject, url: QUERY_URL){ (succeeded: Bool, msg: NSData) -> () in
            if (succeeded) {
                guard let recommJson = EEXCESSRecommendationCtrl(data: msg) else
                {
                    print ("Versagen 1")
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
