// This javascript-file implements a method that returns all attributes of the search-meta-tag (search-head) on the Webiste. It returns
// a long string with every attribute added after another.
//
// CORRECT WHEN CHANGED: This file is called in the WebViewDelegat.swift

function returnHead(){
    var metas = document.getElementsByTagName("META");
    var i;
    for (i = 0; i < metas.length; i++) {
        if (metas[i].getAttribute("name") == "search-head"){
            var string = "";
            
            
            
            string = string + "topic=" + "\"" + metas[i].getAttribute("topic") + "\" ";
            string = string + "type=" + "\"" + metas[i].getAttribute("type") + "\" ";
            string = string + "mediaType=" + "\"" + metas[i].getAttribute("mediaType") + "\" ";
            string = string + "provider=" + "\"" + metas[i].getAttribute("provider") + "\" ";
            string = string + "licence=" + "\"" + metas[i].getAttribute("licence") + "\" ";
            
            
            return string;
        }
    }
    return "Nothing found";
}
returnHead();