<?php //echo '<script src="'. base_url() .'assets/js/show_reclamos_crear.js"></script>'; ?>
<div class="container-fluid">

  <div class="col-sm-12">
  <h1>Pasos de Trámites pendientes ordenados por fecha: </h1>

        <div class="col-sm-8">
          <div class="col-sm-6">
            formularios
          </div>
          <div class="col-sm-6">
            chekclit
          </div> 
        </div>        
        <div class="col-sm-4">
          info de los pasos siguientes
        </div>

  <?php
   /*
        echo '<table class="table">
              <thead class="thead-inverse"><tr id="header-table">
                 <th>Tramite ID</th><th>DNI</th><th>Apellido, Nombre</th><th>email</th><th>tel.</th><th>movil</th>
                 <th>Fecha inicio</th><th>Pasos completados</th><th>Paso</th><th>Tratar</th>
              </tr></thead>
              <tbody>';
        foreach( $tramites_list as $tramite_paso){
          echo  '<tr>'.
                '<th scope="row">'. $tramite_paso->tramiteId .'</th>'.
                '<td>'.$tramite_paso->DNI.'</td>'.
                '<td>'.$tramite_paso->Apellido.', '.$tramite_paso->Nombre.'</td>'.
                '<td>'.$tramite_paso->mail.'</td>'.
                '<td>'.$tramite_paso->tel_fijo.'</td>'.
                '<td>'.$tramite_paso->tel_movil.'</td>'.
                '<td>'.$tramite_paso->tr_fecha_tramite.'</td>'.
                '<td>'.$tramite_paso->pasos_completados.' de '.$tramite_paso->pasos_totales_al_incio.'</td>'.
                '<td>'.$tramite_paso->titulo.'</td>'.
                '<td><a href="main_tr_operator/tratar_paso?id_paso='.$tramite_paso->pasoId.'&id_ttr='.$tramite_paso->tr_tipo_tramite_id.'&id_tr='.$tramite_paso->tramiteId.'&num_pasos_tot='.$tramite_paso->pasos_totales_al_incio.'" class="btn btn-primary" >Editar</a></td>'.
                '</tr>'
                ;
        }
        echo '</tbody></table>';
        */
    ?>
  </div>
  <!-- <pre><?php // print_r($tramites_list); ?></pre> -->
</div>


 
<link rel="stylesheet" href="<?php echo base_url();?>assets/js/vendor/jquery-ui/jquery-ui.css">
<script src="<?php echo base_url();?>assets/js/vendor/jquery-ui/jquery-ui.js"></script>
