



User Function tstCvTst()

	//Local sStr := "01234567890123456789"
	//Local sOut := ""
	//Chave privada - origem *.pk7 e destino *.pem
	//Local cKeyPk7 := "\certs\keypk7.pk7"
	//Local cKeyPem := "\certs\keypk7.pem"
	//Chave pública/certificado com chave pública - origem *.pk7 e destino *.pem
	//Local cCertPk7 := "\certs\certpk7.pk7"
	//Local cCertPem := "\certs\certpk7.pem"
	//Local cError := ""
	//Local cContent : = ""
	//Local lRet
	Local sStr := "01234567890123456789"
	Local sOut := ""
	Local cKeyPk7 := "\certs\nfse000001_all.pem"
	Local cKeyPem := "\certs\nfse000001_all.pem"
	Local cCertPk7 := "\certs\nfse000001_all.pem"
	Local cCertPem := "\certs\nfse000001_all.pem"
	Local cError := ""
	Local cContent := ""
	Local lRet

	// => Conversão da chave privada

	//lRet := PK7Key2PEM( cKeyPk7, cKeyPem, @cError, "SEBRAEA1" )
	//If lRet == .F.
		//conout( "Error: " + cError )
	//Else
	//	cContent := MemoRead( cKeyPem )
	//	varinfo( "KeyPem", cContent )
	//Endif

	// => Conversão da chave pública/certificado com chave pública

//	lRet := PK7Key2PEM( cCertPk7, cCertPem, @cError )
//	If lRet == .F. 
	//	conout( "Error: " + cError )
	//Else
	//	cContent := MemoRead( cCertPem )
//	varinfo( "KeyPem", cContent )
	//Endif

	//sStr := Md5( sStr )
//	varinfo( "1", sStr )

	sOut := PrivSignRSA( "\certs\nfse000001_all.pem", sStr, 1, "assinatura" )
	varinfo( "sOut", sOut )

	conout( PrivVeryRSA( "\certs\nfse000001_all.pem", sStr, 1, sOut ) )

Return