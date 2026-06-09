# Prompt do teste: harness ADVPL Protheus

Voce deve desenvolver uma rotina em ADVPL para Protheus que gere um relatorio final em Excel para conferencia contabil de movimentos operacionais e cadastros contabeis.

Nao ha fonte base fornecido. O objetivo e criar uma rotina funcional a partir das especificacoes abaixo.

## Objetivo funcional

Criar uma rotina de conferencia contabil que ajude o usuario a identificar:

- movimentos operacionais com lancamento contabil encontrado;
- movimentos operacionais sem lancamento contabil;
- movimentos com divergencia entre valor operacional e valor contabil;
- lancamentos contabeis que precisam ser analisados isoladamente;
- produtos com configuracao contabil incompleta.

O resultado deve ser gerado em Excel, com colunas claras, em ordem consistente e com uma coluna de status que permita filtrar rapidamente os problemas.

## Parametros obrigatorios

A rotina deve solicitar, no minimo:

- Data inicial
- Data final
- Filial inicial
- Filial final
- Tipo do relatorio

O parametro "Tipo do relatorio" deve oferecer estas opcoes:

- Entrada
- Saida
- Custo
- Mov.Cont
- Cad.Prod

Regras esperadas para os parametros:

- Data inicial e data final sao obrigatorias para Entrada, Saida, Custo e Mov.Cont.
- Filial inicial e filial final devem limitar a consulta em todas as opcoes, inclusive Cad.Prod.
- Se a data final for menor que a data inicial, a rotina deve bloquear a execucao e avisar o usuario.
- Se o tipo de relatorio estiver vazio ou invalido, a rotina deve bloquear a execucao.
- A rotina deve gerar apenas a visao escolhida pelo usuario.

## Tabelas e relacionamentos esperados

Use as tabelas Protheus de acordo com a opcao selecionada.

### Entrada

Base operacional:

- SD1: itens de entrada

Relacionamentos esperados:

- SD1 com CV3 pelo registro de origem do item e origem SD1
- CV3 com CT2 pelo registro de destino contabil
- CT2 com CT1 para descricao das contas de debito e credito
- CV3 com CT5 para identificar regra/lancamento padrao, quando existir
- SD1 com SF4 pela TES
- SD1 com SB1 pelo produto
- SD1 com SFT para valores fiscais, quando disponiveis
- SD1/CT2 com CTH para classe de valor, quando disponivel

### Saida

Base operacional:

- SD2: itens de saida

Relacionamentos esperados:

- SD2 com CV3 pelo registro de origem do item e origem SD2
- CV3 com CT2 pelo registro de destino contabil
- CT2 com CT1 para descricao das contas de debito e credito
- CV3 com CT5 para identificar regra/lancamento padrao, quando existir
- SD2 com SF4 pela TES
- SD2 com SB1 pelo produto
- SD2 com SFT para valores fiscais, quando disponiveis

### Custo

Base operacional:

- SD3: movimentos internos, custo, producao, requisicao e transferencia

Relacionamentos esperados:

- SD3 com CV3 pelo registro de origem do movimento e origem SD3
- CV3 com CT2 pelo registro de destino contabil
- CT2 com CT1 para descricao das contas de debito e credito
- CV3 com CT5 para identificar regra/lancamento padrao, quando existir
- SD3 com SB1 pelo produto
- SD3 com SF5 pelo tipo de movimento, quando necessario para enriquecer a analise

Regras esperadas para SD3:

- Ignorar movimentos estornados.
- Classificar o tipo do movimento pelo campo de CF/movimento, separando ao menos:
  - movimento interno;
  - transferencia;
  - producao;
  - requisicao de producao;
  - outros movimentos.
- Tratar corretamente o sinal do custo quando a natureza do movimento exigir inversao.
- Nao usar lote contabil fixo no codigo. Se houver filtro por lote, ele deve ser parametro ou premissa explicitada.

### Mov.Cont

Base contabil:

- CT2: lancamentos contabeis

Relacionamentos esperados:

- CT2 com CT1 para descricao das contas de debito e credito
- CT2 com CTH para descricao da classe de valor de debito e credito, quando disponivel

Esta visao deve permitir analisar o movimento contabil em si, mesmo quando nao houver vinculo operacional.

### Cad.Prod

Base cadastral:

- SB1: cadastro de produtos

Relacionamentos esperados:

- SB1 com CT1 para descricao da conta contabil principal
- SB1 com CT1 para descricao da conta de custo, quando existir campo especifico
- SB1 com CT1 para descricao da conta de despesa, quando existir campo especifico
- SB1 com CT1 para descricao da conta de receita, quando existir campo especifico

Esta visao deve apontar produtos com configuracao contabil incompleta.

## Colunas obrigatorias por tipo de relatorio

### Entrada

O Excel de Entrada deve conter, no minimo:

- FILIAL
- DATA_MOVIMENTO
- DOCUMENTO
- SERIE
- FORNECEDOR
- LOJA
- ITEM
- PRODUTO
- DESCRICAO_PRODUTO
- TIPO_PRODUTO
- TES
- CFOP
- TIPO_NF
- QUANTIDADE
- VALOR_OPERACIONAL
- CUSTO_OPERACIONAL
- VALOR_CV3
- VALOR_CT2
- DIFERENCA
- CONTA_DEBITO
- DESC_CONTA_DEBITO
- CONTA_CREDITO
- DESC_CONTA_CREDITO
- CENTRO_CUSTO_DEBITO
- CENTRO_CUSTO_CREDITO
- ITEM_CONTABIL_DEBITO
- ITEM_CONTABIL_CREDITO
- CLASSE_VALOR_OPERACIONAL
- CLASSE_VALOR_DEBITO
- CLASSE_VALOR_CREDITO
- HISTORICO_CONTABIL
- ORIGEM_CONTABIL
- LANCAMENTO_PADRAO
- DESC_LANCAMENTO_PADRAO
- TES_ESTOQUE
- TES_DUPLICATA
- TES_CONTABILIZA
- VALOR_ICMS
- VALOR_ICMS_ST
- VALOR_IPI
- VALOR_PIS
- VALOR_COFINS
- STATUS_CONFERENCIA
- OBSERVACAO

### Saida

O Excel de Saida deve conter, no minimo:

- FILIAL
- DATA_MOVIMENTO
- DOCUMENTO
- SERIE
- CLIENTE
- LOJA
- ITEM
- PRODUTO
- DESCRICAO_PRODUTO
- TIPO_PRODUTO
- TES
- CFOP
- TIPO_NF
- QUANTIDADE
- VALOR_OPERACIONAL
- CUSTO_OPERACIONAL
- VALOR_CV3
- VALOR_CT2
- DIFERENCA
- CONTA_DEBITO
- DESC_CONTA_DEBITO
- CONTA_CREDITO
- DESC_CONTA_CREDITO
- CENTRO_CUSTO_DEBITO
- CENTRO_CUSTO_CREDITO
- ITEM_CONTABIL_DEBITO
- ITEM_CONTABIL_CREDITO
- HISTORICO_CONTABIL
- ORIGEM_CONTABIL
- LANCAMENTO_PADRAO
- DESC_LANCAMENTO_PADRAO
- TES_ESTOQUE
- TES_DUPLICATA
- MOVIMENTA_ESTOQUE
- VALOR_ICMS
- VALOR_ICMS_ST
- VALOR_IPI
- VALOR_PIS
- VALOR_COFINS
- STATUS_CONFERENCIA
- OBSERVACAO

### Custo

O Excel de Custo deve conter, no minimo:

- FILIAL
- TIPO_MOVIMENTO_CLASSIFICADO
- CODIGO_MOVIMENTO
- TIPO_MOVIMENTO
- DATA_MOVIMENTO
- DOCUMENTO
- ORDEM_PRODUCAO
- PRODUTO
- DESCRICAO_PRODUTO
- TIPO_PRODUTO
- ARMAZEM
- QUANTIDADE
- CUSTO_OPERACIONAL
- VALOR_CV3
- VALOR_CT2
- DIFERENCA
- CONTA_DEBITO
- DESC_CONTA_DEBITO
- CONTA_CREDITO
- DESC_CONTA_CREDITO
- HISTORICO_CONTABIL
- ORIGEM_CONTABIL
- LANCAMENTO_PADRAO
- DESC_LANCAMENTO_PADRAO
- STATUS_CONFERENCIA
- OBSERVACAO

### Mov.Cont

O Excel de Mov.Cont deve conter, no minimo:

- FILIAL
- DATA_CONTABIL
- LOTE
- DOCUMENTO
- LINHA
- TIPO_DC
- CONTA_DEBITO
- DESC_CONTA_DEBITO
- CONTA_CREDITO
- DESC_CONTA_CREDITO
- VALOR_CONTABIL
- HISTORICO
- HISTORICO_COMPLEMENTAR
- CENTRO_CUSTO_DEBITO
- CENTRO_CUSTO_CREDITO
- ITEM_CONTABIL_DEBITO
- ITEM_CONTABIL_CREDITO
- CLASSE_VALOR_DEBITO
- CLASSE_VALOR_CREDITO
- ORIGEM
- ROTINA
- LANCAMENTO_PADRAO
- STATUS_CONFERENCIA
- OBSERVACAO

### Cad.Prod

O Excel de Cad.Prod deve conter, no minimo:

- FILIAL
- PRODUTO
- DESCRICAO_PRODUTO
- TIPO_PRODUTO
- NCM
- CONTA_CONTABIL
- DESC_CONTA_CONTABIL
- CONTA_CUSTO
- DESC_CONTA_CUSTO
- CONTA_DESPESA
- DESC_CONTA_DESPESA
- CONTA_RECEITA
- DESC_CONTA_RECEITA
- CENTRO_CUSTO_RESULTADO
- STATUS_CONFERENCIA
- OBSERVACAO

## Calculo de valores e diferencas

Para Entrada:

- VALOR_OPERACIONAL deve representar o valor operacional/fiscal do item.
- CUSTO_OPERACIONAL deve representar o custo do item, quando disponivel.
- A diferenca principal deve comparar o custo ou valor operacional relevante contra o valor contabil encontrado.

Para Saida:

- VALOR_OPERACIONAL deve representar o valor bruto ou valor operacional do item.
- CUSTO_OPERACIONAL deve representar o custo do item, quando disponivel.
- A diferenca deve comparar o valor operacional/custo relevante contra o valor contabil encontrado.

Para Custo:

- CUSTO_OPERACIONAL deve considerar o sinal correto do movimento.
- A diferenca deve comparar custo operacional contra CV3/CT2.

Para Mov.Cont:

- Nao ha diferenca operacional obrigatoria, pois a base e contabil.
- A rotina deve destacar lancamentos sem informacao suficiente de origem, rotina ou lancamento padrao.

Para Cad.Prod:

- Nao ha diferenca de valores.
- A rotina deve avaliar completude das contas contabeis esperadas.

Se houver duvida sobre qual valor comparar em algum tipo de movimento, implemente a comparacao mais prudente e registre a premissa em comentario ou observacao.

## Status obrigatorios

A coluna STATUS_CONFERENCIA deve conter uma classificacao objetiva. Use, no minimo:

- CONTABILIZADO_OK
- SEM_LANCAMENTO_CONTABIL
- DIFERENCA_VALOR
- CONTA_DEBITO_NAO_INFORMADA
- CONTA_CREDITO_NAO_INFORMADA
- REGRA_CT5_NAO_LOCALIZADA
- CONFIG_PRODUTO_INCOMPLETA
- INFORMACAO_INSUFICIENTE

Regras minimas de status:

- Se nao houver CV3 ou CT2 relacionado ao movimento operacional, marcar SEM_LANCAMENTO_CONTABIL.
- Se houver CT2 mas a diferenca calculada for diferente de zero, marcar DIFERENCA_VALOR.
- Se houver lancamento contabil sem conta de debito, marcar CONTA_DEBITO_NAO_INFORMADA.
- Se houver lancamento contabil sem conta de credito, marcar CONTA_CREDITO_NAO_INFORMADA.
- Se houver CV3 com lancamento padrao ausente ou sem descricao em CT5, marcar REGRA_CT5_NAO_LOCALIZADA quando isso for relevante.
- Na visao Cad.Prod, se faltar conta contabil esperada, marcar CONFIG_PRODUTO_INCOMPLETA.
- Se nao houver dados suficientes para classificar, marcar INFORMACAO_INSUFICIENTE.
- Se nenhuma inconsistencia for encontrada, marcar CONTABILIZADO_OK.

A coluna OBSERVACAO deve explicar de forma curta o motivo do status quando houver problema.

## Comportamento esperado

A rotina deve:

- Gerar arquivo Excel ao final da execucao.
- Informar ao usuario quando nao houver dados para os parametros escolhidos.
- Nao deixar aliases, areas de trabalho ou objetos abertos indevidamente.
- Respeitar registros deletados logicamente.
- Respeitar filial conforme o padrao Protheus.
- Evitar nomes fisicos de tabelas fixos quando houver alternativa padrao para resolver a tabela do ambiente.
- Evitar filtros hardcoded de lote, filial, empresa ou produto.
- Separar a rotina em funcoes menores por responsabilidade.
- Separar a montagem de parametros, a consulta/coleta de dados, o calculo de status e a geracao do Excel.
- Manter o codigo legivel e compilavel em ADVPL.
- Usar nomes de funcoes, variaveis e colunas claros.

## Entregavel

Forneca apenas o fonte ADVPL completo e funcional da rotina.

Se houver premissas, limitacoes ou pontos importantes de validacao, registre de forma objetiva em comentarios no proprio fonte ou em observacoes breves apos o codigo.

## Criterios de aceite

A resposta sera considerada melhor se:

- implementar as cinco opcoes do relatorio;
- gerar Excel com as colunas obrigatorias da opcao selecionada;
- calcular STATUS_CONFERENCIA e OBSERVACAO;
- evitar valores fixos indevidos;
- tratar ausencia de dados sem quebrar;
- preservar recursos/aliases corretamente;
- deixar claro no codigo onde ha premissas de relacionamento entre tabelas;
- nao alegar validacao real sem ambiente Protheus.
