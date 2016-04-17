//
//  WebContent.swift
//  Browser
//
//  Created by Lothar Manuel Mödl on 22.03.16.
//  Copyright © 2016 SECH-Tag-EEXCESS-Browser. All rights reserved.
//

import Foundation

public class WebContent{
    private let html:Html
    private let url: String
    
    init(html:Html, url:String){
        self.html = html
        self.url = url
    }
    
    func getHtml()->Html{
        return self.html
    }
    func getUrl()-> String{
        return self.url
    }
}

public class Html{
    private let head:String
    private let body:String
    
    init(head:String,body:String){

        self.body = body
        self.head = head
    }
    
    func getHeadAndBody()->(String,String){
        return (head,body)
    }
}