CREATE OR REPLACE FUNCTION acertar_taxa()
  RETURNS void AS
$BODY$
DECLARE
  reg RECORD; -- variável de registro para armazenar informações de cada documento
  rep int2; -- variável para percorrer rep 0, 1, 2, 3, 4
  idEmpCentComis int8; -- id da empresa centralizadora
BEGIN 
  -- obtendo a empresa centralizadora
  SELECT tb652ec INTO idEmpCentComis FROM tb652 INNER JOIN tb65 ON tb652empresa = tb65id 
  WHERE tb652tabela = 'DC' AND tb65codigo = '999'; -- '999' substituir pelo código da empresa

  -- percorrendo os documentos verificando se tem representante que não gerou dados na comissão, ou seja, que estavam com a taxa zerada ('999' substituir pelo código da empresa)
  FOR rep IN 0 .. 4 LOOP
    FOR reg IN SELECT tb02id, (CASE WHEN rep = 0 THEN tb02rep0 WHEN rep = 1 THEN tb02rep1 WHEN rep = 2 THEN tb02rep2 WHEN rep = 3 THEN tb02rep3 ELSE tb02rep4 END) AS idRep 
               FROM tb02 INNER JOIN tb65 ON tb02empresa = tb65id 
               WHERE tb65codigo = '999' AND (CASE WHEN rep = 0 THEN tb02rep0 WHEN rep = 1 THEN tb02rep1 WHEN rep = 2 THEN tb02rep2 WHEN rep = 3 THEN tb02rep3 ELSE tb02rep4 END) IS NOT NULL AND tb02dtpgto IS NULL AND tb02rp = 0 
               AND (tb02id, (CASE WHEN rep = 0 THEN tb02rep0 WHEN rep = 1 THEN tb02rep1 WHEN rep = 2 THEN tb02rep2 WHEN rep = 3 THEN tb02rep3 ELSE tb02rep4 END)) NOT IN (SELECT tb04doc, tb04rep FROM tb04 INNER JOIN tb65 ON tb04empresa = tb65id WHERE tb65codigo = '999')
    LOOP
    
      -- inserindo registro na tabela tb04 comissão com valores zerados
      INSERT INTO tb04 (tb04id, tb04versao, tb04empresa, tb04rep, tb04doc, tb04seq, tb04dtcredito, tb04dtcalc, tb04bccomis, tb04txcomis, tb04vlrcomis, 
                        tb04vlr0, tb04vlr1, tb04vlr2, tb04vlr3, tb04vlr4, tb04vlr5, tb04vlr6, tb04vlr7, tb04vlr8, tb04vlr9, 
                        tb04vlr10, tb04vlr11, tb04vlr12, tb04vlr13, tb04vlr14, tb04vlr15, tb04vlr16, tb04vlr17, tb04vlr18, tb04vlr19, 
                        tb04vlr20, tb04vlr21, tb04vlr22, tb04vlr23, tb04vlr24, tb04vlr25, tb04vlr26, tb04vlr27, tb04vlr28, tb04vlr29, 
                        tb04vlr30, tb04vlr31, tb04vlr32, tb04vlr33, tb04vlr34, tb04vlr35, tb04vlr36, tb04vlr37, tb04vlr38, tb04vlr39, 
                        tb04vlr40, tb04vlr41, tb04vlr42, tb04vlr43, tb04vlr44, tb04vlr45, tb04vlr46, tb04vlr47, tb04vlr48, tb04vlr49, 
                        tb04vlr50, tb04vlr51, tb04vlr52, tb04vlr53, tb04vlr54, tb04vlr55, tb04vlr56, tb04vlr57, tb04vlr58, tb04vlr59, 
                        tb04vlr60, tb04vlr61, tb04vlr62, tb04vlr63, tb04vlr64, tb04vlr65, tb04vlr66, tb04vlr67, tb04vlr68, tb04vlr69, 
                        tb04vlr70, tb04vlr71, tb04vlr72, tb04vlr73, tb04vlr74, tb04vlr75, tb04vlr76, tb04vlr77, tb04vlr78, tb04vlr79, 
                        tb04vlr80, tb04vlr81, tb04vlr82, tb04vlr83, tb04vlr84, tb04vlr85, tb04vlr86, tb04vlr87, tb04vlr88, tb04vlr89, 
                        tb04vlr90, tb04vlr91, tb04vlr92, tb04vlr93, tb04vlr94, tb04vlr95, tb04vlr96, tb04vlr97, tb04vlr98, tb04vlr99, 
                        tb04vlr100, tb04vlr101, tb04vlr102, tb04vlr103, tb04vlr104, tb04vlr105, tb04vlr106, tb04vlr107, tb04vlr108, tb04vlr109, 
                        tb04vlr110, tb04vlr111, tb04vlr112, tb04vlr113, tb04vlr114, tb04vlr115, tb04vlr116, tb04vlr117, tb04vlr118, tb04vlr119, 
                        tb04vlr120, tb04vlr121, tb04vlr122, tb04vlr123, tb04vlr124, tb04vlr125, tb04vlr126, tb04vlr127, tb04vlr128, tb04vlr129, 
                        tb04du, tb04nv)
      VALUES (nextval('dc_sequence'), 0, idEmpCentComis, reg.idRep, reg.tb02id, 0, null, null, 0.0, 0.0, 0.0, 
              0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 
              0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 
              0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 
              0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 
              0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 
              0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 
              0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 
              0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 
              0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 
              0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 
              0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 
              0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 
              0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 
              '21102009;MASTER', 0);

    END LOOP;
  END LOOP;

  RETURN;
END
$BODY$
  LANGUAGE 'plpgsql' VOLATILE;
ALTER FUNCTION acertar_taxa() OWNER TO postgres;

SELECT acertar_taxa()