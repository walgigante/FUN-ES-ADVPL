#include 'protheus.ch'
#include 'parmtype.ch'

user function gatSN()

	Local cRet := M->N1_QUANTD 

	//If N3_YQTD == '000001'
		//TMP1->(dbGotop())
		//While TMP1->( !Eof() )
		//	TMP1->CK_DESCRI := 'CLIENTE 1'
		//	TMP1->(dbSkip())
		//EndDo
//	Else
	//	TMP1->(dbGotop())
		//While TMP1->( !Eof() )
			//TMP1->CK_DESCRI := ''
			//TMP1->(dbSkip())
		//EndDo
	//EndIf

	//TMP1->(dbGotop())

	oGetDad:oBrowse:Refresh()

Return cRet


