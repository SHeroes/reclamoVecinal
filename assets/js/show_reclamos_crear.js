
 $(document).ready(function(){
   
   if($(".vecinos_filtrados").length > 0){
    //alert("asdasd");
    $(".vecinos_filtrados").click(function() {
        var row = $(this);
        var value = row.children("th").attr("id-value");
        var seleccion = $(row.children("td"));
        var Apellido = $(seleccion.get(0));
        var Nombre = $(seleccion.get(1));

        alert("El vecino seleccionado es:  " + Apellido.html() + ", " + Nombre.html());


        $(".buscar_vecinos").hide();

        //$(".filtro-secretaria").show();


        //$(".id_vecino").val(value);

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
        console.log($(".filtro-secretaria"));
        //console.log("con valor:" , value);
        //$(".filtro-secretaria").show();
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
      //alert(elemento.val());
      resultDOM.hide();
    });
  };


  var DOM_elem_Required = $("#usar_domicilio_vecino").parents("#domicilio-reclamo-data").children("p").children(".required");
  $("#usar_domicilio_vecino").change(function(){
    if($("#usar_domicilio_vecino").prop( "checked" )){
      DOM_elem_Required.each(function( index ) {
        $(this).prop('required',false);
        $(this).prop('disabled',true);
        $("#columna_electrica").prop('disabled',true);
      });      
    } else{
      DOM_elem_Required.each(function( index ) {
        $(this).prop('required',true);
        $(this).prop('disabled',false);
        $("#columna_electrica").prop('disabled',false);
      });
    }
  });

  $(".tipo_reclamo_row").click(function(){
      var elementoClickeado = $($(this));
      var val = elementoClickeado.attr("value");
      hiddenElement = $('#tipo_reclamo');
      hiddenElement.attr("value", val);
      $(".reclamo-form").show();
      //alert("Se seleccionó el tipo de reclamo: " + elementoClickeado.html());
  });

});
