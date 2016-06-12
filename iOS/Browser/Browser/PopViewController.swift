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

class PopViewController : UIViewController{
    
    //#########################################################################################################################################
    //##########################################################___Class_Variables___##########################################################
    //#########################################################################################################################################
    
    @IBOutlet weak var sechHeadline: UILabel!
    @IBOutlet weak var sechImage: UIImageView!
    @IBOutlet weak var sechWebView: UIWebView!
    
//    var searchTags : [SearchResultItem]!
    private var popoverContent: SearchTableViewController!
    var xPosition : Int!
    var yPosition : Int!
    private var myContext = 0
    var viewCtrl:ViewController?

    //##########################################################___PopViewController_Methods___################################################
    //#########################################################################################################################################
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewCtrl!.searchResultsOfPages[viewCtrl!.currentSearchModel!]!.addObserver(self, forKeyPath: "mSearchResults", options: .New, context: &myContext)
        loadpopView(viewCtrl!.searchResultsOfPages[viewCtrl!.currentSearchModel!]!.getSearchResultForTitle(viewCtrl!.currentSearchModel!))
    }
    
    func loadpopView(lresult:SearchResult?){
        guard let results = lresult else {
            return
        }
        sechHeadline.text = results.getTitle()

        if(!results.getResultItems().isEmpty){
            viewCtrl?.setSechButtonLoading(false)
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
    //##########################################################___other-Methods___############################################################
    //#########################################################################################################################################

    func setDetailsInSechView(url: String){
        
    }
}