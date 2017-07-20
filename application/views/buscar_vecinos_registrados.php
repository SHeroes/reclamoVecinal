  <h1> Buscar Vecinos Registrados según:</h1>
  <form action="show_main" id="vecinos-dni-form" method="POST" >
  <p><input type="text" class="span4" name="DNI_filter" id="DNI_filter" placeholder="DNI a buscar..." ></p>
  <p><input type="submit" class="span4" value="Buscar"></p>
  </form>
  <form action="show_main" method="POST" >
  <p><input type="text" class="span4" name="Apellido_filter" id="Apellido_filter" placeholder="Apellido a buscar..." ></p>
  <p><input type="submit" class="span4" value="Buscar"></p>
  </form>

  <?php if($vecinos_filtrados != '') {

    if( count($vecinos_filtrados) == 0){
      echo '<h2>el vecino no esta registrado</h2>';
      $this->view('registrar_vecino_nuevo');
    } else {
      echo '<h1> Vecinos Filtrados</h1>';
      echo '<table class="table"><thead class="thead-inverse">        <tr id="header-table">
      <th>DNI</th><th>Apellido</th><th>Nombre</th><th>Domicilio</th><th>mail</th><th>otros</th>       </tr>        </thead><tbody>';
      foreach( $vecinos_filtrados as $vecino){
        echo  '<tr class="vecinos_filtrados"><th scope="row" id-value="'.$vecino->id_vecino .'">'. $vecino->DNI.'</th>'.
              '<td>'.$vecino->Apellido.'</td>'.
              '<td>'.$vecino->Nombre.'</td>'.
              '<td>'.$vecino->calle . $vecino->altura.'</td>'.
              '<td>'.$vecino->mail.'</td>';
      }
      echo '  </tbody></table>';
    }
  } else {
    if ( isset($id_vecino) && ($id_vecino != '') )
     echo "El vecino seleccionado es:  " . $name_vecino;
  }
  ?>
  <br></br>



  <?php /*

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
    echo '<table class="table"><thead class="thead-inverse">        <tr id="header-table">
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

  */ ?>