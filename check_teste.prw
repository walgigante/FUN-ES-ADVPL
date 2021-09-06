#include "TOTVS.CH"

User Function TCheckBox()

DEFINE DIALOG oDlg TITLE "Exemplo TCheckBox" FROM 180,180 TO 550,700 PIXEL

lCheck := .F. // Usando New

oCheck1 := TCheckBox():New(01,01,'CheckBox 001',,oDlg,100,210,,,,,,,,.T.,,,)
oCheck2 := TCheckBox():New(11,01,'CheckBox 002',,oDlg,100,210,,,,,,,,.T.,,,)
oCheck3 := TCheckBox():New(21,01,'CheckBox 003',,oDlg,100,210,,,,,,,,.T.,,,)
oCheck4 := TCheckBox():New(31,01,'CheckBox 004',,oDlg,100,210,,,,,,,,.T.,,,)
oCheck5 := TCheckBox():New(41,01,'CheckBox 005',,oDlg,100,210,,,,,,,,.T.,,,)
ACTIVATE DIALOG oDlg CENTERED
Return

Static Function VldCheck()
	ConOut("OI")
Return (.F.)