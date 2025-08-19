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

 DROP PROCEDURE IF EXISTS sp_set_atl_usr;
DELIMITER $$
	CREATE PROCEDURE sp_set_atl_usr(	
		IN Iallow varchar(80),
		IN Ihash varchar(64),
		IN Iid_atleta int(11)
    )
	BEGIN    
		CALL sp_allow(Iallow,Ihash);
		IF(@allow)THEN
            UPDATE tb_usuario SET id_atleta=Iid_atleta WHERE hash COLLATE utf8_general_ci = Ihash COLLATE utf8_general_ci;
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
					INSERT INTO tb_financeiro (id,id_usuario,descricao,valor,data) 
					VALUES (Iid,@id_call,Idescricao,Ivalor,Idata)
					ON DUPLICATE KEY UPDATE
					descricao=Idescricao, valor=Ivalor, data=Idata;                
                END IF;
            END IF;
        END IF;
	END $$
DELIMITER ;

 DROP PROCEDURE sp_view_racha;
DELIMITER $$
	CREATE PROCEDURE sp_view_racha(
		IN Iallow varchar(80),
		IN Ihash varchar(64),
        IN Iopen boolean
    )
	BEGIN
		CALL sp_allow(Iallow,Ihash);
		IF(@allow)THEN
			IF(Iopen)THEN
				SELECT * FROM tb_racha WHERE dia >= CURDATE() ORDER BY dia;
            ELSE
				SELECT * FROM tb_racha ORDER BY dia;
            END IF;
        END IF;
	END $$
	DELIMITER ;


 DROP PROCEDURE IF EXISTS sp_set_racha;
DELIMITER $$
	CREATE PROCEDURE sp_set_racha(	
		IN Iallow varchar(80),
		IN Ihash varchar(64),
		IN Iid int(11),
        IN Idia date,
		IN Iobs varchar(255)
    )
	BEGIN    
		CALL sp_allow(Iallow,Ihash);
		IF(@allow)THEN
			SET @id_call = 0;
            SET @access = -1;
            SELECT IFNULL(id,0), IFNULL(access,-1) INTO @id_call,@access FROM tb_usuario WHERE hash COLLATE utf8_general_ci = Ihash COLLATE utf8_general_ci LIMIT 1;
			IF(@access=0)THEN
				IF(Iobs="")THEN
					DELETE FROM tb_presenca WHERE id_racha=Iid;
					DELETE FROM tb_racha WHERE id=Iid;
				ELSE
					IF(Iid=0)THEN
						INSERT INTO tb_racha (id_usuario,dia,obs) 
						VALUES (@id_call,Idia,Iobs);
                    ELSE 
						UPDATE tb_racha SET dia=Idia, obs=Iobs WHERE id=Iid;
                    END IF;
                END IF;
            END IF;
        END IF;
	END $$
DELIMITER ;


 DROP PROCEDURE sp_view_presenca;
DELIMITER $$
	CREATE PROCEDURE sp_view_presenca(
		IN Iallow varchar(80),
		IN Ihash varchar(64),
        IN Iid_racha boolean
    )
	BEGIN
		CALL sp_allow(Iallow,Ihash);
		IF(@allow)THEN
			SELECT * FROM vw_presenca WHERE id_racha=Iid_racha;
        END IF;
	END $$
	DELIMITER ;

 DROP PROCEDURE IF EXISTS sp_set_presenca;
DELIMITER $$
	CREATE PROCEDURE sp_set_presenca(	
		IN Iallow varchar(80),
		IN Ihash varchar(64),
        IN Iid_atleta int(11),
		IN Iid_racha int(11)
    )
	BEGIN    
		CALL sp_allow(Iallow,Ihash);
		IF(@allow)THEN
			SET @id_call = 0;
            SET @access = -1;
            SET @id_atleta = 0;
            SELECT IFNULL(id,0), IFNULL(access,-1), IFNULL(id_atleta,0) INTO @id_call,@access,@id_atleta FROM tb_usuario WHERE hash COLLATE utf8_general_ci = Ihash COLLATE utf8_general_ci LIMIT 1;
			IF(@id_call>0)THEN
				IF(@access=0 OR @id_atleta=Iid_atleta)THEN
					SET @has = (SELECT COUNT(*) FROM tb_presenca WHERE id_racha=Iid_racha AND id_atleta=Iid_atleta);
                    IF(@has)THEN
						DELETE FROM tb_presenca WHERE id_racha=Iid_racha AND id_atleta=Iid_atleta;
                    ELSE
						INSERT INTO tb_presenca (id_usuario,id_atleta,id_racha) VALUES(@id_call,Iid_atleta,Iid_racha);
                    END IF;
				END IF;
            END IF;
        END IF;
	END $$
DELIMITER ;

 DROP PROCEDURE IF EXISTS sp_update_time;
DELIMITER $$
	CREATE PROCEDURE sp_update_time(	
		IN Iallow varchar(80),
		IN Ihash varchar(64),
		IN Iid_racha int(11),
        IN Iid_atletas varchar(50),
        IN Itime varchar(1)
    )
	BEGIN    
		CALL sp_allow(Iallow,Ihash);
		IF(@allow)THEN
			SET @quer =CONCAT('UPDATE tb_presenca SET time="',Itime,'" WHERE id_racha=',Iid_racha,' AND id_atleta IN (',Iid_atletas,');');            
			PREPARE stmt1 FROM @quer;
			EXECUTE stmt1;

        END IF;
	END $$
DELIMITER ;

 DROP PROCEDURE sp_view_jogos;
DELIMITER $$
	CREATE PROCEDURE sp_view_jogos(
		IN Iallow varchar(80),
		IN Ihash varchar(64),
        IN Iid_racha boolean
    )
	BEGIN
		CALL sp_allow(Iallow,Ihash);
		IF(@allow)THEN
			SELECT * FROM tb_jogos WHERE id_racha=Iid_racha;
        END IF;
	END $$
DELIMITER ;

 DROP PROCEDURE IF EXISTS sp_set_jogo;
DELIMITER $$
	CREATE PROCEDURE sp_set_jogo(	
		IN Iallow varchar(80),
		IN Ihash varchar(64),
        IN Iid int(11),
		IN Iid_racha int(11),
        IN Itime_1 varchar(1),
		IN Itime_2 varchar(1),
		IN Iplacar_1 int,
		IN Iplacar_2 int
    )
	BEGIN    
		CALL sp_allow(Iallow,Ihash);
		IF(@allow)THEN
			SET @id_call = 0;
            SET @access = -1;
            SELECT IFNULL(id,0), IFNULL(access,-1) INTO @id_call,@access FROM tb_usuario WHERE hash COLLATE utf8_general_ci = Ihash COLLATE utf8_general_ci LIMIT 1;
			IF(@id_call>0)THEN
				IF(@access=0)THEN
					IF(Iid=0)THEN
						INSERT INTO tb_jogos (id_usuario,id_racha,time_1,time_2,placar_1,placar_2) 
						VALUES(@id_call,Iid_racha,Itime_1,Itime_2,Iplacar_1,Iplacar_2);
					ELSE
						IF(Iplacar_1=0 AND Iplacar_2=0)THEN
							DELETE FROM tb_jogos WHERE id=Iid;
						ELSE
							UPDATE tb_jogos
							SET time_1=Itime_1,  time_2=Itime_2,  placar_1=Iplacar_1,  placar_2=Iplacar_2
							WHERE id=Iid;
						END IF;
                    END IF;
				END IF;
            END IF;
        END IF;
	END $$
DELIMITER ;


 DROP PROCEDURE sp_view_post;
DELIMITER $$
	CREATE PROCEDURE sp_view_post(
		IN Iallow varchar(80),
		IN Ihash varchar(64),
        IN Iini int
    )
	BEGIN
		CALL sp_allow(Iallow,Ihash);
		IF(@allow)THEN
			SELECT * FROM tb_post ORDER BY data_hora LIMIT Iini,10;
        END IF;
	END $$
DELIMITER ;


 DROP PROCEDURE IF EXISTS sp_set_post;
DELIMITER $$
	CREATE PROCEDURE sp_set_post(	
		IN Iallow varchar(80),
		IN Ihash varchar(64),
        IN Iid int(11),
		IN Iid_post int(11),
		IN Itexto varchar(512)
    )
	BEGIN    
		CALL sp_allow(Iallow,Ihash);
		IF(@allow)THEN
			SET @id_call = (SELECT IFNULL(id,0) FROM tb_usuario WHERE hash COLLATE utf8_general_ci = Ihash COLLATE utf8_general_ci LIMIT 1);
			IF(@id_call>0)THEN
				IF(Iid=0 AND Itexto!="")THEN
					SET @id_post = (SELECT IF (Iid_post=0,NULL,Iid_post) AS ID_POST);
					INSERT INTO tb_post (id_usuario,id_post,texto) 
					VALUES(@id_call,@id_post,Itexto);
				ELSE
					IF(Itexto="")THEN
						DELETE FROM tb_post WHERE id=Iid;
					ELSE
						UPDATE tb_post
						SET texto=Itexto
						WHERE id=Iid;
					END IF;
				END IF;
            END IF;
        END IF;
	END $$
DELIMITER ;
