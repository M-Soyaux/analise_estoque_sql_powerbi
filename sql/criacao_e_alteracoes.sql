CREATE DATABASE IF NOT EXISTS projeto_estoque;
USE projeto_estoque;
SELECT DATABASE() AS banco_atual;

DESCRIBE projeto_estoque.estoque;

-- Contagem de linhas da base
SELECT COUNT(*) AS total_linhas
FROM projeto_estoque.estoque;

-- Verificação de itens nulos
SELECT COUNT(item_id) AS qtd_itens_nao_nulos
FROM projeto_estoque.estoque;

-- Verificação de itens repetidos
SELECT COUNT(DISTINCT item_id) AS total_itens
FROM projeto_estoque.estoque;

-- Alterando colunas 
ALTER TABLE projeto_estoque.estoque
	MODIFY COLUMN item_id VARCHAR(20) NOT NULL,
    ADD PRIMARY KEY (item_id);
    
ALTER TABLE projeto_estoque.estoque
	MODIFY COLUMN unit_price DECIMAL(10,2);
    
ALTER TABLE projeto_estoque.estoque
	MODIFY COLUMN handling_cost_per_unit DECIMAL(10,2);
    
ALTER TABLE projeto_estoque.estoque
	MODIFY COLUMN holding_cost_per_unit_day DECIMAL(10,2);
    
    
