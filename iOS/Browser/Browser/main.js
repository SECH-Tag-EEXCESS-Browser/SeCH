
window.onload = function() {    
    var elements = document.getElementsByTagName("search-link");
    for (var i=0; i<elements.length;i++){
        elements[i].style.color = "Red";
        elements[i].setAttribute("id",i);
        elements[i].addEventListener("click", function(){
                                     var currentTopic = this.getAttribute("topic");
                                     var currentID = this.getAttribute("id");
                                     webkit.messageHandlers.onclick.postMessage(currentID+"|"+currentTopic);});
    }
}

