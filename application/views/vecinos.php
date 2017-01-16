<?php //echo '<script src="'. base_url() .'assets/js/show_sectors.js"></script>'; 
    
?>

<div class="container">
  <h1> Vecinos Registrados</h1>
  <?php 
    echo '<table class="table"><thead class="thead-inverse">        <tr>
      <th>#id</th><th>Denominación del Sector</th><th>Tipo Sector</th><th>id Dependencia</th><th>Fecha Creacion</th>       </tr>        </thead><tbody>';
    /*
    foreach( $array_sectores as $sector){
      echo  '<tr><th scope="row">'. $sector->id_sector .'</th>'.
            '<td>'.$sector->denominacion.'</td>'.
            '<td>'.$sector->tipo.'</td>'.
            '<td>'.$sector->id_padre.'</td>'.
            '<td>'.$sector->fecha_creacion.'</td>';
    }
    */
    echo '  </tbody></table>';
 ?>
  <br></br>
    
  <div class="col-sm-12" id="new-sector">
  <h3>Registrar Vecino Nuevo</h3>
    <form method="POST" action="insert_vecino/">
      <div class="col-sm-6">
        <h4> Datos del vecino </h4>
        <p><input type="text" class="span4" name="nombre" id="nombre" placeholder="nombre" required="true"></p>
        <p><input type="text" class="span4" name="apellido" id="apellido" placeholder="apellido"></p>
        <p><input type="text" class="span4" name="mail" id="mail" placeholder="mail"></p>
        <p><input type="text" class="span4" name="tel_fijo" id="tel_fijo" placeholder="tel_fijo"></p>
        <p><input type="text" class="span4" name="tel_movil" id="tel_movil" placeholder="tel_movil"></p>
      </div>
      <div class="col-sm-6">
      <h4> Datos del Domicilio </h4>
      <p><input type="text" class="span4" name="id_domicilio" id="id_domicilio" placeholder="id_domicilio"></p>
       si el domicilio ya existe seleccionarlo. Ej: un pariente del mismo domicilio ya se ecuentra registrado 

      <p><input type="text" class="span4 calle" name="calle" id="calle" placeholder="calle"></p>
      <p id="finalResult"> </p>
      <div class="input-search-result" style="display: none;"></div>


      <p><input type="text" class="span4" name="altura" id="altura" placeholder="altura"></p>
      <p><input type="text" class="span4 calle" name="entrecalle1" id="entrecalle1" placeholder="entrecalle1"></p>
      <p><input type="text" class="span4 calle" name="entrecalle2" id="entrecalle2" placeholder="entrecalle2"></p>

      <p><input type="text" class="span4" name="id_barrio" id="id_barrio" placeholder="id_barrio"></p>

      <p><input type="text" class="span4" name="departamento" id="departamento" placeholder="departamento"></p>
      <p><input type="text" class="span4" name="piso" id="piso" placeholder="piso"></p>
      </div>
    <p><a><input type="submit" class="btn btn-primary" value="Registrar"></a></p>
    </form>
  </div>

</div>

<!-- <script type="text/javascript" language="javascript" src="http://www.technicalkeeda.com/js/javascripts/plugin/jquery.js"></script>
-->
<script type="text/javascript" src="http://www.technicalkeeda.com/js/javascripts/plugin/json2.js"></script>
<script>
 $(document).ready(function(){
   $(".calle").keyup(function(){
    var elem = $(this);
    //console.log(elm.val());
    if(elem.val().length>3){
      //console.log("es:" + $("#calle").val());
      var dataToSearch = {
          searchCalle: elem.val()
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

  
  function calle_encontrada2(data){
    $.each(data, function (i, val) {
      if(currentValues.indexOf(val.calle) < 0){
        currentValues.push(val.calle);
        currentModels.push(val);
        results.append('<div value="'+ val.id_calle +'" item="'+(i+1)+'">'+ val.calle + '</div>');
      }
    });
    $(".no-clickeable").hide();
    results.children().click(onItemClick);
    if (results.children().length == 1) {
      results.html(textToShowNotFound);
    }
  }

 });
</script>