<?php
class Blog extends CI_Controller {

        public function index()
        {
                echo 'Hello World!';

                $this->load->view('blogview.php');
        }
}