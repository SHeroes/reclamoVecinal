<?php


class Reclamo_edesur_m extends CI_Model {



    function set_solucionado_reclamo_edesur($id_reclamo_asociado, $id_reclamo_edesur){
        $this->load->model('reclamo_m');
        $this->reclamo_m->update_state_reclamo('Solucionado',$id_reclamo_asociado);
        $this->set_on_reclamo_edesur($id_reclamo_edesur);
        return true;
    }

    function set_on_reclamo_edesur($id_reclamo_edesur){
        $this->db->set('estado_servicio',"b'1'");   
        $this->db->where('id', $id_reclamo_edesur);
        $this->db->update('reclamos_edesur');  

        return $id_reclamo_edesur;
    }

    function get_reclamo_edesur_by_vecino($id_vecino){
        $query = 'SELECT reclamos_edesur.*, reclamos.codigo_reclamo FROM reclamos, reclamos_edesur
                    WHERE reclamos.id_reclamo = reclamos_edesur.id_reclamo_asociado
                    AND reclamos_edesur.estado_servicio = 0
                    AND reclamos.id_vecino = '.$id_vecino ;
        $query_result = $this->db->query($query);
        return $query_result->result_array();
    }

    function get_all_reclamos_edesur($id_tipo_reclamo){
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