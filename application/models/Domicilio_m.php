<?php


class Domicilio_m extends CI_Model {

	function get_all_calles(){
	  $this->db->from('calles');
	  $calles = $this->db->get()->result();
	  return $calles;  
	}

	function get_calle($search){
		$this->db->select("id_calle,calle");
		$this->db->like('calle', $search);
		$this->db->from('calles');
		$query = $this->db->get();
		return $query->result();
	}

	/*
	 $this->db->select('t1.field, t2.field2')
	          ->from('table1 AS t1, table2 AS t2')
	          ->where('t1.id = t2.table1_id')
	          ->where('t1.user_id', $user_id);
	*/

	function get_all_domicilios(){
		$this->db->select('id_domicilio, calle, altura' )
							->from('domicilio, calles')
							->where('domicilio.id_calle = calles.id_calle');
	  $domicilios = $this->db->get()->result();
	  return $domicilios; 
	}

	function get_all_barrios(){
	  $this->db->from('barrios');
	  $barrios = $this->db->get()->result();
	  return $barrios;  
	}

}