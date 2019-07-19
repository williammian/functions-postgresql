CREATE OR REPLACE FUNCTION function_avisar_usuario()
  RETURNS trigger AS
$BODY$
DECLARE 
	rec_Rep RECORD;
	rec_Msg RECORD;
	rec_Users RECORD;
	msg VARCHAR(300);

BEGIN

	msg := NULL;

	-- Montando mensagem
	FOR rec_Msg IN (SELECT tb15codigo, tb01num, tb80codigo, tb80na, tb50codigo, tb50descr, tb011vlr76 As compra     
			FROM tb01 INNER JOIN tb011 ON tb011doc = tb01id INNER JOIN tb15 ON tb01tipo = tb15id 
			INNER JOIN tb80 ON tb01ent = tb80id  
			INNER JOIN tb50 ON tb011item = tb50id  
			WHERE tb01empresa = OLD.tb05empresa AND tb01tipo = OLD.tb05tipo AND tb01ent = OLD.tb05ent AND tb01num = OLD.tb05num 
			AND tb011item = OLD.tb05item LIMIT 1) LOOP 

		msg := 'O item ' || rec_Msg.tb50codigo || '-' || rec_Msg.tb50descr || 
		       ' do documento ' || rec_Msg.tb15codigo || '-' || rec_Msg.tb01num ||  
		       ' da entidade ' || rec_Msg.tb80codigo || '-' || rec_Msg.tb80na || 
		       ' quantidade ' || rec_Msg.compra || ' teve sua necessidade de compra atendida.';

	END LOOP;

	IF msg IS NOT NULL THEN

		-- Obtendo usuário/vendedor do documento
		FOR rec_Rep IN(SELECT tb80ruser FROM tb01 INNER JOIN tb80 ON tb01rep0 = tb80id  
				WHERE tb01tipo = OLD.tb05tipo AND tb01num = OLD.tb05num AND tb01ent = OLD.tb05ent AND tb01empresa = OLD.tb05empresa AND tb80ruser IS NOT NULL) LOOP
		
			-- Inserindo um registro na agenda para o usuário/vendedor
			INSERT INTO tb38 (tb38id, tb38versao, tb38user, tb38data, tb38hora, tb38autor, tb38msg, tb38dtciente, tb38hrciente, tb38dtarquivo, tb38hrarquivo, tb38obs)
			VALUES (nextval('aa_sequence'), 0, rec_Rep.tb80ruser, CURRENT_DATE, CURRENT_TIME, rec_Rep.tb80ruser, msg, null, null, null, null, null);
				
		END LOOP;

		-- Gerando registro na agenda para outros usuários
		FOR rec_Users IN(SELECT tb30id FROM tb30   
				WHERE tb30user IN ('GERENTE' , 'USUARIO')) LOOP
				
			INSERT INTO tb38 (tb38id, tb38versao, tb38user, tb38data, tb38hora, tb38autor, tb38msg, tb38dtciente, tb38hrciente, tb38dtarquivo, tb38hrarquivo, tb38obs)
			VALUES (nextval('aa_sequence'), 0, rec_Users.tb30id, CURRENT_DATE, CURRENT_TIME, rec_Users.tb30id, msg, null, null, null, null, null);

		END LOOP;

	END IF;
 
 RETURN NEW;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION function_avisar_usuario()
  OWNER TO postgres;

DROP TRIGGER IF EXISTS trigger_avisar_usuario ON tb05;
CREATE TRIGGER trigger_avisar_usuario  
  AFTER DELETE 
  ON tb05
  FOR EACH ROW
  EXECUTE PROCEDURE function_avisar_usuario();