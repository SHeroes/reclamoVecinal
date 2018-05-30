

<body onload="initialize()">
    <div id="floating-panel">
      <input onclick="changeMarkers('red');" type=button class="btn btn-danger" value="URGENTE">
      <input onclick="changeMarkers('orange');" type=button class="btn btn-warning" value="ATENCION">
      <input onclick="changeMarkers('green');" type=button class="btn btn-success" value="SOLUCIONADOS">
      <input onclick="changeMarkers('all');" type=button class="btn btn-info" value="TODOS">
    </div>
    <div class="container-fluid"></div>
        <div id="map"></div>
    </div>
</body>
    <div class="container-fluid">
    <form action="#" id="state_filter" method="POST" style="padding: 30px 0px;" >

        <div class="col-sm-12">
          <div class="col-sm-3">
            <p><select type="text" class="span4 form-control" name="id_loc" id="id_loc" placeholder="id_loc">
              <option value="">Seleccionar Localidad...</option>
                <?php foreach( $all_localidades as $localidad){
                  if ($localidad->id_localidad == $info['id_loc']) {
                    $selected_str  = ' selected="selected" ';
                  } else {
                    $selected_str  = '';
                  }
                  echo '<option value="'. $localidad->id_localidad .'"'.$selected_str.'>'.$localidad->localidades.'</option>';
                }?>
                </select>
            </p>
          </div>
          <div class="col-sm-3">
            <p><input type="text" placeholder="desde:" autocomplete="off" class="input-fecha desde form-control" name="desde" id="datepicker" size="15" value="<?php echo $info['desde']; ?>" ></p>
          </div>
          <div class="col-sm-3">
            <p><input type="text" placeholder="hasta:" autocomplete="off" class="input-fecha hasta form-control" name="hasta" id="datepicker2" size="15" value="<?php echo $info['hasta']; ?>"></p>  
          </div>
          <div class="col-sm-3">
            <input type="submit" class="span4 btn" value="Filtrar">
          </div>
          <p></p> 
        </div>   
    </form>

    <?php
  	if($reclamos_list != ''){
        echo '<table class="table" style="margin-top: 40px; "><thead class="thead-inverse">        <tr id="header-table">
        <th>Código Reclamo</th><th>Estado</th><th>Fecha Alta</th><th>Vecino</th><th>Domicilio</th><th>Telefonos</th><th>email</th><th>Horarios</th><th>Nro. Ticket</th><th>Nro. Cliente</th></tr>        </thead><tbody>';
        foreach ($reclamos_list as $rec) {
        	if ($rec['estado_servicio'] == 1){
        		$estado = '<td><div class="btn state btn-success" id-rec-edesur="'.$rec['id'].'">OK</div></td>';
        	} else if ( $rec['horas_transcurridas'] > 24) {
  	      		$estado = '<td><div class="btn state btn-danger" id-rec-edesur="'.$rec['id'].'">URGENTE</div></td>';
  	      	} else {
  	      		$estado = '<td><div class="btn state btn-warning" id-rec-edesur="'.$rec['id'].'">ATENCION</div></td>';
        	}
  		
          echo  '<tr class="reclamo_row"><th scope="row" class="" id_reclamo="'.$rec['id_reclamo'].'"value="'. $rec['id_vecino'].' ">'. $rec['codigo_reclamo'] .'</th>'.$estado.'<td>'.$rec['fecha_alta_reclamo'].'</td>'.
              '<td>'.$rec['Apellido'].', '.$rec['Nombre'].'</td>'.
              '<td>'.$rec['localidades'].' | '.$rec['calle'].' Nro: '.$rec['altura'].'</td>'.
              '<td>'.$rec['tel_fijo'].' / '.$rec['tel_movil'].'</td>'.
              '<td>'.$rec['mail'].'</td>'.
              '<td>'.$rec['horarios'].'</td>'.
              '<td>'.$rec['ticket_edesur'].'</td>'.
              '<td>'.$rec['nro_cliente_edesur'].'</td>';
          }
          echo '  </tbody></table>';
      }
?>
</div>


<script type="text/javascript" src="https://maps.google.com/maps/api/js?key=<?php echo $this->config->item('google_key'); ?>"></script>




<link rel="stylesheet" href="<?php echo base_url();?>assets/js/vendor/jquery-ui/jquery-ui.css">
<script src="<?php echo base_url();?>assets/js/vendor/jquery-ui/jquery-ui.js"></script>
<?php echo '<script src="'. base_url() .'assets/js/show_calendar.js"></script>'; ?> 
