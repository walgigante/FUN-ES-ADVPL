#include  'protheus.ch'

// Teste de componente METER

// O Botão "Meter Normal" incrementa a régua de processamento, atualizada 
// em média a cada 10 acionamentos do botão 

// O botão "Knignt Rider" coloca o meter em um estado indeterminado, com uma
// animação da barra de progresso...

// O Botão Smartclient Info mostrauma caixa de dialogo 
// com detalhes do smartclient sendo executado

user function TSTMeter()
Local oMeter
Local nTot := 100
Local nPos := 1 
Local oDlg

DEFINE DIALOG oDlg FROM 0,0 TO 300,400 PIXEL TITLE "Teste de Regua de Processamento"
  
@ 10,20 METER oMeter VAR nPos TOTAL 10 SIZE 100, 10 OF oDlg PIXEL

@ 40,20 BUTTON oBtn1 PROMPT 'Meter Normal' ;
			ACTION (meterinc(oMeter,@nPos,nTot)) SIZE 080, 013 ;
			OF oDlg PIXEL

@ 60,20 BUTTON oBtn2 PROMPT 'Knignt Rider' ;
			ACTION (knightrider(oMeter)) SIZE 080, 013 ;
			OF oDlg PIXEL

@ 80,20 BUTTON oBtn1 PROMPT 'Smartclient Info' ;
			ACTION (ClientInfo()) SIZE 080, 013 ;
			OF oDlg PIXEL

ACTIVATE DIALOG oDlg  CENTER

Return

STATIC Function meterinc(oMeter,nPos,nTot)
oMeter:SetTotal(nTot+1)
oMeter:Set(++nPos)
oMeter:Refresh()
Return

STATIC Function knightrider(oMeter)
oMeter:SetTotal(0)
oMeter:Set(0)
oMeter:Refresh()
Return

STATIC Function ClientInfo()
Local aInfo := GETRMTINFO()
Local cInfo := ""
Local nI
Local cBuild := ""

cBuild += "Build "+cvaltochar(getbuild(.T.))
cBuild += " | Version "+cvaltochar(GetRmtVersion())

For nI := 1 to len(aInfo)
	cInfo += "#"+cvaltochar(nI)+"="+cvaltochar(aInfo[nI]) + CRLF 
Next

MsgInfo(cInfo,cBuild)

Return


