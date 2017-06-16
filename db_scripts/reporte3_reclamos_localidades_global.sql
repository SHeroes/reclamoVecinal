SELECT localidades, count(localidades) as cantidad 

FROM reclamos, domicilio, localidadxcalle, localidades
WHERE domicilio.id_domicilio = reclamos.id_dom_reclamo
AND domicilio.id_calle = localidadxcalle.id_calle
AND localidades.id_localidad = localidadxcalle.id_loc

group by  localidades