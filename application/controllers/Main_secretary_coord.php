<?php

class Main_secretary_coord extends CI_Controller{

  var $data = array(
    'perfil' => '' ,
    'perfil_lvl' => 9 ,
    'is_admin' => false,
    'name' => ''
   );

	public function __construct(){
		parent::__construct();
		if( !$this->session->userdata('isLoggedIn') ) {
	    redirect('/login/show_login');   
		}
	}

  public function basic_level(){
      $this->data['name'] = $this->session->name;
      $this->data['perfil_lvl'] = $this->session->userdata('perfil_level');
      switch ($this->data['perfil_lvl']){
        case 0:
            $this->data['perfil'] = 'Administrador';
            $this->data['is_admin'] = true;
            redirect('/main_admin/show_main');
            break;
        case 1: 
            $this->data['perfil'] = 'Secretario';
            break;
        case 2:
            $this->data['perfil'] = 'Oficina';
            redirect('/main_office/show_main');
            break;
        case 3: 
            $this->data['perfil'] = 'Operador';
            redirect('/main_operator/show_main');
            break;
        case 4: 
            $this->data['perfil'] = 'Intendente';  
            break;
      }
      return $this->data['perfil_lvl'];
  }

	function show_main() {
    if($this->basic_level() != 1) {
      $this->load->view('restricted',$this->data);
      return ;
    }
    //$id_sector = $this->details->id_sector;
    $id_sector = $this->session->id_sector;
    $new_data['reclamos_list'] = '';
    $new_data['user_enable'] = 'officer';
    
    $this->load->model('reclamo_m');
    //si se post algo como filtro lo uso, sino no muestro ninguno
    $info = $this->input->post(null,true);
    if( count($info) && isset($info['status_filter_selector'])){
      $new_data['reclamos_list'] = $this->reclamo_m->get_all_reclamos_for_secretary_by('estado',$info['status_filter_selector'], $id_sector);
    } else {
      $new_data['reclamos_list'] = $this->reclamo_m->get_all_reclamos_for_secretary_by('estado','', $id_sector);
    }

    //$new_data['reclamos_list'] = $this->reclamo_m->get_all_reclamos_by_state('Iniciado');
    
    $this->load->view('main_secretary_coord',$this->data);
    $this->load->view('reclamos_secretary_coord',$new_data);
    $this->load->view('footer_base',$this->data);
	}



  public function get_vecino_info(){

    $this->load->model('vecino_m');
    $id_vecino =  $this->input->post('id_vecino');
    $query = $this->vecino_m->get_vecino_info($id_vecino);
    echo json_encode ($query);
    
  }

  public function editar_observacion(){
    $info = $this->input->post(null,true);
    if( count($info) ) {
      $id_officer = $this->session->userdata('id');
      $this->load->model('reclamo_m');
      $obs_str =  $this->input->post('observacion_input');
      $id_reclamo =  $this->input->post('id_reclamo');

      $saved = $this->reclamo_m->concat_observacion($obs_str, $id_reclamo, $id_officer);
      echo json_encode ($saved);
      //print_r($saved);
    }
    if ( isset($saved) && $saved ) {
      echo 'Editado Correctamente';
    }
  }

  public function ver_observaciones(){
    $info = $this->input->post(null,true);
    if( count($info) ) {
      $this->load->model('reclamo_m');
      $id_reclamo =  $this->input->post('id_reclamo');

      $saved = $this->reclamo_m->show_observaciones($id_reclamo);
      echo json_encode ($saved);
      //print_r($saved);
    }
    if ( isset($saved) && $saved ) {
      //echo 'Editado Correctamente';
    }
  }

  public function actualizar_estado(){
    $info = $this->input->post(null,true);
    if( count($info) ) {
      $this->load->model('reclamo_m');
      $str_state =  $this->input->post('state');
      $id_reclamo =  $this->input->post('id_reclamo');
      $saved = $this->reclamo_m->update_state_reclamo($str_state, $id_reclamo);
    }
    if ( isset($saved) && $saved ) {
      echo 'Estado del Reclamo actualizado Correctamente';
    }
  }

}