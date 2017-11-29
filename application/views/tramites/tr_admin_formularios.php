<?php //echo '<script src="'. base_url() .'assets/js/show_reclamos_crear.js"></script>'; ?>
<div class="container-fluid">
<h1>Creación de Pasos para Los Trámites</h1>

  <div class="col-sm-12">

    <div class="col-sm-4">
        formularios
    </div> 
    <div id="columna-pasos-hechos" class="col-sm-8">
      <?php 
      echo '<h3>Pasos actuales los ultimo 10 creados recientemente</h3>';
      //print_r($array_pasos);
      $max = sizeof($array_pasos);
      if($max > 10){$max = 10;}
      for($i=0;$i<$max;$i++){
        ?><div class="col-sm-12 header">
            <div class="col-sm-4"><?php echo $array_pasos[$i]->titulo; ?></div>
            <div class="col-sm-8"><?php echo $array_pasos[$i]->desc; ?></div>
          </div><?php
          $json = $array_pasos[$i]->check_list_json;   //var_dump(json_decode($json, true));
          $checkListArray = json_decode($json, true);          //print_r($checkListArray['checklist']); 
          foreach ($checkListArray['checklist'] as $key => $value) {
            echo '<div class="col-sm-12 ck-list">'.$value.'</div>';
          }
      }
      ?>
    </div>
  </div>
<link rel="stylesheet" href="<?php echo base_url();?>assets/js/vendor/jquery-ui/jquery-ui.css">
<script src="<?php echo base_url();?>assets/js/vendor/jquery-ui/jquery-ui.js"></script>



<script>
$(document).ready(function() {
});



</script>