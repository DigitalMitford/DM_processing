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

window.onload = menu