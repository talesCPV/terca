
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
        FIN.descricao, ROUND(FIN.valor/100,2) AS valor, ROUND(FIN.saldo/100,2) AS saldo
        FROM tb_financeiro AS FIN
        INNER JOIN tb_usuario AS USR
        ON FIN.id_usuario = USR.id
        ORDER BY FIN.id;
    
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