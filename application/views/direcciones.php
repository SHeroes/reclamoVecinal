    <div class="container">
      <h1> Direcciones Existentes</h1>
      <?php 
        echo '<table class="table"><thead class="thead-inverse">        <tr>
          <th>#id</th><th>Direccion</th><th>Id Secretaria Relacionada</th>        </tr>        </thead><tbody>';
        foreach( $data_array as $direccion){
          echo  '<tr><th scope="row">'. $direccion->id_direccion .'</th>'.
                '<td>'.$direccion->nombre.'</td>'.
                '<td>'.$direccion->id_secretaria.'</td>';
        }
        echo '  </tbody></table>';
      ?>
      </br>
        <h3>Crear Direccion Nueva</h2>
      <div class="row-no-margin">
        <p><input type="text" class="span4" name="direccion" id="direccion" placeholder="Nombre Direccion"></p>
        <p><input type="text" class="span4" name="id_sec_rel" id="id_sec_rel" placeholder="Id Secretaria Relacionada"></p>
      </div>
      <div class="modal-footer">
        <a href="#" id="btnSubmitDireccion" class="btn btn-primary">Create</a>
      </div>
    </div>