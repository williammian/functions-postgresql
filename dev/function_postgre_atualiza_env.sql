-- Trigger trigger para atualizar o campo (env) com 0 quando inserção ou alteração de registro
CREATE OR REPLACE FUNCTION function_atualiza_env()
  RETURNS trigger AS
$BODY$
BEGIN
 IF TG_OP = 'UPDATE' THEN
	 IF NEW.tb50mps = 1 AND NEW.tb50grupo = 0 AND (NEW.tb50codigo <> OLD.tb50codigo OR NEW.tb50class <> OLD.tb50class OR NEW.tb50umu <> OLD.tb50umu) THEN
	     
	   UPDATE tb50 SET pcf_env = 0 WHERE tb50id = NEW.tb50id;

	 END IF;
 ELSE
	IF NEW.tb50mps = 1 AND NEW.tb50grupo = 0 THEN
	     
	   UPDATE tb50 SET pcf_env = 0 WHERE tb50id = NEW.tb50id;

	 END IF;
 END IF;
 
 RETURN NEW;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION function_atualiza_env()
  OWNER TO postgres;

DROP TRIGGER IF EXISTS trigger_atualiza_env ON tb50;
CREATE TRIGGER trigger_atualiza_env
  AFTER INSERT OR UPDATE
  ON tb50
  FOR EACH ROW
  EXECUTE PROCEDURE function_atualiza_env();