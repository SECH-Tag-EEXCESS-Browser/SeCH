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
        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let requesturl = NSURL(string: searchLists[indexPath.row].getUri())
        let request = NSURLRequest(URL: requesturl!)
               
        sechWebView.loadRequest(request)
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
