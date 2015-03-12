

       var thisImage = 0;
   /*ebb: This javascript rotates images on reload from server*/         
            
            function rotate() {
          var images = new Array ('Images/maryrmitford.png', 'Images/MRMchild.png', 'Images/MRMwrit.png', 'Images/letter.png', 'Images/Flush.png', 'Images/MRMJul.png', 'Images/TMC.png', 'Images/Mitford-puzzle-color-1.png', 'Images/Mitford-puzzle-color-1-label.png')
  
  /*ebb: This line randomizes the order of the images:*/
      var thisImage = Math.floor(Math.random()*(images.length)) ;

          document.getElementById("rotator").src = images[thisImage];

         /*ebb: Uncomment this if you want continual image rotation in seconds*/
        /*  setTimeout(rotate, 5 * 1000);*/
          }
          
  
  /*ebb: Old code that seems only to work with continual image rotation in order, not for refresh from server.*/
         /*  var thisImage = 0;
            
            function rotate() {
          var images = new Array ('Images/maryrmitford.png', 'Images/MRMchild.png', 'Images/MRMwrit.png', 'Images/letter.png', 'Images/Flush.png', 'Images/MRMJul.png', 'Images/TMC.png'); 
          
          thisImage++;
          if (thisImage == images.length) {
          thisImage = 0;
          
          }
          document.getElementById("rotator").src = images[thisImage];
          
           setTimeout(rotate, 5 * 1000);
          }*/



       function toggle() {
           var mainEntry = document.getElementsByClassName('entry');
           for (var i = 0; i < mainEntry.length; i++) {
               if (mainEntry[i].querySelector("span.more"))

              
               mainEntry[i].addEventListener('mouseover', showMore, false);
               mainEntry[i].addEventListener('click', showMore, false);
             mainEntry[i].addEventListener('mouseout', hideMore, false);
               mainEntry[i].addEventListener('dblclick', hideMore, false);


           }


           function showMore() {
               var arrow = this.querySelector("span.arrow");
               var whatMore =  this.querySelector("span.more");
               console.log('whatMore = ' + whatMore);
               arrow.innerHTML = '&#x21a5;';
               whatMore.style.display = "inline";

           }

           function hideMore() {
               var arrow = this.querySelector("span.arrow");
               var whatMore = this.querySelector("span.more");

               whatMore.style.display = "none";
               arrow.innerHTML = '&#x21b4;';
           }

       }
           window.onload = toggle;
           rotate;


