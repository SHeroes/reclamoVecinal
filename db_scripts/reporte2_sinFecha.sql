SELECT reclamos.codigo_reclamo as NumRec, s1.denominacion Oficina , s2.denominacion Secretaria, estado, fecha_alta_reclamo
/* 
Numero reclamo   - oficina   - Secretaria   -   Estado  -  Fecha alta   - Fecha última Modif   - Cant días entre el alta y fecha modif
*/
FROM dbcav.reclamos, tiporeclamo, usuariosxsector, sectores s1, sectores s2
WHERE reclamos.id_tipo_reclamo = tiporeclamo.id_tipo_reclamo
AND tiporeclamo.id_responsable = usuariosxsector.id_usuario
AND s1.id_sector = usuariosxsector.id_sector
AND s1.id_padre = s2.id_sector;