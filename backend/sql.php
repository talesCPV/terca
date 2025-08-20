<?php

    $query_db = array(
        /* LOGIN */
        "LOG-0"  => 'CALL sp_login("x00", "x01");', // USER, PASS

        /* USERS */
        "USR-0"  => 'CALL sp_viewUser(@access,@hash,"x00","x01","x02");', // FIELD,SIGNAL, VALUE
        "USR-1"  => 'CALL sp_setUser(@access,@hash,x00,"x01","x02","x03",x04);', // ID, NOME, EMAIL, PASS, ACCESS

        /* ATLETAS */
        "ATL-0" => 'CALL sp_view_atleta(@access,@hash,"x00");', // NOME
        "ATL-1" => 'CALL sp_set_atleta(@access,@hash,x00,"x01","x02","x03",x04);', // id,nome,posicao,sexo,mensalista
        "ATL-2" => 'CALL sp_set_ranking(@access,@hash,x00,x01);', // ID_ATLETA, NOTA
        "ATL-3" => 'CALL sp_set_atl_usr(@access,@hash,x00);', // ID_ATLETA
        
  
        /* FINANCEIRO */
        "FIN-0" => 'CALL sp_view_extrato(@access,@hash,"x00","x01");', // DATA_INI, DATA_FIN
        "FIN-1" => 'CALL sp_set_financeiro(@access,@hash,"x00","x01","x02","x03");', // ID, DESCRIÇÃO, VALOR, DATA_HORA

        /* RACHA */
        "RCH-0" => 'CALL sp_view_racha(@access,@hash,x00);', // OPEN
        "RCH-1" => 'CALL sp_set_racha(@access,@hash,x00,"x01","x02");', // ID, DATA_HORA, OBS
        "RCH-2" => 'CALL sp_view_presenca(@access,@hash,x00);', // ID_RACHA
        "RCH-3" => 'CALL sp_set_presenca(@access,@hash,x00,x01);', // ID_ATLETA, ID_RACHA
        "RCH-4" => 'CALL sp_update_time(@access,@hash,x00,"x01","x02");', // ID_RACHA,ID_ATLETAS, TIME
        "RCH-5" => 'CALL sp_view_jogos(@access,@hash,x00);', // id_racha
        "RCH-6" => 'CALL sp_set_jogo(@access,@hash,x00,x01,"x02","x03",x04,x05);', // id,id_racha,time_1,time_2,placar_1,placar_2
        "RCH-7" => 'CALL sp_view_pontos();', 
        


        /* POST */
        "PST-0" => 'CALL sp_view_post(@access,@hash,x00);', // registro_inicial
        "PST-1" => 'CALL sp_set_post(@access,@hash,x00,x01,"x02");', // id,id_post,texto

        

    );

?>