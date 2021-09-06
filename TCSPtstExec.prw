#include 'TOTVS.CH'

USER FUNCTION TCSPtstExec()

Local aResult := {}

    RpcSetEnv("T1", "M SP 01 ")
    aResult := TCSPEXEC("USRTESTE", 100)
 
IF empty(aResult)
    Conout('Erro na execução da Stored Procedure : '+TcSqlError())
Else
    Conout("Retorno String : "+aResult[1])
    Conout("Retorno Numerico : "+str(aResult[2]))
    MsgInfo("Procedure Executada")
Endif
 
Return

