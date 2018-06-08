A basic example of using Leaflet-IIIF, all in 5 lines!

This example does the following:

  - initializes the `map` object LN:1
  - sets the options used in map initialization LN:2-LN4
  - adds a newly created Leaflet-IIIF layer to the map

This could also be done more verbosely:

```javascript
var map = L.map('map', {
  center: [0, 0],
  crs: L.CRS.Simple,
  zoom: 0,
});

L.tileLayer.iiif('https://stacks.stanford.edu/image/iiif/hg676jb4964%2F0380_796-44/info.json').addTo(map);

```
  