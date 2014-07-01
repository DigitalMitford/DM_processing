function init() {
   
         var unfurl = document.getElementsByClassName('lists');
       for (var i=0; i <unfurl.length; i++)
{unfurl[i].addEventListener('click', toggle, false);}
       
}

function toggle() {
var id = this.id;
var hist_persons = document.getElementsByClassName("hist_persons");
var histOrgs = document.getElementsByClassName("histOrgs");
var histPlaces = document.getElementsByClassName("histPlaces");
var events = document.getElementsByClassName("events");
var plants = document.getElementsByClassName("plants");

var fict_chars = document.getElementsByClassName("fict_chars");
var fictOrgs = document.getElementsByClassName("fictOrgs");
var archetypes = document.getElementsByClassName("archetypes");
var fictPlaces = document.getElementsByClassName("fictPlaces");

var artWorks = document.getElementsByClassName("artWorks");
var refWorks = document.getElementsByClassName("refWorks");
var periodical = document.getElementsByClassName("periodical");
var litWorks = document.getElementsByClassName("litWorks");
var currSchol = document.getElementsByClassName("currSchol");
var archives = document.getElementsByClassName("archives");

var pastEditors = document.getElementsByClassName("pastEditors");
var Mitford_Team = document.getElementsByClassName("Mitford_Team");

switch (id) {
 case "hist_persons_toggle": {
  var a;
  for (a=0; a < hist_persons.length; a++)
  {hist_persons[a].classList.toggle("on")}
   }
break;
  case "hist_orgs_toggle": {
  var b;
  for (b=0; b < histOrgs.length; b++)
  {histOrgs[b].classList.toggle("on")}
   }
  break;
  case "places_hist_toggle": {
  var c;
  for (c=0; c < histPlaces.length; c++)
  {histPlaces[c].classList.toggle("on")}
   }
  break;
  case "events_toggle": {
  var d;
  for (d=0; d < events.length; d++)
  {events[d].classList.toggle("on")}
   }
  break;
  case "plant_toggle": {
  var e;
  for (e=0; e < plants.length; e++)
  {plants[e].classList.toggle("on")}
   }
  break;
  case "fict_chars_toggle": {
  var f;
  for (f=0; f < fict_chars.length; f++)
  {fict_chars[f].classList.toggle("on")}
   }
  break;
  case "fict_orgs_toggle": {
  var g;
  for (g=0; g < fictOrgs.length; g++)
  {fictOrgs[g].classList.toggle("on")}
   }
  break;
  case "archetypes_toggle": {
  var h;
  for (h=0; h < archetypes.length; h++)
  {archetypes[h].classList.toggle("on")}
   }
  break;
  case "places_fict_toggle": {
  var i;
  for (i=0; i < fictPlaces.length; i++)
  {fictPlaces[i].classList.toggle("on")}
   }
  break;
  case "art_toggle": {
  var j;
  for (j=0; j < artWorks.length; j++)
  {artWorks[j].classList.toggle("on")}
   }
  break;
  case "ref_19thc_toggle": {
  var k;
  for (k=0; k < refWorks.length; k++)
  {refWorks[k].classList.toggle("on")}
   }
  break;
  case "per_19thc_toggle": {
  var l;
  for (l=0; l < periodical.length; l++)
  {periodical[l].classList.toggle("on")}
   }
  break;
  case "literary": {
  var m;
  for (m=0; m < litWorks.length; m++)
  {litWorks[m].classList.toggle("on")}
   }
  break;
   case "currSchol_toggle": {
  var n;
  for (n=0; n < currSchol.length; n++)
  {currSchol[n].classList.toggle("on")}
   }
  break;
   case "archives_toggle": {
  var o;
  for (o=0; o < archives.length; o++)
  {archives[o].classList.toggle("on")}
   }
  break; case "Past_Editors_toggle": {
  var p;
  for (p=0; p < pastEditors.length; p++)
  {pastEditors[p].classList.toggle("on")}
   }
  break; case "Mitford_Team_toggle": {
  var q;
  for (q=0; q < Mitford_Team.length; q++)
  {Mitford_Team[q].classList.toggle("on")}
   }
  break;
  
}

   }

window.onload = init;