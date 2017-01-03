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
    $this->load->model('sector_m');
    $sectores = $this->sector_m->get_all_sectores();
    $data['array_sectores'] = $sectores;

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

  function show_sector() {
    $this->load->model('sector_m');
    $sectores = $this->sector_m->get_all_sectores();
    $data['array_sectores'] = $sectores;
    $data['is_admin'] = false;
    $data['name'] = $this->session->name;
    $this->basic_level($this->session->userdata('perfil_level'));
    $data['perfil'] = $this->perfil;
    if ($this->session->userdata('perfil_level') == 0){
      $data['is_admin'] = true;
      $this->load->view('main_admin',$data);
      $this->load->view('sectores',$data);
      $this->load->view('footer',$data);
    } else {
      $this->load->view('restricted',$data);
    }
  }


  function  create_new_sector() {
    $userInfo = $this->input->post(null,true);
    if( count($userInfo) ) {
      $this->load->model('sector_m');
      $saved = $this->sector_m->create_new_sector($userInfo);
    }
    if ( isset($saved) && $saved ) {
       echo "success";
    }
  }

  function  update_sector() {
    $info = $this->input->post(null,true);
    if( count($info) ) {
      $this->load->model('sector_m');
      $saved = $this->sector_m->update_sector_id($info['id_sector'],$info);
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
       echo "success creating user with id:".$saved;
    }
  }
}
