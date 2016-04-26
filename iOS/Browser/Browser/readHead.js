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