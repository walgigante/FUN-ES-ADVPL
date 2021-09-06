#include 'protheus.ch'
#include 'parmtype.ch'

user function GATSA2()

	Local lRet      := .T.
	Local oModel    := FWModelActive()
	Local cNumCon    := oModel:GetValue('SA2MASTER','A2_NUMCON')

	cNumCon := STRZERO(VAL(cNumCon),10)

	oModel:SetValue('SA2MASTER','A2_NUMCON',cNumCon)

Return lRet