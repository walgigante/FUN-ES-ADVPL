#include 'TOTVS.CH'


User Function UsrBlock()
Local nx
Local aAllusers := FWSFALLUSERS({"000002"})
Local cUser := "000002"


RPCSetEnv("T1", "M SP 01") 
For nx := 1 To Len(aAllusers)
    conout(aAllusers[nx][5] + " -" + aAllusers[nx][7])
Next

PswBlock(cUser)

Return
