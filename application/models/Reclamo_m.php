<?php


class Reclamo_m extends CI_Model {



  function create_reclamo($userData,$usar_domicilio_vecino){
    // create_domicilio //
    if ($usar_domicilio_vecino){ 
      $idDomicilioReclamoAgregado = $userData['idDomicilioParaReclamo'];
    } else {
      $data2['id_calle'] =    (int) $userData['calle_id'];
      $data2['altura'] =      (int) $userData['altura_inicio'];
      //$data2['altura_fin'] =      (int) $userData['altura_fin'];

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
    //$data3['observaciones'] = '';
     isset($userData['domicilio_restringido']) ? $data3['domicilio_restringido'] = true : $data3['domicilio_restringido'] = false ;

    $idReclamogregado = $this->db->insert('reclamos',$data3);

    return $cod_reclamo;
  }


  function concat_observacion($str_obs,$id_reclamo,$id_user){

    $data['userId'] = $id_user;
    $data['body'] = $str_obs;
    $data['createdDate'] = date('Y-m-d H:i:s',time());

    $this->db->insert('observaciones', $data);
    $id_observacion = $this->db->insert_id();

    $data2['id_obs'] = $id_observacion;
    $data2['id_reclamo'] = $id_reclamo;

    $id_obsXreclamo = $this->db->insert('observacionesxreclamo', $data2);

    return $id_observacion;
  }

  function show_observaciones($id_reclamo){
    $query = 'SELECT id_reclamo, apellido, nombre , body, createdDate FROM dbcav.observacionesxreclamo, user, observaciones
    where id_obs = observaciones.ID    
    and user.id = observaciones.userId
    and id_reclamo = '. $id_reclamo .'
    order by createdDate asc;';
    $query_result = $this->db->query($query);
    return $query_result->result_array();
  }

  function update_state_reclamo($str_state,$id_reclamo){
    $this->db->set('estado', $str_state);
    $this->db->where('id_reclamo', $id_reclamo);
    $this->db->update('reclamos');
  }

  function get_all_reclamos_con_vecino_by($column,$value){

    $value != '' ? $cond_str = " AND ".$column." = '".$value."' " : $cond_str = " AND estado != 'Solucionado' ";
    if ($column != 'estado'){ $cond_str = " AND ".$column." LIKE '%".$value."%'" ;}

    $str_query = 'SELECT id_reclamo, vecino.id_vecino, codigo_reclamo, fecha_alta_reclamo, tiporeclamo.titulo , tiporeclamo.tiempo_respuesta_hs , domicilio_restringido,  estado,comentarios, Apellido, DNI
    FROM reclamos, tiporeclamo, vecino
    WHERE reclamos.id_tipo_reclamo = tiporeclamo.id_tipo_reclamo
    AND reclamos.id_vecino = vecino.id_vecino '. $cond_str .'
    ORDER BY fecha_alta_reclamo ASC;';
    /* los datos del titular se buscar por ajax al darle click */

    $query = $this->db->query($str_query);
    
    return $query->result_array();
  }

  /* ES PARA LAS OFICINIAS porque solo aparecen los reclamos de la oficina a la que pertenece el usuario */
  function get_all_reclamos_by($column,$value, $id_sec){
    $value != '' ? $cond_str = " AND reclamos.".$column." = '".$value."' " : $cond_str = " AND reclamos.estado != 'Solucionado' ";
    /*  yo ya tengo mi id de sector, entonces busco los reclamos de los responsable de mi sector */
    $str_query = 'SELECT id_reclamo, id_vecino, codigo_reclamo, fecha_alta_reclamo, barrios.barrio ,calles.calle, domicilio.altura , tiporeclamo.titulo , tiporeclamo.tiempo_respuesta_hs , domicilio_restringido,  estado,comentarios 
    FROM reclamos, domicilio, tiporeclamo, calles, barrios, usuariosxsector
    WHERE reclamos.id_tipo_reclamo = tiporeclamo.id_tipo_reclamo
    AND tiporeclamo.id_responsable = usuariosxsector.id_usuario
    AND usuariosxsector.id_sector = '. $id_sec . '
    AND reclamos.id_dom_reclamo = domicilio.id_domicilio
    AND domicilio.id_calle = calles.id_calle
    AND domicilio.id_barrio = barrios.id_barrio '. $cond_str .'
    ORDER BY fecha_alta_reclamo ASC;';
    /* los datos del titular se buscar por ajax al darle click */

    $query = $this->db->query($str_query);
    
    return $query->result_array();
  }

  /* ES PARA LAS SECRETARIAS porque solo aparecen los reclamos de la oficina a la que pertenece el usuario */
  function get_all_reclamos_for_secretary_by($column,$value, $id_sec){
    $value != '' ? $cond_str = " AND reclamos.".$column." = '".$value."' " : $cond_str = " ";
    /*  yo ya tengo mi id de sector, entonces busco los reclamos de los responsable de mi sector */
    $str_query = 'SELECT id_reclamo, id_vecino, codigo_reclamo, fecha_alta_reclamo, barrios.barrio ,calles.calle, domicilio.altura , tiporeclamo.titulo , tiporeclamo.tiempo_respuesta_hs , domicilio_restringido,  estado,comentarios 
    FROM reclamos, domicilio, tiporeclamo, calles, barrios, usuariosxsector, sectores
    WHERE reclamos.id_tipo_reclamo = tiporeclamo.id_tipo_reclamo
    AND tiporeclamo.id_responsable = usuariosxsector.id_usuario
    AND sectores.id_padre = '. $id_sec . '
    AND usuariosxsector.id_sector = sectores.id_sector
    AND reclamos.id_dom_reclamo = domicilio.id_domicilio
    AND domicilio.id_calle = calles.id_calle
    AND domicilio.id_barrio = barrios.id_barrio '. $cond_str .'
    ORDER BY fecha_alta_reclamo ASC;';
    /* los datos del titular se buscar por ajax al darle click */

    $query = $this->db->query($str_query);
    
    return $query->result_array();
  }

}
