<?php

class Main_office extends CI_Controller{

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
    if($this->basic_level() != 2) {
      $this->load->view('restricted',$this->data);
      return ;
    }

    $new_data['reclamos_list'] = '';
    $this->load->model('reclamo_m');
    //$new_data['reclamos_list'] = $this->reclamo_m->get_all_reclamos_by_state('Iniciado');
    $new_data['reclamos_list'] = $this->reclamo_m->get_all_reclamos_by_state('');

    $this->load->view('main_office',$this->data);
    $this->load->view('reclamos_office',$new_data);
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
      $this->load->model('reclamo_m');
      $obs_str =  $this->input->post('observacion_input');
      $id_reclamo =  $this->input->post('id_reclamo');
      $saved = $this->reclamo_m->update_obs_info($obs_str, $id_reclamo);
    }
    if ( isset($saved) && $saved ) {
      echo 'Editado Correctamente';
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