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
    
    init(html:Html){
        self.html = html
    }
    
    func getHtml()->Html{
        return self.html
    }
    
}

public class Html{
    private let head:String
    private let body:String
    
    init(head:String,body:String){
        self.body = body
        self.head = head
    }
    
    func getHead()->String{
        return head
    }
    
    func getBody()->String{
        return body
    }
}