$(document).ready(function(){

/*
  $("#state .btn").click(function() {
    
    var state_str = $("#status_selector").val();
    var id_reclamo = $("#state").attr("id-rec");

    $(".state").each(function (index, elem){
      var el = $(elem);
      if (el.attr("id_reclamo") == id_reclamo){
        el.children("div").html(state_str);
      }
    });

    var dataToSearch = {
      id_reclamo: id_reclamo,
      state: state_str
    };
    $.ajax({
     type: "post",
     url: "/index.php/main_office/actualizar_estado",
     cache: false,    
     data: dataToSearch,
     success: $("#state").dialog('close'),
     error: function(){      
      alert('Error while request..');
     }
    });  
  });
*/

/*
TODO si la clave del usuario actual es clave1234 entonces sugerir cambio de clave
*/
//  alert("La clave actual es: clave1234 , cambiela");


  $("#ch_pass .btn").click( function (){
      alert("Enviando ...");
  });

});

function change_password(){
  $("#ch_pass").dialog();
}