<?php $this->load->view('header') ?>

  <div class="navbar">
    <div class="navbar-inner">
      <div class="container-fluid">
        <a class="brand" href="#" name="top">Bienvenido <?php echo $name; ?> perfil: <?php echo $perfil;?></a>
          <ul class="nav">
            <li><a href="show_main"><i class="icon-home"></i> Home - Reclamos</a></li>
            <li><a href="show_vecinos"><i class="icon-th-list"></i> Vecinos</a></li>
            <li class="divider-vertical"></li>
          </ul>
          <div class="btn-group pull-right">
              <a class="btn" href="<?php echo base_url() ?>index.php/login/logout_user"><i class="icon-share"></i> Logout</a>
            
          </div>
      </div>
      <!--/.container-fluid -->
    </div>
    <!--/.navbar-inner -->
  </div>
  <!--/.navbar -->

<!-- 

</div>
-->
