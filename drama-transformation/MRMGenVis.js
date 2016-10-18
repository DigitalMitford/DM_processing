//*ebb: 2016-10-18: There are issues here with getting next element (text) row to show on mouseclick/mouseover, but I've discovered there are problems in the output HTML the row text. Need to address that first.

function init() {showNums();showTexts();
}
/* For sorting, try working with this example: http://jsfiddle.net/g9eL6768/2/
 * 
 */

/* from Obdurodon: http://www.obdurodon.org/js/show-hide.js and not working here:
function next(elem) {
    do {
        elem = elem.nextSibling;
    }
    while (elem && elem.nodeType != 1);
    return elem;
}*/
 
 /*function showHide(sender) {
    var tr = sender.parentNode;
    var nextElem = next(tr);
    if (nextElem.style.display != 'none') {
        nextElem.style.display = 'none';
        
    } else {
        nextElem.style.display = 'block';
        
    }
}
 */
function showTexts() {
  var toShow = document.querySelectorAll('tr.vars');
        for (var i = 0; i < toShow.length; i++) {
        if (toShow[i].nextElementSibling)   toShow[i].addEventListener('mouseover', showRow, false);
            showTexts[i].addEventListener('click', showRow, false);
            showTexts[i].addEventListener('mouseout', hideRow, false);
            showTexts[i].addEventListener('dblclick', showRow, false);
        }
    
}  
    function showNums() {
        var hidNo = document.querySelectorAll('td');
        for (var i = 0; i < hidNo.length; i++) {
        if (hidNo[i].querySelector("span.hidNo"))    
             hidNo[i].addEventListener('mouseover', showMore, false);
            hidNo[i].addEventListener('click', showMore, false);
            hidNo[i].addEventListener('mouseout', hideMore, false);
            hidNo[i].addEventListener('dblclick', hideMore, false);
        }
        

          function showRow() {
            /*var arrow = this.querySelector("span.arrow");*/
            var newRow = this.nextElementSibling;
            console.log('newRow = ' + newRow);
            /*arrow.innerHTML = '&#x21a5;';*/
            newRow.style.display = "inline";

        }

        function hideRow() {
            /*var arrow = this.querySelector("span.arrow");*/
            var closeRow = this.nextElementSibling;
            closeRow.style.display = "none";
            /*arrow.innerHTML = '&#x21b4;';*/
        }    


        function showMore() {
            /*var arrow = this.querySelector("span.arrow");*/
            var whatMore = this.querySelector("span.hidNo");
            console.log('whatMore = ' + whatMore);
            /*arrow.innerHTML = '&#x21a5;';*/
            whatMore.style.display = "inline";

        }

        function hideMore() {
            /*var arrow = this.querySelector("span.arrow");*/
            var whatMore = this.querySelector("span.hidNo");
            whatMore.style.display = "none";
            /*arrow.innerHTML = '&#x21b4;';*/
        }

    }

           window.onload = init;
