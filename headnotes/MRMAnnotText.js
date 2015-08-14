function init() {
    var anchors = document.getElementsByClassName("anchor");
    for (var i = 0; i < anchors.length; i++) {
        anchors[i].addEventListener('mouseover', show_footnote, false);
        anchors[i].addEventListener('click', show_footnote, false);
        anchors[i].addEventListener('mouseout', hide_footnote, false);
        anchors[i].addEventListener('dblclick', hide_footnote, false);

        anchors[i].addEventListener('touchenter', show_footnote, false);
        anchors[i].addEventListener('touchleave', hide_footnote, false);

    }
    
    var spclasses = 'person org place title';
    console.log('spclasses = ' + spclasses);
    var spclassArray, a, b;
    spclassArray = spclasses.split(' ');
    console.log('spclassArray = ' + spclassArray);
    for (a = 0; a < spclassArray.length; a++) {
        console.log('spclassArray[' + a + '] =' + spclassArray[a]);
        spclasschange = document.getElementsByClassName(spclassArray[a]);
        for (b = 0; b < spclasschange.length; b++) {
            
         spclasschange[b].addEventListener('mouseover', show_SI, false);
        spclasschange[b].addEventListener('click', show_SI, false);
        spclasschange[b].addEventListener('mouseout', hide_SI, false);
        spclasschange[b].addEventListener('dblclick', hide_SI, false);

        spclasschange[b].addEventListener('touchenter', show_SI, false);
        spclasschange[b].addEventListener('touchleave', hide_SI, false);
        }
        
    }

    var fieldset = document.getElementsByTagName('input');
    for (var j = 0; j < fieldset.length; j++) {
        fieldset[j].addEventListener('click', toggle, false);
    }
    
    
    /*THOUGHTS for retooling color-clicks: set a new var for tagname input (for the checkboxes).
    var checkbox = document.getElementsByTagName("input:)
    checkbox.onclick = */
}

function show_footnote() {
    var footnote = this.firstElementChild;
    console.log('footnote = ' + footnote);
    footnote.style.display = "inline";
}
function hide_footnote() {
    var footnote = this.firstElementChild;
    footnote.style.display = "none";
}

function show_SI(){
var siteIndex = this.querySelector("span.si");
    console.log('siteIndex = ' + siteIndex);
    siteIndex.style.display= "inline";
}

function hide_SI(){
    var siteIndex = this.querySelector("span.si");
    siteIndex.style.display= "none";
}


function toggle() {
    var classes = 'reg del add sic caret pagebreak jerk prose supplied damage'; 
    /*This identifies the variable classes as a string of text, containing the different class values I want to toggle.*/
    console.log('classes = ' + classes);
    /*This lets me look in the console log at the output of the classes variable. It's a concatenated syntax: 'classes= ' is just a string to introduce it, and + is the concatenator, then classes is the classes function.*/
    var classArray, i, j; /*This declares three variables: classArray and two range variables, since we'll need to range twice.*/
    classArray = classes.split(' '); /*classArray is defined by splitting the variable classes on white space.*/
    console.log('classArray = ' + classArray);
    for (i = 0; i < classArray.length; i++) {
        console.log('classArray[' + i + '] =' + classArray[i]);
        /*Here, our range variable, i, is looping over classArray*/
        
        classchange = document.getElementsByClassName(classArray[i]);
        /*Now, for each return of the range variable i, we get elements by class name, and next turn to each of them in turn, using range variable j.*/
        for (j = 0; j < classchange.length; j++) {
            classchange[j].classList.toggle("on");
        }
    }
}



window.onload = init;