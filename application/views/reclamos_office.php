<?php //echo '<script src="'. base_url() .'assets/js/show_reclamos_crear.js"></script>'; ?>
<div class="container">
<h1>Reclamos correspondientes a: <?php echo $this->session->sector_name; ?></h1>

  <div class="col-md-12">
    <?php 
    // Array ( [0] => Array ( [id_vecino] => 6 [codigo_reclamo] => 0010001/2017 [fecha_alta_reclamo] => 2017-02-08 22:24:38 [barrio] => DON CONRADO [calle] => San Juan [altura] => 1234 [titulo] => Presencia Policial [tiempo_respuesta_hs] => 48 [domicilio_restringido] => 0 ) )
    if(count($reclamos_list) > 0){
      echo '<table class="table"><thead class="thead-inverse">        <tr>
      <th>codigo_reclamo</th><th>fecha_alta_reclamo</th><th>barrio</th><th>calle</th><th>altura</th><th>titulo</th><th>Tiempo respuesta hs</th></tr>        </thead><tbody>';
      foreach ($reclamos_list as $rec) {
        echo  '<tr class="reclamo_row"><th scope="row" class="" value="'. $rec['id_vecino'].'">'. $rec['codigo_reclamo'] .'</th>'.
                '<td>'.$rec['fecha_alta_reclamo'].'</td>'.
                '<td>'.$rec['barrio'].'</td>'.
                '<td>'.$rec['calle'].'</td>'.
                '<td>'.$rec['altura'].'</td>'.
                '<td>'.$rec['titulo'].'</td>'.
                '<td>'.$rec['tiempo_respuesta_hs'].'</td>'.
                '<td>'.$rec['domicilio_restringido'].'</td>';
        }    
        echo '  </tbody></table>'; 
    }

    ?>
  </div>

</div>

<style>
.reclamo-form{
 display: none; 
}
.input-search-result{
  cursor: pointer;
  display: none;
}
tr.reclamo_row{
  cursor: pointer;
}


</style>