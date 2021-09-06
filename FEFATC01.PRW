#INCLUDE "TOTVS.CH" 
#include "rwmake.ch"
#include "topconn.ch"

Static cCRLF		:= CRLF
Static cDebug		:= 'UAAMERDEBUG.DEBUG'
Static cZB4DEPART	:= ''

/*/{Protheus.doc} FEFATC01
Funcao Generica

@type		class
@author		Eurai Rapelli
@since 		2017.01.02

@example	U_FEFATC01( 1 )

@obs		Atualiza��o 2017.01.17. Eurai Rapelli - Adicionado C6_NUMORC no ExecAuto
@obs		Atualiza��o 2017.01.24. Eurai Rapelli - Filtro E1_TIPO = 'RA'
@obs		Atualiza��o 2017.01.24. Eurai Rapelli - Atualizar dados do Pedido Triangular
@obs		Atualiza��o 2017.01.30. Eurai Rapelli - Filtro E1_TIPO = 'NCC'
@obs		Atualiza��o 2017.02.01. Eurai Rapelli - CK_XNETDES
@obs		Atualiza��o 2017.06.28. Eurai Rapelli - Alterar valida�ao de credito
@obs		Atualiza��o 2017.08.18. Eurai Rapelli - Altera��es
@obs		Atualiza��o 2017.09.19. Eurai Rapelli - SC5->C5_SPLAN   := "5" no cancelamento do CK
@obs		Atualiza��o 2018.02.09. Eurai Rapelli - Melhorias
@obs		Atualiza��o 2018.02.22. Eurai Rapelli - Altera��o Status
@obs		Atualiza��o 2018.02.22. Eurai Rapelli - Voltar para o campo CJ_XVLBRUT
@obs		Atualiza��o 2018.03.12. Eurai Rapelli - Static lendo antes de inicializar RpcSetEnv. Static > Local
@obs		Atualiza��o 2018.03.28. Eurai Rapelli - Atualizado para Linha faturada parcialmente
@obs		Atualiza��o 2018.07.11. Almir         - alterado forma de pesquisa do SCK para o SC6
@obs		Atualiza��o 2019.03.28. Eurai Rapelli - Frete Minimo
@obs		Atualiza��o 2019.06.19. Eurai Rapelli - Error TMP1 FEFATA19
/*/
User Function FEFATC01( nFuncao )
Local oFEFATC01 := FEFATC01():New()
Local xRet		:= Nil

Default nFuncao	:= 1

If nFuncao == 1

	oFEFATC01:LogAprov()

ElseIf nFuncao == 2
	If SCJ->CJ_XSTATUS == '17'		// INATIVO
		Help( ,, 'HELP',, '[FEFATC01] Apenas a op��o de Reativar CK pode ser usada! ' +SCJ->CJ_NUM+' inativo.', 1, 0)
	Else
		CJ_XSTATUS()
	Endif
ElseIf nFuncao == 3
	If SCJ->CJ_XSTATUS == '17'		// INATIVO
		Help( ,, 'HELP',, '[FEFATC01] Apenas a op��o de Reativar CK pode ser usada! ' +SCJ->CJ_NUM+' inativo.', 1, 0)
	Else
		DEPURARS()
	Endif
ElseIf nFuncao == 4
	If SCJ->CJ_XSTATUS == '17'		// INATIVO
		Help( ,, 'HELP',, '[FEFATC01] Apenas a op��o de Reativar CK pode ser usada! ' +SCJ->CJ_NUM+' inativo.', 1, 0)
	Else
		DEPURARN()
	Endif
ElseIf nFuncao == 5
	If SCJ->CJ_XSTATUS == '17'		// INATIVO
		Help( ,, 'HELP',, '[FEFATC01] Apenas a op��o de Reativar CK pode ser usada! ' +SCJ->CJ_NUM+' inativo.', 1, 0)
	Else
		oFEFATC01:CJtoC5()
	Endif
ElseIf nFuncao == 6
	If SCJ->CJ_XSTATUS == '17'		// INATIVO
		Help( ,, 'HELP',, '[FEFATC01] Apenas a op��o de Reativar CK pode ser usada! ' +SCJ->CJ_NUM+' inativo.', 1, 0)
	Else
		oFEFATC01:DetailsUA()
	Endif
ElseIf nFuncao == 7 //Pelo campo CJ_LEG1 / Inicializador do Browser

	If SCJ->CJ_XTIPCK == '1'		//Normal
		//xRet := "BR_VERDE"
		xRet := "folder10"
	ElseIf SCJ->CJ_XTIPCK == '2'	//Refaturamento
		//xRet := "BR_VERDE_ESCURO"
		xRet := "folder14"
	ElseIf SCJ->CJ_XTIPCK == '3'	//Consulta
		//xRet := "BR_AZUL_CLARO"
		xRet := "folder12"
	Endif

ElseIf nFuncao == 8 //Reativa Cancelado
	If SCJ->CJ_XSTATUS != '17'		// ATIVO
		Help( ,, 'HELP',, '[FEFATC01] CK n�o esta cancelado! ' +SCJ->CJ_NUM+' ativo.', 1, 0)
	Else
		oFEFATC01:AtivaCanc()
	Endif
Endif

Return( xRet )

/*/{Protheus.doc} FEFATC01
Classe para Or�amento BOBINA

@type		class
@author		Eurai Rapelli
@since 		2016.06.13
/*/
Class FEFATC01

	DATA oFEGENC01

	DATA cArqSCJ
	DATA cArqSCK
	DATA cFunName
	DATA cLog
	DATA cTpLib

	DATA nFator


	Method New( cTipLib ) Constructor

	Method a415Copia()
	Method anFreteMin()
	Method anFinanc()
	Method AtivaCanc()

	Method CopyForLog( cCJNUM )
	Method C5toTriang( cFilSC5, cNumSC5, cNumSC5Tri )
	Method CJtoC5( cCJNUM )

	Method DataValida( dDataVer, lCast )
	Method DelForLog()
	Method DetailsUA()

	Method EfetOrc( nTipo )
	Method ExcluiApr( cNumSCJ, cRevisao )

	Method FCIOrigem( cCodProd , dDtEmissao )

	Method GetAprov( nValor )
	Method GeraAlcApr( cNumSCJ, aAprovador, cRevisao )
	Method GetCJBruto()
	Method GetFator( cTES, nFator )
	Method getForByTr( cCJTRANSP, cCJXREDESP )
	Method getFrtMin( nPesFrtMin, cZ03FORNEC, cZ03LOJA, cZ03EST, cZ03CODMUN, cZ03CEP )
	Method GetMotsCan( cTipo, cArea )
	Method GetSaldos( cCliente, cLoja )
	Method GetTpLib()
	Method GetTESAmos()
	Method GetUSRAdm()
	Method GetVlArray( aSaldos )
	Method GrvLogManu( aLogManu )
	Method GZB3STATUS( cStatus )

	Method HaveNF( cNumSCJ )
	Method HistCanc( oCria )
	Method HistZB4( oCria )

	Method IsAllAprov( cNumSCJ, cRevisao )
	Method IsLibAprov( cNumSCJ, cNivel, cRevisao )
	Method IsCJXTIPCK( cCJNUM )

	Method Liberar( cStatus, cNumSCJ, cNivel, cAprovador, cObs, cRevisao, cMotivo )
	Method LibForPV( lTMP, cNumSCJ )
	Method LogAprov()
	Method LogLiberac( cNumSC9, cRotina )
	Method LogPV( cNumSCJ )
	Method LogSF2()


	Method MA41XCOR( aCores ) 
	Method MA41XLEG( aCores ) 
	Method MA41XMNU()

	Method PosAprov( cNumSCJ, cCodUsr, cRevisao )
	Method PosNextApr( cNumSCJ, cRevisao )

	Method SendForApr( cNumSCJ, nValor, cRevisao )
	Method SetDescont()
	Method SetKey( nOpc )
	Method SetPrcFat()
	Method SetPrcTab( cCodTab, cCodRef, cProduto )
	Method SetPerda()
	Method SetRodape()
	Method ShowLog()

	Method Tracker( cCJNUM )

	Method UAFocusGER( oCont, cAbaFind, cFindUA )

	Method WFFinanc( cUsrMail, cTitulo, cMensagem )
	
	
EndClass

/*/{Protheus.doc} New
Metodo New

@type		method
@author		Eurai Rapelli
@since 		2016.06.13
/*/
Method New( cTipLib ) Class FEFATC01
Default cTipLib		:= 'OC'


::cTpLib			:= cTipLib
::cFunName			:= AllTrim( FunName() )
::oFEGENC01			:= FEGENC01():New()
::cLog				:= ''
::cArqSCJ			:= ''
::cArqSCK			:= ''

Return( Self )



/*/{Protheus.doc} a415Copia
Tratamento da Copia

@type		method	
@author		Eurai Rapelli
@since 		2017.08.24

@example	Local oFEFATC01 := FEFATC01():New(); oFEFATC01:a415Copia()
/*/

Method a415Copia() Class FEFATC01
//Local cFilialSB1:= xFilial('SB1')
//Local lMVXFATADT:= GetMv('MV_XFATADT', .F., .F. )	

TMP1->( dbGoTop() )
Do While TMP1->( !EOF() )

	RecLock('TMP1',.F.)
	
		TMP1->CK_ENTREG	:= M->CJ_XDTENTR
		TMP1->CK_DTPCP	:= CTOD("  /  /  ")   // Data PCP - gravada pelo sistema X-Trim
		TMP1->CK_DTCLI	:= CTOD("  /  /  ")   // Data Cliente - � data de entrega inicial gravada pelo Marcos da fedrigoni
		TMP1->CK_XDTPREM:= M->CJ_XDTENTR      // Data Prev. Embarque - gravada pela data de entrega inicial + Marcos da Fedrigoni + Na altera��o do X-Trim
		TMP1->CK_XDTSAID:= M->CJ_XDTENTR      // Data Prev. Saida - gravada pela data de entrega inicial + Marcos da Fedrigoni
		TMP1->CK_XDTPCPI:= CTOD("  /  /  ")   // Data PCP Inicial - gravada pelo Marcos da Fedrigoni
		TMP1->CK_XDTPEMI:= CTOD("  /  /  ")	  // Data Prev. Embarque Inicial - gravada pelo Marcos da Fedrigoni
		TMP1->CK_XCMDATA:= M->CJ_XDTENTR 		//M->CJ_EMISSAO
		
		TMP1->CK_XCMUSER:= '' 					//Usuario Aprova��o comercial
		TMP1->CK_XCMHORA:= '' 					//Hora Aprova��o comercial
		                                                                                                    
		TMP1->CK_TES	:= ''
		TMP1->CK_XITFAT	:= 'S'
		TMP1->CK_XOBSITF:= ''
		TMP1->CK_XMOTCAN:= ''
	
	TMP1->( MsUnlock() )

	TMP1->( dbSkip() )
EndDo
TMP1->( dbGoTop() )
GetDRefresh()

Return( Nil )



/*/{Protheus.doc} anFreteMin
Analisa Frete Minimo.
SCJ Poscionado

@type		method
@author		Eurai Rapelli
@since 		2019.03.28

@example	oFEFATC01:anFreteMin()
/*/
Method anFreteMin() CLASS FEFATC01
Local lRet			:= .F.
Local lOPE_TRI		:= .F.
Local aLogManu		:= {}
Local aArea			:= GetArea()
Local cMensagem		:= ''


Local tCKXNETDES	:= 00
Local nPesFrtMin	:= 00
Local nZ03VLRKG		:= 00
Local aFornec		:= {}
Local aDadosFrt		:= {}

Local oFEFATC01A	:= FEFATC01():New('FM')




//lOPE_TRI := !Empty(SC5->C5_TRIANGU) .AND. !Empty(SC5->C5_MENREM) .AND. !Empty(SC5->C5_TESREM) .AND. !Empty(SC5->C5_PEDREM)


/*
Para um preco de venda 3.142, usando TES "501"
ICMS 	12
COF  	7.6
PIS 	1.65
Preco sem imposto seria: 2,474325
100 - 21,25 / 100 = 0,7875
3,142 * 0,7875 = 2,474325

Z03 podem existir umas 5 ou mais linhas
Linha 1 = KGMIN 1 KG / KGMAX 100 KG
LInha 2 = KGMIN 100,01KG / KGMAX 700 KG
*/



Begin Sequence

If !Empty( SCJ->CJ_XREDESP )

	If SCJ->CJ_XCPLRED != '1'
		Break
	Endif

Else

	If SCJ->CJ_TPFRETE != 'C'
		Break
	Endif

Endif




If SCJ->CJ_XSNDFIN != 'S'
	Break
Endif

If !Empty( SCJ->CJ_TRIANGU )
	If SA1->( dbSeek( xFilial('SA1') + SCJ->CJ_TRIANGU ) )

	Else
		Help(NIL, NIL, "FEFATC01/anFreteMin", NIL, 'N�o encontrado cliente de OP Triangular: ' + SCJ->CJ_TRIANGU, 1, 0, NIL, NIL, NIL, NIL, NIL, {'Linha{'+cValtoChar(ProcLine(0))+'}'})
		Break
	Endif
Else
	If SA1->( dbSeek( xFilial('SA1') + SCJ->CJ_CLIENTE + SCJ->CJ_LOJA ) )

	Else
		Help(NIL, NIL, "FEFATC01/anFreteMin", NIL, 'N�o encontrado cliente: ' + SCJ->CJ_CLIENTE + SCJ->CJ_LOJA, 1, 0, NIL, NIL, NIL, NIL, NIL, {'Linha{'+cValtoChar(ProcLine(0))+'}'})
		Break
	Endif	
Endif

If SA1->A1_EST == 'EX'
	Break
Endif




TMP1->( dbGoTop() )
Do While TMP1->( !EOF() )

	If TMP1->CK_FLAG .OR. TMP1->CK_XITFAT == 'N'
		TMP1->( dbSkip() )
		Loop
	Endif

	SB1->( MsSeek( cFilialSB1 + TMP1->CK_PRODUTO ) )

	If SB1->B1_PESO > 0
		nPesFrtMin	+= SB1->B1_PESO * TMP1->CK_QTDVEN
		tCKXNETDES	+= TMP1->CK_XNETDES * TMP1->CK_QTDVEN
	Endif
	

	TMP1->( dbSkip() )
EndDo

::cLog		:= ''
::cLog		+= 'Peso(SB1->B1_PESO * SCK->CK_QTDVEN): ' + cValtoChar(nPesFrtMin) + cCRLF
::cLog		+= 'Soma(SCK->CK_XNETDES): ' + cValtoChar(tCKXNETDES) + cCRLF
::cLog		+= 'A1_EST: ' + SA1->A1_EST + cCRLF
::cLog		+= 'A1_COD_MUN: ' + SA1->A1_COD_MUN + cCRLF
::cLog		+= 'A1_CEP: ' + SA1->A1_CEP + cCRLF
aFornec		:= ::getForByTr( SCJ->CJ_TRANSP, SCJ->CJ_XREDESP )
aDadosFrt 	:= ::getFrtMin( nPesFrtMin, aFornec[01], aFornec[02], SA1->A1_EST, SA1->A1_COD_MUN, SA1->A1_CEP )
nZ03VLRKG	:= aDadosFrt[01,01]



If nZ03VLRKG == 0
	aLogManu	:= Array(19)
	aLogManu[01]:= SCJ->CJ_NUM
	aLogManu[02]:= SCJ->CJ_XREVISA
	aLogManu[03]:= ''
	aLogManu[04]:= Date()
	aLogManu[05]:= Time()
	aLogManu[06]:= ''
	aLogManu[07]:= ::cLog
	aLogManu[08]:= ''
	aLogManu[09]:= ''
	aLogManu[10]:= SCJ->CJ_XTIPCK
	aLogManu[11]:= 'FRM'
	aLogManu[12]:= 'FEFATC01'
	aLogManu[13]:= 'ANALISE FRETE MINIMO'
	aLogManu[14]:= 'NAO ENCONTRADO TABELA'
	oFEFATC01A:GrvLogManu( aLogManu )
	
	cMensagem	:= ' [ ANALISE FRETE MINIMO - NAO ENCONTRADO TABELA ] ' + cCRLF + cCRLF
	cMensagem	+= 'CheckList: ' + SCJ->CJ_NUM + cCRLF
	cMensagem	+= 'Transportadora: ' + SCJ->CJ_TRANSP + cCRLF
	cMensagem	+= 'Redespacho: ' + SCJ->CJ_XREDESP + cCRLF
	cMensagem	+= 'Cliente: ' + SA1->A1_COD + '/' + SA1->A1_LOJA + ' - ' + AllTrim(SA1->A1_NOME) + cCRLF
	cMensagem	+= 'Estado: ' + SA1->A1_EST + cCRLF
	cMensagem	+= 'Municipio: ' + SA1->A1_COD_MUN + cCRLF
	cMensagem	+= 'CEP: ' + SA1->A1_CEP + cCRLF
	cMensagem	+= 'Peso: ' + cValtoChar(nPesFrtMin) + cCRLF
	cMensagem	+= 'Fornecedor: ' + aFornec[01] + '/' + aFornec[02] + ' - ' + AllTrim(aFornec[04]) + cCRLF
	If !Empty( (xTmp := UsrRetMail(__cUserID)) )
		xTmp	:= ';' + xTmp
	Endif
	::oFEGENC01:SendMail( GetMV('FD_FATA19A',.F.,'eurai.rapelli@b2finance.com') + xTmp, 'NAO ENCONTRADO TABELA', cMensagem )
	
	
	Break
Endif


::cLog		+= 'KG-MIN: ' + cValtoChar(aDadosFrt[01,02]) + cCRLF
::cLog		+= 'KG-MAX: ' + cValtoChar(aDadosFrt[01,03]) + cCRLF

//If MsgYesNo( '[SIMULACAO]Bloquear para Analise de Frete', 'FEFATC01/anFreteMin' )		//Bloqueado Frete Minimo
If aDadosFrt[01,05]	

	::cLog		+= '(Fixo)Valor Frete Encontrado: ' + cValtoChar(nZ03VLRKG) + cCRLF
	nZ03VLRKG	:= aDadosFrt[01,01] / nPesFrtMin
//	::cLog		+= 'Valor Frete Kg (Z03 valor / Peso): ' + cValtoChar(nZ03VLRKG) + cCRLF

	If !IsBlind()
		cMensagem	:= 'Este CK n�o est� em conformidade com as pol�ticas comerciais de frete m�nimo.' + cCRLF
		cMensagem	+= 'Favor, analisar o motivo antes de seguir com o processo'
		Help(NIL, NIL, "FEFATC01/anFreteMin", NIL, cMensagem, 1, 0, NIL, NIL, NIL, NIL, NIL, {'Linha{'+cValtoChar(ProcLine(0))+'}'})
	Endif
	//CJ_TRANSP || CJ_TRIANGU
	//A1_CEP || A1_EST || A1_COD_MUN
	//CJ_XCPLRED (Frete Redespacho) | 1=Emitente;2=Destinatario
	//CK_XNETDES
	
	oFEFATC01A:SendForApr()

	RecLock('SCJ', .F. )
		SCJ->CJ_XSTATUS		:= '18'
	SCJ->( MsUnlock() )
	
	
	aLogManu	:= Array(19)
	aLogManu[01]:= SCJ->CJ_NUM
	aLogManu[02]:= SCJ->CJ_XREVISA
	aLogManu[03]:= ''
	aLogManu[04]:= Date()
	aLogManu[05]:= Time()
	aLogManu[06]:= ''
	aLogManu[07]:= ::cLog
	aLogManu[08]:= ''
	aLogManu[09]:= ''
	aLogManu[10]:= SCJ->CJ_XTIPCK
	aLogManu[11]:= 'FRM'
	aLogManu[12]:= 'FEFATC01'
	aLogManu[13]:= 'ANALISE FRETE MINIMO'
	If tCKXNETDES <= aDadosFrt[01,01] 
		aLogManu[14]:= 'BLOQUEADO POR PESO M�NIMO E PRE�O'
	Else
		aLogManu[14]:= 'BLOQUEADO POR PESO M�NIMO'
	Endif
	
	oFEFATC01A:GrvLogManu( aLogManu )
	
	lRet	:= .T.

Else

	::cLog		+= 'Valor Frete Encontrado: ' + cValtoChar(nZ03VLRKG) + cCRLF
	nZ03VLRKG	:= aDadosFrt[01,01] * nPesFrtMin
	::cLog		+= 'Valor Frete Total(Z03 valor * Peso): ' + cValtoChar(nZ03VLRKG) + cCRLF

	If tCKXNETDES <= nZ03VLRKG 
	
		If !IsBlind()
			cMensagem	:= 'Este CK n�o est� em conformidade com as pol�ticas comerciais de frete m�nimo.' + cCRLF
			cMensagem	+= 'Favor, analisar o motivo antes de seguir com o processo'
			Help(NIL, NIL, "FEFATC01/anFreteMin", NIL, cMensagem, 1, 0, NIL, NIL, NIL, NIL, NIL, {'Linha{'+cValtoChar(ProcLine(0))+'}'})
		Endif
		//CJ_TRANSP || CJ_TRIANGU
		//A1_CEP || A1_EST || A1_COD_MUN
		//CJ_XCPLRED (Frete Redespacho) | 1=Emitente;2=Destinatario
		//CK_XNETDES
		
	
		
		oFEFATC01A:SendForApr()
	
		RecLock('SCJ', .F. )
			SCJ->CJ_XSTATUS		:= '18'
		SCJ->( MsUnlock() )
		
		
		aLogManu	:= Array(19)
		aLogManu[01]:= SCJ->CJ_NUM
		aLogManu[02]:= SCJ->CJ_XREVISA
		aLogManu[03]:= ''
		aLogManu[04]:= Date()
		aLogManu[05]:= Time()
		aLogManu[06]:= ''
		aLogManu[07]:= ::cLog
		aLogManu[08]:= ''
		aLogManu[09]:= ''
		aLogManu[10]:= SCJ->CJ_XTIPCK
		aLogManu[11]:= 'FRM'
		aLogManu[12]:= 'FEFATC01'
		aLogManu[13]:= 'ANALISE FRETE MINIMO'
		aLogManu[14]:= 'BLOQUEADO POR PRE�O M�NINO'
		
		oFEFATC01A:GrvLogManu( aLogManu )
		
		lRet	:= .T.
	Else
		aLogManu	:= Array(19)
		aLogManu[01]:= SCJ->CJ_NUM
		aLogManu[02]:= SCJ->CJ_XREVISA
		aLogManu[03]:= ''
		aLogManu[04]:= Date()
		aLogManu[05]:= Time()
		aLogManu[06]:= ''
		aLogManu[07]:= ::cLog
		aLogManu[08]:= ''
		aLogManu[09]:= ''
		aLogManu[10]:= SCJ->CJ_XTIPCK
		aLogManu[11]:= 'FRM'
		aLogManu[12]:= 'FEFATC01'
		aLogManu[13]:= 'ANALISE FRETE MINIMO'
		aLogManu[14]:= 'LIBERADO AUTOMATICO'
		oFEFATC01A:GrvLogManu( aLogManu )
		Break
	Endif

Endif


End Sequence
::cLog		:= ''



RestArea(aArea)
Return( lRet )

/*/{Protheus.doc} getForByTr
Retorna Fornecedor

@type		method
@author		Eurai Rapelli
@since 		2019.05.22

@example	oFEFATC01:anFreteMin()
/*/
Method getForByTr( cCJTRANSP, cCJXREDESP ) Class FEFATC01
Local aRet			:= {'','','',''}
Local cA4CGC		:= ''
Local aAreaSA2		:= SA2->( GetArea() )

Default cCJTRANSP	:= ''
Default cCJXREDESP	:= ''


If !Empty( cCJXREDESP )
	If SA4->( dbSeek( xFilial('SA4') + cCJXREDESP ) )
		cA4CGC	:= SA4->A4_CGC
		::cLog		+= 'CJ_XREDESP: ' + cCJXREDESP + cCRLF
	Endif
ElseIf !Empty( cCJTRANSP )
	If SA4->( dbSeek( xFilial('SA4') + cCJTRANSP ) )
		cA4CGC	:= SA4->A4_CGC
		::cLog		+= 'CJ_TRANSP: ' + cCJTRANSP + cCRLF
	Endif
Endif

If !Empty( cA4CGC )
	::cLog		+= 'A4_CGC: ' + cA4CGC + cCRLF
	SA2->( dbSetOrder(3) )
	If SA2->( dbSeek( xFilial('SA2') + cA4CGC ) )
		aRet[01]	:= SA2->A2_COD
		aRet[02]	:= SA2->A2_LOJA
		aRet[03]	:= cA4CGC
		aRet[04]	:= SA4->A4_NOME
		::cLog		+= 'Fornecedor: ' + SA2->A2_COD + ' / ' + SA2->A2_LOJA + ' - ' + AllTrim(SA4->A4_NOME) + cCRLF
	Endif
Endif

RestArea( aAreaSA2 )
Return( aRet )

/*/{Protheus.doc} getFrtMin
Retorna Pre�o Minimo

@type		method
@author		Eurai Rapelli
@since 		2019.03.28

@example	oFEFATC01:anFreteMin()
/*/
Method getFrtMin( nPesFrtMin, cZ03FORNEC, cZ03LOJA, cZ03EST, cZ03CODMUN, cZ03CEP ) Class FEFATC01
Local cQuery			:= ''
Local cWhere			:= ''

Local nI				:= ''
Local nZ03VLRKG			:= 00
Local lExit				:= .F.

Local cAliasZ03			:= GetNextAlias()
Local aDadosFrt			:= {}
Local aWheres			:= {}

Default nPesFrtMin		:= 00
Default cZ03EST			:= ''
Default cZ03CODMUN		:= ''
Default cZ03CEP			:= ''



Begin Sequence


cWhere	:= ''
If !Empty( cZ03FORNEC )
	cWhere 		+= cCRLF + " AND Z03_FORNEC 	= '" + cZ03FORNEC + "' "
Endif
If !Empty( cZ03LOJA )
	cWhere 		+= cCRLF + " AND Z03_LOJA 	= '" + cZ03LOJA + "' "
Endif
cWhere += cCRLF + " AND Z03_EST 	= '" + cZ03EST + "' "
aAdd( aWheres, cWhere )

cWhere += cCRLF + " AND Z03_CODMUN 	= '" + cZ03CODMUN + "' "
aAdd( aWheres, cWhere )

cWhere += cCRLF + " AND Z03_CEP 	= '" + cZ03CEP + "' "
aAdd( aWheres, cWhere )


For nI := Len( aWheres ) to 01 STEP -1

	If Select(cAliasZ03) > 0
		(cAliasZ03)->( dbCloseArea() )
	Endif

	cQuery := cCRLF + "	SELECT  "
	cQuery += cCRLF + "		Z03.R_E_C_N_O_ AS Z03RECNO "
	cQuery += cCRLF + "	FROM "
	cQuery += cCRLF + RetSqlName("Z03") + " Z03 "
	cQuery += cCRLF + "	WHERE "
	cQuery += cCRLF + "		Z03_FILIAL	= '" + xFilial('Z03') + "' "
	cQuery += cCRLF + aWheres[nI]
	If nPesFrtMin > 0
		cQuery += cCRLF + " 	AND " + cValtoChar(nPesFrtMin) + " 	BETWEEN Z03_KGMIN AND Z03_KGMAX  "
	Endif
	cQuery += cCRLF + " 	AND Z03.D_E_L_E_T_ = ' ' "





	//MemoWrite( 'C:\Temp\arq.txt', cQuery )
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQuery)),cAliasZ03,.T.,.T.)

	If (cAliasZ03)->( !EOF() )

		lExit	:= .T.
		Do While (cAliasZ03)->( !EOF() )
			
			Z03->( dbGoTo( (cAliasZ03)->Z03RECNO ) )

			aTmp		:= Array(05)
			If Z03->Z03_PRCKGM > 0 
				aTmp[01] 	:= Z03->Z03_PRCKGM
				aTmp[05] 	:= .T.
			Else
				aTmp[01] 	:= Z03->Z03_VLRKG
				aTmp[05] 	:= .F.
			Endif
			aTmp[02] 	:= Z03->Z03_KGMIN 
			aTmp[03] 	:= Z03->Z03_KGMAX 
			aTmp[04] 	:= Z03->Z03_CEP
			aAdd( aDadosFrt, aTmp )

			If nPesFrtMin > 0
				Exit
			Endif

			(cAliasZ03)->( dbSkip() )
		EndDo

	Else
		::cLog		+= '>>>> FILTRO NIVEL: ' + cValtoChar(nI) + cCRLF
		::cLog		+= aWheres[nI] + cCRLF
		::cLog		+= 'VALOR ENTRE Z03_KGMIN AND Z03_KGMAX: ' + cValtoChar(nPesFrtMin) + cCRLF
	Endif

	If lExit 
		Exit
	Endif

Next nI
(cAliasZ03)->( dbCloseArea() )

If Len( aDadosFrt ) == 0
	aTmp		:= Array(05)
	aTmp[01] 	:= 0
	aTmp[02] 	:= 0
	aTmp[03] 	:= 0
	aTmp[04] 	:= ''
	aTmp[05] 	:= .F.
	aAdd( aDadosFrt, aTmp )
Endif

/*
aAdd( aChave, cZ03FORNEC + cZ03LOJA + cZ03EST + cZ03CODMUN + cZ03CEP  )
aAdd( aChave, cZ03FORNEC + cZ03LOJA + cZ03EST + cZ03CODMUN  )
aAdd( aChave, cZ03FORNEC + cZ03LOJA + cZ03EST  )
aAdd( aChave, cZ03FORNEC + cZ03LOJA  )

For nI := 01 to Len(aChave)

	cChave	:= aChave[nI]
	
	If Z03->( dbSeek( xFilial("Z03") + cChave ) )
		
		Do While Z03->Z03_FILIAL + Z03->Z03_FORNEC + Z03->Z03_LOJA + Z03->Z03_EST + Z03->Z03_CODMUN + Z03->Z03_CEP  ;
				== xFilial("Z03") + cChave
			
			If nPesFrtMin >= Z03->Z03_KGMIN .AND. nPesFrtMin <= Z03->Z03_KGMAX
				nZ03VLRKG := Z03->Z03_VLRKG
				Break
			EndIf
			
			Z03->( dbSkip() )
		EndDo
		
	Endif

Next nI
*/


End Sequence



Return( aDadosFrt )




/*/{Protheus.doc} anFinanc
Analisa Financeiro.
SCJ Poscionado

@type		method
@author		Eurai Rapelli
@since 		2019.03.28

@example	oFEFATC01:anFinanc()
/*/
Method anFinanc() CLASS FEFATC01
Local oFEFATC01		:= FEFATC01():New()
Local cCodigo		:= ''
Local nVldCredit	:= 0
Local dData			:= Date()
Local cHora			:= Time()
Local aLogManu		:= {}



If SCJ->CJ_XSNDFIN == 'S' 

	oFEFATC01:SendForApr()

	
	If Select("QryUA") > 0
		QryUA->( dbCloseArea() )
	Endif


	/* Alterado o Select pois, o mesmo n�o esta encontrando o CK que foi incluido, for�ado para n�o ler com a condi��o CK_NUM <> CJ_NUM */
	cQuery := cCRLF + "	SELECT  "
	cQuery += cCRLF + "		SUM(CK_VALOR) CK_VALOR "
	cQuery += cCRLF + "	FROM "
	cQuery += cCRLF + RetSqlName("SCK") + " SCK "
	cQuery += cCRLF + "	INNER JOIN "
	cQuery += cCRLF + RetSqlName("SCJ") + " SCJ "
	cQuery += cCRLF + "	ON "
	cQuery += cCRLF + "		CJ_FILIAL = CK_FILIAL "
	cQuery += cCRLF + "		AND CJ_NUM = CK_NUM "
	cQuery += cCRLF + "	WHERE "
	cQuery += cCRLF + "		CK_FILIAL 		= '" + SCJ->CJ_FILIAL + "' "
	cQuery += cCRLF + " 	AND CK_CLIENTE 	= '" + SCJ->CJ_CLIENTE + "' "
	cQuery += cCRLF + " 	AND CK_LOJA 	= '" + SCJ->CJ_LOJA + "' "
	cQuery += cCRLF + " 	AND CK_XITFAT 	= 'S' "
	cQuery += cCRLF + " 	AND CK_NUM <> '" + SCJ->CJ_NUM + "' "
	cQuery += cCRLF + " 	AND CJ_XSTATUS 	IN ('01','02','03','04','06','07') "
	cQuery += cCRLF + " 	AND CJ_XTIPO = 'N' "
	cQuery += cCRLF + " 	AND SCK.D_E_L_E_T_ <> '*' "
	cQuery += cCRLF + " 	AND SCJ.D_E_L_E_T_ <> '*' "
	
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQuery)),"QryUA",.T.,.T.)

	If QryUA->( !EOF() )
		nVldCredit += QryUA->CK_VALOR
	Endif
	QryUA->( dbCloseArea() )
	
	cQuery := cCRLF + "	SELECT  "
	cQuery += cCRLF + "		SUM(C6_VALOR) C6_VALOR "
	cQuery += cCRLF + "	FROM "
	cQuery += cCRLF + RetSqlName("SC6") + " SC6 "
	cQuery += cCRLF + "	INNER JOIN "
	cQuery += cCRLF + RetSqlName("SC5") + " SC5 "
	cQuery += cCRLF + "	ON "
	cQuery += cCRLF + "		C5_FILIAL = C6_FILIAL "
	cQuery += cCRLF + "		AND C5_NUM = C6_NUM "
	cQuery += cCRLF + "	WHERE "
	cQuery += cCRLF + "		C6_FILIAL 		= '" + SCJ->CJ_FILIAL + "' "
	cQuery += cCRLF + " 	AND C6_CLI	 	= '" + SCJ->CJ_CLIENTE + "' "
	cQuery += cCRLF + " 	AND C6_LOJA 	= '" + SCJ->CJ_LOJA + "' "
	cQuery += cCRLF + " 	AND C6_BLQ = '' "						//N�o esta eliminado
	cQuery += cCRLF + " 	AND C6_QTDVEN-C6_QTDENT > 0 "			//Somente pedidos em aberto
	cQuery += cCRLF + " 	AND C6_QTDEMP = 0 "  					//N�o tem quantidade liberada
	cQuery += cCRLF + " 	AND C5_TIPO = 'N' "						//Somente pedidos normais
	cQuery += cCRLF + " 	AND SC6.D_E_L_E_T_ <> '*' "
	cQuery += cCRLF + " 	AND SC5.D_E_L_E_T_ <> '*' "
	
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQuery)),"QryUA",.T.,.T.)
	
	If QryUA->( !EOF() )
		nVldCredit += QryUA->C6_VALOR
	Endif
	QryUA->( dbCloseArea() )

	/* Incluido para processar o valor do CK que acaba de ser incluido pois, o select acima n�o estava trazendo o mesmo */
	SCK->(DBSeek(xFilial("SCK")+SCJ->CJ_NUM))
	While SCK->CK_FILIAL = xFilial("SCK") .and. SCK->CK_NUM = SCJ->CJ_NUM  
		If SCK->CK_XITFAT == "S"
			nVldCredit += SCK->CK_VALOR
		EndIf
		SCK->(DBSkip())
	End
	
	//If oFEGENC01:MaAvalCred( SCJ->CJ_CLIENTE, SCJ->CJ_LOJA, SCJ->CJ_XVLBRUT, SCJ->CJ_MOEDA,/*lPedido*/.T.,@cCodigo,,,SA1->A1_LCFIN)
	If MaAvalCred( SCJ->CJ_CLIENTE, SCJ->CJ_LOJA, nVldCredit, SCJ->CJ_MOEDA,/*lPedido*/.T.,@cCodigo,,,SA1->A1_LCFIN)

		If oFEFATC01:Liberar( 'L', SCJ->CJ_NUM, , , 'CREDITO LIBERADO AUTOMATICAMENTE' )
		
			RecLock('SCJ', .F. )
				
				IF SCJ->CJ_XTIPCK=='2' //refaturamento
				    SCJ->CJ_XSTATUS := "07"
				ELSE
					SCJ->CJ_XSTATUS	:= '04'
				ENDIF
			
			SCJ->( MsUnlock() )
			
			oFEFATC01:LibForPV( .F., SCJ->CJ_NUM )//Atualiza��o 2019.06.19. Eurai Rapelli - Error TMP1 FEFATA19
			
			aLogManu	:= Array(19)
			aLogManu[01]:= SCJ->CJ_NUM
			aLogManu[02]:= SCJ->CJ_XREVISA
			aLogManu[03]:= ''
			aLogManu[04]:= dData
			aLogManu[05]:= cHora
			aLogManu[06]:= ''
			aLogManu[07]:= ''
			aLogManu[08]:= ''
			aLogManu[09]:= ''
			aLogManu[10]:= SCJ->CJ_XTIPCK
			aLogManu[11]:= 'ACA'
			aLogManu[12]:= 'FEFATA06'
			aLogManu[13]:= 'ANALISE FINANCEIRA AUTOMATICA'
			aLogManu[14]:= 'LIBERADO AUTOMATICO'
			oFEFATC01:GrvLogManu( aLogManu )
			
			MsgInfo('Cr�dito Liberado Automaticamente', 'FEFATA06')
			
		Endif
	
	Else
	
		RecLock('SCJ', .F. )
			
			SCJ->CJ_XSTATUS		:= '02'
			
		SCJ->( MsUnlock() )

		aLogManu	:= Array(19)
		aLogManu[01]:= SCJ->CJ_NUM
		aLogManu[02]:= SCJ->CJ_XREVISA
		aLogManu[03]:= ''
		aLogManu[04]:= dData
		aLogManu[05]:= cHora
		aLogManu[06]:= ''
		aLogManu[07]:= ''
		aLogManu[08]:= ''
		aLogManu[09]:= ''
		aLogManu[10]:= SCJ->CJ_XTIPCK
		aLogManu[11]:= 'ACA'
		aLogManu[12]:= 'FEFATA06'
		aLogManu[13]:= 'ANALISE FINANCEIRA AUTOMATICA'
		aLogManu[14]:= 'BLOQUEADO AUTOMATICO'
		oFEFATC01:GrvLogManu( aLogManu )

	Endif
		
	
Endif



Return( Nil )





/*/{Protheus.doc} AtivaCanc
Ativa CK Cancelado

@type		method
@author		Eurai Rapelli
@since 		2018.02.09

@example	oFEFATC01:AtivaCanc()
/*/
Method AtivaCanc() CLASS FEFATC01
Local aLogManu	:= {}

If SCJ->CJ_XSTATUS == '17'

	SCK->( dbSeek( SCJ->CJ_FILIAL + SCJ->CJ_NUM ) )
	Do While SCK->( !EOF() ) .AND. SCK->CK_NUM == SCJ->CJ_NUM
		
		If  SCK->CK_XMOTCAN == '006'
			RecLock('SCK',.F.)
			SCK->CK_XITFAT 		:= 'S'
			SCK->CK_XMOTCAN		:= ''
			SCK->CK_XOBSITF 	:= ''
			SCK->( MsUnlock() )
		EndIf

		SCK->( dbSkip() )
	EndDo

	RecLock('SCJ',.F.)

	SCJ->CJ_XSTATUS		:= '01'
	SCJ->CJ_STATUS		:= 'A'
	SCJ->CJ_SPLAN		:= '1'
	SCJ->CJ_XROTCAN		:= ''
	SCJ->CJ_XUSRCAN		:= ''
	SCJ->CJ_XREDPCP		:= Ctod('')
	SCJ->CJ_XREHPCP		:= ''
	
	SCJ->( MsUnlock() )
	
	aLogManu	:= Array(19)
	aLogManu[01]:= SCJ->CJ_NUM
	aLogManu[02]:= SCJ->CJ_XREVISA
	aLogManu[03]:= ''
	aLogManu[04]:= Date()
	aLogManu[05]:= Time()
	aLogManu[06]:= ''
	aLogManu[07]:= ''
	aLogManu[08]:= ''
	aLogManu[09]:= ''
	aLogManu[10]:= SCJ->CJ_XTIPCK
	aLogManu[11]:= 'RCK'
	aLogManu[12]:= 'FEFATC01'
	aLogManu[13]:= 'ATIVA'
	::GrvLogManu( aLogManu )	
	
	MsgInfo('Checklist Ativado','FEFATC01/AtivaCanc')

Else
	MsgInfo('Checklist n�o cancelado pelo FEFATA18','FEFATC01/AtivaCanc')
Endif

Return( Nil )


/*/{Protheus.doc} CopyForLog
Copia registro SCJ

@type		method	
@author		Eurai Rapelli
@since 		2017.08.29

@example	Local oFEFATC01 := FEFATC01():New(); oFEFATC01:CopyForLog( cCJNUM )
/*/
Method CopyForLog( cCJNUM ) Class FEFATC01
Local nX			:= 0
Local cSeconds		:= "9"+StrZero(Seconds(),5,0)
Local cFieldName	:= ''
Local aAreaSCJ		:= SCJ->( GetArea() )
Local aAreaSCK		:= SCK->( GetArea() )
Local aArea			:= GetArea()

Local nCountSCJ		:= SCJ->( FCount() )
Local nCountSCK		:= SCK->( FCount() )

SCJ->(DbSetOrder(1))

If !Empty(cCJNUM) .and. SCJ->( dbSeek( xFilial('SCJ') + cCJNUM ) )

	::DelForLog()
	::cArqSCJ		:= "CopyForLog_SCJ" + cSeconds
	::cArqSCK		:= "CopyForLog_SCK" + cSeconds

	dbCreate( ::cArqSCJ, SCJ->( dbStruct() ), __LocalDriver )
	dbUseArea( .T., __LocalDriver, ::cArqSCJ, 'UAERSCJ', .F., .F. )
	
	RecLock('UAERSCJ',.T.)
		For nX := 01 To nCountSCJ
			
			cFieldName	:= SCJ->(FieldName(nX))
			UAERSCJ->&(cFieldName) := SCJ->&(cFieldName)
	
		Next nX
	UAERSCJ->( MsUnlock() )

	If SCK->( dbSeek( SCJ->CJ_FILIAL + SCJ->CJ_NUM ) )

		dbCreate( ::cArqSCK, SCK->( dbStruct() ), __LocalDriver )
		dbUseArea( .T., __LocalDriver, ::cArqSCK, 'UAERSCK', .F., .F. )
	
		Do While SCK->( !EOF() ) ;
			.AND. SCK->CK_FILIAL + SCK->CK_NUM == SCJ->CJ_FILIAL + SCJ->CJ_NUM
			
			
			RecLock('UAERSCK',.T.)
			
				For nX := 01 To nCountSCK
				
					cFieldName	:= SCK->(FieldName(nX))
					UAERSCK->&(cFieldName) := SCK->&(cFieldName)
			
				Next nX
			
			UAERSCK->( MsUnlock() )
			
			
			SCK->( dbSkip() )
		EndDo
		
	
	Endif
Else
	conout("Numero do CK n�o encontrado (Method CopyForLog): "+ cCJNUM)
Endif

RestArea( aAreaSCJ )
RestArea( aAreaSCK )
RestArea( aArea )
Return( Nil )




/*/{Protheus.doc} C5toTriang
Atualiza Pedido Triangular

@type		method	
@author		Eurai Rapelli
@since 		2017.01.24

@example	Local oFEFATC01 := FEFATC01():New(); oFEFATC01:C5toTriang( cFilSC5, cNumSC5, cNumSC5Tri )
/*/
Method C5toTriang( cFilSC5, cNumSC5, cNumSC5Tri ) Class FEFATC01
Local cCFOP			:= ''


Local nX			:= 0



Local cCampo		:= '1'
Local cVend     	:= "1"          
Local cParcela  	:= "123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ0"

Local nParcTp9  	:= GetMv("MV_NUMPARC")
Local nMaxVend  	:= Fa440CntVen()


Local aDadosCfo		:= {}	

Local lRet	:= .T.



dbUseArea( .T.,"TOPCONN", RetSqlName("SC5"), "SC5_UAREM", .T., .F. ) 
dbSetIndex( RetSqlName("SC5") + '1'  )
dbUseArea( .T.,"TOPCONN", RetSqlName("SC6"), "SC6_UAREM", .T., .F. ) 
dbSetIndex( RetSqlName("SC6") + '1'  )
dbUseArea( .T.,"TOPCONN", RetSqlName("SC9"), "SC9_UAREM", .T., .F. ) 	
dbSetIndex( RetSqlName("SC9") + '1'  )

Begin Sequence



If !SC5->( dbSeek( cFilSC5 + cNumSC5 ) )
	MsgInfo('Pedido Origem n�o Encontrado: ' + cNumSC5)
	lRet := .F.; Break
Endif

If !SC5_UAREM->( dbSeek( cFilSC5 + cNumSC5Tri ) )
	MsgInfo('Pedido Triangular n�o Encontrado: ' + cNumSC5Tri)
	lRet := .F.; Break
Endif

If !SA1->( dbSeek( xFilial('SA1',cFilSC5) + SC5->C5_TRIANGU ) )
	MsgInfo('Cliente n�o Encontrado: ' + SC5->C5_TRIANGU)
	lRet := .F.; Break
Endif

If !SE4->( dbSeek( xFilial('SE4',cFilSC5) + SC5->C5_CONDPAG ) )
	MsgInfo('Condi��o n�o Encontrado: ' + SC5->C5_CONDPAG)
	lRet := .F.; Break
Endif



RecLock('SC5_UAREM',.F.)

	SC5_UAREM->C5_CLIENTE		:= Left(SC5->C5_TRIANGU,6)
	SC5_UAREM->C5_LOJACLI		:= Right(SC5->C5_TRIANGU,2)
	SC5_UAREM->C5_LOJAENT		:= Right(SC5->C5_TRIANGU,2)
	SC5_UAREM->C5_TIPOCLI		:= SC5->C5_TIPOCLI
	SC5_UAREM->C5_CONDPAG		:= SC5->C5_CONDPAG
	SC5_UAREM->C5_TABELA		:= SC5->C5_TABELA
	SC5_UAREM->C5_DESC1			:= SC5->C5_DESC1
	SC5_UAREM->C5_DESC2			:= SC5->C5_DESC2
	SC5_UAREM->C5_DESC3			:= SC5->C5_DESC3
	SC5_UAREM->C5_DESC4			:= SC5->C5_DESC4
	SC5_UAREM->C5_FRETE			:= SC5->C5_FRETE
	SC5_UAREM->C5_SEGURO		:= SC5->C5_SEGURO
	SC5_UAREM->C5_DESPESA		:= SC5->C5_DESPESA
	SC5_UAREM->C5_FRETAUT		:= SC5->C5_FRETAUT
	SC5_UAREM->C5_ACRSFIN		:= SE4->E4_ACRSFIN
	SC5_UAREM->C5_MOEDA			:= SC5->C5_MOEDA
	SC5_UAREM->C5_TXMOEDA		:= SC5->C5_TXMOEDA
	SC5_UAREM->C5_TIPLIB		:= SC5->C5_TIPLIB
	SC5_UAREM->C5_TPCARGA		:= SC5->C5_TPCARGA
	SC5_UAREM->C5_DESCONT		:= SC5->C5_DESCONT
	SC5_UAREM->C5_PDESCAB		:= SC5->C5_PDESCAB
	
	For nX :=  1 To nParcTp9
		
		cCampo := SubStr( cParcela, nX, 1 ) 
		
		&('SC5_UAREM->C5_PARC'+cCampo)		:= SC5->&('C5_PARC'+cCampo)	
		&('SC5_UAREM->C5_DATA'+cCampo)		:= SC5->&('C5_DATA'+cCampo)
		
	Next nX
	
	For nX := 1 To nMaxVend
	
		If SC5_UAREM->(FieldPos('C5_VEND'+cVend)) > 0
			&('SC5_UAREM->C5_VEND'+cVend)		:= SC5->&('C5_VEND'+cVend)
		Endif
	
		If SC5_UAREM->(FieldPos('C5_COMIS'+cVend)) > 0
			&('SC5_UAREM->C5_COMIS'+cVend)		:= SC5->&('C5_COMIS'+cVend)
		Endif
		
		cVend := Soma1(cVend,1)
			
	Next nX
	
	SC5_UAREM->C5_VIA			:= SC5->C5_VIA
	SC5_UAREM->C5_DEP_COM		:= SC5->C5_DEP_COM
	SC5_UAREM->C5_MENPAD		:= SC5->C5_MENPAD
	SC5_UAREM->C5_TIPO			:= SC5->C5_TIPO
	SC5_UAREM->C5_TRANSP		:= SC5->C5_TRANSP
	//SC5_UAREM->C5_TRIANGU		:= SC5->C5_TRIANGU
	//SC5_UAREM->C5_MENREM		:= SC5->C5_MENREM
	//SC5_UAREM->C5_TESREM		:= SC5->C5_TESREM
	SC5_UAREM->C5_TPFRETE 		:= SC5->C5_TPFRETE
	SC5_UAREM->C5_VOLUME1 		:= SC5->C5_VOLUME1
	SC5_UAREM->C5_ESPECI1 		:= SC5->C5_ESPECI1
	SC5_UAREM->C5_INF_FAT 		:= SC5->C5_INF_FAT
	SC5_UAREM->C5_AMOSTRA 		:= SC5->C5_AMOSTRA
	SC5_UAREM->C5_LAUDO			:= SC5->C5_LAUDO
	SC5_UAREM->C5_FRETE			:= SC5->C5_FRETE
	SC5_UAREM->C5_REAJUST 		:= SC5->C5_REAJUST
	SC5_UAREM->C5_MENNOTA 		:= SC5->C5_MENNOTA
	SC5_UAREM->C5_MENNOT1 		:= SC5->C5_MENNOT1
	SC5_UAREM->C5_MENNOT2 		:= SC5->C5_MENNOT2
	SC5_UAREM->C5_MENNOT3 		:= SC5->C5_MENNOT3
	//SC5->C5_VEND1				:= SCJ->CJ_VEND1
	SC5_UAREM->C5_PBRUTO 		:= SC5->C5_PBRUTO
	SC5_UAREM->C5_PESOL			:= SC5->C5_PESOL
	SC5_UAREM->C5_NATUREZ		:= SC5->C5_NATUREZ
	SC5_UAREM->C5_COTCLI		:= SC5->C5_COTCLI
	SC5_UAREM->C5_XGERBOL		:= SC5->C5_XGERBOL
	SC5_UAREM->C5_XEMLAUD		:= SC5->C5_XEMLAUD
	SC5_UAREM->C5_REDESP		:= SC5->C5_REDESP
	SC5_UAREM->C5_XPROIME		:= SC5->C5_XPROIME
	SC5_UAREM->C5_INF_FAT		:= AllTrim(SC5->C5_INF_FAT) + '.'	//Valida��o SALTO. N�o sai Erro em execauto
	
SC5_UAREM->( MsUnlock() )

SC6_UAREM->( dbSeek( SC5_UAREM->C5_FILIAL + SC5_UAREM->C5_NUM ) )
Do While SC6_UAREM->( !EOF() ) ;
	.AND. SC6_UAREM->C6_NUM == SC5_UAREM->C5_NUM


	If !SC6->( dbSeek( SC5->C5_FILIAL + SC5->C5_NUM + SC6_UAREM->C6_ITEM ) )
		MsgInfo('Item Pedido n�o Encontrado: ' + SC5->C5_NUM + ' / ' + SC6_UAREM->C6_ITEM )
		lRet := .F.; Break
	Endif
	
	If !SF4->( dbSeek( xFilial('SF4',SC5->C5_FILIAL) + SC5->C5_TESREM ) )
		MsgInfo('TES n�o Encontrada: ' + SC5->C5_TESREM)
		lRet := .F.; Break
	Endif	

	aDadosCfo	:= {}
 	aAdd( aDadosCfo, { "OPERNF"		, "S" 				} )
 	aAdd( aDadosCfo, { "TPCLIFOR"	, SA1->A1_TIPO	 	} )
 	aAdd( aDadosCfo, { "UFDEST"		, SA1->A1_EST 		} )
 	aAdd( aDadosCfo, { "INSCR"		, SA1->A1_INSCR 	} )
	aAdd( aDadosCfo, { "CONTR"		, SA1->A1_CONTRIB 	} )
	cCFOP	:= MaFisCfo( , SF4->F4_CF, aDadosCfo )	
	
	
	RecLock('SC6_UAREM',.F.)
	
		SC6_UAREM->C6_ITEM			:= SC6->C6_ITEM	
		SC6_UAREM->C6_PRODUTO		:= SC6->C6_PRODUTO
		SC6_UAREM->C6_TES			:= SC5->C5_TESREM
		SC6_UAREM->C6_QTDVEN		:= SC6->C6_QTDVEN
		SC6_UAREM->C6_PRCVEN		:= SC6->C6_PRCVEN
		SC6_UAREM->C6_PRUNIT		:= SC6->C6_PRUNIT
		SC6_UAREM->C6_VALOR			:= SC6->C6_VALOR
		SC6_UAREM->C6_ENTREG		:= SC6->C6_ENTREG
		SC6_UAREM->C6_CLASFIS		:= SC6->C6_CLASFIS
		SC6_UAREM->C6_CF			:= cCFOP
		//SC6_UAREM->C6_NUMORC		:= SC6->C6_NUMORC
		
	SC6_UAREM->( MsUnlock() )
	
	If SC9_UAREM->( dbSeek( SC6_UAREM->C6_FILIAL + SC6_UAREM->C6_NUM + SC6_UAREM->C6_ITEM ) )
	
		Do While SC9_UAREM->( !EOF() ) ;
			.AND. SC9_UAREM->C9_PEDIDO + SC9_UAREM->C9_ITEM == SC6_UAREM->C6_NUM + SC6_UAREM->C6_ITEM

			If Empty(SC9_UAREM->C9_NFISCAL)
			
				RecLock('SC9_UAREM',.F.)
				
					SC9_UAREM->C9_PRCVEN	:= SC6_UAREM->C6_PRCVEN
					SC9_UAREM->C9_DATENT	:= SC6_UAREM->C6_ENTREG
				
				SC9_UAREM->( MsUnlock() )
			
			Endif

		
			SC9_UAREM->( dbSkip() )
		EndDo
	
	Endif
	

	SC6_UAREM->( dbSkip() )
EndDo

End Sequence


If Select("SC5_UAREM") > 0
	SC5_UAREM->( dbCloseArea() )
Endif

If Select("SC6_UAREM") > 0
	SC6_UAREM->( dbCloseArea() )
Endif

If Select("SC9_UAREM") > 0
	SC9_UAREM->( dbCloseArea() )
Endif


Return( lRet )



/*/{Protheus.doc} CJtoC5
Altera pedido de venda de acordo Or�amento

@type		method	
@author		Eurai Rapelli
@since 		2017.01.06

@example	Local oFEFATC01 := FEFATC01():New(); oFEFATC01:CKtoCJ( cCJNUM )
/*/
Method CJtoC5( cCJNUM ) Class FEFATC01
Local lRet			:= .T.


Local aCab			:= {}
Local aItem			:= {}
Local aItens		:= {}

Local cCampo		:= ''
Local cCFOP			:= ''


Local nX			:= 0


Local xTemp			:= ''



Local cVend     	:= "1"          
Local cParcela  	:= "123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ0"

Local nParcTp9  	:= GetMv("MV_NUMPARC")
Local nMaxVend  	:= Fa440CntVen()

Local dBKDtBase		:= dDataBase 


Local aDadosCfo		:= {}	

Local lExecAuto		:= .F.
Local lCancelado	:= .T.
Local lOPE_TRI		:= .F.
Local cQuery		:= ""
Local cAliasSC6 := GetNextAlias()

Private lMSErroAuto	:= .F.


Default cCJNUM	:= SCJ->CJ_NUM



Begin Sequence

If !SCJ->( dbSeek( xFilial('SCJ') + cCJNUM ) )
	MsgInfo('Or�amento n�o Encontrado: ' + cCJNUM)
	lRet := .F.; Break
Endif
If !SCK->( dbSeek( SCJ->CJ_FILIAL + SCJ->CJ_NUM ) )
	MsgInfo('Item n�o Encontrado: ' + SCJ->CJ_NUM)
	lRet := .F.; Break
Endif
If !SA1->( dbSeek( xFilial('SA1',SCJ->CJ_FILIAL) + SCJ->CJ_CLIENTE + SCJ->CJ_LOJA ) )
	MsgInfo('Cliente n�o Encontrado: ' + SCJ->CJ_CLIENTE + ' / ' + SCJ->CJ_LOJA)
	lRet := .F.; Break
Endif
If !SE4->( dbSeek( xFilial('SE4',SCJ->CJ_FILIAL) + SCJ->CJ_CONDPAG ) )
	MsgInfo('Condi��o n�o Encontrado: ' + SCJ->CJ_CONDPAG)
	lRet := .F.; Break
Endif
If !SC5->( dbSeek( SCK->CK_FILIAL + SCK->CK_NUMPV ) )
	MsgInfo('Pedido n�o Encontrado: ' + SCK->CK_NUMPV)
	lRet := .F.; Break
Endif

lOPE_TRI := !Empty(SC5->C5_TRIANGU) .AND. !Empty(SC5->C5_MENREM) .AND. !Empty(SC5->C5_TESREM) .AND. !Empty(SC5->C5_PEDREM)



If lExecAuto

	aAdd( aCab, {"C5_NUM"     	, SCK->CK_NUMPV			, Nil } )
	aAdd( aCab, {"C5_CLIENTE" 	, SCJ->CJ_CLIENTE		, Nil } )
	aAdd( aCab, {"C5_LOJACLI"	, SCJ->CJ_LOJA			, Nil } )
	aAdd( aCab, {"C5_CLIENT"	, SCJ->CJ_CLIENT		, Nil } )
	aAdd( aCab, {"C5_LOJAENT"	, SCJ->CJ_LOJAENT		, Nil } )
	xTemp	:= If( Empty(SCJ->CJ_TIPOCLI), SA1->A1_TIPO, SCJ->CJ_TIPOCLI )
	aAdd( aCab, {"C5_TIPOCLI"	, xTemp					, Nil } )
	aAdd( aCab, {"C5_CONDPAG"	, SCJ->CJ_CONDPAG		, Nil } )
	xTemp	:= If( Empty(SCJ->CJ_TABELA), Space( Len( SC5->C5_TABELA ) ), SCJ->CJ_TABELA )
	aAdd( aCab, {"C5_TABELA"	, xTemp					, ".T." } )
	aAdd( aCab, {"C5_DESC1"		, SCJ->CJ_DESC1			, Nil } )
	aAdd( aCab, {"C5_DESC2"		, SCJ->CJ_DESC2			, Nil } )
	aAdd( aCab, {"C5_DESC3"		, SCJ->CJ_DESC3			, Nil } )
	aAdd( aCab, {"C5_DESC4"		, SCJ->CJ_DESC4			, Nil } )
	aAdd( aCab, {"C5_FRETE"		, SCJ->CJ_FRETE			, Nil } )
	aAdd( aCab, {"C5_SEGURO"	, SCJ->CJ_SEGURO		, Nil } )
	aAdd( aCab, {"C5_DESPESA"	, SCJ->CJ_DESPESA		, Nil } )
	aAdd( aCab, {"C5_FRETAUT"	, SCJ->CJ_FRETAUT		, Nil } )
	aAdd( aCab, {"C5_ACRSFIN"	, SE4->E4_ACRSFIN		, Nil } )
	aAdd( aCab, {"C5_MOEDA"		, SCJ->CJ_MOEDA			, Nil } )
	aAdd( aCab, {"C5_TXMOEDA"	, SCJ->CJ_TXMOEDA		, Nil } )
	aAdd( aCab, {"C5_TIPLIB"	, SCJ->CJ_TIPLIB		, Nil } )
	aAdd( aCab, {"C5_TPCARGA"	, SCJ->CJ_TPCARGA		, Nil } )
	aAdd( aCab, {"C5_DESCONT"	, SCJ->CJ_DESCONT		, Nil } )
	aAdd( aCab, {"C5_PDESCAB"	, SCJ->CJ_PDESCAB		, Nil } )
	aAdd( aCab, {"C5_PAISENT"	, SA1->A1_PAIS			, Nil } )
	
	For nX :=  1 To nParcTp9
		
		cCampo := SubStr( cParcela, nX, 1 ) 
		
		aAdd( aCab, {"C5_PARC"+cCampo	, SCJ->&('CJ_PARC'+cCampo)			, Nil } )
		aAdd( aCab, {"C5_DATA"+cCampo	, SCJ->&('CJ_DATA'+cCampo)			, Nil } )
		
	Next nX
	
	For nX := 1 To nMaxVend
	
		If SCJ->(FieldPos('CJ_VEND'+cVend)) > 0
			aAdd( aCab, {"C5_VEND"+cVend	, SCJ->&('CJ_VEND'+cVend)			, Nil } )
		Endif
	
		If SCJ->(FieldPos('C5_COMIS'+cVend)) > 0
			aAdd( aCab, {"C5_COMIS"+cVend	, SCJ->&('CJ_COMIS'+cVend)			, Nil } )
		Endif
		
		cVend := Soma1(cVend,1)
			
	Next nX
	
	aAdd( aCab, {"C5_VIA"			, SCJ->CJ_VIA 					, Nil } )
	aAdd( aCab, {"C5_DEP_COM"		, SCJ->CJ_DEP_COM				, Nil } )
	aAdd( aCab, {"C5_MENPAD"      	, SCJ->CJ_MENPAD				, Nil } )
	aAdd( aCab, {"C5_TIPO"        	, SCJ->CJ_XTIPO					, Nil } )
	aAdd( aCab, {"C5_TRANSP"      	, SCJ->CJ_TRANSP				, Nil } )
	aAdd( aCab, {"C5_TRIANGU"      	, SCJ->CJ_TRIANGU				, Nil } )
	aAdd( aCab, {"C5_MENREM"      	, SCJ->CJ_MENREM				, Nil } )
	aAdd( aCab, {"C5_TESREM"      	, SCJ->CJ_TESREM				, Nil } )
	aAdd( aCab, {"C5_TPFRETE"     	, SCJ->CJ_TPFRETE				, Nil } )
	aAdd( aCab, {"C5_VOLUME1"     	, SCJ->CJ_VOLUME1				, Nil } )
	aAdd( aCab, {"C5_ESPECI1"     	, SCJ->CJ_ESPECI1				, Nil } )
	aAdd( aCab, {"C5_INF_FAT"     	, SCJ->CJ_INF_FAT				, Nil } )
	aAdd( aCab, {"C5_AMOSTRA"     	, SCJ->CJ_AMOSTRA				, Nil } )
	aAdd( aCab, {"C5_LAUDO"       	, SCJ->CJ_LAUDO					, Nil } )
	aAdd( aCab, {"C5_FRETE"       	, SCJ->CJ_FRETE					, Nil } )
	aAdd( aCab, {"C5_REAJUST"     	, SCJ->CJ_REAJUST				, Nil } )
	aAdd( aCab, {"C5_MENNOTA"     	, SCJ->CJ_MENNOTA				, Nil } )
	aAdd( aCab, {"C5_MENNOT1"     	, SCJ->CJ_MENNOT1				, Nil } )
	aAdd( aCab, {"C5_MENNOT2"     	, SCJ->CJ_MENNOT2				, Nil } )
	aAdd( aCab, {"C5_MENNOT3"     	, SCJ->CJ_MENNOT3				, Nil } )
	//aAdd( aCab, {"C5_VEND1"       	, SCJ->CJ_VEND1				, Nil } )
	aAdd( aCab, {"C5_PBRUTO"     	, SCJ->CJ_PBRUTO				, Nil } )
	aAdd( aCab, {"C5_PESOL"       	, SCJ->CJ_PESOL					, Nil } )
	aAdd( aCab, {"C5_NATUREZ"    	, SCJ->CJ_NATUREZ				, Nil } )
	aAdd( aCab, {"C5_COTCLI"    	, SCJ->CJ_COTCLI				, Nil } )
	aAdd( aCab, {"C5_XGERBOL"    	, SCJ->CJ_XGERBOL				, Nil } )
	aAdd( aCab, {"C5_XEMLAUD"    	, SCJ->CJ_XEMLAUD				, Nil } )
	aAdd( aCab, {"C5_REDESP"        , SCJ->CJ_XREDESP				, Nil } )
	aAdd( aCab, {"C5_XPROIME"       , SCJ->CJ_XPROIME				, Nil } )
	aAdd( aCab, {"C5_INF_FAT"       , AllTrim(SC5->C5_INF_FAT)+'.'	, Nil } )	//Valida��o SALTO. N�o sai Erro em execauto
	
/*
EURAI  
	If SCJ->CJ_XMOEDA $ "R$"
		aAdd( aCab, {"C5_MOEDA"       , 1		, Nil } )
	ElseIf SCJ->CJ_XMOEDA $ "US/USD/US$"
		aAdd( aCab, {"C5_MOEDA"       , 2		, Nil } )
	ElseIf SCJ->CJ_XMOEDA $ "EU/EUR"
		aAdd( aCab, {"C5_MOEDA"       , 4		, Nil } )
	Endif
*/
	
	If Alltrim(SCJ->CJ_XMOEDA) $ "R$"
		aAdd( aCab, {"C5_MOEDA"       , 1		, Nil } )
	ElseIf Alltrim(SCJ->CJ_XMOEDA) $ "US$/US"
		aAdd( aCab, {"C5_MOEDA"       , 2		, Nil } )
	ElseIf Alltrim(SCJ->CJ_XMOEDA) $ "AUD"
		aAdd( aCab, {"C5_MOEDA"       , 3		, Nil } )
	ElseIf Alltrim(SCJ->CJ_XMOEDA) $ "USD"
		aAdd( aCab, {"C5_MOEDA"       , 4		, Nil } )
	ElseIf Alltrim(SCJ->CJ_XMOEDA) $ "EUR"
		aAdd( aCab, {"C5_MOEDA"       , 5		, Nil } )
	ElseIf Alltrim(SCJ->CJ_XMOEDA) $ "SEK"
		aAdd( aCab, {"C5_MOEDA"       , 6		, Nil } )
	ElseIf Alltrim(SCJ->CJ_XMOEDA) $ "EU"
		aAdd( aCab, {"C5_MOEDA"       , 7		, Nil } )
	ElseIf Alltrim(SCJ->CJ_XMOEDA) $ "GBP"
		aAdd( aCab, {"C5_MOEDA"       , 8		, Nil } )
	ElseIf Alltrim(SCJ->CJ_XMOEDA) $ "LB"
		aAdd( aCab, {"C5_MOEDA"       , 9		, Nil } )
	ElseIf Alltrim(SCJ->CJ_XMOEDA) $ "JYP"
		aAdd( aCab, {"C5_MOEDA"       , 11		, Nil } )
	Endif	
	
		
	Do While SCK->( !EOF() ) ;
		.AND. SCK->CK_NUM == SCJ->CJ_NUM
	
		If SCK->CK_XITFAT == 'N'
			SCK->( dbSkip() )
			Loop
		Endif
/*
// Eurai		
		If !SC6->( dbSeek( SCK->CK_FILIAL + SCK->CK_NUMPV + SCK->CK_ITEM ) )
			MsgInfo('Item Pedido n�o Encontrado: ' + SCK->CK_NUMPV + ' / ' + SCK->CK_ITEM)
			lRet := .F.; Break
		Endif
*/

// Almir - 11/07/18 - substituindo If acima
		cQuery := " SELECT C6_NUM,C6_ITEM FROM "+RetSqlName("SC6")
		cQuery += " WHERE C6_FILIAL = '"+SCK->CK_FILIAL+"' AND C6_NUMORC = '"+SCK->CK_NUM+SCK->CK_ITEM+"'"
		cQuery += " AND "+RetSqlName("SC6")+".D_E_L_E_T_ <> '*'"
		TcQuery cQuery New Alias (cAliasSC6)
		(cAliasSC6)->(DbGoTop())
		If !SC6->( dbSeek( SCK->CK_FILIAL + (cAliasSC6)->C6_NUM + (cAliasSC6)->C6_ITEM ) )
			MsgInfo('Item Pedido n�o Encontrado: ' + SCK->CK_NUMPV + ' / ' + SCK->CK_ITEM)
			lRet := .F.; Break
		Endif


		If !SF4->( dbSeek( xFilial('SF4',SCK->CK_FILIAL) + SCK->CK_TES ) )
			MsgInfo('TES n�o Encontrada: ' + SCK->CK_TES)
			lRet := .F.; Break
		Endif	
		//dDataBase	:= SCK->CK_ENTREG
	
		aDadosCfo	:= {}
	 	aAdd( aDadosCfo, { "OPERNF"		, "S" 				} )
	 	aAdd( aDadosCfo, { "TPCLIFOR"	, SA1->A1_TIPO	 	} )
	 	aAdd( aDadosCfo, { "UFDEST"		, SA1->A1_EST 		} )
	 	aAdd( aDadosCfo, { "INSCR"		, SA1->A1_INSCR 	} )
		aAdd( aDadosCfo, { "CONTR"		, SA1->A1_CONTRIB 	} )
		cCFOP	:= MaFisCfo( , SF4->F4_CF, aDadosCfo )	
		
		aItem	:= {}
		aAdd( aItem, {"C6_ITEM"		, SC6->C6_ITEM			, Nil } )
		aAdd( aItem, {"C6_PRODUTO"	, SC6->C6_PRODUTO		, Nil } )
		aAdd( aItem, {"C6_TES"		, SCK->CK_TES			, Nil } )
		aAdd( aItem, {"C6_QTDVEN"	, SC6->C6_QTDVEN		, Nil } )
		aAdd( aItem, {"C6_PRCVEN"	, SCK->CK_PRCVEN		, Nil } )
		aAdd( aItem, {"C6_PRUNIT"	, SCK->CK_PRUNIT		, Nil } )
		aAdd( aItem, {"C6_VALOR"	, SCK->CK_VALOR			, Nil } )
		aAdd( aItem, {"C6_ENTREG"	, SCK->CK_ENTREG		, ".T." } )
		aAdd( aItem, {"C6_CLASFIS"	, SCK->CK_CLASFIS		, Nil } )
		aAdd( aItem, {"C6_CF"		, cCFOP					, Nil } )
		aAdd( aItem, {"C6_NUMORC"	, SC6->C6_NUMORC		, Nil } )
	
		aAdd( aItens, aItem )
	
		SCK->( dbSkip() )
	EndDo
	
	
	FWMsgRun( , {|| MSExecAuto( { |UA,ER,AM| MATA410(UA,ER,AM) } , aCab , aItens , 4 ) }, 'FEFATC01', "Atualizando PV" )
	
	If lMSErroAuto
		MostraErro()
		lRet := .F.; Break
//	Else
//		U_FEFATA12(.F.)	//	nao liberar local 15
//		MsgInfo("Pedido Atualizado com Sucesso!!",SC5->C5_NUM)
	Endif


Else

	RecLock('SC5',.F.)

		SC5->C5_NUM 		:= SCK->CK_NUMPV
		SC5->C5_CLIENTE		:= SCJ->CJ_CLIENTE
		SC5->C5_LOJACLI		:= SCJ->CJ_LOJA
		SC5->C5_CLIENT		:= SCJ->CJ_CLIENT
		SC5->C5_LOJAENT		:= SCJ->CJ_LOJAENT
		xTemp	:= If( Empty(SCJ->CJ_TIPOCLI), SA1->A1_TIPO, SCJ->CJ_TIPOCLI )
		SC5->C5_TIPOCLI		:= xTemp
		SC5->C5_CONDPAG		:= SCJ->CJ_CONDPAG
		xTemp	:= If( Empty(SCJ->CJ_TABELA), Space( Len( SC5->C5_TABELA ) ), SCJ->CJ_TABELA )
		SC5->C5_TABELA		:= xTemp
		SC5->C5_DESC1		:= SCJ->CJ_DESC1
		SC5->C5_DESC2		:= SCJ->CJ_DESC2
		SC5->C5_DESC3		:= SCJ->CJ_DESC3
		SC5->C5_DESC4		:= SCJ->CJ_DESC4
		SC5->C5_FRETE		:= SCJ->CJ_FRETE
		SC5->C5_SEGURO		:= SCJ->CJ_SEGURO
		SC5->C5_DESPESA		:= SCJ->CJ_DESPESA
		SC5->C5_FRETAUT		:= SCJ->CJ_FRETAUT
		SC5->C5_ACRSFIN		:= SE4->E4_ACRSFIN
		SC5->C5_MOEDA		:= SCJ->CJ_MOEDA
		SC5->C5_TXMOEDA		:= SCJ->CJ_TXMOEDA
		SC5->C5_TIPLIB		:= SCJ->CJ_TIPLIB
		SC5->C5_TPCARGA		:= SCJ->CJ_TPCARGA
		SC5->C5_DESCONT		:= SCJ->CJ_DESCONT
		SC5->C5_PDESCAB		:= SCJ->CJ_PDESCAB
		//SC5->C5_PAISENT		:= SA1->A1_PAIS
		
		For nX :=  1 To nParcTp9
			
			cCampo := SubStr( cParcela, nX, 1 ) 
			
			&('SC5->C5_PARC'+cCampo)		:= SCJ->&('CJ_PARC'+cCampo)	
			&('SC5->C5_DATA'+cCampo)		:= SCJ->&('CJ_DATA'+cCampo)
			
		Next nX
		
		For nX := 1 To nMaxVend
		
			If SCJ->(FieldPos('CJ_VEND'+cVend)) > 0
				&('SC5->C5_VEND'+cVend)			:= SCJ->&('CJ_VEND'+cVend)
			Endif
		
			If SCJ->(FieldPos('C5_COMIS'+cVend)) > 0
				&('SC5->C5_COMIS'+cVend)		:= SCJ->&('CJ_COMIS'+cVend)
			Endif
			
			cVend := Soma1(cVend,1)
				
		Next nX
		
		SC5->C5_VIA			:= SCJ->CJ_VIA
		SC5->C5_DEP_COM		:= SCJ->CJ_DEP_COM
		SC5->C5_MENPAD		:= SCJ->CJ_MENPAD
		SC5->C5_TIPO		:= SCJ->CJ_XTIPO
		SC5->C5_TRANSP		:= SCJ->CJ_TRANSP
		SC5->C5_TRIANGU		:= SCJ->CJ_TRIANGU
		SC5->C5_MENREM		:= SCJ->CJ_MENREM
		SC5->C5_TESREM		:= SCJ->CJ_TESREM
		SC5->C5_TPFRETE 	:= SCJ->CJ_TPFRETE
		SC5->C5_VOLUME1 	:= SCJ->CJ_VOLUME1
		SC5->C5_ESPECI1 	:= SCJ->CJ_ESPECI1
		SC5->C5_INF_FAT 	:= SCJ->CJ_INF_FAT
		SC5->C5_AMOSTRA 	:= SCJ->CJ_AMOSTRA
		SC5->C5_LAUDO		:= SCJ->CJ_LAUDO
		SC5->C5_FRETE		:= SCJ->CJ_FRETE
		SC5->C5_REAJUST 	:= SCJ->CJ_REAJUST
		SC5->C5_MENNOTA 	:= SCJ->CJ_MENNOTA
		SC5->C5_MENNOT1 	:= SCJ->CJ_MENNOT1
		SC5->C5_MENNOT2 	:= SCJ->CJ_MENNOT2
		SC5->C5_MENNOT3 	:= SCJ->CJ_MENNOT3
		//SC5->C5_VEND1		:= SCJ->CJ_VEND1
		SC5->C5_PBRUTO 		:= SCJ->CJ_PBRUTO
		SC5->C5_PESOL		:= SCJ->CJ_PESOL
		SC5->C5_NATUREZ		:= SCJ->CJ_NATUREZ
		SC5->C5_COTCLI		:= SCJ->CJ_COTCLI
		SC5->C5_XGERBOL		:= SCJ->CJ_XGERBOL
		SC5->C5_XEMLAUD		:= SCJ->CJ_XEMLAUD
		SC5->C5_REDESP		:= SCJ->CJ_XREDESP
		SC5->C5_XPROIME		:= SCJ->CJ_XPROIME
		SC5->C5_INF_FAT		:= AllTrim(SC5->C5_INF_FAT) + '.'	//Valida��o SALTO. N�o sai Erro em execauto
		
/*
Eurai
		If SCJ->CJ_XMOEDA $ "R$"
			SC5->C5_MOEDA		:= 1
		ElseIf SCJ->CJ_XMOEDA $ "US/USD/US$"
			SC5->C5_MOEDA		:= 2
		ElseIf SCJ->CJ_XMOEDA $ "EU/EUR"
			SC5->C5_MOEDA		:= 4
		Endif
*/

		If Alltrim(SCJ->CJ_XMOEDA) $ "R$"
			SC5->C5_MOEDA		:= 1
		ElseIf Alltrim(SCJ->CJ_XMOEDA) $ "US$/US"
			SC5->C5_MOEDA		:= 2
		ElseIf Alltrim(SCJ->CJ_XMOEDA) $ "AUD"
			SC5->C5_MOEDA		:= 3
		ElseIf Alltrim(SCJ->CJ_XMOEDA) $ "USD"
			SC5->C5_MOEDA		:= 4
		ElseIf Alltrim(SCJ->CJ_XMOEDA) $ "EUR"
			SC5->C5_MOEDA		:= 5
		ElseIf Alltrim(SCJ->CJ_XMOEDA) $ "SEK"
			SC5->C5_MOEDA		:= 6
		ElseIf Alltrim(SCJ->CJ_XMOEDA) $ "EU"
			SC5->C5_MOEDA		:= 7
		ElseIf Alltrim(SCJ->CJ_XMOEDA) $ "GBP"
			SC5->C5_MOEDA		:= 8
		ElseIf Alltrim(SCJ->CJ_XMOEDA) $ "LB"
			SC5->C5_MOEDA		:= 9
		ElseIf Alltrim(SCJ->CJ_XMOEDA) $ "JYP"
			SC5->C5_MOEDA		:= 11
		Endif	



	SC5->( MsUnlock() )
	lCancelado := .T.
	Do While SCK->( !EOF() ) ;
		.AND. SCK->CK_NUM == SCJ->CJ_NUM

		If SCK->CK_XITFAT == 'N'

//	Almir - 11/07/18
			cQuery := " SELECT C6_NUM,C6_ITEM FROM "+RetSqlName("SC6")
			cQuery += " WHERE C6_FILIAL = '"+SCK->CK_FILIAL+"' AND C6_NUMORC = '"+SCK->CK_NUM+SCK->CK_ITEM+"'"
			cQuery += " AND "+RetSqlName("SC6")+".D_E_L_E_T_ <> '*'"
			TcQuery cQuery New Alias (cAliasSC6)
			(cAliasSC6)->(DbGoTop())
			If SC6->( dbSeek( SCK->CK_FILIAL + (cAliasSC6)->C6_NUM + (cAliasSC6)->C6_ITEM ) )
				If AllTrim( SC6->C6_BLQ ) <> 'R'
					If !MaResDoFat(,.T.,.T.)
						Help( ,, 'HELP',, '[FEFATC01/CJtoC5]Erro na elimina��o de residuo: ' + SCK->CK_NUMPV + SCK->CK_ITEM, 1, 0)
					Endif
				Endif
			Else

/*
			Original Eurai
			If SC6->( dbSeek( xFilial("SC6") + SCK->CK_NUMPV + SCK->CK_ITEM ) )
				If AllTrim( SC6->C6_BLQ ) <> 'R'
					If !MaResDoFat(,.T.,.T.)
						Help( ,, 'HELP',, '[FEFATC01/CJtoC5]Erro na elimina��o de residuo: ' + SCK->CK_NUMPV + SCK->CK_ITEM, 1, 0)
					Endif
				Endif
			Else
*/
				//Help( ,, 'HELP',, '[FEFATA13]Item do Pedido n�o encontrado: ' + SCK->CK_NUMPV + SCK->CK_ITEM, 1, 0)

			Endif		
			(cAliasSC6)->(DbCloseArea())		
			SCK->( dbSkip() )
			Loop

		Endif

/*
Original Eurai
		If !SC6->( dbSeek( SCK->CK_FILIAL + SCK->CK_NUMPV + SCK->CK_ITEM ) )
			MsgInfo('[FEFATC01/CJtoC5]Item Pedido n�o Encontrado: ' + SCK->CK_NUMPV + ' / ' + SCK->CK_ITEM)
			lRet := .F.; Break
		Endif
*/

//	Almir - 11/06/18 substituindo If acima (errado)
//		Inicialmente o CK 020559 tinha 5 itens porem o primeiro foi exclu�do, ficando os itens 2, 3, 4, 5. 
//		Quando virou pedido, foram criados os itens 1, 2, 3, 4, da forma que esta o programa n�o acha o item 5 do PV
//		e os que acha, posicoina no item errado!


		cQuery := " SELECT C6_NUM,C6_ITEM FROM "+RetSqlName("SC6")
		cQuery += " WHERE C6_FILIAL = '"+SCK->CK_FILIAL+"' AND C6_NUMORC = '"+SCK->CK_NUM+SCK->CK_ITEM+"'"
		cQuery += " AND "+RetSqlName("SC6")+".D_E_L_E_T_ <> '*'"
		TcQuery cQuery New Alias (cAliasSC6)
		(cAliasSC6)->(DbGoTop())
		If (cAliasSC6)->(Eof())
			MsgInfo('[FEFATC01/CJtoC5]Item Pedido n�o Encontrado: ' + SCK->CK_NUMPV + ' / ' + SCK->CK_ITEM)
			lRet := .F.; Break
		Else
			SC6->( dbSeek( SCK->CK_FILIAL + (cAliasSC6)->C6_NUM + (cAliasSC6)->C6_ITEM ) )
   		Endif
		(cAliasSC6)->(DbCloseArea())


		If !SF4->( dbSeek( xFilial('SF4',SCK->CK_FILIAL) + SCK->CK_TES ) )
			MsgInfo('[FEFATC01/CJtoC5]TES n�o Encontrada: ' + SCK->CK_TES)
			lRet := .F.; Break
		Endif	

		lCancelado := .F.


		//dDataBase	:= SCK->CK_ENTREG
	
		aDadosCfo	:= {}
	 	aAdd( aDadosCfo, { "OPERNF"		, "S" 				} )
	 	aAdd( aDadosCfo, { "TPCLIFOR"	, SA1->A1_TIPO	 	} )
	 	aAdd( aDadosCfo, { "UFDEST"		, SA1->A1_EST 		} )
	 	aAdd( aDadosCfo, { "INSCR"		, SA1->A1_INSCR 	} )
		aAdd( aDadosCfo, { "CONTR"		, SA1->A1_CONTRIB 	} )
		cCFOP	:= MaFisCfo( , SF4->F4_CF, aDadosCfo )	
		
		
		RecLock('SC6',.F.)
		
			SC6->C6_ITEM		:= SC6->C6_ITEM	
			SC6->C6_PRODUTO		:= SC6->C6_PRODUTO
			SC6->C6_TES			:= SCK->CK_TES
			SC6->C6_QTDVEN		:= SC6->C6_QTDVEN
			SC6->C6_PRCVEN		:= SCK->CK_PRCVEN
			SC6->C6_PRUNIT		:= SCK->CK_PRUNIT
			SC6->C6_VALOR		:= SCK->CK_VALOR
			SC6->C6_ENTREG		:= SCK->CK_ENTREG
			SC6->C6_CLASFIS		:= SCK->CK_CLASFIS
			SC6->C6_CF			:= cCFOP
			SC6->C6_NUMORC		:= SC6->C6_NUMORC
			
		SC6->( MsUnlock() )
		
		If SC9->( dbSeek( SC6->C6_FILIAL + SC6->C6_NUM + SC6->C6_ITEM ) )
		
			Do While SC9->( !EOF() ) ;
				.AND. SC9->C9_PEDIDO + SC9->C9_ITEM == SC6->C6_NUM + SC6->C6_ITEM

				If Empty(SC9->C9_NFISCAL)
				
					RecLock('SC9',.F.)
					
						SC9->C9_PRCVEN	:= SC6->C6_PRCVEN
						SC9->C9_DATENT	:= SC6->C6_ENTREG
					
					SC9->( MsUnlock() )
				
				Endif

			
				SC9->( dbSkip() )
			EndDo
		
		Endif
		
	
		SCK->( dbSkip() )
	EndDo

	
	If lCancelado
		
		RecLock('SCJ', .F. )
			SCJ->CJ_XSTATUS		:= '15'
			SCJ->CJ_STATUS		:= 'C'
			SCJ->CJ_SPLAN   	:= "5"
			SCJ->CJ_XROTCAN		:= 'FEFATA13'
			SCJ->CJ_XUSRCAN		:= __cUserID
		SCJ->( MsUnlock() )
		
		RecLock('SC5', .F. )
			SC5->C5_SPLAN   	:= "5"
		SC5->( MsUnlock() )		
		
	Endif

	If lOPE_TRI
		::C5toTriang( SC5->C5_FILIAL, SC5->C5_NUM, SC5->C5_PEDREM )
	Endif

Endif


End Sequence

dDataBase := dBKDtBase
Return( lRet )



/*/{Protheus.doc} DataValida
Valida data de Entrega
Minimo permitido

@type		method
@author		Eurai Rapelli
@since 		2016.10.20

@example	oFEFATC01 := FEFATC01():New(); lRet  := oFEFATC01:DataValida( dDataVer, lCast )
/*/
Method DataValida( dDataVer, lCast ) Class FEFATC01
Local nDIAS		:= 0
Local dDataValid:= 0
Local lRet		:= .T.

Default dDataVer	:= M->CJ_XDTENTR
Default lCast		:= .F.


Begin Sequence

//N�o Validar na Manuten��o
If FwIsInCallStack('U_FEFATA13')
	Break
Endif

If Empty(dDataVer)
	Help( ,, 'HELP',, '[FEFATC01:DataValida]Data valida��o Branco [PROGRAMA��O/ENTREGA]', 1, 0)
	lRet := .F.;Break	
Endif


If Dow(dDataVer) == 7
	Help( ,, 'HELP',, '[FEFATC01:DataValida]Sabado, n�o permitido: ' + Dtoc(dDataVer), 1, 0)
	lRet := .F.;Break
Endif

If Dow(dDataVer) == 1
	Help( ,, 'HELP',, '[FEFATC01:DataValida]Domingo, n�o permitido: ' + Dtoc(dDataVer), 1, 0)
	lRet := .F.;Break
Endif

//If dDataVer <> DataValida(dDataVer)
//	Help( ,, 'HELP',, '[FEFATC01:DataValida]Feriado: ' + Dtoc(dDataValid), 1, 0)
//	lRet := .F.;Break
//Endif


If lCast

	cHoraLim	:= "15:00:00" 

	If Time() <= cHoraLim
		nDIAS := 1 
	Else 
		nDIAS := 2 
	Endif

Else

	cHoraLim	:= "12:00:00" 

	If Time() <= cHoraLim
		nDIAS := 1 
	Else 
		nDIAS := 2 
	Endif

Endif 

dDataValid := Date() + nDias 
If Dow(dDataValid) == 7 
	dDataValid := dDataValid + 2 
ElseIf Dow(dDataValid) == 1 
	dDataValid := dDataValid + 1 
Endif

If dDataVer <> DataValida(dDataVer)
	Help( ,, 'HELP',, '[FEFATC01:DataValida]Feriado: ' + Dtoc(dDataValid), 1, 0)
	lRet := .F.;Break
Endif

If dDataVer < dDataValid
	Help( ,, 'HELP',, '[FEFATC01:DataValida]Data menor que o permitido: ' + Dtoc(dDataValid) + ' Hora Lim: ' + cHoraLim, 1, 0)
	lRet := .F.;Break
Endif



End Sequence


Return( lRet )



/*/{Protheus.doc} DelForLog
Deleta os LOGs

@type		method	
@author		Eurai Rapelli
@since 		2017.08.29

@example	Local oFEFATC01 := FEFATC01():New(); oFEFATC01:DelForLog()
/*/
Method DelForLog() Class FEFATC01

If Select("UAERSCJ") > 0
	UAERSCJ->( dbCloseArea() )
Endif
If Select("UAERSCK") > 0
	UAERSCK->( dbCloseArea() )
Endif
If File( ::cArqSCJ + GetDbExtension() )
	fErase( ::cArqSCJ + GetDbExtension() )
Endif

Return( Nil )



/*/{Protheus.doc} DetailsUA
Grava o log de manuten��o do SCK

@type		method	
@author		Eurai Rapelli
@since 		2017.01.03

@example	Local oFEFATC01 := FEFATC01():New(); oFEFATC01:DetailsUA()
/*/
Method DetailsUA() Class FEFATC01
Local oDlg			:= Nil
Local oBar01		:= Nil
Local oBtnBmp01		:= Nil
Local oBtnBmp02		:= Nil

Local oFolder01		:= Nil

Local cAlias01a		:= 'SCJ'
Local cAlias01b		:= 'SCJ_UAAM'
Local cFiltro01		:= 'CJ_NUM = "'+SCJ->CJ_NUM+'" '
Local aStructSCJ	:= SCJ->( dbStruct() )

Local cAlias02a		:= 'SCK'
Local cAlias02b		:= 'SCK_UAAM'
Local cFiltro02		:= 'CK_NUM = "'+SCJ->CJ_NUM+'" '
Local aStructSCK	:= SCK->( dbStruct() )

dbUseArea( .T.,"TOPCONN", RetSqlName("SCJ"), cAlias01b, .T., .F. ) 
dbUseArea( .T.,"TOPCONN", RetSqlName("SCK"), cAlias02b, .T., .F. )

(cAlias01b)->( dbSetFilter( { || &cFiltro01 }, cFiltro01 ) )
(cAlias02b)->( dbSetFilter( { || &cFiltro02 }, cFiltro02 ) )


oDlg			:= MSDialog():New( 000,000,520,1030,"DetailsUA",,,.F.,,,,,,.T.,,,.T. )
oDlg:lMaximized	:= .T.

oFolder01		:= TFolder():New( 0,0,{'SCJ','SCK'},,oDlg,,,,.T.,,260,184 )
oFolder01:Align	:= CONTROL_ALIGN_ALLCLIENT



oBrw01				:= TCBrowse():New( 02,02,(oFolder01:nWidth/2)-6,(oFolder01:nHeight/2)-50, , , , oFolder01:aDialogs[1],,,,,,,,,,,, .F., cAlias01b, .T.,, .F., , ,.F. )
//oBrw01 				:= MsBrGetDBase():New( 0, 0, 0, 0,,,, oFolder01:aDialogs[1],,,,,,,,,,,, .F., cAlias01b, .T.,, .F.,,, )
oBrw01:Align 		:= CONTROL_ALIGN_ALLCLIENT
oBrw01:lLineDrag	:= .T.
oBrw01:lColDrag		:= .T.


SX3->(dbSetOrder(1))
SX3->(dbSeek(cAlias01a))
Do While SX3->(!EOF()) .AND. SX3->X3_ARQUIVO == cAlias01a
	
	If SX3->X3_CONTEXT == "V"
		SX3->( dbSkip() )
		Loop
	EndIf
	
	//oBrw01:AddColumn( TCColumn():New( Trim(X3Titulo()), FieldWBlock( SX3->X3_CAMPO, Select(cAlias01b) ),AllTrim(SX3->X3_PICTURE),,, If(SX3->X3_TIPO=="N","RIGHT","LEFT"), CalcFieldSize(SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_PICTURE,X3Titulo()), .F., .F.,,,, .F., ) )
	oBrw01:AddColumn( TCColumn():New( AllTrim(SX3->X3_CAMPO), FieldWBlock( SX3->X3_CAMPO, Select(cAlias01b) ),AllTrim(SX3->X3_PICTURE),,, If(SX3->X3_TIPO=="N","RIGHT","LEFT"), CalcFieldSize(SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_PICTURE,X3Titulo()), .F., .F.,,,, .F., ) )
	
	SX3->(DbSkip())
EndDo

//SduEditCel(oBrow,oBrow:nColPos
//MsBrGetDBase
oBrw02				:= TCBrowse():New( 02,02,(oFolder01:nWidth/2)-6,(oFolder01:nHeight/2)-50, , , , oFolder01:aDialogs[2],,,,,,,,,,,, .F., cAlias02b, .T.,, .F., , ,.F. )
//oBrw02 				:= MsBrGetDBase():New( 0, 0, 0, 0,,,, oFolder01:aDialogs[2],,,,,,,,,,,, .F., cAlias02b, .T.,, .F.,,, )
oBrw02:Align 		:= CONTROL_ALIGN_ALLCLIENT
oBrw02:lLineDrag	:= .T.
oBrw02:lColDrag		:= .T.


SX3->(dbSetOrder(1))
SX3->(dbSeek(cAlias02a))
Do While SX3->(!EOF()) .AND. SX3->X3_ARQUIVO == cAlias02a
	
	If SX3->X3_CONTEXT == "V"
		SX3->( dbSkip() )
		Loop
	EndIf
	
	//oBrw02:AddColumn( TCColumn():New( Trim(X3Titulo()), FieldWBlock( SX3->X3_CAMPO, Select(cAlias02b) ),AllTrim(SX3->X3_PICTURE),,, If(SX3->X3_TIPO=="N","RIGHT","LEFT"), CalcFieldSize(SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_PICTURE,X3Titulo()), .F., .F.,,,, .F., ) )
	oBrw02:AddColumn( TCColumn():New( AllTrim(SX3->X3_CAMPO), FieldWBlock( SX3->X3_CAMPO, Select(cAlias02b) ),AllTrim(SX3->X3_PICTURE),,, If(SX3->X3_TIPO=="N","RIGHT","LEFT"), CalcFieldSize(SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_PICTURE,X3Titulo()), .F., .F.,,,, .F., ) )
	
	SX3->(DbSkip())
EndDo
oBrw01:Refresh()
oBrw02:Refresh()
oBrw01:bLDblClick	:= {|| dbSelectArea(cAlias01b), EditCelUA( oBrw01, oBrw01:nColPos, aStructSCJ ) }
oBrw02:bLDblClick	:= {|| dbSelectArea(cAlias02b), EditCelUA( oBrw02, oBrw02:nColPos, aStructSCK ) }

oBar01			:= TBar():New( oDlg,25,35,.T.,,,'backgroundblack',.T. )
oBtnBmp01 		:= TBtnBmp2():New( 000, 000, 035, 070, 'FINAL' ,,,,		{|| oDlg:End() }, oBar01,'Fechar',,.F.,.F. )

oDlg:Activate(,,,.T.)  

SCJ_UAAM->( dbCloseArea() )
SCK_UAAM->( dbCloseArea() )

Return( Nil )


/*/{Protheus.doc} ExcluiApr
Exclui aprova��o da ZB3

@type		method
@author		Eurai Rapelli
@since 		2016.06.28

@param		cNumSCJ			, Caracter		, Numero SCJ - Busca

@example	oFEFATC01:ExcluiApr( cNumSCJ, cRevisao )
/*/
Method ExcluiApr( cNumSCJ, cRevisao ) CLASS FEFATC01
Local cQuery		:= ""

Default cNumSCJ		:= SCJ->CJ_NUM
Default cRevisao	:= SCJ->CJ_XREVISA


If Select("QryExc") > 0//Verifica se ja existe alias criado
	QryExc->( dbCloseArea() )
Endif

cQuery := cCRLF + "	SELECT  "
cQuery += cCRLF + "		ZB3.R_E_C_N_O_ AS ZB3RECNO "
cQuery += cCRLF + "	FROM "
cQuery += cCRLF + RetSqlName("ZB3") + " ZB3 "
cQuery += cCRLF + "	WHERE "
cQuery += cCRLF + "		ZB3_FILIAL 		= '" + xFilial('ZB3') + "' "
cQuery += cCRLF + " 	AND ZB3_ID	 	= '" + cNumSCJ + "' "
cQuery += cCRLF + " 	AND ZB3_TIPO 	= '" + ::GetTpLib() + "' "
cQuery += cCRLF + " 	AND ZB3_REVISA 	= '" + cRevisao + "' "
cQuery += cCRLF + " 	AND ZB3.D_E_L_E_T_ <> '*' "

DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQuery)),"QryExc",.T.,.T.)

Do While QryExc->( !EOF() )
	
	ZB3->( dbGoTo( QryExc->ZB3RECNO ) )
	
	Reclock( "ZB3",.F. )
				
		ZB3->( dbDelete() )
				
	ZB3->( MsUnlock() )
				
	QryExc->( dbSkip() )
EndDo

QryExc->( dbCloseArea() )

Return( Nil )



/*/{Protheus.doc} FCIOrigem
Retorna Origem da Tabela FCI

@type		method
@author		Eurai Rapelli
@since 		2016.09.14
/*/
Method FCIOrigem( cCodProd , dDtEmissao ) CLASS FEFATC01
Local cFilialCFD 	:= xFilial("CFD")
Local cPeriod 		:= ''

Local nI			:= 1

Local lRet			:= .F.

If SA1->A1_EST <> 'SP'

	If AliasInDic( "CFD" ) .And. CFD->( FieldPos( "CFD_ORIGEM" ) ) > 0         
	    
	    CFD->( dbSetOrder( 2 ) )
	    For nI := 1 to 12

			cPeriod := Alltrim( StrZero( Month( dDtEmissao ) , 2 ) ) + Alltrim( Str( Year( dDtEmissao ) ) )
	    
			If CFD->( MsSeek( cFilialCFD + cCodProd + cPeriod ) )
			
				If CFD->CFD_ORIGEM == '3' .OR. CFD->CFD_ORIGEM == '8'
					lRet			:= .T.
				Endif
				
				Exit
				
			Endif
			
			dDtEmissao := MonthSub( dDtEmissao, 1 )
			
		Next nI
		
	Endif

Endif	

Return( lRet )


/*/{Protheus.doc} GetAprov
Retorna array com os aprovadores

@type		method
@author		Eurai Rapelli
@since 		2016.06.28

@param		nValor		, Numerico		, Valor para definir quem ser�o os niveis

@example	aAprovador := oFEFATC01:GetAprov( nValor )
/*/
Method GetAprov( nValor ) CLASS FEFATC01
Local cQuery		:= ""

Local aAprovador	:= {}

Default nValor		:= 0

/*aAprovador
aAprovador[nI,01]	:= Nivel
aAprovador[nI,02]	:= C�digo usu�rio sistema
*/

If Select("QryApr") > 0//Verifica se ja existe alias criado
	QryApr->( dbCloseArea() )
Endif

cQuery := cCRLF + "	SELECT  "
cQuery += cCRLF + "		ZB2.* "
cQuery += cCRLF + "	FROM "
cQuery += cCRLF + RetSqlName("ZB1") + " ZB1 "
cQuery += cCRLF + "	INNER JOIN "
cQuery += cCRLF + RetSqlName("ZB2") + " ZB2 "
cQuery += cCRLF + "	ON "
cQuery += cCRLF + "		ZB1_FILIAL = ZB2_FILIAL "
cQuery += cCRLF + "		AND ZB1_ID = ZB2_ID "
cQuery += cCRLF + "	WHERE "
cQuery += cCRLF + "		ZB1_FILIAL		= '" + xFilial('ZB1') + "' "
cQuery += cCRLF + " 	AND ZB1_TIPO 	= '" + ::GetTpLib() + "' "
cQuery += cCRLF + " 	AND ZB1_MSBLQL 	= '2' "
cQuery += cCRLF + " 	AND ZB1.D_E_L_E_T_ <> '*' "
cQuery += cCRLF + " 	AND ZB2.D_E_L_E_T_ <> '*' "
cQuery += cCRLF + "	ORDER BY "
cQuery += cCRLF + "		ZB2_ID,ZB2_NIVEL "

DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQuery)),"QryApr",.T.,.T.)

Do While QryApr->( !EOF() )

	aAdd( aAprovador, { QryApr->ZB2_NIVEL, QryApr->ZB2_USRAPR } )
	If nValor <= QryApr->ZB2_VLIMIT
		Exit
	Endif

	QryApr->( dbSkip() )
EndDo
QryApr->( dbCloseArea() )

Return( aAprovador )


/*/{Protheus.doc} GeraAlcApr
Grava as al�adas na ZB3

@type		method
@author		Eurai Rapelli
@since 		2016.06.28

@param		cNumSCJ				, Caracter	, Numero Pedido
@param		aAprovador			, Array		, Array com aprovadores da al�ada

@example	oFEFATC01:GeraAlcApr( cNumSCJ, aAprovador, cRevisao )
/*/
Method GeraAlcApr( cNumSCJ, aAprovador, cRevisao ) CLASS FEFATC01
Local nI			:= 0

Default cNumSCJ		:= ''
Default	aAprovador	:= {}

Begin Sequence

If Empty( cNumSCJ )
	Break
Endif

::ExcluiApr( cNumSCJ, cRevisao )

For nI := 1 to Len( aAprovador )

	If !ZB3->( dbSeek( xFilial('ZB3') + ::cTpLib + cNumSCJ + aAprovador[nI,01] ) )

		Reclock( "ZB3",.T. )
		
			ZB3->ZB3_FILIAL		:= xFilial('ZB3')
			ZB3->ZB3_ID			:= cNumSCJ
			ZB3->ZB3_TIPO		:= ::cTpLib 
			ZB3->ZB3_USER		:= RetCodUsr()
			ZB3->ZB3_STATUS		:= 'B'
			ZB3->ZB3_EMISSA		:= Date()
			ZB3->ZB3_HORA		:= Time()
			ZB3->ZB3_NIVEL		:= aAprovador[nI,01]
			ZB3->ZB3_APROV		:= aAprovador[nI,02]
			ZB3->ZB3_OBS		:= "ORCAMENTO BLOQUEADO PARA APROVACAO"
			ZB3->ZB3_REVISA		:= cRevisao
	
		ZB3->( MsUnlock() )
		
	Endif

Next nI

End Sequence
		
Return( Nil )


/*/{Protheus.doc} GetCJBruto
Grava o log de manuten��o do SCK

@type		method	
@author		Eurai Rapelli
@since 		2017.01.03

@example	Local oFEFATC01 := FEFATC01():New(); oFEFATC01:GetCJBruto()
/*/
Method GetCJBruto() Class FEFATC01
Local cFilialSB1:= xFilial('SB1')

Local aTmp		:= {}
Local aProd		:= {}

Local aAreaTMP1	:= TMP1->( GetArea() )


SA1->( MsSeek( xFilial('SA1') + M->CJ_CLIENTE + M->CJ_LOJA ) )

TMP1->( dbGoTop() )
Do While TMP1->( !EOF() )

	If TMP1->CK_FLAG .OR. TMP1->CK_XITFAT == 'N'
		TMP1->( dbSkip() )
		Loop
	Endif

	SB1->( MsSeek( cFilialSB1 + TMP1->CK_PRODUTO ) )

	aTmp 		:= Array(15)
	
	aTmp[01] 	:= TMP1->CK_PRODUTO						//Codigo do Produto ( Obrigatorio )
	aTmp[02] 	:= TMP1->CK_TES							//Codigo do TES ( Opcional )
	aTmp[03] 	:= TMP1->CK_QTDVEN						//Quantidade ( Obrigatorio ) 
	aTmp[04] 	:= TMP1->CK_PRCVEN						//Preco Unitario ( Obrigatorio )
	aTmp[05] 	:= 0									//Valor do Desconto ( Opcional ) 
	aTmp[06] 	:= ""									//Numero da NF Original ( Devolucao/Benef )
	aTmp[07] 	:= ""									//Serie da NF Original ( Devolucao/Benef ) 
	aTmp[08] 	:= 0									//Recno da NF Original no arq SD1/SD2
	aTmp[09] 	:= 0									//Valor do Frete do Item ( Opcional )
	aTmp[10] 	:= 0									//Valor da Despesa do item ( Opcional )
	aTmp[11] 	:= 0									//Valor do Seguro do item ( Opcional )
	aTmp[12] 	:= 0									//Valor do Frete Autonomo ( Opcional )
	aTmp[13] 	:= TMP1->CK_VALOR						//Valor da Mercadoria ( Obrigatorio )
	aTmp[14] 	:= 0									//Valor da Embalagem ( Opiconal )	
	aTmp[15] 	:= SB1->( Recno() )						//SB1->( Recno() )
	
	aAdd( aProd, aTmp )
	

	TMP1->( dbSkip() )
EndDo

aRet 	:= ::oFEGENC01:RetImposto( M->CJ_CLIENTE, M->CJ_LOJA, SA1->A1_TIPO, aProd, { { 1, 'NF_TOTAL'} } )

RestArea(aAreaTMP1)
Return( aRet[01] )


/*/{Protheus.doc} GetFator
Recalcula o Desconto

@type		method
@author		Eurai Rapelli
@since 		2017.05.19
/*/
Method GetFator( cTES, nFator ) CLASS FEFATC01	
Local aRet		:= {}

Local aTmp		:= {}

Local aImps		:= {}


Default cTES	:= ''



nFator	:= 0

SB1->( MsSeek( xFilial('SB1') + TMP1->CK_PRODUTO ) )

aTmp 		:= Array(15)
aTmp[01] 	:= TMP1->CK_PRODUTO						//Codigo do Produto ( Obrigatorio )
aTmp[02] 	:= cTES									//Codigo do TES ( Opcional )
aTmp[03] 	:= TMP1->CK_QTDVEN						//Quantidade ( Obrigatorio ) 
aTmp[04] 	:= TMP1->CK_PRCVEN						//Preco Unitario ( Obrigatorio )
aTmp[05] 	:= 0									//Valor do Desconto ( Opcional ) 
aTmp[06] 	:= ""									//Numero da NF Original ( Devolucao/Benef )
aTmp[07] 	:= ""									//Serie da NF Original ( Devolucao/Benef ) 
aTmp[08] 	:= 0									//Recno da NF Original no arq SD1/SD2
aTmp[09] 	:= 0									//Valor do Frete do Item ( Opcional )
aTmp[10] 	:= 0									//Valor da Despesa do item ( Opcional )
aTmp[11] 	:= 0									//Valor do Seguro do item ( Opcional )
aTmp[12] 	:= 0									//Valor do Frete Autonomo ( Opcional )
aTmp[13] 	:= TMP1->CK_VALOR						//Valor da Mercadoria ( Obrigatorio )
aTmp[14] 	:= 0									//Valor da Embalagem ( Opiconal )	
aTmp[15] 	:= SB1->( Recno() )						//SB1->( Recno() )


//aAdd( aImps, { 1, 'IT_ALIQICM'} )
//aAdd( aImps, { 1, 'IT_ALIQCOF'} )
//aAdd( aImps, { 1, 'IT_ALIQPIS'} )
//aAdd( aImps, { , 'NF_VALICM'} )
//aAdd( aImps, { , 'NF_VALCOF'} )
//aAdd( aImps, { , 'NF_VALPIS'} )
aAdd( aImps, { 1, 'IT_ALIQICM'} )
aAdd( aImps, { 1, 'IT_ALIQCF2'} )
aAdd( aImps, { 1, 'IT_ALIQPS2'} )
aAdd( aImps, { 1, 'IT_ALIQIPI'} )
aAdd( aImps, { 1, 'IT_ALIQCMP'} )

//aAdd( aImps, { 1, 'IT_BASEIPI'} )
//aAdd( aImps, { 1, 'IT_VALIPI'} )
//aAdd( aImps, { 1, 'IT_VALCMP'} )

/*
aAdd( aImps, { 1, 'IT_DIFAL'} )
aAdd( aImps, { 1, 'IT_PDORI'} )
aAdd( aImps, { 1, 'IT_PDDES'} )
aAdd( aImps, { 1, 'IT_ALFCCMP'} )
aAdd( aImps, { 1, 'IT_ALIQCMP'} )
aAdd( aImps, { 1, 'IT_BASEDES'} )
aAdd( aImps, { 1, 'IT_VFCPDIF'} )
aAdd( aImps, { 1, 'NF_VALCMP'} )
*/

//aAdd( aImps, { 1, 'IT_VALICM'} )
//aAdd( aImps, { 1, 'IT_VALCF2'} )
//aAdd( aImps, { 1, 'IT_VALPS2'} )
aRet 	:= ::oFEGENC01:RetImposto( M->CJ_CLIENTE, M->CJ_LOJA, SA1->A1_TIPO, {aTmp}, aImps )


//::cLog	+= cCRLF + VarInfo( "aTmp: ", aTmp, , .F. ) + cCRLF + cCRLF
//::cLog	+= cCRLF + VarInfo( "aImps: ", aImps, , .F. ) + cCRLF + cCRLF
//::cLog	+= cCRLF + VarInfo( "aRet: ", aRet, , .F. ) + cCRLF + cCRLF

If SA1->A1_CONTRIB == '1'
	
	If Len(aRet) == 5
	
		::cLog	+= '[IT_ALIQICM] ' + cValtoChar(aRet[01]) + cCRLF
		::cLog	+= '[IT_ALIQCF2] ' + cValtoChar(aRet[02]) + cCRLF
		::cLog	+= '[IT_ALIQPS2] ' + cValtoChar(aRet[03]) + cCRLF
		
		If aRet[01] > 0
	
			//aRet := XFciGetOrigem( cCodProd , dDtEmissao )
			//If Empty( aRet[01] )
			//Endif
			If ::FCIOrigem( TMP1->CK_PRODUTO , M->CJ_EMISSAO )
				::cLog	+= '[FCIOrigem] 4 ICMS ' + cCRLF
				aRet[01] := 4
			Endif
		
		Endif
		
		nFator 	:= ( 100 - ( aRet[01] + aRet[02] + aRet[03] ) ) / 100
	
		::cLog	+= '[FATOR] ' + cValtoChar(nFator) + cCRLF
	
	Endif

Else
	//025219
If Len(aRet) == 5

	::cLog	+= '[IT_ALIQCF2] ' + cValtoChar(aRet[02]) + cCRLF
	::cLog	+= '[IT_ALIQPS2] ' + cValtoChar(aRet[03]) + cCRLF

	::cLog	+= '[IT_ALIQIPI] ' + cValtoChar(aRet[04]) + cCRLF
	::cLog	+= '[IT_ALIQCMP] ' + cValtoChar(aRet[05]) + cCRLF
	
	
	nFator 	:= ( 1 - ( aRet[05]/100 + aRet[02]/100 + aRet[03]/100 + ( aRet[05]/100 * aRet[04]/100 ) ) )

	::cLog	+= '[FATOR] ' + cValtoChar(nFator) + cCRLF

	Endif

Endif

::nFator := nFator

	
Return( aRet )



/*/{Protheus.doc} GetMotsCan
Retorna motivos de Cancelamento. ZB5

@type		method
@author		Eurai Rapelli
@since 		2017.08.18

@example	aMotivos	:= oFEFATC01:GetMotsCan()
/*/
Method GetMotsCan( cTipo, cArea ) CLASS FEFATC01
Local cQuery	:= ''
Local aMotivos	:= {}

Default cTipo	:= ''
Default cArea	:= ''

If Select("QryZB5Mot") > 0//Verifica se ja existe alias criado
	QryZB5Mot->( dbCloseArea() )
Endif

cQuery := cCRLF + "	SELECT  "
cQuery += cCRLF + "		ZB5_ID,ZB5_DESC "
cQuery += cCRLF + "	FROM "
cQuery += cCRLF + RetSqlName("ZB5") + " ZB5 "
cQuery += cCRLF + "	WHERE "
cQuery += cCRLF + "		ZB5_FILIAL 		= '" + xFilial('ZB5') + "' "
If !Empty(cTipo)
	cQuery += cCRLF + " 	AND ZB5_TIPO 	= '" + cTipo + "' "
Endif
If !Empty(cArea)
	cQuery += cCRLF + " 	AND ZB5_AREA 	= '" + cArea + "' "
Endif
cQuery += cCRLF + " 	AND ZB5.D_E_L_E_T_ <> '*' "

DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQuery)),"QryZB5Mot",.T.,.T.)

Do While QryZB5Mot->( !EOF() )
	
	aAdd( aMotivos, { AllTrim(QryZB5Mot->ZB5_ID), AllTrim(QryZB5Mot->ZB5_DESC) } )

	QryZB5Mot->( dbSkip() )
EndDo

QryZB5Mot->( dbCloseArea() )

Return( aMotivos )



/*/{Protheus.doc} GetSaldos
Retorna Saldos do Cliente

@type		method	
@author		Eurai Rapelli
@since 		2017.01.02

@example	Local oFEFATC01 := FEFATC01():New(); aSaldos 	:= oFEFATC01:GetSaldos( M->CJ_CLIENTE, M->CJ_LOJA )
/*/
Method GetSaldos( cCliente, cLoja ) Class FEFATC01
Local cQuery	:= ''
Local cAliasQry := GetNextAlias()

Local nTitAber	:= 0

Local aSaldos	:= {}

Local aAreaSA1	:= SA1->( GetArea() )

Local cTipoLim := SuperGetMv("MV_CREDCLI")

Local nSTA1_LCSEG := 0
Local nSTA1_LCEMP := 0
Local nSTA1_LC    := 0

Begin Sequence

	If cTipoLim == "L"	//	controle por loja - MV_CREDCLI = "L"
		If Empty( cCliente ) .OR. Empty( cLoja )
			Break
		Endif
		SA1->( dbSetOrder(1) )
		If !SA1->( dbSeek( xFilial('SA1') + cCliente + cLoja ) )
			Help( ,, 'HELP',, 'Cliente n�o encontrado: ' + xFilial('SA1') + cCliente + cLoja, 1, 0)
			Break
		Endif
		aAdd( aSaldos, { 'A1_LCSEG', SA1->A1_LCSEG } )
		aAdd( aSaldos, { 'A1_LCEMP', SA1->A1_LCEMP } )
		aAdd( aSaldos, { 'A1_LC', SA1->A1_LC } )
		cQuery	:=		   " SELECT	 "
		cQuery	+=	cCRLF + " 	SUM(E1_SALDO) E1_SALDO "
		cQuery	+=	cCRLF + " FROM " + RetSqlName('SE1') + " SE1 "
		cQuery	+=	cCRLF + " WHERE "
		cQuery	+=	cCRLF + "	E1_FILIAL = '" + xFilial('SE1') + "' "
		cQuery	+=	cCRLF + " 	AND E1_SALDO > 0 "
		cQuery	+=	cCRLF + " 	AND E1_CLIENTE + E1_LOJA = '" + cCliente + cLoja + "'"
		cQuery	+=	cCRLF + " 	AND E1_TIPO NOT IN ('RA','NCC') "	//Atualiza��o 2017.01.25. Eurai Rapelli - Filtro E1_TIPO <> 'RA'
		cQuery	+=	cCRLF + " 	AND SE1.D_E_L_E_T_ <> '*' "
		DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQuery)),cAliasQry,.F.,.T.)
		If (cAliasQry)->(!EOF())
			aAdd( aSaldos, { 'nTitAber', (cAliasQry)->E1_SALDO } )
			nTitAber	:= (cAliasQry)->E1_SALDO
		Else
			aAdd( aSaldos, { 'nTitAber', 0 } )
		Endif
		(cAliasQry)->( dbCloseArea() )
		cQuery	:=		   " SELECT	 "
		cQuery	+=	cCRLF + " 	SUM((C6_QTDVEN - C6_QTDENT)*C6_PRCVEN) C6_TOTAL "
		cQuery	+=	cCRLF + " FROM " + RetSqlName('SC6') + " SC6 "
		cQuery  +=  cCRLF + "	INNER JOIN "
		cQuery  +=  cCRLF + RetSqlName("SF4") + " SF4 "
		cQuery  +=  cCRLF + "	ON "
		cQuery  +=  cCRLF + "		C6_TES = F4_CODIGO "
		cQuery	+=	cCRLF + " WHERE "
		cQuery	+=	cCRLF + "	C6_FILIAL = '" + xFilial('SC6') + "' "
		cQuery	+=	cCRLF + " 	AND C6_CLI + C6_LOJA = '" + cCliente + cLoja + "' "
		cQuery	+=	cCRLF + " 	AND C6_QTDENT < C6_QTDVEN "	
		cQuery	+=	cCRLF + " 	AND C6_BLQ <> 'R' "	
		cQuery	+=	cCRLF + "   AND F4_DUPLIC = 'S'
		cQuery	+=	cCRLF + " 	AND SC6.D_E_L_E_T_ <> '*' "
		cQuery	+=	cCRLF + " 	AND SF4.D_E_L_E_T_ <> '*' "
		DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQuery)),cAliasQry,.F.,.T.)
		If (cAliasQry)->(!EOF())
			aAdd( aSaldos, { 'nPedLib', (cAliasQry)->C6_TOTAL } )
		Else
			aAdd( aSaldos, { 'nPedLib', 0 } )
		Endif
		(cAliasQry)->( dbCloseArea() )
		//Atualiza��o 2018.02.22. Eurai Rapelli - Voltar para o campo CJ_XVLBRUT
		cQuery	:=		   " SELECT	 "
		cQuery	+=	cCRLF + " 	Sum(CJ_XVLBRUT) CJ_XVLBRUT "
		cQuery	+=	cCRLF + " FROM " + RetSqlName('SCJ') + " SCJ "
		cQuery	+=	cCRLF + " WHERE "
		cQuery	+=	cCRLF + "	CJ_FILIAL = '" + xFilial('SCJ') + "' "
		cQuery	+=	cCRLF + " 	AND CJ_CLIENTE + CJ_LOJA = '" + cCliente + cLoja + "' "
		cQuery	+=	cCRLF + " 	AND CJ_XSTATUS IN ('02','04','06','07') "
		cQuery  +=  cCRLF + " 	AND CJ_XTIPO = 'N' "
		cQuery	+=	cCRLF + " 	AND SCJ.D_E_L_E_T_ = '' "
		DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQuery)),cAliasQry,.F.,.T.)
		If (cAliasQry)->(!EOF())
			aAdd( aSaldos, { 'CJ_XVLBRUT', (cAliasQry)->CJ_XVLBRUT } )
		Else
			aAdd( aSaldos, { 'CJ_XVLBRUT', 0 } )
		Endif
		(cAliasQry)->( dbCloseArea() )
		cQuery	:=		   " SELECT	 "
		cQuery	+=	cCRLF + " 	SUM(E1_SALDO) E1_SALDO "
		cQuery	+=	cCRLF + " FROM " + RetSqlName('SE1') + " SE1 "
		cQuery	+=	cCRLF + " WHERE "
		cQuery	+=	cCRLF + "	E1_FILIAL = '" + xFilial('SE1') + "' "
		cQuery	+=	cCRLF + " 	AND E1_SALDO > 0 "
		cQuery	+=	cCRLF + " 	AND E1_CLIENTE + E1_LOJA = '" + cCliente + cLoja + "'"
		cQuery	+=	cCRLF + " 	AND E1_TIPO = 'RA' "	//Atualiza��o 2017.01.24. Eurai Rapelli - Filtro E1_TIPO = 'RA'
		cQuery	+=	cCRLF + " 	AND SE1.D_E_L_E_T_ <> '*' "
		DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQuery)),cAliasQry,.F.,.T.)
		If (cAliasQry)->(!EOF())
			aAdd( aSaldos, { 'nTitAberRA', (cAliasQry)->E1_SALDO } )
		Else
			aAdd( aSaldos, { 'nTitAberRA', 0 } )
		Endif
		(cAliasQry)->( dbCloseArea() )
		cQuery	:=		   " SELECT	 "
		cQuery	+=	cCRLF + " 	SUM(E1_SALDO) E1_SALDO "
		cQuery	+=	cCRLF + " FROM " + RetSqlName('SE1') + " SE1 "
		cQuery	+=	cCRLF + " WHERE "
		cQuery	+=	cCRLF + "	E1_FILIAL = '" + xFilial('SE1') + "' "
		cQuery	+=	cCRLF + " 	AND E1_SALDO > 0 "
		cQuery	+=	cCRLF + " 	AND E1_CLIENTE + E1_LOJA = '" + cCliente + cLoja + "'
		cQuery	+=	cCRLF + " 	AND E1_TIPO = 'NCC' "	//Atualiza��o 2017.01.30. Eurai Rapelli - Filtro E1_TIPO = 'RA'
		cQuery	+=	cCRLF + " 	AND SE1.D_E_L_E_T_ <> '*' "
		DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQuery)),cAliasQry,.F.,.T.)
		If (cAliasQry)->(!EOF())
			aAdd( aSaldos, { 'nTitAbrNCC', (cAliasQry)->E1_SALDO } )
		Else
			aAdd( aSaldos, { 'nTitAbrNCC', 0 } )
		Endif
		(cAliasQry)->( dbCloseArea() )
	Else		//	controle por Empresa - MV_CREDCLI = "C"

		If Empty( cCliente )
			Break
		Endif
		SA1->( dbSetOrder(1) )
		If !SA1->( dbSeek( xFilial('SA1') + cCliente) )
			Help( ,, 'HELP',, 'Cliente n�o encontrado: ' + xFilial('SA1') + cCliente, 1, 0)
			Break
		Endif
		nSTA1_LCSEG := 0
		nSTA1_LCEMP := 0
		nSTA1_LC    := 0
		While SA1->A1_FILIAL == SM0->M0_CODFIL .and. SA1->A1_COD == cCliente .and. !SA1->(Eof())
			nSTA1_LCSEG += SA1->A1_LCSEG
			nSTA1_LCEMP += SA1->A1_LCEMP
			nSTA1_LC    += SA1->A1_LC
			SA1->(DBSkip())
		Enddo
		SA1->( dbSeek( xFilial('SA1') + cCliente + cLoja ) )
		aAdd( aSaldos, { 'A1_LCSEG', nSTA1_LCSEG } )
		aAdd( aSaldos, { 'A1_LCEMP', nSTA1_LCEMP } )
		aAdd( aSaldos, { 'A1_LC'   , nSTA1_LC    } )

		//	titulos em aberto
		cQuery	:=		   " SELECT	 "
		cQuery	+=	cCRLF + " 	SUM(E1_SALDO) E1_SALDO "
		cQuery	+=	cCRLF + " FROM " + RetSqlName('SE1') + " SE1 "
		cQuery	+=	cCRLF + " WHERE "
		cQuery	+=	cCRLF + "	E1_FILIAL = '" + xFilial('SE1') + "' "
		cQuery	+=	cCRLF + " 	AND E1_SALDO > 0 "
		cQuery	+=	cCRLF + " 	AND E1_CLIENTE = '" + cCliente + "'"
		cQuery	+=	cCRLF + " 	AND E1_TIPO NOT IN ('RA','NCC') "	//Atualiza��o 2017.01.25. Eurai Rapelli - Filtro E1_TIPO <> 'RA'
		cQuery	+=	cCRLF + " 	AND SE1.D_E_L_E_T_ <> '*' "
		DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQuery)),cAliasQry,.F.,.T.)
		If (cAliasQry)->(!EOF())
			aAdd( aSaldos, { 'nTitAber', (cAliasQry)->E1_SALDO } )
			nTitAber	:= (cAliasQry)->E1_SALDO
		Else
			aAdd( aSaldos, { 'nTitAber', 0 } )
		Endif
		(cAliasQry)->( dbCloseArea() )
		cQuery	:=		   " SELECT	 "
		cQuery	+=	cCRLF + " 	SUM((C6_QTDVEN-C6_QTDENT)*C6_PRCVEN) C6_TOTAL "
		cQuery	+=	cCRLF + " FROM " + RetSqlName('SC6') + " SC6 "
		cQuery  +=  cCRLF + "	INNER JOIN "
		cQuery  +=  cCRLF + RetSqlName("SF4") + " SF4 "
		cQuery  +=  cCRLF + "	ON "
		cQuery  +=  cCRLF + "		C6_TES = F4_CODIGO "
		cQuery	+=	cCRLF + " WHERE "
		cQuery	+=	cCRLF + "	C6_FILIAL = '" + xFilial('SC6') + "' "
		cQuery	+=	cCRLF + " 	AND C6_CLI = '" + cCliente + "' "
		cQuery	+=	cCRLF + " 	AND C6_QTDENT < C6_QTDVEN "	
		cQuery	+=	cCRLF + " 	AND C6_BLQ <> 'R' "	
		cQuery	+=	cCRLF + "   AND F4_DUPLIC = 'S'
		cQuery	+=	cCRLF + " 	AND SC6.D_E_L_E_T_ <> '*' "
		cQuery	+=	cCRLF + " 	AND SF4.D_E_L_E_T_ <> '*' "
		DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQuery)),cAliasQry,.F.,.T.)
		If (cAliasQry)->(!EOF())
			aAdd( aSaldos, { 'nPedLib', (cAliasQry)->C6_TOTAL } )
		Else
			aAdd( aSaldos, { 'nPedLib', 0 } )
		Endif
		(cAliasQry)->( dbCloseArea() )
		//Atualiza��o 2018.02.22. Eurai Rapelli - Voltar para o campo CJ_XVLBRUT
		cQuery	:=		   " SELECT	 "
		cQuery	+=	cCRLF + " 	Sum(CJ_XVLBRUT) CJ_XVLBRUT "
		cQuery	+=	cCRLF + " FROM " + RetSqlName('SCJ') + " SCJ "
		cQuery	+=	cCRLF + " WHERE "
		cQuery	+=	cCRLF + "	CJ_FILIAL = '" + xFilial('SCJ') + "' "
		cQuery	+=	cCRLF + " 	AND CJ_CLIENTE = '" + cCliente + "' "
		cQuery	+=	cCRLF + " 	AND CJ_XSTATUS IN ('02','04','06','07') "
		cQuery  +=  cCRLF + " 	AND CJ_XTIPO = 'N' "
		cQuery	+=	cCRLF + " 	AND SCJ.D_E_L_E_T_ = '' "
		DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQuery)),cAliasQry,.F.,.T.)
		If (cAliasQry)->(!EOF())
			aAdd( aSaldos, { 'CJ_XVLBRUT', (cAliasQry)->CJ_XVLBRUT } )
		Else
			aAdd( aSaldos, { 'CJ_XVLBRUT', 0 } )
		Endif
		(cAliasQry)->( dbCloseArea() )
		cQuery	:=		   " SELECT	 "
		cQuery	+=	cCRLF + " 	SUM(E1_SALDO) E1_SALDO "
		cQuery	+=	cCRLF + " FROM " + RetSqlName('SE1') + " SE1 "
		cQuery	+=	cCRLF + " WHERE "
		cQuery	+=	cCRLF + "	E1_FILIAL = '" + xFilial('SE1') + "' "
		cQuery	+=	cCRLF + " 	AND E1_SALDO > 0 "
		cQuery	+=	cCRLF + " 	AND E1_CLIENTE = '" + cCliente + "'"
		cQuery	+=	cCRLF + " 	AND E1_TIPO = 'RA' "
		cQuery	+=	cCRLF + " 	AND SE1.D_E_L_E_T_ <> '*' "
		DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQuery)),cAliasQry,.F.,.T.)
		If (cAliasQry)->(!EOF())
			aAdd( aSaldos, { 'nTitAberRA', (cAliasQry)->E1_SALDO } )
		Else
			aAdd( aSaldos, { 'nTitAberRA', 0 } )
		Endif
		(cAliasQry)->( dbCloseArea() )
		cQuery	:=		   " SELECT	 "
		cQuery	+=	cCRLF + " 	SUM(E1_SALDO) E1_SALDO "
		cQuery	+=	cCRLF + " FROM " + RetSqlName('SE1') + " SE1 "
		cQuery	+=	cCRLF + " WHERE "
		cQuery	+=	cCRLF + "	E1_FILIAL = '" + xFilial('SE1') + "' "
		cQuery	+=	cCRLF + " 	AND E1_SALDO > 0 "
		cQuery	+=	cCRLF + " 	AND E1_CLIENTE = '" + cCliente + "'
		cQuery	+=	cCRLF + " 	AND E1_TIPO = 'NCC' "
		cQuery	+=	cCRLF + " 	AND SE1.D_E_L_E_T_ <> '*' "
		DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQuery)),cAliasQry,.F.,.T.)
		If (cAliasQry)->(!EOF())
			aAdd( aSaldos, { 'nTitAbrNCC', (cAliasQry)->E1_SALDO } )
		Else
			aAdd( aSaldos, { 'nTitAbrNCC', 0 } )
		Endif
		(cAliasQry)->( dbCloseArea() )

	Endif

End Sequence


RestArea(aAreaSA1)
Return( aSaldos )



/*/{Protheus.doc} GetTpLib
Retorna nomenclatura do tipo de libera��o

@type		method
@author		Eurai Rapelli
@since 		2016.06.28

@param		cNumSCJ			, Caracter		, Numero SCJ - Busca

@example	cTpLib	:= oFEFATC01:GetTpLib()
/*/
Method GetTpLib() CLASS FEFATC01
Return( ::cTpLib )


/*/{Protheus.doc} SetRodape
Retorna TES de Amostra

@type		method
@author		Eurai Rapelli
@since 		2016.11.10

@example	oFEFATC01 := FEFATC01():New(); oFEFATC01:GetTESAmos()
/*/
Method GetTESAmos() CLASS FEFATC01
Local cRet	:= '667/586/585'
Return( cRet )


/*/{Protheus.doc} GetUSRAdm
Retorna user ADM

@author		Eurai Rapelli
@since 		2017.01.10

@Example	oFEFATC01 := FEFATC01():New(); oFEFATC01:GetUSRAdm()
/*/
Method GetUSRAdm() Class FEFATC01
Local cID	:= ''
//000387 -> B2FINANCE
If At(AllTrim(cUserName),'eurai/erapelli') > 0
	cID += __cUserID
Endif

Return('000000/000387/'+cID)




/*/{Protheus.doc} GetVlArray
Retorna valor do Array

@type		method	
@author		Eurai Rapelli
@since 		2017.01.02

@example	Local oFEFATC01 := FEFATC01():New(); nRet 	:= oFEFATC01:GetVlArray( aSaldos, 'A1_LCSEG' )
/*/
Method GetVlArray( aSaldos, cProcura ) Class FEFATC01
Local nRet		:= 0

Default aSaldos	:= {}
Default cProcura:= ''

nPos := aScan( aSaldos, { |UA| UA[01] == cProcura } )
If nPos > 0
	nRet := aSaldos[nPos,02]
Endif

Return( nRet )



/*/{Protheus.doc} GrvLogManu
Grava o log de manuten��o do SCK

@type		method	
@author		Eurai Rapelli
@since 		2017.08.29

@example	Local oFEFATC01 := FEFATC01():New(); oFEFATC01:GrvLogManu( aLogManu )
/*/
Method GrvLogManu( aLogManu ) Class FEFATC01
Local nI	:= 01


For nI := 01 to Len(aLogManu)
	If aLogManu[nI] == Nil
		aLogManu[nI] := ''
	Endif
Next nI

If cZB4DEPART == ''
	If __cUserID == '000000'
		cZB4DEPART	:= 'Administrador'
	ElseIf !Empty(__cUserID) //JOB
		aAllUsers	:= AllUsers()
		nPos := aScan( aAllUsers, { |UA| UA[01,01] == __cUserID } )
		If nPos > 0
			cZB4DEPART	:= aAllUsers[nPos,01,12]
		Endif
	Endif
Endif


RecLock('ZB4',.T.)

	ZB4->ZB4_FILIAL		:= xFilial('ZB4')
	ZB4->ZB4_ID			:= GetSXENUM('ZB4','ZB4_ID')
	ZB4->ZB4_NUM		:= aLogManu[01]
	ZB4->ZB4_REVISA		:= aLogManu[02]
	ZB4->ZB4_ITEM		:= aLogManu[03]
	ZB4->ZB4_USER		:= __cUserID
	If !Empty(__cUserID) //JOB
		ZB4->ZB4_NUSER	:= UsrFullName(__cUserID)
	EndIf
	ZB4->ZB4_DATA 		:= aLogManu[04]
	ZB4->ZB4_HORA 		:= aLogManu[05]
	ZB4->ZB4_CAMPO		:= aLogManu[06]
	ZB4->ZB4_OBS		:= aLogManu[07]
	ZB4->ZB4_VALANT		:= ::oFEGENC01:ValtoStr( aLogManu[06], aLogManu[08] )
	ZB4->ZB4_VALNOV		:= ::oFEGENC01:ValtoStr( aLogManu[06], aLogManu[09] )
	ZB4->ZB4_TIPCK		:= aLogManu[10]
	ZB4->ZB4_OPERAC		:= aLogManu[11]
	ZB4->ZB4_ROTINA		:= aLogManu[12]
	ZB4->ZB4_EVENTO		:= aLogManu[13]
	ZB4->ZB4_RESULT		:= aLogManu[14]
	ZB4->ZB4_MOTIVO		:= aLogManu[15]
	ZB4->ZB4_NUMPV		:= aLogManu[16]
	ZB4->ZB4_ITEMPV		:= aLogManu[17]
	ZB4->ZB4_NUMNF		:= aLogManu[18]
	ZB4->ZB4_ITEMNF		:= aLogManu[19]
	ZB4->ZB4_DEPART		:= cZB4DEPART

ZB4->( MsUnlock() )

ConfirmSX8()



Return( Nil )


/*/{Protheus.doc} HaveNF
Retorna se tem Nota

@type		function
@author		Eurai Rapelli
@since 		2017.08.23

@example	Local oFEFATC01 := FEFATC01():New(); oFEFATC01:HaveNF( cNumSCJ )
/*/
Method HaveNF( cNumSCJ ) CLASS FEFATC01
Local lRet			:= .F.
Local cQuery		:= ''
Local cAliasQry		:= GetNextAlias()
Local cNumPV        := ""
Local cBLQ          := "R"


If Select(cAliasQry) > 0
	(cAliasQry)->( dbCloseArea() )
Endif


SC6->(DbSetOrder(1))
SCK->(DbSetOrder(1))

//	Verificar se todos os itens estao bloquados, caso afirmativo, permitir cancelar CK   -   Almir - 26/11/18 - Chamado GLPI: 2311
SCK->( dbSeek( xFilial("SCK") + cNumSCJ ) )
If !Empty(SCK->CK_NUMPV)
	cNumPV := SCK->CK_NUMPV
	If SC6->( dbSeek( xFilial("SC6") + cNumPV  ) )
		While SC6->C6_NUM == cNumPV .and. !SC6->(Eof())
			If Empty(SC6->C6_BLQ)
				cBLQ := ""
			Endif
			SC6->(DbSkip())
		Enddo
	Endif
Endif

cQuery := cCRLF + "	SELECT  "
cQuery += cCRLF + "		C6_NOTA "
cQuery += cCRLF + "	FROM "
cQuery += cCRLF + RetSqlName("SC6") + " SC6 "
cQuery += cCRLF + "	WHERE "
cQuery += cCRLF + "		C6_FILIAL 		= '" + xFilial('SC6') + "' "
cQuery += cCRLF + " 	AND SubString(C6_NUMORC,01,06) 	= '" + cNumSCJ + "' "
//cQuery += cCRLF + " 	AND C6_NOTA = '' "
cQuery += cCRLF + " 	AND C6_QTDENT < C6_QTDVEN "
cQuery += cCRLF + " 	AND C6_BLQ <> 'R' "
cQuery += cCRLF + " 	AND SC6.D_E_L_E_T_ = ' ' "

DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQuery)),cAliasQry,.T.,.T.)

If (cAliasQry)->( EOF() ) .and. cBLQ == "" 	//	ha itens ativos
	Help( ,, 'HELP',, '[FEFATC01/HaveNF]Checklist Faturado: ' + (cAliasQry)->C6_NOTA, 1, 0)
	lRet := .T.
Endif

Return( lRet )


/*/{Protheus.doc} GZB3STATUS
Retorna a descri��o do campo GZB3STATUS

@type		method
@author		Eurai Rapelli
@since 		2016.06.28

@return		cRet			, Caracter		, Descri��o do Campo

@example	oFEFATC01:GZB3STATUS()
/*/
Method GZB3STATUS( cStatus ) CLASS FEFATC01
Local cRet		:= ''

Default cStatus	:= ZB3->ZB3_STATUS

If AllTrim( cStatus ) == 'R'
	
	cRet	:= 'Rejeitado'

ElseIf AllTrim( cStatus ) == 'B'

	cRet	:= 'Bloqueio'

ElseIf AllTrim( cStatus )  == 'L'

	cRet	:= 'Liberado'

Else

	cRet	:= 'Sem Al�ada'

Endif

Return( cRet )



/*/{Protheus.doc} HistCanc
Cria log de Cancelamento

@type		method	
@author		Eurai Rapelli
@since 		2017.01.04

@example	Local oFEFATC01 := FEFATC01():New(); oFEFATC01:HistCanc( oCria )
/*/
Method HistCanc( oCria ) Class FEFATC01
Local oPnlTop01		:= Nil
Local oPnlItem01	:= Nil
Local oSayXX		:= Nil

Local cRotina		:= ''

Local nX			:= 01
Local nTamArray1	:= 00

Local aTmp			:= {}

Local oBrwHist		:= Nil
Local aBrwHist		:= {}
Local mBrwHist		:= {}

Local oMemo01		:= Nil	
Local cMemo01		:= ''

Local aMotivos		:= {}

Local fCKXOBSITF	:= 0

If oCria <> Nil

	
	aAdd( mBrwHist, { 'Item'		, "@C", 'LEFT', 020, 'SCK', 'CK_ITEM'		, '' } )
	aAdd( mBrwHist, { 'Produto'		, "@C", 'LEFT', 030, 'SCK', 'CK_PRODUTO'	, '' } )
	aAdd( mBrwHist, { 'Descri��o'	, "@C", 'LEFT', 050, 'SCK', 'CK_DESCRI'		, '' } )
	aAdd( mBrwHist, { 'Local'		, "@C", 'LEFT', 020, 'SCK', 'CK_LOCAL'		, '' } )
	aAdd( mBrwHist, { 'Fatura?'		, "@C", 'LEFT', 030, 'SCK', 'CK_XITFAT'		, {|UA| If( SCK->CK_XITFAT == 'S', 'Sim', 'N�o' ) } } )
	aAdd( mBrwHist, { 'Taglio?'		, "@C", 'LEFT', 030, 'SCK', 'CK_XTAGLIO'	, {|ER| If( SCK->CK_XTAGLIO == 'S', 'Sim', 'N�o' ) } } )
	aAdd( mBrwHist, { 'Mot Can'		, "@C", 'LEFT', 025, 'SCK', 'CK_XMOTCAN'	, '' } )
	aAdd( mBrwHist, { 'Mot Desc'	, "@C", 'LEFT', 060, 'SCK', 'CK_XMOTCAN'	, {|AM| AM := aScan(aMotivos, { |UA| UA[01] == SCK->CK_XMOTCAN }), If(AM > 0, aMotivos[AM,02], '' ) } } )
	aAdd( mBrwHist, { 'Canc'		, "@M", 'LEFT', 025, 'SCK', 'CK_XOBSITF'	, '' } )
	
	nTamArray1	:= Len(mBrwHist)
	aMotivos	:= ::GetMotsCan()
	fCKXOBSITF	:= aScan( mBrwHist, { |AM| AM[06] == 'CK_XOBSITF' } )
	
	
	oPnlTop01	  	:= TPanel():NEW( 000,  000, "", oCria, , .T., , CLR_BLUE, , 000, 025, .T., .T.)
	oPnlTop01:Align	:= CONTROL_ALIGN_TOP
	
	If SCJ->CJ_XROTCAN == 'FEFATA06'
		cRotina := 'FEFATA06' + ' - ALTERA��O'
	ElseIf SCJ->CJ_XROTCAN == 'FEFATA07'
		cRotina := 'FEFATA07' + ' - CANCELAMENTO PADR�O'
	ElseIf SCJ->CJ_XROTCAN == 'FEFATA11'
		cRotina := 'FEFATA11' + ' - APROVA��O COMERCIAL'
	ElseIf SCJ->CJ_XROTCAN == 'FEFATA13'
		cRotina := 'FEFATA13' + ' - MANUTEN��O CHECKLIST'
	ElseIf SCJ->CJ_XROTCAN == 'FEFATV08'
		cRotina := 'FEFATV08' + ' - PEDIDO BAIXADO'
	ElseIf SCJ->CJ_XROTCAN == 'FEFATA18'
		cRotina := 'FEFATA18' + ' - JOB TIMEOUT'
	Else
		cRotina := 'SEM CANCELAMENTO / DESCONHECIDO'
	Endif
	
	oSayXX 			:= TSay():New( 005,010,{|| "Rotina: " + cRotina },oPnlTop01,,,.F.,.F.,.F.,.T.,,,550,008)
	If !Empty(SCJ->CJ_XUSRCAN)
		oSayXX		:= TSay():New( 015,010,{|| "Usu�rio: " + UsrFullName(SCJ->CJ_XUSRCAN) },oPnlTop01,,,.F.,.F.,.F.,.T.,,,550,008)
	EndIf	
	
	oPnlItem01		:= TPanel():NEW( 000, 000, "", oCria, , .T., , CLR_BLUE, , 000, 000, .T., .T.)
	oPnlItem01:Align:= CONTROL_ALIGN_ALLCLIENT
	
	
	
	SCK->( MsSeek( SCJ->CJ_FILIAL + SCJ->CJ_NUM ) )
	Do While SCK->( !EOF() ) ;
		.AND. SCK->CK_NUM == SCJ->CJ_NUM
		
		aTmp	:= {}
		For nX := 01 to nTamArray1
			If Empty(mBrwHist[nX,07])
				aAdd( aTmp, &( mBrwHist[nX,05] + '->' + mBrwHist[nX,06] ) )
			Else
				aAdd( aTmp, Eval( mBrwHist[nX,07] ) )
			Endif
		Next nX
		
		aAdd( aBrwHist, aTmp )
		
	
		SCK->( dbSkip() )
	EndDo
	
	
	
	
	
	oBrwHist := TCBrowse():New(010,010,258,195,,,,oPnlItem01,,,,,,,,,,,,.F.,,.T.,,.F.,,,,)
	
	For nX := 01 to Len(mBrwHist)
		If mBrwHist[nX,02] == '@M'
			oBrwHist:AddColumn( TCColumn():New( mBrwHist[nX,01], { || "Memo" }, mBrwHist[nX,02], , , mBrwHist[nX,03], mBrwHist[nX,04], .F., .F., , , , .F., ) )
		Else
			oBrwHist:AddColumn( TCColumn():New( mBrwHist[nX,01], &("{ || aBrwHist[oBrwHist:nAt, "+Str(nX,4)+"] }"), mBrwHist[nX,02], , , mBrwHist[nX,03], mBrwHist[nX,04], .F., .F., , , , .F., ) )
		Endif
	Next nX
	
	oBrwHist:Align	:= CONTROL_ALIGN_ALLCLIENT
	oBrwHist:SetArray(aBrwHist)
	
	
	If fCKXOBSITF > 0
	
		oBrwHist:bChange := {|| cMemo01 := aBrwHist[oBrwHist:nAt,fCKXOBSITF], oMemo01:Refresh() }
	
		oMemo01 		:= TMultiget():New(000, 000,{|u|if(Pcount()>0,cMemo01:=u,cMemo01)},oPnlItem01,000,050,,.T.,,,,.T.,,,,,,,,,,,.T.)
		oMemo01:Align	:= CONTROL_ALIGN_BOTTOM
		oMemo01:lReadOnly	:= .T.
	
	Endif

Endif

Return( Nil )


/*/{Protheus.doc} HistZB4
Cria log da Altera��o

@type		method	
@author		Eurai Rapelli
@since 		2017.08.29

@example	Local oFEFATC01 := FEFATC01():New(); oFEFATC01:HistZB4( oCria )
/*/
Method HistZB4( oCria ) Class FEFATC01
Local cQuery		:= ''
Local cTemp			:= ''

Local oMemo01		:= Nil
Local cMemo01		:= ''

Local cObsZB3		:= '' 
Local cObsZB4		:= ''

Local oBrwHist	:= Nil
Local aBrwHist	:= {}
Local mBrwHist	:= {}

Local aTmp		:= {}


aAdd( mBrwHist, { 'Evento'		, "@C", 'LEFT'	, 060, 'ZB4_TMP', 'ZB4_EVENTO'	, '' } )
aAdd( mBrwHist, { 'Departamento', "@C", 'LEFT'	, 060, 'ZB4_TMP', 'ZB4_DEPART'	, '' } )
//aAdd( mBrwHist, { 'Tipo Check'	, "@C", 'LEFT'	, 070, 'ZB4_TMP', 'ZB4_TIPCK'	, {|ER| If(ZB4_TMP->ZB4_TIPCK=='1','Normal',If(ZB4_TMP->ZB4_TIPCK=='2','Refaturameto','Consulta')) } } )
aAdd( mBrwHist, { 'Opera��o'	, "@C", 'LEFT'	, 030, 'ZB4_TMP', 'ZB4_OPERAC'	, '' } )
aAdd( mBrwHist, { 'User'		, "@C", 'LEFT'	, 070, 'ZB4_TMP', 'ZB4_NUSER'	, '' } )
aAdd( mBrwHist, { 'Data'		, "@C", 'LEFT'	, 035, 'ZB4_TMP', 'ZB4_DATA'	, '' } )
aAdd( mBrwHist, { 'Hora'		, "@C", 'LEFT'	, 030, 'ZB4_TMP', 'ZB4_HORA'	, '' } )
aAdd( mBrwHist, { 'Revis�o'		, "@C", 'CENTER', 025, 'ZB4_TMP', 'ZB4_REVISA'	, '' } )
aAdd( mBrwHist, { 'Item'		, "@C", 'CENTER', 020, 'ZB4_TMP', 'ZB4_ITEM'	, '' } )
aAdd( mBrwHist, { 'Campo'		, "@C", 'LEFT'	, 050, 'ZB4_TMP', 'ZB4_CAMPO'	, '' } )
aAdd( mBrwHist, { 'Descri��o'	, "@C", 'LEFT'	, 060, 'ZB4_TMP', 'ZB4_CAMPO'	, {|ER| GetSX3Cache(ZB4_TMP->ZB4_CAMPO,'X3_TITULO') } } )
aAdd( mBrwHist, { 'Valor Antes'	, "@C", 'LEFT'	, 070, 'ZB4_TMP', 'ZB4_VALANT'	, '' } )
aAdd( mBrwHist, { 'Valor Novo'	, "@C", 'LEFT'	, 070, 'ZB4_TMP', 'ZB4_VALNOV'	, '' } )
aAdd( mBrwHist, { 'Resultado'	, "@C", 'LEFT'	, 070, 'ZB4_TMP', 'ZB4_RESULT'	, '' } )
aAdd( mBrwHist, { 'Motivo'		, "@C", 'LEFT'	, 070, 'ZB4_TMP', 'ZB4_MOTIVO'	, '' } )
aAdd( mBrwHist, { 'PV'			, "@C", 'LEFT'	, 070, 'ZB4_TMP', 'ZB4_NUMPV'	, '' } )
aAdd( mBrwHist, { 'NF'			, "@C", 'LEFT'	, 070, 'ZB4_TMP', 'ZB4_NUMNF'	, '' } )
aAdd( mBrwHist, { 'Rotina'		, "@C", 'LEFT'	, 070, 'ZB4_TMP', 'ZB4_ROTINA'	, '' } )
aAdd( mBrwHist, { 'OBS'			, "@M", 'LEFT'	, 050, 'ZB4_TMP', 'ZB4_OBS'		, '' } )




nTamArray1:= Len(mBrwHist)

If Select("QryObs") > 0//Verifica se ja existe alias criado
	QryObs->( dbCloseArea() )
Endif

cQuery += cCRLF + " SELECT  "
cQuery += cCRLF + " 	ZB4.R_E_C_N_O_ ZB4RECNO "
cQuery += cCRLF + " FROM "
cQuery += cCRLF + RetSqlName("ZB4") + " ZB4 "
cQuery += cCRLF + " WHERE "
cQuery += cCRLF + " 	ZB4_FILIAL = '" + xFilial('ZB4') + "' "
cQuery += cCRLF + " 	AND ZB4_NUM = '" + SCJ->CJ_NUM + "' "
//cQuery += cCRLF + " 	AND ZB4_ITEM 	= '' "
//cQuery += cCRLF + " 	AND ZB4_CAMPO NOT IN ('U_FEFATA16') "
cQuery += cCRLF + " 	AND ZB4.D_E_L_E_T_ <> '*' "
//cQuery += cCRLF + " ORDER BY ZB4_DATA DESC,ZB4_HORA DESC,ZB4_ITEM DESC "
cQuery += cCRLF + " ORDER BY R_E_C_N_O_ DESC "

DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQuery)),"QryObs",.T.,.T.)

dbUseArea( .T.,"TOPCONN", RetSqlName("ZB4"), "ZB4_TMP", .T., .F. ) 

Do While QryObs->( !EOF() )

	ZB4_TMP->( dbGoTo( QryObs->ZB4RECNO ) )
	
	aTmp	:= {}
	For nX := 01 to nTamArray1

		If Empty(mBrwHist[nX,07])
			If mBrwHist[nX,02] == '@M'
				aAdd( aTmp, &( mBrwHist[nX,05] + '->' + mBrwHist[nX,06] ) )
			Else
				aAdd( aTmp, StrTran( cValtoChar( &( mBrwHist[nX,05] + '->' + mBrwHist[nX,06] ) ), cCRLF, ' <br> ' ) )
			Endif
		Else
			aAdd( aTmp, Eval( mBrwHist[nX,07] ) )
		Endif
	
	Next nX
	
	aAdd( aBrwHist, aTmp )


	
	QryObs->( dbSkip() )
EndDo
QryObs->( dbCloseArea() )
ZB4_TMP->( dbCloseArea() )

If oCria <> Nil

	oBrwHist := TCBrowse():New(010,010,258,195,,,,oCria,,,,,,,,,,,,.F.,,.T.,,.F.,,,,)
	
	For nX := 01 to Len(mBrwHist)
		If mBrwHist[nX,02] == '@M'
			oBrwHist:AddColumn( TCColumn():New( mBrwHist[nX,01], { || "Memo" }, mBrwHist[nX,02], , , mBrwHist[nX,03], mBrwHist[nX,04], .F., .F., , , , .F., ) )
		Else
			oBrwHist:AddColumn( TCColumn():New( mBrwHist[nX,01], &("{ || aBrwHist[oBrwHist:nAt, "+Str(nX,4)+"] }"), mBrwHist[nX,02], , , mBrwHist[nX,03], mBrwHist[nX,04], .F., .F., , , , .F., ) )
		Endif
	Next nX
	
	oBrwHist:Align	:= CONTROL_ALIGN_ALLCLIENT
	oBrwHist:SetArray(aBrwHist)

	If Len(aBrwHist) > 0
		oBrwHist:bChange := {|| cMemo01 := aBrwHist[oBrwHist:nAt,Len(mBrwHist)], oMemo01:Refresh() }
	Endif
	
	oMemo01 		:= TMultiget():New(000, 000,{|u|if(Pcount()>0,cMemo01:=u,cMemo01)},oCria,000,050,,.T.,,,,.T.,,,,,,,,,,,.T.)
	oMemo01:Align	:= CONTROL_ALIGN_BOTTOM
	oMemo01:lReadOnly	:= .T.
	
	
       			

Endif


Return( aBrwHist )



/*/{Protheus.doc} IsAllAprov
Retorna se tem algum nivel pendente de libera��o

@type		method
@author		Eurai Rapelli
@since 		2016.06.28

@param		cNumSCJ			, Caracter		, Numero SCJ

@example	oFEFATC01:IsAllAprov( cNumSCJ, cRevisao )
/*/
Method IsAllAprov( cNumSCJ, cRevisao ) CLASS FEFATC01
Local lRet			:= .T.

Default cNumSCJ		:= SCJ->CJ_NUM
Default cRevisao	:= SCJ->CJ_XREVISA

If Select("QryAprov") > 0//Verifica se ja existe alias criado
	QryAprov->( dbCloseArea() )
Endif

cQuery := cCRLF + "	SELECT  "
cQuery += cCRLF + "		ZB3.R_E_C_N_O_ AS ZB3RECNO "
cQuery += cCRLF + "	FROM "
cQuery += cCRLF + RetSqlName("ZB3") + " ZB3 "
cQuery += cCRLF + "	WHERE "
cQuery += cCRLF + "		ZB3_FILIAL 			= '" + xFilial('ZB3') + "' "
cQuery += cCRLF + " 		AND ZB3_ID	 	= '" + cNumSCJ + "' "
cQuery += cCRLF + " 		AND ZB3_TIPO 	= '" + ::GetTpLib() + "' "
cQuery += cCRLF + " 		AND ZB3_STATUS 	= 'B' "
cQuery += cCRLF + " 		AND ZB3_REVISA 	= '" + cRevisao + "' "
cQuery += cCRLF + " 		AND ZB3.D_E_L_E_T_ <> '*' "

DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQuery)),"QryAprov",.T.,.T.)

If QryAprov->( !EOF() )
	lRet	:= .F.
Endif
QryAprov->( dbCloseArea() )

Return( lRet )




/*/{Protheus.doc} IsLibAprov
Retorna se or�amento est� liberado nos niveis anteriores

@type		method
@author		Eurai Rapelli
@since 		2016.06.28

@param		cFilSCJ			, Caracter		, Filial SCJ - Busca
@param		cNumSCJ			, Caracter		, Numero SCJ - Busca

@example	oFEFATC01:IsLibAprov( cNumSCJ, cNivel, cRevisao )
/*/
Method IsLibAprov( cNumSCJ, cNivel, cRevisao ) CLASS FEFATC01
Local lRet			:= .T.

Default cNumSCJ		:= ''
Default cNivel		:= '01'
Default cRevisao	:= SCJ->CJ_XREVISA


If Select("QryLibApr") > 0//Verifica se ja existe alias criado
	QryLibApr->( dbCloseArea() )
Endif

cQuery := cCRLF + "	SELECT  "
cQuery += cCRLF + "		ZB3.R_E_C_N_O_ AS ZB3RECNO "
cQuery += cCRLF + "	FROM "
cQuery += cCRLF + RetSqlName("ZB3") + " ZB3 "
cQuery += cCRLF + "	WHERE "
cQuery += cCRLF + "		ZB3_FILIAL 		= '" + xFilial('ZB3') + "' "
cQuery += cCRLF + " 	AND ZB3_ID		= '" + cNumSCJ + "' "
cQuery += cCRLF + " 	AND ZB3_TIPO 	= '" + ::GetTpLib() + "' "
cQuery += cCRLF + " 	AND ZB3_NIVEL 	< '" + cNivel + "' "
cQuery += cCRLF + " 	AND ZB3_STATUS 	= 'B' "
cQuery += cCRLF + " 	AND ZB3_REVISA 	= '" + cRevisao + "' "
cQuery += cCRLF + " 	AND ZB3.D_E_L_E_T_ <> '*' "

DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQuery)),"QryLibApr",.T.,.T.)

If QryLibApr->( !EOF() )

	ShowHelpDlg( ProcName(1) + '/' + ProcName(0), {'N�vel superior ainda n�o foi aprovado'}, , {'Solicite o desbloqueio do n�vel superior'}, )
	lRet	:= .F.

Endif
QryLibApr->( dbCloseArea() )

Return( lRet )


/*/{Protheus.doc} IsCJXTIPCK
Inicio como tipo de Consulta

@type		method
@author		Eurai Rapelli
@since 		2018.02.08

@example	oFEFATC01:IsCJXTIPCK( SCJ->CJ_NUM )
/*/
Method IsCJXTIPCK( cCJNUM ) CLASS FEFATC01
Local cQuery		:= ''
Local cAliasER		:= GetNextAlias()

Local lRet			:= .F.

Default cCJNUM		:= SCJ->CJ_NUM


If Select(cAliasER) > 0
	(cAliasER)->( dbCloseArea() )
Endif

cQuery := cCRLF + "	SELECT  "
cQuery += cCRLF + "		ZB4_NUM "
cQuery += cCRLF + "	FROM "
cQuery += cCRLF + RetSqlName("ZB4") + " ZB4 "

cQuery += cCRLF + "	WHERE "
cQuery += cCRLF + "		ZB4_FILIAL 		= '" + xFilial('ZB4') + "' "
cQuery += cCRLF + " 	AND ZB4_NUM 	= '" + cCJNUM + "' "
cQuery += cCRLF + " 	AND ZB4_TIPCK 	= '3' "
cQuery += cCRLF + " 	AND ZB4_ROTINA 	= 'FEFATA11' "
cQuery += cCRLF + " 	AND ZB4.D_E_L_E_T_ = ' ' "

DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQuery)),cAliasER,.T.,.T.)

If (cAliasER)->( !EOF() )
	lRet := .T.
Endif
(cAliasER)->( dbCloseArea() )

Return( lRet )



/*/{Protheus.doc} Liberar
Libera ou Rejeita PV

@type		method
@author		Eurai Rapelli
@since 		2016.06.28

@param		cStatus				, Caracter	, L=Liberar,R=Rejeitar
@param		cNumSCJ				, Caracter	, Numero Pedido
@param		cNivel				, Caracter	, Nivel do Aprovador
@param		cAprovador			, Caracter	, C�digo do Aprovador

@example	oFEFATC01:Liberar()
/*/
Method Liberar( cStatus, cNumSCJ, cNivel, cAprovador, cObs, cRevisao, cMotivo ) CLASS FEFATC01
Local lAtualiza		:= .F.
Local cNumID		:= ''

Default	cStatus		:= 'L'
Default cNumSCJ		:= ''
Default cNivel		:= ''
Default cAprovador	:= RetCodUsr()
Default cObs		:= ''
Default cRevisao	:= SCJ->CJ_XREVISAO
Default cMotivo		:= ''


cNumId	:= Padr( cNumSCJ, TamSX3('ZB3_ID')[01] )
If !Empty( cNivel )
	cNivel	:= Padr( cNivel, TamSX3('ZB3_NIVEL')[01] )
Endif

Begin Sequence

If Empty( cNumSCJ )
	Break
Endif

If !Empty( cNivel ) .AND. cStatus == 'L'
	
	If Select("QryLib") > 0//Verifica se ja existe alias criado
		QryLib->( dbCloseArea() )
	Endif
	
	cQuery := cCRLF + "	SELECT  "
	cQuery += cCRLF + "		ZB3.R_E_C_N_O_ AS ZB3RECNO "
	cQuery += cCRLF + "	FROM "
	cQuery += cCRLF + RetSqlName("ZB3") + " ZB3 "
	cQuery += cCRLF + "	WHERE "
	cQuery += cCRLF + "		ZB3_FILIAL 		= '" + xFilial('ZB3') + "' "
	cQuery += cCRLF + " 	AND ZB3_ID		= '" + cNumId + "' "
	cQuery += cCRLF + " 	AND ZB3_TIPO 	= '" + ::GetTpLib() + "' "
	cQuery += cCRLF + " 	AND ZB3_NIVEL 	= '" + cNivel + "' "
	cQuery += cCRLF + " 	AND ZB3_REVISA 	= '" + cRevisao + "' "
	cQuery += cCRLF + " 	AND ZB3.D_E_L_E_T_ <> '*' "
	
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQuery)),"QryLib",.T.,.T.)
	
	If QryLib->( !EOF() )
	
		ZB3->( dbGoTo( QryLib->ZB3RECNO ) )
		
		Reclock( "ZB3",.F. )
		
			ZB3->ZB3_STATUS	:= cStatus
			ZB3->ZB3_DATALB	:= Date()
			ZB3->ZB3_HORALB	:= Time()
			ZB3->ZB3_APROVL	:= cAprovador
			If !Empty( cObs )
				ZB3->ZB3_OBS	:= cObs
			Endif
			If !Empty( cMotivo )
				ZB3->ZB3_MOTIVO	:= cMotivo
			Endif
	
		ZB3->( MsUnlock() )
		
		lAtualiza := ::IsAllAprov( cNumSCJ )
		
	Endif


Else
	
	If Select("QryLib") > 0//Verifica se ja existe alias criado
		QryLib->( dbCloseArea() )
	Endif
	
	cQuery := cCRLF + "	SELECT  "
	cQuery += cCRLF + "		ZB3.R_E_C_N_O_ AS ZB3RECNO "
	cQuery += cCRLF + "	FROM "
	cQuery += cCRLF + RetSqlName("ZB3") + " ZB3 "
	cQuery += cCRLF + "	WHERE "
	cQuery += cCRLF + "		ZB3_FILIAL 		= '" + xFilial('ZB3') + "' "
	cQuery += cCRLF + " 	AND ZB3_ID		= '" + cNumId + "' "
	cQuery += cCRLF + " 	AND ZB3_TIPO 	= '" + ::GetTpLib() + "' "
	cQuery += cCRLF + " 	AND ZB3_NIVEL 	>= '" + cNivel + "' "
	cQuery += cCRLF + " 	AND ZB3_REVISA 	= '" + cRevisao + "' "
	cQuery += cCRLF + " 	AND ZB3.D_E_L_E_T_ <> '*' "
	
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQuery)),"QryLib",.T.,.T.)
	
	If QryLib->( !EOF() )
	
		Do While QryLib->( !EOF() )

			ZB3->( dbGoTo( QryLib->ZB3RECNO ) )

			Reclock( "ZB3",.F. )
			
				ZB3->ZB3_STATUS	:= cStatus
				ZB3->ZB3_DATALB	:= Date()
				ZB3->ZB3_HORALB	:= Time()
				ZB3->ZB3_APROVL	:= cAprovador
				If !Empty( cObs )
					ZB3->ZB3_OBS	:= cObs
				Endif
				ZB3->ZB3_MOTIVO	:= cMotivo
		
			ZB3->( MsUnlock() )
			
			QryLib->( dbSkip() )
		EndDo
		
		lAtualiza	:= .T.
		
	Endif


Endif

End Sequence
		
Return( lAtualiza )	




/*/{Protheus.doc} LibForPV
Libera para Pedido de Venda Direto. Se existir apenas armazem 15

@type		method
@author		Eurai Rapelli
@since 		2016.12.15

@param		cNumSCJ				, Caracter	, Numero Pedido

@example	oFEFATC01:LibForPV( lTMP, cNumSCJ )
/*/
Method LibForPV( lTMP, cNumSCJ ) CLASS FEFATC01
Default lTMP	:= .T.
Default cNumSCJ	:= ''



Begin Sequence



If lTMP
	
	TMP1->( dbGoTop() )
	Do While TMP1->( !EOF() )
	
		If TMP1->CK_FLAG .OR. TMP1->CK_XITFAT == 'N'
			TMP1->( dbSkip() )
			Loop
		Endif
	
		If AllTrim( TMP1->CK_LOCAL ) <> '15'
			Break
		Endif
		
	
		TMP1->( dbSkip() )
	EndDo

Else
	
	If Empty(cNumSCJ)
		Break
	Endif

	If SCK->( dbSeek( xFilial('SCJ') + cNumSCJ ) )
		
		Do While SCK->( !EOF() ) ;
			.AND. SCK->CK_NUM == cNumSCJ

			If SCK->CK_XITFAT == 'N'
				SCK->( dbSkip() )
				Loop
			Endif
		
			If AllTrim( SCK->CK_LOCAL ) <> '15'
				Break
			Endif
		
			SCK->( dbSkip() )
		EndDo	
		
	Else
		Break
	Endif
	
Endif

RecLock('SCJ', .F. )
	
	SCJ->CJ_XSTATUS	:= '07'

SCJ->( MsUnlock() )


End Sequence


Return( Nil )



/*/{Protheus.doc} LogZB3
Monta Log na Tela

@type		method	
@author		Eurai Rapelli
@since 		2017.01.02

@example	Local oFEFATC01 := FEFATC01():New(); oFEFATC01:LogAprov()
/*/
Method LogAprov() Class FEFATC01
Local oDlg			:= Nil
Local oBar01		:= Nil
Local oBtnBmp01		:= Nil
Local oBtnBmp02		:= Nil

Local oFolder01		:= Nil




SA1->( MsSeek( xFilial('SA1') + SCJ->CJ_CLIENTE + SCJ->CJ_LOJA ) )



//oDlg				:= MSDialog():New( 000,000,720,1200,"Log de Ocorrencias [ZB4]",,,.F.,,,,,,.T.,,,.T. )
oDlg				:= MSDialog():New( 000,000,600,500,"Log de Ocorrencias [ZB4]",,,.F.,,,,,,.T.,,,.T. )
oDlg:lMaximized 	:= .T.

//oFolder01		:= TFolder():New( 0,0,{'Hist�rico Aprova��o','Hist�rico Solicita��o Manuten��o','Hist�rico Altera��o','Hist�rico Cancelamento'},,oDlg,,,,.T.,,260,184 )
//oFolder01		:= TFolder():New( 0,0,{'Hist�rico CheckList','Hist�rico Solicita��o Manuten��o','Hist�rico Cancelamento'},,oDlg,,,,.T.,,260,184 )
//oFolder01		:= TFolder():New( 0,0,{'Hist�rico CheckList','Hist�rico Cancelamento'},,oDlg,,,,.T.,,260,184 )
oFolder01		:= TFolder():New( 0,0,{'Hist�rico CheckList','Hist�rico Cancelamento'},,oDlg,,,,.T.,,200,100 )
oFolder01:Align	:= CONTROL_ALIGN_ALLCLIENT

::HistZB4( oFolder01:aDialogs[1] )
::HistCanc( oFolder01:aDialogs[2] )






oBar01			:= TBar():New( oDlg,25,35,.T.,,,'backgroundblack',.T. )//barra_mensagens 
oBtnBmp01 		:= TBtnBmp2():New( 000, 000, 035, 070, 'FINAL' ,,,,		{|| oDlg:End() }, oBar01,'Fechar',,.F.,.F. )
oBtnBmp02 		:= TBtnBmp2():New( 000, 000, 035, 070, 'cliente' ,,,,		{|| FC010CON() }, oBar01,'Cliente',,.F.,.F. )
oBtnBmp02 		:= TBtnBmp2():New( 000, 000, 035, 070, 'BMPVISUAL' ,,,,		{|| ::Tracker() }, oBar01,'Tracker',,.F.,.F. )

oDlg:Activate(,,,.T.)  

Return( Nil )




/*/{Protheus.doc} LogLiberac
Gera LOG do SC9. Libera��o

@type		method	
@author		Eurai Rapelli
@since 		2017.08.30

@example	Local oFEFATC01 := FEFATC01():New(); oFEFATC01:LogLiberac( cNumSC9, cRotina )
/*/

Method LogLiberac( cNumSC9, cRotina ) Class FEFATC01
Local cQuery	:= ''
Local cAliasER	:= GetNextAlias()

Local dData			:= Date()
Local cHora			:= Time()
Local aLogManu		:= {}

Local cRetCre		:= ''
Local cRetEst		:= ''



If Select(cAliasER) > 0
	(cAliasER)->( dbCloseArea() )
Endif

cQuery := cCRLF + "	SELECT  "
cQuery += cCRLF + "		C9_FILIAL,C9_PEDIDO,C9_ITEM,C9_BLEST,C9_BLCRED,CK_NUM,CK_ITEM "
cQuery += cCRLF + "	FROM "
cQuery += cCRLF + RetSqlName("SC9") + " SC9 "

cQuery += cCRLF + "	INNER JOIN "
cQuery += cCRLF + RetSqlName("SCK") + " SCK "
cQuery += cCRLF + "	ON "
cQuery += cCRLF + "		C9_FILIAL = CK_FILIAL "
cQuery += cCRLF + "		AND C9_PEDIDO = CK_NUMPV "
cQuery += cCRLF + "		AND C9_ITEM = CK_ITEM "

cQuery += cCRLF + "	WHERE "
cQuery += cCRLF + "		C9_FILIAL 		= '" + xFilial('SC9') + "' "
cQuery += cCRLF + " 	AND C9_PEDIDO 	= '" + cNumSC9 + "' "
cQuery += cCRLF + " 	AND SC9.D_E_L_E_T_ = ' ' "
cQuery += cCRLF + " 	AND SCK.D_E_L_E_T_ = ' ' "

DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQuery)),cAliasER,.T.,.T.)

Do While (cAliasER)->( !EOF() )

	SCJ->( dbSeek( (cAliasER)->C9_FILIAL + (cAliasER)->CK_NUM ) )
		
	If (cAliasER)->C9_BLCRED == '10'
	
		cRetCre := 'CREDITO - FATURADO'
	
	ElseIf Empty( (cAliasER)->C9_BLCRED )
	
		cRetCre := 'CREDITO - LIBERADO'
	
	ElseIf !Empty( (cAliasER)->C9_BLCRED )
	
		cRetCre := 'CREDITO - BLOQUEADO'
	
	Endif
	
	If (cAliasER)->C9_BLEST == '10'
	
		cRetEst := 'ESTOQUE - FATURADO'
	
	ElseIf Empty( (cAliasER)->C9_BLEST )
	
		cRetEst := 'ESTOQUE - LIBERADO'
	
	ElseIf !Empty( (cAliasER)->C9_BLEST )
	
		cRetEst := 'ESTOQUE - BLOQUEADO'
	
	Endif	
	
	aLogManu	:= Array(19)
	aLogManu[01]:= SCJ->CJ_NUM
	aLogManu[02]:= SCJ->CJ_XREVISA
	aLogManu[03]:= (cAliasER)->CK_ITEM
	aLogManu[04]:= dData
	aLogManu[05]:= cHora
	aLogManu[06]:= ''
	aLogManu[07]:= ''
	aLogManu[08]:= ''
	aLogManu[09]:= ''
	aLogManu[10]:= SCJ->CJ_XTIPCK
	aLogManu[11]:= 'LIB'
	aLogManu[12]:= cRotina
	aLogManu[13]:= 'LIBERACAO DE CREDITO E ESTOQUE'
	aLogManu[14]:= cRetCre
	aLogManu[15]:= ''
	aLogManu[16]:= (cAliasER)->C9_PEDIDO
	aLogManu[17]:= (cAliasER)->C9_ITEM
	::GrvLogManu( aLogManu )
	If Empty(__cUserID)
		RecLock('ZB4',.F.)
		ZB4->ZB4_USER		:= '000316'
		ZB4->ZB4_NUSER		:= 'Usuario Sistema Mis                     '
		ZB4->ZB4_DEPART		:= 'PRODUCAO                      '
		ZB4->( MsUnlock() )
	EndIf
	
	aLogManu[14]:= cRetEst
	::GrvLogManu( aLogManu )
	If Empty(__cUserID)
		RecLock('ZB4',.F.)
		ZB4->ZB4_USER		:= '000316'
		ZB4->ZB4_NUSER		:= 'Usuario Sistema Mis                     '
		ZB4->ZB4_DEPART		:= 'PRODUCAO                      '
		ZB4->( MsUnlock() )
	EndIf

	(cAliasER)->( dbSkip() )
EndDo

Return( Nil )



/*/{Protheus.doc} LogPV
Completa o LOG no Manuten��o

@type		function
@author		Eurai Rapelli
@since 		2017.09.01
/*/
Method LogPV( cNumSCJ ) Class FEFATC01
Local cQuery		:= ''
Local cAliasQry		:= GetNextAlias()
Local aRet			:= {}

If Select(cAliasQry) > 0
	(cAliasQry)->( dbCloseArea() )
Endif

cQuery := cCRLF + "	SELECT  "
cQuery += cCRLF + "		CK_ITEM,CK_NUMPV "
cQuery += cCRLF + "	FROM "
cQuery += cCRLF + RetSqlName("SCK") + " SCK "
cQuery += cCRLF + "	WHERE "
cQuery += cCRLF + "		CK_FILIAL 		= '" + xFilial('SCK') + "' "
cQuery += cCRLF + " 	AND CK_NUM 	= '" + cNumSCJ + "' "
cQuery += cCRLF + " 	AND SCK.D_E_L_E_T_ = ' ' "

DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQuery)),cAliasQry,.T.,.T.)

If (cAliasQry)->( !EOF() )
	
	aAdd( aRet, (cAliasQry)->CK_NUMPV )
	//aLogManu[17]:= (cAliasQry)->CK_ITEM
Else
	aAdd( aRet , '' )
Endif

Return( aRet )




/*/{Protheus.doc} LogSF2
Gera LOG na nota. SF2

@type		function
@author		Eurai Rapelli
@since 		2017.09.01
/*/
Method LogSF2() Class FEFATC01
Local lFEFATA01	:= GetMv('MV_XFATA01', .F., .F. )
Local oFEFATC01 := FEFATC01():New()
Local aArea 	:= GetArea()
Local cQuery	:= ''
Local cAliasER	:= GetNextAlias()
Local aLogManu	:= {}
Local dData		:= Date()
Local cHora		:= Time()

If lFEFATA01

	If Select(cAliasER) > 0
		(cAliasER)->( dbCloseArea() )
	Endif
	
	cQuery := cCRLF + "	SELECT  "
	cQuery += cCRLF + "		D2_FILIAL,D2_PEDIDO,D2_ITEMPV,D2_DOC,D2_ITEM,CK_NUM,CK_ITEM "
	cQuery += cCRLF + "	FROM "
	cQuery += cCRLF + RetSqlName("SD2") + " SD2 "
	
	cQuery += cCRLF + "	INNER JOIN "
	cQuery += cCRLF + RetSqlName("SCK") + " SCK "
	cQuery += cCRLF + "	ON "
	cQuery += cCRLF + "		D2_FILIAL = CK_FILIAL "
	cQuery += cCRLF + "		AND D2_PEDIDO = CK_NUMPV "
	cQuery += cCRLF + "		AND D2_ITEMPV = CK_ITEM "
	
	cQuery += cCRLF + "	WHERE "
	cQuery += cCRLF + "		D2_FILIAL 		= '" + SF2->F2_FILIAL + "' "
	cQuery += cCRLF + " 	AND D2_DOC 	= '" + SF2->F2_DOC + "' "
	cQuery += cCRLF + " 	AND D2_SERIE 	= '" + SF2->F2_SERIE + "' "
	cQuery += cCRLF + " 	AND SD2.D_E_L_E_T_ = ' ' "
	cQuery += cCRLF + " 	AND SCK.D_E_L_E_T_ = ' ' "
	
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQuery)),cAliasER,.T.,.T.)
	
	Do While (cAliasER)->( !EOF() )
	
		SCJ->( dbSeek( (cAliasER)->D2_FILIAL + (cAliasER)->CK_NUM ) )
	
		aLogManu	:= Array(19)
		aLogManu[01]:= SCJ->CJ_NUM
		aLogManu[02]:= SCJ->CJ_XREVISA
		aLogManu[03]:= (cAliasER)->CK_ITEM
		aLogManu[04]:= dData
		aLogManu[05]:= cHora
		aLogManu[06]:= ''
		aLogManu[07]:= ''
		aLogManu[08]:= ''
		aLogManu[09]:= ''
		aLogManu[10]:= SCJ->CJ_XTIPCK
		aLogManu[11]:= 'GNF'
		aLogManu[12]:= 'MATA460'
		aLogManu[13]:= 'GERACAO NOTA FISCAL'
		aLogManu[14]:= 'GERADO ITEM: ' + (cAliasER)->D2_ITEM
		aLogManu[15]:= ''
		aLogManu[16]:= (cAliasER)->D2_PEDIDO
		aLogManu[17]:= (cAliasER)->D2_ITEMPV
		aLogManu[18]:= (cAliasER)->D2_DOC
		aLogManu[19]:= (cAliasER)->D2_ITEM
		::GrvLogManu( aLogManu )

		If Empty(__cUserID)
			RecLock('ZB4',.F.)
			ZB4->ZB4_USER		:= '000316'
			ZB4->ZB4_NUSER		:= 'Usuario Sistema Mis                     '
			ZB4->ZB4_DEPART		:= 'EXPEDICAO                     '
			ZB4->( MsUnlock() )
		EndIf

		(cAliasER)->( dbSkip() )
	EndDo

Endif




RestArea(aArea)
Return( Nil )



/*/{Protheus.doc} MA41XCOR
Adiciona cor no or�amento e efetiva��o or�amento

@type		method	
@author		Eurai Rapelli
@since 		2016.06.13

@example	Local oFEFATC01 := FEFATC01():New(); oFEFATC01:MA41XCOR( aCores )
/*/
Method MA41XCOR( aCores ) Class FEFATC01
Local nI		:= 0

Local aCoresRet	:= {}

Default aCores	:= {}

/*LEGENDA
01 - ABERTO
02 - PENDENTE APROVA��O FINANCEIRO
03 - REJEITADO APROVA��O FINANCEIRO
04 - APROVADO FINANCEIRO
05 - CANCELADO
06 - APROVA��O COMERCIAL - XPLAN -> DIVERGENCIA DATAS
07 - PEDIDO LIBERADO 
08 - ORCAMENTO BAIXADO
09 - PENDENTE MANUTENCAO
10 - REPROVADO MANUTENCAO
11 - [OLD] APROVADO MANUTENCAO
12 - PENDENTE FINANCEIRO
13 - REPROVADO FINANCEIRO
14 - APROVADO MANUTENCAO
CJ_XBLQAPR > CJ_XSTATUS
*/

/*CJ_SPLAN
1 - INCLUSAO
2 - ALTERACAO
3 - 
4 -
6 - 
7 - LIBERADO ALTERA��O DO CHECKLIST, RETORNO DO SPLAN
8 - CK_XITTFAT == N. ITENS CANCELADO 
9 - BLOQUEADO ALTERA��O DO CHECKLIST, SENDO ANALISADO PELO SPLAN
*/


aAdd( aCoresRet, { 'SCJ->CJ_XSTATUS=="01" ', 'BR_AMARELO' } )
aAdd( aCoresRet, { 'SCJ->CJ_XSTATUS=="02" ', 'BR_AZUL' } ) 
aAdd( aCoresRet, { 'SCJ->CJ_XSTATUS=="03" ', 'BR_CANCEL' } )
aAdd( aCoresRet, { 'SCJ->CJ_XSTATUS=="04" ', 'ENABLE' } )
aAdd( aCoresRet, { 'SCJ->CJ_XSTATUS=="05" ', 'BR_PRETO' } )
//aAdd( aCoresRet, { 'SCJ->CJ_XSTATUS=="06" ', 'PMSEDT2' } )
aAdd( aCoresRet, { 'SCJ->CJ_XSTATUS=="06" .AND. SCJ->CJ_XTIPCK!="3" ', 'PMSEDT2' } )
aAdd( aCoresRet, { 'SCJ->CJ_XSTATUS=="07" ', 'PMSEDT3' } )
aAdd( aCoresRet, { 'SCJ->CJ_XSTATUS=="08" ', 'DISABLE' } )
aAdd( aCoresRet, { 'SCJ->CJ_XSTATUS=="09" ', 'br_amarelo.bmp' } ) 
aAdd( aCoresRet, { 'SCJ->CJ_XSTATUS=="10" ', 'br_marron.bmp' } )
aAdd( aCoresRet, { 'SCJ->CJ_XSTATUS=="11" ', 'br_branco.bmp' } )
aAdd( aCoresRet, { 'SCJ->CJ_XSTATUS=="12" ', 'br_azul.bmp' } )
aAdd( aCoresRet, { 'SCJ->CJ_XSTATUS=="13" ', 'br_vermelho.bmp' } )
aAdd( aCoresRet, { 'SCJ->CJ_XSTATUS=="14" ', 'br_verde.bmp' } )
aAdd( aCoresRet, { 'SCJ->CJ_XSTATUS=="15" ', 'br_preto_1.png' } )
aAdd( aCoresRet, { 'SCJ->CJ_XSTATUS=="06" .AND. SCJ->CJ_XTIPCK=="3"', 'PMSEDT1' } )
//aAdd( aCoresRet, { 'SCJ->CJ_XSTATUS=="16" ', 'br_preto_a' } )
aAdd( aCoresRet, { 'SCJ->CJ_XSTATUS=="17" ', 'br_preto_a' } )
aAdd( aCoresRet, { 'SCJ->CJ_XSTATUS=="18" ', 'tmsimg32' } )
//aAdd( aCoresRet, { 'SCJ->CJ_XSTATUS=="19" ', 'ng_ico_sinistro1' } )

If ::cFunName == 'MATA415'
	cCadastro	:= 'CHECKLIST'
ElseIf ::cFunName == 'MATA416'
	cCadastro	:= 'EFETIVA��O CHECKLIST'
Endif


/*
aAdd( aCoresRet, { 'SCJ->CJ_XSTATUS=="01".AND.SCJ->CJ_STATUS=="A"', 'BR_AZUL' } ) 				//Bloqueio Aprova��o
aAdd( aCoresRet, { 'SCJ->CJ_XSTATUS=="02".AND.SCJ->CJ_STATUS=="A"', 'BR_CANCEL' } ) 			//Rejeitado Aprova��o
aAdd( aCoresRet, { 'SCJ->CJ_XSTATUS=="03".AND.SCJ->CJ_STATUS=="A"', 'BR_VERDE_ESCURO' } ) 		//Aprovado

For nI := 1 to Len( aCores )
	aAdd( aCoresRet, { aCores[nI,01], aCores[nI,02] } )
Next nI
*/

Return( aCoresRet )


/*/{Protheus.doc} MA41XLEG
Adiciona cor no or�amento e efetiva��o or�amento
Legenda

@type		method	
@author		Eurai Rapelli
@since 		2016.06.13

@example	Local oFEFATC01 := FEFATC01():New(); oFEFATC01:MA41XLEG( aCores )
/*/
Method MA41XLEG( aCores ) Class FEFATC01 
Local nI		:= 0

Local aCoresRet	:= {}

Default aCores	:= {}


aAdd( aCoresRet, { 'BR_AMARELO'				, '01-ABERTO' } )
aAdd( aCoresRet, { 'BR_AZUL'				, '02-PENDENTE APROVA��O FINANCEIRO' } )
aAdd( aCoresRet, { 'BR_CANCEL' 				, '03-REJEITADO APROVA��O FINANCEIRO' } )
aAdd( aCoresRet, { 'ENABLE' 				, '04-APROVADO FINANCEIRO' } )
aAdd( aCoresRet, { 'BR_PRETO' 				, '05-CANCELADO' } )
aAdd( aCoresRet, { 'PMSEDT2' 				, '06-APROVA��O COMERCIAL' } )
aAdd( aCoresRet, { 'PMSEDT3' 				, '07-APTO VIRAR PEDIDO' } )
aAdd( aCoresRet, { 'DISABLE'		 		, '08-TRANSFORMADO EM PEDIDO' } )
aAdd( aCoresRet, { 'br_amarelo.bmp'	 		, '09-PENDENTE MANUTENCAO' } )
aAdd( aCoresRet, { 'br_marron.bmp'			, '10-REPROVADO MANUTENCAO' } )
//aAdd( aCoresRet, { 'br_branco.bmp'	 	, '11-APROVADO MANUTENCAO' } )
aAdd( aCoresRet, { 'br_azul.bmp'	 		, '12-PENDENTE FINANCEIRO' } )
aAdd( aCoresRet, { 'br_vermelho.bmp' 		, '13-REPROVADO FINANCEIRO' } )
aAdd( aCoresRet, { 'br_verde.bmp'	 		, '14-APROVADO MANUTENCAO' } )
aAdd( aCoresRet, { 'br_preto_1.png'	 		, '15-CANCELADO MANUTENCAO CHECKLIST' } )
aAdd( aCoresRet, { 'PMSEDT1' 				, '16-APROVA��O COMERCIAL CONSULTA' } )
aAdd( aCoresRet, { 'br_preto_a'				, '17-CANCELADO FEFATA18 INATIVO' } )
aAdd( aCoresRet, { 'tmsimg32'				, '18-PENDENTE ANALISE PRECO MINIMO' } )	//papimg32	fwskin_simpedit_font
//aAdd( aCoresRet, { 'ng_ico_sinistro1'		, '19-REPROVADO ANALISE PRECO MINIMO' } )	//tmsimg32	

/*
For nI := 1 to Len( aCores )
	aAdd( aCoresRet, { aCores[nI,01], aCores[nI,02] } )
Next nI
*/

Return( aCoresRet )

/*/{Protheus.doc} MA415MNU
Adiciona op��o MENU

@author		Eurai Rapelli
@since 		2016.06.13

@example	Local oFEFATC01 := FEFATC01():New(); oFEFATC01:MA41XMNU
/*/
Method MA41XMNU() Class FEFATC01
Local nPos		:= 0

Local aSubMenu	:= {}
Local cSTUserPcp:= Alltrim(GetMv('MV_USRPCP'))
Local cSTCadAprCK:= Alltrim(GetMv('ST_APRCK'))

/*
ONDE:Parametros do array a Rotina:
1. Nome a aparecer no cabecalho
2. Nome da Rotina associada    
3. Reservado                        
4. Tipo de Transa��o a ser efetuada:    
	1 - Pesquisa e Posiciona em um Banco de Dados      
	2 - Simplesmente Mostra os Campos                  
	3 - Inclui registros no Bancos de Dados            
	4 - Altera o registro corrente                     
	5 - Remove o registro corrente do Banco de Dados 
5. Nivel de acesso                                   
6. Habilita Menu Funcional
*/

aAdd( aRotina, {'* Analise Frete Minimo '		, 'U_FEFATA19()' 		, 0, 10 } )
aAdd( aRotina, {'* Aprova��o &Financeira'		, 'U_FEFATA05()' 		, 0, 10 } )
aAdd( aRotina, {'* Aprova��o Co&mercial'		, 'U_FEFATA11()' 		, 0, 11 } )
aAdd( aRotina, {'* Aprova��o Manu&ten��o'		, 'U_FEFATA14()' 		, 0, 4 } )
aAdd( aRotina, {'* &Hist�ricos'					, 'U_FEFATC01( 1 )' 	, 0, 12 } )
aAdd( aRotina, {'* &Manuten��o CHKLIST'			, 'U_FEFATA13()' 		, 0, 4 } )
aAdd( aRotina, {'* &Reenvio PCP'				, 'U_FEFATA16()' 		, 0, 4 } )
aAdd( aRotina, {'* &Reativar CK'				, 'U_FEFATC01( 8 )'		, 0, 4 } )
aAdd( aRotina, {'* &Enviar Plano Carga'			, 'U_STFT0310()'		, 0, 4 } )
aAdd( aRotina, {'* Alterar Data Cliente'		, 'U_AtuDatCli()'  		, 0, 4 } )
aAdd( aRotina, {'* Alt.Data Embarq./Saida'		, 'U_AtuDatEmb()'  		, 0, 4 } )
If __cUserID $ cSTUserPcp .or. At( __cUserID, ::GetUSRAdm() ) > 0
	aAdd( aRotina, {'* Reenvio CK &Opt-Studio'	, 'U_ReEnvCKOPT()' 		, 0, 4 } )
	aAdd( aRotina, {'* Reenvio PV &Opt-Studio'	, 'U_ReEnvPVOPT()' 		, 0, 4 } )
	aAdd( aRotina, {'* Atualiza��o Opt-St&udio'	, 'U_SPPPth()'   		, 0, 4 } )
EndIf

If At( __cUserID, ::GetUSRAdm() ) > 0 .or. __cUserID $ cSTCadAprCK
	aAdd( aRotina, {'* Aprovadores'			, 'U_FEGENA01()' 		, 0, 3 } )
EndIf 

If At( __cUserID, ::GetUSRAdm() ) > 0 
	aAdd( aSubMenu, {'[*] EEC TST'				, 'U_FEFATA03()' 		, 0, 12 } )
	aAdd( aSubMenu, {'[*] Mudar CJ_XSTATUS'		, 'U_FEFATC01( 2 )' 	, 0, 12 } )
	aAdd( aSubMenu, {'[*] Depurar Sim'			, 'U_FEFATC01( 3 )' 	, 0, 12 } )
	aAdd( aSubMenu, {'[*] Depurar N�o'			, 'U_FEFATC01( 4 )' 	, 0, 12 } )
	aAdd( aSubMenu, {'[*] Atualiza Pedido'		, 'U_FEFATC01( 5 )' 	, 0, 12 } )
	aAdd( aSubMenu, {'[*] Details'				, 'U_FEFATC01( 6 )' 	, 0, 12 } )
	aAdd( aSubMenu, {'[*] JOB FEFATA18'			, 'U_FEFATA18()' 		, 0, 12 } )
	aAdd( aSubMenu, {'[*] Motivos'				, 'U_FEFATA17()' 		, 0, 3 } )
	aAdd( aRotina, { "Super ADM"   	, aSubMenu      		, 0, 3 } )
Endif



If( nPos := aScan( aRotina, { |UA| UA[02] == 'A415Exclui' } ) ) > 0
	aDel( aRotina, nPos )
	aSize( aRotina, Len(aRotina)-01 )
Endif

If( nPos := aScan( aRotina, { |UA| UA[02] == 'A415Altera' } ) ) > 0
	aRotina[nPos,02]	:= "U_FEFATV07()"
Endif

If( nPos := aScan( aRotina, { |UA| UA[02] == 'A415Cancel' } ) ) > 0
	aRotina[nPos,02]	:= "U_FEFATV08()"
Endif


Return( Nil )



/*/{Protheus.doc} PosAprov
Posiciona no Aprovador

@type		method
@author		Eurai Rapelli
@since 		2016.06.29

@param		cNumSCJ			, Caracter		, Numero
@param		cCodUsr			, Caracter		, C�digo Usuario

@example	oFEFATC01:PosAprov( cNumSCJ, cCodUsr )
/*/
Method PosAprov( cNumSCJ, cCodUsr, cRevisao ) CLASS FEFATC01
Local lRet			:= .F.

Default cNumSCJ		:= SCJ->CJ_NUM
Default cCodUsr		:= RetCodUsr()
Default cRevisao	:= SCJ->CJ_XREVISA


If Select("QryPosAprv") > 0//Verifica se ja existe alias criado
	QryPosAprv->( dbCloseArea() )
Endif

cQuery := cCRLF + "	SELECT  "
cQuery += cCRLF + "		ZB3.R_E_C_N_O_ AS ZB3RECNO "
cQuery += cCRLF + "	FROM "
cQuery += cCRLF + RetSqlName("ZB3") + " ZB3 "
cQuery += cCRLF + "	WHERE "
cQuery += cCRLF + "		ZB3_FILIAL 		= '" + xFilial('ZB3') + "' "
cQuery += cCRLF + " 	AND ZB3_ID		= '" + cNumSCJ + "' "
cQuery += cCRLF + " 	AND ZB3_TIPO 	= '" + ::GetTpLib() + "' "
cQuery += cCRLF + " 	AND ZB3_APROV 	= '" + cCodUsr + "' "
//cQuery += cCRLF + " 	AND ZB3_STATUS 	= 'B' "
cQuery += cCRLF + " 	AND ZB3_REVISA 	= '" + cRevisao + "' "
cQuery += cCRLF + " 	AND ZB3.D_E_L_E_T_ <> '*' "

DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQuery)),"QryPosAprv",.T.,.T.)

If QryPosAprv->( !EOF() )
	ZB3->( dbGoTo( QryPosAprv->ZB3RECNO ) )
	lRet	:= .T.
Else
	ShowHelpDlg( ProcName(1) + '/' + ProcName(0), {'N�o possui permiss�o para aprovar esse or�amento'}, , {'Solicite ao respons�vel a Aprova��o'}, )
	lRet	:= .F.
Endif


Return( lRet )




/*/{Protheus.doc} PosNextApr
Posiciona Proximo aprovador

@type		method
@author		Eurai Rapelli
@since 		2016.07.01

@param		cNumSCJ			, Caracter		, Numero

@example	oFEFATC01:PosNextApr( cNumSCJ, cRevisao )
/*/
Method PosNextApr( cNumSCJ, cRevisao ) CLASS FEFATC01
Local lRet			:= .F.

Default cNumSCJ		:= SCJ->CJ_NUM
Default cRevisao	:= SCJ->CJ_XREVISA


If Select("QryNextApr") > 0//Verifica se ja existe alias criado
	QryNextApr->( dbCloseArea() )
Endif

cQuery := cCRLF + "	SELECT  "
cQuery += cCRLF + "		ZB3.R_E_C_N_O_ AS ZB3RECNO "
cQuery += cCRLF + "	FROM "
cQuery += cCRLF + RetSqlName("ZB3") + " ZB3 "
cQuery += cCRLF + "	WHERE "
cQuery += cCRLF + "		ZB3_FILIAL 		= '" + xFilial('ZB3') + "' "
cQuery += cCRLF + " 	AND ZB3_ID		= '" + cNumSCJ + "' "
cQuery += cCRLF + " 	AND ZB3_TIPO 	= '" + ::GetTpLib() + "' "
cQuery += cCRLF + " 	AND ZB3_STATUS 	= 'B' "
cQuery += cCRLF + " 	AND ZB3_REVISA 	= '" + cRevisao + "' "
cQuery += cCRLF + " 	AND ZB3.D_E_L_E_T_ <> '*' "
cQuery += cCRLF + "	ORDER BY ZB3_NIVEL "

DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQuery)),"QryNextApr",.T.,.T.)

If QryNextApr->( !EOF() )
	ZB3->( dbGoTo( QryNextApr->ZB3RECNO ) )
	lRet	:= .T.
Else
	lRet	:= .F.
Endif


Return( lRet )





/*/{Protheus.doc} SendForApr
Envia Pedido de Venda para Aprova��o

@type		method
@author		Eurai Rapelli
@since 		2016.06.28

@example	oFEFATC01:SendForApr( cNumSCJ, nValor, cRevisao )
/*/
Method SendForApr( cNumSCJ, nValor, cRevisao ) CLASS FEFATC01
Local aAprovador	:= {}
Local lRet			:= .T.

Default	cNumSCJ		:= SCJ->CJ_NUM
Default nValor		:= SCJ->CJ_XVLBRUT
Default cRevisao	:= SCJ->CJ_XREVISA


aAprovador := ::GetAprov( nValor )

If Len( aAprovador ) > 0 

	::GeraAlcApr( cNumSCJ, aAprovador, cRevisao )
	
Else

	ShowHelpDlg( ProcName(1) + '/' + ProcName(0), {'Sem aprovadores cadastrado: '}, , {'Cadastre aprovadores e refa�a o or�amento'}, )
	lRet			:= .F.

Endif


Return( lRet )



/*/{Protheus.doc} SetDescont
Recalcula o Desconto

@type		method
@author		Eurai Rapelli
@since 		2016.08.29
/*/
Method SetDescont() CLASS FEFATC01
Local nCasas 		:= TamSX3('CK_PRUNIT')[02]
Local aAreaSA1		:= SA1->( GetArea() )
Local aAreaSE4		:= SE4->( GetArea() )
Local aAreaSB1		:= SB1->( GetArea() )

Local cQuery	:= ''
Local cCodRef	:= TMP1->CK_XCODREF
Local cCliente 	:= ''
Local cLoja 	:= ''
Local cTabPreco := ''
Local cCondPg 	:= ''
Local cFormPg 	:= ''
Local nFaixa 	:= 0
Local nPrcBase	:= 0
Local nDesconto	:= 0
Local nValor	:= 0
Local nPrcVen	:= 0
Local nVlDesc	:= 0
Local nI		:= 0
Local aProdPesq	:= {}
Local aCpos		:= {}


Local cReadVar		:= AllTrim( ReadVar() )


SA1->( MsSeek( xFilial('SA1') + M->CJ_CLIENTE + M->CJ_LOJA ) )

If SA1->A1_EST <> 'EX'
	
	If cReadVar == 'M->CK_PRCVEN'
		nPrcVen := M->CK_PRCVEN
	Else
		nPrcVen := TMP1->CK_PRCVEN
	Endif

	//Se estiver preenchido e nao tiver perda
	//Com perda nao pode arredondar
	If !Empty(SA1->A1_TABELA) .AND. ;
		TMP1->CK_XPERDA == 0 .AND. nPrcVen == 0 .AND. TMP1->CK_QTDVEN == 0 .AND. TMP1->CK_XTPPERD <> 'F'
	
		If SA1->A1_EST <> 'EX'
			nCasas := 2
		Else
			nCasas := 3
		Endif
	
	Endif

	//MaReleRDes()
	//FtRegraDesc(2)
	
	SE4->( dbSetOrder(1) )
	SE4->( MsSeek( xFilial("SE4") + M->CJ_CONDPAG ) )
	
	aAdd( aProdPesq, TMP1->CK_PRODUTO )
	If !Empty( cCodRef )
	
		If Select("Qry1") > 0//Verifica se ja existe alias criado
			Qry1->( dbCloseArea() )
		Endif
		
		cQuery := cCRLF + "	SELECT  "
		cQuery += cCRLF + "		B1_COD "
		cQuery += cCRLF + "	FROM "
		cQuery += cCRLF + RetSqlName("SB1") + " SB1 "
		cQuery += cCRLF + "	WHERE "
		cQuery += cCRLF + "		B1_FILIAL		= '" + xFilial('SB1') + "' "
		cQuery += cCRLF + " 	AND B1_CODREF 	= '" + cCodRef + "' "
		If Left(AllTrim(cCodRef),1) == "B"
			cQuery += cCRLF + " 	AND B1_TIPO 	= 'SA' "
		ElseIf Left(AllTrim(cCodRef),1) == "F"
			cQuery += cCRLF + " 	AND B1_TIPO 	= 'PA' "
		ElseIf Left(AllTrim(cCodRef),1) == "L"
			cQuery += cCRLF + " 	AND B1_TIPO 	= 'PR' "
		Endif	
		cQuery += cCRLF + " 	AND B1_MSBLQL 	= '2' "
		cQuery += cCRLF + " 	AND SB1.D_E_L_E_T_ <> '*' "
		
		DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQuery)),"Qry1",.T.,.T.)	
		
		If Qry1->( !EOF() )
			aAdd( aProdPesq, Qry1->B1_COD )
		Endif
		
	Endif
	
	Qry1->( dbCloseArea() )
	
	
	cCliente 	:= M->CJ_CLIENTE
	cLoja 		:= M->CJ_LOJA
	cTabPreco 	:= M->CJ_TABELA
	cCondPg 	:= M->CJ_CONDPAG
	cFormPg 	:= SE4->E4_FORMA
	If cReadVar == 'M->CK_QTDVEN'
		nFaixa 		:= M->CK_QTDVEN
	Else
		nFaixa 		:= TMP1->CK_QTDVEN
	Endif
	nPrcBase	:= TMP1->CK_PRUNIT


	For nI := 01 to Len(aProdPesq)

		If Select("QryDesc") > 0//Verifica se ja existe alias criado
			QryDesc->( dbCloseArea() )
		Endif
		
		SB1->( MsSeek( xFilial('SB1') + aProdPesq[nI] ) )
		
		cQuery := 		  "	SELECT  "
		cQuery += cCRLF + "		ACO.ACO_PERDES DESCONTO, ACO_CODREG, ACO.ACO_VLRDES VLRDESC, ACO_GRPVEN  "
		cQuery += cCRLF + " 	,ACO_DATDE, ACO_DATATE, ACO_HORADE, ACO_HORATE, ACO_TPHORA "
		cQuery += cCRLF + " 	,ACP.* "
		cQuery += cCRLF + " FROM "
		cQuery += cCRLF + 		RetSqlName("ACO") + " ACO "
		cQuery += cCRLF + " INNER JOIN "
		cQuery += cCRLF + 		RetSqlName("ACP") + " ACP "
		cQuery += cCRLF + " ON " 
		cQuery += cCRLF + "		ACP.ACP_FILIAL = '" + xFilial("ACP") + "' "
		cQuery += cCRLF + " 	AND ACP.ACP_CODREG = ACO.ACO_CODREG "
		cQuery += cCRLF + "	WHERE "
		cQuery += cCRLF + "		ACO.ACO_FILIAL = '" + xFilial("ACO") + "' "
		cQuery += cCRLF + "		AND (ACO.ACO_CODCLI = '" + Space(Len(SA1->A1_COD)) + "' OR ACO.ACO_CODCLI = '" + cCliente + "')  "
		cQuery += cCRLF + "		AND (ACO.ACO_LOJA = '" + Space(Len(SA1->A1_LOJA)) + "' OR ACO.ACO_LOJA = '" + cLoja + "')  "
		cQuery += cCRLF + "		AND (ACO.ACO_CODTAB = '" + Space(Len(DA0->DA0_CODTAB)) + "' OR ACO.ACO_CODTAB = '" + cTabPreco + "')  "
		cQuery += cCRLF + "		AND (ACO.ACO_CONDPG = '" + Space(Len(DA0->DA0_CONDPG)) + "' OR ACO.ACO_CONDPG = '" + cCondPg + "')  "
		cQuery += cCRLF + "		AND (ACO.ACO_FORMPG = '" + Space(Len(ACO->ACO_FORMPG)) + "' OR ACO.ACO_FORMPG = '" + cFormPg + "')  "
		cQuery += cCRLF + "		AND (ACP.ACP_GRUPO = '" + Space(Len(SB1->B1_GRUPO))+"' OR ACP.ACP_GRUPO = '" + SB1->B1_GRUPO + "')  "
		cQuery += cCRLF + "		AND (ACP.ACP_CODPRO = '" + Space(Len(SB1->B1_COD))+"' OR ACP.ACP_CODPRO = '" + aProdPesq[nI] + "')  "
		cQuery += cCRLF + "		AND ACP.ACP_FAIXA >= " + Alltrim(StrZero(nFaixa,18,2)) + "  "
		cQuery += cCRLF + "		AND ACP.D_E_L_E_T_= ' ' "
		cQuery += cCRLF + "		AND ACO.D_E_L_E_T_ = ' ' "
		cQuery += cCRLF + "		AND ACO.ACO_MSBLQL = '2' "
		cQuery += cCRLF + "		ORDER BY ACO_FILIAL DESC, ACO_CODTAB DESC, ACO_CONDPG DESC, ACO_FORMPG DESC, ACO_CODCLI DESC, ACO_LOJA DESC, ACO_CFAIXA " 
	
		DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQuery)),"QryDesc",.T.,.T.)
	
		If QryDesc->( !EOF() )
			aCpos	:=	{ {'ACO_DATDE',"D",8,0},{'ACO_DATATE',"D",8,0}}
			Exit
		Endif

	
	Next nI

	For nI := 1 To Len(aCpos)
		TcSetField( 'QryDesc', aCpos[nI,01], aCpos[nI,02], aCpos[nI,03], aCpos[nI,04] )
	Next nI	
	
	Do While QryDesc->( !EOF() )
		
		If FtIsDataOk("ACO","QryDesc")
		
			If nFaixa <= QryDesc->ACP_FAIXA
			
				If QryDesc->ACP_PERDES <> 0 //Desconto por Percentual
					
					nDesconto := QryDesc->ACP_PERDES
					
				ElseIf QryDesc->ACP_VLRDES <> 0 //Desconto por Valor
				
					nDesconto := VlrToPct( QryDesc->ACP_VLRDES, 1, nFaixa, nPrcBase, QryDesc->ACP_TPDESC )
					
				Else
				
					nDesconto := 0
					
				EndIf

				If nDesconto > 0
					Exit
				EndIf
				
			EndIf			
		
		Endif
	
		QryDesc->( dbSkip() )
	EndDo	
	QryDesc->( dbCloseArea() )
	
	If nDesconto > 0

		M->CK_DESCONT 	:= nDesconto
		
		nPrcVen			:= FtDescItem(FtDescCab(nPrcBase,{M->CJ_DESC1,M->CJ_DESC2,M->CJ_DESC3,M->CJ_DESC4}),TMP1->CK_PRCVEN,TMP1->CK_QTDVEN,@nValor,@M->CK_DESCONT,@nVlDesc,nVlDesc,1,,If(cPaisLoc=="CHI",M->CJ_MOEDA,NIL))
		nPrcVen			:= Round( nPrcVen, nCasas )
		
		RecLock('TMP1',.F.)
			TMP1->CK_PRCVEN		:= nPrcVen
			TMP1->CK_PRUNIT		:= TMP1->CK_PRCVEN
			TMP1->CK_XPRCVEN	:= TMP1->CK_PRCVEN
			TMP1->CK_VALOR  	:= A410Arred(nFaixa * TMP1->CK_PRCVEN,"CK_VALOR")
			TMP1->CK_VALDESC 	:= 0
			TMP1->CK_DESCONT 	:= 0
			
			If ::nFator > 0
				TMP1->CK_XNETDES	:= TMP1->CK_PRCVEN * ::nFator
			Else
				TMP1->CK_XNETDES	:= TMP1->CK_PRCVEN
			Endif
			
			//TMP1->CK_XPRCNET	:= TMP1->CK_XNETDES + ( nPrcBase * nDesconto )
			//TMP1->CK_XNETDES	:= FtDescItem(FtDescCab(TMP1->CK_XNETDES,{M->CJ_DESC1,M->CJ_DESC2,M->CJ_DESC3,M->CJ_DESC4}),TMP1->CK_XNETDES,TMP1->CK_QTDVEN,@nValor,@M->CK_DESCONT,@nVlDesc,nVlDesc,1,,If(cPaisLoc=="CHI",M->CJ_MOEDA,NIL))
		TMP1->( MsUnlock() )
		::cLog	+= '[DESCONTO %] ' + cValtoChar(nDesconto) + cCRLF
		::cLog	+= '[nPrcBase * nDesconto] ' + cValtoChar(nPrcBase * nDesconto) + cCRLF
		::cLog	+= '[CK_PRCVEN] ' + cValtoChar(TMP1->CK_PRCVEN) + cCRLF
		::cLog	+= '[CK_XNETDES	:= TMP1->CK_PRCVEN] ' + cValtoChar(TMP1->CK_XNETDES) + cCRLF
		::cLog	+= '[CK_XPRCNET] ' + cValtoChar(TMP1->CK_XPRCNET) + cCRLF
		
	Endif
	
Endif

RestArea( aAreaSA1 )
RestArea( aAreaSB1 )
RestArea( aAreaSE4 )
Return( {  nPrcVen, nDesconto } )



/*/{Protheus.doc} SetKey
Seta as key

@type		method	
@author		Eurai Rapelli
@since 		2016.06.13

@example	Local oFEFATC01 := FEFATC01():New(); oFEFATC01:SetKey( 1 )
/*/
Method SetKey( nOpc ) Class FEFATC01 
Default nOpc	:= 1


If nOpc == 1

	SetKey( VK_F10, { || U_FEFATA01() } )
	SetKey( VK_F11, { || U_FEFATA02() } )

Else

	SetKey( VK_F10, { || Nil } )
	SetKey( VK_F11, { || Nil } )

Endif

Return( Nil )








	

/*/{Protheus.doc} SetPrcFat
Retorna pre�o com calculo de fator

@type		method
@author		Eurai Rapelli
@since 		2016.08.26

@example	oUA := FEFATC01():New(), oUA:SetPrcFat()
/*/
Method SetPrcFat() CLASS FEFATC01
Local nPrcVen		:= 0
Local nFator		:= 0
Local nCasas		:= TamSX3('CK_PRUNIT')[02]

Local aRet			:= {}

Local aAreaSE4		:= SE4->( GetArea() )
Local aAreaSA1		:= SA1->( GetArea() )
Local aAreaSB1		:= SB1->( GetArea() )

Local cReadVar		:= AllTrim( ReadVar() )

Local bError 	:= ErrorBlock( { |e| MsgAlert( e:Description ) } )

/* Wagner 2016.12.29 | SA1->A1_CONTRIB
Preco Unit�rio = Pre�o Net / ( 1 -  ( ICC + PS2 + CF2 + (ICC * IPI) ) )   
1,226/(1-(17%+1,65%+7,6%+(17%*5%)))

/*
ICC - ICMS COMPLEMENTAR
ICMS - ICMS 
PS2 - Pis 
CF2 - Cofins
IPI - IPI

SIM
	nPrcVen := [Pre�o Tabela] / (  ( 100 - ( [ICMS] + [COFINS] + [PIS] ) ) / 100 )
	
NAO
	nPrcVen := [Pre�o Tabela] / (  ( 1 - ( [COMPLEMENTAR] + [COFINS] + [PIS] + ( [COMPLEMENTAR] * [IPI] ) ) ) )
*/

If cReadVar == 'M->CK_TES'
	cTES		:= M->CK_TES
Else
	cTES		:= TMP1->CK_TES
Endif

SA1->( MsSeek( xFilial('SA1') + M->CJ_CLIENTE + M->CJ_LOJA ) )
//CLIENTE 025171
If SA1->A1_EST <> 'EX' .AND. !Empty(M->CJ_CONDPAG) .AND. !Empty(cTES)

	
	If Empty(SA1->A1_TABELA)
	
		If SA1->A1_EST <> 'EX'
			nCasas := 2
		Else
			nCasas := 3
		Endif
	
	Endif
		
	nPrcVen		:= TMP1->CK_PRUNIT
	
    SF4->(dbSetOrder(1))
    SF4->( MsSeek( xFilial("SF4") + cTES ) )
	
	aRet := ::GetFator( cTES, @nFator )
	
	If nFator > 0
		nPrcVen := nPrcVen / nFator
		::cLog	+= '[PRECO/FATOR] ' + cValtoChar(nPrcVen) + cCRLF
	Endif	
	
	//cTemp += VarInfo( "aRet: ", aRet, , .F. )

	If SE4->( MsSeek( xFilial('SE4') + M->CJ_CONDPAG ) ) 
	
		If SE4->E4_XFATFIN > 0 .AND. SF4->F4_DUPLIC == 'S'
		
			nPrcVen := nPrcVen * SE4->E4_XFATFIN
			::cLog	+= '[INDICE] ' + cValtoChar(SE4->E4_XFATFIN) + cCRLF
			::cLog	+= '[PRECO*INDICE] ' + cValtoChar(nPrcVen) + cCRLF
		
		Endif
	
	Endif

	RecLock('TMP1',.F.)
		TMP1->CK_PRCVEN		:= Round( nPrcVen, nCasas )
		TMP1->CK_PRUNIT		:= TMP1->CK_PRCVEN
		TMP1->CK_VALOR 		:= A410Arred(TMP1->CK_QTDVEN * TMP1->CK_PRCVEN,"CK_VALOR")
		TMP1->CK_XPRCVEN	:= TMP1->CK_PRCVEN
		If nFator > 0
			TMP1->CK_XNETDES	:= TMP1->CK_PRCVEN * nFator
		Else
			TMP1->CK_XNETDES	:= TMP1->CK_PRCVEN
		Endif

	TMP1->( MsUnlock() )

	::cLog	+= '[VALOR] ' + cValtoChar(TMP1->CK_PRCVEN) + cCRLF
	::cLog	+= '[CK_XNETDES	:= TMP1->CK_PRCVEN * nFator] ' + cValtoChar(TMP1->CK_XNETDES) + cCRLF

Else
	::nFator := 1
												//	TES deve vir vazio segundo Alexandre
Endif

ErrorBlock(bError)
RestArea( aAreaSE4 )
RestArea( aAreaSA1 )
RestArea( aAreaSB1 )
Return( Nil )






/*/{Protheus.doc} SetPrcTab
Retorna pre�o da tabela de venda

@type		method
@author		Eurai Rapelli
@since 		2016.08.19

@example	oUA := FEFATC01():New(), oUA:SetPrcTab()
/*/
Method SetPrcTab( cCodTab, cCodRef, cProduto ) CLASS FEFATC01
Local cQuery		:= ''

Local nCasas		:= TamSX3('CK_PRUNIT')[02]

Local aB1COD		:= TamSX3('B1_COD')	//Atualiza��o 2018.03.12. Eurai Rapelli - Static lendo antes de inicializar RpcSetEnv. Static > Local

Default cCodTab		:= M->CJ_TABELA
Default cCodRef		:= TMP1->CK_XCODREF
Default cProduto	:= TMP1->CK_PRODUTO


If Empty( cCodTab )
	Return( Nil )
Endif

SA1->( MsSeek( xFilial('SA1') + M->CJ_CLIENTE + M->CJ_LOJA ) )


cProduto := Padr( cProduto, aB1COD[01] )

DA1->( dbSetOrder(1) )
If DA1->( MsSeek( xFilial('DA1') + cCodTab + cProduto ) )
	
	RecLock('TMP1',.F.)
		TMP1->CK_PRUNIT	:= Round( DA1->DA1_PRCVEN, nCasas )
		TMP1->CK_PRCVEN	:= Round( DA1->DA1_PRCVEN, nCasas )
		TMP1->CK_XPRCNET:= Round( DA1->DA1_PRCVEN, nCasas )
		TMP1->CK_XNETDES:= Round( DA1->DA1_PRCVEN, nCasas )
	TMP1->( MsUnlock() )
	
	::cLog	:= '[CK_PRUNIT PA] ' + cValtoChar(TMP1->CK_PRUNIT) + cCRLF
	::cLog	+= '[CK_PRCVEN PA] ' + cValtoChar(TMP1->CK_PRCVEN) + cCRLF
	
Else
	
	If Select("Qry1") > 0//Verifica se ja existe alias criado
		Qry1->( dbCloseArea() )
	Endif
	
	cQuery := cCRLF + "	SELECT  "
	cQuery += cCRLF + "		B1_COD "
	cQuery += cCRLF + "	FROM "
	cQuery += cCRLF + RetSqlName("SB1") + " SB1 "
	cQuery += cCRLF + "	WHERE "
	cQuery += cCRLF + "		B1_FILIAL		= '" + xFilial('SB1') + "' "
	cQuery += cCRLF + " 	AND B1_CODREF 	= '" + cCodRef + "' "
	If Left(AllTrim(cCodRef),1) == "B"
		cQuery += cCRLF + " 	AND B1_TIPO 	= 'SA' "
	ElseIf Left(AllTrim(cCodRef),1) == "F"
		cQuery += cCRLF + " 	AND B1_TIPO 	= 'SA' "
	ElseIf Left(AllTrim(cCodRef),1) == "L"
		cQuery += cCRLF + " 	AND B1_TIPO 	= 'PR' "
	Endif	
	cQuery += cCRLF + " 	AND B1_MSBLQL 	= '2' "
	cQuery += cCRLF + " 	AND SB1.D_E_L_E_T_ <> '*' "
	
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQuery)),"Qry1",.T.,.T.)	
	
	If Qry1->( !EOF() )
		
		If DA1->( MsSeek( xFilial('DA1') + cCodTab + Qry1->B1_COD ) )
			
			RecLock('TMP1',.F.)
				TMP1->CK_PRUNIT	:= Round( DA1->DA1_PRCVEN, nCasas )
				TMP1->CK_PRCVEN	:= Round( DA1->DA1_PRCVEN, nCasas )
				TMP1->CK_XPRCNET:= Round( DA1->DA1_PRCVEN, nCasas )
				TMP1->CK_XNETDES:= Round( DA1->DA1_PRCVEN, nCasas )
			TMP1->( MsUnlock() )

			::cLog	:= '[CK_PRUNIT SA] ' + cValtoChar(TMP1->CK_PRUNIT) + cCRLF
			::cLog	+= '[CK_PRCVEN SA] ' + cValtoChar(TMP1->CK_PRCVEN) + cCRLF
			
		Else
		
			Help( ,, 'HELP',, '[FEFATC01:SetPrcTab]Cadastre produto na tabela de Pre�o: ' + Qry1->B1_COD, 1, 0)
		
		Endif
		
	Else
	
		Help( ,, 'HELP',, '[FEFATC01:SetPrcTab]Produto Referencia n�o encontrado: ' + cCodRef, 1, 0)
		
	Endif
	
	Qry1->( dbCloseArea() )
	

Endif

RecLock('TMP1',.F.)
	TMP1->CK_VALDESC 	:= 0
	TMP1->CK_DESCONT 	:= 0
	TMP1->CK_VALOR 		:= Round( TMP1->CK_QTDVEN * TMP1->CK_PRCVEN, nCasas )
TMP1->( MsUnlock() )		

Return( Nil )




/*/{Protheus.doc} SetPerda
Seta a Perda

@type		method
@author		Eurai Rapelli
@since 		2016.09.01
/*/
Method SetPerda() CLASS FEFATC01
Local cReadVar		:= AllTrim( ReadVar() )

Local nPrcVen		:= 0
Local nPerda 		:= 0

Local nCasas		:= TamSX3('CK_PRUNIT')[02]


SA1->( MsSeek( xFilial('SA1') + M->CJ_CLIENTE + M->CJ_LOJA ) )




If cReadVar == 'M->CK_PRCVEN'
	nPrcVen := M->CK_PRCVEN
Else
	nPrcVen := TMP1->CK_PRCVEN
Endif

If TMP1->CK_XPERDA > 0 .AND. nPrcVen > 0 .AND. TMP1->CK_QTDVEN > 0 .AND. TMP1->CK_XTPPERD == 'F'

	nPerda := 1 * ( TMP1->CK_XPERDA / ( Val(TMP1->CK_XLARGUR) - TMP1->CK_XPERDA ) )

	RecLock('TMP1',.F.)
		TMP1->CK_PRCVEN		+= Round( nPrcVen * nPerda, nCasas )
		TMP1->CK_PRUNIT		:= TMP1->CK_PRCVEN
		TMP1->CK_VALOR 		:= A410Arred(TMP1->CK_QTDVEN * TMP1->CK_PRCVEN,"CK_VALOR")
		TMP1->CK_VALDESC 	:= 0
		TMP1->CK_DESCONT 	:= 0	
	TMP1->( MsUnlock() )
	::cLog	+= '[PERDA] ' + cValtoChar(nPerda) + cCRLF
	::cLog	+= '[CK_PRCVEN FIM] ' + cValtoChar(TMP1->CK_PRCVEN) + cCRLF

Endif

Return( Nil )





/*/{Protheus.doc} SetRodape
Atualiza Rodape

@type		method
@author		Eurai Rapelli
@since 		2016.10.27

@example	oFEFATC01 := FEFATC01():New(); oFEFATC01:SetRodape()
/*/
Method SetRodape() CLASS FEFATC01
Local nX		:= 0
Local oDlg		:= GetWndDefault()
Local aControl 	:= oDlg:aControls

Local aRet		:= {}
Local aTmp		:= {}
Local aProd		:= {}
Local aArea		:= GetArea()
Local aAreaSB1	:= SB1->( GetArea() )
Local aAreaTMP1	:= TMP1->( GetArea() )
Local cFilialSB1:= xFilial('SB1')

SA1->( MsSeek( xFilial('SA1') + M->CJ_CLIENTE + M->CJ_LOJA ) )


TMP1->( dbGoTop() )
Do While TMP1->( !EOF() )
/*
	If TMP1->CK_FLAG .OR. TMP1->CK_XITFAT == 'N'
		TMP1->( dbSkip() )
		Loop
	Endif
*/
	SB1->( MsSeek( cFilialSB1 + TMP1->CK_PRODUTO ) )

	aTmp 		:= Array(15)
	
	aTmp[01] 	:= TMP1->CK_PRODUTO						//Codigo do Produto ( Obrigatorio )
	aTmp[02] 	:= TMP1->CK_TES							//Codigo do TES ( Opcional )
	aTmp[03] 	:= TMP1->CK_QTDVEN						//Quantidade ( Obrigatorio ) 
	aTmp[04] 	:= TMP1->CK_PRCVEN						//Preco Unitario ( Obrigatorio )
	aTmp[05] 	:= 0									//Valor do Desconto ( Opcional ) 
	aTmp[06] 	:= ""									//Numero da NF Original ( Devolucao/Benef )
	aTmp[07] 	:= ""									//Serie da NF Original ( Devolucao/Benef ) 
	aTmp[08] 	:= 0									//Recno da NF Original no arq SD1/SD2
	aTmp[09] 	:= 0									//Valor do Frete do Item ( Opcional )
	aTmp[10] 	:= 0									//Valor da Despesa do item ( Opcional )
	aTmp[11] 	:= 0									//Valor do Seguro do item ( Opcional )
	aTmp[12] 	:= 0									//Valor do Frete Autonomo ( Opcional )
	aTmp[13] 	:= TMP1->CK_VALOR						//Valor da Mercadoria ( Obrigatorio )
	aTmp[14] 	:= 0									//Valor da Embalagem ( Opiconal )	
	aTmp[15] 	:= SB1->( Recno() )						//SB1->( Recno() )
	
	aAdd( aProd, aTmp )
	

	TMP1->( dbSkip() )
EndDo

aRet 	:= ::oFEGENC01:RetImposto( M->CJ_CLIENTE, M->CJ_LOJA, SA1->A1_TIPO, aProd, { { 1, 'NF_TOTAL'} } )

For nX := 1 To Len(aControl)
	If ValType(aControl[nX]) <> "U" .AND. ValType(aControl[nX]:Cargo)=="C"
		Do Case
			Case ( aControl[nX]:Cargo $ "Total" )
				aControl[nX]:SetText( aRet[01] - M->CJ_FRETE - M->CJ_SEGURO  )
		EndCase
	EndIf
Next nX

RestArea(aAreaSB1)
RestArea(aAreaTMP1)
RestArea(aArea)
Return( Nil )





/*/{Protheus.doc} ShowLog
Mostra o LOG

@type		method
@author		Eurai Rapelli
@since 		2016.12.07

@example	oFEFATC01 := FEFATC01():New(); oFEFATC01:ShowLog()
/*/
Method ShowLog() CLASS FEFATC01

If File( cDebug )
	::oFEGENC01:ShowLog(::cLog)
	::cLog := ''
Endif

Return( Nil )










/*/{Protheus.doc} Tracker
Tracker

@type		method	
@author		Eurai Rapelli
@since 		2017.01.06

@example	Local oFEFATC01 := FEFATC01():New(); oFEFATC01:Tracker( cCJNUM )
/*/
Method Tracker( cCJNUM ) Class FEFATC01
Local aEnt		:= {}

Default cCJNUM	:= SCJ->CJ_NUM

SCK->( dbSeek( SCJ->CJ_FILIAL + cCJNUM ) )
Do While !SCK->( EOF() ) .AND. SCK->CK_NUM == cCJNUM
	aAdd( aEnt, { "SCK", SCK->CK_NUM + SCK->CK_ITEM } )
	SCK->( dbSkip() )
EndDo

MaTrkShow( aEnt )

Return( Nil )






















/*/{Protheus.doc} Method -> UAFocusGER
Verifica os objetos da tela

@author		Eurai Rapelli
@since 		2016.06.27

@Example	oFEFATC01 := FEFATC01():New(); oFEFATC01:UAFocusGER(, 'M->CJ_XPEDIDO' )
/*/
Method UAFocusGER( oCont, cAbaFind, cFindUA ) Class FEFATC01
Local nI		:= 0

Private oObjUA	:= Nil
Private oPai	:= Nil
Private nG		:= 1
Private oCont	:= Nil


Default	oCont		:= Nil
Default cAbaFind	:= '&Customizado'
Default cFindUA		:= ''


If cFindUA <> ''
	
	If oCont == Nil
	
		oPai := GetWndDefault()
	
	Else
	
		oPai := oCont
		
	Endif
		
	For nG := 1 To Len( oPai:aControls )
	
		If Type('oPai:aControls[nG]') <> 'O'
			Loop
		Endif
		
		
		oObjUA	:= oPai:aControls[nG]
		If oObjUA:ClassName() == 'TFOLDER'
		
			For nI := 1 to Len( oObjUA:APROMPTS )
	
				If oObjUA:APROMPTS[nI] == cAbaFind
					//oAba := oObjUA
					//nAba := nI
					oObjUA:SetOption(nI)
					Exit
				Endif
	
			Next nI
	
		Endif	
		
	
		
	Next nG
	
	
	
	For nG := 1 To Len( oPai:aControls )
	
		If Type('oPai:aControls[nG]') <> 'O'
			Loop
		Endif
		
		oObjUA	:= oPai:aControls[nG]
		
		If AllTrim( oObjUA:cReadVar ) == cFindUA
			/*If Type('oAba') == 'O'
				oAba:SetOption(nAba)
				//oAba:NOPTION(nAba)
			Endif*/
			oObjUA:SetFocus()
			Exit
		Endif
		
	Next nG	


Endif

Return( Nil )






/*/{Protheus.doc} WFFinanc
Envia e-mail

@type		method	
@author		Eurai Rapelli
@since 		2016.09.12

@example	oFEFATC01 := FEFATC01():New(); oFEFATC01:WFFinanc( cUsrMail, cTitulo, cMensagem )
/*/
Method WFFinanc( cUsrMail, cTitulo, cMensagem ) Class FEFATC01
Local oProcess		:= Nil
Local oHtml			:= Nil

Local cPasta		:= '\ENVIO_EMAIL\'
Local cEndHtml		:= "\workflow\html\orcamento_financeiro.htm"
Local cCaminho		:= "\workflow\emp"+cEmpAnt+cPasta

Local pCJXVLBRUT	:= PesqPict('SCJ','CJ_XVLBRUT')


Default cUsrMail	:= ''
Default cTitulo		:= ''
Default cMensagem	:= ''




If !File( cEndHtml )
	MsgInfo( 'N�o existe o arquivo: ' + cEndHtml, 'Workflow n�o ser� enviado' )
	Return( Nil )
Endif


SA1->( MsSeek( xFilial('SA1') + SCJ->CJ_CLIENTE + SCJ->CJ_LOJA ) )

oProcess := TWFProcess():New( "MAILWF", "Envio Mensagem" )



oProcess:NewTask( "MAILWF", cEndHtml )
oHtml    := oProcess:oHTML


cTitulo	:= StrTran(cTitulo,"�","a")
cTitulo	:= StrTran(cTitulo,"�","c")
cTitulo	:= StrTran(cTitulo,"�","e")

cMensagem := StrTran( cMensagem, cCRLF, '<br>' )

oProcess:cSubject := cTitulo
oProcess:cTo      := cUsrMail


oHtml:ValByName( "TITULO"		, cTitulo )

oHtml:ValByName( "CJ_NUM"		, SCJ->CJ_NUM )
oHtml:ValByName( "A1_NOME"		, AllTrim(SA1->A1_NOME) + ' (' + SA1->A1_COD + ' - ' + SA1->A1_LOJA + ')' )
oHtml:ValByName( "CJ_EMISSAO"	, Dtoc(SCJ->CJ_EMISSAO) )
oHtml:ValByName( "A1_CONTATO"	, SA1->A1_CONTATO )
oHtml:ValByName( "CJ_XUSER"		, UsrFullName(SCJ->CJ_XUSER) )
oHtml:ValByName( "A1_END"		, SA1->A1_END )
oHtml:ValByName( "CJ_XVLBRUT"	, Transform( SCJ->CJ_XVLBRUT, pCJXVLBRUT ) )
oHtml:ValByName( "A1_BAIRRO"	, SA1->A1_BAIRRO + ' - ' + SA1->A1_MUN + ' - ' + SA1->A1_EST )
oHtml:ValByName( "CJ_CONDPAG"	, SCJ->CJ_CONDPAG )
oHtml:ValByName( "A1_TEL"		, SA1->A1_DDD + ' - ' + SA1->A1_TEL )
oHtml:ValByName( "CJ_XREVISA"	, SCJ->CJ_XREVISA )
oHtml:ValByName( "A1_FAX"		, SA1->A1_DDD + ' - ' + SA1->A1_FAX )

oHtml:ValByName( "MENSAGEM"	, cMensagem )
 
 
oProcess:Start()
oProcess:Finish()



Return( Nil )












/*/{Protheus.doc} CJ_XSTATUS
Aprova

@type		function
@author		Eurai Rapelli
@since 		06/12/2016
/*/
Static Function CJ_XSTATUS()
Local oDlg		:= Nil

Local oBar01  	:= Nil 
Local oBtnBmp01	:= Nil
Local oBtnBmp02	:= Nil


Local oPnlItens	:= Nil


Local oSay01	:= Nil
Local oGet01	:= Nil
Local cGet01	:= SCJ->CJ_XSTATUS

Local oSay02	:= Nil
Local oGet02	:= Nil
Local cGet02	:= SCJ->CJ_SPLAN

Local oSay03	:= Nil
Local oGet03	:= Nil
Local cGet03	:= SCJ->CJ_STATUS


Local nOpca		:= 00


oDlg			:= MSDialog():New( 000,000,160,230,"Mudar Status - ADM",,,.F.,,,,,,.T.,,,.T. )

oPnlItens		:= TPanel():NEW( 000, 000, "", oDlg, , .T., , CLR_BLUE, , 000, 000, .T., .T.)
oPnlItens:Align	:= CONTROL_ALIGN_ALLCLIENT

oSay01 			:= TSay():New( 010,005,{|| "CJ_XSTATUS:" },oPnlItens,,,.F.,.F.,.F.,.T.,,,550,008)
oGet01 			:= TGet():New( 010,070,bSETGET(cGet01),oPnlItens,040,010,,,,/*10*/,,,,.T.,/*15*/,,,,,/*20*/,,)

oSay02 			:= TSay():New( 025,005,{|| "CJ_SPLAN:" },oPnlItens,,,.F.,.F.,.F.,.T.,,,550,008)
oGet02 			:= TGet():New( 025,070,bSETGET(cGet02),oPnlItens,040,010,,,,/*10*/,,,,.T.,/*15*/,,,,,/*20*/,,)

oSay03 			:= TSay():New( 040,005,{|| "CJ_STATUS:" },oPnlItens,,,.F.,.F.,.F.,.T.,,,550,008)
oGet03 			:= TGet():New( 040,070,bSETGET(cGet03),oPnlItens,040,010,,,,/*10*/,,,,.T.,/*15*/,,,,,/*20*/,,)

oBar01			:= TBar():New( oDlg,25,35,.T.,,,'backgroundblack',.T. )
oBtnBmp01 		:= TBtnBmp2():New( 000, 000, 035, 070, 'OK' ,,,,			{|| nOpca := 01, oDlg:End() }, oBar01,'Confirmar',,.F.,.F. )
oBtnBmp02 		:= TBtnBmp2():New( 000, 000, 035, 070, 'CANCEL' ,,,,		{|| nOpca := 00, oDlg:End() }, oBar01,'Cancelar',,.F.,.F. )

oDlg:Activate(,,,.T.) 

If nOpca == 01

	RecLock('SCJ',.F.)
		SCJ->CJ_XSTATUS 	:= cGet01
		SCJ->CJ_SPLAN 		:= cGet02
		SCJ->CJ_STATUS	 	:= cGet03
	SCJ->( MsUnlock() )

Endif


Return( Nil )

/*/{Protheus.doc} DEPURARS
Ativa Depura��o

@type		function
@author		Eurai Rapelli
@since 		2016.12.29
/*/
Static Function DEPURARS()
Local nHdlLock := 0

If !File( cDebug )

	nHdlLock := FCreate(cDebug)
	If nHdlLock > 0
		FClose( nHdlLock )
	Endif
	
	MsgInfo('Ativado Depura��o','FEFATC01')
	
Endif

Return( Nil )

/*/{Protheus.doc} DEPURARN
Desmarca Depura��o

@type		function
@author		Eurai Rapelli
@since 		2016.12.29
/*/
Static Function DEPURARN()

If File( cDebug )
	FErase( cDebug )
	MsgInfo('Desativado Depura��o','FEFATC01')
Endif	

Return( Nil )









/*/{Protheus.doc} EditCelUA
Edita e Salva valores

@type		function	
@author		Eurai Rapelli
@since 		2017.08.30
/*/
Static Function EditCelUA( oBrowse, nCol, aStruct )
Local oDlg		:= Nil
Local oRect		:= Nil
Local oGet		:= Nil
Local oBtn		:= Nil
Local oOwner 	:= oBrowse:oWnd

Local nRow   	:= oBrowse:nAt
Local nLastKey	:= 0
Local nX		:= 0
Local nField	:= 0

Local aItems	:= {'.T.','.F.'}
Local aColumns	:= oBrowse:GetBrwOrder()

Local cCbx		:= '.T.'
Local cValType	:= ''
Local cMacro	:= ''
Local cPict		:= ''
Local cInfo 	:= ''
Local cField	:= ''

Default nCol  := oBrowse:nColPos

If !DbRLock(Recno())
	cInfo += 'Registro travado por outro usu�rio' + cCRLF
	If "TOP" $ RDDNAME()
		cInfo += TCInternal(53)
	Endif
	MsgInfo(cInfo,'FEFATC01')
	Return( Nil )
Endif


cField := aColumns[nCol][1]
//nField := Len(cField)
nField := Ascan(oBrowse:aColumns,{|x| AllTrim(x:cHeading) == cField})
cField := oBrowse:aColumns[nField]:cHeading

oRect	 := tRect():New(0,0,0,0) // obtem as coordenadas da celula (lugar onde
oBrowse:GetCellRect(nCol,,oRect) // a janela de edicao deve ficar)
aDim  	 := {oRect:nTop,oRect:nLeft,oRect:nBottom,oRect:nRight}

cMacro 	 := "M->CELL"+StrZero(nRow,6)
&cMacro	 := FieldGet(FieldPos(cField))

nX		 := aScan( aStruct, { |UA| UA[1] == cField } )
cValType := aStruct[nX,2]
If cValType == "N"
	If aStruct[nX,4] > 0
		cPict := Replicate("9",aStruct[nX,3]-(aStruct[nX,4]+1)) + "." + Replicate("9",aStruct[nX,4])
	Else
		cPict := Replicate("9",aStruct[nX,3])
	EndIf
ElseIf cValType == "D"
	cPict := "@D"
EndIf

If cValType == 'M'
	SetKey( 23,{|| oDlg:End(), nLastKey := 13 } )
	DEFINE MSDIALOG oDlg OF oOwner FROM 000,000 TO 050,400 STYLE nOR( WS_VISIBLE, WS_POPUP ) PIXEL
	oGet := TMultiGet():New(0,0,bSetGet(&(cMacro)),oDlg,399,049,oOwner:oFont,.F.,,,,.T.,,,,,, ,,,,.F.)
	oGet:Move(-2,-2, (aDim[ 4 ] - aDim[ 2 ]) + 4, 062  )
	oGet:cReadVar  := cMacro
Else
	DEFINE MSDIALOG oDlg OF oOwner  FROM 000,000 TO 000,000 STYLE nOR( WS_VISIBLE, WS_POPUP ) PIXEL
	If cValType == 'L'
		cCbx := If(&(cMacro),'.T.','.F.')
		oGet := TComboBox():New( 0, 0, bSetGet(cCbx),aItems, 10, 10, oDlg,,{|| If(cCbx=='.T.',&(cMacro):=.T.,&(cMacro):=.F.), oDlg:End(), nLastKey:=13  },,,,.T., oOwner:oFont)
	 	oGet:Move(-2,-2, (aDim[ 4 ] - aDim[ 2 ]) + 4, aDim[ 3 ] - aDim[ 1 ] + 4 )
	Else
		oGet := TGet():New(0,0,bSetGet(&(cMacro)),oDlg,0,0,cPict,,,,oOwner:oFont,,,.T.,,,,,,,,,,,,,,,.T.)
		oGet:Move(-2,-2, (aDim[ 4 ] - aDim[ 2 ]) + 4, aDim[ 3 ] - aDim[ 1 ] + 4 )
		oGet:cReadVar  := cMacro
	EndIf
EndIf

//@ 0, 0 BUTTON oBtn PROMPT "eu" SIZE 0,0 OF oDlg
oBtn := TButton():New( 000, 000, "EUR"	, oDlg, {||  }, 000, 000, , , .F., .T., .F., , .F., , , .F. )
oBtn:bGotFocus := {|| oDlg:nLastKey := VK_RETURN, oDlg:End() }

If cValType == 'M'
	ACTIVATE MSDIALOG oDlg CENTERED  ON INIT oDlg:Move(aDim[1],aDim[2],aDim[4]-aDim[2], 60)  VALID ( nLastKey := oDlg:nLastKey, .T. )
Else
	ACTIVATE MSDIALOG oDlg ON INIT oDlg:Move(aDim[1],aDim[2],aDim[4]-aDim[2], aDim[3]-aDim[1])  VALID ( nLastKey := oDlg:nLastKey, .T. )
EndIf


SetKey(23,{||})
If nLastKey <> 0
	FieldPut(FieldPos(cField),(&cMacro))
	DbUnlock()
	DbCommit()
	oBrowse:nAt := nRow
	SetFocus(oBrowse:hWnd)
	oBrowse:Refresh()
Else
	DbUnlock()
Endif

Return( Nil )

/*
�����������������������������������������������������������������������������������������������
��� Atualiza Data de Entrega do Cliente CK PROGRAMADOS                                      ���
�����������������������������������������������������������������������������������������������
*/
User Function AtuDatCli()
Local cWPerg := "STDATCLI"
Local aWRegs := {}
Local oFEFATC01 := FEFATC01():New()
Local aLogManu  := {}
Local dData := Date()
Local cHora := Time()
Local dSTDatAnt := CtoD("//")
Local cSTLogZB4 := ""

If SCJ->CJ_XSTATUS == '17'		// INATIVO
	Help( ,, 'HELP',, '[FEFATC01] Apenas a op��o de Reativar CK pode ser usada! ' +SCJ->CJ_NUM+' inativo.', 1, 0)
	Return
Endif

If SCJ->CJ_XPROIME <> 'P'
	MsgStop("ATEN��O. Check-List n�o � PROGRAMADO. N�o � permitida a altera��o da Data Cliente")
	Return
EndIf

If SCJ->CJ_STATUS <> 'B'
	MsgStop("ATEN��O. Check-List ainda n�o virou pedido. N�o � permitida a altera��o da Data Cliente")
	Return
EndIf

AADD(aWRegs,{cWPerg,"01","Nova Data Cliente     ","Nova Data Cliente     ","Nova Data Cliente     ","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aWRegs,{cWPerg,"02","Observacao            ","Observacao            ","Observacao            ","mv_ch2","C",30,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
U_AWCFG005(cWPerg,aWRegs)																				// Processa Arquivo de Perguntas
If !Pergunte(cWPerg, .T.)
	Return
EndIf

If !Msgbox("Confirma Altera��o ?","Data Cliente","YESNO")
	Return Nil
EndIf

ZZX->(DBSEEK(XFILIAL("ZZX")+"ZR    LOGCKZB4  "))
cSTLogZB4 := Alltrim(ZZX->ZZX_DESCRI)

SCK->(DBSeek(SCJ->CJ_FILIAL+SCJ->CJ_NUM))
While SCK->CK_FILIAL=SCJ->CJ_FILIAL .and. SCK->CK_NUM=SCJ->CJ_NUM .and. !SCK->(Eof())
	If SCK->CK_XITFAT <> 'S'
		SCK->(DBSkip())
		Loop
	EndIf

	dSTDatAnt := SCK->CK_DTCLI 
	While !RecLock("SCK",.f.);end
	SCK->CK_DTCLI  := mv_par01
	SCK->(MSUnlock())

	// Gerar Log no Arquivo de Rastreabilidade de CK
	If cSTLogZB4 == "S"
		aLogManu := Array(19)
		aLogManu[01]:= SCK->CK_NUM
		aLogManu[02]:= SCJ->CJ_XREVISA
		aLogManu[03]:=�SCK->CK_ITEM
		aLogManu[04]:= dData
		aLogManu[05]:= cHora
		aLogManu[06]:= 'CK_DTCLI'
		aLogManu[07]:= mv_par02
		aLogManu[08]:= dSTDatAnt
		aLogManu[09]:= SCK->CK_DTCLI
		aLogManu[10]:= SCJ->CJ_XTIPCK
		aLogManu[11]:= 'ACK'
		aLogManu[12]:= 'ATUDATCL'
		aLogManu[13]:= 'ALT.DATA CLIENTE CK PROGRAMADO'
		aLogManu[14]:= ''
		aLogManu[15]:= '001'
		oFEFATC01:GrvLogManu( aLogManu )
	EndIf
	SCK->(DBSkip())

End

Msgbox("Data Cliente alterada com sucesso!","ALERT")

Return Nil

/*
�����������������������������������������������������������������������������������������������
��� Atualiza Data de Embarque e Saida                                                       ���
�����������������������������������������������������������������������������������������������
*/
User Function AtuDatEmb()
Local cWPerg := "STDATEMB"
Local aWRegs := {}
Local oFEFATC01 := FEFATC01():New()
Local aLogManu  := {}
Local dData := Date()
Local cHora := Time()
Local dSTDatAnt := CtoD("//")
Local cSTLogZB4 := ""

If SCJ->CJ_XSTATUS == '17'		// INATIVO
	Help( ,, 'HELP',, '[FEFATC01] Apenas a op��o de Reativar CK pode ser usada! ' +SCJ->CJ_NUM+' inativo.', 1, 0)
	Return Nil
Endif

AADD(aWRegs,{cWPerg,"01","Nova Dt Embarque/Saida","Nova Dt Embarque/Saida","Nova Dt Embarque/Saida","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aWRegs,{cWPerg,"02","Observacao            ","Observacao            ","Observacao            ","mv_ch2","C",30,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
U_AWCFG005(cWPerg,aWRegs)																				// Processa Arquivo de Perguntas
If !Pergunte(cWPerg, .T.)
	Return
EndIf

If !Msgbox("Confirma Altera��o ?","Data Embarque/Saida","YESNO")
	Return Nil
EndIf

SCK->(DBSeek(SCJ->CJ_FILIAL+SCJ->CJ_NUM))
While SCK->CK_FILIAL=SCJ->CJ_FILIAL .and. SCK->CK_NUM=SCJ->CJ_NUM .and. !SCK->(Eof())
	If SCK->CK_XITFAT <> 'S'
		SCK->(DBSkip())
		Loop
	EndIf
	If SCK->CK_ENTREG > mv_par01
		Help( ,, 'HELP',, 'Data de Prev. de Embarque/Saida deve ser menor ou igual Data de Entrega ' +SCK->CK_NUM+'/'+SCK->CK_ITEM, 1, 0)
		Return Nil
	EndIf
	SCK->(DBSkip())
End

ZZX->(DBSEEK(XFILIAL("ZZX")+"ZR    LOGCKZB4  "))
cSTLogZB4 := Alltrim(ZZX->ZZX_DESCRI)

SCK->(DBSeek(SCJ->CJ_FILIAL+SCJ->CJ_NUM))
While SCK->CK_FILIAL=SCJ->CJ_FILIAL .and. SCK->CK_NUM=SCJ->CJ_NUM .and. !SCK->(Eof())
	If SCK->CK_XITFAT <> 'S'
		SCK->(DBSkip())
		Loop
	EndIf

	dSTDTPREM := SCK->CK_XDTPREM
	dSTXDTSAID:= SCK->CK_XDTSAID

	While !RecLock("SCK",.f.);end
	SCK->CK_XDTPREM := mv_par01
	SCK->CK_XDTSAID := mv_par01
	SCK->(MSUnlock())

	// Gerar Log no Arquivo de Rastreabilidade de CK
	If cSTLogZB4 == "S"
		aLogManu := Array(19)
		aLogManu[01]:= SCK->CK_NUM
		aLogManu[02]:= SCJ->CJ_XREVISA
		aLogManu[03]:=�SCK->CK_ITEM
		aLogManu[04]:= dData
		aLogManu[05]:= cHora
		aLogManu[06]:= 'CK_DTCLI'
		aLogManu[07]:= mv_par02
		aLogManu[08]:= dSTDTPREM
		aLogManu[09]:= SCK->CK_XDTPREM
		aLogManu[10]:= SCJ->CJ_XTIPCK
		aLogManu[11]:= 'ACK'
		aLogManu[12]:= 'ATUDTPRE'
		aLogManu[13]:= 'ALT.DATA PREVISTA DE EMBARQUE '
		aLogManu[14]:= ''
		aLogManu[15]:= '001'
		oFEFATC01:GrvLogManu( aLogManu )

		aLogManu := Array(19)
		aLogManu[01]:= SCK->CK_NUM
		aLogManu[02]:= SCJ->CJ_XREVISA
		aLogManu[03]:=�SCK->CK_ITEM
		aLogManu[04]:= dData
		aLogManu[05]:= cHora
		aLogManu[06]:= 'CK_DTCLI'
		aLogManu[07]:= mv_par02
		aLogManu[08]:= dSTXDTSAID
		aLogManu[09]:= SCK->CK_XDTSAID
		aLogManu[10]:= SCJ->CJ_XTIPCK
		aLogManu[11]:= 'ACK'
		aLogManu[12]:= 'ATUDTSAI'
		aLogManu[13]:= 'ALT.DATA DE SAIDA             '
		aLogManu[14]:= ''
		aLogManu[15]:= '001'
		oFEFATC01:GrvLogManu( aLogManu )

	EndIf
	SCK->(DBSkip())
End

Msgbox("Data alterada com sucesso!","ALERT")

Return Nil