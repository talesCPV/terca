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
        

    );

?>