--18_isolamento_transacional.sql

CREATE DATABASE db1410_isolamento;
GO

USE db1410_isolamento;
GO

CREATE TABLE produtos(
	produto_id INT PRIMARY KEY,
	nome_produto VARCHAR(100),
	quantidade INT,
	preco DECIMAL (10,2)
);

INSERT INTO produtos
	(produto_id,nome_produto,quantidade,preco)
VALUES
	(1, 'Camiseta', 100, 50.00),
	(2, 'Cal�a', 50, 120.00),
	(3, 'Tenis', 75, 500.00),
	(4, 'Meia', 25, 20.00),
	(5, 'Blusa', 10, 200.00);

SELECT * FROM produtos

/*
Exemplo de isolamento transacional
para observar o comportamento vamos realizar algumas opera��es

A- usar diferentes niveis de isolamento
B-simular transa��es recorrentes

Vamos come�ar com uma transa��o com niveis de
isolamento 'READ UNCOMMITED'
*/

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN TRANSACTION;
	--vamos ler os dados da tabela de produtos
	--permitindo dados nao confirmados (dirty read)

	PRINT 'Transa��o 01 (READ UNCOMMITTED)';
	SELECT * FROM produtos;

	--alterando a quantidade sem confirmar a transa��o
	UPDATE produtos
	SET quantidade=quantidade-5
	WHERE produto_id=1;

	--simulando algum processamento
	WAITFOR DELAY '00:00:10';--Atraso de 10 segundos antes do commit

COMMIT TRANSACTION;

--agora vamos realizar uma transa��o com nivel de isolamento
--'SERIALIZABLE'

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
BEGIN TRANSACTION;
	--vamos ler e bloquear a linha de produto_id 1
	PRINT 'Transa��o 02 (SERIALIZABLE)';
	SELECT * FROM produtos
	WHERE produto_id=1;
	WAITFOR DELAY '00:00:10';
COMMIT TRANSACTION;