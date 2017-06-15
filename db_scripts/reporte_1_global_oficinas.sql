SELECT estado, count(estado) as cantidad, sectores.denominacion, sectores.id_padre
FROM reclamos, tiporeclamo, usuariosxsector, sectores
WHERE reclamos.id_tipo_reclamo = tiporeclamo.id_tipo_reclamo
AND tiporeclamo.id_responsable = usuariosxsector.id_usuario
AND sectores.id_sector = usuariosxsector.id_sector

group by estado, sectores.id_sector

order by sectores.id_padre, sectores.id_sector 