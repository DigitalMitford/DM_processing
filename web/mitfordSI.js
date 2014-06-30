function init() {
   
         var unfurl = document.getElementsByClassName('lists');
       for (var i=0; i <unfurl.length; i++)
{unfurl[i].addEventListener('click', toggle, false);}
       
}

function toggle() {
var id = this.id;
var hist_persons = document.getElementById("hist_persons");
var histOrgs = document.getElementbyId("histOrgs");
var histPlaces = document.getElementbyId("histPlaces");
var events = document.getElementbyId("events");
var plants = document.getElementbyId("plants");

var fict_chars = document.getElementById("fict_chars");
var fictOrgs = document.getElementbyId("fictOrgs");
var archetypes = document.getElementbyId("archetypes");
var fictPlaces = document.getElementbyId("fictPlaces");

var artWorks = document.getElementbyId("artWorks");
var refWorks = document.getElementbyId("refWorks");
var periodical = document.getElementbyId("periodical");
var litWorks = document.getElementbyId("litWorks");
var currSchol = document.getElementbyId("currSchol");
var archives = document.getElementbyId("archives");

var pastEditors = document.getElementbyId("pastEditors");
var Mitford_Team = document.getElementbyId("Mitford_Team");

switch (id) {
 case "hist_persons_toggle": {
  var e;
  for (e=0; e < hist_persons.length; e++)
  {hist_persons[e].classList.toggle("on")}
   };
break;
  case "hist_orgs_toggle": {
  var e;
  for (e=0; e < histOrgs.length; e++)
  {histOrgs[e].classList.toggle("on")}
   };
  break;
  case "places_hist_toggle": {
  var e;
  for (e=0; e < histPlaces.length; e++)
  {histPlaces[e].classList.toggle("on")}
   };
  break;
  case "events_toggle": {
  var e;
  for (e=0; e < events.length; e++)
  {events[e].classList.toggle("on")}
   };
  break;
  case "plant_toggle": {
  var e;
  for (e=0; e < plants.length; e++)
  {plants[e].classList.toggle("on")}
   };
  break;
  case "fict_chars_toggle": {
  var e;
  for (e=0; e < fict_chars.length; e++)
  {fict_chars[e].classList.toggle("on")}
   };
  break;
  case "fict_orgs_toggle": {
  var e;
  for (e=0; e < fictOrgs.length; e++)
  {fictOrgs[e].classList.toggle("on")}
   };
  break;
  case "archetypes_toggle": {
  var e;
  for (e=0; e < archetypes.length; e++)
  {archetypes[e].classList.toggle("on")}
   };
  break;
  case "places_fict_toggle": {
  var e;
  for (e=0; e < fictPlaces.length; e++)
  {fictPlaces[e].classList.toggle("on")}
   };
  break;
  case "art_toggle": {
  var e;
  for (e=0; e < artWorks.length; e++)
  {artWorks[e].classList.toggle("on")}
   };
  break;
  case "ref_19thc_toggle": {
  var e;
  for (e=0; e < refWorks.length; e++)
  {refWorks[e].classList.toggle("on")}
   };
  break;
  case "per_19thc_toggle": {
  var e;
  for (e=0; e < periodical.length; e++)
  {periodical[e].classList.toggle("on")}
   };
  break;
  case "literary": {
  var e;
  for (e=0; e < litWorks.length; e++)
  {litWorks[e].classList.toggle("on")}
   };
  break;
   case "currSchol_toggle": {
  var e;
  for (e=0; e < currSchol.length; e++)
  {currSchol[e].classList.toggle("on")}
   };
  break;
   case "archives_toggle": {
  var e;
  for (e=0; e < archives.length; e++)
  {archives[e].classList.toggle("on")}
   };
  break; case "Past_Editors_toggle": {
  var e;
  for (e=0; e < pastEditors.length; e++)
  {pastEditors[e].classList.toggle("on")}
   };
  break; case "Mitford_Team_toggle": {
  var e;
  for (e=0; e < Mitford_Team.length; e++)
  {Mitford_Team[e].classList.toggle("on")}
   };
  break;
  
}

   }

window.onload = init;