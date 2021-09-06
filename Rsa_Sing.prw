User Function RSA_Sign()
	Local sStr := "01234567890123456789"
	Local sOut := ""

	sStr := Md5( sStr )
	varinfo( "1",  sStr )

	sOut := PrivSignRSA( "\certs\certs_este\wildcard-cloudtotvs-com-br-2015.pem", sStr, 1, "senhachaveprivada" )
	varinfo( "sOut",  sOut )

	conout( PrivVeryRSA( "\certs\certs_este\wildcard-cloudtotvs-com-br-2015.pem", sStr, 1, sOut ) )
Return