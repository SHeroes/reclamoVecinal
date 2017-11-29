<?php //echo '<script src="'. base_url() .'assets/js/show_reclamos_crear.js"></script>'; ?>
<div class="container-fluid">
<h1>Reclamos correspondientes a: <?php
/*
  if ($this->session->sectores_multiples){
    $array_sectores = $this->session->array_sectores;
    foreach ($array_sectores as $row => $value) {
     echo '</br> - ' .$array_sectores[$row]->denominacion ;
    }
  }else{
    echo $this->session->sector_name;
  }
  */
 ?></h1>



  <div class="col-sm-12">


    <form action="#" id="state_filter" method="POST" >

        <div class="col-sm-3">
          <p><input type="text" name="apellido" class="input-form form-control" placeholder="Apellido..."></p>
          <p><input type="int" name="dni" class="input-form form-control" placeholder="DNI..."></p>
          <p><input type="text" name="nro_rec" class="input-form form-control" placeholder="Nº Reclamo"></p>
        </div>
        <div class="col-sm-3">
          <p><input type="text" placeholder="desde:" class="input-fecha desde form-control" name="desde" id="datepicker" size="15"></p>
          <p><input type="text" placeholder="hasta:" class="input-fecha hasta form-control" name="hasta" id="datepicker2" size="15"></p>  
          <input type="submit" class="span4 btn" value="Filtrar">
          <p></p> 
        </div>        

        <div class="col-sm-6">
          <p><select type="text" class="span4 form-control" name="status_filter_selector" id="status_filter_selector" style="margin-right: 30px;">
              <option id="estado-vacio_filter" value="">Elegir Estado... </option>
              <option id="iniciado_filter" value="Iniciado">Iniciado</option>
              <option id="visto_filter" value="Visto">Visto</option>            
              <option id="contactado_filter" value="Contactado">Contactado</option>
              <option id="resolucion_filter" value="En resolución">En resolución</option>
              <option id="solucionado_filter" value="Solucionado">Solucionado</option>
              <option id="gestionado_filter" value="Gestionado">Gestionado</option>
              <option id="reasignacion" value="En Reasignacion">En Reasignacion</option> 
          </select>  </p>


          <p><select type="text" class="span4 form-control" name="reclamoType_filter_selector" id="reclamoType_filter_selector" style="margin-right: 30px;">
              <option id="typeReclamo-vacio_filter" value="">Elegir Tipo de Reclamo... </option>
              <?php
              
                foreach ($list_reclaim_type as $row => $value) {
                     $str = '<option id="typeReclamo-vacio_filter" value="'.$list_reclaim_type[$row]->id_tipo_reclamo. '">' . $list_reclaim_type[$row]->titulo.'</option>';
                     echo $str;

                }
                
              ?>
          </select>
          </p>
        </div>
        
        <p></p>
    </form>


    <?php 
  
      echo $tramites_list;
    ?>

 
  </div>

</div>

  <div id="vecino-data" class="dialog-box" style="display: none;" title="Datos Reclamante">
    <p></p>
  </div> 

  <div id="ver-obs" class="dialog-box" style="display: none;" title="Visualizar Observaciones">
    <p></p>
  </div> 

  <div id="comments-data" class="dialog-box" style="display: none;" title="Comentario">
    <p></p>
  </div> 

  <div id="state" class="dialog-box" id-rec="" style="display: none;" title="Cambiar estado">
    
      <p><select type="text" class="span4" name="status_selector" id="status_selector">
        <option id="estado-vacio" value="">Elegir Estado... </option>
        <option id="contactado" value="Contactado">Contactado</option>
        <option id="resolucion" value="En resolución">En resolución</option>
        <option id="solucionado" value="Solucionado">Solucionado</option>
        <option id="gestionado" value="Gestionado">Gestionado</option>
        <option id="reasignacion" value="En Reasignacion">En Reasignacion</option>
    </select></p>
    <div class="btn btn-primary">Aceptar</div>
  </div>


  <div id="obs-data" class="dialog-box" style="display: none;" title="Editar Observacion">
    <p>
      <form action="javascript:editar_observacion();" id="obs-form" method="POST" ><p><textarea type="text" class="span4" name="observacion_input" id="observacion-input" rows="8" cols="50" placeholder="" ></textarea></p><p><input type="hidden" name="id_rec" id="id-rec" class="span4" value=""></p><p><input type="submit" class="span4" value="Enviar"></p></form>
    </p>
  </div> 

  <div id="img-box" class="ui-widget-content" style="display: none;" title="Fotos del Reclamo">
    <p>
      
    </p>
  </div> 

<?php echo '<script src="'. base_url() .'assets/js/show_office.js"></script>'; ?>

<?php echo '<script src="'. base_url() .'assets/js/ver_imagenes_reclamo.js"></script>'; ?>
 
<link rel="stylesheet" href="<?php echo base_url();?>assets/js/vendor/jquery-ui/jquery-ui.css">
<script src="<?php echo base_url();?>assets/js/vendor/jquery-ui/jquery-ui.js"></script>
<?php echo '<script src="'. base_url() .'assets/js/show_calendar.js"></script>'; ?> 
<?php echo '<script src="'. base_url() .'assets/js/header-table.js"></script>'; ?> 
