<?php

class main_admin extends CI_Controller{
  var $perfil = '';
  public function __construct()
  {
    parent::__construct();
    if( !$this->session->userdata('isLoggedIn') ) {
        redirect('/login/show_login');
    }   
  }

  /**
   * This is the controller method that drives the application.
   * After a user logs in, show_main() is called and the main
   * application screen is set up.
   */
  function show_main() {
    $data['is_admin'] = false;
    $data['name'] = $this->session->name;
    $this->basic_level($this->session->userdata('perfil_level'));
    $data['perfil'] = $this->perfil;

    switch ($this->session->userdata('perfil_level')){
      case 0:
        $data['is_admin'] = true;
        //print_r($this->perfil);
        $this->load->view('main_admin',$data);
        $this->load->view('usuarios',$data);
        $this->load->view('footer',$data);
      break;
      case 3:
        $this->load->view('main_operator',$data);
        //$this->load->view('reclamos',$data);
        $this->load->view('footer',$data);
      break;
      default:
        $this->load->view('restricted',$data);
      break;
    }  
  }

  private function basic_level($level){
      switch ($level){
        case 0:
            $this->perfil = 'Administrador';
            break;
        case 1: 
            $this->perfil = 'Secretario';
            break;
        case 2:
            $this->perfil = 'Direccion';
            break;
        case 3: 
            $this->perfil = 'Operador';
            break;
        case 4: 
            $this->perfil = 'Intendente';  
            break;
      }
  }
  function show_secretaria() {
    $this->load->model('secretary_m');
    $secretarias = $this->secretary_m->get_all_secretaries();
    $data['data_array'] = $secretarias;
    $data['is_admin'] = false;
    $data['name'] = $this->session->name;
    $this->basic_level($this->session->userdata('perfil_level'));
    $data['perfil'] = $this->perfil;
    if ($this->session->userdata('perfil_level') == 0){
      $data['is_admin'] = true;
      $this->load->view('main_admin',$data);
      $this->load->view('secretarias',$data);
      $this->load->view('footer',$data);
    } else {
      $this->load->view('restricted',$data);
    }    

  }

  function show_direccion() {
    $this->load->model('direccion_m');
    $direcciones = $this->direccion_m->get_all_direcciones();
    $data['data_array'] = $direcciones;
    $data['is_admin'] = false;
    $data['name'] = $this->session->name;
    $this->basic_level($this->session->userdata('perfil_level'));
    $data['perfil'] = $this->perfil;
    if ($this->session->userdata('perfil_level') == 0){
      $data['is_admin'] = true;
      $this->load->view('main_admin',$data);
      $this->load->view('direcciones',$data);
      $this->load->view('footer',$data);
    } else {
      $this->load->view('restricted',$data);
    }  
  }

  function  create_new_secretary() {
    $userInfo = $this->input->post(null,true);
    if( count($userInfo) ) {
      $this->load->model('secretary_m');
      $saved = $this->secretary_m->create_new_secretary($userInfo);
    }
    if ( isset($saved) && $saved ) {
       echo "success";
    }
  }

  function  create_new_direccion() {
    $userInfo = $this->input->post(null,true);
    if( count($userInfo) ) {
      $this->load->model('direccion_m');
      $saved = $this->direccion_m->create_new_direccion($userInfo);
    }
    if ( isset($saved) && $saved ) {
       echo "success";
    }
  }

  function create_new_user() {
    $userInfo = $this->input->post(null,true);

    if( count($userInfo) ) {
      $this->load->model('user_m');
      $saved = $this->user_m->create_new_user($userInfo);
    }

    if ( isset($saved) && $saved ) {
       echo "success";
    }
  }
}
