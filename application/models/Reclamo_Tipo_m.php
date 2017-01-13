<?php


class Reclamo_Tipo_m extends CI_Model {

    function get_all_tipo_reclamos(){
      $this->db->from('tiporeclamo');
      $tiporeclamo = $this->db->get()->result();
      return $tiporeclamo;
    }

    function get_responsables(){
      $str_query = "
      SELECT id as id_responsable , nombre , apellido, denominacion as sec_nombre , sectores.id_sector as sec_id
      FROM user , usuariosxsector , sectores
      WHERE perfil_level = '2' and user.id = usuariosxsector.id_usuario and usuariosxsector.id_sector = sectores.id_sector
      ";
      $query = $this->db->query($str_query);

      return $query->result_array();
    }

    function insert_tipo_reclamo($tipo_reclamo){
      //$data['id_tipo_reclamo'] = $tipo_reclamo[''];
      $data['tiempo_respuesta_hs'] = $tipo_reclamo['tiempo_respuesta'];
      $data['id_responsable'] = $tipo_reclamo['id_responsable'];
      $data['descripcion'] = $tipo_reclamo['descripcion'];
      $data['titulo'] = $tipo_reclamo['titulo'];

      return $this->db->insert('tiporeclamo',$data);
    }

    function update_tipo_reclamo($tipo_reclamo){
      $data['tiempo_respuesta_hs'] = $tipo_reclamo['tiempo_respuesta'];
      $data['id_responsable'] = $tipo_reclamo['id_responsable'];
      $data['descripcion'] = $tipo_reclamo['descripcion'];
      $data['titulo'] = $tipo_reclamo['titulo'];
      $data['estado_activo'] = true;

      $this->db->where('id_tipo_reclamo',  $tipo_reclamo['id_tipo_reclamo']);
      return $this->db->update('tiporeclamo', $data);
    }

    function disable_tipo_reclamo($tipo_reclamo){
      $data['estado_activo'] = false;

      $this->db->where('id_tipo_reclamo',  $tipo_reclamo['id_tipo_reclamo']);
      return $this->db->update('tiporeclamo', $data);
    }
}