#INCLUDE "TOTVS.CH"
#INCLUDE "PARMTYPE.CH"

USER FUNCTION TSTGET()

	Local cHtmlPage

	 RPCSETENV("T1", "M SP 01 ") 

		// BUSCAR PAGINA 
		cHtmlPage := HTTPGET('https://www.google.com/')
		ALERT("WebPage", cHtmlPage)

	RPCCLEARENV()     
return
