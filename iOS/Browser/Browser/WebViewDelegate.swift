//
//  WebViewDelegate.swift
//  Browser
//
//  Created by Andreas Ziemer on 16.10.15.
//  Copyright © 2015 SECH-Tag-EEXCESS-Browser. All rights reserved.
//
// This is the Delegate-Class for the WebView shown in the main-view. At the top are the class-variables and below web-view-delegate-specific methods such
// as didFinishNavigation or didFailLoadWithError. At the bottom of the class other methods are listed that do not fall in the categories above.

import UIKit
import WebKit

class WebViewDelegate: NSObject, WKNavigationDelegate {
    
    //#########################################################################################################################################
    //##########################################################___Class_Variables___##########################################################
    //#########################################################################################################################################
    
    let regex = RegexForSEARCH()
    let searchManager = SEARCHManager()
    var mURL = ""
    var viewCtrl: ViewController!
    var htmlHead = ""
    var htmlBody = ""
    
    
    
    //#########################################################################################################################################
    //##########################################################___Web_View_Delegate_Methods___################################################
    //#########################################################################################################################################

    
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        viewCtrl.tableViewDataSource.emptyTable()
        viewCtrl.tableView.reloadData()
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        
        mURL = (webView.URL?.absoluteString)!
        viewCtrl.addressBarTxt.text = mURL
        viewCtrl.progressViewWebsite.hidden = true
        
        //Change SechButton Image
        viewCtrl.setSechButtonLoading(true)

        // Ineinander verschachtelt, weil completionHandler wartet bis ausgeführt wurde
        let scriptURL = NSBundle.mainBundle().pathForResource("readHead", ofType: "js")
        let scriptContent = try! String( contentsOfFile: scriptURL!, encoding:NSUTF8StringEncoding)
        webView.evaluateJavaScript( scriptContent, completionHandler: { (object, error) -> Void in
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
    
    func webView(webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        print("#########didReceiveServerRedirectForProvisionalNavigation##########")
    }
    
    func webViewWebContentProcessDidTerminate(webView: WKWebView) {
        print("##########webViewWebContentProcessDidTerminate#########")
    }
    
    
    
    //#########################################################################################################################################
    //##########################################################___Other_Methods___############################################################
    //#########################################################################################################################################
    
    func sechMng() {
        self.viewCtrl.countSechsLabel.hidden = false
        viewCtrl.enableSearchLinks()
        //-------------------------------- SeARCHExtraction ----------------------------------------
        // Generate SearchObjects for QueryBuildCtrl
        viewCtrl.searchModelsOfCurrentPage = SEARCHManager().getSEARCHObjects(WebContent(html: Html(head: self.htmlHead, body: self.htmlBody), url: (self.viewCtrl.myWebView?.URL?.absoluteString)!))
        //-------------------------------- /SeARCHExtraction ---------------------------------------
    }
}