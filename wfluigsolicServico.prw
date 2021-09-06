#INCLUDE "TOTVS.CH"
#INCLUDE "RESTFUL.CH"
#INCLUDE "FILEIO.CH"
//#INCLUDE "AARRAY.CH"
//#INCLUDE "JSON.CH"

/**************************************************************************************************
* WEBSEVICE......: wfluigsolicServico
* OBJETIVO.......: WebService para Incluir, Alterar e Excluir Solicitações de Serviço realizadas pelo Fluig
* AUTOR..........: Samara
* DATA...........: 19/10/2018
* ALTERAÇÃO......:
**************************************************************************************************/

WSRESTFUL F_SOLICSERVICO DESCRIPTION "Urbano AgroIndustria - Solicitação de Serviço (REST)"

WSDATA unidade 	 AS STRING

WSMETHOD GET DESCRIPTION "Solicitação de Serviço" WSSYNTAX "/F_SOLICSERVICO"
WSMETHOD POST DESCRIPTION "Solicitação de Serviço" WSSYNTAX "/F_SOLICSERVICO"

END WSRESTFUL

WSMETHOD GET WSRECEIVE unidade WSSERVICE F_SOLICSERVICO
	
	Local cUnidade 		:= ''
	Local _cAlias  		:= GetNextAlias()	
	
	// define o tipo de retorno do método
	::SetContentType("application/json")
	
	cUnidade := ::unidade
	
	BeginSql Alias _cAlias
		select tqb.tqb_filial, tqb.tqb_solici, tqb.tqb_codbem, tqb.tqb_dtaber, tqb.tqb_hoaber, tqb.tqb_cdsoli
		from %table:TQB% tqb
		where tqb.%notDel%
		  and tqb.tqb_filial = %exp:cUnidade%
	EndSql
	
	nCont	:= 0
	
	conout("**********************GET DAS SOLICITACOES DE SERVICO")
	
	While (_cAlias)->(!Eof())

		if nCont > 0
			::SetResponse(',')
		endif
	
		::SetResponse( '{' +;
					   '"filial":"'   		+ (_cAlias)->tqb_filial + '",' +;
					   '"codsolicitacao":"' + (_cAlias)->tqb_solici + '",' +;
					   '"codbem":"'   		+ (_cAlias)->tqb_codbem + '",' +;
					   '"dataabert":"'    	+ (_cAlias)->tqb_dtaber + '",' +;
					   '"horaabert":"' 		+ (_cAlias)->tqb_hoaber + '",' +;
					   '"codsolicitante":"' + (_cAlias)->tqb_cdsoli + '"'  +;
					   '}' )
		nCont++				
		(_cAlias)->(DbSkip())
	EndDo
	
	conout("**********************F I M")
	
	(_cAlias)->(dbCloseArea())

Return .T.

WSMETHOD POST WSSERVICE F_SOLICSERVICO
	
	Local oJson		:= ''	
	Local cJSONRet	:= ''
	Local lPost 		:= .T.
	Local aDadosSS 	:= {} //Array para ExecAuto do MNTA280
	Local cErro 	:= ''
	
	Private cFilAux 	:= cFilAnt
	Private cAcao		:= ''
	Private cFilSS	 	:= ''
	Private cCodBem 	:= ''
	Private cDataAbert 	:= ''
	Private cHoraAbert 	:= ''
	Private cRamal		:= ''
	Private cServico	:= ''	
	
	Private cFluigRet := "1"
	Private cFluigMsg := '""'
	Private lMsHelpAuto    := .T.
	Private lAutoErrNoFile := .T.
	Private lMsErroAuto    := .F.
	
	// define o tipo de retorno do método
	::SetContentType("application/json")
	
	conout("**********************NOVA SOLICIACAO DE SERVICO******************* Data: ", date(), " Hora: ", time())
	conout("**********************", ::GetContent())
	
	//recupa o body da requisição
	oJson := FromJson(::GetContent())	
	conout("**********************oJson", oJson)
	
	//ACAO vem como: I - Inclusao, A - Alteracao
	//cAcao		:= oJson[#'acao']
	cFilSS		:= oJson[#'filial']
	cCodBem		:= oJson[#'codigobem']
	cDataAbert 	:= oJson[#'dataabert']
	cHoraAbert 	:= oJson[#'horaabert']
	cRamal		:= oJson[#'ramalss']
	cServico   	:= oJson[#'servico']
	cCodSolic	:= oJson[#'codsolic']
	cEmaSolic	:= oJson[#'emasolic']
	
	conout("*************FILIAL************", cFilSS)
	
	//Descobrir o código do usuário através do e-mail do Fluig
	cEmail = cEmaSolic
	PswOrder(4)
	PswSeek(AllTrim(cEmail)) 
	cCod  = PswRet()[1][1] 
	cUser = PswRet()[1][2] 
	
	aDadosSS := {{"TQB_FILIAL", cFilSS				,Nil},;	
				 {"TQB_CODBEM", cCodBem    			,Nil},;
				 {"TQB_CDSOLI", cCod	    		,Nil},; 
				 {"TQB_NMSOLI", cUser	    		,Nil},;
				 {"TQB_DTABER", STOD(cDataAbert) 	,Nil},;
				 {"TQB_HOABER", cHoraAbert			,Nil},;
				 {"TQB_DESCSS", cServico   			,Nil},;
				 {"TQB_RAMAL" , cRamal    			,Nil},; 
				 {"TQB_CODUSE", cCodSolic   		,Nil},;
				 {"TQB_EMUSER", cEmaSolic   		,Nil},;			 
				 {"TQB_ORIGEM", "FLUIG"				,Nil}}
	
	
	cFilAnt := cFilSS
	
	conout("*************aDadosSS************", aDadosSS)
	
	//MSExecAuto( {|x,z,y,w| MNTA280(x,z,y,w)}, , , aDadosSS )
	
	cFilAnt := cFilAux
	
	If lMsErroAuto
	
		conout("*****2 erro ao incluir solicitacao de servico*****")	
		
		SetFluigErro(MontaErro(GetAutoGrLog()))
		
	Else 		
	
		conout("*****1 solicitacao de servico incluida com sucesso*****")
					
		cFluigMsg := '"Solicitacao de Servico incluida com sucesso."'	

	EndIf
	
	//Retorno
	::SetResponse('{')

	::SetResponse('"codret":' + cFluigRet) // 1 - certo, 2 - erro
	::SetResponse(',"msgret":' + cFluigMsg) //"json recebido com sucesso - AMBIENTE DE TESTE"
	::SetResponse('}')
	
	conout("retorno: " + cFluigRet)
	conout("mensagem: " + cFluigMsg)
	
Return lPost

Static Function MontaErro(aErro)

	Local nI
	Local cMsg := ""	

	For nI := 1 To Len(aErro)

		cMsg += aErro[nI] + CRLF

	Next
	
	conout(cMsg)
	
Return cMsg

Static Function SetFluigErro(cMsg)
	
	Default cMsg := ""
	
	cFluigRet := "2"
	cFluigMsg := '"' + cMsg + '"'
	
Return