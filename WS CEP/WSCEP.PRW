#include 'protheus.ch'


User Function WSCEP()

	MsgRun("Procurando CEP...", "Aguarde", {|| fInCep()})

Return


Static Function fInCep()

	Local aPergs   := {}
	Local nCep := 0

	aAdd(aPergs, {1, "CEP" ,nCep,PesqPict("SA1", "A1_CEP"),"ValCep()", "",".T.", TamSX3(A1_CEP), .T.})

	If ParamBox(aPergs, "Informe o cep")
		If RestCep(MV_PAR01)
			FwAlertSucces("Importaçao feita com sucesso!","Sucesso")
		EndIf
	EndIf

Return Nil

Static Function ValCep()

	Local lRet := .T.

	IF len(MV_PAR01) < 8 .AND. !VAZIO()
		lRet:= .F.
	EndIf

return lRet


static Function RestCep(nCep)

	Local cCep          := cValToChar(nCep)
	Local cUrl			:= "http://viacep.com.br/ws/"+ALLTRIM(cCep)+"/json/"
	Local cJson         := ""
	Local nTimeOut		:= 200
	Local aHeadStr		:= {"Content-Type: application/json"}
	Local cHeaderGet	:= ""
	Local oJson			:= Nil
	Local cGetParms     := ""

	cJson	:= HttpGet(cUrl, cGetParms, nTimeOut, aHeadStr, @cHeaderGet)

	FWJsonDeserialize(cJson,@oJson)
	If !AttIsMemberOf(oJson,"ERRO")
		RecLock('SA1', .F.)
			SA1->A1_CEP 	:= oJson['cep']
			SA1->A1_END 	:= oJson['logradouro']
			SA1->A1_COMPLEM := oJson['complemento']
			SA1->A1_BAIRRO  := oJson['bairro']
			SA1->A1_MUN  	:= oJson['localidade']
			SA1->A1_IBGE	:= oJson['ibge']
			SA1->A1_DDD		:= oJson['ddd']
		SA1->(MsUnlock())
	Else
		alert("Dados do CEP informado nao encontrados.")
		Return .F.
	EndIf

Return .T.

