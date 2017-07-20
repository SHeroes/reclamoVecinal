<div class="container-fluid">
  <h1> Reclamos Existentes</h1>
    <div class="col-md-12">

<form action="#" id="state_filter" method="POST" >
      <div class="col-sm-2">
        <p><input type="text" id="apellido" name="apellido" class="input-form" placeholder="Apellido..."></p>
        <p><input type="int" id="dni" name="dni" class="input-form" placeholder="DNI..."></p>
        <p><input type="text" id="nro_rec" name="nro_rec" class="input-form" placeholder="Nº Reclamo"></p>
      </div>
      <div class="col-sm-4">    
        <p>desde: <input type="text" class="input-fecha desde" name="desde" id="datepicker" size="15"></p>
        <p>hasta: <input type="text" class="input-fecha hasta" name="hasta" id="datepicker2" size="15"></p>
        <p><select type="text" class="span4" name="sector_filter_selector_sec" id="sector_filter_selector_sec" style="margin-right: 30px;">
        <option class="sector_filter secretaria" value="">Elegir Secretaria... </option>
        <?php
        foreach ($query_secretarias as $row ) {
          $str = '<option class="sector_filter secretaria" value="'. $row->id_sector . '">'. $row->denominacion .'</option>';
          echo $str;
        }?>
        </select></p>

      </div>  

      <div class="col-sm-6">
        <div class="col-sm-3">
        <p><select type="text" class="span4" name="status_filter_selector" id="status_filter_selector" style="margin-right: 30px;">
            <option id="estado-vacio_filter" value="">Elegir Estado... </option>
            <option id="iniciado_filter" value="Iniciado">Iniciado</option>
            <option id="visto_filter" value="Visto">Visto</option>
            <option id="contactado_filter" value="Contactado">Contactado</option>
            <option id="resolucion_filter" value="En resolución">En resolución</option>
            <option id="solucionado_filter" value="Solucionado">Solucionado</option>
            <option id="gestionado_filter" value="Gestionado">Gestionado</option>
            <option id="reasignacion_filter" value="En Reasignacion">En Reasignacion</option> 
        </select></p>
        </div>
        <div class="col-sm-3">
        <p><select type="text" class="span4" name="responsable_filter_selector" id="responsable_filter_selector" style="margin-right: 30px;">
        <option class="responsable_filter" value="">Elegir Responsable... </option>
        <?php
        
        foreach ($query_responsable as $row) {
          $string_2 = '<option class="sector_filter" value="'. $row->id_responsable . '">'. $row->apellido .' '. $row->nombre .'</option>';
          echo $string_2;
        }
        
        ?>
        </select></p>        
        </div>

        <select type="text" class="span4" name="reclamoType_filter_selector" id="reclamoType_filter_selector" style="margin-right: 30px;">
        <option id="typeReclamo-vacio_filter" value="">Elegir Tipo de Reclamo... </option>
        <?php
        
        foreach ($query_tipos_reclamo as $row => $value) {
            $str_1 = '<option id="typeReclamo-vacio_filter" value="'.$value->id_tipo_reclamo. '">'. $value->titulo.'</option>';
            echo $str_1;
        }
        
        ?>
        </select></p>

        <p><select type="text" class="span4" name="sector_filter_selector_of" id="sector_filter_selector_of" style="margin-right: 30px;">
        <option class="sector_filter oficina " value="">Elegir Oficina... </option>
        <?php
        foreach ($query_oficinas as $row ) {
          $str = '<option class="sector_filter" value="'. $row->id_sector . '">'. $row->denominacion .'</option>';
          echo $str;
        }?>
        </select></p>

        <input type="submit" class="span4" value="Filtrar">
        <p></p> 
        
      </div>
    </form>

    <?php 

    if(count($reclamos_list) > 0){
      echo '<table class="table"><thead class="thead-inverse">        <tr>
      <th>Código Reclamo</th><th>Fecha Alta</th><th>Barrio</th><th>Calle</th><th>Nº</th><th>Título</th><th>Rta. hs</th><th>Estado</th><th>Reasignable</th><th>Comentarios</th><th>Observaciones</th><th>Vecino</th> </tr>        </thead><tbody>';
      foreach ($reclamos_list as $rec) {
        echo  '<tr class="reclamo_row">
                <th scope="row" class="" horario="-'.$rec['molestar_dia_hs'].'" id_reclamo="'.$rec['id_reclamo'].'"value="'. $rec['id_vecino'].' ">'. $rec['codigo_reclamo'] .'</th>'.
            '<td>'.$rec['fecha_alta_reclamo'].'</td>'.
            '<td><div>'.$rec['barrio'].'</div></td>'.
            '<td>'.$rec['calle'].'</td>'.
            '<td>'.$rec['altura'].'</td>'.
            '<td>'.$rec['titulo'].'</td>'.
            '<td>'.$rec['tiempo_respuesta_hs'].'</td>'.
            '<td class="state-supervisor" id_reclamo="'.$rec['id_reclamo'].'">'. $rec['estado'].'</td>'.
            '<td> <div class="reasignar btn btn-warning" id_reclamo="'.$rec['id_reclamo'].'">Reasignar</div></td>'.
            '<td class="comentario" comentario="'.$rec['comentarios'].'"><div class="btn btn-info">Ver</div></td>'.
            '<td class="observacion" id_reclamo="'.$rec['id_reclamo'].'"><div class="btn btn-success ver">Ver</div></td>';
          if ($rec['domicilio_restringido'] == 0) echo '<td><div class="btn btn-info info-vecino" dom-res="0">Ver</div></td>'; else echo '<td></td>';
        }
        echo '  </tbody></table>'; 
    }

    ?>

 
  </div>
</div>





  <div id="vecino-data" class="dialog-box" style="display: none;" title="Datos Reclamante">
    <p></p>
  </div> 

  <div id="ver-obs" class="dialog-box" style="display: none;" title="Visualizar Observaciones">
    <p></p>
  </div> 

  <div id="comments-data" class="dialog-box" style="display: none;" title="Comentario">
    <p></p>
  </div> 


  <div id="obs-data" class="dialog-box" style="display: none;" title="Editar Observacion">
    <p>
      <form action="javascript:editar_observacion();" id="obs-form" method="POST" ><p><textarea type="text" class="span4" name="observacion_input" id="observacion-input" rows="8" cols="50" placeholder="" ></textarea></p><p><input type="hidden" name="id_rec" id="id-rec" class="span4" value=""></p><p><input type="submit" class="span4" value="Enviar"></p></form>
    </p>
  </div> 

  <div id="reitero-data" class="dialog-box" style="display: none;" title="Reitero de reclamo">
    <p>Agregar comentarios al reclamo: </p>
    <p>
      <form action="javascript:editar_comentario_por_reitero();" id="reitero-form" method="POST" >
        <p><textarea type="text" class="span4" name="reitero_input" id="reitero-input" rows="10" cols="28" placeholder="" ></textarea></p>
        <p><input type="hidden" name="id-reitero" id="id-rei" class="span4" value=""></p>
        <p><input type="hidden" name="id-rei-num" id="id-rei-num" class="span4" value=""></p>
        <p><input type="submit" class="span4" value="Reiterar Reclamo"></p>
      </form>
    </p>
  </div> 

  <div id="reasignacion-data" class="dialog-box" style="display: none;" title="Reasignacion de reclamo">
    <p class="box_rec_title">Reclamo a reasignar: <b></b></p>
    <p>
      <form action="javascript:reasignacion_reclamo();" id="reasignacion-form" method="POST" >
        <p><input type="hidden" name="id-reclamo" id="id-rec-reasig" class="span4" value=""></p>
        <select type="text" class="span4" name="reclamoType_filter_selector" id="reclamoType_box_dialog" style="margin-right: 30px;">
          <option id="typeReclamo-vacio_filter" value="">Elegir El Nuevo Tipo de Reclamo... </option>
          <?php
          
          foreach ($query_tipos_reclamo as $row => $value) {
              $str_1 = '<option id="typeReclamo-vacio_filter" value="'.$value->id_tipo_reclamo. '">'. $value->titulo.'</option>';
              echo $str_1;
          }
          
          ?>
        </select></p>        
        <p><input type="submit" class="span4" value="Reasignar Reclamo"></p>
      </form>
    </p>
  </div> 

  <div id="img-box" class="ui-widget-content" style="display: none;" title="Fotos del Reclamo">
    <p>
      
    </p>
  </div> 

<?php echo '<script src="'. base_url() .'assets/js/show_reclamos_operator.js"></script>'; ?>
<?php echo '<script src="'. base_url() .'assets/js/reclamos_reitero.js"></script>'; ?>
<?php echo '<script src="'. base_url() .'assets/js/reclamos_reasignacion.js"></script>'; ?>
<?php echo '<script src="'. base_url() .'assets/js/ver_imagenes_reclamo.js"></script>'; ?>

<link rel="stylesheet" href="<?php echo base_url();?>assets/js/vendor/jquery-ui/jquery-ui.css">
<script src="<?php echo base_url();?>assets/js/vendor/jquery-ui/jquery-ui.js"></script>
<?php echo '<script src="'. base_url() .'assets/js/show_calendar.js"></script>'; ?> 

<script type="text/javascript">

  document.getElementById('apellido').value = "<?php echo $info['apellido']; ?>";
  document.getElementById('dni').value = "<?php echo $info['dni']; ?>";
  document.getElementById('nro_rec').value = "<?php echo $info['nro_rec']; ?>";
  document.getElementById('datepicker').value = "<?php echo $info['desde']; ?>";

  document.getElementById('datepicker2').value = "<?php echo $info['hasta']; ?>";
  document.getElementById('sector_filter_selector_sec').value = "<?php echo $info['sector_filter_selector_sec']; ?>";
  document.getElementById('sector_filter_selector_of').value = "<?php echo $info['sector_filter_selector_of']; ?>";

  document.getElementById('status_filter_selector').value = "<?php echo $info['status_filter_selector']; ?>";
  document.getElementById('reclamoType_filter_selector').value = "<?php echo $info['reclamoType_filter_selector']; ?>";
  document.getElementById('responsable_filter_selector').value = "<?php echo $info['responsable_filter_selector']; ?>";
 
$(document).ready(function(){
  var id_sec_selected = $("#sector_filter_selector_sec option:selected" ).attr("value");
  $("#sector_filter_selector_sec").change(function() {
    id_sec_selected = $("#sector_filter_selector_sec option:selected" ).attr("value");
      actualizar_oficinas(id_sec_selected);
   });
});

  function actualizar_oficinas(id_sec){
    var dataToSearch = { id_secretaria: id_sec  };
    $.ajax({
     type: "post",
     url: "/index.php/common_links_ajax/oficinas_por_id_secretaria",
     cache: false,    
     data: dataToSearch,
     success: secretary_ch,
     error: function(){      
      alert('Error while request..');
     }
    }); 
  }

  function secretary_ch(response){
    $("#sector_filter_selector_of").html("");
    var data = JSON.parse( response );
    var str =  '<option class="sector_filter" value="">Elegir Oficina</option>';
    $.each(data, function(i, item) {
        str = str + '<option class="sector_filter" value="'+ data[i].id_sector + '">'+ data[i].denominacion +'</option>';
    });
    $("#sector_filter_selector_of").html(str);
  }
</script>
