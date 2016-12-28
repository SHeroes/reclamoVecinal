<?php


class direccion_m extends CI_Model {

    function  create_new_direccion( $direccionData ) {
      $data['nombre'] = $direccionData['direccion'];
      $data['id_secretaria'] = $direccionData['id_secretaria'];
      //TODO si lo hago tomando el nombre del secretario.. que lo busque en la base primero y aho saco el id
      return $this->db->insert('direcciones',$data);
    }

    function get_all_direcciones(){
		$this->db->from('direcciones');
        $direcciones = $this->db->get()->result();
        return $direcciones;
    }
    

}