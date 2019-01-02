// ==UserScript==
// @name        Google 100
// @namespace   http://saliman.net
// @description Set how many results per page Google should show (FF Quantum GM 4.x version)
// @run-at      document-end
// @include       http://*google.*/*
// @include       https://*google.*/*
// @exclude     http://maps.google.*
// @exclude     https://maps.google.*
// @version     57.0.0
// ==/UserScript==

// We always want 100 per page
var resultsPerPage = 100;
// Enable the "last update" item
/*
var as_qdr = document.getElementById("as_qdr_input");
if ( as_qdr != null ) {
  //as_qdr.name = "old_as_qdr";
    //as_qdr.id = "old_as_qdr";
    var parent = as_qdr.parentNode;
    parent.removeChild(as_qdr);
    var pull_down = document.createElement("select");
    pull_down.setAttribute('id', "as_qdr_input");
    pull_down.setAttribute('name', "tbs");
    pull_down.setAttribute('value', "all");
    var opt = new Option("All", "all");
    pull_down.appendChild(opt);
    opt = new Option("Past Year", "qdr:y");
    pull_down.appendChild(opt);
    opt = new Option("Past Month", "qdr:m");
    pull_down.appendChild(opt);
    opt = new Option("Past Week", "qdr:w");
    pull_down.appendChild(opt);
    opt = new Option("Past Day", "qdr:d");
    pull_down.appendChild(opt);
    opt = new Option("Past Hour", "qdr:h");
    pull_down.appendChild(opt);
    parent.appendChild(pull_down);
}
*/
(function(){
    document.body.setAttribute("style", "background-color: white;");
    // Clear any prior query
	/*
    var as_q = document.getElementsByName("as_q");
    if ( as_q.length > 0 ) {
        for ( var i=0; i < as_q.length; i++ ) {
            //alert ("as_q type: " + as_q[i].type);
            if ( as_q[i].type == "text" || as_q[i].type == "hidden" ) {
                //alert("cleared as_q");
                as_q[i].type = "text"
                as_q[i].value="";
            }
        }
    }
	*/

    // enable results per page and set results per page field.
    var num = document.getElementsByName("num");
    if ( num.length > 0 ) {
        // We have a "num" parameter, so make sure it is 100.
        for ( var i=0; i < num.length; i++ ) {
            //alert ("num type: " + num[i].type);
            if ( num[i].type == "text" || num[i].type == "hidden" ) {
                // alert("set num");
                as_q[i].value=resultsPerPage;
            } else if ( num[i].type == "select-one" ){
                //alert("enabled num");
                num[i].removeAttribute("disabled");
            }
        }
    } else {
        // we didn't already have a "num" parameter, so make one.
        var hidden_param = document.createElement('input');
        hidden_param.setAttribute('type', 'hidden');
        hidden_param.setAttribute('name', 'num');
        hidden_param.setAttribute('value', resultsPerPage);
        document.forms[0].appendChild(hidden_param);
        // alert("Appended num");
    }

})();

