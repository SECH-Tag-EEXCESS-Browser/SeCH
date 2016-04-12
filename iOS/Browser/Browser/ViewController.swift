//
//  ViewController.swift
//  Browser
//
//  Created by Andreas Ziemer on 14.10.15.
//  Copyright © 2015 SECH-Tag-EEXCESS-Browser. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController ,WKScriptMessageHandler,  UIPopoverPresentationControllerDelegate, UITableViewDelegate, BackDelegate
{
    
    private var indexPathForSelectedSearchTag: Int!
    
    var myWebView: WKWebView?
    
//    override func loadView() {
//        super.loadView()
//        
//        self.myWebView = WKWebView(frame: containerView.bounds)
//        containerView.addSubview(myWebView!)
//    }
    
    var myWebViewDelegate : WebViewDelegate!
    let myAdressBar: AddressBar = AddressBar()

    let p : DataObjectPersistency = DataObjectPersistency()
    let tableViewDataSource = SechTableDataSource()
//    var p = DataObjectPersistency()
//    var tableViewDataSource = SechTableDataSource()

    
    let settingsPers = SettingsPersistency()
    var settings = SettingsModel()
    var eexcessAllResponses: [EEXCESSAllResponses]!
    var headLine : String!
    
    @IBOutlet weak var sechWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var forwardButton: UIBarButtonItem!
    @IBOutlet weak var addressBarTxt: UITextField!
    @IBOutlet weak var reloadButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var countSechsLabel: UILabel!
    
    @IBOutlet weak var progressViewWebsite: UIProgressView!
    
    var webViewWidth: NSLayoutConstraint!
    var webViewHeight: NSLayoutConstraint!
    var webViewYpos: NSLayoutConstraint!
    
    var favourites = [FavouritesModel]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        myWebViewDelegate = WebViewDelegate()
        myWebViewDelegate.viewCtrl = self
        
        countSechsLabel.hidden = true
       
        // Do any additional setup after loading the view, typically from a nib.
        tableView.delegate = self
        tableView.dataSource = tableViewDataSource
        
        
        //p = DataObjectPersistency()
        settings = settingsPers.loadDataObject()
        
        let config = WKWebViewConfiguration()
        let scriptURL = NSBundle.mainBundle().pathForResource("main", ofType: "js")
        let scriptContent = try! String( contentsOfFile: scriptURL!, encoding:NSUTF8StringEncoding)
        let script = WKUserScript(source: scriptContent, injectionTime: .AtDocumentStart, forMainFrameOnly: true)
        config.userContentController.addUserScript(script)
        
        config.userContentController.addScriptMessageHandler(self, name: "onclick")
        
        //WebView erzeugen
        self.myWebView = WKWebView(frame: containerView.bounds, configuration: config)
        self.containerView.addSubview(myWebView!)
        

        myWebView!.translatesAutoresizingMaskIntoConstraints = false // Neu seit iOS 9

        webViewWidth = NSLayoutConstraint(item: myWebView!, attribute: .Width, relatedBy: .Equal, toItem: containerView, attribute: .Width, multiplier: 1.0, constant: 0.0)
        
        webViewHeight = NSLayoutConstraint(item: myWebView!, attribute: .Height, relatedBy: .Equal, toItem: containerView, attribute: .Height, multiplier: 1.0, constant: 0.0)

        webViewYpos = NSLayoutConstraint(item: myWebView!, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1.0, constant: 64.0)

        self.view.addConstraint(webViewWidth)
        self.view.addConstraint(webViewHeight)
        self.view.addConstraint(webViewYpos)
        
        tableView.hidden = true
        sechWidthConstraint.constant = 0
        
        //Observer for ProgressBarWebsite
        myWebView?.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //Constrains setzen
        containerView.addSubview(myWebView!)
        myWebView?.navigationDelegate = myWebViewDelegate
    }
    
    override func viewWillLayoutSubviews() {
        
        var frame = addressBarTxt.frame
        frame.size.width = 42000
        
        super.viewWillLayoutSubviews()
        addressBarTxt.frame = frame
        
    }

    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        favourites = p.loadDataObject()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        //Dispose of any resources that can be recreated.
    }
    
    //Obeserver Function for ProgressBar Website
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "estimatedProgress" {
            progressViewWebsite.progress = Float ((myWebView?.estimatedProgress)!)
        }
    }
    
    func receiveInfo(ctrl: FavouriteTableViewController, info: FavouritesModel)
    {
        loadURL(info.url)
        ctrl.navigationController?.popToRootViewControllerAnimated(true)
    }

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
    
    func loadURL(requestURL : String){
        let url = NSURL(string: requestURL)
        let request = NSURLRequest (URL: url!)
        myWebView?.loadRequest(request)
        addressBarTxt.text = requestURL
    }
    
    //Adressbar Ende
    @IBAction func favouriteButton(sender: AnyObject)
    {
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
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "editBookmarks"
        {
            let destVC = segue.destinationViewController as! FavouriteTableViewController
            destVC.favourites = favourites
            destVC.delegate = self

        }

//        if segue.identifier == "PopoverViewController"{
//            let destVC = segue.destinationViewController as! PopViewController
//            destVC.title = "This is From Segue"
//        }

        if segue.identifier == "showPopView"
        {
            let popViewController = segue.destinationViewController as! PopViewController
            popViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
            print("Segue "+self.headLine)
            popViewController.headLine = self.headLine
//            popViewController.jsonText = SechModel.instance.sechs[self.headLine]?.response.convertToString()
//            popViewController.url = SechModel.instance.sechs[self.headLine]?.responseObject.documentBadge.uri
//            if let response = SechPage.instance.sechs[self.headLine]?.getFirstSingleResponseObject(){
//                popViewController.jsonText = response.getString()
//                popViewController.url = response.documentBadge.getURI()
//            }else{
//                popViewController.jsonText = "NO RESULTS"
//                popViewController.url = "https://www.google.de/"
//            }
            if eexcessAllResponses != nil && eexcessAllResponses.count > 0{
                popViewController.searchTags = eexcessAllResponses[indexPathForSelectedSearchTag].responses
//                popViewController.url = response
            }else{
                popViewController.jsonText = "NO RESULTS"
                popViewController.url = "https://www.google.de/?gws_rd=ssl#q=Mein+Name+ist+Hase"
            }
            
            popViewController.popoverPresentationController?.delegate = self

        }
    

    }
    
    
    @IBAction func reloadButton(sender: AnyObject)
    {
         myWebView!.reload()
    }
    
    @IBAction func forwardButton(sender: AnyObject)
    {
        myWebView!.goForward()
    }

    @IBAction func backButton(sender: AnyObject)
    {
        myWebView!.goBack()
    }

    @IBAction func doPopover(sender: AnyObject) {

        //Wenn Sech ausgeblendet
        if (tableView.hidden == true){
            UIView.animateWithDuration(0.4, animations: { () -> Void in
                self.sechWidthConstraint.constant = 160;
                self.tableView.hidden = false
                self.view.layoutIfNeeded()
            })
            
        //Wenn Sech eingeblendet
        }else{
            countSechAnimation()
            self.tableView.hidden = true
        }
    }
    
    func countSechAnimation(){
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self.sechWidthConstraint.constant = 0;
            self.view.layoutIfNeeded()
        })
        
        self.tableView.hidden = true
    }
    
    
    @IBAction func optionsMenu(sender: UIBarButtonItem) {
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("OptionsMenu")
        vc.modalPresentationStyle = UIModalPresentationStyle.Popover
        let popover: UIPopoverPresentationController = vc.popoverPresentationController!
        popover.barButtonItem = sender
        popover.delegate = self
        presentViewController(vc, animated: true, completion:nil)
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        

//        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewControllerWithIdentifier("PopoverViewController")
//        vc.modalPresentationStyle = UIModalPresentationStyle.Popover
//        
//        //vc.prepareForSegue(<#T##segue: UIStoryboardSegue##UIStoryboardSegue#>, sender: <#T##AnyObject?#>)
//        
//        let popover: UIPopoverPresentationController = vc.popoverPresentationController!
//        popover.sourceView = tableView.cellForRowAtIndexPath(indexPath)
//        popover.sourceRect = (tableView.cellForRowAtIndexPath(indexPath)?.bounds)!
//        popover.delegate = self
//        
//        presentViewController(vc, animated: true, completion:nil)
//        
//
        self.indexPathForSelectedSearchTag = indexPath.row

        let currentCell = tableView.cellForRowAtIndexPath(indexPath)! as UITableViewCell
        
        headLine = (currentCell.textLabel?.text!)! as String
        print("\n\n\n\n\n\n\n")
        print("selected: "+headLine)
        
//        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewControllerWithIdentifier("PopoverViewController")
//        vc.modalPresentationStyle = UIModalPresentationStyle.Popover
//        
//        
//        let popover: UIPopoverPresentationController = vc.popoverPresentationController!
//        popover.sourceView = tableView.cellForRowAtIndexPath(indexPath)
//        popover.sourceRect = (tableView.cellForRowAtIndexPath(indexPath)?.bounds)!
//        popover.delegate = self

        
        
        
        
//        presentViewController(vc, animated: true, completion:nil)
        
        return indexPath
    }
    
    func userContentController(userContentController: WKUserContentController,
        didReceiveScriptMessage message: WKScriptMessage) {
            print("JavaScript is sending a message \(message.body)")
            //self.headLine
            let str  = message.body as! String
//            str.characters.split($0 == "|").map(String.init)
            var strs = str.componentsSeparatedByString("|")
            
            print(strs[0])
            
            self.headLine = ""
            
            for i in 1 ..< strs.count {
                self.headLine = self.headLine + strs[i]
            }
            
            //str.sp
            let sechTags = tableViewDataSource.sechTags
            
            for i in 0 ..< sechTags.count {
                if(eexcessAllResponses[i].index == Int(strs[0])){
                    self.indexPathForSelectedSearchTag = i
                }
            }
            
            
            performSegueWithIdentifier("showPopView", sender: self)
   
    }
    
    func rankThatShit(eexcessAllResponses: [EEXCESSAllResponses]!){
        print("Before Rules \(eexcessAllResponses)")
        
        guard let allResponses = eexcessAllResponses else{
            return
        }
        
        let rule : Rules = Rules()
        
        for i in 0 ..< allResponses.count {
            
             let seachRule: SeachRules = SeachRules()
            
            for j in 0 ..< allResponses[i].responses.count {
                var rules: [Rule] = []
                let mendeley : Mendeley = Mendeley(expectedResult: "Mendeley")
                let language: Language = Language(expectedResult: LanguageType.German, title: allResponses[i].responses[j].title)
                let mediaType: MediaType = MediaType(expectedResult: MediaTypes.image)
                rules.append(mendeley)
                rules.append(language)
                rules.append(mediaType)
                
               
                seachRule.appendSeachRules(rules)
            }
            
            rule.addRule(seachRule)
            
        }
        
        
        rule.applyRulesToAllResponses(allResponses)
        print("After Rules \(eexcessAllResponses)")

    }

}

