<?php //echo '<script src="'. base_url() .'assets/js/show_reclamos_crear.js"></script>'; ?>
<div class="container">
<h1>Reclamos correspondientes a: <?php
  if ($this->session->sectores_multiples){
    $array_sectores = $this->session->array_sectores;
    foreach ($array_sectores as $row => $value) {
     echo '</br> - ' .$array_sectores[$row]->denominacion ;
    }
  }else{
    echo $this->session->sector_name;
  }
  /*
  ?><pre>
  <?php
  //print_r($this->session);
  print_r(count($this->session->sectores_multiples));
  ?></pre>
  */

  ?>
 </h1>




  <div class="col-md-12">


    <form action="#" id="state_filter" method="POST" >

      <div class="col-sm-6">
        <p>desde: <input type="text" class="input-fecha desde" name="desde" id="datepicker" size="15"></p>
        <p>hasta: <input type="text" class="input-fecha hasta" name="hasta" id="datepicker2" size="15"></p>  
        <input type="submit" class="span4" value="Filtrar">
        <p></p> 
      </div>  

      <div class="col-sm-6">
        <p><select type="text" class="span4" name="status_filter_selector" id="status_filter_selector" style="margin-right: 30px;">
            <option id="estado-vacio_filter" value="">Elegir Estado... </option>
            <option id="iniciado_filter" value="Iniciado">Iniciado</option>
            <option id="visto_filter" value="Visto">Visto</option>
            <option id="contactado_filter" value="Contactado">Contactado</option>
            <option id="resolucion_filter" value="En resolución">En resolución</option>
            <option id="solucionado_filter" value="Solucionado">Solucionado</option>
            <option id="gestionado_filter" value="Gestionado">Gestionado</option>
        </select>  <input type="submit" class="span4" value="Filtrar"></p>

        <p><select type="text" class="span4" name="reclamoType_filter_selector" id="reclamoType_filter_selector" style="margin-right: 30px;">
        <option id="typeReclamo-vacio_filter" value="">Elegir Tipo de Reclamo... </option>
        <?php

        foreach ($list_reclaim_type as $row => $value) {
           $str = '<option id="typeReclamo-vacio_filter" value="'.$list_reclaim_type[$row]->id_tipo_reclamo. '">' . $list_reclaim_type[$row]->titulo.'</option>';
           echo $str;

        }
        print_r($list_reclaim_type);
        ?>
        </select>
        </p>
      </div>
    </form>


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
            '<td class="state '. $user_enable .'" id_reclamo="'.$rec['id_reclamo'].'"><div class="">'.$rec['estado'].'</div></td>'.
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


<?php echo '<script src="'. base_url() .'assets/js/show_secretary_coord.js"></script>'; ?>


<link rel="stylesheet" href="<?php echo base_url();?>assets/js/vendor/jquery-ui/jquery-ui.css">
<script src="<?php echo base_url();?>assets/js/vendor/jquery-ui/jquery-ui.js"></script>
<?php echo '<script src="'. base_url() .'assets/js/show_calendar.js"></script>'; ?> 