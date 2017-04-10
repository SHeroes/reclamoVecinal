<?php

class Main_supervisor extends CI_Controller{

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
      $this->data['my_id_user'] = $this->session->userdata('id');
      $this->data['my_sha1_pass'] = $this->session->userdata('password');      
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
            $this->data['perfil'] = 'Supervisor';
            break;            
        case 5: 
            $this->data['perfil'] = 'Intendente';  
            break;
      }
      return $this->data['perfil_lvl'];
  }

	function show_main() {
    if($this->basic_level() != 4) {
      $this->load->view('restricted',$this->data);
      return ;
    }

    $new_data['reclamos_list_no_vistos'] = '';

    $this->load->model('reclamo_m');

    $new_data['reclamos_list_no_vistos'] = $this->reclamo_m->get_reclamos_no_vistos_creados_hace_mas_un_dia();

    $this->load->view('main_supervisor',$this->data);
    $this->load->view('sup_rec_list_no_vistos',$new_data);
    $this->load->view('footer_base',$this->data);
	}

  function show_no_contact() {
    if($this->basic_level() != 4) {
      $this->load->view('restricted',$this->data);
      return ;
    }

    $new_data['reclamos_list_no_contactados'] = '';

    $this->load->model('reclamo_m');

    $new_data['reclamos_list_no_contactados'] = 
    $this->reclamo_m->get_reclamos_vistos_no_contactados_hace_mas_dos_dias();

    $this->load->view('main_supervisor',$this->data);
    $this->load->view('sup_rec_list_no_contact',$new_data);
    $this->load->view('footer_base',$this->data);
  }

  function show_contactados() {
    if($this->basic_level() != 4) {
      $this->load->view('restricted',$this->data);
      return ;
    }

    $new_data['reclamos_list_contactados'] = '';

    $this->load->model('reclamo_m');

    $new_data['reclamos_list_contactados'] = $this->reclamo_m->get_all_reclamos_contactados_no_verificados();

    $this->load->view('main_supervisor',$this->data);
    $this->load->view('sup_rec_list_contactados',$new_data);
    $this->load->view('footer_base',$this->data);
  }

  
  function show_verificados() {
    if($this->basic_level() != 4) {
      $this->load->view('restricted',$this->data);
      return ;
    }
    $new_data['reclamos_list_verificados'] = '';
    $this->load->model('reclamo_m');
    $new_data['reclamos_list_verificados'] = $this->reclamo_m->get_all_reclamos_verificados();

    $this->load->view('main_supervisor',$this->data);
    $this->load->view('sup_rec_list_verificados',$new_data);
    $this->load->view('footer_base',$this->data);
  }

  public function verificacion_reclamo(){
    $info = $this->input->post(null,true);
    if( count($info) ) {
      $this->load->model('reclamo_m');

      $correctitud =  $this->input->post('correctitud');
      $id_reclamo =  $this->input->post('id_reclamo_asociado');

      $saved = $this->reclamo_m->verificacion_reclamo( $id_reclamo, $correctitud);
    }

    if ( isset($saved) && $saved ) {
      echo 'Verificado Correctamente';
    }
    //$this->load->view('test_query',$saved);
    //$this->load->view('footer_base',$this->data);  
  }

  public function editar_observacion_esp(){
    $info = $this->input->post(null,true);
    if( count($info) ) {
      $id_officer = $this->session->userdata('id');
      $this->load->model('reclamo_m');
      $obs_str =  $this->input->post('observacion_input');
      $id_reclamo =  $this->input->post('id_reclamo');

      $saved = $this->reclamo_m->concat_observacion_esp($obs_str, $id_reclamo, $id_officer);
      echo json_encode ($saved);
      //print_r($saved);
    }
    if ( isset($saved) && $saved ) {
      echo 'Editado Correctamente';
    }
  }

}