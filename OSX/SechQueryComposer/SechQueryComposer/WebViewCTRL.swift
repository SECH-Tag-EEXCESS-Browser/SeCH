//
//  WebViewCTRL.swift
//  SechQueryComposer
//
//  Copyright © 2015 Peter Stoehr. All rights reserved.
//

import Cocoa
import WebKit

class WebViewCTRL: NSViewController {

    var url : String = ""
    
    @IBOutlet weak var myWebView: WebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadAddressURL()
    }
    

    func loadAddressURL(){
        let requesturl = NSURL(string: url)
        let request = NSURLRequest(URL: requesturl!)
        myWebView.mainFrame.loadRequest(request)
    }
    
}
