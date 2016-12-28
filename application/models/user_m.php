<?php


class user_m extends CI_Model {

    var $details;

    function validate_user( $email, $password ) {
        // Build a query to retrieve the user's details
        // based on the received username and password
        $this->db->from('user');
        $this->db->where('email',$email );
        $this->db->where( 'password', sha1($password) );
        $login = $this->db->get()->result();

        // The results of the query are stored in $login.
        // If a value exists, then the user account exists and is validated
        if ( is_array($login) && count($login) == 1 ) {
            // Set the users details into the $details property of this class
            $this->details = $login[0];
            // Call set_session to set the user's session vars via CodeIgniter
            $this->set_session();
            return true;
        }

        return false;
    }

    function set_session() {
        // session->set_userdata is a CodeIgniter function that
        // stores data in CodeIgniter's session storage.  Some of the values are built in
        // to CodeIgniter, others are added.  See CodeIgniter's documentation for details.
        $this->session->set_userdata( array(
                'id'=>$this->details->id,
                'perfil_level'=>$this->details->perfil_level,
                'name'=> $this->details->nombre . ' ' . $this->details->apellido,
                'email'=>$this->details->email,
                'password'=>$this->details->password,
                
                'isLoggedIn'=>true
            )
        );


    }

    function  create_new_user( $userData ) {
      $data['perfil_level'] = (int) $userData['perfil_level'];
      $data['apellido'] = $userData['lastName'];
      $data['nombre'] = $userData['firstName'];
      $data['email'] = $userData['email'];
      $data['password'] = sha1($userData['password1']);
      return $this->db->insert('user',$data);
    }

    public function update_tagline( $user_id, $tagline ) {
      $data = array('tagline'=>$tagline);
      $result = $this->db->update('user', $data, array('id'=>$user_id));
      return $result;
    }

    private function getAvatar() {
      $avatar_names = array();

      foreach(glob('assets/img/avatars/*.png') as $avatar_filename){
        $avatar_filename =   str_replace("assets/img/avatars/","",$avatar_filename);
        array_push($avatar_names, str_replace(".png","",$avatar_filename));
      }

      return $avatar_names[array_rand($avatar_names)];
    }
}
