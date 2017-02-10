<?php


class Reclamo_m extends CI_Model {

  function create_reclamo($userData){
    // create_domicilio //
    if ($userData['usar_domicilio_vecino']){ 
      //checkbox para que tome el ID del domicilio del vecino como el de reclamo
      $str_query = 'SELECT domicilio.id_domicilio
      FROM domiciliosxvecinos, domicilio
      where domiciliosxvecinos.id_vecino = '.$userData['id_vecino'].' and domiciliosxvecinos.id_domicilio = domicilio.id_domicilio
      order by fecha_alta DESC
      LIMIT 1;';
      $query = $this->db->query($str_query);

      $array = $query->result_array();
      $idDomicilioReclamoAgregado = (int) $array[0]['id_domicilio'];

    } else {
      $data2['id_calle'] =    (int) $userData['calle_id'];
      $data2['altura'] =      (int) $userData['altura_inicio'];
      $data2['altura_fin'] =      (int) $userData['altura_fin'];

      $data2['entrecalle1_id'] = (int) $userData['entrecalle1_id'];
      $data2['entrecalle2_id'] = (int) $userData['entrecalle2_id'];
      $data2['id_barrio'] =   (int) $userData['id_barrio'];
      $data2['columna_luminaria'] = (int) $userData['columna_electrica'];

      $this->db->insert('domicilio',$data2);
      $idDomicilioReclamoAgregado = $this->db->insert_id();
    }
    // create_reclamo //

    $data3['id_vecino'] = $userData['id_vecino'];
    $data3['id_tipo_reclamo'] = $userData['id_tipo_reclamo'];
    $data3['id_operador'] = $userData['id_operador']; 
    $data3['id_dom_reclamo'] = $idDomicilioReclamoAgregado;
    $data3['estado'] = 'Iniciado';    
    $data3['fecha_alta_reclamo'] = date('Y-m-d H:i:s',time());
    $data3['id_lastchanger'] = $userData['id_operador']; 
    $data3['molestar_dia_hs'] = $userData['molestar_dia_hs']; 

    
    isset($userData['molestar_al_tel_fijo']) ?  $data3['molestar_al_tel_fijo'] = true :  $data3['molestar_al_tel_fijo'] = false;
    isset($userData['molestar_al_tel_mov']) ?   $data3['molestar_al_tel_mov'] = true :   $data3['molestar_al_tel_mov'] = false;
    isset($userData['molestar_al_dom']) ?       $data3['molestar_al_domicilio'] = true : $data3['molestar_al_domicilio'] = false;
    $data3['comentarios'] = $userData['comentarios'];

    $currentYear =  date('Y');

    
    $where_cond = "YEAR(fecha_alta_reclamo) =" . $currentYear;
    $this->db->select('COUNT(fecha_alta_reclamo) as cantReclamos')->from('reclamos')->where($where_cond);
    $aux = $this->db->get()->result();
    $cantidad_reclamos_delAnio = (int) $aux[0]->cantReclamos;

    //El número de reclamo debe ser automático comenzando por el 0010000/año, cada año comienza con el mismo número.   
    $int_reclamo = 10001 + $cantidad_reclamos_delAnio;
    $cod_reclamo = '00' . $int_reclamo . '/' . $currentYear;
    $data3['codigo_reclamo'] = $cod_reclamo;
    $data3['observaciones'] = '';
    $userData['domicilio_restringido'] ? $data3['domicilio_restringido'] = true : $data3['domicilio_restringido'] = false ;

    $idReclamogregado = $this->db->insert('reclamos',$data3);

    return $cod_reclamo;
  }



  function get_all_reclamos_by_state($estado){
    $estado != '' ? $estado_str = " AND reclamos.estado = '".$estado."' " : $estado_str = " AND reclamos.estado != 'Terminado' ";
    $str_query = 'SELECT id_vecino, codigo_reclamo, fecha_alta_reclamo, barrios.barrio ,calles.calle, domicilio.altura , tiporeclamo.titulo , tiporeclamo.tiempo_respuesta_hs , domicilio_restringido
    FROM reclamos, domicilio, tiporeclamo, calles, barrios
    WHERE reclamos.id_tipo_reclamo = tiporeclamo.id_tipo_reclamo '. $estado_str .'
    AND reclamos.id_dom_reclamo = domicilio.id_domicilio
    AND domicilio.id_calle = calles.id_calle
    AND domicilio.id_barrio = barrios.id_barrio
    ORDER BY fecha_alta_reclamo ASC;';
    /* los datos del titular se buscar por ajax al darle click */

    $query = $this->db->query($str_query);
    
    return $query->result_array();

    /*
    $this->db->select(*)

    return 

        $DNI_ = "'" . $DNI . "'";
    $where_str = 'domicilio.id_calle = calles.id_calle and DNI ='.$DNI_;
    $this->db->select('id_vecino, Nombre, Apellido, DNI, mail, tel_fijo, tel_movil, id_domicilio, calle ,altura')
              ->from('vecino, domicilio, calles')
              ->where($where_str);
    $vecino = $this->db->get()->result();
    return $vecino;*/
  }
}
