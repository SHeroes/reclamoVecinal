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
        </div>
    </form>
  </div>