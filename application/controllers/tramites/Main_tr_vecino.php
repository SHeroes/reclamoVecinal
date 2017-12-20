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
      print_r("hola");
		}
    */

        
	}

  public function index()
  {
    $info = $this->input->post(null,true);
    if( !isset($info['id_vecino']) ){
      // no se recibio post 
      redirect('/tramites/Main_tr_vecino/select_Vecino');
    }else{
      // muestro las opciones para que elijan los tramites

      $this->load->model('tramites_m');
      $new_data['id_vecino'] = $info['id_vecino']; 
      $new_data['tramites_list'] = 'TRAMITES ARRAY';    
      
      $this->load->view('tramites/tr_vecino_main',$this->data);
      $this->load->view('tramites/show_tr_vecino',$new_data);
      $this->load->view('tramites/tr_footer_base',$this->data);
    }
  }

  public function select_Vecino(){
    //print_r("aca se debe mostrar la lista de seleccino de vecino por DNI");
    $this->load->view('tramites/tr_vecino_main',$this->data);
  }

  public function create_Vecino(){
    print_r("aca se debe mostrar el formulario para crear vecino por DNI");
  }

}