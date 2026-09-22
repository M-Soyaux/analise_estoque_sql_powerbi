-- VIEW RESUMO DAS ZONAS
CREATE OR REPLACE VIEW vw_resumo_zonas AS
	SELECT zone AS zona_separacao, COUNT(*) AS qtd_SKUs, 
		ROUND(AVG(picking_time_seconds), 2) AS tempo_medio_separacao, 
		ROUND(AVG(handling_cost_per_unit), 2) AS custo_medio_manuseio
	FROM projeto_estoque.estoque
	GROUP BY zona_separacao;
    
 -- Consulta da view   
SELECT *
FROM vw_resumo_zonas
ORDER BY tempo_medio_separacao DESC;

-- Procedure para consulta do tempo medio por filtro
DROP PROCEDURE IF EXISTS  projeto_estoque.sp_zonas_acima_tempo;

DELIMITER //

CREATE PROCEDURE projeto_estoque.sp_zonas_acima_tempo(
    IN p_limite_segundos DECIMAL(10,2)
)
BEGIN
    SELECT *
    FROM projeto_estoque.vw_resumo_zonas
    WHERE tempo_medio_separacao > p_limite_segundos
    ORDER BY tempo_medio_separacao DESC;
END //

DELIMITER ;

-- Chamando a Procedure
CALL projeto_estoque.sp_zonas_acima_tempo(95);


CREATE OR REPLACE VIEW vw_base_powerbi AS
SELECT
    item_id,
    category,
    zone,
    stock_level,
    reorder_point,
    unit_price,
    turnover_ratio,
    forecasted_demand_next_7d,
    holding_cost_per_unit_day,
    stockout_count_last_month,
    order_fulfillment_rate,
    picking_time_seconds,
    handling_cost_per_unit
FROM projeto_estoque.estoque;

SELECT *
FROM vw_base_powerbi;
