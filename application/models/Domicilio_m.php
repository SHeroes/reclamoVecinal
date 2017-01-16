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

}