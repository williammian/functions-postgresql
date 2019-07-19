CREATE OR REPLACE FUNCTION acertar_dados()
  RETURNS void AS
$BODY$
DECLARE
  reg RECORD; -- variável de registro para armazenar informações de cada registro
BEGIN 
  
	-- percorrendo os registros
	FOR reg IN SELECT tb25codigo, tb25nome, tb25aquis, tb03dtimob, tb03id FROM tb25 INNER JOIN tb03 ON tb03bem = tb25id INNER JOIN tb65 ON tb03empresa = tb65id 
		   WHERE tb25aquis <> tb03dtimob AND tb65codigo = '999'   
		   ORDER BY tb25codigo
	LOOP
	
		-- atualiza conforme critérios
		UPDATE tb032 SET tb032mes = (SELECT DATE_PART('MONTH', tb25aquis) FROM tb25 INNER JOIN tb03 ON tb03bem = tb25id WHERE tb03id = reg.tb03id), 
		tb032ano = (SELECT DATE_PART('YEAR', tb25aquis) FROM tb25 INNER JOIN tb03 ON tb03bem = tb25id WHERE tb03id = reg.tb03id) 
		WHERE tb032id = (SELECT tb032id FROM tb032 WHERE tb032esp = reg.tb03id ORDER BY tb032ano, tb032mes LIMIT 1); 
	
	END LOOP;

  RETURN;
END
$BODY$
  LANGUAGE 'plpgsql' VOLATILE;
ALTER FUNCTION acertar_dados() OWNER TO postgres;

select acertar_dados()