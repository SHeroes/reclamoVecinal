<?php $this->load->view('tramites/tr_header_vecino'); ?>
  <div class="navbar navbar-default">
    <div class="navbar-inner">
      <div class="container-fluid">
        <div class="navbar-header">
          <div class="collapse navbar-collapse">
                <a class="navbar-brand" id="head_user_info"  href="#" name="top">
                  Bienvenido 
                </a>
                <ul class="nav navbar-nav">
                  <li class="tomar_reclamos">
                    <a href="show_main"><i class="glyphicon glyphicon-home"></i>Ver Trámites Asignados a la Oficina </a>
                    </li>
  
                  <li>
                    <a class="btn" href="javascript:change_password();"><i class="glyphicon glyphicon-user"></i>Cambiar Contraseña</a>
                  </li>
                  <li>
                    <a class="btn" href="<?php echo base_url() ?>index.php/login/logout_user"><i class="glyphicon glyphicon-share"></i>Logout</a>          
                  </li>
                </ul>
          </div>
        </div>
        <!--/.navbar-header -->
      </div>
      <!--/.container-fluid -->
    </div>
    <!--/.navbar-inner -->
  </div>
  <!--/.navbar -->
  <?php $this->load->view('change_pass'); ?>