/*/{Protheus.doc} User Function SF_SetCanhoto
    Carrega dados do set canhoto para integração
    @type User Function
    @author Lucas Mendonça
    @since 05/04/2021
    @version 1.0
    /*/
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#DEFINE CRLF CHR( 13 ) + CHR( 10 )

User Function SF_SetCanhoto(lAtualizacao)
	Local lSchedule		:= FWGetRunSchedule()
	Local aJson     := {}

	_msg('Inicio do Processo')
	// Carga do cabeçalho da nota
	aAdd(aJson, SF_MontaDados('SF2'))
	If !Empty(aJson[1][1])
		U_CRM_CONEXAO( , "NotaFiscal__c" , , aJson )
	endif

	aJson     := {}
	//Carga dos itens da nota
	aAdd(aJson, SF_MontaDados('SD2'))
	If !Empty(aJson[1][1])
		U_CRM_CONEXAO( , "ItemNotaFiscal__c" , , aJson )
	endif
	_msg('Fim do Processo')

Return aJson

/*/{Protheus.doc} User Function SF_MontaDados
    Gera os dados para exportação
    @type User Function
    @author Lucas Mendonça
    @since 04/09/2020
    @version 1.0
    /*/

Static Function SF_MontaDados(xTabela, xFilter)
	Local aTabela   := {}
	Local aDados    := {}

	Local aTabRet   := {}
	Local aDadRet   := {}

	Default xFilter := ""

	xTipo := 'JSON'

	Do Case
	Case xTabela == "SF2"
		aTabela := U_CRM_Fields( xTabela )
		xFilter := iif(Empty(xFilter), " F2_CHVNFE!=' ' AND F2_XSETCAN='S' " , xFilter )
		aDados  := SFSetCanhotoBD( aTabela, xFilter)
		aDados 	:= CarregaSetCanhoto( aDados, aTabela )
		nI		:= 2
	Case xTabela == "SD2"
		aTabela := U_CRM_Fields( xTabela )
		xFilter := iif(Empty(xFilter), " F2_XCRM != '' " , xFilter )
		aDados  := SFSetBDD2( aTabela, xFilter )
		nI		:= 1
	endCase
	aDadRet := expDado( xTipo, xTabela, aDados, xField(aTabela), aDadRet, nI)

	// aTabRet := expDado( xTipo, xTabela, aTabela )

Return { aDadRet,  aTabela[01][11][01] }

/*/{Protheus.doc} CarregaSetCanhoto
	Carrega os dados do Set Canhoto
	@type  Static Function
	@author Lucas Mendonça
	@since 05/04/2021
	@version 1.0
	/*/
Static Function CarregaSetCanhoto( aDados, xTabela )
	Local retSF := aRet := {}
	Local nX 			:= 0

	For nX := 1 to len(aDados)

		aRet := getRetXML(aDados[nX][6])

		if aRet[1] // Se houve retorno positivo
			if AttIsMemberOf(aRet[2],"CPFCNPJ_DESTINATARIO")
				aDados[nX][04]	:= Posicione("SE4",1,xFilial("SE4")+aDados[nX][04], "E4_DESCRI")
				aDados[nX][09] 	:= xGetCliente(aRet[2]:CPFCNPJ_DESTINATARIO) 	//A1_XCRM
				aDados[nX][10]	:= U_SF_GetFilialRecord(aDados[nX][01]) 		//Carrega o código da filial no crm
				aDados[nX][11]	:= aRet[2]:PEDIDO_RECEBEDOR_FEEDBACK
				aDados[nX][12]	:= aRet[2]:PEDIDO_RECEBEDOR_COMENTARIO
				aDados[nX][13]	:= aRet[2]:PEDIDO_RECEBEDOR_ASSINATURA
				aDados[nX][14]	:= aRet[2]:PEDIDO_RECEBEDOR_DOCUMENTO
				aDados[nX][15]	:= aRet[2]:PEDIDO_RECEBEDOR_AUDIO
				aDados[nX][16]	:= aRet[2]:TELEFONE_PEDIDO
				aDados[nX][17]	:= aRet[2]:DISPOSITIVO
				aDados[nX][18]	:= aRet[2]:PEDIDO_RECEBEDOR_ACEITE
				// Validação para enviar para o Sales Force
				if !Empty(aDados[nX][09]) .and. !Empty(aDados[nX][11])
					aAdd(retSf, aDados[nX])
					_msg( 'Carregando Linha ' + cValToChar(len(retSf)) + ' de ' + cValToChar(len(aDados)) )
				endif
			endif
		endif

	Next nX
Return retSF

Static Function xGetCliente(c_CNPJ)
	Local cAlias    := GetNextAlias()
	Local cQuery 	:= "SELECT A1_XCRM FROM SA1010 WHERE D_E_L_E_T_!='*' AND A1_CGC='"+c_CNPJ+"' "

	TcQuery cQuery New Alias (cAlias)

	While (cAlias)->(!EOF())
		ret_A1_XCRM := (cAlias)->(A1_XCRM)
		(cAlias)->(DBSkip())
	EndDo

	if Empty(ret_A1_XCRM) // Se não tiver A1_XCRM deve cadastrar o Cliente
		ret_A1_XCRM := U_CRM_CONEXAO(" A1_CGC = '"+c_CNPJ+"' ", "SA1")
	endif

	(cAlias)->(dbCloseArea())
Return ret_A1_XCRM


/*/{Protheus.doc} getRetXML
	Carrega dados do Set Canhoto
	@type  Static Function
	@author Lucas Mendonça
	@since 05/04/2021
	/*/
Static Function getRetXML(chvNfe, lChave, nDias)
	Local a_Ret     := {}
	Local aHeadStr	:= { "Content-Type: application/json" }
	Local oRetJSON
	Local cDataSC	:= ""
	Default lChave	:= .T.
	Default nDias	:= 1
	// Realiza o request
	oObjREST := FWRest():New( "http://casadopicapau.setcanhoto.com.br/api/canhoto/" )
	if lChave
		oObjREST:setPath( "?key=a894eb1f7ecd7d3f1aa0c1f7e4655bac&acao=get_dados_pedido&chave_nfe=" + chvNfe )
	else

		cDataSC := Dtos(Date()-nDias)
		cDataSC := Substr(cDataSC, 1,4) + '-' + Substr(cDataSC, 5,2) + '-' + Substr(cDataSC, 7,2)

		oObjREST:setPath( "?key=a894eb1f7ecd7d3f1aa0c1f7e4655bac&acao=get_dados_pedido&data_hora_inicio="+cDataSC+"%2000%3A00%3A00&data_hora_fim="+cDataSC+"%2023%3A59%3A00" )
	endif

	If oObjREST:Get( aHeadStr )
		cRetAPI    := oObjREST:GetResult()
	Else
		cRetAPI    := oObjREST:GetLastError()
	EndIf
	cStatusRet := oObjREST:oResponseH:cStatusCode
	cMessage   := oObjREST:GetResult()

	If Alltrim( cStatusRet ) = '200' //Ok
		FWJSonDeserialize( u_decode(cRetAPI), @oRetJSON )
		a_Ret   := {.t., oRetJSON:dados}
	Else
		conout("SetCanhoto - CRM :: " + Dtoc(Ddatabase) + " - " + cValtoChar(Time()) + 'Falha ao conectar ' + cMessage )
		aRet := {.f., oRetJSON}
	EndIf
Return a_Ret

/*/{Protheus.doc} SFSetBDD2
	Função copiada do fonte CRM-BD e adaptada para buscar dados à quente do Set Canhoto
	@type  Static Function
	@author Lucas Mendonça
	@since 05/04/2021
	@version 1.0
	  @param xDados, String, Nome da tabela
    @param xFilter, String, Conteúdo do Filtro
    @return aDados, Array, Conteúdo da query
    
	/*/
Static Function SFSetBDD2( xDados, xFilter, lAtualizacao )
	Local aDados    := {}
	Local aTmp      := {}
	Local cCampos   := ""
	Local cAlias    := GetNextAlias()

	Local cQuery    := ""

	Local nX        := 0

	For nX := 1 to len(xDados)
		if at('__',xDados[nX][2]) <= 0
			cCampos += xDados[nX][2]
		elseif xDados[nX][2] == "Descricao__c"
			cCampos += " ( SELECT B1_DESC FROM SB1010 WHERE D_E_L_E_T_ != '*' AND B1_COD = D2_COD ) AS " + xDados[nX][2]
		else
			cCampos += "' '"+ xDados[nX][2]
		endIF
		cCampos += IIF(nX < Len(xDados),", ","")
	Next nX

	cQuery += " SELECT TOP 100 " + cCampos
	cQuery += " FROM "   + xDados[ 01 ][ 10 ] + " A "
	cQuery += " INNER JOIN SF2010 B ON F2_FILIAL = D2_FILIAL AND F2_DOC = D2_DOC AND F2_SERIE = D2_SERIE "

	cQuery += " WHERE A.D_E_L_E_T_!='*' AND B.D_E_L_E_T_!='*' " + " AND "

	if !lAtualizacao
		cQuery += IIF( SUBSTR( xDados[1][10], 1, 1 )=="S", Substr( xDados[1][10], 2, 2 ), Substr( xDados[1][10], 1, 3 ) )  + "_XCRM = ' ' "
	else
		cQuery += IIF( SUBSTR( xDados[1][10], 1, 1 )=="S", Substr( xDados[1][10], 2, 2 ), Substr( xDados[1][10], 1, 3 ) )  + "_XCRM != ' ' "
	endif
	if ( !Empty( xFilter ) )
		cQuery += " AND " + xFilter
	endIf
	cQuery += " ORDER BY A.R_E_C_N_O_ DESC "

	TcQuery cQuery New Alias (cAlias)

	While (cAlias)->(!EOF())
		For nX := 1 to len( xDados )
			aAdd(aTmp, (cAlias)->(&(xDados[nX][02])))
		Next nX
		aAdd(aDados, aTmp)
		aTmp := {}
		(cAlias)->(DBSkip())
	EndDo
	(cAlias)->(dbCloseArea())
Return aDados

/*/{Protheus.doc} SFSetCanhotoBD
	Função copiada do fonte CRM-BD e adaptada para buscar dados à quente do Set Canhoto
	@type  Static Function
	@author Lucas Mendonça
	@since 05/04/2021
	@version 1.0
	  @param xDados, String, Nome da tabela
    @param xFilter, String, Conteúdo do Filtro
    @return aDados, Array, Conteúdo da query
    
	/*/
Static Function SFSetCanhotoBD( xDados, xFilter, lAtualizacao )
	Local aDados    := {}
	Local aTmp      := {}
	Local cCampos   := ""
	Local cAlias    := GetNextAlias()

	Local cQuery    := ""

	Local nX        := 0
	Default lAtualizacao := .F.

	For nX := 1 to len(xDados)
		if at('__',xDados[nX][2]) <= 0
			cCampos += xDados[nX][2]+ IIF(nX < Len(xDados),", ","")
		else
			cCampos += "' '"+ xDados[nX][2]+ IIF(nX < Len(xDados),", ","")
		endIF
	Next nX

	cQuery += " SELECT TOP 20 " + cCampos
	cQuery += " FROM "   + xDados[ 01 ][ 10 ]
	cQuery += " WHERE D_E_L_E_T_!='*' " + " AND "
	cQuery += " F2_EMISSAO >= '20210301' AND "
	if !lAtualizacao
		cQuery += IIF( SUBSTR( xDados[1][10], 1, 1 )=="S", Substr( xDados[1][10], 2, 2 ), Substr( xDados[1][10], 1, 3 ) )  + "_XCRM = ' ' "
	else
		cQuery += IIF( SUBSTR( xDados[1][10], 1, 1 )=="S", Substr( xDados[1][10], 2, 2 ), Substr( xDados[1][10], 1, 3 ) )  + "_XCRM != ' ' "
	endif
	if ( !Empty( xFilter ) )
		cQuery += " AND " + xFilter
	endIf
	cQuery += " ORDER BY R_E_C_N_O_ DESC "

	TcQuery cQuery New Alias (cAlias)

	While (cAlias)->(!EOF())
		For nX := 1 to len( xDados )
			aAdd(aTmp, (cAlias)->(&(xDados[nX][02])))
		Next nX
		aAdd(aDados, aTmp)
		aTmp := {}
		(cAlias)->(DBSkip())
	EndDo
	(cAlias)->(dbCloseArea())
Return aDados

/*/{Protheus.doc} expDado
    Exporta os dados para leitura externa
    @type  Static Function
    @author Lucas Mendonça
    @since 04/09/2020
    @version 1.0
    @param xTipo, String, Tipo Exportação
    @param xArray, Array, Array com os dados
    @param aCampos, Array, Array com os cabeçalhos dos campos
    @return xRet, x, Variavel com o retorno
    /*/
Static Function expDado(xTipo, xTitulo, xArray, aCampos, xRet, _n)
	Local Linha := ""
	Local nX    := 0
	Default aCampos := {"Tabela", "Campo", "Titulo", "Descrição", "Tamanho", "Picture", "Opções", "Obrigatório", "Ajuda", "TabSQL", "CamposSF"}

	xRet := {}
	For nX := 1 to len(xArray)
		For nI := _N to len(xArray[nX])
			// oJson := JsonObject():New()
			if !Empty(xArray[nX][nI])
				if ValType(xArray[ nX ][ nI ]) != "N"
					if Alltrim(xArray[ nX ][ nI ]) $ 'true/false' .or. aCampos[nI][02] == "L"
						Linha += '"'+aCampos[nI][01]+'": '+ xArray[ nX ][ nI ] + IIF(nI < Len(xArray[nX]),', ',' ')
					else
						Linha += '"'+aCampos[nI][01]+'": "'+ TrataCampo(xArray[nX][nI], aCampos, nI, xTipo, aCampos[nI][02]) + IIF(nI < Len(xArray[nX]),'", ','" ')
					endif
				else
					if Upper('Hora') $ Upper(aCampos[nI][01]) // 10:11:00.000Z
						Linha += '"'+aCampos[nI][01]+'": "'+ TrataCampo(xArray[nX][nI], aCampos, nI, xTipo, aCampos[nI][02]) + IIF(nI < Len(xArray[nX]),'", ','"')
					else
						Linha += '"'+aCampos[nI][01]+'": '+ TrataCampo(xArray[nX][nI], aCampos, nI, xTipo, aCampos[nI][02]) + IIF(nI < Len(xArray[nX]),', ','')
					endif
				endif
			endif
		Next nI
		// xRet    += '"' + cValToChar( nX ) + '": {'+ Linha + '} '
		// xRet    += ' {'+ Linha + '} ' + IIF(nX < Len(xArray),', ','')
		aAdd(xRet, '{'+ iIf( Right( AllTrim( Linha ), 1 ) = ",", Substr( Linha, 1, Len( Linha ) - 2 ), Linha ) + '}' )
		Linha   := ""
	Next nX


Return xRet

/*/{Protheus.doc} RetNameField
	/*/
Static Function RetNameField(aCampos)
	Local nX := 0
	Local aRet := {}
	For nX:= 1 to Len(aCampos)
		aAdd(aRet,aCampos[nX][1])
	next nX
Return aRet

/*/{Protheus.doc} TrataCampo
    Trata o dado do campo para retornar em String o dado
    @type  Static Function
    @author Lucas Mendonça
    @since 08/09/2020
    @version 1.0
    @param Campo, String, String contendo os dados do campo
    @param aCampos, Array, Cabeçalho dos campos
    @param Nx, Numérico, Posição do String
    @return cRet, String, String contendo os dados do campo
  
    /*/
Static Function TrataCampo(Campo, aCampos, nX, xTipo, TipoCampo)
	Local cRet      := ""
	Local nJ        := 1
	Local aTemp     := {}
	// if ValType(Campo) == "C"
	if TipoCampo == "C"
		if Upper(aCampos[nX][1]) == Upper("Name")
			cRet := Alltrim(Campo)
		else
			cRet := u_xSemCarc(Alltrim(Campo))
		endif
		// elseif ValType(Campo) == "N"
	elseif TipoCampo == "N"
		if Upper('Hora') $ Upper(aCampos[nX][01]) // 10:11:00.000Z
			cRet := Transform(iif(len(cValToChar(Campo))=3,"0"+cValToChar(Campo),cValToChar(Campo)), "@R XX:XX")+":00.000Z"
		else
			cRet := cValToChar(Campo)
		endif
		// elseif ValType(Campo) == "D"
	elseif TipoCampo == "D"
		cRet := substr(campo,1,4)+'-'+substr(campo,5,2)+'-'+substr(campo,7,2) //2020-08-03
		// elseif ValType(Campo) == "L"
	elseif TipoCampo == "L"
		cRet := iif(Campo=="1","true","false")
		// elseif ValType(Campo) == "A"
	elseif TipoCampo == "X"
		cRet := Campo
		// elseif ValType(Campo) == "A"
	elseif TipoCampo == "A"
		aTemp := Campo
		For nJ := 1 to len(aTemp)
			cRet += '"'+ aCampos[nX] +'": "'+ cValToChar(aTemp[nJ]) + IIF(nJ < Len(aTemp),'", ','')
		Next nJ
		if xTipo == "JSON"
			cRet := "{ " + cRet + " }"
		endif
	endif
Return cRet

/*/{Protheus.doc} xField
    Carrega os campos da tabela
    @type  Static Function
    @author Lucas Mendonça
    @since 08/09/2020
    @version 1.0
    @param aTabela, Array, Array contendo a configuração de campos
    @return aRet, Array, Retorno só com os campos
    /*/
Static Function xField(aTabela)
	Local aRet  := {}
	Local nX    := 1
	For nX := 1 to len(aTabela)
		if !Empty(aTabela[nX][11]) .and. !Empty(aTabela[nX][05])
			aAdd(aRet, {aTabela[nX][11][02], aTabela[nX][05][03]})
		EndIf
	Next nX
Return aRet

Static Function SchedDef()
	Local aOrd   := {}
	Local aParam := {}
	aParam := {"P" , ; //Tipo R para relatorio P para processo
	""             , ; //Pergunte do relatorio, caso nao use passar ParamDef
	""             , ; //Alias
	aOrd           , ; //Array de ordens
	}
Return aParam

Static Function _msg(msg)
	ConOut(' [SF-SetCanhoto] - '+ Dtoc( Date() ) + ' - '+ cValToChar( Time() ) +' '+ msg )
Return nil


/*/{Protheus.doc} User Function xPL_SetCanhoto
	(long_description)
	@type  Function
	@author user
	@since 27/04/2021
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	/*/
User Function xPL_SetCanhoto()

	Local a_Ret 	:= {}
	Local nX 		:= nI	:= 0
	Local nTam		:= 0
	Local xTabela 	:= "SF2"
	Local aTabela 	:= U_CRM_Fields( xTabela )

	For nX := 1 to 70
		a_Ret 	:= getRetXML( , .F., nX )
		nTam 	:= Len( a_Ret[2] )

		if a_Ret[1]
			for nI := 1 to len(a_Ret[2]) // A cada linha do Retorno do SetCanhoto
				_msg( "Processando linha " + cValToChar(nX) + " de " + cValToChar(nTam) )

				aDados  := SFSetCanhotoBD( aTabela, " F2_CHVNFE='" + a_Ret[2]:chave_nfe + "' ")

				aRet := a_Ret[nX]

				if aRet[1] // Se houve retorno positivo
					if AttIsMemberOf(aRet[2],"CPFCNPJ_DESTINATARIO")
						aDados[nX][04]	:= Posicione("SE4",1,xFilial("SE4")+aDados[nX][04], "E4_DESCRI")
						aDados[nX][09] 	:= xGetCliente(aRet[2]:CPFCNPJ_DESTINATARIO) 	//A1_XCRM
						aDados[nX][10]	:= U_SF_GetFilialRecord(aDados[nX][01]) 		//Carrega o código da filial no crm
						aDados[nX][11]	:= aRet[2]:PEDIDO_RECEBEDOR_FEEDBACK
						aDados[nX][12]	:= aRet[2]:PEDIDO_RECEBEDOR_COMENTARIO
						aDados[nX][13]	:= aRet[2]:PEDIDO_RECEBEDOR_ASSINATURA
						aDados[nX][14]	:= aRet[2]:PEDIDO_RECEBEDOR_DOCUMENTO
						aDados[nX][15]	:= aRet[2]:PEDIDO_RECEBEDOR_AUDIO
						aDados[nX][16]	:= aRet[2]:TELEFONE_PEDIDO
						aDados[nX][17]	:= aRet[2]:DISPOSITIVO
						aDados[nX][18]	:= aRet[2]:PEDIDO_RECEBEDOR_ACEITE
						// Validação para enviar para o Sales Force
					endif
				endif
			next nI
		endif
	Next nX

	nI		:= 2
	aDadRet := expDado( xTipo, xTabela, aDados, xField(aTabela), aDadRet, nI)
	aAdd(aJson, { aDadRet,  aTabela[01][11][01] })
	_msg("Carregou os dados" )

	If !Empty(aJson[1][1])

		_msg("Enviando para CRM_CONEXAO: " + cValToChar(nX) + " de " + cValToChar(nTam) )
		U_CRM_CONEXAO( , "NotaFiscal__c" , , aJson )

	endif
	_msg( "Resetando variáveis e reiniciando o processo" )
	aJson := {}
Return


User Function Wal
	Local aRet := getRetXML( , .F., 1 )
Return
