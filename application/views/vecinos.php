
<div class="container">
  <h1> Buscar Vecinos Registrados según:</h1>
  <form action="show_vecinos" method="POST" >
  <p><input type="text" class="span4" name="DNI_filter" id="DNI_filter" placeholder="DNI a buscar..." ></p>
  <p><input type="submit" class="span4" value="Buscar"></p>
  </form>
  <form action="show_vecinos" method="POST" >
  <p><input type="text" class="span4" name="Apellido_filter" id="Apellido_filter" placeholder="Apellido a buscar..." ></p>
  <p><input type="submit" class="span4" value="Buscar"></p>
  </form>
  <?php if(isset($vecinos_filtrados[0])) {
    echo '<h1> Vecinos Seleccionado</h1>';
    echo '<table class="table"><thead class="thead-inverse">        <tr>
    <th>DNI</th><th>Apellido</th><th>Nombre</th><th>Domicilio</th><th>mail</th><th>otros</th>       </tr>        </thead><tbody>';
    foreach( $vecinos_filtrados as $vecino){
      echo  '<tr><th scope="row">'. $vecino->DNI.'</th>'.
            '<td>'.$vecino->Apellido.'</td>'.
            '<td>'.$vecino->Nombre.'</td>'.
            '<td>'.$vecino->calle . $vecino->altura.'</td>'.
            '<td>'.$vecino->mail.'</td>';
    }
    echo '  </tbody></table>';
  }else {
    echo '<h2>No se han encontrado vecinos seleccionados</h2>';
  }?>
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
      <div class="col-sm-6 domicilio-data">
      <h4> Datos del Domicilio </h4>
      <p><select type="text" class="span4" name="id_domicilio" id="id_domicilio" placeholder="id_domicilio">
        <option value="">si el domicilio ya existe seleccionarlo</option>
          <?php foreach( $all_domicilios as $domicilio){
          echo  '<option value="'. $domicilio->id_domicilio .'">'. $domicilio->calle .'  ' .  $domicilio->altura . '</option>';
          }?>
          </select>
      </p>
       si el domicilio ya existe seleccionarlo. Ej: un pariente del mismo domicilio ya se encuentra registrado 

      <p><input type="text" class="span4 calle" name="calle" id="calle" placeholder="calle" autocomplete="off" required>
          <input type="text" hidden class="hidden_id" name="calle_id" value="">
      </p>
      <div class="calle input-search-result"></div>
      

      <p><input type="text" class="span4 required" name="altura" id="altura" placeholder="altura" required></p>
      <p><input type="text" class="span4 calle required" name="entrecalle1" id="entrecalle1" autocomplete="off" placeholder="entrecalle1" required>
          <input type="text" hidden class="hidden_id" name="entrecalle1_id" value="">
      </p>
      <div class="calle input-search-result" ></div>
      
      <p><input type="text" class="span4 calle required" name="entrecalle2" id="entrecalle2" placeholder="entrecalle2" autocomplete="off" required>
         <input type="text" hidden class="hidden_id" name="entrecalle2_id" value="">
      </p>
      <div class="calle input-search-result" ></div>

      <p><select type="text" class="span4 required" name="id_barrio" id="id_barrio" placeholder="id_barrio" autocomplete="off" required></p>
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

<?php echo '<script src="'. base_url() .'assets/js/plugin/json2.js"></script>'; ?>
<?php echo '<script src="'. base_url() .'assets/js/show_vecinos.js"></script>'; ?>

<style>
.input-search-result{
  cursor: pointer;
  display: none;
}

</style>