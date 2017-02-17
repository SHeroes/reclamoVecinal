<?php //echo '<script src="'. base_url() .'assets/js/show_reclamos_crear.js"></script>'; ?>
<div class="container">
<h1>Reclamos correspondientes a: <?php echo $this->session->sector_name; ?></h1>

  <div class="col-md-12">
    <?php 
  
    if(count($reclamos_list) > 0){
      echo '<table class="table"><thead class="thead-inverse">        <tr>
      <th>Código Reclamo</th><th>Fecha Alta</th><th>Barrio</th><th>Calle</th><th>Nº</th><th>Título</th><th>Rta. hs</th><th>Estado</th><th>Comentarios</th><th>Observaciones</th><th>Vecino</th> </tr>        </thead><tbody>';
      foreach ($reclamos_list as $rec) {
        echo  '<tr class="reclamo_row"><th scope="row" class="" id_reclamo="'.$rec['id_reclamo'].'"value="'. $rec['id_vecino'].' ">'. $rec['codigo_reclamo'] .'</th>'. '<td>'.$rec['fecha_alta_reclamo'].'</td>'.
            '<td><div>'.$rec['barrio'].'</div></td>'.
            '<td>'.$rec['calle'].'</td>'.
            '<td>'.$rec['altura'].'</td>'.
            '<td>'.$rec['titulo'].'</td>'.
            '<td>'.$rec['tiempo_respuesta_hs'].'</td>'.
            '<td class="state" id_reclamo="'.$rec['id_reclamo'].'"><div class="btn btn-primary">'.$rec['estado'].'</div></td>'.
            '<td class="comentario" comentario="'.$rec['comentarios'].'"><div class="btn btn-info">Ver</div></td>'.
            '<td class="observacion" id_reclamo="'.$rec['id_reclamo'].'" observacion="'.$rec['observaciones'].'"><div class="btn btn-success">Observar</div></td>';
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

  <div id="comments-data" class="dialog-box" style="display: none;" title="Comentario">
    <p></p>
  </div> 

  <div id="state" class="dialog-box" id-rec="" style="display: none;" title="Cambiar estado">
    
      <p><select type="text" class="span4" name="status_selector" id="status_selector">
        <option id="estado-vacio" value="">Elegir Estado... </option>
        <option id="contactado" value="Contactado">Contactado</option>
        <option id="resolucion" value="En resolución">En resolución</option>
        <option id="solucionado" value="Solucionado">Solucionado</option>
        <option id="gestionado" value="Gestionado">Gestionado</option>
    </select></p>
    <div class="btn btn-primary">Aceptar</div>
  </div>


  <div id="obs-data" class="dialog-box" style="display: none;" title="Editar Observacion">
    <p>
      <form action="javascript:editar_observacion();" id="obs-form" method="POST" ><p><textarea type="text" class="span4" name="observacion_input" id="observacion-input" rows="8" cols="50" placeholder="" ></textarea></p><p><input type="hidden" name="id_rec" id="id-rec" class="span4" value=""></p><p><input type="submit" class="span4" value="Enviar"></p></form>
    </p>
  </div> 

<link rel="stylesheet" href="<?php echo base_url();?>assets/js/vendor/jquery-ui/jquery-ui.css">
  <script src="<?php echo base_url();?>assets/js/vendor/jquery-ui/jquery-ui.js"></script>

<style>

.ui-draggable, .ui-droppable {
  background-position: top;
}

#vecino-data {
}

tr.reclamo_row{  
}



</style>


<?php echo '<script src="'. base_url() .'assets/js/show_office.js"></script>'; ?>
