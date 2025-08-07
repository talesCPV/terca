
	DROP VIEW IF EXISTS vw_ranking;
 	CREATE VIEW vw_ranking AS
		SELECT ATL.id AS id_atleta, UPPER(ATL.nome) AS nome, UPPER(ATL.posicao) AS posicao, UPPER(ATL.sexo) AS sexo,
        IF(ATL.mensalista,"SIM","NÃO") AS mensalista, ROUND(IFNULL(AVG(RNK.nota),0),1) AS nota
        FROM tb_atleta AS ATL
        LEFT JOIN tb_ranking AS RNK
        ON RNK.id_atleta = ATL.id
        GROUP BY ATL.id;
    
SELECT * FROM vw_ranking;