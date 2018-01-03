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
      //$this->load->view('tramites/show_tr_vecino',$new_data);
      $this->load->view('tramites/tr_footer_base',$this->data);
    }
  }

/*
  public function select_Vecino(){
    $this->load->view('tramites/tr_vecino_main',$this->data);
    print_r("aca se debe mostrar la lista de seleccino de vecino por DNI");
    
    $this->load->model('vecino_m');


    $this->load->view('tramites/tr_vecino_show',$new_data);
    $this->load->view('tramites/tr_footer_base',$this->data);    
  }
*/

  function select_Vecino(){
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

    $this->load->view('tramites/tr_vecino_main',$this->data);
    $this->load->view('tramites/vecinos',$new_data);
    $this->load->view('tramites/tr_footer_base',$this->data);
  }

  function show_main() {

    $this->load->model('sector_m');
    $this->load->model('domicilio_m');
    $this->load->model('vecino_m');

    $new_data['vecinos_filtrados'] = '';
  
    $new_data['id_vecino'] = '';
    $new_data['name_vecino'] = '';

    //si se post algo como filtro lo uso, sino no muestro ninguno
    $post = $this->input->post(null,true);
    $get = $this->input->get(null,true);
    if( count($post) or count($get) ) {

      if (isset($post['id_vecino']) or isset($get['id_vecino'])){
          if (isset($post['id_vecino'])){
                  $new_data['id_vecino'] = $post['id_vecino'];
                  $new_data['name_vecino'] = $post['name_vecino'];
          } else{
                  $new_data['id_vecino'] = $get['id_vecino'];
                  $new_data['name_vecino'] = $get['name_vecino'];
          }

      } else { //NO HAY FILTRADOS TODAVIA, posiblemente un acceso mal por url
          redirect('tramites/Main_tr_vecino/select_Vecino');
      }

    } else { //NO HAY FILTRADOS TODAVIA
      redirect('tramites/Main_tr_vecino/select_Vecino');
    }

    $this->load->view('tramites/tr_vecino_main',$this->data);
    $this->load->view('tramites/tr_vecino_chose_tramite',$new_data);
    $this->load->view('tramites/tr_footer_base',$this->data);

  }


  function insert_vecino() {
    echo '<script src="'. base_url() .'assets/js/vendor/jquery-1.9.0.min.js"></script>';
    $info = $this->input->post(null,true);
    if( count($info) ) {
      $this->load->model('vecino_m');
      $saved = $this->vecino_m->create_vecino($info);
    }
    if ( isset($saved) && $saved ) {
       echo "vecino agregado exitosamente";
       $vecino_info = $this->vecino_m->get_vecino_info($saved);
       //print_r($vecino_info);
       
       $name_vecino = 'name_vecino';
       $name_vecino = $vecino_info['Apellido'] . ", " . $vecino_info['Nombre'];

        echo '<form id="form-id-vecino-creado" action="/index.php/tramites/Main_tr_vecino/show_main" method="POST" >
        <p><input hidden  type="text" class="span4 id_vecino" name="id_vecino" value="'. $saved .'" id=""></p>
    <p><input hidden  type="text" class="span4 name_vecino" name="name_vecino" value="'. $name_vecino .'" id=""></p>
        </form>
        <script>
        $(document).ready(function(){
          $("form#form-id-vecino-creado").submit(function(){
              alert("Se ha Registrado al Vecino:'. $name_vecino .'correctamente, Se procede a la toma del reclamo");
          });
          $("form#form-id-vecino-creado").submit();
        });
        </script>';

       //redirect('main_operator/show_main');
        //http://cav.gob/index.php/Main_tr_vecino/show_main
    }
  }

}