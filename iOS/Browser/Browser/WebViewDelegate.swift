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
        viewCtrl.progressViewWebsite.hidden = true
        
        
        // Ineinander verschachtelt, weil completionHandler wartet bis ausgeführt wurde
        
        webView.evaluateJavaScript("document.head.innerHTML", completionHandler: { (object, error) -> Void in
            if error == nil && object != nil{
                self.htmlHead = (object as? String)!
            
                webView .evaluateJavaScript("document.body.innerHTML", completionHandler: { (object, error) -> Void in
                    if error == nil && object != nil{
                        self.htmlBody = (object as? String)!
                        //IBAction
                        
                        self.sechMng()
                    }
                })
            }
        })
    }
        
    
    func webView(webView: WKWebView, didFailLoadWithError error: NSError?) {

    }
    
    func sechMng(){
        
        //let searchObjects = self.searchManager.getSEARCHObjects(self.htmlHead, htmlBody: self.htmlBody)
        
        
//        print("Sechlinks found: \(searchObjects.count)")
//        print("SechlinkIDs:")
        
        self.viewCtrl.countSechsLabel.hidden = false
        //self.viewCtrl.countSechsLabel.text = "\(searchObjects.count)"
        
//        for item in searchObjects{
//            print(item.title)
//        }
        //-> !
        // Put call for Request of EEXCESS here!
        
        let task = TaskCtrl()
        
        let setRecommendations = ({(msg:String,data:SearchResults?) -> () in
            print(msg)
            // TODO: To be redesigned! 6
            let ds = self.viewCtrl.tableViewDataSource
            ds.makeLabels(task.searchObjects.getSearchModels())
            
            if(data != nil){
                self.viewCtrl.responses = data?.getSearchResults()
            }else{
                self.viewCtrl.responses = []
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                // TODO: To be redesigned! 8
                self.viewCtrl.rankThatShit(self.viewCtrl.responses)
                self.viewCtrl.tableView.reloadData()
                
            })
        })
        
        
        
        task.getRecommendations(WebContent(html: Html(head: self.htmlHead, body: self.htmlBody), url: (self.viewCtrl.myWebView?.URL?.absoluteString)!), setRecommendations: setRecommendations)
        
        
    }
    func webView(webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        print("#########didReceiveServerRedirectForProvisionalNavigation##########")
    }
    func webViewWebContentProcessDidTerminate(webView: WKWebView) {
        print("##########webViewWebContentProcessDidTerminate#########")
    }
    //    func webView(webView: WKWebView, decidePolicyForNavigationResponse navigationResponse: WKNavigationResponse, decisionHandler: (WKNavigationResponsePolicy) -> Void) {
    //    print("decidePolicyForNavigationResponse")
    //    }
    
}