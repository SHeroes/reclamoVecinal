  <div class="container">
      <h3>Detalles de usuario Nuevo</h3>
    
    <div class="modal-body">
        <p><input type="text" class="span4" name="first_name" id="first_name" placeholder="Nombre"></p>
        <p><input type="text" class="span4" name="last_name" id="last_name" placeholder="Apellido"></p>
        <p><input type="text" class="span4" name="email" id="email" placeholder="Email"></p>
        <p>
        <select class="span4" name="miembro_sector" id="miembro_sector">
        <option value="">Sector del que depende</option>
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
    <div class="modal-footer">
      <a href="#" id="btnModalSubmit" class="btn btn-primary">Create</a>
    </div>
  </div>