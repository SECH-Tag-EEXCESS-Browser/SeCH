//
//  ViewController.swift
//  Browser
//
//  Created by Andreas Ziemer on 14.10.15.
//  Copyright © 2015 SECH-Tag-EEXCESS-Browser. All rights reserved.
//
// This class handles the mainscreen of the application. In the upper most part the class variables are defined. Below this is a collection of viewcontroller specific
// methods which holds methods like viewDidLoad(), viewWillAppear(), ect. AND methods for reacting to elements of the view such as observers, segues and tableViews.
// After that the IB-Action-Methods are listed. At the end of this class methods are listed that do not fall in any of the categories above.

import UIKit
import WebKit

class ViewController: UIViewController ,WKScriptMessageHandler,  UIPopoverPresentationControllerDelegate, UITableViewDelegate, BackDelegate
{
    //#########################################################################################################################################
    //##########################################################___Class_Variables___##########################################################
    //#########################################################################################################################################
    
    // IBOutlets
    @IBOutlet weak var sechWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var forwardButton: UIBarButtonItem!
    @IBOutlet weak var addressBarTxt: UITextField!
    @IBOutlet weak var reloadButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var countSechsLabel: UILabel!
    @IBOutlet weak var sechButton: UIBarButtonItem!
    @IBOutlet weak var progressViewWebsite: UIProgressView!
    
    // WebView Variables
    var myWebView: WKWebView?
    var myWebViewDelegate : WebViewDelegate!
    var webViewWidth: NSLayoutConstraint!
    var webViewHeight: NSLayoutConstraint!
    var webViewYpos: NSLayoutConstraint!
    var config = WKWebViewConfiguration()
    
    // Settings Variables
    let settingsPers = SettingsPersistency()
    var settings = SettingsModel()
    
    // Other Variables
    let myAdressBar: AddressBar = AddressBar()
    let p : DataObjectPersistency = DataObjectPersistency()
    let tableViewDataSource = SechTableDataSource()
    private var indexPathForSelectedSearchTag: Int!
    var headLine : String!
    var favourites = [FavouritesModel]()
    var xPosition : Int!
    var yPosition : Int!
    
//    ***************************************************************
    //var responses: [SearchResult]!
    var searchModelsOfCurrentPage:SEARCHModels?
    var currentSearchModel:SEARCHModel?
    var searchResultsOfPages = [SEARCHModel:SearchResults]()
//    ***************************************************************

    //################################################################################################################################################
    //##########################################################___View_Controlling_Methods___##########################################################
    //################################################################################################################################################
    
    //#########___On_start_View___#########
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup WebView
        myWebViewDelegate = WebViewDelegate()
        myWebViewDelegate.viewCtrl = self
        config.userContentController.addScriptMessageHandler(self, name: "onclick")
        self.myWebView = WKWebView(frame: containerView.bounds, configuration: config)
        self.containerView.addSubview(myWebView!)
        myWebView!.translatesAutoresizingMaskIntoConstraints = false // Neu seit iOS 9
        webViewWidth = NSLayoutConstraint(item: myWebView!, attribute: .Width, relatedBy: .Equal, toItem: containerView, attribute: .Width, multiplier: 1.0, constant: 0.0)
        webViewHeight = NSLayoutConstraint(item: myWebView!, attribute: .Height, relatedBy: .Equal, toItem: containerView, attribute: .Height, multiplier: 1.0, constant: 0.0)
        webViewYpos = NSLayoutConstraint(item: myWebView!, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1.0, constant: 64.0)
        
        self.view.addConstraint(webViewWidth)
        self.view.addConstraint(webViewHeight)
        self.view.addConstraint(webViewYpos)
        
        myWebView?.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)
        myWebView?.addObserver(self, forKeyPath: "canGoBack", options: .New, context: nil)
        myWebView?.addObserver(self, forKeyPath: "canGoForward", options: .New, context: nil)
        
        
        // Setup SechTableView
        tableView.delegate = self
        tableView.dataSource = tableViewDataSource
        tableView.hidden = true
        sechWidthConstraint.constant = 0
        
        // Setup Settings
        settings = settingsPers.loadDataObject()
        
        // Additional Setups
        progressViewWebsite.hidden = true
        countSechsLabel.hidden = true
        
        forwardButton.enabled = false  //Disable back & forward Buttons at the beginning
        backButton.enabled = false
        
        // Load Startpage of Browser
        let homeUrl = settings.homeURL
        let url = myAdressBar.checkURL(homeUrl)
        loadURL(url)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        favourites = p.loadDataObject()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //Set Constrains
        containerView.addSubview(myWebView!)
        myWebView?.navigationDelegate = myWebViewDelegate
    }
    
    override func viewWillLayoutSubviews() {
        
        var frame = addressBarTxt.frame
        frame.size.width = 42000
        
        super.viewWillLayoutSubviews()
        addressBarTxt.frame = frame
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    //#########___View_Handling___#########
    
    // Obeserver Methods added
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "estimatedProgress" {
            progressViewWebsite.hidden = false
            progressViewWebsite.progress = Float ((myWebView?.estimatedProgress)!)
        }
        
        if keyPath == "canGoBack"{
            backButton.enabled = (myWebView?.canGoBack)!
        }
        
        if keyPath == "canGoForward"{
            forwardButton.enabled = (myWebView?.canGoForward)!
        }
    }
    
    // Segue Methods
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "editBookmarks"
        {
            let destVC = segue.destinationViewController as! FavouriteTableViewController
            destVC.favourites = favourites
            destVC.delegate = self
        }
        
        if segue.identifier == "showPopView"
        {
            let popViewController = segue.destinationViewController as! PopViewController
            
            //Change Size from PopViewController
            popViewController.preferredContentSize.height = (UIScreen.mainScreen().bounds.height)*0.66
            popViewController.preferredContentSize.width = (UIScreen.mainScreen().bounds.width)*0.66
            popViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
            print("Segue "+self.headLine)
            popViewController.headLine = self.headLine
            popViewController.xPosition = self.xPosition
            popViewController.yPosition = self.yPosition
            
            if self.searchResultsOfPages[self.currentSearchModel!] != nil ? self.searchResultsOfPages[self.currentSearchModel!]!.hasResults():false {
                let title = self.currentSearchModel?.title
                popViewController.searchTags = self.searchResultsOfPages[self.currentSearchModel!]!.getSearchResultForTitle(title!)!.getResultItems()//responses[indexPathForSelectedSearchTag].getResultItems()
            }else{
                popViewController.jsonText = "NO RESULTS"
                popViewController.url = "https://www.google.de/?gws_rd=ssl#q=Mein+Name+ist+Hase"
            }
            
            popViewController.popoverPresentationController?.delegate = self
            popViewController.popoverPresentationController?.sourceRect = CGRectMake(CGFloat(xPosition), CGFloat(yPosition) , 400, 500)
            popViewController.popoverPresentationController?.canOverlapSourceViewRect = true
            
            
        }
    }
    
    // Sechtableview Delegate
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        
        self.indexPathForSelectedSearchTag = indexPath.row
        
        let currentCell = tableView.cellForRowAtIndexPath(indexPath)! as UITableViewCell
        
        headLine = (currentCell.textLabel?.text!)! as String
        print("\n\n\n\n\n\n\n")
        print("selected: "+headLine)
        
        return indexPath
    }
    
    
    
    //###########################################################################################################################################
    //##########################################################___IB-Action-Methods___##########################################################
    //###########################################################################################################################################
    
    //Adressbar
    @IBAction func addressBar(sender: UITextField) {
        let url = myAdressBar.checkURL(sender.text!)
        loadURL(url)
         }
    
    @IBAction func homeBtn(sender: AnyObject){
        let homeUrl = settings.homeURL
        let url = myAdressBar.checkURL(homeUrl)
        loadURL(url)
    }
    
    
    // Favourites
    @IBAction func favouriteButton(sender: AnyObject) {
        let alertSheetController = UIAlertController(title: "Favoriten hinzufügen", message: "Geben Sie den Titel ein", preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel)
        {
            action-> Void in
            print("Cancel")
        }
        
        alertSheetController.addAction(cancelAction)
        
        let enterAction = UIAlertAction(title: "Enter", style: .Default)
        {
            action-> Void in
            
            let textfield : UITextField = alertSheetController.textFields![0]
            let fav = FavouritesModel()
            
            self.favourites.append(fav)
            
            fav.title = textfield.text!
            fav.url = self.addressBarTxt.text!
            
            self.p.saveDataObject(self.favourites)
        }
        
        alertSheetController.addAction(enterAction)
        
        alertSheetController.addTextFieldWithConfigurationHandler
        {
                textField -> Void in
                textField.placeholder="Titel"
        }
        
        alertSheetController.addTextFieldWithConfigurationHandler
        {
                textField -> Void in
                textField.placeholder="URL"
                textField.text = self.addressBarTxt.text
        }
        
        self.presentViewController(alertSheetController, animated: true) {}
    }
    
    @IBAction func favBtn(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("editBookmarks", sender: self)
    }
    
    
    // Navigation
    @IBAction func reloadButton(sender: AnyObject){
        myWebView!.reload()
    }
    
    @IBAction func forwardButton(sender: AnyObject){
        myWebView!.goForward()
    }
    
    @IBAction func backButton(sender: AnyObject){
        myWebView!.goBack()
    }
    
    
    // Sechtable
    @IBAction func doPopover(sender: AnyObject) {
        
        //If Sech-Table not visible
        if (tableView.hidden == true){
            UIView.animateWithDuration(0.4, animations: { () -> Void in
                self.sechWidthConstraint.constant = 210;
                self.tableView.hidden = false
                self.view.layoutIfNeeded()
            })
            
            //If Sech-Table visible
        }else{
            countSechAnimation()
            self.tableView.hidden = true
        }
    }
    
    
    // Settings
    @IBAction func optionsMenu(sender: UIBarButtonItem) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("OptionsMenu")
        vc.modalPresentationStyle = UIModalPresentationStyle.Popover
        let popover: UIPopoverPresentationController = vc.popoverPresentationController!
        popover.barButtonItem = sender
        popover.delegate = self
        presentViewController(vc, animated: true, completion:nil)
    }
    
    
    
    //###########################################################################################################################################
    //##########################################################___Ranking-Methods___############################################################
    //###########################################################################################################################################
    
    
    func doRank(){
        //Warum guard?
        guard let allResponses = self.searchResultsOfPages[self.currentSearchModel!]?.getSearchResults() else{
            return
        }
        
        let rule : Rules = Rules()
        
        for i in 0 ..< allResponses.count {
            
            let seachRule: SeachRules = SeachRules()
            
            for j in 0 ..< allResponses[i].getResultItems().count {
                var rules: [Rule] = []
                let mendeley : Mendeley = Mendeley(expectedResult: "Mendeley")
                let language: Language = Language(expectedResult: LanguageType.German, title: allResponses[i].getResultItems()[j].getTitle())
                let mediaType: MediaType = MediaType(expectedResult: MediaTypes.image)
                rules.append(mendeley)
                rules.append(language)
                rules.append(mediaType)
                seachRule.appendSeachRules(rules)
            }
            rule.addRule(seachRule)
        }
        enableSearchLinks()
        rule.applyRulesToAllResponses(allResponses)

        //Change SechButton Image
        setSechButtonLoading(false)
        
    }
    
    
    
    //#########################################################################################################################################
    //##########################################################___Other-Methods___############################################################
    //#########################################################################################################################################
    
    func enableSearchLinks(){
        let scriptURL = NSBundle.mainBundle().pathForResource("main", ofType: "js")
        let scriptContent = try! String( contentsOfFile: scriptURL!, encoding:NSUTF8StringEncoding)
        self.myWebView?.evaluateJavaScript(scriptContent, completionHandler: { (object, error) in
        })
    }
    
    func countSechAnimation(){
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self.sechWidthConstraint.constant = 0;
            self.view.layoutIfNeeded()
        })
        
        self.tableView.hidden = true
    }
    
    func loadURL(requestURL : String){
        let url = NSURL(string: requestURL)
        let request = NSURLRequest (URL: url!)
        myWebView?.loadRequest(request)
        addressBarTxt.text = requestURL
    }

    func userContentController(userContentController: WKUserContentController,
        didReceiveScriptMessage message: WKScriptMessage) {
            print("JavaScript is sending a message \(message.body)")
            let json = message.body as! [String:String]
            
            let id = Int(json["id"]!)

            self.indexPathForSelectedSearchTag = id
 
            self.headLine = json["topic"]
            self.xPosition = Int(json["x"]!)!
            self.yPosition = Int(json["y"]!)!
            
            guard let models = searchModelsOfCurrentPage?.getSearchModels() else{
                return
            }
            for model in models {
                if model.url == json["url"]! && model.index == id {
                    currentSearchModel = model
                }
            }
            
            let setRecommendations = ({(status:String,msg: String, results: [SearchResult]) -> () in
                print(msg)
                // TODO: To be redesigned! 6
                
                if(status == "FAILED"){
                    self.tableViewDataSource.sechTags = []
                    self.tableView.reloadData()
                    self.setSechButtonLoading(false)
                    return
                }
                
                if(!results.isEmpty){
                    self.tableViewDataSource.appendLabel(results[0].getTitle())
                    //self.responses = [result!]
                    if self.searchResultsOfPages[self.currentSearchModel!] == nil {
                        self.searchResultsOfPages[self.currentSearchModel!] = SearchResults(searchResults: [])
                    }
                    self.searchResultsOfPages[self.currentSearchModel!]?.appendAll(results)
                }else{
                    //self.responses = []
                }
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    // TODO: To be redesigned! 8
                    self.doRank()
                    self.tableView.reloadData()
                    print("######### SeARCH fertig #########")
                    self.showPopView()
                })
            })

            let results = self.searchResultsOfPages[currentSearchModel!]
            
            print("-------------------------")
            
            if currentSearchModel != nil {
                print(currentSearchModel!.title)
            }
            for (key,result) in self.searchResultsOfPages {
                print(key.title)
                print("####################")

            }
            print("-------------------------")
            
            if (results != nil ? (results!.hasResults()):false) {
//            if results!.hasResults(){
                  setRecommendations("OK","Result wurde im Speicher gefunden", results!.getSearchResults())
            }
            else{
            let task = TaskCtrl()
            
                        // Start SearchTask -> find results for Search-tags
            task.getRecommendationsNew(currentSearchModel!, setRecommendations: setRecommendations)
                setSechButtonLoading(true)
        }
    }
    
    func showPopView(){
        performSegueWithIdentifier("showPopView", sender: self)
    }
    
    func setSechButtonLoading(bool : Bool){
        if bool == true{
            sechButton.image = UIImage(named: "SechLoadIcon")
        }else{
            sechButton.image = UIImage(named: "SechIcon")
        }
    }
    
    func receiveInfo(ctrl: FavouriteTableViewController, info: FavouritesModel) {
        loadURL(info.url)
        ctrl.navigationController?.popToRootViewControllerAnimated(true)
    }

}