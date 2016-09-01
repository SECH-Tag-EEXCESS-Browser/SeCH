//
//  PopViewController.swift
//  Browser
//
//  Created by Andreas Netsch on 04.11.15.
//  Copyright © 2015 SECH-Tag-EEXCESS-Browser. All rights reserved.
//
// This class implements the PopViewController for the popview that displays the content of the search-tag selected in the sechTableView.
// At the top class-variables are defined and below that popview-controller-specific methods are collected. After that the IB-Actions and other
// methods are listed.

import UIKit

class PopViewController: UIViewController, UIWebViewDelegate{
    
    //#########################################################################################################################################
    //##########################################################___Class_Variables___##########################################################
    //#########################################################################################################################################
    
    @IBOutlet weak var sechHeadline: UILabel!
    @IBOutlet weak var sechWebView: UIWebView!
    @IBOutlet weak var allSearchResults: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
//    var searchTags : [SearchResultItem]!
    private var popoverContent: SearchTableViewController!
    var xPosition : Int!
    var yPosition : Int!
    var sechTitel : String!
    private var myContext = 0
    var viewCtrl:ViewController?

    //##########################################################___PopViewController_Methods___################################################
    //#########################################################################################################################################
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Indicator start
        activityIndicator.alpha = 0.7
        activityIndicator.startAnimating()
        
        sechWebView.delegate = self
        sechHeadline.text = sechTitel
        allSearchResults.enabled = false
        
        // Transparent Background
        self.view.layer.backgroundColor = UIColor.clearColor().CGColor
        self.view.subviews.first?.backgroundColor = UIColor.clearColor()
        sechWebView?.scrollView.backgroundColor = UIColor.clearColor()

        
        viewCtrl!.searchResultsOfPages[viewCtrl!.currentSearchModel!]!.addObserver(self, forKeyPath: "mSearchResults", options: .New, context: &myContext)
        loadpopView(viewCtrl!.searchResultsOfPages[viewCtrl!.currentSearchModel!]!.getSearchResultForTitle(viewCtrl!.currentSearchModel!))
        self.sechWebView?.opaque = false
        self.sechWebView?.backgroundColor = UIColor.clearColor()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        sechWebView.stopLoading()
        sechWebView.delegate = nil 
    }
    func loadpopView(lresult:SearchResult?){
        guard let results = lresult else {
            return
        }
        
        sechHeadline.text = results.getTitle()

        if(!results.getResultItems().isEmpty){
            let requesturl = NSURL(string: results.getResultItems()[0].getUri())
            let request = NSURLRequest(URL: requesturl!)
            sechWebView.loadRequest(request)
            
        }else{
            let requesturl = NSURL(string: "http://www.sech-browser.de/404.html")
            let request = NSURLRequest(URL: requesturl!)
            sechWebView.loadRequest(request)
        }
        
        self.popoverContent = (self.storyboard?.instantiateViewControllerWithIdentifier("SearchTableViewController"))! as! SearchTableViewController
        
        popoverContent.searchLists = results.getResultItems()
        popoverContent.sechWebView = sechWebView
        popoverContent.modalPresentationStyle = .Popover
        popoverContent.popoverPresentationController?.permittedArrowDirections = .Up
        
    }
    
    
    //#########################################################################################################################################
    //##########################################################___IB-Actions___###############################################################
    //#########################################################################################################################################
    
    @IBAction func openTable(sender: AnyObject) {
        
        if let popover = popoverContent.popoverPresentationController {
            
            let viewForSource = sender as! UIView
            popover.sourceView = viewForSource
            
            // the position of the popover where it's showed
           popover.sourceRect = viewForSource.bounds
            
            // the size you want to display
            popoverContent.preferredContentSize = CGSizeMake(400,500)
        }
        
        self.presentViewController(popoverContent, animated: true, completion: nil)
    }
    
    //#########################################################################################################################################
    //##########################################################___observe-Methods___############################################################
    //#########################################################################################################################################
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if context == &myContext {
            if let newValue = change?[NSKeyValueChangeNewKey] {
                loadpopView(viewCtrl!.searchResultsOfPages[viewCtrl!.currentSearchModel!]!.getSearchResult(viewCtrl!.currentSearchModel!))
            }
        } else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
    
    deinit {
        if viewCtrl!.searchResultsOfPages[viewCtrl!.currentSearchModel!] != nil {
            viewCtrl!.searchResultsOfPages[viewCtrl!.currentSearchModel!]!.removeObserver(self, forKeyPath: "mSearchResults", context: &myContext)
        }
    }
    
    //#########################################################################################################################################
    //##########################################################___webviewdelegat___###########################################################
    //#########################################################################################################################################
    
    func webViewDidStartLoad(sechWebView: UIWebView) {
        viewCtrl?.setSechButtonLoading(false)
        allSearchResults.enabled = true
        
        // Start Indicator if another page is selected
        if (!activityIndicator.isAnimating()){
            activityIndicator.hidden = false
            activityIndicator.startAnimating()
        }
    }
    
    func webViewDidFinishLoad(sechWebView: UIWebView) {
        activityIndicator.stopAnimating()
        activityIndicator.hidden = true
    }
    
    func webView(sechWebView: UIWebView, didFailLoadWithError error: NSError) {
        activityIndicator.stopAnimating()
        activityIndicator.hidden = true
    }
    
    //#########################################################################################################################################
    //##########################################################___other-Methods___############################################################
    //#########################################################################################################################################

    func setDetailsInSechView(url: String){
        
    }
}
