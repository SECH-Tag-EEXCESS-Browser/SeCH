//
//  SearchTableViewController.swift
//  Browser
//
//  Created by Philipp Winterholler  on 08.01.16.
//  Copyright © 2016 SECH-Tag-EEXCESS-Browser. All rights reserved.
//
// This class implements the Delegate and Controller for the tableView that displayes the titels of the found search-tags.
// At the top the class-varables are defined and below tableView-controller-specific methods are collected.
// For the tableViewDATASOURCE look for file SechTableDataSource.swift.

import UIKit

class SearchTableViewController: UITableViewController {
    
    //#########################################################################################################################################
    //##########################################################___Class_Variables___##########################################################
    //#########################################################################################################################################
    
    var searchLists : [SearchResultItem] = [SearchResultItem(title: "Test", provider: "unknown", uri: "http://www.google.de", language: "de", mediaType: "text")]
    var sechWebView: UIWebView!

    
    
    //#########################################################################################################################################
    //##########################################################___Table_ViewController_Methods___#############################################
    //#########################################################################################################################################
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source


    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return searchLists.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("listCell", forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel!.text = searchLists[indexPath.row].getTitle()
        //cell.detailTextLabel?.text = "Reason why this super duper cool item is here"
        cell.detailTextLabel?.text = searchLists[indexPath.row].getUri()
        
        
        
        var provider = "Europeana"
        let someCharacter: String = searchLists[indexPath.row].getUri()
        
        if someCharacter.contains("swissbib"){
            provider = "Swissbib"
        }
        if someCharacter.contains("mendeley"){
            provider = "Mendeley"
        }
        if someCharacter.contains("CORE.ac.uk"){
            provider = "CORE.ac.uk"
        }
        if someCharacter.contains("dnb"){
            provider = "DeutscheNationalbibliothek"
        }
        if someCharacter.contains("mendeley"){
            provider = "Mendeley"
        }
        if someCharacter.contains("mendeley"){
            provider = "Mendeley"
        }
        
        
//        "CORE.ac.uk"
//        "ZBW"
//        "Digital Public Library of America"
//        "The National Archives UK"
//        "RijksMuseum"
//        "DeutscheNationalbibliothek"
//        "Europeana"
//        "KIMPortal"
        //2 arrays: 1 mit den ganzen Providern 2 mit den Ganzen Bildern. Dann mittels for-schleife beide vergleichen
//        "Deutsche Digitale Bibliothek"
        let url = NSURL(string: "https://eexcess.joanneum.at/eexcess-privacy-proxy-issuer-1.0-SNAPSHOT/issuer/getPartnerFavIcon?partnerId="+provider)
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
            dispatch_async(dispatch_get_main_queue(), {
                cell.imageView!.image = UIImage(data: data!)
            });
        }
//        let url = NSURL(string : "https://eexcess.joanneum.at/eexcess-privacy-proxy-issuer-1.0-SNAPSHOT/issuer/getPartnerFavIcon?partnerId=Europeana")
//        
//        var pic = NSData(contentsOfURL: url!, options: <#T##NSDataReadingOptions#>)
//        
//        let image : UIImage = UIImage(data: pic)!
//        cell.imageView!.image = image
        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let requesturl = NSURL(string: searchLists[indexPath.row].getUri())
        let request = NSURLRequest(URL: requesturl!)
               
        sechWebView.loadRequest(request)
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
