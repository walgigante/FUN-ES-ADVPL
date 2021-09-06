// BIBLIOTECAS NECESSÁRIAS
#Include "TOTVS.ch"

// BARRA DE SEPARAÇÃO DE DIRETÓRIOS
#Define BAR IIf(IsSrvUnix(), "/", "\")

//------------------------------------------------------
// ENVIA JSON CRIPTOGRAFADO PARA O BANCO BRADESCO
//------------------------------------------------------
User Function T288APCK7()
    Local cCert    := BAR + "certificate" + BAR + "myCorp_cert.pem"
    Local cKey     := BAR + "certificate" + BAR + "myCorp_key.pem"
    Local cJson    := GetJsonStruct()
    Local cOption  := "-nodetach"
    Local cError   := Space(0)
    Local cPasswd  := "MyPasswordHere"
    Local cRet     := SMIMESign(cCert, cKey, cJson, cOption, @cError, cPasswd)
    Local cURL     := "https://cobranca.bradesconetempresa.b.br/ibpjregistrotitulows/registrotitulo"
    Local nTimeOut := 180
    Local aHeadOut := {}
    Local cHeadRet := Space(0)
    Local cResp    := HTTPSPost(cURL, cCert, cKey, cPasswd, Space(0), cRet, nTimeOut, aHeadOut, @cHeadRet)
Return (NIL)

//------------------------------------------------------
// ENVIA JSON CRIPTOGRAFADO PARA O BANCO BRADESCO
//------------------------------------------------------
User Function T288BPCK7()
    Local aCert    As Array     // CERTIFICADOS
    Local aHeadOut As Array     // CABEÇALHO DE ENVIO
    Local cSign    As Character // JSON ASSINADO
    Local cURL     As Character // URL DA REQUISIÇÃO
    Local cResp    As Character // RESPOSTA DA REQUISIÇÃO
    Local cHeadRet As Character // CABEÇALHO DE RETORNO
    Local cPasswd  As Character // SENHA DO CERTIFICADO
    Local nTimeOut As Numeric   // TEMPO DE REQUISIÇÃO

    // INICIALIZAÇÃO DE VARIÁVEIS
    aHeadOut := {}
    cPasswd  := "MyPasswordHere"
    cHeadRet := Space(0)
    nTimeOut := 180
    cURL     := "https://cobranca.bradesconetempresa.b.br/ibpjregistrotitulows/registrotitulo"
    aCert    := GetCertificate(BAR + "certificate", "myCorp", cPasswd)
    cSign    := SignJson(aCert, cPasswd)

    // ENVIO DA REQUISIÇÃO
    cResp := HTTPSPost(cURL,;
                       aCert[AScan(aCert, {|aCert|aCert[1] == "CERT"})][2],;
                       aCert[AScan(aCert, {|aCert|aCert[1] == "KEY"})][2],;
                       cPasswd,;
                       Space(0),;
                       cSign,;
                       nTimeOut,;
                       aHeadOut,;
                       @cHeadRet)

    // VALIDAÇÃO DE ERROS
    If (Empty(cResp))
        ConOut("@SP.ADVPL: Error!")
    Else
        ConOut("@SP.ADVPL: Success!")
        ConOut(cResp)
    EndIf
Return (NIL)

//------------------------------------------------------
// ASSINA O JSON COM OS CERTIFICADOS
//------------------------------------------------------
Static Function SignJson(aCert As Array, cPass As Character)
    Local cError As Character // VALIDAÇÃO DE ERROS
    Local cSign  As Character // JSON ASSINADO
    Local cJson  As Character // JSON A SER ASSINADO

    // INICIALIZAÇÃO DE VARIÁVEIS
    cError := Space(0)
    cSign  := Space(0)
    cJson  := GetJsonStruct()

    // ASSINA O JSON
    cSign := SMIMESign(aCert[AScan(aCert, {|aCert|aCert[1] == "CERT"})][2],; // CHAVE PÚBLICA
                    aCert[AScan(aCert, {|aCert|aCert[1] == "KEY"})][2],;     // CHAVE PRIVADA
                    GetJsonStruct(),;                                        // JSON PARA SER ASSINADO
                    "-nodetach",;                                            // ENVIO S/ ANEXO
                    @cError,;                                                // VALIDAÇÃO DE ERROS
                    cPass)

    // SERIALIZA O JSON ASSINADO
    cSign := FwCutOff(cSign, .T.)

    // REMOVE O CABEÇALHO E RODAPÉ
    cSign := SubStr(cSign, 22, Len(cSign) - 40)
Return (cSign)

//------------------------------------------------------
// MONTAGEM DO JSON DE ENVIO
//------------------------------------------------------
Static Function GetJsonStruct()
    Local oJson As Object // OBJETO JSON

    // INICIALIZAÇÃO DE VARIÁVEL
    oJson := JsonObject():New()

    // MONTAGEM DO JSON
    oJson["nuCPFCNPJ"]                            := "20940512000145"
    oJson["filialCPFCNPJ"]                        := "0001"
    oJson["ctrlCPFCNPJ"]                          := "45"
    oJson["cdTipoAcesso"]                         := "2"
    oJson["clubBanco"]                            := "2269651"
    oJson["cdTipoContrato"]                       := "48"
    oJson["nuSequenciaContrato"]                  := "0"
    oJson["idProduto"]                            := "09"
    oJson["nuNegociacao"]                         := "123400000001234567"
    oJson["cdBanco"]                              := "237"
    oJson["eNuSequenciaContrato"]                 := "0"
    oJson["tpRegistro"]                           := "1"
    oJson["cdProduto"]                            := "0"
    oJson["nuTitulo"]                             := "0"
    oJson["nuCliente"]                            := "123456"
    oJson["dtEmissaoTitulo"]                      := "25.07.2019"
    oJson["dtVencimentoTitulo"]                   := "20.08.2019"
    oJson["tpVencimento"]                         := "0"
    oJson["vlNominalTitulo"]                      := "100"
    oJson["cdEspecieTitulo"]                      := "04"
    oJson["tpProtestoAutomaticoNegativacao"]      := "0"
    oJson["prazoProtestoAutomaticoNegativacao"]   := "0"
    oJson["controleParticipante"]                 := Space(0)
    oJson["cdPagamentoParcial"]                   := Space(0)
    oJson["qtdePagamentoParcial"]                 := "0"
    oJson["percentualJuros"]                      := "0"
    oJson["vlJuros"]                              := "0"
    oJson["qtdeDiasJuros"]                        := "0"
    oJson["percentualMulta"]                      := "0"
    oJson["vlMulta"]                              := "0"
    oJson["qtdeDiasMulta"]                        := "0"
    oJson["percentualDesconto1"]                  := "0"
    oJson["vlDesconto1"]                          := "0"
    oJson["dataLimiteDesconto1"]                  := Space(0)
    oJson["percentualDesconto2"]                  := "0"
    oJson["vlDesconto2"]                          := "0"
    oJson["dataLimiteDesconto2"]                  := Space(0)
    oJson["percentualDesconto3"]                  := "0"
    oJson["vlDesconto3"]                          := "0"
    oJson["dataLimiteDesconto3"]                  := Space(0)
    oJson["prazoBonificacao"]                     := "0"
    oJson["percentualBonificacao"]                := "0"
    oJson["vlBonificacao"]                        := "0"
    oJson["dtLimiteBonificacao"]                  := Space(0)
    oJson["vlAbatimento"]                         := "0"
    oJson["vlIOF"]                                := "0"
    oJson["nomePagador"]                          := "CMDA Digital Canvas"
    oJson["logradouroPagador"]                    := "Avenida Eulalio Costa"
    oJson["nuLogradouroPagador"]                  := "90"
    oJson["complementoLogradouroPagador"]         := Space(0)
    oJson["cepPagador"]                           := "12345"
    oJson["complementoCepPagador"]                := "500"
    oJson["bairroPagador"]                        := "Jardim da Boa Viagem"
    oJson["municipioPagador"]                     := "Vila Formosa"
    oJson["ufPagador"]                            := "SP"
    oJson["cdIndCpfcnpjPagador"]                  := "1"
    oJson["nuCpfcnpjPagador"]                     := "12345648901234"
    oJson["endEletronicoPagador"]                 := Space(0)
    oJson["nomeSacadorAvalista"]                  := Space(0)
    oJson["logradouroSacadorAvalista"]            := Space(0)
    oJson["nuLogradouroSacadorAvalista"]          := "0"
    oJson["complementoLogradouroSacadorAvalista"] := Space(0)
    oJson["cepSacadorAvalista"]                   := "0"
    oJson["complementoCepSacadorAvalista"]        := "0"
    oJson["bairroSacadorAvalista"]                := Space(0)
    oJson["municipioSacadorAvalista"]             := Space(0)
    oJson["ufSacadorAvalista"]                    := Space(0)
    oJson["cdIndCpfcnpjSacadorAvalista"]          := "0"
    oJson["nuCpfcnpjSacadorAvalista"]             := "0"
    oJson["endEletronicoSacadorAvalista"]         := Space(0)
Return (oJson:ToJson())

//------------------------------------------------------
// RETORNA O CAMINHO PARA OS CERTIFICADOS
//------------------------------------------------------
Static Function GetCertificate(cCertPath As Character, cFileName As Character, cPassword As Character)
    Local aCert     As Array      // VETOR DE CERTIFICADOS
    Local cFullPath As Character  // CAMINHO RELATIVO COMPLETO
    Local cError    As Character  // ERROS DE GERAÇÃO DE CERTIFICADO
    Local lFind     As Logical    // VALIDADOR DE EXTRAÇÃO DE CERTIFICADO

    // INICIALIZAÇÃO DE VARIÁVEIS
    lFind     := .F.
    aCert     := {}
    cCertPath := cCertPath + BAR
    cFullPath := Space(0)
    cError    := Space(0)

    // PROPRIEDADES PARA ARQUIVO *.CA
    cError    := Space(0)
    cFullPath := cCertPath + cFileName + "_ca.pem"
    lFind     := File(cFullPath)

    // VERIFICA SE O ARQUIVO JÁ EXISTE,
    // CASO NÃO EFETUA A CRIAÇÃO
    If (!lFind)
        If (!PFXCA2PEM(cCertPath + cFileName + ".pfx", cFullPath, @cError, cPassword))
            ConOut(PadC("ERROR: Couldn't extract *_CA certificate", 80))
        EndIf
    EndIf

    // ADICIONA O CAMINHO NO RETORNO
    AAdd(aCert, {"CA", cFullPath, lFind})

    // PROPRIEDADES PARA ARQUIVO *.KEY
    cError    := Space(0)
    cFullPath := cCertPath + cFileName + "_key.pem"
    lFind     := File(cFullPath)

    // VERIFICA SE O ARQUIVO JÁ EXISTE,
    // CASO NÃO EFETUA A CRIAÇÃO
    If (!lFind)
        If (!PFXKey2PEM(cCertPath + cFileName + ".pfx", cFullPath, @cError, cPassword))
            ConOut(PadC("ERROR: Couldn't extract *_KEY certificate", 80))
        EndIf
    EndIf

    // ADICIONA O CAMINHO NO RETORNO
    AAdd(aCert, {"KEY", cFullPath, lFind})

    // PROPRIEDADES PARA ARQUIVO *.CERT
    cError    := Space(0)
    cFullPath := cCertPath + cFileName + "_cert.pem"
    lFind     := File(cFullPath)

    // VERIFICA SE O ARQUIVO *.CERT JÁ EXISTE,
    // CASO NÃO EFETUA A CRIAÇÃO
    If (!lFind)
        If (!PFXCert2PEM(cCertPath + cFileName + ".pfx", cFullPath, @cError, cPassword))
            ConOut(PadC("ERROR: Couldn't extract *_CERT certificate", 80))
        EndIf
    EndIf

    // ADICIONA O CAMINHO NO RETORNO
    AAdd(aCert, {"CERT", cFullPath, lFind})

    // VERIFICA SE OS CERTIFICADOS BÁSICOS FORAM EXTRAÍDOS
    If (!aCert[2][3] .And. !aCert[3][3])
        Final("ERROR: Couldn't extract any certificate")
    EndIf
Return (aCert)
