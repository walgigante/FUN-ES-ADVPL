#INCLUDE "TOTVS.CH"
/*/{Protheus.doc} FWEXCELTST
    Função para criação de planillha
    @type function
    @author Waldenilson Mereles 
    @since 07/07/2021
/*/
USER FUNCTION FWEXCELTST()
    LOCAL lRet := NIL

    oExcel := FWMSEXCELXLSX():NEW()

        lRet := oExcel:ISWORKSHEET("WorkSheet1")
        oExcel:ADDWORKSHEET("WorkSheet1")

        lRet := oExcel:ISWORKSHEET("WorkSheet1")
        oExcel:ADDTABLE ("WorkSheet1","Table1")
        oExcel:ADDCOLUMN("WorkSheet1","Table1","Col1",1,2,.F., "999999.9")
        oExcel:ADDCOLUMN("WorkSheet1","Table1","Col2",1,2,.F., "999999.99")
        oExcel:ADDCOLUMN("WorkSheet1","Table1","Col3",1,2,.F., "999999.999")
        oExcel:ADDCOLUMN("WorkSheet1","Table1","Col4",1,2,.F., "999999.9999")
        oExcel:ADDCOLUMN("WorkSheet1","Table1","Col5",1,2,.F., "999999.99999")
        oExcel:ADDCOLUMN("WorkSheet1","Table1","Col6",1,2,.F., "999999.999999")
        oExcel:ADDCOLUMN("WorkSheet1","Table1","Col7",1,2,.F., "999999.9999999")
        oExcel:ADDCOLUMN("WorkSheet1","Table1","Col8",1,1,.F., "999999.99999999")


        oExcel:ADDROW("WorkSheet1","Table1",{1.1, 2.11, 3.111, 4.1111, 5.11111, 6.111111, 7.1111111, 8.11111111})
        oExcel:ACTIVATE()
        oExcel:GETXMLFILE("C:\12.1.25\TESTE.xlsx")

    oExcel:DEACTIVATE()
RETURN
