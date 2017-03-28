<?php
  
   class Upload extends CI_Controller {
	
      public function __construct() { 
         parent::__construct(); 
         $this->load->helper(array('form', 'url')); 
      }
		
      public function index() { 
         $this->load->view('upload_form', array('error' => ' ' )); 
         //print_r($this->input->get('id-rec'));
      } 
		
      public function do_upload() { 
         $config['upload_path']   = './uploads/'; 
         /* $config['allowed_types'] = 'gif|jpg|png|jpeg';
         $config['max_size']      = 100; 
         $config['max_width']     = 1024; 
         $config['max_height']    = 768;  
         */
         $config['allowed_types'] = '*';
         $config['max_size']      = 10000; 
         $config['max_width']     = 2048; 
         $config['max_height']    = 1336;  

         $this->load->library('upload', $config);
			//$this->load->library('upload', $config);
         //$this->upload->initialize($config);
         if ( ! $this->upload->do_upload('userfile')) {
            $error = array('error' => $this->upload->display_errors()); 
            $this->load->view('upload_form', $error); 
         }
			
         else { 
            $data = array('upload_data' => $this->upload->data()); 
            $this->load->view('upload_success', $data);



            //TODO cargar en la base de datos el la url de la imagen con el id del reclamo relacionado

         } 
      } 
   } 
?>