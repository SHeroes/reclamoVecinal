<?php


class sector_m extends CI_Model {

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

    // Function To Fetch Selected Student Record
    function show_sectores_id($data){
    $this->db->select('*');
    $this->db->from('students');
    $this->db->where('student_id', $data);
    $query = $this->db->get();
    $result = $query->result();
    return $result;
    }


    // Update Query For Selected Student
    function update_sector_id($id,$sectorData){
      $sectorData['padre'] == '' ? $data['id_padre'] = null : $data['id_padre'] = $sectorData['padre'];
      $data['denominacion'] = $sectorData['denominacion'];
      $data['tipo'] = $sectorData['tipo'];
      $data['fecha_modificacion'] =  date('Y-m-d H:i:s',time());
    $this->db->where('id_sector', $id);
    $this->db->update('sectores', $data);

    }
    

}