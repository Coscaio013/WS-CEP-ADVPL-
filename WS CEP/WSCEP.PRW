#include 'protheus.ch'


User Function WSCEP()

	MsgRun("Procurando CEP...", "Aguarde", {|| fInCep()})

Return


Static Function fInCep()

	Local aPergs   := {}
	Local cCep := Space(TamSX3("A1_CEP")[1])

	aAdd( aPergs ,{1,"CEP",cCep , PesqPict("SA1","A1_CEP")   ,'U_ValCep()',     ,'.T.',TamSX3("A1_CEP")[1],.T.}) 

	If ParamBox(aPergs, "Informe o cep")
		If RestCep(MV_PAR01)
			FwAlertSucces("Importaçao feita com sucesso!","Sucesso")
		EndIf
	EndIf

Return Nil

User Function ValCep()

Local lRet := .T.

	If len(ALLTRIM(&(ReadVar()))) < 8 .AND. !VAZIO()
		lRet:= .F.
	EndIf

Return lRet

static Function RestCep(cCep)

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

