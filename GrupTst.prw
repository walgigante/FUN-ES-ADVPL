#INCLUDE "TOTVS.CH"
 
User function grpUsr()
   Local aGrp := {}
   Local cUser := CUSERNAME
   Local cCodUser := __CUSERID

   aGrp := UsrRetGrp(CUSERNAME,__CUSERID)

   msginfo("Código do grupo = "+aGrp[1])

Return