SELECT estado, count(estado) as cantidad
FROM reclamos
group by estado
