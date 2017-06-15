<?php

class Reportes extends CI_Controller{

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

	function show_reportes_pSector() {

		switch ($this->session->userdata('perfil_level')){
		    case 0:
		        break;
		    case 4: 
		        break;            
		    case 5: 
		        break;
		    default :
		    	$this->load->view('restricted',$this->data);
		    return;
		}

		$this->load->model('reclamo_m');

		$reporte_global = $this->reclamo_m->get_reporte_global();
		$reporte_gl_sec = $this->reclamo_m->reporte_gl_sec();
		$reporte_gl_of = $this->reclamo_m->reporte_gl_of();

		$new_data['reporte_global'] = $reporte_global;
		
		//$new_data['reporte_secretaria'] = $reporte_gl_sec;
		//$new_data['reporte_oficina'] = $reporte_gl_of;


		$reportesSecretaria = array();
		//armos el array con clave con el id de la secretaria
		foreach ($reporte_gl_sec as $sec_value) {
			$reportesSecretaria[$sec_value['id_secretaria']] = array();
		}
		//le meto un array por cada secretaria
		foreach ($reporte_gl_sec as $sec_value) {
			array_push($reportesSecretaria[$sec_value['id_secretaria']], $sec_value);
		}

		$reportesOficinas = array();
		//armos el array con clave con el id de la secretaria
		foreach ($reporte_gl_of as $of_value) {
			$reportesOficinas[$of_value['id_padre']] = array();
		}
		//le meto un array por cada secretaria
		foreach ($reporte_gl_of as $of_value) {
			array_push($reportesOficinas[$of_value['id_padre']], $of_value);
		}

		$new_data['reporte_secretaria'] = $reportesSecretaria;
		$new_data['reporte_oficina'] = $reportesOficinas;

		$this->load->view('reportes_semanal_pSectores', $new_data);
		$this->load->view('footer',$this->data);

	}

	function show_reportes_Reclamos() {  

		switch ($this->session->userdata('perfil_level')){
		    case 0:
		        break;
		    case 4: 
		        break;            
		    case 5: 
		        break;
		    default :
		    	$this->load->view('restricted',$this->data);
		    return;
		}

		echo 'Super Hola show_reportes_Reclamos';

		$this->load->view('reportes_semanal_Reclamos',$this->data);
		$this->load->view('footer',$this->data);
	}

	/*
	function armarReportes($sec,$of){
		$reportesArmados = array();

		foreach ($sec as $sec_value) {
			$reportesArmados[$sec_value['id_secretaria']] = array();
		}

		foreach ($sec as $sec_value) {
			
			array_push($reportesArmados[$sec_value['id_secretaria']], $sec_value);
			
			//$reportesArmados[$sec_value['id_secretaria']] = array();
			
			foreach ($of as $of_value){
				
			}

			//array_push($reportesArmados, $sec, $of);
		}

		//print_r($reportesArmados);

		return $reportesArmados;
	}
*/



}