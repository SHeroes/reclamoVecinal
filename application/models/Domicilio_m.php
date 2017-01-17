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

	function get_all_domicilios(){
		$this->db->select('id_domicilio, calle, altura' )
							->from('domicilio, calles')
							->where('domicilio.id_calle = calles.id_calle');
	  $domicilios = $this->db->get()->result();
	  return $domicilios; 
	}

	function get_domicilio_by_id($id){
		$where_str = 'domicilio.id_calle = calles.id_calle and id_domicilio='.$id ;
		$this->db->select('id_domicilio, calle, altura' )
					->from('domicilio, calles')
					->where($where_str);
	  $domicilio = $this->db->get()->result();
	  return $domicilio; 
	}

	function get_all_barrios(){
	  $this->db->from('barrios');
	  $barrios = $this->db->get()->result();
	  return $barrios;  
	}

}