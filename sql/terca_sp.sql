/* FUNCTIONS */

 DROP PROCEDURE IF EXISTS sp_getHash;
DELIMITER $$
	CREATE PROCEDURE sp_getHash(
		IN Iemail varchar(80),
		IN Isenha varchar(30)
    )
	BEGIN    
		SELECT SHA2(CONCAT(Iemail, Isenha), 256) AS HASH;
	END $$
DELIMITER ;

 DROP PROCEDURE IF EXISTS sp_allow;
DELIMITER $$
	CREATE PROCEDURE sp_allow(
		IN Iallow varchar(80),
		IN Ihash varchar(64)
    )
	BEGIN        
/*    
		SET @access = (SELECT IFNULL(access,-1) FROM tb_usuario WHERE hash COLLATE utf8_general_ci = Ihash COLLATE utf8_general_ci LIMIT 1);
		SET @quer =CONCAT('SET @allow = (SELECT ',@access,' IN ',Iallow,');');
			PREPARE stmt1 FROM @quer;
			EXECUTE stmt1;
*/
		SET @allow = 1;
	END $$
DELIMITER ;

/* LOGIN */

 DROP PROCEDURE IF EXISTS sp_login;
DELIMITER $$
	CREATE PROCEDURE sp_login(
		IN Iemail varchar(80),
		IN Isenha varchar(30)
    )
	BEGIN    
		SET @hash = (SELECT SHA2(CONCAT(Iemail, Isenha), 256));
		SELECT *, IF(nome="",SUBSTRING_INDEX(email,"@",1),nome) AS nome FROM tb_usuario WHERE hash=@hash;
	END $$
DELIMITER ;

/* USER */

 DROP PROCEDURE IF EXISTS sp_setUser;
DELIMITER $$
	CREATE PROCEDURE sp_setUser(
		IN Iallow varchar(80),
		IN Ihash varchar(64),
        IN Iid int(11),
        IN Inome varchar(30),
		IN Iemail varchar(80),
		IN Isenha varchar(30),
        IN Iaccess int(11)
    )
	BEGIN
		IF(Iemail="")THEN
			DELETE FROM tb_mail WHERE id_from=Iid OR id_to=Iid;
			DELETE FROM tb_usuario WHERE id=Iid;
			DELETE FROM tb_user_cli WHERE id_user=Iid;
		ELSE			
			IF(Iid=0)THEN
				INSERT INTO tb_usuario (email,hash,access,nome)VALUES(Iemail,SHA2(CONCAT(Iemail, Isenha), 256),Iaccess,Inome);
			ELSE
				IF(Isenha="")THEN
					UPDATE tb_usuario SET nome=Inome, email=Iemail, access=Iaccess WHERE id=Iid;
				ELSE
					UPDATE tb_usuario SET nome=Inome, email=Iemail, hash=SHA2(CONCAT(Iemail, Isenha), 256), access=Iaccess WHERE id=Iid;
				END IF;
			END IF;
		END IF;
		SELECT 1 AS ok;

	END $$
DELIMITER ;

 DROP PROCEDURE IF EXISTS sp_viewUser;
DELIMITER $$
	CREATE PROCEDURE sp_viewUser(
		IN Iallow varchar(80),
		IN Ihash varchar(64),
		IN Ifield varchar(30),
        IN Isignal varchar(4),
		IN Ivalue varchar(50)
    )
	BEGIN    
		CALL sp_allow(Iallow,Ihash);
		IF(@allow)THEN
			SET @quer =CONCAT('SELECT id,nome,email,access, IF(access=0,"ROOT",IFNULL((SELECT nome FROM tb_usr_perm_perfil WHERE USR.access = id),"DESCONHECIDO")) AS perfil FROM tb_usuario AS USR WHERE ',Ifield,' ',Isignal,' ',Ivalue,' ORDER BY ',Ifield,';');
			PREPARE stmt1 FROM @quer;
			EXECUTE stmt1;
		ELSE 
			SELECT 0 AS id, "" AS email, 0 AS access;
        END IF;
	END $$
DELIMITER ;

 DROP PROCEDURE IF EXISTS sp_updatePass;
DELIMITER $$
	CREATE PROCEDURE sp_updatePass(	
		IN Ihash varchar(64),
        IN Inome varchar(30),
		IN Isenha varchar(30)
    )
	BEGIN    
		SET @call_id = (SELECT IFNULL(id,0) FROM tb_usuario WHERE hash COLLATE utf8_general_ci = Ihash COLLATE utf8_general_ci LIMIT 1);
		IF(@call_id > 0)THEN
			IF(Isenha="")THEN
				UPDATE tb_usuario SET nome=Inome WHERE id=@call_id;
            ELSE
				UPDATE tb_usuario SET hash = SHA2(CONCAT(email, Isenha), 256), nome=Inome WHERE id=@call_id;
            END IF;
            SELECT 1 AS ok;
		ELSE 
			SELECT 0 AS ok;
        END IF;
	END $$
DELIMITER ;

 DROP PROCEDURE IF EXISTS sp_view_atleta;
DELIMITER $$
	CREATE PROCEDURE sp_view_atleta(
		IN Iallow varchar(80),
		IN Ihash varchar(64),
        IN Inome varchar(50)
    )
	BEGIN
		CALL sp_allow(Iallow,Ihash);
		IF(@allow)THEN            
			SELECT * FROM vw_ranking WHERE nome COLLATE utf8_general_ci LIKE CONCAT("%",Inome,"%") ORDER BY nome;
        END IF;
	END $$
DELIMITER ;

 DROP PROCEDURE IF EXISTS sp_set_atleta;
DELIMITER $$
	CREATE PROCEDURE sp_set_atleta(	
		IN Iallow varchar(80),
		IN Ihash varchar(64),
		IN Iid int(11),
		IN Inome varchar(30),
		IN Iposicao varchar(10),
		IN Isexo varchar(1),
		IN Imensalista boolean
    )
	BEGIN    
		CALL sp_allow(Iallow,Ihash);
		IF(@allow)THEN
			IF(Inome="")THEN
				DELETE FROM tb_atleta WHERE id=Iid;
            ELSE
				IF(Iid=0)THEN
					INSERT INTO tb_atleta (id,nome,posicao,sexo,mensalista) 
					VALUES (Iid,Inome,Iposicao,Isexo,Imensalista);
				ELSE
					UPDATE tb_atleta 
                    SET nome=Inome, posicao=Iposicao, sexo=Isexo, mensalista=Imensalista
                    WHERE id=Iid;                
                END IF;
            END IF;
        END IF;
	END $$
DELIMITER ;

 DROP PROCEDURE IF EXISTS sp_set_ranking;
DELIMITER $$
	CREATE PROCEDURE sp_set_ranking(	
		IN Iallow varchar(80),
		IN Ihash varchar(64),
		IN Iid_atleta int(11),
		IN Inota int
    )
	BEGIN    
		CALL sp_allow(Iallow,Ihash);
		IF(@allow)THEN
			SET @id_call = (SELECT IFNULL(id,0) FROM tb_usuario WHERE hash COLLATE utf8_general_ci = Ihash COLLATE utf8_general_ci LIMIT 1);
			IF(@id_call>0)THEN
				INSERT INTO tb_ranking (id_usuario,id_atleta,nota) 
				VALUES (@id_call,Iid_atleta,Inota)
				ON DUPLICATE KEY UPDATE nota=Inota;
            END IF;
        END IF;
	END $$
DELIMITER ;

 DROP PROCEDURE sp_view_extrato;
DELIMITER $$
	CREATE PROCEDURE sp_view_extrato(
		IN Iallow varchar(80),
		IN Ihash varchar(64),
        IN Idt_ini date,
        IN Idt_fin date
    )
	BEGIN
		CALL sp_allow(Iallow,Ihash);
		IF(@allow)THEN
			SET @quer =CONCAT('SELECT * FROM vw_extrato WHERE fulldate >= "',Idt_ini,' 00:00:00" AND fulldate <="',Idt_fin,' 23:59:59" ORDER BY id;');
			PREPARE stmt1 FROM @quer;
			EXECUTE stmt1;
		ELSE
			SELECT 0 AS id, "" AS nome;
        END IF;
	END $$
	DELIMITER ;

 DROP PROCEDURE IF EXISTS sp_set_financeiro;
DELIMITER $$
	CREATE PROCEDURE sp_set_financeiro(	
		IN Iallow varchar(80),
		IN Ihash varchar(64),
		IN Iid int(11),
		IN Idescricao varchar(50),
		IN Ivalor int,
        IN Idata datetime
    )
	BEGIN    
		CALL sp_allow(Iallow,Ihash);
		IF(@allow)THEN
			SET @id_call = 0;
            SET @access = -1;
            SELECT IFNULL(id,0), IFNULL(access,-1) INTO @id_call,@access FROM tb_usuario WHERE hash COLLATE utf8_general_ci = Ihash COLLATE utf8_general_ci LIMIT 1;
			IF(@access=0)THEN
				IF(Idescricao="")THEN
					DELETE FROM tb_financeiro WHERE id=Iid;
				ELSE
					SET @saldo = (SELECT saldo FROM vw_saldo);
					INSERT INTO tb_financeiro (id,id_usuario,descricao,valor,saldo,data) 
					VALUES (Iid,@id_call,Idescricao,Ivalor,@saldo+Ivalor,Idata)
					ON DUPLICATE KEY UPDATE
					descricao=Idescricao, valor=Ivalor, data=Idata;                
                END IF;
            END IF;
        END IF;
	END $$
DELIMITER ;
