SELECT id_localidad, localidades, tiporeclamo.id_tipo_reclamo , tiporeclamo.titulo , count(tiporeclamo.id_tipo_reclamo) as cantidad 

FROM reclamos, tiporeclamo, domicilio, localidadxcalle, localidades
WHERE reclamos.id_tipo_reclamo = tiporeclamo.id_tipo_reclamo
AND domicilio.id_domicilio = reclamos.id_dom_reclamo
AND domicilio.id_calle = localidadxcalle.id_calle
AND localidades.id_localidad = localidadxcalle.id_loc

group by tiporeclamo.id_tipo_reclamo
order by localidades, titulo

