
	DROP VIEW IF EXISTS vw_ranking;
 	CREATE VIEW vw_ranking AS
		SELECT ATL.id AS id_atleta, UPPER(ATL.nome) AS nome, UPPER(ATL.posicao) AS posicao, UPPER(ATL.sexo) AS sexo,
        IF(ATL.mensalista,"SIM","NÃO") AS mensalista, ROUND(IFNULL(AVG(RNK.nota),0),1) AS nota
        FROM tb_atleta AS ATL
        LEFT JOIN tb_ranking AS RNK
        ON RNK.id_atleta = ATL.id
        GROUP BY ATL.id;
    
SELECT * FROM vw_ranking;

	DROP VIEW IF EXISTS vw_saldo;
 	CREATE VIEW vw_saldo AS
		SELECT
    CASE
        WHEN EXISTS (SELECT 1 FROM tb_financeiro) THEN
            (SELECT saldo FROM tb_financeiro ORDER BY id DESC LIMIT 1)
        ELSE
            0
    END AS saldo;
    
SELECT * FROM vw_saldo;

	DROP VIEW IF EXISTS vw_extrato;
 	CREATE VIEW vw_extrato AS
		SELECT FIN.id, FIN.data AS fulldate, DATE_FORMAT(FIN.data, "%d/%m/%Y") AS data, DATE_FORMAT(FIN.data, "%H:%i:%s") AS hora,USR.nome AS usuario,
        FIN.descricao, ROUND(FIN.valor/100,2) AS valor,
        (SELECT  ROUND(SUM(valor)/100,2)FROM tb_financeiro WHERE id<=FIN.id) AS saldo
        FROM tb_financeiro AS FIN
        INNER JOIN tb_usuario AS USR
        ON FIN.id_usuario = USR.id
        ORDER BY FIN.id;
    
    SELECT FIN.id,FIN.id_usuario,FIN.descricao, FIN.data, FIN.valor,(SELECT SUM(valor) WHERE id<= FIN.id) AS saldo FROM tb_financeiro AS FIN;
    
SELECT * FROM vw_extrato;

	DROP VIEW IF EXISTS vw_notas;
 	CREATE VIEW vw_notas AS
		SELECT   USR.nome AS usuario, UPPER(ATL.nome) AS atleta, RNK.nota   
        FROM tb_atleta AS ATL
        INNER JOIN tb_usuario AS USR
        INNER JOIN tb_ranking AS RNK        
        ON RNK.id_atleta = ATL.id
        AND RNK.id_usuario = USR.id;
    
    SELECT * FROM vw_notas;
    
    
	DROP VIEW IF EXISTS vw_presenca;
 	CREATE VIEW vw_presenca AS    
		SELECT RCH.id AS id_racha, RCH.dia,  ATL.*,
        CASE WHEN PRE.id_atleta IS NOT NULL THEN "SIM" ELSE "NÃO" END AS  vai,
        IFNULL(PRE.data,"") AS data,
        IFNULL(PRE.time,"") AS time
        FROM vw_ranking AS ATL
        INNER JOIN tb_racha AS RCH
        LEFT JOIN tb_presenca AS PRE
        ON  PRE.id_atleta = ATL.id_atleta
        AND PRE.id_racha = RCH.id
        ORDER BY RCH.id, ATL.mensalista DESC,
        CASE 
			WHEN ATL.mensalista="SIM" THEN ATL.nome
			WHEN ATL.mensalista="NÃO" THEN IFNULL(PRE.data,999999999999999)
		END;

SELECT * FROM vw_presenca;

	DROP VIEW IF EXISTS vw_pontos;
 	CREATE VIEW vw_pontos AS   
		SELECT COUNT(*) AS jogos, ATL.id AS id_atleta, ATL.nome, ATL.posicao, ATL.sexo,PRE.time,
		SUM(IF((PRE.time=JOG.time_1 AND JOG.placar_1>JOG.placar_2) OR(PRE.time=JOG.time_2 AND JOG.placar_2>JOG.placar_1) ,1,0)) AS vitoria,
		SUM(IF((PRE.time=JOG.time_1 AND JOG.placar_1>JOG.placar_2) OR(PRE.time=JOG.time_2 AND JOG.placar_2>JOG.placar_1) ,0,1)) AS derrota,
		SUM(IF(PRE.time=JOG.time_1,JOG.placar_1,JOG.placar_2)) AS pt_pro,
		SUM(IF(PRE.time=JOG.time_1,JOG.placar_2,JOG.placar_1)) AS pt_contra,
        CONCAT(ROUND(SUM(IF((PRE.time=JOG.time_1 AND JOG.placar_1>JOG.placar_2) OR(PRE.time=JOG.time_2 AND JOG.placar_2>JOG.placar_1) ,1,0))/COUNT(*)*100,0),"%") AS perc
		FROM tb_jogos AS JOG
		INNER JOIN tb_presenca AS PRE
		INNER JOIN tb_atleta AS ATL
		ON JOG.id_racha = PRE.id_racha
		AND ATL.id = PRE.id_atleta
		AND (JOG.time_1=PRE.time OR JOG.time_2=PRE.time)
		GROUP BY ATL.id
		ORDER BY vitoria DESC, derrota ASC, pt_pro DESC, pt_contra ASC;

SELECT * FROM vw_pontos ORDER BY perc DESC;

	DROP VIEW IF EXISTS vw_posts;
 	CREATE VIEW vw_posts AS   
		SELECT PST.id AS id_post, PST.id_post AS id_pai, PST.data_hora, PST.texto, USR.nome, USR.id AS id_usuario, USR.id_atleta
		FROM tb_post AS PST
		INNER JOIN tb_usuario AS USR
		ON PST.id_usuario=USR.id
		ORDER BY PST.data_hora;

SELECT * FROM vw_posts;