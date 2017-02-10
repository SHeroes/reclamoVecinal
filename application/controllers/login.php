<?php

class Login extends CI_Controller {

    function index() {
        if( $this->session->userdata('isLoggedIn') ) {
           switch ($this->session->userdata('perfil_level')){
                case 0:
                redirect('/main_admin/show_main');
                break;
                case 2:
                redirect('/main_office/show_main');
                break;
                case 3:
                redirect('/main_operator/show_main');
                break;
                default:
                $this->load->view('restricted',$data);
                break;
            }  
        } else {
            $this->show_login(false);
        }
    }

    function login_user() {
        // Create an instance of the user model
        $this->load->model('user_m');

        // Grab the email and password from the form POST
        $email = $this->input->post('email');
        $pass  = $this->input->post('password');

        //Ensure values exist for email and pass, and validate the user's credentials
        if( $email && $pass && $this->user_m->validate_user($email,$pass)) {
            // If the user is valid, redirect to the main view
            
            redirect('/main_admin/show_main');

        } else {
            // Otherwise show the login screen with an error message.
            $this->show_login(true);
        }
    }

    function show_login( $show_error = false ) {
        $data['error'] = $show_error;

        $this->load->helper('form');
        $this->load->view('login',$data);
    }

    function logout_user() {
      $this->session->sess_destroy();
      $this->index();
    }

    function showphpinfo() {
        echo phpinfo();
    }


}
