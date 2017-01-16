<?php


class Vecino_m extends CI_Model {
  /*
    function  create_new_user( $userData ) {
      $data['perfil_level'] = (int) $userData['perfil_level'];
      $data['apellido'] = $userData['lastName'];
      $data['nombre'] = $userData['firstName'];
      $data['email'] = $userData['email'];
      $data['password'] = sha1($userData['password1']);
      $this->db->insert('user',$data);
      $lastid = $this->db->insert_id();

      $data2['id_usuario'] = $lastid;
      $data2['id_sector'] = $userData['miembro_sector'];
      $this->db->insert('usuariosxsector',$data2);

      return $lastid;
    }

    function update_user_id($id,$userData){

      $data2['id_usuario'] = $id;
      $data2['id_sector'] = $userData['miembro_sector'];
      $this->db->where('id_usuario', $id);
      $this->db->update('usuariosxsector',$data2);

      $data['id'] = $id;
      $data['perfil_level'] = (int) $userData['perfil_level'];
      $data['apellido'] = $userData['lastName'];
      $data['nombre'] = $userData['firstName'];
      $data['email'] = $userData['email'];
      $data['password'] = sha1($userData['password1']);

      $this->db->where('id', $id);
      $this->db->update('user', $data);
      return $id;
    }
*/
    /*
  function get_vecino_by_DNI{

    return $vecinos_filtrados;
  }

  function get_all_vecinos(){
    $this->db->from('vecinos');
    $users = $this->db->get()->result();
    return $users;  
  }
*/
  function create_vecino($userData){
    $data['nombre'] = $userData['nombre'];
    $data['apellido'] = $userData['apellido'];
    $data['mail'] = $userData['mail'];
    $data['tel_fijo'] = $userData['tel_fijo'];
    $data['tel_movil'] = $userData['tel_movil'];
    $this->db->insert('vecino',$data);
    $idVecinoAgregado = $this->db->insert_id();

    // create_domicilio //
    if ($userData['id_domicilio'] == null){ // nuevo vecino con un domicilio que ya existe //
      $data2['id_calle'] =    (int) $userData['id_calle'];
      $data2['altura'] =      (int) $userData['altura'];
      $data2['entrecalle1_id'] = (int) $userData['entrecalle1'];
      $data2['entrecalle2_id'] = (int) $userData['entrecalle2'];
      $data2['id_barrio'] =   (int) $userData['id_barrio'];
      $data2['dpto'] = (int) $userData['departamento'];
      $data2['piso'] =        (int) $userData['piso']; 
      $this->db->insert('domicilio',$data2);
      $idDomicilioAgregado = $this->db->insert_id();
    } else {
      $idDomicilioAgregado = (int) $userData['id_domicilio'];
    }

    // create domicilioxvecino //
    $data3['id_vecino'] = $idVecinoAgregado;
    $data3['id_domicilio'] = $idDomicilioAgregado;
    $data3['fecha_alta'] = date('Y-m-d H:i:s',time());

    $this->db->insert('domiciliosxvecinos',$data3);

    return ;
  }



}
