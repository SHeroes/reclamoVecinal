<div class="container">
<br>
<h1>Vecino:   <b><?php echo $name_vecino; ?></b></h1>
<h1>Usted ya tiene un reclamo en gestión para su domicilio, el código es: <b><?php echo $array_rec_edesur[0]['codigo_reclamo'];
 ?></b></h1>



  <form class="reclamo-form" action="update_reclamo_edesur/" method="POST">
    <div class="col-sm-12" id="reclamo-data">
     
      <input hidden type="text" class="span4  rec_asociado" name="rec_asociado" value="<?php echo $array_rec_edesur[0]['id_reclamo_asociado'];?>">

      <input hidden type="text" class="span4 rec_edesur" name="rec_edesur" value="<?php echo $array_rec_edesur[0]['id']; ?>">

      <div id="activar-suministro-vecino-box">
	      <p>¿Usted tiene ahora el suministro activo?</p>
	      <p><a><input type="submit" class="btn btn-primary " value="Marcar como Activo"></a></p>
      </div>
    </div>

  </form>

</div>
