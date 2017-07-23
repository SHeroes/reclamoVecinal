
 $(document).ready(function(){
   
  $("#boton_mas_reclamos").click(function() {
    if(!$("#usar_domicilio_vecino").prop( "checked" )){
      if($("#calle_id_hidden").val() == ''){
        alert ("Falta completar el campo de calle");
        return;
      }else if ($("#altura_inicio").val() == ''){
        alert ("Falta completar el campo de altura");
        return;
      } 
    }

    var str_obj = '{';
    $(".reclamo-form .more-reg").each(function(index, elem){
      //console.log($(elem).attr("name") + $(elem).val());
     
      var name = '';
      var value = '';
      if ( $(elem).attr("type") == 'checkbox' ){
        if ( $(elem).prop('checked') ) {
          name = $(elem).attr("name");
          value = $(elem).prop('checked');
        }else {
          //nadaaaaa 
        }
      }else {
        name = $(elem).attr("name");
        value = $(elem).val();
      }

      if (index >0) {str_obj = str_obj + ",";}
      str_obj = str_obj +'"'+ name +'":"'+ value +'"';
    });

    str_obj = str_obj + '}';
    console.log(str_obj);
    var dataToSearch = $.parseJSON(str_obj);
    $.ajax({
     type: "post",
     url: "/index.php/main_operator/insert_varios_reclamos",
     cache: false,    
     data: dataToSearch,
     success: un_reclamo_exitoso,
     error: function(){      
      alert('Error while request..');
     }
    }); 
  }); 
    
  function un_reclamo_exitoso(response){
    alert(response);
    //  var obj = JSON.parse(response);
  }


  if($(".vecinos_filtrados").length > 0){
    $(".vecinos_filtrados").click(function() {
        var row = $(this);
        var value = row.children("th").attr("id-value");
        var seleccion = $(row.children("td"));
        var Apellido = $(seleccion.get(0));
        var Nombre = $(seleccion.get(1));

        alert("El vecino seleccionado es:  " + Apellido.html() + ", " + Nombre.html());
        $(".buscar_vecinos").hide();
        $(".id_vecino").each(function( index , item){
          elem = $(item);
          elem.attr("value",value);
        });

        $(".name_vecino").each(function( index , item){
          elem = $(item);
          elem.attr("value", Apellido.html() + ", " + Nombre.html());
        });

        $(".buscar_vecinos").hide();
        $(".filtro-secretaria").show();
    }); 
  };
   
   $(".calle").keyup(function(){
    elemento = $(this);
    if(elemento.val().length>3){
      var dataToSearch = {
          searchCalle: elemento.val()
        };
    $.ajax({
     type: "post",
     url: "/index.php/main_operator/search_calle",
     cache: false,    
     data: dataToSearch,
     success: calle_encontrada,
     error: function(){      
      alert('Error while request..');
     }
    });
    }
    return false;
  });

  function calle_encontrada(response){
      var resultDOM = elemento.parents("p").next();
      resultDOM.html("");   
      var obj = JSON.parse(response);
      if(obj.length>0){
       try{
        var items=[];  
        $.each(obj, function(i,val){           
            items.push('<div class="result" value="'+ val.id_calle +'" item="'+(i+1)+'">'+ val.calle + '</div>');
        }); 
        resultDOM.append.apply(resultDOM, items);
        resultDOM.show();
        clickeable(resultDOM);
       }catch(e) {  
        alert('Exception while request..');
       }  
      }else{
       resultDOM.html($('<div class="result fail" />').text("No hay calles con ese nombre"));   
      } 
  };

  function clickeable(resultDOM){
    $('div.result').click(function(){
      var elementoClickeado = $($(this));
      var val = elementoClickeado.attr("value");
      // USO EL elemento QUE ES GLOBAL, AL QUE LE DI EL CLICK
      hiddenElement = $(elemento.next());
      hiddenElement.attr("value", val);

      elemento.val(elementoClickeado.html());
      resultDOM.hide();
    });
  };

  var DOM_elem_Required = $("#usar_domicilio_vecino").parents("#domicilio-reclamo-data").children("p").children(".required");
  $("#usar_domicilio_vecino").change(function(){
    if($("#usar_domicilio_vecino").prop( "checked" )){
        var id_vecino = $($(".id_vecino").get(0)).val();
        var dataToSearch = { id_vecino: id_vecino };
        $.ajax({
         type: "post",
         url: "/index.php/main_operator/search_domicilio_by_id_vecino",
         cache: false,    
         data: dataToSearch,
         success: domicilio_vecino_encontrado,
         error: function(){      
          alert('Error while request..');
         }
        }); 
        DOM_elem_Required.each(function( index ) {
          $(this).prop('required',false);
          $(this).prop('disabled',true);
          //$("#columna_electrica").prop('disabled',true);
        }); 
    }else{
        DOM_elem_Required.each(function( index ) {
          $(this).prop('required',true);
          $(this).prop('disabled',false);
          //$("#columna_electrica").prop('disabled',false);
        });
        $("#calle").val('');
        $("#altura_inicio").val('');
        $("#altura_fin").val('');
        $("#entrecalle1").val('');
        $("#entrecalle2").val('');
        $("#id_barrio").val('');
        $("#columna_electrica").val('');
    }
  });

  function domicilio_vecino_encontrado(response){
    var obj = JSON.parse(response);
    $("#calle").val(obj.calle);
    $("#altura_inicio").val(obj.altura);
    $("#altura_fin").val(obj.altura_fin);
    $("#entrecalle1").val(obj.entrecalle1);
    $("#entrecalle2").val(obj.entrecalle2);
    $("#id_barrio").val(obj.id_barrio);
    $("#columna_electrica").val(obj.columna_luminaria);
  };

  $(".tipo_reclamo_row").click(function(){
      var elementoClickeado = $($(this));
      var val = elementoClickeado.attr("value");
      hiddenElement = $('#tipo_reclamo');
      hiddenElement.attr("value", val);
      $(".reclamo-form").show();
      //alert("Se seleccionó el tipo de reclamo: " + elementoClickeado.html());
      $(".reclamo-form").show();

      //elementoClickeado.addClass('info');

      $('html,body').animate({scrollTop: $(".reclamo-form").offset().top});
      $("#tipo_reclamo_seleccionado").html(elementoClickeado.html());
  });

});
