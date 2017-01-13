    <?php echo '<script src="'. base_url() .'assets/js/show_users.js"></script>'; ?>
  <div class="container">
      <h1> Usuarios Existentes</h1>
      <?php
        echo '<table class="table"><thead class="thead-inverse">        <tr>
          <th>email</th><th>Nombre</th><th>Apellido</th><th>Nivel de Acceso</th>
          </tr></thead><tbody>';
        foreach( $all_users as $usuario){
          echo  '<tr><th scope="row">'. $usuario->email .'</th>'.
                '<td>'.$usuario->nombre.'</td>'.
                '<td>'.$usuario->apellido.'</td>'.
                '<td>'.$usuario->perfil_level.'</td>';
        }
        echo '  </tbody></table>';
     ?>
      </br>
        
      <div class="col-sm-6" id="new-user">

      <h3>Detalles de usuario Nuevo</h3>
    
        <div class="">
            <p><input type="text" class="span4" name="first_name" id="first_name" placeholder="Nombre"></p>
            <p><input type="text" class="span4" name="last_name" id="last_name" placeholder="Apellido"></p>
            <p><input type="text" class="span4" name="email" id="email" placeholder="Email"></p>
            <p>
            <select class="span4" name="miembro_sector" id="miembro_sector">
            <option value="">Sector al que pertenece</option>
                 <?php
                  foreach( $array_sectores as $sector){
                    echo  '<option value="'.$sector->id_sector.'">'. $sector->denominacion.'</option>';
                  }
                  ?>
            </select>
            </p>


            <p>
              <select class="span4" name="teamId" id="teamId">
                <option value="">Perfil</option>
                <option value="1">Secretario</option>
                <option value="2">Usuario Oficina</option>
                <option value="3">Operador</option>
                <option value="4">Intendente</option>
              </select>
            </p>
            <p><input type="password" class="span4" name="password" id="password" placeholder="Password"></p>
            <p><input type="password" class="span4" name="password2" id="password2" placeholder="Confirm Password"></p>
            
        </div>
        <div class="">
          <a href="#" id="btnCreateUser" class="btn btn-primary">Create</a>
        </div>
      </div>
      <div class="col-sm-6" id="mod-user">
      <h3>Modificar Usuario Existente</h3>
    
        <div class="">
            <p><span>Elegir usuario a modficar:</span><p>
            <select class="span4" name="id_user" id="id_user">
             <?php
              foreach( $all_users as $usuario){
                echo  '<option value="'.$usuario->id.'">'. $usuario->email.'</option>';
              }
              ?>
            </select>
            <p><span>Ingresar los datos nuevos:</span><p>
            <p><input type="text" class="span4" name="first_name" id="first_name" placeholder="Nombre"></p>
            <p><input type="text" class="span4" name="last_name" id="last_name" placeholder="Apellido"></p>
            <p><input type="text" class="span4" name="email" id="email" placeholder="Email"></p>
            <p>
            <select class="span4" name="miembro_sector" id="miembro_sector">
            <option value="">Sector nuevo</option>
                 <?php
                  foreach( $array_sectores as $sector){
                    echo  '<option value="'.$sector->id_sector.'">'. $sector->denominacion.'</option>';
                  }
                  ?>
            </select>
            </p>


            <p>
              <select class="span4" name="teamId" id="teamId">
                <option value="">Perfil nuevo</option>
                <option value="1">Secretario</option>
                <option value="2">Usuario Oficina</option>
                <option value="3">Operador</option>
                <option value="4">Intendente</option>
              </select>
            </p>
            <p><input type="password" class="span4" name="password" id="password" placeholder="Password"></p>
            <p><input type="password" class="span4" name="password2" id="password2" placeholder="Confirm Password"></p>
            
        </div>
        <div class="">
          <a href="#" id="btnModifyUser" class="btn btn-primary">Modificar</a>
        </div>
      </div>
  </div>