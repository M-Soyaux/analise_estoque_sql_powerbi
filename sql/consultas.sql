-- Distribuição do estoque por categoria
SELECT 
	category AS categoria, COUNT(*) AS total_SKUs, 
    SUM(stock_level) AS total_uni_estoque, 
    ROUND(AVG(stock_level), 2) AS media_estoque
FROM projeto_estoque.estoque
GROUP BY category
ORDER BY total_uni_estoque DESC;

-- SKUs abaixo do nivel de reposição (qtd e percentual)
SELECT category AS categoria, COUNT(*) AS total_SKUs,
SUM(
		CASE
			WHEN stock_level < reorder_point THEN 1
            ELSE 0
		END
	) AS qtd_abaixo_reposicao,
    ROUND(SUM(
		CASE
			WHEN stock_level < reorder_point THEN 1
            ELSE 0
		END
	) *100 / COUNT(*), 2) AS percent_abaixo_reposicao
FROM projeto_estoque.estoque
GROUP BY category
ORDER BY percent_abaixo_reposicao DESC;

-- Itens com estoque insuficiente 
SELECT category AS categoria, COUNT(*) AS total_SKUs,
SUM(
		CASE
			WHEN stock_level < forecasted_demand_next_7d THEN 1
            ELSE 0
		END
	) AS qtd_item_insuficiente,
    ROUND(SUM(
		CASE
			WHEN stock_level < forecasted_demand_next_7d THEN 1
            ELSE 0
		END
	) *100 / COUNT(*), 2) AS percent_item_insuficiente
FROM projeto_estoque.estoque
GROUP BY category
ORDER BY percent_item_insuficiente DESC;

-- 10 SKUs com maior falta estimada
SELECT item_id AS codigo_item,
	category AS categoria,
    stock_level AS estoque_atual,
    forecasted_demand_next_7d AS demanda_prevista_7d,
	ROUND(forecasted_demand_next_7d - stock_level, 2) AS falta_estimada
FROM projeto_estoque.estoque
WHERE stock_level < forecasted_demand_next_7d
ORDER BY falta_estimada DESC
LIMIT 10;

-- SKUs com estoque elevado e giro baixo (estoque acima, giro abaixo da media)
SELECT item_id AS codigo_item, category AS categoria, stock_level AS estoque_atual, turnover_ratio AS giro_estoque
FROM projeto_estoque.estoque
WHERE stock_level > (SELECT
	AVG(stock_level)
    FROM projeto_estoque.estoque
    ) AND turnover_ratio < (SELECT 
    AVG(turnover_ratio)
    FROM projeto_estoque.estoque
    )
ORDER BY estoque_atual DESC,
	giro_estoque ASC;

-- Valor de estoque e custo estimado por categoria (estoque acima, giro abaixo da media)
SELECT category AS categoria, COUNT(*) AS qtd_SKUs_alto_estoque_baixo_giro,
	SUM(stock_level) AS total_unidades,
    ROUND(SUM(stock_level * unit_price) / SUM(stock_level), 2) AS preco_medio_ponderado,
    ROUND(SUM(stock_level * unit_price), 2) AS valor_estoque,
    ROUND(SUM(stock_level * holding_cost_per_unit_day), 2) AS custo_diario_armazenagem
FROM projeto_estoque.estoque
WHERE stock_level > (SELECT
	AVG(stock_level)
    FROM projeto_estoque.estoque
    ) AND turnover_ratio < (SELECT 
    AVG(turnover_ratio)
    FROM projeto_estoque.estoque
    )
GROUP BY category 
ORDER BY custo_diario_armazenagem DESC;

-- rupturas e atendimento de pedidos
SELECT category AS categoria, 
	COUNT(*) AS qtd_SKUs,
	SUM(stockout_count_last_month) AS qtd_rupturas_ult_mes, 
    ROUND(AVG(order_fulfillment_rate), 2) AS taxa_media_atendimento
FROM projeto_estoque.estoque
WHERE order_fulfillment_rate < 
	(SELECT AVG(order_fulfillment_rate)
    FROM projeto_estoque.estoque) 
    AND
    stockout_count_last_month > 0
GROUP BY categoria
ORDER BY qtd_SKUs DESC;





	
	



