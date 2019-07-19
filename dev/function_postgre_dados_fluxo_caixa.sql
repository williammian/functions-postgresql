CREATE TYPE fluxo_caixa AS
   (data date,
    recebimentos numeric,
    pagamentos numeric,
    receber numeric,
    pagar numeric,
    saldosimples numeric,
    saldoanteriorsimples numeric,
    saldoanteriorsomado numeric,
    saldosomado numeric);
ALTER TYPE fluxo_caixa OWNER TO postgres;

CREATE TRUSTED PROCEDURAL LANGUAGE 'plpgsql'
HANDLER plpgsql_call_handler;

CREATE OR REPLACE FUNCTION dados_fluxo_caixa()
  RETURNS SETOF fluxo_caixa AS
$BODY$
DECLARE
  f fluxo_caixa%ROWTYPE;
  reg RECORD;
  saldoanterior numeric;
  linha int4;
BEGIN
  SELECT SUM(tb101vlrdeb - tb101vlrcred) INTO saldoanterior FROM tb101 INNER JOIN tb10 ON tb101ctac = tb10id INNER JOIN tb65 ON tb10empresa = tb65id 
  WHERE tb65codigo = '999' AND tb101ano = 0 AND tb101mes = 0; 
  
  linha := 0;

  FOR reg IN SELECT tb11data As data, SUM(CASE WHEN tb11dc = 0 THEN tb11valor ELSE 0.0 END) AS recebimentos, SUM(CASE WHEN tb11dc = 1 THEN tb11valor ELSE 0.0 END) AS pagamentos, 0.0 As receber, 0.0 as pagar FROM tb11 INNER JOIN tb65 ON tb11empresa = tb65id WHERE tb65codigo = '999' GROUP BY tb11data 
		UNION 
		SELECT tb02dtvcton As data, 0.0 As recebimentos, 0.0 As pagamentos, SUM(CASE WHEN tb02rp = 0 AND tb02prev = 0 THEN tb02valor ELSE 0.0 END) As receber, SUM(CASE WHEN tb02rp = 1 AND tb02prev = 0 THEN tb02valor ELSE 0.0 END) As pagar FROM tb02 INNER JOIN tb65 ON tb02empresa = tb65id WHERE tb65codigo = '999' GROUP BY tb02dtvcton 
  LOOP
    f.data := reg.data;
    f.recebimentos := reg.recebimentos;
    f.pagamentos := reg.pagamentos;
    f.receber := reg.receber;
    f.pagar := reg.pagar;
    
    f.saldosimples := reg.recebimentos - reg.pagamentos + reg.receber - reg.pagar;

    IF linha = 0 THEN
       f.saldoanteriorsimples := saldoanterior;
    ELSE
       f.saldoanteriorsimples := 0.0;
    END IF;

    f.saldoanteriorsomado := saldoanterior;

    saldoanterior := saldoanterior + reg.recebimentos - reg.pagamentos + reg.receber - reg.pagar;

    f.saldosomado := saldoanterior;

    linha := linha + 1;
    RETURN NEXT f;
  END LOOP;
  RETURN;
END
$BODY$
  LANGUAGE 'plpgsql' VOLATILE;
ALTER FUNCTION dados_fluxo_caixa() OWNER TO postgres;