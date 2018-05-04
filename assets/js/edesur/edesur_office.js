var geocoder;
var map;
var markers = new Array();

function loadMarker(map,color){
  var reclamosData;
  if (color == 'red'){ reclamosData = reclamosInfo.red }
  if (color == 'green'){ reclamosData = reclamosInfo.green }
  if (color == 'orange'){ reclamosData = reclamosInfo.orange }      

  $.each(reclamosData, function(i, item) {
    var marker = new google.maps.Marker({
      position: item.LatLng,
      map: map,
      title: 'Reclamo: '+ item.codigo_reclamo
    });
    marker.setIcon('http://maps.google.com/mapfiles/ms/icons/'+color+'-dot.png');
    markers.push(marker);
  });
}

function setMapOnAll(map) {
  for (var i = 0; i < markers.length; i++) {
    markers[i].setMap(map);
  }
}

function changeMarkers(color){
  console.log('hola');
  clearMarkers();
  if (color == 'all'){
    loadMarker(map,'green');
    loadMarker(map,'orange');
    loadMarker(map,'red');   
  } else {
    loadMarker(map,color);
  }
}

function clearMarkers() {
  setMapOnAll(null);
}

function initialize() {
  geocoder = new google.maps.Geocoder();
  var latlng = new google.maps.LatLng(-34.8184400, -58.4562500);
  var mapOptions = { zoom: 12,center: latlng};
  map = new google.maps.Map(document.getElementById('map'), mapOptions);

  loadMarker(map,'green');
  loadMarker(map,'orange');
  loadMarker(map,'red');

  setMapOnAll(map);

}


$( document ).ready(function() {
  //  console.log( "ready!" );
});
