<?php


class Reclamo_edesur_m extends CI_Model {

  function get_all_reclamos_edesur($id_tipo_reclamo){
    //$id_tipo_reclamo = '743';
    $query = 'SELECT r.codigo_reclamo, r.id_reclamo, HOUR(TIMEDIFF(r.fecha_alta_reclamo,NOW())) as horas_transcurridas,r.fecha_alta_reclamo,r.molestar_dia_hs as horarios, v.id_vecino,v.Apellido, v.Nombre, v.DNI,v.mail, v.tel_fijo, v.tel_movil,l.localidades,c.calle, d.altura ,d.lat, d.lng, ede.*
        FROM reclamos r, vecino v, domiciliosxvecinos , domicilio d, calles c, localidades l,reclamos_edesur ede
        WHERE r.id_tipo_reclamo = '. $id_tipo_reclamo .'
        AND ede.id_reclamo_asociado = r.id_reclamo
        AND r.id_vecino = v.id_vecino 
        AND v.id_vecino = domiciliosxvecinos.id_vecino
        AND domiciliosxvecinos.id_domicilio = d.id_domicilio
        AND d.id_calle = c.id_calle
        AND d.id_loc = l.id_localidad
        order by ede.estado_servicio, horas_transcurridas  desc , r.id_reclamo ;' ;
    $query_result = $this->db->query($query);
    return $query_result->result_array();    
  }

  function create_reclamo($userData){
    $this->load->model('domicilio_m');
    $userData['idDomicilioParaReclamo'] = $this->domicilio_m->search_Dom_by_Vecino($userData['id_vecino']);
    
    $this->load->model('reclamo_m');

    $cod_reclamo = $this->reclamo_m->create_reclamo($userData, true);
    $id_rec_org = $this->db->insert_id();

    $info_edesur_rec = array();
    $info_edesur_rec['id_reclamo_asociado'] =           $id_rec_org;
    $info_edesur_rec['ticket_edesur'] =                 $userData['ticket_edesur'];
    $info_edesur_rec['nro_cliente_edesur'] =            $userData['nro_cliente_edesur'];


    $this->db->insert('reclamos_edesur',$info_edesur_rec);
    return $cod_reclamo;
  }

}