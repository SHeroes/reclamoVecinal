<?php //echo '<script src="'. base_url() .'assets/js/show_reclamos_crear.js"></script>'; ?>
<div class="container-fluid">
<h1>Trámites correspondientes a: </h1>
  <div class="col-sm-12">
    <form action="#" id="state_filter" method="POST" >
        <div class="col-sm-3">
          <p><input type="text" name="apellido" class="input-form form-control" placeholder="Apellido..."></p>
          <p><input type="int" name="dni" class="input-form form-control" placeholder="DNI..."></p>
          <p><input type="text" name="nro_tramite" class="input-form form-control" placeholder="Nº Tramite"></p>
        </div>
        <div class="col-sm-3">
          <p><input type="text" placeholder="desde:" class="input-fecha desde form-control" name="desde" id="datepicker" size="15"></p>
          <p><input type="text" placeholder="hasta:" class="input-fecha hasta form-control" name="hasta" id="datepicker2" size="15"></p>  
          <input type="submit" class="span4 btn" value="Filtrar">
          <p></p> 
        </div>        

        <div class="col-sm-6">
          <p><select type="text" class="span4 form-control" name="status_filter_selector" id="status_filter_selector" style="margin-right: 30px;">
              <?php 
              foreach ($array as $key => $value) {
                echo '<option value="'.$value.'">Paso Nro: '.$value. '</option>';             
              }
              ?>
          </select></p>
        </div>
    </form>


    <?php 
  
      echo $tramites_list;

      /*
              echo '<table class="table"><thead class="thead-inverse">        <tr id="header-table">
          <th>email</th><th>Nombre</th><th>Apellido</th><th>Nivel de Acceso</th>
          </tr></thead><tbody>';
        foreach( $all_users as $usuario){
          echo  '<tr><th scope="row">'. $usuario->email .'</th>'.
                '<td>'.$usuario->nombre.'</td>'.
                '<td>'.$usuario->apellido.'</td>'.
                '<td>'.$usuario->perfil_level.'</td>';
        }
        echo '  </tbody></table>';
        */
    ?>
  </div>

</div>


 
<link rel="stylesheet" href="<?php echo base_url();?>assets/js/vendor/jquery-ui/jquery-ui.css">
<script src="<?php echo base_url();?>assets/js/vendor/jquery-ui/jquery-ui.js"></script>
<?php echo '<script src="'. base_url() .'assets/js/show_calendar.js"></script>'; ?> 


<?php echo '<script src="'. base_url() .'assets/js/header-table.js"></script>'; ?> 
