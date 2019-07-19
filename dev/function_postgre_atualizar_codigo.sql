CREATE OR REPLACE FUNCTION atualizar_codigo()
  RETURNS void AS
$BODY$DECLARE

   rec_E RECORD;
   rec_SE RECORD;
   counter NUMERIC;
   fam bigint;

BEGIN
   
   fam := 1;
   
   FOR rec_E IN(SELECT tb02codaglut, count(tb02codaglut) AS rep FROM tb02 INNER JOIN tb59 ON tb59id = tb02codmov 
                WHERE tb59codigo IN ('20', '19') AND tb02data > '01/01/2012' GROUP BY tb02codaglut ORDER BY rep DESC) LOOP

      counter := 1;

      FOR rec_SE IN(SELECT tb02id, tb59codigo, tb02codaglut FROM tb02 INNER JOIN tb59 ON tb59id = tb02codmov 
                    WHERE tb02codaglut = rec_E.tb02codaglut 
                    ORDER BY tb02id) LOOP
                       
         UPDATE tb02 SET tb02codaglut = rec_E.tb02codaglut || '-' || counter, 
                         tb02famaglut = fam, 
                         tb02ctrlaglut = (CASE WHEN rec_SE.tb59codigo = '20' OR rec_SE.tb59codigo = '19' THEN 3 ELSE 2 END) 
                         WHERE tb02id = rec_SE.tb02id;                       
            
         IF rec_SE.tb59codigo = '20' OR rec_SE.tb59codigo = '19' THEN
            counter := counter + 1;   
         END IF;

      END LOOP;

      fam := fam + 1;
      
   END LOOP;
   
   RETURN;
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION atualizar_codigo()
  OWNER TO postgres;
