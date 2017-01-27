<?php echo '<script src="'. base_url() .'assets/js/show_reclamos_crear.js"></script>'; ?>
<div class="container">
<h1>Tomar Reclamo</h1>
  <?php if ($id_vecino != '') echo '<div class="buscar_vecinos" style="display:none;">'; else echo '<div class="buscar_vecinos">'; ?>
  <h1> Buscar Vecinos Registrados según:</h1>
  <form action="show_main" id="vecinos-dni-form" method="POST" >
  <p><input type="text" class="span4" name="DNI_filter" id="DNI_filter" placeholder="DNI a buscar..." ></p>
  <p><input type="submit" class="span4" value="Buscar"></p>
  </form>
  <form action="show_main" method="POST" >
  <p><input type="text" class="span4" name="Apellido_filter" id="Apellido_filter" placeholder="Apellido a buscar..." ></p>
  <p><input type="submit" class="span4" value="Buscar"></p>
  </form>
  <?php echo '</div>'; ?>
  <?php if($vecinos_filtrados != '') {
    echo '<h1> Vecinos Filtrados</h1>';
    echo '<table class="table"><thead class="thead-inverse">        <tr>
    <th>DNI</th><th>Apellido</th><th>Nombre</th><th>Domicilio</th><th>mail</th><th>otros</th>       </tr>        </thead><tbody>';
    foreach( $vecinos_filtrados as $vecino){
      echo  '<tr class="vecinos_filtrados"><th scope="row" id-value="'.$vecino->id_vecino .'">'. $vecino->DNI.'</th>'.
            '<td>'.$vecino->Apellido.'</td>'.
            '<td>'.$vecino->Nombre.'</td>'.
            '<td>'.$vecino->calle . $vecino->altura.'</td>'.
            '<td>'.$vecino->mail.'</td>';
    }
    echo '  </tbody></table>';
  }else {
    if ($id_vecino == '')  echo '<h2>No se ha seleccionado vecino</h2>';
     else echo "El vecino seleccionado es:  " . $name_vecino;
  }?>
  <br></br>

  <div class="filtro-secretaria" <?php if ($id_vecino == '')  echo 'style="display:none;"';  ?> >
    <h3>Para elegir el tipo de reclamo primero filtre por Secretaría y Oficina:</h3>
    <form action="#oficina_filter" method="POST" >
    <p><select type="text" class="span4" name="secretaria_filter" id="secretaria_filter">
        <option value="">Todas las Secretaria</option>
        <?php foreach( $secretarias as $secretaria){
          echo  '<option value="'.$secretaria->id_sector.'"';
          if (isset($secretaria_selected) and $secretaria_selected == $secretaria->id_sector ){
            echo 'selected';
          }
          echo '>'. $secretaria->denominacion.'</option>';
        }?>
    </select></p>
    <p><input hidden  type="text" class="span4 id_vecino" name="id_vecino" value="<?php echo $id_vecino; ?>" id=""></p>
    <p><input hidden  type="text" class="span4 name_vecino" name="name_vecino" value="<?php echo $name_vecino; ?>" id=""></p>     
    <p><input type="submit" class="span4" value="Filtrar Oficinas"></p>
    </form>

    <form action="#oficina_filter" method="POST" >
    <p><select type="text" class="span4" name="oficina_filter" id="oficina_filter">
        
          <?php 
          //print_r($oficinas_filtradas);
          if (isset($oficinas_filtradas)){
            echo '<option value="">Todas las Oficinas</option>';
            foreach( $oficinas_filtradas as $oficina){
              echo  '<option value="'.$oficina->id_sector.'">'. $oficina->denominacion.'</option>';
            }  
          } else {
            echo '<option value="">Todas las Oficinas</option>';
            foreach( $oficinas as $oficina){
              echo  '<option value="'.$oficina->id_sector.'">'. $oficina->denominacion.'</option>';
            }  
          }
         ?>
     </select></p>
    <p><input hidden  type="text" class="span4 id_vecino" name="id_vecino" value="<?php echo $id_vecino; ?>" id=""></p>
    <p><input hidden  type="text" class="span4 name_vecino" name="name_vecino" value="<?php echo $name_vecino; ?>" id=""></p>      
    <p><input type="submit" class="span4" value="Mostrar Tipo Reclamos"></p>
    </form>



    <?php if(isset($tipo_reclamos_filtrados)){
        echo '<table class="table"><thead class="thead-inverse">        <tr>
        <th>Titulo</th><th>Descripcion</th><th>Tiempo respuesta hs</th><th>Dependencia</th></tr>        </thead><tbody>';
         foreach( $tipo_reclamos_filtrados as $reclamo){
          echo  '<tr><th scope="row" class="tipo_reclamo_row btn btn-primary" value="'. $reclamo->id_tipo_reclamo.'">'. $reclamo->titulo .'</th>'.
                '<td>'.$reclamo->descripcion.'</td>'.
                '<td>'.$reclamo->tiempo_respuesta_hs.'</td>'.
                '<td>'.$reclamo->denominacion.'</td>';
        }    
        echo '  </tbody></table>'; 
      } ?>
  </div>

  <form class="reclamo-form" action="insert_reclamo/" method="POST">
    <div class="col-sm-6" id="domicilio-reclamo-data">
      <h3>Domicilio de Reclamo</h3>
      <p><select type="text" class="span4" name="id_domicilio" id="id_domicilio" placeholder="id_domicilio">
        <option value="">Si el domicilio de Reclamo ya existe... Elegirlo</option>
          <?php foreach( $all_domicilios_reclamo as $domicilio_rec){
          echo  '<option value="'. $domicilio_rec->id_domicilio .'">'. $domicilio_rec->calle .' Desde:  ' .  $domicilio_rec->altura_inicio .' Hasta: ' .  $domicilio_rec->altura_fin . '</option>';
          }?>
          </select>
      </p>



      <p><input type="text" class="span4 calle required" name="calle" id="calle" placeholder="calle" autocomplete="off" required>
          <input type="text" hidden class="hidden_id" name="calle_id" value="">
      </p>
      <div class="calle input-search-result" ></div>
      

      <p><input type="text" class="span4 required" name="altura_inicio" id="altura_inicio" placeholder="altura_inicio" required></p>
      <p><input type="text" class="span4 required" name="altura_fin" id="altura_fin" placeholder="altura_fin" required></p>
      <p><input type="text" class="span4 calle required" name="entrecalle1" id="entrecalle1" placeholder="entrecalle1" autocomplete="off" required>
          <input type="text" hidden class="hidden_id" name="entrecalle1_id" value="">
      </p>
      <div class="calle input-search-result" ></div>
      
      <p><input type="text" class="span4 calle required" name="entrecalle2" id="entrecalle2" placeholder="entrecalle2" autocomplete="off" required>
         <input type="text" hidden class="hidden_id" name="entrecalle2_id" value="">
      </p>
      <div class="calle input-search-result"></div>

      <p><select type="text" class="span4 required" name="id_barrio" id="id_barrio" placeholder="id_barrio" autocomplete="off" required>
        <?php
        foreach( $all_barrios as $barrio){
        echo  '<option value="'. $barrio->id_barrio .'">'. $barrio->barrio. '</option>';
        }
        
        ?>
        </select></p>
      <p><input type="text" class="span4" name="columna_electrica" id="columna_electrica" placeholder="columna" >“este dato se pide si se refiere a una luminaria”</p>
    </div>
    <div class="col-sm-6" id="reclamo-data">
      <h3>Datos para Reclamo</h3>
      Vecino que realiza el Reclamo:   <?php echo $name_vecino; ?>
      <?php
      /* if(isset($vecinos[0])) {
        echo '<p><select name="id_vecino">';
        echo '<h1>Seleccionar Vecino</h1>';
            foreach( $vecinos as $vecino){
              echo  '<option value="'.$vecino->id_vecino.'">DNI: '.$vecino->DNI.'  '.$vecino->Apellido.' '.$vecino->Nombre.'</option>';
            }
        echo '</select></p>';
      }
      */ ?>
      <p><input hidden  type="text" class="span4 id_vecino" name="id_vecino" value="<?php echo $id_vecino; ?>" id=""></p>
      <p><input hidden  type="text" class="span4 name_vecino" name="name_vecino" value="<?php echo $name_vecino; ?>" id=""></p>
      <p><textarea rows="2" cols="50" type="text" class="span4" name="molestar_dia_hs" id="molestar_dia_hs" placeholder="Días y horarios en que puede ser molestado " ></textarea></p>
      <p><input type="checkbox" name="molestar_al_tel_fijo" value="true" >Se lo puede molestar al tel. fijo</p>
      <p><input type="checkbox" name="molestar_al_tel_mov" value="true" >Se lo puede molestar al tel. movil</p>
      <p><input type="checkbox" name="molestar_al_dom" value="true" >Se lo puede molestar al domicilio</p>
      <p><textarea rows="6" cols="50" type="text" name="comentarios" placeholder="comentarios"></textarea></p>

      <input hidden type="text" class="span4" name="id_tipo_reclamo" value="" id="tipo_reclamo">

      <input hidden type="text" class="span4" name="id_operador" id="id_operador" value="<?php echo $id_actual_user; ?>" >
      
      <!-- <input hidden type="text" class="span4" name="" id="" > -->

      <p><a><input type="submit" class="btn btn-primary" value="Registrar Reclamo"></a></p>
    </div>

  </form>






</div>

<style>
.reclamo-form{
 display: none; 
}
.input-search-result{
  cursor: pointer;
  display: none;
}

</style>