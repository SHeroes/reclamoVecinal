

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
    <div class="container-fluid"><?php
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

