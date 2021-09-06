#INCLUDE "PROTHEUS.CH"

//Array contendo tradu��o
Static aTranslate := {}

#DEFINE __VERSION "v1.0"

//---------------------------------------------------------------------
/*/{Protheus.doc} Translate
Rotina did�tica para traduzir textos.
O seu funcionamento depender� da p�gina do Google Translate
Testado no dia 23/03/2012
en|de | Ingl�s para Alem�o
en|es | Ingl�s para Espanhol
en|fr | Ingl�s para Franc�s
en|it | Ingl�s para Italiano
en|pt | Ingl�s para Portugu�s
de|en | Alem�o para Ingl�s
de|fr | Alem�o para Franc�s
es|en | Espanhol para Ingl�s
fr|en | Franc�s para Ingl�s
fr|de | Franc�s para Alem�o
it|en | Italiano para Ingl�s
pt|en | Portugu�s para Ingl�s
Etc...
@author Vitor Emanuel Batista
@since 18/01/2012
@version MP10
@return Nil
/*/
//---------------------------------------------------------------------
User Function Translate()
	Local oDlg
	Local cText := Space(100)
	Local cResult := ""
	Local aLang := {'pt|en=Portugu�s x Ingl�s','en|pt=Ingles x Portug�s','pt|es=Portugu�s x Espanhol','es|pt=Espanhol x Portugu�s','es|en=Espanhol x Ingl�s'}
	Local cLang := aLang[1]

	Local oFont := TFont():New('Courier new',,-18,.T.,.T.)

	DEFINE MSDIALOG oDlg TITLE __VERSION+' Tradutor de textos utilizando Google Translate' FROM 0,0 TO 225,600 PIXEL

	@ 05,05 Say "Tradutor" OF oDlg Font oFont Color 3754973 Pixel

	//Combobox contendo tradu��es poss�veis
	@ 05,150 Combobox oLang Var cLang Items aLang Size 75,50 Of oDlg Pixel	

	//Bot�o com CSS para apresentar a tradu��o no MultiLine da esquerda
	@ 03, 230 Button oTranslate Prompt "Traduzir" Action Translate(cLang,cText,@cResult) Size 40,16 Pixel  
	oTranslate:SetCss("QPushButton{ border-radius: 3px;border: 1px solid #4D90FE; color: #FFFFFF; background-color: #3079ED;  }")

	//Linha para dividir
	@ 20,0 To 21.5,300 Of oDlg COLOR CLR_BLACK,CLR_BLACK DESIGN pixel

	//Multiline para escrever texto a ser traduzido
	@ 30 , 005 Get oText Var cText MultiLine Size 140,80 Pixel

	//Multiline com a tradu��o do texto
	@ 30 , 152 Get cResult MultiLine Size 140,80 NO MODIFY COLOR CLR_BLACK,CLR_BLUE Pixel
	ACTIVATE MSDIALOG oDlg CENTERED
Return 
//---------------------------------------------------------------------
/*/{Protheus.doc} Translate
Converte HTML do HTTPGET para a tradu��o da lingua escolhida 
@param cLang Lingua escolhida
@param cTexto Texto para tradu��o
@author Vitor Emanuel Batista
@since 18/01/2012
@version MP10
@return Nil
/*/
//---------------------------------------------------------------------
Static Function Translate(cLang,cText,cResult)
	Local nTranslate
	Local cTranslate := ""
	Local cLink, cHtml

	// Transforma espa�os em branco para URL Encoding
	cText := StrTran(cText," ","%20")

	// Transforma ENTER para URL Encoding
	cText := StrTran(cText,CRLF,"%0A")

	// Link do Google para traduzir texto na lingua escolhida 
	cLink := "http://translate.google.com/translate_t?text="+AllTrim(cText)+"&langpair="+AllTrim(cLang)
	// Emula um client HTTP, retornando p�gina HTML	
	cHtml := HTTPGET(cLink)

	If ValType(cHtml) <> "C"
		cResult := ""
		Alert("ERRO NA REQUISI��O AO SERVIDOR GOOGLE")
		Return 	
	EndIf

	ConvertHtml(cHtml)
	// Processa array contendo a tradu��o
	For nTranslate := 1 To Len(aTranslate)
		cTranslate += aTranslate[nTranslate] + CRLF
	Next nTranslate
	// Limpa array de tradu��o para uma pr�xima utiliza��o
	aTranslate := {}
	cResult := cTranslate 
Return 
//---------------------------------------------------------------------
/*/{Protheus.doc} ConvertHtml
Converte HTML do HTTPGET para a tradu��o da lingua escolhida 
@author Vitor Emanuel Batista
@since 18/01/2012
@version MP10
@return Nil
/*/
//---------------------------------------------------------------------
Static Function ConvertHtml(cHtml)
	Local nAt

	nAt := At("result_box",cHtml)
	cHtml := SubStr(cHtml,nAt)
	nAt := At(">",cHtml)+1
	cHtml := SubStr(cHtml,nAt)
	nAt := At(">",cHtml)+1
	cHtml := SubStr(cHtml,nAt)
	nAt := At("<",cHtml)-1

	// Adiciona linha de tradu��o na array
	aAdd(aTranslate,SubStr(cHtml,1,nAt))

	// Verifica se h� mais linhas de tradu��o
	If SubStr(cHtml,nAt+1,4) == "<br>"		
		ConvertHtml(SubStr(cHtml,nAt+5))
	EndIf

Return