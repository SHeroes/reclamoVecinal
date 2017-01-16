
var elemento;
//$("#calle").parents("p").next()

 $(document).ready(function(){
    
   $(".calle").keyup(function(){
    elemento = $(this);
    //console.log(elm.val());
    if(elemento.val().length>3){
      //console.log("es:" + $("#calle").val());
      var dataToSearch = {
          searchCalle: elemento.val()
        };
    $.ajax({
     type: "post",
     url: "/index.php/main_operator/search_calle",
     cache: false,    
     data: dataToSearch,
     success: calle_encontrada2,
     error: function(){      
      alert('Error while request..');
     }
    });
    }
    return false;
  });

  function calle_encontrada(response){
      $('#finalResult').html("");
      var obj = JSON.parse(response);
      if(obj.length>0){
       try{
        var items=[];  
        $.each(obj, function(i,val){           
            items.push($('<li/>').text(val.id_calle + " " + val.calle));
        }); 
        $('#finalResult').append.apply($('#finalResult'), items);
       }catch(e) {  
        alert('Exception while request..');
       }  
      }else{
       $('#finalResult').html($('<li/>').text("No Data Found"));   
      }  
  };


  function calle_encontrada2(response){
      var resultDOM = elemento.parents("p").next();
      resultDOM.html("");   //$('.input-search-result').html("");
      //console.log(resultDOM);
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

      //$('#calle').next().val(81)
      // USO EL elemento QUE ES GLOBAL, AL QUE LE DI EL CLICK
      hiddenElement = $(elemento.next());
      hiddenElement.attr("value", val);

      elemento.val(elementoClickeado.html());
      //alert(elemento.val());
      resultDOM.hide();
      //console.log(hiddenElement.attr("value"));
    });
  };

  $("#id_domicilio").change(function(){
  if($("#id_domicilio").val() != ""){
    console.log("quitar el Required del formulario");

    }
  });

 });
