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
  

    );

?>