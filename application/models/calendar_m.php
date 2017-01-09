<?php


class calendar_m extends CI_Model {
/*
    function  create_new_sector( $sectorData ) {
      $sectorData['padre'] == '' ? $data['id_padre'] = null : $data['id_padre'] = $sectorData['padre'];
      $data['denominacion'] = $sectorData['denominacion'];
      $data['tipo'] = $sectorData['tipo'];
      $data['fecha_creacion'] =  date('Y-m-d H:i:s',time());
      //$data['cierre'] = $sectorData['fecha_cierre'];

      //TODO si lo hago tomando el nombre del secretario.. que lo busque en la base primero y aho saco el id
      return $this->db->insert('sectores',$data);
    }

    function get_all_sectores(){
		  $this->db->from('sectores');
      $sectores = $this->db->get()->result();
      return $sectores;
    }
*/
    function insert_date($fecha){
      $data['fecha'] = $fecha;
      return $this->db->insert('feriados',$data);
    }

    function delete_date($fecha){
      $data['fecha'] = $fecha;
      $this->db->where('fecha', $fecha);
      return $this->db->delete('feriados');

    }

    function get_holy_dates(){
      $set_lang = "SET lc_time_names = 'es_ES';";
      $reset_lang = "SET lc_time_names = 'en_US';";

      $str_query = "  
      SELECT year(fecha) anio,monthname(fecha) mes, dayname(fecha) dia, fecha FROM dbcav.feriados 
      WHERE dayname(fecha) != 'Sabado' AND dayname(fecha) != 'Domingo' and year(fecha) >= year(current_date())
      ORDER BY fecha ;
      ";

      $this->db->query($set_lang);
      $query = $this->db->query($str_query);
      $this->db->query($reset_lang);
      return $query->result_array();
    }
}