<?php


class Reclamo_m extends CI_Model {

  function create_reclamo($userData){
    // create_domicilio_reclamo //
    if ($userData['id_domicilio'] == null){ 
      $data2['id_calle'] =    (int) $userData['calle_id'];
      $data2['altura_inicio'] =      (int) $userData['altura_inicio'];
      $data2['altura_fin'] =      (int) $userData['altura_fin'];

      $data2['entrecalle1_id'] = (int) $userData['entrecalle1_id'];
      $data2['entrecalle2_id'] = (int) $userData['entrecalle2_id'];
      $data2['id_barrio'] =   (int) $userData['id_barrio'];
      $data2['columna_electrica'] = (int) $userData['columna_electrica'];

      $this->db->insert('domicilio_reclamo',$data2);
      $idDomicilioReclamoAgregado = $this->db->insert_id();
    } else {
      // nuevo vecino con un domicilio que ya existe //
      $idDomicilioReclamoAgregado = (int) $userData['id_domicilio'];
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
    
    //print_r($currentYear);

    
    $where_cond = "YEAR(fecha_alta_reclamo) =" . $currentYear;
    $this->db->select('COUNT(fecha_alta_reclamo) as cantReclamos')->from('reclamos')->where($where_cond);
    $aux = $this->db->get()->result();
    $cantidad_reclamos_delAnio = (int) $aux[0]->cantReclamos;

    //El número de reclamo debe ser automático comenzando por el 0010000/año, cada año comienza con el mismo número.
    
    $int_reclamo = 10001 + $cantidad_reclamos_delAnio;
    $cod_reclamo = '00' . $int_reclamo . '/' . $currentYear;
    $data3['codigo_reclamo'] = $cod_reclamo;

    $idReclamogregado = $this->db->insert('reclamos',$data3);

    return $idReclamogregado;
  }



  function get_all_reclamos(){
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
