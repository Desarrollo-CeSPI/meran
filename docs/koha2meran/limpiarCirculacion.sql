    DELETE FROM circ_sancion WHERE fecha_final < substr(now(),1,10);
    DELETE FROM circ_prestamo WHERE fecha_devolucion is not null;
    DELETE FROM circ_reserva WHERE id3 not in (select id3 from circ_prestamo) and estado = 'P';
    UPDATE circ_reserva SET estado='G' WHERE id3 is NULL and  estado is NULL;
    UPDATE circ_reserva SET estado='E' WHERE id3 is not NULL and  estado is NULL;


