<?php

    $query_db = array(
        /* LOGIN */
        "LOG-0"  => 'CALL sp_login("x00", "x01");', // USER, PASS

        /* USERS */
        "USR-0"  => 'CALL sp_viewUser(@access,@hash,"x00","x01","x02");', // FIELD,SIGNAL, VALUE
        "USR-1"  => 'CALL sp_setUser(@access,@hash,x00,"x01","x02","x03",x04);', // ID, NOME, EMAIL, PASS, ACCESS
        "USR-2"  => 'CALL sp_updatePass(@hash,"x00","x01");', // NOME, PASS
        "USR-3"  => 'CALL sp_check_usr_mail(@hash);',

        /* CALENDAR */
        "CAL-0"  => 'CALL sp_view_calendar(@hash,"x00","x01");', // DT_INI, DT_FIN
        "CAL-1"  => 'CALL sp_set_calendar(@hash,"x00","x01");', // DT_AGD, OBS

        /* MAIL */
        "MAIL-0"  => 'CALL sp_set_mail(@hash,"x00","x01");', // ID_TO, MESSAGE
        "MAIL-1"  => 'CALL sp_view_mail(@hash,x00);', // I_SEND
        "MAIL-2"  => 'CALL sp_all_mail_adress(@hash);', //      
        "MAIL-3"  => 'CALL sp_del_mail(@hash,"x00",x01,x02);', // DATA, ID_FROM, ID_TO
        "MAIL-4"  => 'CALL sp_mark_mail(@hash,"x00",x01,x02);', // DATA, ID_FROM, ID_TO

        /* SYSTEMA */
        "SYS-0"  => 'CALL sp_set_usr_perm_perf(@access,@hash,x00,"x01");', // ID, NOME
        "SYS-1"  => 'CALL sp_view_usr_perm_perf(@access,@hash,"x00","x01","x02");', // FIELD,SIGNAL, VALUE

        /* CLIENTES */
        "CLI-0"  => 'CALL sp_view_cli(@access,@hash,"x00","x01","x02");', // FIELD,SIGNAL, VALUE
        "CLI-1"  => 'CALL sp_set_cli(@access,@hash,x00,"x01","x02","x03","x04","x05","x06","x07","x08","x09","x10","x11","x12","x13","x14","x15");', // id,razao_social,fantasia,cnpj,ie,im,end,num,comp,bairro,cidade,uf,cep,ramo,tel,email
        "CLI-2"  => 'CALL sp_set_user_cli(@access,@hash,x00,x01);', // ID_USER, ID_CLIENTE
        "CLI-3"  => 'CALL sp_view_cli_user(@access,@hash,x00);', // ID, SE id=0(traz todas as empresas do usuário que esta chamando)

        /* PRODUTOS */
        "PROD-0"  => 'CALL sp_view_prod(@access,@hash,"x00");', // Nome
        "PROD-1"  => 'CALL sp_set_prod(@access,@hash,x00,"x01","x02","x03");', // id,nome,valor,sobre
        "PROD-2"  => 'CALL sp_view_escopo(@access,@hash,x00);', // ID_PROD
        "PROD-3"  => 'CALL sp_set_escopo(@access,@hash,x00,x01,"x02","x03");', // id,id_prod,nome,texto
        "PROD-4"  => 'CALL sp_up_escopo(@access,@hash,x00,x01);', // id, id_prod
        "PROD-5"  => 'CALL sp_view_cli_prod(@access,@hash,x00,x01);', // ID, ID=(0-id_prod 1-ID_cliente)
        "PROD-6"  => 'CALL sp_set_prod_cli(@access,@hash,x00,x01);', // ID_PRODUTO, ID_CLIENTE

        /* TAREFAS */
        "TASK-0" => 'CALL sp_view_task(@access,@hash,"x00","x01","x02");', // FIELD,SIGNAL, VALUE
        "TASK-1" => 'CALL sp_set_task(@access,@hash,x00,x01,"x02","x03");', // ID, ID_PROD, NOME, DESCRIÇÃO
        "TASK-2" => 'CALL sp_view_quest(@access,@hash,"x00","x01","x02");', // FIELD,SIGNAL, VALUE
        "TASK-3" => 'CALL sp_set_quest(@access,@hash,x00,x01,"x02","x03",x04,x05);', // ID, ID_TAREFA, TITULO, PERGUNTA, RELATORIO,SUB_ITEM
        "TASK-4" => 'CALL sp_view_answer(@access,@hash,x00,x01);', // ID_PERGUNTA, ID_TASK_CLI
        "TASK-5" => 'CALL sp_set_answer(@access,@hash,x00,x01,"x02","x03");', // ID_PERGUNTA, ID_TASK_CLI, RESPOSTA,DATA_HORA
        "TASK-6" => 'CALL sp_set_like(@access,@hash,x00,"x01");', // ID_PERGUNTA,DATA_HORA
        "TASK-7" => 'CALL sp_view_task_cli(@access,@hash,x00,x01);', // ID_CLIENTE, ID_PRODUTO
        "TASK-8" => 'CALL sp_set_task_cli(@access,@hash,x00,x01,x02,"x03","x04");', // ID, ID_TASK, ID_CLIENTE, TITULO, COD
        "TASK-9" => 'CALL sp_view_main_answer(@access,@hash,x00);', // ID_TASK_CLI
        "TASK-10" => 'CALL sp_view_task_rev(@access,@hash,x00);', // ID_TASK_CLI
        "TASK-11" => 'CALL sp_set_task_rev(@access,@hash,x00,x01,"x02","x03","x04","x05");', // ID_TASK_CLI, REVISÃO, HISTORICO, ELABORAÇÃO, APROVAÇÃO, DATA
        "TASK-12" => 'CALL sp_view_task_setor(@access,@hash,x00);', // ID_TASK_CLI
        "TASK-13" => 'CALL sp_set_task_setor(@access,@hash,x00,"x01",x02);', // ID_TASK_CLI, SETOR, DEL
        
        /* ORÇAMENTOS */
        "ORC-0"  => 'CALL sp_view_orc(@access,@hash,"x00","x01");', // DT_INI, DT_FIN
        "ORC-1"  => 'CALL sp_set_orc(@access,@hash,x00,x01,"x02","x03","x04");', // id,id_cli,capa,data,valor
        "ORC-2"  => 'CALL sp_orc_set_item(@access,@hash,x00,x01,"x02");', // id_orc,id_prod,valor
        "ORC-3"  => 'CALL sp_orc_view_item(@access,@hash,x00);', // id_orc
        "ORC-4"  => 'CALL sp_view_texto(@access,@hash,"x00");', // titulo
        "ORC-5"  => 'CALL sp_set_texto(@access,@hash,x00,"x01","x02","x03");', // id,titulo,texto,valor
        "ORC-6"  => 'CALL sp_orc_set_texto(@access,@hash,x00,x01,"x02");', // id_orc,id_texto,valor
        "ORC-7"  => 'CALL sp_orc_view_texto(@access,@hash,x00);', // id_orc
        "ORC-8"  => 'CALL sp_up_texto(@access,@hash,x00);', // id

        /* LEGISLAÇÂO */
        "NOR-0"  => 'CALL sp_view_normas(@access,@hash,"x00");', // nome
        "NOR-1"  => 'CALL sp_set_norma(@access,@hash,x00,"x01","x02");', // id,nome,sobre
        "NOR-2"  => 'CALL sp_view_leis(@access,@hash,"x00","x01","x02");', // FIELD,SIGNAL, VALUE
        "NOR-3"  => 'CALL sp_set_lei(@access,@hash,x00,"x01","x02","x03","x04","x05","x06");', // id,nome,esfera,assunto,resumo,aplicabilidade,link
        "NOR-4"  => 'CALL sp_set_norma_cli(@access,@hash,x00,x01);', // ID_NORMA, ID_CLIENTE
        "NOR-5"  => 'CALL sp_view_cli_norma(@access,@hash,x00,x01);', // ID, ID=(0-id_norma 1-ID_cliente)
        "NOR-6"  => 'CALL sp_set_norma_lei(@access,@hash,x00,x01);', // ID_NORMA, ID_LEI
        "NOR-7"  => 'CALL sp_view_norma_lei(@access,@hash,x00,x01);', // ID, ID=(0-id_norma 1-ID_lei)
        "NOR-8"  => 'CALL sp_set_tarefa(@access,@hash,x00,x01,"x02",x03);', // ID,ID_LEI, PERGUNTA, Conhecimento (0-NÃO, 1-SIM)
        "NOR-9"  => 'CALL sp_view_tarefas(@access,@hash,x00);', // ID_LEI
        "NOR-10"  => 'CALL sp_valida_norma_cli(@access,@hash,x00,x01,"x02");', // ID_NORMA, ID_CLIENTE, EXPIRA (datetime)

        /* ELEVATE */
        "ELE-0"  => 'CALL sp_view_check_tarefa(@access,@hash,x00,x01);', // id_cli, id_norma
        "ELE-1"  => 'CALL sp_set_check_task(@access,@hash,x00,x01,x02,x03,"x04","x05");', // id_cliente,id_tarefa,ok,nao_aplica,obs,validade
        "ELE-2"  => 'CALL sp_view_cli_leis(@access,@hash,x00,x01);', // id_cliente,id_norma

        /* PAGAMENTO */
        "PGT-0" => 'CALL sp_view_pgto(@access,@hash,x00,x01);', // id_norma, id_plano
        "PGT-1" => 'CALL sp_set_pgto(@access,@hash,x00,x01,"x02",x03);', // id_norma,id_cliente,valor,meses
        "PGT-2" => 'CALL sp_view_pgto_plano(@access,@hash,"x00");', // nome do plano
        "PGT-3" => 'CALL sp_set_pgto_plano(@access,@hash,x00,"x01",x02,"x03","x04");', // id,nome,cred_mes,valor,texto

        

    );

?>