<?php

class Main_operator extends CI_Controller{

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
            break;
        case 4: 
            $this->data['perfil'] = 'Intendente';  
            break;
      }
      return $this->data['perfil_lvl'];
  }

	function show_main() {
	    if($this->basic_level() != 3) {
	      $this->load->view('restricted',$this->data);
	      return ;
	    }

	    $this->load->view('main_operator',$this->data);
	    //$this->load->view('reclamos',$data);
	    $this->load->view('footer',$this->data);
	}

	function show_vecinos() {

    if($this->basic_level() != 3) {
      $this->load->view('restricted',$this->data);
      return ;
    }
    $this->load->model('domicilio_m');
    $this->load->model('vecino_m');
    
    $new_data['vecinos_filtrados'] = '';
    //si se post algo como filtro lo uso, sino no muestro ninguno
    $vecino_filter = $this->input->post(null,true);
    if( count($vecino_filter) ) {
      if (isset($vecino_filter['DNI_filter'])){
        ///print_r("buscando por DNI ...");
        $new_data['vecinos_filtrados'] = $this->vecino_m->get_vecinos_by_DNI($vecino_filter['DNI_filter']);
        //print_r($new_data['vecinos_filtrados']);
      }
      if (isset($vecino_filter['Apellido_filter'])){
        //print_r("buscando por Apellido_filter .");
        $new_data['vecinos_filtrados'] = $this->vecino_m->get_vecinos_by_Apellido($vecino_filter['Apellido_filter']);
      }
    }


    
    $new_data['all_domicilios'] = $this->domicilio_m->get_all_domicilios();
    $new_data['all_barrios'] = $this->domicilio_m->get_all_barrios();

    $this->load->view('main_operator',$this->data);
    $this->load->view('vecinos',$new_data);
    $this->load->view('footer',$this->data);
	}

  function insert_vecino() {
    $info = $this->input->post(null,true);
    if( count($info) ) {
      $this->load->model('vecino_m');
      $saved = $this->vecino_m->create_vecino($info);
    }
    if ( isset($saved) && $saved ) {
       echo "vecino agregado exitosamente";
       redirect('main_operator/show_vecinos');
    }
  }

  function search_calle(){
    $this->load->model('domicilio_m');
    $search =  $this->input->post('searchCalle');    
    $query = $this->domicilio_m->get_calle($search);
    echo json_encode ($query);
    
  }

}