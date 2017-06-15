SELECT estado, count(estado) as cantidad, s1.id_padre, s2.denominacion
FROM reclamos, tiporeclamo, usuariosxsector, sectores s1 , sectores s2
WHERE reclamos.id_tipo_reclamo = tiporeclamo.id_tipo_reclamo
AND tiporeclamo.id_responsable = usuariosxsector.id_usuario
AND s1.id_sector = usuariosxsector.id_sector
AND s1.id_padre = s2.id_sector

group by estado, s1.id_padre

order by s1.id_padre 