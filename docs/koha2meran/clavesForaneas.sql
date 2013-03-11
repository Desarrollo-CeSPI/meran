ALTER TABLE `cat_registro_marc_n3`
  ADD CONSTRAINT `cat_registro_marc_n3_n1` FOREIGN KEY (`id1`) REFERENCES `cat_registro_marc_n1` (`id`),
  ADD CONSTRAINT `cat_registro_marc_n3_n2` FOREIGN KEY (`id2`) REFERENCES `cat_registro_marc_n2` (`id`);

ALTER TABLE `circ_reserva`
  ADD CONSTRAINT `FK_reserves_id3` FOREIGN KEY (`id3`) REFERENCES `cat_nivel3` (`id3`);

ALTER TABLE `usr_socio`
  ADD CONSTRAINT `usr_socio_ibfk_1` FOREIGN KEY (`id_persona`) REFERENCES `usr_persona` (`id_persona`),
  ADD CONSTRAINT `usr_socio_ibfk_2` FOREIGN KEY (`cod_categoria`) REFERENCES `usr_ref_categoria_socio` (`categorycode`),
  ADD CONSTRAINT `usr_socio_ibfk_3` FOREIGN KEY (`id_estado`) REFERENCES `usr_estado` (`id_estado`);