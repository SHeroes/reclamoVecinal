    <div class="container">
      <h1> Secretarías Existentes</h1>
      <?php 
        echo '<table class="table"><thead class="thead-inverse">        <tr>
          <th>#id</th><th>Secretaria</th><th>Id Secretario</th>        </tr>        </thead><tbody>';
        foreach( $data_array as $secretaria){
          echo  '<tr><th scope="row">'. $secretaria->id_secretaria .'</th>'.
                '<td>'.$secretaria->nombre.'</td>'.
                '<td>'.$secretaria->id_secretario.'</td>';
        }
        echo '  </tbody></table>';
      ?>
        </br>
        <h3>Crear Secretaria Nueva</h2>
        <div class="row-no-margin">
          <p><input type="text" class="span4" name="secretaria" id="secretaria" placeholder="Nombre Secretaria"></p>
          <p><input type="text" class="span4" name="id_secretario" id="id_secretario" placeholder="Id Secretario"></p>
        </div>
        <div class="modal-footer">
          <a href="#" id="btnSubmitSecretary" class="btn btn-primary">Create</a>
        </div>
    </div>