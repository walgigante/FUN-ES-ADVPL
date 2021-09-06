/*
===============================================================================================================================
               ULTIMAS ATUALIZA��ES EFETUADAS - CONSULTAR LOG DO VERSIONADOR PARA HISTORICO COMPLETO
===============================================================================================================================
 Autor        |    Data    |                              Motivo                      										 
-------------------------------------------------------------------------------------------------------------------------------
Lucas Borges  | 28/09/2018 | Revis�o do fonte para padroniza��o - Chamado 26404
-------------------------------------------------------------------------------------------------------------------------------
Lucas Borges  | 08/10/2018 | Corrigido nome da vari�vel - Chamado 26566
===============================================================================================================================
*/

//===========================================================================
//| Defini��es de Includes                                                  |
//===========================================================================
#INCLUDE 'Protheus.ch' 

/*
===============================================================================================================================
Programa----------: AGLT031
Autor-------------: Abrahao P. Santos
Data da Criacao---: 08/05/2009
===============================================================================================================================
Descri��o---------: Cadastro de Mensagens do Informativo/Demonstrativo do Produtor
===============================================================================================================================
Parametros--------: Nenhum
===============================================================================================================================
Retorno-----------: Nenhum
===============================================================================================================================
*/
User Function AGLT031

Private cCadastro	:= "Mensagens do Informativo"
Private aRotina		:= MenuDef()
Private cAlias		:= "SB1"

//AxCadastro(cAlias,cCadastro,,) 	// N�o funciona
mBrowse( ,,,, cAlias )		// Funciona
Return

/*
===============================================================================================================================
Programa----------: MenuDef
Autor-------------: Lucas Borges Ferreira
Data da Criacao---: 28/08/2018
===============================================================================================================================
Descri��o---------: Utilizacao de Menu Funcional
===============================================================================================================================
Parametros--------: aRotina
					1. Nome a aparecer no cabecalho
					2. Nome da Rotina associada
					3. Reservado
					4. Tipo de Transa��o a ser efetuada:
						1 - Pesquisa e Posiciona em um Banco de Dados
						2 - Simplesmente Mostra os Campos
						3 - Inclui registros no Bancos de Dados
						4 - Altera o registro corrente
						5 - Remove o registro corrente do Banco de Dados
					5. Nivel de acesso
					6. Habilita Menu Funcional
===============================================================================================================================
Retorno-----------: Array com opcoes da rotina
===============================================================================================================================
*/
Static Function MenuDef()

Local aRotina := {	{ "Pesquisar"		, "AxPesqui" 		, 0 , 1 } ,;
					{ "Visualizar"		, "AxVisual" 		, 0 , 2 } ,;
					{ "Incluir"			, "u_Getwal2" 		, 0 , 3 } ,;
					{ "Alterar"			, "AxAltera" 		, 0 , 4 } ,;
					{ "Excluir"			, "AxDeleta"		, 0 , 5 }  }

Return( aRotina )