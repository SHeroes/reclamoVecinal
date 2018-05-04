<?php 

    $arrayForJson = array();
    $arrayForJsonRed = array();
    $arrayForJsonGreen = array();
    $arrayForJsonOrange = array();

	foreach ($reclamos_list as $key => $value) {
		$LatLng = array('lat' => (float)$value['lat'], 'lng' => (float)$value['lng']);
		$elForJson['LatLng'] = $LatLng;
		$elForJson['codigo_reclamo'] = 		$value['codigo_reclamo'];
		$elForJson['id_reclamo'] = 			$value['id_reclamo'];
		if ($value['estado_servicio']>0){
			array_push($arrayForJsonGreen, $elForJson);
		}else{ // esta suministro inactivo
			if($value['horas_transcurridas']>24){
				array_push($arrayForJsonRed, $elForJson);
			}else{
				array_push($arrayForJsonOrange, $elForJson);
			}
		}
	}
	$arrayForJson['green'] = $arrayForJsonGreen;
	$arrayForJson['red'] = $arrayForJsonRed;
	$arrayForJson['orange'] = $arrayForJsonOrange;
	$reclamosInfo = json_encode($arrayForJson);

	echo '<script type="text/javascript">';
	echo 'var reclamosInfo='.$reclamosInfo;
	echo '</script>';

?>
