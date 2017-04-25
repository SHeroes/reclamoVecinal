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
 ?></h1>



  <div class="col-md-12">


    <form action="#" id="state_filter" method="POST" >
        <p><select type="text" class="span4" name="status_filter_selector" id="status_filter_selector" style="margin-right: 30px;">
            <option id="estado-vacio_filter" value="">Elegir Estado... </option>
            <option id="iniciado_filter" value="Iniciado">Iniciado</option>
            <option id="visto_filter" value="Visto">Visto</option>            
            <option id="contactado_filter" value="Contactado">Contactado</option>
            <option id="resolucion_filter" value="En resolución">En resolución</option>
            <option id="solucionado_filter" value="Solucionado">Solucionado</option>
            <option id="gestionado_filter" value="Gestionado">Gestionado</option>
        </select>  <input type="submit" class="span4" value="Filtrar"></p>
    </form>


    <?php 
  
    if(count($reclamos_list) > 0){
      echo '<table class="table"><thead class="thead-inverse">        <tr>
      <th>Código Reclamo</th><th>Fecha Alta</th><th>Estado</th><th>Barrio</th><th>Calle</th><th>Nº</th><th>Título</th><th>Rta. hs</th><th>Comentarios</th><th>Observaciones</th><th>Vecino</th> </tr>        </thead><tbody>';
      foreach ($reclamos_list as $rec) {
        $visualizacion = '';
        $mostrarEstado = $rec['estado'];
        if ($rec['estado'] == 'Iniciado'){ 
          $visualizacion = 'no-visto';
          $mostrarEstado = 'Ver Info';
         }else{ $visualizacion = 'visto'; }
        echo  '<tr class="reclamo_row"><th scope="row" class="" id_reclamo="'.$rec['id_reclamo'].'"value="'. $rec['id_vecino'].' ">'. $rec['codigo_reclamo'] .'</th>'. '<td>'.$rec['fecha_alta_reclamo'].'</td>'.
            '<td class="state" id_reclamo="'.$rec['id_reclamo'].'"><div class="btn btn-primary">'.$mostrarEstado.'</div></td>'.
            '<td class="horario hidden">'. $rec['molestar_dia_hs'] .'</td>'.
            '<td class="'. $visualizacion .'"><div>'.$rec['barrio'].'</div></td>'.
            '<td class="'. $visualizacion .'">'.$rec['calle'].'</td>'.
            '<td class="'. $visualizacion .'">'.$rec['altura'].'</td>'.
            '<td class="'. $visualizacion .'">'.$rec['titulo'].'</td>'.
            '<td class="'. $visualizacion .'">'.$rec['tiempo_respuesta_hs'].'</td>'.
            '<td class="comentario '. $visualizacion .'" comentario="'.$rec['comentarios'].'"><div class="btn btn-info">Ver</div></td>'.
            '<td class="observacion '. $visualizacion .'" id_reclamo="'.$rec['id_reclamo'].'" observacion="'  . '"><div class="btn btn-success observar">Observar</div><div class="btn btn-success ver">Ver</div></td>';
          if ($rec['domicilio_restringido'] == 0) echo '<td class="'. $visualizacion .'"><div class="btn btn-info info-vecino" dom-res="0">Ver</div></td>'; else echo '<td></td>';
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



<?php echo '<script src="'. base_url() .'assets/js/show_office.js"></script>'; ?>
