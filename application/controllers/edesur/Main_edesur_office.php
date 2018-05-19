<?php

class Main_edesur_office extends CI_Controller{

  var $data = array(
    'perfil' => '' ,
    'perfil_lvl' => 9 ,    // TODO poner usuarios para hacer le correcto login
    'is_admin' => false,
    'name' => ''
   );

	public function __construct(){
		parent::__construct();        
	}

  public function index()
  {
    redirect('/edesur/Main_edesur_office/show_main');
  }


  function show_main() {
    if($this->session->sector_name != $this->config->item('edesur_oficina_name')){
      redirect('/login/logout_user');
    }

    $this->data['perfil'] = 'Oficina';
    $this->data['name'] = $this->session->name;
    $this->data['my_id_user'] = $this->session->userdata('id');
    $this->data['my_sha1_pass'] = $this->session->userdata('password');      
    $this->data['perfil_lvl'] = $this->session->userdata('perfil_level');
    $id_sector = $this->session->id_sector;    
    $new_data['reclamos_list'] = '';
    $new_data['reclamos_list_type'] ='';
    $arrayListaReclamos = array();


    $this->load->model('reclamo_tipo_m');
    $this->load->model('reclamo_edesur_m');
    $new_data['reclamos_list_type'] =  $this->reclamo_tipo_m->get_all_tipo_reclamos_by_sector($id_sector);

    foreach ($new_data['reclamos_list_type'] as $key => $value) {
      array_push($arrayListaReclamos, $this->reclamo_edesur_m->get_all_reclamos_edesur($value->id_tipo_reclamo));

    }

    $new_data['reclamos_list'] = $arrayListaReclamos[0];    //TIPO DE RECLAMO UNICO PARA ESTA OFICINA

    
    $this->load->view('edesur/edesur_office_main',$this->data);
    $this->load->view('edesur/edesur_office_data_JSON',$new_data);
    $this->load->view('edesur/edesur_office',$new_data);
    $this->load->view('edesur/edesur_footer_empty',$this->data);
  }

}