<?php


class Vecino_m extends CI_Model {

  function get_vecinos_by_DNI($DNI){
    $DNI_ = "'" . $DNI . "'";
    $where_str = 'domicilio.id_calle = calles.id_calle and DNI ='.$DNI_;
    $this->db->select('id_vecino, Nombre, Apellido, DNI, mail, tel_fijo, tel_movil, id_domicilio, calle ,altura')
              ->from('vecino, domicilio, calles')
              ->where($where_str);
    $vecino = $this->db->get()->result();
    return $vecino;
  }

  function get_all_vecinos(){
    $this->db->from('vecino');
    $vecinos = $this->db->get()->result();
    return $vecinos;
  }

  function get_vecinos_by_Apellido($Apellido){
    $Apellido_ = "'" . $Apellido . "'";
    $where_str = 'domicilio.id_calle = calles.id_calle and vecino.Apellido ='.$Apellido_;
    $this->db->select('id_vecino, Nombre, Apellido, DNI, mail, tel_fijo, tel_movil, id_domicilio, calle ,altura')
              ->from('vecino, domicilio, calles')
              ->where($where_str);
              //->limit(1);
    $vecino = $this->db->get()->result();
    return $vecino;
  }

  function create_vecino($userData){
    $data['nombre'] = $userData['nombre'];
    $data['apellido'] = $userData['apellido'];
    $data['DNI'] = $userData['dni'];
    $data['mail'] = $userData['mail'];
    $data['tel_fijo'] = $userData['tel_fijo'];
    $data['tel_movil'] = $userData['tel_movil'];
    $this->db->insert('vecino',$data);
    $idVecinoAgregado = $this->db->insert_id();

    // create_domicilio //
    if ($userData['id_domicilio'] == null){ 
      $data2['id_calle'] =    (int) $userData['calle_id'];
      $data2['altura'] =      (int) $userData['altura'];
      $data2['entrecalle1_id'] = (int) $userData['entrecalle1_id'];
      $data2['entrecalle2_id'] = (int) $userData['entrecalle2_id'];
      $data2['id_barrio'] =   (int) $userData['id_barrio'];
      $data2['dpto'] = (int) $userData['departamento'];
      $data2['piso'] =        (int) $userData['piso']; 
      $this->db->insert('domicilio',$data2);
      $idDomicilioAgregado = $this->db->insert_id();
    } else {
      // nuevo vecino con un domicilio que ya existe //
      $idDomicilioAgregado = (int) $userData['id_domicilio'];
    }

    // create domicilioxvecino //
    $data3['id_vecino'] = $idVecinoAgregado;
    $data3['id_domicilio'] = $idDomicilioAgregado;
    $data3['fecha_alta'] = date('Y-m-d H:i:s',time());

    $this->db->insert('domiciliosxvecinos',$data3);

    return $idVecinoAgregado;
  }

}
