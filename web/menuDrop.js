function init() {
    rotate(); menu();
}

            
            function rotate() {
          var images = new Array ('Images/maryrmitford.png', 'Images/MRMchild.png', 'Images/MRMwrit.png', 'Images/letter.png', 'Images/Flush.png', 'Images/MRMJul.png', 'Images/TMC.png', 'Images/Mitford-puzzle-color-1.png', 'Images/Mitford-puzzle-color-1-label.png')
                var thisImage = 0;
                /*ebb: This javascript rotates images on reload from server*/
                /*ebb: This line randomizes the order of the images:*/
      var thisImage = Math.floor(Math.random()*(images.length)) ;

          document.getElementById("rotator").src = images[thisImage];

         /*ebb: Uncomment this if you want continual image rotation in seconds*/
        /*  setTimeout(rotate, 5 * 1000);*/
          }


function menu() {
    var lis = document.getElementsByClassName('drops');
    for (var i = 0; i <lis.length; i++) {
        lis[i].addEventListener('click', dropDown, false);
               lis[i].addEventListener('dblclick', hide, false);
  }
    
}

function dropDown(){
    this.classList.toggle('dropped');
  var drops = document.getElementsByClassName('dropped');
    for (var j = 0; j <drops.length; j++) {
        drops[j].addEventListener('click', hide, false);
    }
}

function hide() {
    this.classList.toggle('drops');
}

window.onload = init