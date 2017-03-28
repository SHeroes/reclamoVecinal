<div class="container">
  <h1> Reclamos Existentes</h1>
    <div class="col-md-12">

    <!-- FILTRO POR ESTADO  esta funcionando ok se quita por pedido
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
    -->
    <form action="#" id="Apellido_filter" method="POST" >
    	<p>
    		<input type="text" name="Apellido_filter_sel" class="input-form" placeholder="Apellido...">
    		<input type="submit" class="span4" value="Filtrar">
    	</p>
    </form>
    <form action="#" id="DNI_filter" method="POST" >
    	<p>
    		<input type="int" name="DNI_filter_sel" class="input-form" placeholder="DNI...">
    		<input type="submit" class="span4" value="Filtrar">
    	</p>
    </form>
    <form action="#" id="num_reclamo_filter" method="POST" >
    	<p>
    		<input type="text" name="num_reclamo_sel" class="input-form" placeholder="Nº Reclamo">
    		<input type="submit" class="span4" value="Filtrar">
    	</p>
    </form>

    <?php 

    if($reclamos_list != ''){
      echo '<table class="table"><thead class="thead-inverse">        <tr>
      <th>Código Reclamo</th><th>Fecha Alta</th><th>Título</th><th>Rta. hs</th><th>Estado</th><th>Comentarios</th><th>Observaciones</th><th>Vecino</th><th>Apellido</th><th>DNI</th><th>Imagenes</th></tr>        </thead><tbody>';
      foreach ($reclamos_list as $rec) {
        echo  '<tr class="reclamo_row"><th scope="row" class="" id_reclamo="'.$rec['id_reclamo'].'"value="'. $rec['id_vecino'].' ">'. $rec['codigo_reclamo'] .'</th>'. '<td>'.$rec['fecha_alta_reclamo'].'</td>'.
            '<td>'.$rec['titulo'].'</td>'.
            '<td>'.$rec['tiempo_respuesta_hs'].'</td>'.
            '<td>'.$rec['estado'].'</div></td>'.
            '<td class="comentario" comentario="'.$rec['comentarios'].'"><div class="btn btn-info">Ver</div></td>'.
            '<td class="observacion" id_reclamo="'.$rec['id_reclamo'].'" observacion="'  . '"><div class="btn btn-success ver">Ver</div></td>';
          if ($rec['domicilio_restringido'] == 0) echo '<td><div class="btn btn-info info-vecino" dom-res="0">Ver</div></td>'; else echo '<td></td>';
          	echo '<td>'.$rec['Apellido'].'</td>'.
            '<td>'.$rec['DNI'].'</td>'.
            '<td><a href="/index.php/upload?id-rec='.$rec['id_reclamo'].'" class="btn btn-info">Upload</div></td>';
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



<?php echo '<script src="'. base_url() .'assets/js/show_reclamos_operator.js"></script>'; ?>