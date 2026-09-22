# Análise de Estoque com SQL e Power BI

Projeto pessoal de análise de dados simulados de 3.204 SKUs, distribuídos em cinco categorias e quatro zonas de armazenagem. O objetivo é identificar situações que merecem investigação na reposição, na disponibilidade de produtos e na operação do estoque.

O projeto conecta consultas em MySQL, tratamento no Power Query, modelagem dimensional e indicadores em DAX a um dashboard no Power BI.

## Perguntas de negócio

- Quais itens estão abaixo do ponto de reposição?

- Quais categorias apresentam maior proporção de itens com estoque insuficiente para a demanda prevista dos próximos sete dias?

- Quais itens combinam estoque acima da média e giro abaixo da média?

- Como o valor estimado do estoque e os custos de armazenagem se distribuem entre as categorias?

- Como as zonas se comparam em tempo médio de separação e custo de manuseio?

## Dados e ferramentas

**Fonte:** [Logistics Warehouse Dataset — Kaggle](https://www.kaggle.com/datasets/ziya07/logistics-warehouse-dataset).

A base original contém 3.204 registros e 23 colunas. Para o Power BI, foi criada uma view com 13 colunas relevantes para o painel, preservando todos os registros. A consulta foi exportada em CSV e tratada no Power Query.

| Ferramenta | Aplicação |
| --- | --- |
| MySQL Workbench | Validação da base, consultas, agregações, subconsultas, views e stored procedure |
| Power Query | Ajuste de tipos, interpretação dos separadores decimais e preparação das tabelas |
| Power BI e DAX | Relacionamentos, medidas e dashboard interativo |

## Desenvolvimento

| Etapa | Atividade |
| --- | --- |
| Validação | Conferência de identificadores, duplicidades, valores ausentes e tipos de dados. |
| Análise em SQL | Investigação de reposição, demanda prevista, giro, rupturas registradas, atendimento e custos. |
| Objetos no banco | Criação da view de resumo das zonas, da procedure que consulta zonas acima de um limite de tempo médio de separação e da view de extração para o Power BI. |
| Tratamento | Correção da interpretação dos números decimais na importação do CSV e definição dos tipos das colunas. |
| Modelagem | Construção da tabela fato e das dimensões de categoria e zona. |
| Visualização | Criação de medidas DAX, cartões, gráficos por categoria, tabela de itens e resumo das zonas. |

## Modelo de dados

A granularidade da `ProjetoEstoque_F` é um registro por SKU na base analisada.

- `ProjetoEstoque_F`: identificador do item, quantidades, preços, indicadores operacionais e chaves das dimensões.

- `Categoria_D`: categorias e seus identificadores.

- `Zona_D`: zonas de armazenagem e seus identificadores.

- `Medidas`: organização das 12 medidas DAX do painel.

As dimensões se relacionam com a fato em relações de um para muitos, com filtro da dimensão para a fato.

## Documentação das medidas

As **12 medidas DAX**, com suas fórmulas e interpretações, estão em [medidas_dax.md](medidas_dax.md). As expressões foram obtidas diretamente do modelo aberto no Power BI por meio de `INFO.VIEW.MEASURES()`.

## Indicadores apresentados no Power BI

| Indicador | Critério |
| --- | --- |
| Total de SKUs | Contagem distinta de `item_id` |
| Total Estoque | Soma de `stock_level` |
| Valor estimado do estoque | Soma de `stock_level` × `unit_price`, calculada por item |
| Abaixo do ponto de reposição | `stock_level` < `reorder_point` |
| Estoque insuficiente para sete dias | `stock_level` < `forecasted_demand_next_7d` |
| Tempo médio de separação | Média de `picking_time_seconds`, apresentada em minutos no painel |

Nos gráficos percentuais, o denominador é o total de SKUs da categoria no contexto dos filtros aplicados.

## Dashboard Power BI

O dashboard foi desenvolvido para acompanhar indicadores de estoque, identificar situações que exigem atenção e apoiar a análise da disponibilidade dos produtos.

![Dashboard de análise de estoque](./images/dashboard_estoque.png)

## Principais resultados e interpretação

Os resultados abaixo consideram a base completa, sem seleção de categoria:

- 237 SKUs (7,40%) estão abaixo do ponto de reposição.

- Automotive apresenta a maior proporção nessa condição: 51 de 658 SKUs (7,75%). Isso orienta a conferência dos pedidos em aberto, das datas previstas e dos prazos reais de reposição.

- Apparel apresenta a maior proporção de itens com estoque inferior à demanda prevista para sete dias: 175 de 617 SKUs (28,36%). Em quantidade absoluta, Automotive tem mais itens nessa condição: 182 de 658 (27,66%). A prioridade depende também da cobertura e do impacto de cada item.

- A análise em SQL identificou 791 SKUs (24,69%) com estoque acima da média e giro abaixo da média. Esses itens formam um grupo para investigação de demanda, compras e possíveis ações comerciais.

- Pharma apresenta o maior valor estimado de estoque no painel, aproximadamente 19,1 milhões, na unidade monetária da base.

A interpretação dos alertas de reposição deve considerar as quantidades já compradas e as datas de chegada. A revisão do ponto de reposição depende da demanda, do prazo de entrega e de suas variações. As causas dos alertas não foram comprovadas pela base.

## Limitações da análise

- A base é simulada e representa uma posição de estoque, sem histórico de movimentações suficiente para analisar a evolução mensal.

- Estoque inferior à previsão de sete dias sinaliza insuficiência caso a previsão se confirme e não haja reposição no período; não comprova uma ruptura futura.

- Estoque acima da média e giro abaixo da média não comprovam excesso ou obsolescência.

- O valor estimado utiliza `unit_price`, que não foi confirmado como custo de aquisição. A moeda da base também não foi confirmada.

- As médias operacionais são calculadas por SKU, sem ponderação pelo volume efetivamente separado ou manuseado.
