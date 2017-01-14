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
  function get_vecino_by_DNI{

    return $vecinos_filtrados;
  }

  function get_all_vecinos(){
    $this->db->from('vecinos');
    $users = $this->db->get()->result();
    return $users;  
  }

}
