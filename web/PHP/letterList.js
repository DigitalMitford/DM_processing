
window.onload = init;
function init() {listShow();
}

function listShow() {
    var yearListing = document.getElementsByClassName('year');
    for (var i = 0; i < yearListing.length; i++) {
        yearListing[i].addEventListener('select', showLetterList, false);
        yearListing[i].addEventListener('keydown', showLetterList, false);
        yearListing[i].addEventListener('click', showLetterList, false);
        /* yearListing[i].addEventListener('mouseout', hideMore, false);*/
        yearListing[i].addEventListener('dblclick', hideLetterList, false);


    }
}


    function showLetterList() {
        /* var arrow = this.querySelector("span.arrow");*/
        var whatMore = this.querySelector("ul.letterList");
        console.log('whatMore = ' + whatMore);
        /*arrow.innerHTML = '&#x21a5;';*/
        whatMore.style.display = "inline";

    }

    function hideLetterList() {
        /* var arrow = this.querySelector("span.arrow");*/
        var whatMore = this.querySelector("ul.letterList");

        whatMore.style.display = "none";
        /*  arrow.innerHTML = '&#x21b4;';*/
    }





