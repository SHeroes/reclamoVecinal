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
            redirect('/main_office/show_main');
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

    //si se post algo como filtro lo uso, sino no muestro ninguno
    $post = $this->input->post(null,true);
    if( count($post) ) {

      if (isset($post['id_vecino'])){
          $new_data['id_vecino'] = $post['id_vecino'];
          $new_data['name_vecino'] = $post['name_vecino'];
          if (isset($post['secretaria_filter'])){
            $new_data['secretaria_selected'] = $post['secretaria_filter'];
            $new_data['oficinas_filtradas'] = $this->sector_m->get_all_sector_by_father_id($new_data['secretaria_selected']);
            //print_r($new_data['oficinas_filtradas']);
          }
          if (isset($post['oficina_filter'])){
            $this->load->model('reclamo_tipo_m');
            $new_data['tipo_reclamos_filtrados'] = $this->reclamo_tipo_m->get_all_tipo_reclamos_by_sector($post['oficina_filter']);
            
            $new_data['id_actual_user'] = $this->session->userdata('id');
            $new_data['vecinos'] = $this->vecino_m->get_all_vecinos();

          }
      } else {
          if (isset($post['DNI_filter'])){
            $new_data['vecinos_filtrados'] = $this->vecino_m->get_vecinos_by_DNI($post['DNI_filter']);
          }
          if (isset($post['Apellido_filter'])){
            $new_data['vecinos_filtrados'] = $this->vecino_m->get_vecinos_by_Apellido($post['Apellido_filter']);
          }

          if( count($new_data['vecinos_filtrados']) == 0){
            $new_data['all_domicilios'] = $this->domicilio_m->get_all_domicilios();
            
          }
      }

    } else { //NO HAY FILTRADOS TODAVIA

    }

    

    $this->load->view('main_operator',$this->data);
    $this->load->view('reclamos',$new_data);
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
        $new_data['vecinos_filtrados'] = $this->vecino_m->get_vecinos_by_DNI($vecino_filter['DNI_filter']);
      }
      if (isset($vecino_filter['Apellido_filter'])){
        $new_data['vecinos_filtrados'] = $this->vecino_m->get_vecinos_by_Apellido($vecino_filter['Apellido_filter']);
      }
    }

    $new_data['all_domicilios'] = $this->domicilio_m->get_all_domicilios();
    $new_data['all_barrios'] = $this->domicilio_m->get_all_barrios();

    $this->load->view('main_operator',$this->data);
    $this->load->view('vecinos',$new_data);
    $this->load->view('footer',$this->data);
	}

  function show_reclamos(){
    if($this->basic_level() != 3) {
      $this->load->view('restricted',$this->data);
      return ;
    }

    $this->load->model('reclamo_m');

    $new_data['reclamos'] = "todos los reclamos";

    $this->load->view('main_operator',$this->data);
    $this->load->view('show_reclamos',$new_data);
    $this->load->view('footer',$this->data);   
  }

  function insert_reclamo(){
    $info = $this->input->post(null,true);
    if( count($info) ) {
      $this->load->model('reclamo_m');
      $saved = $this->reclamo_m->create_reclamo($info);


    }
    if ( isset($saved) && $saved ) {
      echo '<script> alert( "Numero de Reclamo:  '.$saved.'");
         window.location.replace("/index.php/main_operator/show_main");   
      </script>';
       //echo "reclamo agregado exitosamente";      
       //redirect('main_operator/show_main');
    }
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