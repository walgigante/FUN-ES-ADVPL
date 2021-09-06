// BIBLIOTECAS NECESSÁRIAS
#Include "TOTVS.ch"

// FUNÇÃO PRINCIPAL
User Function RDGPESOC(cType, nOper, aData)
	Local aSoapMsg := {} // RETORNO DA REQUISIÇÃO

    // CONSTRUTOR PADRÃO DA ASSINATURA DA FUNÇÃO
	Default cType := "CC" // CENTRO DE CUSTO
	Default nOper := 04   // OPERAÇÃO (ALTERAÇÃO)
	Default aData := {}   // DADOS A SEREM ATUALIZADOS

	RPCSetEnv("99", "01") // PREPARAÇÃO DE AMBIENTE
        // INSERE A DATA E A HORA DA ALTERAÇÃO
        If (!Empty(cType) .And. cType == "CC")
            AAdd(aData, "6600")
            AAdd(aData, "ADMINISTRATIVO Alterado (" + DToC(dDataBase)+ " às " + Time() + ")")

            // GERA REQUISIÇÃO SOAP PARA INTEGRAÇÃO
            aSoapMsg := SendRequest(cType, nOper, aData)
        EndIf
    RPCClearEnv() // ENCERRAMENTO DO AMBIENTE
Return (NIL)

// PREPARA E ENVIO O *.XML PARA CONSUMO
Static Function SendRequest(cType, nOper, aData)
    Local oWsdl    := TWsdlManager():New()                           // CLIENT PARA CONSUMO DO SERVIÇO
    Local cURI     := "https://www.p-soc.com.br/WSSoc/CentroCustoWs" // ENDEREÇO DO RECURSO
    Local cPasswd  := "24b2b95d29fc50f"                              // SENHA PARA CONSUMO DO SERVIÇO
    Local cUserId  := "522908"                                       // CÓDIGO IDENTIFICADOR DO USUÁRIO
    Local cSoapMsg := ""                                             // *.XML A SER ENVIADO
    Local aRequest := {}                                             // VETOR DE RETORNO DA REQUISIÇÃO

    // DEFINIÇÃO DAS PROPRIEDADS DO CLIENT
    oWsdl:cSSLCACertFile := "\certificate\www.soc.com.br-2019.pem" // CAMINHO DO CERTIFICADO CA
    oWsdl:lSSLInsecure   := .T.                                    // CONEXÃO ANÔNIMA SEM CERTIFICADOS
    oWsdl:lVerbose	     := .T.                                    // GERA .LOG DOS PROCESSOS
    oWsdl:nTimeout       := 120                                    // TEMPO MÁXIMO PARA RESPOSTA

    // REALIZA A CONVERSÃO DO *.WSDL
    If (!oWsdl:ParseURL(cURI + "?wsdl"))
  	    ConOut("Couldn't parse URI: " + oWsdl:cError)
    EndIf

    // DEFINE A OPERAÇÃO
    If (!oWsdl:SetOperation("alterarCentroCusto"))
        ConOut("Couldn't select operation: " + oWsdl:cError)
    EndIf

    // ADICIONA OS XMLNS
    cSoapMsg += '<?xml version="1.0" encoding="UTF-8" standalone="no"?>'        + CRLF
    cSoapMsg += '<SOAP-ENV:Envelope'                                            + CRLF
    cSoapMsg += '    xmlns:SOAP-ENV="http://www.w3.org/2003/05/soap-envelope"'  + CRLF
    // cSoapMsg += '    xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope"' + CRLF
    cSoapMsg += '    xmlns:xsd="http://www.w3.org/2001/XMLSchema"'              + CRLF
    cSoapMsg += '    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"'     + CRLF
    cSoapMsg += '    xmlns:ser="http://services.soc.age.com/">'                 + CRLF

    // MONTA O CABEÇALHO DO WSSECURITY
    cSoapMsg += NewHeader()

    // MONTA O CORPO DA REQUISIÇÃO
    cSoapMsg += NewBody(cType, aData)
    cSoapMsg += '</SOAP-ENV:Envelope>'

    // COPIA A MENSAGEM PARA A ÁREA DE TRANSFÊNCIA
    // UTILIZE PARA COPIAR PARA O SOAPUI
    CopyToClipBoard(cSoapMsg)

    // REALIZA O ENVIO DO *.XML
    If (!oWsdl:SendSoapMsg(cSoapMsg))
        ConOut("Couldn't send SOAP Message: " + oWsdl:cError)
        ConOut("Fault Code: " + oWsdl:cFaultCode)
    EndIf

    // EXIBE A MENSAGEM DE RETORNO
    ConOut(oWsdl:GetSoapResponse())

    // MONTA O VETOR DE RETORNO
    AAdd(aRequest, oWsdl:cError)
    AAdd(aRequest, oWsdl:cFaultCode)
    AAdd(aRequest, oWsdl:GetSoapResponse())
Return (aRequest)

// MONTA O CABEÇALHO DO WSSECURITY
Static Function NewHeader()
	Local cData		  := ""
	Local cHora		  := ""
	Local cString	  := ""
	Local cIDEmpPrinc := GetNewPar("RD_SOCEMS", "541095")			// Formato: 541095
	Local cIDEmpresa  := GetNewPar("RD_SOCEMP", "552486")			// Formato: 552486
	Local cUserId 	  := GetNewPar("RD_SOCUSR", "522908")  			// Formato: 522908
	Local cPasswd	  := GetNewPar("RD_SOCPSW", "24b2b95d29fc50f")	// Formato: kHqc6S10Iz3Wtyp3Mca4ovuA/8Y=     DOC: Password_Digest = Base64 ( SHA-1 ( nonce + created + password ) ).
	Local cNonce	  := ""  										// Formato: S4GG4acXUt3KnLRMd9Ah5Q==
	Local cTimeStamp  := ""											// Formato: 2018-11-20T09:45:00.933Z
	Local cTimeExpire := ""											// Formato: 2018-11-20T09:45:00.933Z
	Local cTimeCreate := ""											// Formato: 2018-11-20T09:45:00.933Z
	Local cTimeToken  := ""											// Formato: 85E9F7BD24A68534C8154264516093324 UUID
	Local cUserToken  := ""											// Formato: 85E9F7BD24A68534C8154264515769523 UUID

	cData:= DTOS(Date())
	cData:= SubStr(cData,1,4)+"-"+SubStr(cData,5,2)+"-"+SubStr(cData,7,2)

	// Determina o Created do XML
	aUTCTime	:= LocalToUTC( DTOS(dDataBase), Time(), 1 )
	cHora		:= Alltrim(TimeFull())
	cHora		:= aUTCTime[2]+SubStr(cHora,9) // Utiliza a hora UTC
	cTimeCreate := cData+"T"+cHora+"Z" // FWTimeStamp(5)

	// Determina o TimeStamp
	aUTCTime	:= LocalToUTC( DTOS(dDataBase), Time(), 1 )
	cHora		:= Alltrim(TimeFull())
	cHora		:= aUTCTime[2]+SubStr(cHora,9) // Utiliza a hora UTC

	// Tempo maximo da mensagem de 1 minuto
	cTimeStamp	:= cData+"T"+cHora+"Z" // FWTimeStamp(5)
	cTimeExpire := cData+"T"+PADR(Replace(Alltrim(Str(SomaHoras(SubStr(cHora,1,6),"00:01:00"))),".",":"),5,"0")+SubStr(cHora,6,7)+"Z" // FWTimeStamp(5)

	// nonce = base64 ( sha1 ( created + random ) )
	cNonce		:= cTimeCreate+StrZero(Randomize(1,9999),4)
	cNonce		:= SHA1(cNonce,1)
	cNonce		:= Encode64(cNonce)

	// password_digest = Encode64(SHA1(cNonce + cTimeStamp + cPasswd, 1))
	cPasswd 	:= (Decode64(cNonce) + cTimeCreate + cPasswd)
	cPasswd   := SHA1( cPasswd , 1 )
	cPasswd   := Encode64(cPasswd)

	cTimeToken  := UPPER(Replace(FWUUID(cTimeCreate+StrZero(Randomize(1,9999),4)),"-",""))  // UPPER(FWUUID(cTimeStamp))
	cUserToken	:= UPPER(Replace(FWUUID(cUserId+StrZero(Randomize(1,9999),4)),"-",""))  // UPPER(FWUUID(cUserId))

	cString+= '    <SOAP-ENV:Header> '+CRLF
	cString+= '       <wsse:Security SOAP-ENV:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd">'+CRLF
	cString+= '          <wsu:Timestamp wsu:Id="TS-'+cTimeToken+'">'+CRLF
	cString+= '             <wsu:Created>'+cTimeStamp+'</wsu:Created>'+CRLF
	cString+= '             <wsu:Expires>'+cTimeExpire+'</wsu:Expires>'+CRLF
	cString+= '          </wsu:Timestamp>'+CRLF
	cString+= '          <wsse:UsernameToken wsu:Id="UsernameToken-'+cUserToken+'">'+CRLF
	cString+= '             <wsse:Username>'+cIDEmpresa+'</wsse:Username>'+CRLF
	cString+= '             <wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordDigest">'+cPasswd+'</wsse:Password>'+CRLF
	cString+= '             <wsse:Nonce EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary">'+cNonce+'</wsse:Nonce>'+CRLF
	cString+= '             <wsu:Created>'+cTimeCreate+'</wsu:Created>'+CRLF
	cString+= '          </wsse:UsernameToken>'+CRLF
	cString+= '       </wsse:Security>'+CRLF
	cString+= '    </SOAP-ENV:Header>'+CRLF
Return (cString)

// MONTA O CORPO DA REQUISIÇÃO
Static Function NewBody(cType, aData)
	Local cString	  := ""
	Local cIDEmpPrinc := GetNewPar("RD_SOCEMS", "541095")			// Formato: 541095
	Local cIDEmpresa  := GetNewPar("RD_SOCEMP", "552486")			// Formato: 552486
	Local cUserId 	  := GetNewPar("RD_SOCUSR", "522908")  			// Formato: 522908
	Local cPasswd	  := GetNewPar("RD_SOCPSW", "24b2b95d29fc50f")	// Formato: DOC: Password_Digest = Base64 ( SHA-1 ( nonce + created + password ) ).
	Local cIDResp 	  := GetNewPar("RD_SOCRSP", "302895")  			// Formato: 302895

	Do Case
		Case cType == "CC"
			cString+= '    <SOAP-ENV:Body>'+CRLF
			cString+= '       <ser:alterarCentroCusto>'+CRLF
			cString+= '          <AlterarCentroCustoWsVo>'+CRLF
			cString+= '             <identificacaoWsVo>'+CRLF
			cString+= '                <codigoEmpresaPrincipal>'+cIDEmpPrinc+'</codigoEmpresaPrincipal>'+CRLF
			cString+= '                <codigoResponsavel>'+cIDResp+'</codigoResponsavel>'+CRLF
			cString+= '                <codigoUsuario>'+cUserId+'</codigoUsuario>'+CRLF
			cString+= '             </identificacaoWsVo>'+CRLF
			cString+= '             <dadosCentroCustoWsVo>'+CRLF
			cString+= '                <codigo>'+aData[1]+'</codigo>'+CRLF
			cString+= '                <nome>'+aData[2]+'</nome>'+CRLF
			cString+= '             </dadosCentroCustoWsVo>'+CRLF
			cString+= '             <codigoEmpresa>'+cIDEmpresa+'</codigoEmpresa>'+CRLF
			cString+= '             <tipoBuscaEmpresa>CODIGO_SOC</tipoBuscaEmpresa>'+CRLF
			cString+= '             <codigoCusto>'+aData[1]+'</codigoCusto>'+CRLF
			cString+= '             <tipoBuscaCentroCusto>CODIGO_SOC</tipoBuscaCentroCusto>'+CRLF
			cString+= '          </AlterarCentroCustoWsVo>'+CRLF
			cString+= '       </ser:alterarCentroCusto>'+CRLF
			cString+= '    </SOAP-ENV:Body>'+CRLF
	EndCase
Return (cString)
