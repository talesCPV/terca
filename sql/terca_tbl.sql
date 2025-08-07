 DROP TABLE IF EXISTS tb_usuario;
CREATE TABLE tb_usuario (
    id int(11) NOT NULL AUTO_INCREMENT,
    email varchar(70) NOT NULL,
    hash varchar(64) NOT NULL,
    nome varchar(30) NOT NULL DEFAULT "",
    token varchar(64) DEFAULT NULL,
    access int(11) DEFAULT -1,
    cadastro TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	UNIQUE KEY (hash),
	UNIQUE KEY (email),
    PRIMARY KEY (id)
) ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

	INSERT INTO tb_usuario (email,hash,access,nome)VALUES("tales@planet3.com.br","b494f6a8b457c58f8feaac439d771a15045337826d72be5b14bb2f224dc7eb39",0,"Developer");
    
DROP TABLE IF EXISTS tb_atleta;
CREATE TABLE tb_atleta (
    id int(11) NOT NULL AUTO_INCREMENT,
    nome varchar(30) NOT NULL,
    posicao varchar(10) NOT NULL,
    sexo varchar(1) NOT NULL DEFAULT "M",
    mensalista boolean NOT NULL DEFAULT 0,
    UNIQUE KEY(nome),
    PRIMARY KEY (id)
) ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS tb_ranking;
CREATE TABLE tb_ranking (
    id_usuario int(11) NOT NULL,
    id_atleta int(11) NOT NULL,
    nota int NOT NULL DEFAULT 0,
    FOREIGN KEY (id_usuario) REFERENCES tb_usuario(id) ON DELETE CASCADE,
    FOREIGN KEY (id_atleta) REFERENCES tb_atleta(id) ON DELETE CASCADE,
    PRIMARY KEY (id_usuario,id_atleta)
) ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;