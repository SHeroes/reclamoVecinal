  <?php 

        $pathUrl = base_url();
      //  $pathUrl = 'http://192.168.1.4/'; 
        $idTipoReclamo = 743; //TODO CAMBIAR POR EL VALOR REAL DE LA OFICINA DE EDESUR  ?>

<?php // echo  '<script src="'. $pathUrl .'assets/js/show_reclamos_crear.js"></script>'; ?>
<div class="container">
<h1>Tomar Reclamo</h1>



  <form class="reclamo-form" action="insert_reclamo_edesur/" method="POST">
    <div class="col-sm-12" id="reclamo-data">
      <p>Vecino que realiza el Reclamo:   <b><?php echo $name_vecino; ?></b></p>
      <p>Tipo de reclamo seleccionado:   <b id="tipo_reclamo_seleccionado">Edesur</b></p>
      <input hidden type="text" class="span4 more-reg" name="id_tipo_reclamo" value="<?php echo $idTipoReclamo;?>" id="tipo_reclamo">
      <input hidden type="text" class="span4  id_vecino more-reg" name="id_vecino" value="<?php echo $id_vecino; ?>" id="">
      <input hidden type="text" class="span4 name_vecino more-reg" name="name_vecino" value="<?php echo $name_vecino; ?>" id="">
      <input hidden type="text" class="span4 id_domicilio more-reg" name="id_domicilio" value="<?php echo $id_domicilio; ?>" id="">
      <p><textarea rows="2" cols="50" type="text" class="span4 more-reg form-control" name="molestar_dia_hs" id="molestar_dia_hs" placeholder="Días y horarios en que puede ser molestado "  required="true" ></textarea></p>
      <p><textarea rows="1" cols="50" type="text" class="span4 more-reg form-control" name="ticket_edesur" id="ticket_edesur" placeholder="Nro Ticket del reclamo realizado a Edesur" required="true"></textarea></p>

      <p><textarea rows="1" cols="50" type="text" class="span4 more-reg form-control" name="nro_cliente_edesur" id="nro_cliente_edesur" placeholder="Nro de cliente de Edesur" required="true"></textarea></p>

      <p><input type="checkbox" class="more-reg form-check-input" name="molestar_al_tel_fijo" value="true" >Comunicarse al tel. fijo</p>
      <p><input type="checkbox" class="more-reg form-check-input" name="molestar_al_tel_mov" value="true" >Comunicarse al tel. movil</p>
      <p><input type="checkbox" class="more-reg form-check-input" name="molestar_al_dom" value="true" >Presencialmente al domicilio</p>
      <p><input type="checkbox" class="more-reg form-check-input" name="domicilio_restringido" value="true" >Si no desea que se puedan ver sus datos</p>
      <!-- <p><input type="checkbox" class="more-reg form-check-input" name="redes_sociales" value="true" >Contactado por Redes Sociales</p> -->

      <p></p>
      <p><textarea class="more-reg form-control" rows="6" cols="50" type="text" name="comentarios" placeholder="comentarios"></textarea></p>



      <p><a><input type="submit" class="btn btn-primary " value="Registrar Reclamo"></a></p>
    </div>

  </form>

</div>
