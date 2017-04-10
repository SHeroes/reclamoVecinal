<?php $this->load->view('header'); ?>
  <div class="navbar navbar-default">
    <div class="navbar-inner">
      <div class="container-fluid">
        <div class="navbar-header">

          <div class="collapse navbar-collapse">
                <a class="navbar-brand" id="head_user_info" pass-sha1="<?php echo $my_sha1_pass; ?>" id-user="<?php echo $my_id_user; ?>" href="#" name="top">
                  Bienvenido <?php echo $name; ?><div style="display: none"> perfil: <?php echo $perfil;?></div>
                </a>
                <ul class="nav navbar-nav">
                  <li class="">
                    <a href="show_main"><i class="glyphicon glyphicon-print"></i>Rec. No Vistos </a>
                    </li>
                  <li class="">
                    <a href="show_no_contact"><i class="glyphicon glyphicon-print"></i>Rec. No Contactados </a>
                  </li>
                  <li class="">
                    <a href="show_verificados"><i class="glyphicon glyphicon-print"></i>Rec. Verificados</a>
                  </li>                  
                  <li class="">
                    <a href="show_contactados"><i class="glyphicon glyphicon-phone-alt"></i>Revisión de Reclamos</a>
                  </li>
                  <li>
                    <a class="btn" href="javascript:change_password();"><i class="glyphicon glyphicon-user"></i>Cambiar Contraseña</a>
                  </li>
                  <li>
                    <a class="btn" href="<?php echo base_url() ?>index.php/login/logout_user"><i class="glyphicon glyphicon-share"></i> Logout</a>          
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