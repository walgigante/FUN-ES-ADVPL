#include "protheus.ch"

User Function Exemplo_ind()

    Local cArquivo
    Local cChave
    Local cFor
    Local nIndex

    DbSelectArea("SA1")
        cArquivo := CriaTrab(,.F.)
        cChave := "A1_NOME"
        cFor := "!Empty(A1_NOME)"
    IndRegua("SA1",cArquivo,cChave,,cFor)

    DbSelectArea("SA1")

    nIndex := RetIndex("SA1")

    #IFNDEF TOP  
        DbSetIndex(cArquivo+OrdBagExt())
    #ENDIF

    DbSetOrder(nIndex+1)
    DbSelectArea("SA1")
    RetIndex("SA1")
    FErase(cArquivo+OrdBagExt())

Return
