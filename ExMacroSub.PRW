#INCLUDE 'TOTVS.CH'

USER Function ExMacroSub()
    
    Local nX        := 10 
    Local cY        := "nX + 1"
    Local nResult   := &cY // Macro Substituição, utilizada para realizar a soma de uma variavel caracter com uma variavel numerica
    Local cMsg      := "O resultado é : " // Mensagem de exibição

    MsgAlert(cMsg + CVALTOCHAR(nResult))

Return 
