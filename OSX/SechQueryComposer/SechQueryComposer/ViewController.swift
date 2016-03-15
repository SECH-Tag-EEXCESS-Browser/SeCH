//
//  ViewController.swift
//  SechQueryComposer
//
//  Copyright © 2015 Peter Stoehr. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTextFieldDelegate {

    @IBOutlet weak var mainTopicMatrx: NSMatrix!
    @IBOutlet weak var processBar: NSProgressIndicator!
    @IBOutlet weak var recommendButton: NSButton!
    @IBOutlet weak var isMainWidthCons: NSLayoutConstraint!
    @IBOutlet weak var resultTable: NSTableView!
    
    @IBOutlet weak var kw00: NSTextField!
    @IBOutlet weak var kw01: NSTextField!
    @IBOutlet weak var kw02: NSTextField!
    @IBOutlet weak var kw03: NSTextField!
    let cntKWS = 4
    
    var isMainWidth = CGFloat(0.0)
    var recommendCTRL : RecommendationCTRL!
    var selectedRow = 0

    // ################################
    

    @IBAction func searchPressed(sender: NSButton) {
        
        let recData : ([String], Int?)
        
        if (checkForURL() == false)
        {
            print("Invalid URL")
            return
        }
        sender.hidden = true
        processBar.hidden = false
        processBar.startAnimation(self)
        
        recData = createRecommendInfo()
        recommendCTRL.getRecommendsForKeyWords(recData, dataSource: resultTable.dataSource() as! RecommendationDataSource){() -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                self.resultTable.reloadData()
                
                self.recommendButton.hidden = false
                self.processBar.hidden = true
                self.processBar.stopAnimation(self)
                self.resultTable.enabled = true
                
            })}
    }
    
    private func createRecommendInfo() -> ([String], Int?)
    {
        var keyWords : [String] = []
        var validKWS = 0;
        var isMainTopicIDX : Int? = nil
        
        var kwf = self.valueForKey("kw0\(validKWS)") as! NSTextField
        while((kwf.enabled) && (kwf.stringValue != "") && (validKWS < cntKWS-1))
        {
            keyWords.append(kwf.stringValue)
            validKWS += 1
            kwf = self.valueForKey("kw0\(validKWS)") as! NSTextField
        }
        
        if (validKWS >= 3)
        {
            isMainTopicIDX = mainTopicMatrx.selectedRow
        }
        
        return (keyWords, isMainTopicIDX)
    }
    
    // ################################

   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        processBar.hidden = true
        
        isMainWidth = isMainWidthCons.constant
        isMainWidthCons.constant = 0.0

        kw00.enabled =  true
        kw00.selectable = true
        kw00.delegate = self
        for i in 1 ..< cntKWS
        {
            let kwf = self.valueForKey("kw0\(i)") as? NSTextField
            kwf!.enabled = false
            //kwf!.selectable = false
            kwf!.delegate = self
        }
        
        let dele = resultTable.delegate() as! RecommendationDelegate
        dele.viewCtrl = self
        resultTable.enabled = false
        resultTable.doubleAction = Selector("performSegue:")
        // Create the CTRLs
        recommendCTRL = RecommendationCTRL()
        
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    func performSegue(table : NSTableView)
    {
        let ds = resultTable.dataSource() as! RecommendationDataSource
        selectedRow = table.selectedRow
        NSWorkspace.sharedWorkspace().openURL(NSURL(string: ds.data[selectedRow].uri)!)

        
        //performSegueWithIdentifier("toWebView", sender: self)
    }
    
    override func prepareForSegue(segue: NSStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "toWebView")
        {
            let ds = resultTable.dataSource() as! RecommendationDataSource
            let destCtrl = segue.destinationController as! WebViewCTRL
            destCtrl.url = ds.data[selectedRow].uri
            destCtrl.title = ds.data[selectedRow].title
        }
    }
    
    // Delegates fur Textfields

    override func controlTextDidEndEditing(obj: NSNotification) {
        if (kw03.stringValue == "") && (mainTopicMatrx.cellAtRow(3, column: 0) == mainTopicMatrx.selectedCell())
        {
            mainTopicMatrx.selectCellAtRow(0, column: 0)
        }
    }
    override func controlTextDidChange(notification: NSNotification)
    {
        var firstEmpty = 1
        while (firstEmpty < cntKWS)
        {
            let kwf = self.valueForKey("kw0\(firstEmpty)") as? NSTextField
            if (kwf!.stringValue == "")
            {
                break
            }
            firstEmpty += 1
        }

        for i in 0 ..< cntKWS
        {
            let kwf = self.valueForKey("kw0\(i)") as? NSTextField
            kwf!.enabled = (i <= firstEmpty)
        }
        
        if (firstEmpty >= 3)
        {
            isMainWidthCons.constant = isMainWidth
        }
        else {
            isMainWidthCons.constant = 0
        }

        mainTopicMatrx.cellAtRow(3, column: 0)?.enabled = (kw03.stringValue != "")
        
    }
    
    // TBDs
    func checkForURL() -> Bool
    {
        let p = Preferences()
        let urlStr = p.url
        let url = NSURL(string: urlStr)
        
        if (url == nil) {return false}
        let req = NSURLRequest(URL: url!)
        
        return NSURLConnection.canHandleRequest(req)
    }
    
}

