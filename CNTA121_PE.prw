//Bibliotecas
#Include "TOTVS.CH"
#Include "FWMVCDEF.CH"

/*/{Protheus.doc} CNTA121
Ponto de Entrada MVC Ref. a Rotina de medicao de contratos.
@author Totvs
@since 11/11/2019
@version 1.0
@return ${return}, ${return_description}
@type function
/*/
User Function CNTA121()

	Local x_Ret       	:= .T.
	Local o_Obj       	:= NIL
	Local c_IdPonto   	:= ""
	Local c_IdModel   	:= ""
	
	If (PARAMIXB <> NIL)
		o_Obj       := PARAMIXB[1]
		c_IdPonto   := PARAMIXB[2]
		c_IdModel   := PARAMIXB[3]

		If (c_IdPonto == 'MODELPOS')
			If Alltrim(Upper(c_IdModel)) == 'CNTA121'
				If o_Obj:GetOperation() == MODEL_OPERATION_INSERT .Or. o_Obj:GetOperation() == MODEL_OPERATION_UPDATE 
					MsgInfo("Condicional atendido!")
				EndIf
			EndIf
		EndIf
	EndIf
	
Return(x_Ret)
