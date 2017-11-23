<?php

class Main_tr_vecino extends CI_Controller{

  var $data = array(
    'perfil' => '' ,
    'perfil_lvl' => 9 ,    // TODO poner usuarios para hacer le correcto login
    'is_admin' => false,
    'name' => ''
   );

	public function __construct(){
		parent::__construct();
    
    /*
		if( !$this->session->userdata('isLoggedIn') ) {
	    redirect('/login/show_login');   
      //print_r("hola");
		}
    */
    
	}

  public function index()
  {
    /*
    if($this->basic_level() != 13) {
      $this->load->view('restricted',$this->data);
      return ;
    }
*/
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
    
    $this->load->view('tramites/main_tr_vecino',$this->data);
    //$this->load->view('tramites/show_tr_vecino',$new_data);
    $this->load->view('tramites/footer_base_tr',$this->data);
  }

}