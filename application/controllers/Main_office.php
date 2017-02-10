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
    /*
    $this->load->model('sector_m');
    $this->load->model('domicilio_m');
    $this->load->model('vecino_m');
    //$new_data['last_10_days_reclamos'] = '';

    $new_data['secretarias'] = $this->sector_m->get_all_sector_by_type('Secretaria');
    $new_data['oficinas'] = $this->sector_m->get_all_sector_by_type('Oficina');

    $this->load->model('vecino_m');
    
    $new_data['vecinos_filtrados'] = '';
    $new_data['id_vecino'] = '';
    $new_data['name_vecino'] = '';


    $new_data['all_domicilios_reclamo'] = $this->domicilio_m->get_all_domicilios_reclamo();
    $new_data['all_barrios'] = $this->domicilio_m->get_all_barrios();
    */

    $new_data['reclamos_list'] = '';
    $this->load->model('reclamo_m');
    $new_data['reclamos_list'] = $this->reclamo_m->get_all_reclamos_by_state('Iniciado');

    $this->load->view('main_office',$this->data);
    $this->load->view('reclamos_office',$new_data);
    $this->load->view('footer',$this->data);
	}

}