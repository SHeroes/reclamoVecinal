<?php

class Main_intendente extends CI_Controller{

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
            redirect('/main_supervisor/show_main');
            break;            
        case 5: 
            $this->data['perfil'] = 'Intendente';  
            break;
        case 13:
            $this->data['perfil'] = 'Operador Tramites';
            redirect('/tramites/main_tr_operator');
            break;               
      }
      return $this->data['perfil_lvl'];
  }

  function show_reclamos(){
    if($this->basic_level() != 5) {
      $this->load->view('restricted',$this->data);
      return ;
    }

    $this->load->model('reclamo_m');
    $this->load->model('user_m');
    $this->load->model('reclamo_tipo_m');
    $this->load->model('sector_m');

    $new_data['reclamos_list'] = '';
    $new_data['query_responsable'] = '';
    $new_data['query_tipos_reclamo'] = '';
    $new_data['query_sectores'] = '';


    $info = $this->input->post(null,true);

    if( count($info) ){
      if( !isset($info['status_filter_selector']))        $info['status_filter_selector'] = '';
      if( !isset($info['reclamoType_filter_selector']))   $info['reclamoType_filter_selector'] = '';
      if( !isset($info['desde']))                         $info['desde'] = '';
      if( !isset($info['hasta']))                         $info['hasta'] = '';
      if( !isset($info['sector_filter_selector_of']))     $info['sector_filter_selector_of'] = '';
      if( !isset($info['sector_filter_selector_sec']))    $info['sector_filter_selector_sec'] = '';
      if( !isset($info['responsable_filter_selector']))   $info['responsable_filter_selector'] = '';
      if( !isset($info['nro_rec']))                       $info['nro_rec'] = '';
      if( !isset($info['apellido']))                      $info['apellido'] = '';
      if( !isset($info['dni']))                           $info['dni'] = '';      
    } else {
      $info['status_filter_selector'] = '';
      $info['reclamoType_filter_selector'] = '';
      $info['desde'] = '';
      $info['hasta'] = '';
      $info['sector_filter_selector_of'] = '';
      $info['sector_filter_selector_sec'] = '';
      $info['responsable_filter_selector'] = '';
      $info['nro_rec'] = '';
      $info['apellido'] = '';
      $info['dni'] = '';      
    }

    $new_data['info'] = $info;
    $new_data['query_responsable'] = $this->user_m->get_all_users_responsables();
    $new_data['query_tipos_reclamo'] = $this->reclamo_tipo_m->get_all_tipo_reclamos();
    $new_data['query_secretarias'] = $this->sector_m->get_all_sector_by_type('Secretaria');
    $new_data['query_oficinas'] = $this->sector_m->get_all_sector_by_type('Oficina');

    $new_data['reclamos_list'] = $this->reclamo_m->get_all_reclamos_for_supervisor('estado',$info['status_filter_selector'], $info['sector_filter_selector_of'],$info['sector_filter_selector_sec'], $info['desde'], $info['hasta'], $info['reclamoType_filter_selector'], $info['responsable_filter_selector'], $info['nro_rec'], $info['apellido'], $info['dni'] );

    $this->load->view('main_intendente',$this->data);
    $this->load->view('reclamos_intendente',$new_data);
    $this->load->view('footer_base',$this->data);   
  }

}