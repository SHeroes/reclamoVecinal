<?php $this->load->view('header'); ?>
  <div class="navbar navbar-default">
    <div class="navbar-inner">
      <div class="container-fluid">
        <div class="navbar-header">

          <div class="collapse navbar-collapse">
                <a class="navbar-brand" href="#" name="top">
                  Bienvenido <?php echo $name; ?> perfil: <?php echo $perfil;?>
                </a>
                <ul class="nav navbar-nav">
                  <li class="tomar_reclamos">
                    <a href="show_main"><i class="glyphicon glyphicon-home"></i> Tomar reclamos </a>
                    </li>
                  <li class="vecinos">
                    <a href="show_vecinos"><i class="glyphicon glyphicon-th-list"></i> Vecinos </a>
                  </li>
                  <!-- <li class="domicilios">
                    <a href="show_domicilios"><i class="glyphicon glyphicon-th-list"></i> Domicilios </a>
                  </li> -->
                  <li class="domicilios">
                    <a href="show_reclamos_table"><i class="glyphicon glyphicon-th-list"></i> Ver reclamos ( en construccion ) </a>
                  </li>
                  <li>
                    <div class="btn-group pull-right">
                        <a class="btn" href="<?php echo base_url() ?>index.php/login/logout_user"><i class="glyphicon glyphicon-share"></i> Logout</a>          
                    </div>
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