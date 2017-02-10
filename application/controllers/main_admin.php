<?php

class Main_admin extends CI_Controller{
  var $data = array(
    'perfil' => '' ,
    'perfil_lvl' => 9 ,
    'is_admin' => false,
    'name' => ''
   );

  public function __construct()
  {
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
            $this->data['perfil'] = 'Intendente';  
            break;
      }
      return $this->data['perfil_lvl'];
  }

  function show_main() {    
    if($this->basic_level() != 0) {
      $this->load->view('restricted',$this->data);
      return ;
    }
    $this->load->model('sector_m');
    $sectores = $this->sector_m->get_all_sectores();
    $this->data['array_sectores'] = $sectores;

    $this->load->model('user_m');
    $all_users = $this->user_m->get_all__users();
    $this->data['all_users'] = $all_users;

    $this->load->view('main_admin',$this->data);
    $this->load->view('usuarios',$this->data);
    $this->load->view('footer',$this->data);
/*
    switch ($this->session->userdata('perfil_level')){
      case 0:
        data['is_admin'] = true;
        //print_r($this->perfil);
        $this->load->model('sector_m');
        $sectores = $this->sector_m->get_all_sectores();
        data['array_sectores'] = $sectores;

        $this->load->model('user_m');
        $all_users = $this->user_m->get_all__users();
        data['all_users'] = $all_users;

        $this->load->view('main_admin',data);
        $this->load->view('usuarios',data);
        $this->load->view('footer',data);
      break;
      case 2: 
        $this->load->view('main_oficina',data);
        //$this->load->view('reclamos',data);
        $this->load->view('footer',data);
      case 3:
        $this->load->view('main_operator',data);
        //$this->load->view('reclamos',data);
        $this->load->view('footer',data);
      break;
      default:
        $this->load->view('restricted',data);
      break;
    }  
    */
  }

  function show_sector() {
    if($this->basic_level() != 0) {
      $this->load->view('restricted',$this->data);
      return ;
    }
    $this->load->model('sector_m');
    $sectores = $this->sector_m->get_all_sectores();
    $this->data['array_sectores'] = $sectores;
    $this->load->view('main_admin',$this->data);
    $this->load->view('sectores',$this->data);
    $this->load->view('footer',$this->data);
  }

  function create_new_sector() {
    $userInfo = $this->input->post(null,true);
    if( count($userInfo) ) {
      $this->load->model('sector_m');
      $saved = $this->sector_m->create_new_sector($userInfo);
    }
    if ( isset($saved) && $saved ) {
       echo "success";
    }
  }

  function update_sector() {
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

  function update_user() {
    $info = $this->input->post(null,true);
    if( count($info) ) {
      $this->load->model('user_m');
      $saved = $this->user_m->update_user_id($info['id'],$info);
    }
    if ( isset($saved) && $saved ) {
       echo "success";
    }
  }

  function show_calendar() {
    if($this->basic_level() != 0) {
      $this->load->view('restricted',$this->data);
      return ;
    }
    $this->load->model('calendar_m');
    $fechas = $this->calendar_m->get_holy_dates();
    $this->data['array_fechas'] = $fechas;

    $this->load->view('main_admin',$this->data);
    $this->load->view('calendar',$this->data);     
    $this->load->view('footer',$this->data);
  }

  function insert_date() {
    $info = $this->input->post(null,true);
    if( count($info) ) {
      $this->load->model('calendar_m');
      $saved = $this->calendar_m->insert_date($info['datepicker']);
    }
    if ( isset($saved) && $saved ) {
       echo "feriado agregado exitosamente";
       redirect('main_admin/show_calendar');
    }
  }

  function delete_date() {
    $info = $this->input->post(null,true);
    if( count($info) ) {
      $this->load->model('calendar_m');
      $saved = $this->calendar_m->delete_date($info['datepicker2']);
    }
    if ( isset($saved) && $saved ) {
       echo "feriado eliminado exitosamente";
        redirect('main_admin/show_calendar');
    }
  }

  function show_reclamo_tipo() {
    if($this->basic_level() != 0) {
      $this->load->view('restricted',$this->data);
      return ;
    }
    $this->load->model('reclamo_tipo_m');
    $tipos_reclamos = $this->reclamo_tipo_m->get_all_tipo_reclamos();
    $this->data['tipos_reclamos'] = $tipos_reclamos;
    $responsables = $this->reclamo_tipo_m->get_responsables();
    $this->data['array_responsables'] = $responsables;      

    $this->load->view('main_admin',$this->data);
    $this->load->view('reclamos_catalogo',$this->data);     
    $this->load->view('footer',$this->data);
  }

  function insertar_tipo_reclamo() {
      $info = $this->input->post(null,true);
      if( count($info) ) {
        $this->load->model('reclamo_tipo_m');
        $saved = $this->reclamo_tipo_m->insert_tipo_reclamo($info);
      }
      if ( isset($saved) && $saved ) {
         echo "reclamo agregado exitosamente";
         redirect('main_admin/show_reclamo_tipo');
      }
  }

  function modificar_tipo_reclamo() {
    $info = $this->input->post(null,true);
    if( count($info) ) {
      $this->load->model('reclamo_tipo_m');
      $saved = $this->reclamo_tipo_m->update_tipo_reclamo($info);
    }
    if ( isset($saved) && $saved ) {
       echo "reclamo modificado exitosamente";
       redirect('main_admin/show_reclamo_tipo');
    }
  }
  
  function desactivar_tipo_reclamo() {
    $info = $this->input->post(null,true);
    if( count($info) ) {
      $this->load->model('reclamo_tipo_m');
      $saved = $this->reclamo_tipo_m->disable_tipo_reclamo($info);
    }
    if ( isset($saved) && $saved ) {
       echo "reclamo deshabilitado exitosamente";
        redirect('main_admin/show_reclamo_tipo');
    }
  }

}
