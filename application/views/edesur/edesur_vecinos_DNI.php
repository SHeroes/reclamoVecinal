

<div class="container">

<?php if($vecinos_filtrados != '') {
    if( count($vecinos_filtrados) == 0){
      echo '<h2>Usted no esta registrado dentro del CAV</h2>';
      $this->view('./registrar_vecino_nuevo');
    } else {
      $val = $vecinos_filtrados[0];
      $stringUrl = '/edesur/Main_edesur_vecino/show_main?id_vecino='.$val->id_vecino.'&name_vecino='.$val->Apellido.', '.$val->Nombre;
      redirect($stringUrl);
    }
  } else {
    echo '<h1 class="ed-mob"> Ingrese su DNI o apellido para saber si se encuentra registrado</h1>';
    if ( isset($id_vecino) && ($id_vecino != '') ){
          echo "El vecino seleccionado es:  " . $name_vecino;
    }else{
        ?>
          <div class="col-sm-12">
          <form action="log_vecino_DNI" id="vecinos-dni-form" method="POST" >
          <div class="col-sm-4">
              <p><input type="text" class="span4 form-control" name="DNI_filter" id="DNI_filter" placeholder="DNI a buscar..." ></p>
           </div>
           <div class="col-sm-4">
            <p><input type="submit" class="span4 btn" value="Buscar"></p>
           </div>
          </form>
          </div>
          <div class="col-sm-12">
          </div>
        <?php
    }
  }
?>

</div>


<?php echo '<script src="'. base_url() .'assets/js/plugin/json2.js"></script>'; ?>
