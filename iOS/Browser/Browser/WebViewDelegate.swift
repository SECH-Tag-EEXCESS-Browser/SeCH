//
//  WebViewDelegate.swift
//  Browser
//
//  Created by Andreas Ziemer on 16.10.15.
//  Copyright © 2015 SECH-Tag-EEXCESS-Browser. All rights reserved.
//

import UIKit
import WebKit

class WebViewDelegate: NSObject, WKNavigationDelegate {
    
    let regex = RegexForSEARCH()
    let searchManager = SEARCHManager()
    var mURL : String = ""
    var viewCtrl: ViewController!
    var htmlHead : String = ""
    var htmlBody : String = ""

    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        
        
        mURL = (webView.URL?.absoluteString)!
        viewCtrl.addressBarTxt.text = mURL
        
        
        // Ineinander verschachtelt, weil completionHandler wartet bis ausgeführt wurde
        
        webView.evaluateJavaScript("document.head.innerHTML", completionHandler: { (object, error) -> Void in
            if error == nil && object != nil{
                self.htmlHead = (object as? String)!
            
            webView .evaluateJavaScript("document.body.innerHTML", completionHandler: { (object, error) -> Void in
                 if error == nil && object != nil{
                self.htmlBody = (object as? String)!
                
                let searchObjects = self.searchManager.getSEARCHObjects(self.htmlHead, htmlBody: self.htmlBody)
                
                
                print("Sechlinks found: \(searchObjects.count)")
                print("SechlinkIDs:")
                    
                self.viewCtrl.countSechsLabel.hidden = false
                self.viewCtrl.countSechsLabel.text = "\(searchObjects.count)"
                
                for item in searchObjects{
                    print(item.title)
                }
                //-> !
                // Put call for Request of EEXCESS here!
                
                let setRecommendations = ({(msg:String,data:[EEXCESSAllResponses]?) -> () in
                    print(msg)
                    // TODO: To be redesigned! 6
                    let ds = self.viewCtrl.tableViewDataSource
                    ds.makeLabels(searchObjects)
                    
                    if(data != nil){
                        self.viewCtrl.eexcessAllResponses = data
                    }else{
                        self.viewCtrl.eexcessAllResponses = []
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        // TODO: To be redesigned! 8
                        self.viewCtrl.rankThatShit(self.viewCtrl.eexcessAllResponses)
                        self.viewCtrl.tableView.reloadData()
                        
                    })
                })
                

                    let task = TaskCtrl()
                    task.getRecommendations(searchObjects, setRecommendations: setRecommendations)

                
                }
            })
            
            
                            }
        }
        )
            

        
            }
        
    
    func webView(webView: WKWebView, didFailLoadWithError error: NSError?) {

    }
            
        
}