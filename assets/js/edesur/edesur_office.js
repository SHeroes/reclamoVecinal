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

$(document).ready(function(){

  $("td .state").click(function() {
    var reclamoElement = $(this).parents("tr").children("th");
    var id_reclamo = reclamoElement.attr("id_reclamo");
    var cod_reclamo = reclamoElement.html();
    var rec_edesur = $(this).attr("id-rec-edesur");
    if($(this).html()=="OK"){
      console.log($(this).html());
    }else{
      alert("Se procede a cambiar el estado del suministro del reclamo con codigo:  "+cod_reclamo);
      //console.log("id"+id_reclamo);
      //console.log($(this));
      //console.log("rec_edesur "+rec_edesur);
      var sendingData = {
        rec_asociado: id_reclamo,
        rec_edesur: rec_edesur
      };
      $.ajax({
       type: "post",
       url: "/index.php/edesur/Main_edesur_vecino/update_reclamo_edesur",
       cache: false,    
       data: sendingData,
       success: reloadPage,
       error: function(){      
        alert('Error cambiando el estado del servicio..');
       }
      });
    }
  });

});

function reloadPage(response){
  console.log(response);
  console.log("reloading...");
  window.location.replace("/index.php/edesur/main_edesur_office/show_main");  
}
