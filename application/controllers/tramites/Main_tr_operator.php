<?php

class Main_tr_operator extends CI_Controller{

  var $data = array(
    'perfil' => '' ,
    'perfil_lvl' => 9 ,    // TODO poner usuarios para hacer le correcto login
    'is_admin' => false,
    'name' => ''
   );

	public function __construct(){
		parent::__construct();
    
		if( !$this->session->userdata('isLoggedIn') ) {
	    redirect('/login/show_login');   
      //print_r("hola");
		}
    
	}

  public function index()
  {
    if($this->basic_level() != 13) {
      $this->load->view('restricted',$this->data);
      return ;
    }

    //$id_sector = $this->details->id_sector;
    /*
    $id_sector = $this->session->id_sector;
    $new_data['tramites_list'] = '';
    $new_data['user_enable'] = 'officer';
    $new_data['list_reclaim_type'] = array();

    $this->load->model('reclamo_tipo_m');
*/

    $this->load->model('tramites_m');
    $new_data['tramites_list'] = 'TRAMITES ARRAY';    
    $this->load->view('tramites/main_tr_office',$this->data);
    $this->load->view('tramites/show_tr_office',$new_data);
    $this->load->view('footer_base',$this->data);

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
            redirect('/main_secretary_coord/show_main');
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
            redirect('/main_supervisor/show_main'); 
            break;            
        case 5: 
            $this->data['perfil'] = 'Intendente';  
            break;
        case 13: // OPARADOR TRAMITES
            $this->data['perfil'] = 'Operador Tramites';
            break;
      }
      return $this->data['perfil_lvl'];
  }

}