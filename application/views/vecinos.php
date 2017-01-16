<?php //echo '<script src="'. base_url() .'assets/js/show_sectors.js"></script>'; 
    
?>

<div class="container">
  <h1> Vecinos Registrados</h1>
  <?php 
    echo '<table class="table"><thead class="thead-inverse">        <tr>
      <th>#id</th><th>Denominación del Sector</th><th>Tipo Sector</th><th>id Dependencia</th><th>Fecha Creacion</th>       </tr>        </thead><tbody>';
      //print_r($all_domicilios) ;
    
    foreach( $all_domicilios as $domicilio){
      echo  '<tr><th scope="row">'. $domicilio->id_domicilio.'</th>';
           // '<td>'.$sector->denominacion.'</td>'.
           // '<td>'.$sector->tipo.'</td>'.
           // '<td>'.$sector->id_padre.'</td>'.
           // '<td>'.$sector->fecha_creacion.'</td>';
    }
    
    echo '  </tbody></table>';
 ?>
  <br></br>
    
  <div class="col-sm-12" id="new-sector">
  <h3>Registrar Vecino Nuevo</h3>
    <form method="POST" action="insert_vecino/">
      <div class="col-sm-6">
        <h4> Datos del vecino </h4>
        <p><input type="text" class="span4" name="nombre" id="nombre" placeholder="nombre" required></p>
        <p><input type="text" class="span4" name="apellido" id="apellido" placeholder="apellido" required></p>
        <p><input type="text" class="span4" name="dni" id="dni" placeholder="DNI" required></p>
        <p><input type="text" class="span4" name="mail" id="mail" placeholder="mail"></p>
        <p><input type="text" class="span4" name="tel_fijo" id="tel_fijo" placeholder="tel_fijo"></p>
        <p><input type="text" class="span4" name="tel_movil" id="tel_movil" placeholder="tel_movil"></p>
      </div>
      <div class="col-sm-6">
      <h4> Datos del Domicilio </h4>
      <p><select type="text" class="span4" name="id_domicilio" id="id_domicilio" placeholder="id_domicilio">
        <option value="">si el domicilio ya existe seleccionarlo</option>
          <?php foreach( $all_domicilios as $domicilio){
          echo  '<option value="'. $domicilio->id_domicilio .'">'. $domicilio->calle .'  ' .  $domicilio->altura . '</option>';
          }?>
          </select>
      </p>
       si el domicilio ya existe seleccionarlo. Ej: un pariente del mismo domicilio ya se encuentra registrado 

      <p><input type="text" class="span4 calle" name="calle" id="calle" placeholder="calle" required>
          <input type="text" hidden class="hidden_id" name="calle_id" value="">
      </p>
      <div class="calle input-search-result" style="display: none;" ></div>
      

      <p><input type="text" class="span4" name="altura" id="altura" placeholder="altura" required></p>
      <p><input type="text" class="span4 calle" name="entrecalle1" id="entrecalle1" placeholder="entrecalle1" required>
          <input type="text" hidden class="hidden_id" name="entrecalle1_id" value="">
      </p>
      <div class="calle input-search-result" style="display: none;" ></div>
      
      <p><input type="text" class="span4 calle" name="entrecalle2" id="entrecalle2" placeholder="entrecalle2" required>
         <input type="text" hidden class="hidden_id" name="entrecalle2_id" value="">
      </p>
      <div class="calle input-search-result" style="display: none;" ></div>

      <p><select type="text" class="span4" name="id_barrio" id="id_barrio" placeholder="id_barrio" required></p>
        <?php foreach( $all_barrios as $barrio){
        echo  '<option value="'. $barrio->id_barrio .'">'. $barrio->barrio. '</option>';
        }?>
        </select>
      <p><input type="text" class="span4" name="departamento" id="departamento" placeholder="departamento"></p>
      <p><input type="text" class="span4" name="piso" id="piso" placeholder="piso"></p>
      </div>
    <p><a><input type="submit" class="btn btn-primary" value="Registrar"></a></p>
    </form>
  </div>

</div>

<!-- <script type="text/javascript" language="javascript" src="http://www.technicalkeeda.com/js/javascripts/plugin/jquery.js"></script>
-->

<?php echo '<script src="'. base_url() .'assets/js/plugin/json2.js"></script>'; ?>
<?php echo '<script src="'. base_url() .'assets/js/show_vecinos.js"></script>'; ?>

<?php //echo '<script src="'. base_url() .'assets/js/buscador_example_2.js"></script>'; ?>
