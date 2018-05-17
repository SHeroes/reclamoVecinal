  <div id="ch_pass" class="dialog-box" style="display: none;" title="Cambiar Contraseña">
    <p>ingrese la contraseña nueva</p>
    <p><input type="text" class="span4" name="new_pass" id="new_pass" placeholder="password"></p>
    <div class="btn btn-primary">Cambiar</div>
  </div>

<link rel="stylesheet" href="<?php echo base_url();?>assets/js/vendor/jquery-ui/jquery-ui.css">

  <?php echo '<script src="'. base_url() .'assets/js/vendor/jquery-ui/jquery-ui.js"></script>'; ?>
  <?php echo '<script src="'. base_url() .'assets/js/change_pass.js"></script>'; ?>

<style>
.ui-draggable, .ui-droppable {
  background-position: top;
}

.input-form{
  margin-right: 30px;
  width: 130px;
}

.reclamo-form{
 display: none; 
}
.no-visto{
  visibility: hidden;
}

</style>