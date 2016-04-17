//
//  PopViewController.swift
//  Browser
//
//  Created by Andreas Netsch on 04.11.15.
//  Copyright © 2015 SECH-Tag-EEXCESS-Browser. All rights reserved.
//

import UIKit




class PopViewController : UIViewController{
    
    
//    @IBOutlet weak var sechText: UITextView!
    
    @IBOutlet weak var sechHeadline: UILabel!
    @IBOutlet weak var sechImage: UIImageView!
    @IBOutlet weak var sechWebView: UIWebView!
    
    private var popoverContent: SearchTableViewController!
    
    @IBAction func openTable(sender: AnyObject) {
//        var popoverContent = (self.storyboard?.instantiateViewControllerWithIdentifier("SearchTableViewController"))! as UIViewController
//        var nav = UINavigationController(rootViewController: popoverContent)
//        nav.modalPresentationStyle = UIModalPresentationStyle.Popover
//        var popover = nav.popoverPresentationController
//        popoverContent.preferredContentSize = CGSizeMake(500,600)
//       // popover!.delegate = self.view
//        popover!.sourceView = self.view
//        popover!.sourceRect = CGRectMake(100,100,0,0)
//        
//        self.presentViewController(nav, animated: true, completion: nil)
        

        if let popover = popoverContent.popoverPresentationController {
            
            let viewForSource = sender as! UIView
            popover.sourceView = viewForSource
            
            // the position of the popover where it's showed
            popover.sourceRect = viewForSource.bounds
            
            // the size you want to display
            popoverContent.preferredContentSize = CGSizeMake(400,500)
            //            popover.delegate = self.view
        }
        
        self.presentViewController(popoverContent, animated: true, completion: nil)
    }
    
    var headLine : String!
    var jsonText : String!
    var url : String!
    var searchTags : [SearchResultItem]!
    
    override func viewDidLoad() {
        
        sechHeadline.text = headLine
        
        guard let sTags = searchTags else{
            return
        }
        
        if(sTags.count > 0){
        
        let requesturl = NSURL(string: sTags[0].getUri())
        let request = NSURLRequest(URL: requesturl!)
        sechWebView.loadRequest(request)
        }else{
            let requesturl = NSURL(string: "http://www.sech-browser.de/404.html")
            let request = NSURLRequest(URL: requesturl!)
            sechWebView.loadRequest(request)
        }
        
        self.popoverContent = (self.storyboard?.instantiateViewControllerWithIdentifier("SearchTableViewController"))! as! SearchTableViewController
        
        popoverContent.searchLists = sTags
        popoverContent.sechWebView = sechWebView
        
        popoverContent.modalPresentationStyle = .Popover
      
     
        
        
    }
    
    
    @IBOutlet weak var SechTitle: UILabel!
    

    func setDetailsInSechView(url: String){
        
    }
    
    
    

}
