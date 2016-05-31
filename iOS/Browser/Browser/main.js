// This javascript-file modifies the html-code of the current website when called:
//     - color all search-links
//     - add an id to all search-links (for identification on a website)
//     - get the current URL which each link is on (for global identification)
//     - add an eventListener to every search-link
//
// CORRECT WHEN CHANGED: This file is called in the ViewController.swift in the method rankThatShit()

var elements = document.getElementsByTagName("search-link");

for (var i=0; i<elements.length;i++){
    elements[i].style.color = "Red";
    elements[i].setAttribute("id",i);
    var currentURL = document.URL;
    elements[i].addEventListener("click", function(e){
                                 var x = e.clientX.toString();
                                 var y = e.clientY.toString();
                                  var currentTopic = this.getAttribute("topic");
                                  var currentID = this.getAttribute("id");
                                  webkit.messageHandlers.onclick.postMessage({"url":currentURL, "id":currentID, "topic":currentTopic, "x":x, "y":y});
                                  });
    }