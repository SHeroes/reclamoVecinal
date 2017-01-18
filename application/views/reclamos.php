<?php echo '<script src="'. base_url() .'assets/js/show_reclamos_crear.js"></script>'; ?>
<div class="container">
<h1>Tomar Reclamo</h1>
  <h3>Filtrar por Secretaría y Oficina:</h3>
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
  <p><input type="submit" class="span4" value="Mostrar Tipo Reclamos"></p>
  </form>



  <input hidden type="text" class="span4" name="tipo_reclamo" value="" id="tipo_reclamo">
    
  
  <?php 
   
    if(isset($tipo_reclamos_filtrados)){
      echo '<table class="table"><thead class="thead-inverse">        <tr>
      <th>Titulo</th><th>Descripcion</th><th>Tiempo respuesta hs</th><th>Dependencia</th></tr>        </thead><tbody>';
       foreach( $tipo_reclamos_filtrados as $reclamo){
        echo  '<tr><th scope="row" class="tipo_reclamo_row btn btn-primary" value="'. $reclamo->id_tipo_reclamo.'">'. $reclamo->titulo .'</th>'.
              '<td>'.$reclamo->descripcion.'</td>'.
              '<td>'.$reclamo->tiempo_respuesta_hs.'</td>'.
              '<td>'.$reclamo->denominacion.'</td>';
      }    
      echo '  </tbody></table>'; 
    }

    

    
 ?>
  </br>
    

<?php /*
    Domicilio del Reclamo: Calle _____________________ Altura: _________________________
Columna: _________________________________ “este dato se pide si se refiere a una luminaria”
Días y horarios en que puede ser molestado Dias:_________________  Horario:_____________
A                  :Teléfono Fijo SI/NO                 :Teléfono Móvil SI/NO              : Domicilio: SI/NO
Se debe poder seleccionar más de una opción.

Comentarios: adicionales:___________________________________
*/ ?>
  <div class="col-sm-6" id="domicilio-reclamo-data">
  <h3>Domicilio de Reclamo</h3>
    <form action="" method="POST">
      <p><select type="text" class="span4" name="id_domicilio" id="id_domicilio" placeholder="id_domicilio">
        <option value="">Si el domicilio de Reclamo ya existe... Elegirlo</option>
          <?php foreach( $all_domicilios_reclamo as $domicilio_rec){
          echo  '<option value="'. $domicilio_rec->id_domicilio .'">'. $domicilio_rec->calle .'  ' .  $domicilio_rec->altura . '</option>';
          }?>
          </select>
      </p>

      <p><input type="text" class="span4 calle" name="calle" id="calle" placeholder="calle" autocomplete="off" required>
          <input type="text" hidden class="hidden_id" name="calle_id" value="">
      </p>
      <div class="calle input-search-result" ></div>
      

      <p><input type="text" class="span4 required" name="altura" id="altura" placeholder="altura" required></p>
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
      <p><textarea type="text" class="span4" name="molestar_dia_hs" id="molestar_dia_hs" placeholder="" >Días y horarios en que puede ser molestado </p>
      <p><input type="checkbox" name="molestar_al_tel_fijo" value="false">molestar_al_tel_fijo</p>
      <p><input type="checkbox" name="molestar_al_tel_mov" value="false">molestar_al_tel_mov</p>
      <p><input type="checkbox" name="molestar_al_domicilio" value="false">molestar_al_domicilio</p>
      <p><textarea type="text" name="comentarios" placeholder="comentarios"></p>

    </form>
    <p><a><input type="submit" class="btn btn-primary" value="Registrar"></a></p>

  </div>
</div>

<style>
#domicilio-reclamo-data{
 display: none; 
}
.input-search-result{
  cursor: pointer;
  display: none;
}

</style>