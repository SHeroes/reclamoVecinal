<?php


class Tramites_m extends CI_Model {

    function get_all_tipo_tramites(){
      $this->db->from('tr_tipo_tramite');
      $tiporeclamo = $this->db->get()->result();
      return $tiporeclamo;
    }

    function get_all_pasos(){
      $this->db->from('tr_paso');
      $pasos = $this->db->get()->result();
      return $pasos;
    }

    function get_all_pasos_by_id_order(){
      $this->db->from('tr_paso');
      $this->db->order_by('id', 'desc');
      $pasos = $this->db->get()->result();
      return $pasos;
    }

    function insertar_tipo_tramite($array_id_ubicacion,$array_id_tiempo,$array_info){
      $max = count($array_id_ubicacion);
      $data['titulo'] =                $array_info['titulo'];
      $data['desc'] =                  $array_info['descripcion'];
      $data['tr_grupo_id'] =           $array_info['grupo']; 
      
      $this->db->insert('tr_tipo_tramite',$data);
      $id_tipo_tramite = $this->db->insert_id();

      for($i = 0; $i<$max; $i++){
        $data2['tr_tipo_tramite_id']= $id_tipo_tramite;
        $data2['tr_paso_id']= $array_id_ubicacion[$i]->id;
        $data2['orden']= $array_id_ubicacion[$i]->ubicacion;
        foreach ($array_id_tiempo as $key => $value) {
          if($value->id == $i){
            $data2['tiempo_estimado']= $value->tiempo;    
          }
        }

        $this->db->insert('tr_pasos_x_tipo_tramite',$data2);
      }
      return $max;
    }

    function insertar_paso_tramite($info){
      $data['id_sector'] =          $info['id_sector'];
      $data['titulo'] =             $info['titulo'];
      $data['desc'] =               $info['descripcion'];
      $data['check_list_json'] =     $info['checklist'];      

      return $this->db->insert('tr_paso',$data);      
    }

    function insert_formulario($info_form){
      $data['tr_paso_id'] =       $info_form['id_paso'];
      $data['file_name'] =        $info_form['file_name'];
      $data['codigo_interno'] =   $info_form['cod_int'] ;
      $data['titulo'] =           $info_form['titulo'];
      $data['desc'] =             $info_form['descripcion'];
      
      return $this->db->insert('tr_formularios',$data);
    }

    function get_all_grupos(){
      $this->db->from('tr_grupos');
      $grupos = $this->db->get()->result();
      return $grupos;
    }

/*
    function get_all_tipo_reclamos(){
      $this->db->from('tiporeclamo');
      $tiporeclamo = $this->db->get()->result();
      return $tiporeclamo;
    }

    function get_all_tipo_reclamos_by_sector($sectorId){
      $sectorId == '' ? $where_cond = '' : $where_cond = " and usuariosxsector.id_sector ='". $sectorId . "'";
      $this->db->select('id_tipo_reclamo, tiempo_respuesta_hs, titulo, descripcion, sectores.denominacion')
              ->from('tiporeclamo, user, usuariosxsector, sectores')
              ->where("tiporeclamo.id_responsable = usuariosxsector.id_usuario  and estado_activo = true and
 user.id = usuariosxsector.id_usuario and sectores.id_sector = usuariosxsector.id_sector" . $where_cond);

      $tiposreclamo_filtrados = $this->db->get()->result();
      return $tiposreclamo_filtrados;
    }

    function get_all_tipo_reclamos_by_secretary($sectorId){
      $sectorId == '' ? $where_cond = '' : $where_cond = " and sectores.id_padre ='". $sectorId . "'";
      $this->db->select('id_tipo_reclamo, tiempo_respuesta_hs, titulo, descripcion, sectores.denominacion')
              ->from('tiporeclamo, user, usuariosxsector, sectores')
              ->where("tiporeclamo.id_responsable = usuariosxsector.id_usuario  and estado_activo = true and
 user.id = usuariosxsector.id_usuario and sectores.id_sector = usuariosxsector.id_sector" . $where_cond);
              
      $tiposreclamo_filtrados = $this->db->get()->result();
      return $tiposreclamo_filtrados;
    }

    function get_responsables(){
      $str_query = "
      SELECT user.id as id_responsable , nombre , apellido, denominacion as sec_nombre , sectores.id_sector as sec_id
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
    */
}