#INCLUDE 'TOTVS.CH'


/*/{Protheus.doc} CTFI002P
Consulta Movimenta豫o Financeira.
@author Cristiano de Souza Orbem/Geanderson Silva
@since 15/09/2016
@version 1.0
@type function
/*/
User Function CTFI002P(p_cFilial, p_cPREF, p_cNUM, p_cParc ,p_cTIPO ,p_cClient, p_cLoja,p_lMsg)

	/*컴컴컴컴컴컴컨컴컴컴컴좔컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂?
	굇 Declara豫o de cVariable dos componentes                                 굇
	袂굼컴컴컴컴컴컴컴좔컴컴컴컨컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?/
	Local nOpc 	   	:= GD_INSERT+GD_DELETE+GD_UPDATE
	Local cFatTit  	:= "" // 2 - E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO                                                                                               
	Local lFat     	:= .F.
	Local nLinIni  	:= 0
	Local nLinFim  	:= 0
	Local nPosBtn  	:= 0
	Local nX 		:= 0
	Local cTabFinc 	:= ""
	Local aArea    	:= GetArea()
	
	Private aCoGdFI002P := {}
	Private aHoGdFI002P := {}
	Private nLinGrid  := 0

	If U_ISPROCCALL("Finc010")

		oTmpDlg    := GetWndDefault()
		oTmpDlg:bvalid := {|| SetKey(K_ALT_F1, Nil)}
		For nX := 1 to Len(oTmpDlg:aControls)
			If ValType(oTmpDlg:aControls[nX]) = 'O' .and.  Upper(AllTrim(oTmpDlg:aControls[nX]:ClassName())) = 'BRGETDDB'
				cTabFinc :=	oTmpDlg:aControls[nX]:CALIASTRB
				Exit
			EndIf
		Next

		p_cFilial  	:= (cTabFinc)->E1_MSFIL
		p_cPREF		:= (cTabFinc)->E1_PREFIXO 
		p_cNUM 		:= (cTabFinc)->E1_NUM
		p_cParc 	:= (cTabFinc)->E1_PARCELA
		p_cTIPO 	:= (cTabFinc)->E1_TIPO
		p_cClient	:= (cTabFinc)->E1_CLIENTE
		p_cLoja		:= (cTabFinc)->E1_LOJA

	EndIf
	
	cFatTit  := Posicione("SE1", 2, xFilial("SE1") + p_cClient + p_cLoja + p_cPREF + p_cNUM + p_cParc + p_cTIPO, "E1_FATURA")

	/*Verifica se titulo ?uma fatura*/
	If Empty(cFatTit) .Or.  RTRIM(UPPER(cFatTit)) <> "NOTFAT" 
		lFat  := .F.
	Else
		lFat := .T.
		nLinIni  := 250
		nLinFim  := 50
		nPosBtn  := 135
	Endif

	/*컴컴컴컴컴컴컨컴컴컴컴좔컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂?
	굇 Declara豫o de Variaveis Private dos Objetos                             굇
	袂굼컴컴컴컴컴컴컴좔컴컴컴컨컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?/
	SetPrvt("oDlgFI002P","oGdFI002P","oPFat","oGridFat")

	/*컴컴컴컴컴컴컨컴컴컴컴좔컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂?
	굇 Definicao do Dialog e todos os seus componentes.                        굇
	袂굼컴컴컴컴컴컴컴좔컴컴컴컨컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?/
	oDlgFI002P      	:= MSDialog():New( 091- nLinIni,232,381 + nLinFim,927+203,"Consulta Movimenta豫o",,,.F.,,,,,,.T.,,,.T. )
	oGdFI002P      		:= DbGrid():Create(000,001,136+05,450,nOpc,'AllwaysTrue()','AllwaysTrue()','',,0,99,'AllwaysTrue()','','AllwaysTrue()',oDlgFI002P,HeadFatu(),{} )
	oGdFI002P:oBrowse:SetBlkBackColor({|| Iif( nLinGrid == oGdFI002P:nAt, U_HRetColor(132, 185, 217), U_HRetColor(255, 255, 255) ) })
	oGdFI002P:bChange 	:= {|| nLinGrid := oGdFI002P:nAt, oGdFI002P:Refresh() }
	
	If lFat
		oPFat	  := TPanel():New( 150, 001,"Documentos Relacionados a fatura: " + p_cPREF + "/" + p_cNUM +" Parcela: " + p_cParc + " Tipo: "+ p_cTIPO ,oDlgFI002P,,.F.,.F.,,,450,134,.T.,.F. )
		oGridFat  := DbGrid():Create( 010, 001, 125, 450, nOpc,'AllwaysTrue()','AllwaysTrue()','',,0,99,'AllwaysTrue()','','AllwaysTrue()', oPFat, GridFat(), {}, 0 )
	EndIf
	
	bBtnConf   := {|| oDlgFI002P:End(),.T.}
		
	oBtnConf   := SButton():New( 145 + nPosBtn, 420, 1,bBtnConf,oDlgFI002P,,"", )

	oDlgFI002P:Activate(,,,.T.,,,{|| MsgRun("Filtrando...","Consultando os dados",{|| Processa( {||ConsMov(p_cNUM,p_cPREF,p_cParc,p_cFilial), Iif(lFat, IniFat(p_cFilial,p_cClient,p_cLoja,p_cPREF, p_cNUM, p_cParc, p_cTipo), .T.) }, "Aguarde...", "Selecionando registros...",.F.) })})
	
	RestArea(aArea)

Return


/*/{Protheus.doc} HeadFatu
Consulta Movimenta豫o Financeira.
@author Cristiano de Souza Orbem/Geanderson Silva
@since 15/09/2016
@version 1.0
@type function
/*/
Static Function HeadFatu()

	Local aHeadFatu := {}

	aAdd( aHeadFatu, { "Parcela",		  	"PARCELA",          "@!", 					8,		0, "" ,, "C" ,,,,,, "V",,, .F. } )
	aAdd( aHeadFatu, { "Tipo",	  			"TIPO",             "@!",					5,		0, "" ,, "C" ,,,,,, "V",,, .F. } )
	aAdd( aHeadFatu, { "Moeda",	  			"MOEDA",            "@!",					5,		0, "" ,, "C" ,,,,,, "V",,, .F. } )
	aAdd( aHeadFatu, { "Valor",		  	    "VALOR",            "@E 999,999,999.99",	14,		2, "" ,, "N" ,,,,,, "V",,, .F. } )
	aAdd( aHeadFatu, { "Motivo Baixa",	    "MOTBAIXA",         "@!",					10,		0, "" ,, "C" ,,,,,, "V",,, .F. } )
	aAdd( aHeadFatu, { "Pagar/Receber",	    "REC_PAG",          "@!",					10,		0, "" ,, "C" ,,,,,, "V",,, .F. } )
	aAdd( aHeadFatu, { "Data",	    		"DATA_BAIXA",       "@!",					10,		0, "" ,, "C" ,,,,,, "V",,, .F. } )
	aAdd( aHeadFatu, { "Tipo Doc",	   		"TIPODOC",          "@!",					08,		0, "" ,, "C" ,,,,,, "V",,, .F. } )
	aAdd( aHeadFatu, { "Historico",		    "HISTORICO",        "@!",					50,		0, "" ,, "C" ,,,,,, "V",,, .F. } )

Return aHeadFatu


/*/{Protheus.doc} ConsMov
Consulta Movimenta豫o Financeira.
@author Cristiano de Souza Orbem/Geanderson Silva
@since 15/09/2016
@version 1.0
@type function
/*/
Static Function ConsMov(p_cNum,p_cPrefixo,p_cParcela,p_cMsFil) 

	local cAlias01  := GetNextAlias()
	local cSql		:= ""
	local nUltReg	:= 0

	oGdFI002P:Limpar()

	cSql := ""

	cSql += "SELECT                                     " + CRLF
	cSql += "  SE5.E5_TIPO      AS TIPO,                " + CRLF
	cSql += "  SE5.E5_TIPODOC   AS TIPODOC,             " + CRLF
	cSql += "  SE5.E5_MOEDA     AS MOEDA,               " + CRLF
	cSql += "  SE5.E5_MOTBX     AS MOTBAIXA,            " + CRLF
	cSql += "  SE5.E5_RECPAG    AS REC_PAG,             " + CRLF
	cSql += "  SE5.E5_PARCELA   AS PARCELA,             " + CRLF
	cSql += "  SE5.E5_VALOR     AS VALOR,               " + CRLF
	cSql += "  SE5.E5_DATA      AS DATA_BAIXA,          " + CRLF
	cSql += "  TRIM(SE5.E5_HISTOR)||', '||TRIM(SE5.E5_DOCUMEN)    AS HISTORICO,           " + CRLF
	cSql += "  SE5.E5_CLIFOR    AS CLIENTE,             " + CRLF
	cSql += "  SE5.E5_LOJA      AS LOJA                 " + CRLF
	cSql += "FROM "+RetSqlName("SE5")+" SE5             " + CRLF
	cSql += "WHERE SE5.E5_NUMERO    = '"+p_cNum+"'      " + CRLF
	cSql += "  AND ( SE5.E5_MSFIL 	= '"+p_cMsFil+"' OR SE5.E5_FILORIG 	= '"+p_cMsFil+"' )    " + CRLF
    cSql += "  AND SE5.E5_PREFIXO 	= '"+p_cPrefixo+"'  " + CRLF
    cSql += "  AND SE5.E5_PARCELA 	= '"+p_cParcela+"'  " + CRLF
	cSql += "  AND SE5.D_E_L_E_T_   = ' '               " + CRLF
	cSql += "                                           " + CRLF
	cSql += "UNION ALL                                  " + CRLF
	cSql += "                                           " + CRLF
	cSql += "SELECT                                     " + CRLF
	cSql += "  'NF'             AS TIPO,                " + CRLF
	cSql += "  'NFE'            AS TIPODOC,             " + CRLF
	cSql += "  ''               AS MOEDA,               " + CRLF
	cSql += "  ''               AS MOTBAIXA,            " + CRLF
	cSql += "  ''               AS REC_PAG,             " + CRLF
	cSql += "  ''               AS PARCELA,             " + CRLF
	cSql += "  SF2.F2_VALBRUT   AS VALOR,               " + CRLF
	cSql += "  SF2.F2_EMISSAO   AS DATA_BAIXA,          " + CRLF
	cSql += "  'NOTA FISCAL DE VENDA '||SF2.F2_SERIE||'/'||SF2.F2_DOC AS HISTORICO,     " + CRLF
	cSql += "  SF2.F2_CLIENTE   AS CLIENTE,             " + CRLF
	cSql += "  SF2.F2_LOJA      AS LOJA                 " + CRLF
	cSql += "FROM "+RetSqlName("SF2")+" SF2             " + CRLF
	cSql += "WHERE SF2.F2_DOC       = '"+p_cNum+"'      " + CRLF
	cSql += "  AND SF2.F2_FILIAL 	= '"+p_cMsFil+"'    " + CRLF
    cSql += "  AND SF2.F2_SERIE 	= '"+p_cPrefixo+"'  " + CRLF
	cSql += "  AND SF2.D_E_L_E_T_   = ' '               " + CRLF
	cSql += "                                           " + CRLF
	cSql += "UNION ALL                                  " + CRLF
	cSql += "                                           " + CRLF
	cSql += "SELECT                                     " + CRLF
	cSql += "  'NF'             AS TIPO,                " + CRLF
	cSql += "  'DEV'            AS TIPODOC,             " + CRLF
	cSql += "  ''               AS MOEDA,               " + CRLF
	cSql += "  ''               AS MOTBAIXA,            " + CRLF
	cSql += "  ''               AS REC_PAG,             " + CRLF
	cSql += "  ''               AS PARCELA,             " + CRLF
	cSql += "  SUM(SD1.D1_TOTAL)AS VALOR,               " + CRLF
	cSql += "  SD1.D1_EMISSAO   AS DATA_BAIXA,          " + CRLF
	cSql += "  'NOTA FISCAL DE DEVOLU플O '||SD1.D1_SERIE||'/'||SD1.D1_DOC AS HISTORICO, " + CRLF
	cSql += "  SD1.D1_FORNECE   AS CLIENTE,             " + CRLF
	cSql += "  SD1.D1_LOJA      AS LOJA                 " + CRLF
	cSql += "FROM "+RetSqlName("SD1")+" SD1             " + CRLF
	cSql += "WHERE SD1.D1_NFORI     = '"+p_cNum+"'      " + CRLF
	cSql += "  AND SD1.D1_FILIAL 	= '"+p_cMsFil+"'    " + CRLF
    cSql += "  AND SD1.D1_SERIORI 	= '"+p_cPrefixo+"'  " + CRLF
	cSql += "  AND SD1.D_E_L_E_T_   = ' '               " + CRLF
	cSql += "GROUP BY                                   " + CRLF
	cSql += "SD1.D1_EMISSAO,SD1.D1_FORNECE,SD1.D1_LOJA,SD1.D1_SERIE,SD1.D1_DOC  " + CRLF
	    
	cSql := ChangeQuery( cSql )

	If Select( cAlias01 ) > 0
		(cAlias01)->( dbCloseArea() )
	EndIf

	MPSysOpenQuery(cSql, cAlias01)

	(cAlias01)->( dbGoTop() )
	DbEval({|| nUltReg++})
	ProcRegua( nUltReg )
	(cAlias01)->( dbGoTop() )

	While (cAlias01)->(!Eof())

		oGdFI002P:AddLinha()

		oGdFI002P:SetColuna("PARCELA", 		(cAlias01)->PARCELA )
		oGdFI002P:SetColuna("TIPO", 		(cAlias01)->TIPO )
		oGdFI002P:SetColuna("MOEDA", 		(cAlias01)->MOEDA )
		oGdFI002P:SetColuna("VALOR", 		(cAlias01)->VALOR )
		oGdFI002P:SetColuna("HISTORICO", 	AllTrim((cAlias01)->HISTORICO) )
		oGdFI002P:SetColuna("MOTBAIXA",  	(cAlias01)->MOTBAIXA )
		oGdFI002P:SetColuna("REC_PAG",  	(cAlias01)->REC_PAG )
		oGdFI002P:SetColuna("DATA_BAIXA",  	Stod((cAlias01)->DATA_BAIXA) )
		oGdFI002P:SetColuna("TIPODOC",   	(cAlias01)->TIPODOC )
		
		(cAlias01)->( DbSkip() )
		IncProc( 'Aguarde... selecionando registros....' )

	EndDo

	if nUltReg > 0
		oGdFI002P:GoTop()
	endif
	oGdFI002P:Refresh()

Return()


/*/{Protheus.doc} GridFat
Monta aHeader da oGridFat 
@type function
@author Julio Kusther
@since 19/03/2018
/*/
Static Function GridFat()
	
	Local aRetGrid := {}
    	
	Aadd(aRetGrid, {"Emissao"		    ,"E1_EMISSAO"	,X3Picture("E1_EMISSAO")    ,TamSx3("E1_EMISSAO")[1], 	    TamSx3("E1_EMISSAO")[2],	"AllWaysTrue()", "?, "D", "", "R",,,,"V"})
	Aadd(aRetGrid, {"Titulo"			,"E1_NUM"		,"@!"						,TamSx3("E1_NUM")[1] + 9,		TamSx3("E1_NUM")[2] + 4, 	"AllWaysTrue()", "?, "C", "", "R",,,,"V"})
	Aadd(aRetGrid, {"Tipo"		        ,"E1_TIPO"		,"@!"						,TamSx3("E1_TIPO")[1],		    TamSx3("E1_TIPO")[2], 	    "AllWaysTrue()", "?, "C", "", "R",,,,"V"})
	Aadd(aRetGrid, {"Cod.Cliente"	    ,"E1_CLIENTE"	,"@!"						,TamSx3("E1_CLIENTE")[1]+ 3,	TamSx3("E1_CLIENTE")[2],	"AllWaysTrue()", "?, "C", "", "R",,,,"V"})
	Aadd(aRetGrid, {"Cliente"		    ,"E1_NOMCLI"	,"@!"							,TamSx3("E1_NOMCLI")[1],		TamSx3("E1_NOMCLI")[2], 	"AllWaysTrue()", "?, "C", "", "R",,,,"V"})
	Aadd(aRetGrid, {"Vencto.Real"	    ,"E1_VENCREA"	,X3Picture("E1_VENCREA")    ,TamSx3("E1_VENCREA")[1], 	    TamSx3("E1_VENCREA")[2],	"AllWaysTrue()", "?, "D", "", "R",,,,"V"})	
	Aadd(aRetGrid, {"Valor"		        ,"E1_VALOR"	    ,X3Picture("E1_VALOR")	    ,TamSx3("E1_VALOR")[1],		    TamSx3("E1_VALOR")[2], 	    "AllWaysTrue()", "?, "N", "", "R",,,,"V"})
	
Return aRetGrid


/*/{Protheus.doc} IniFat
Seleciona os dados do Formulario
@type function
@author Julio Kusther
@since 19/03/2018
/*/
Static Function IniFat(p_cFilial,p_cClient,p_cLoja,p_cPREF, p_cNUM, p_cPar, p_cTipo)

	Local   lAdd	  := .F.
	Local   nCol	  := 0
    Local   p_xFilial := p_cFilial
    Local   p_xClient := p_cClient
    Local   p_xLoja   := p_cLoja
    Local   p_xPREF   := p_cPREF
    Local   p_xNUM    := p_cNUM
    Local   p_xPar    := p_cPar
    
	BeginSql Alias 'TMPFAT'
		
		Column E1_EMISSAO AS DATE
		Column E1_VENCREA AS DATE
		  
        SELECT  E1_FATURA,E1_EMISSAO,
                E1_PREFIXO || '-' || E1_NUM || '-' || E1_PARCELA AS E1_NUM,
                E1_TIPO,		    
                E1_CLIENTE || '-' || E1_LOJA AS E1_CLIENTE, 			    
                E1_NOMCLI ,E1_VALOR, E1_VENCREA
        
        FROM %TABLE:FI7% FI7
        
        INNER JOIN %TABLE:SE1% SE1 ON E1_NUM      = FI7_NUMORI
                               AND E1_PREFIXO     = FI7_PRFORI
                               AND E1_PARCELA     = FI7_PARORI
                               AND E1_TIPO        = FI7_TIPORI
                               AND E1_CLIENTE     = FI7_CLIORI
                               AND E1_LOJA        = FI7_LOJORI
                               AND E1_FILIAL      = %XFILIAL:SE1%
                               AND E1_MSFIL      = %EXP:p_xFilial%
                               AND SE1.%NOTDEL%
		
        WHERE FI7_PRFDES     = %EXP:p_xPREF%
          AND FI7_NUMDES     = %EXP:p_xNUM%
          AND FI7_PARDES     = %EXP:p_xPar%
          AND FI7_CLIDES     = %EXP:p_xClient%
          AND FI7_LOJDES     = %EXP:p_xLoja%
          AND FI7_FILIAL     = %XFILIAL:FI7%
          AND FI7.%NOTDEL%
       	
	EndSql
	
	TMPFAT->(dbGoTop())
	
	While TMPFAT->(!Eof())
		
		If  lAdd
			oGridFat:AddLinha()
		EndIf
		
		For nCol := 1 to oGridFat:GetQtdColuna()
			oGridFat:SetColuna(oGridFat:NomeColuna(nCol), TMPFAT->&(oGridFat:NomeColuna(nCol)) )		
		Next	
		lAdd := .T.	
		TMPFAT->(DbSkip())	
	End
	
	TMPFAT->(dbCloseArea())
		
	If oGridFat:GETQTDLINHA() > 0
		oGridFat:PosLinha(1,.T.)
	Else	
		oGridFat:Refresh()
	EndIf
Return 
