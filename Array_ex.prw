User Function Exemplo()
  Local nCont 	 
  Local nTotal	
  Local aExemplo := Nil
  Local cMensagem := "A quantidade de caracter consultado é : "
  
  
  RpcSetEnv( '01' , '01' )
  //+----------------------------------------------------------------------------+
  //|Exemplifica o uso da função Array                                           |
  //+----------------------------------------------------------------------------+
  aExemplo := Array(8, 8)
  aExemplo[1] := {"W", "K", "S", "U", "I", "M", "A"}
  aExemplo[2] := {"Ç", "X", "D", "F", "B", "N", "X"}
  aExemplo[3] := {"D", "P", "E", "G", "G", "H", "B"}
  aExemplo[4] := {"N", "A", "K", "M", "R", "E", "H"}
  aExemplo[5] := {"R", "H", "Z", "Y", "P", "T", "Y"}
  aExemplo[6] := {"K", "X", "A", "K", "J", "L", "U"}
  aExemplo[7] := {"M", "S", "C", "V", "P", "O", "O"}
  aExemplo[8] := {"!", "!", "C", "V", "P", "O", "O"}
 // cMensagem += cValToChar(aExemplo[7][4])
  //cMensagem += cValToChar(aExemplo[7][6])
 // cMensagem += cValToChar(aExemplo[7][3])
 // cMensagem += cValToChar(aExemplo[4][6])
  //cMensagem += cValToChar(aExemplo[5][5])
  //cMensagem += cValToChar(aExemplo[6][6])
  //cMensagem += cValToChar(aExemplo[7][7])
  
  //+------------------condição ASCAN--------------------------------------------+
  
  
  //+----------------------------------------------------------------------------+
  //|Apresenta uma mensagem com os resultados obtidos                            |
  //+----------------------------------------------------------------------------+
  //MsgInfo(cMensagem, cValToChar(aExemplo[1][1]))

  //MsgInfo(cMensagem)
  MsgAlert(CVALTOCHAR(Ascan(aExemplo[1],"A",)))
  
Return