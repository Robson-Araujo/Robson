create database ESTOQUE;
use ESTOQUE;

/*========================================================================================================*/
CREATE TABLE CLIENTE (
COD_CLI INT(10) NOT NULL,
NOME VARCHAR(25) NOT NULL,
CONSTRAINT PK_COD_CLI PRIMARY KEY (COD_CLI)
);

/*========================================================================================================*/
CREATE TABLE ESTOQUE (
COD_PECA INT(10) NOT NULL,
QUANTIDADE INT(10) NOT NULL,
DESCRICAO VARCHAR(20),
CONSTRAINT PK_COD_PECA PRIMARY KEY (COD_PECA)
);

/*========================================================================================================*/
CREATE TABLE CLIENTE_PEDIDO (
    COD_CLI INT(10) NOT NULL,
    QUANTIDADE_PED INT(10) NOT NULL,
    PRIMARY KEY (COD_CLI)
);

/*========================================================================================================*/
CREATE TABLE PEDIDOS (
COD_PED INT(10) NOT NULL,
COD_CLI INT(10) NOT NULL,
QUANTIDADE_ITENS INT(10) NOT NULL,
CONSTRAINT FK_CLIENTE_PEDIDO FOREIGN KEY (COD_CLI) REFERENCES CLIENTE_PEDIDO (COD_CLI),
CONSTRAINT FK_PED_CLI FOREIGN KEY (COD_CLI) REFERENCES CLIENTE (COD_CLI)
);

/*========================================================================================================*/
INSERT INTO CLIENTE (COD_CLI, NOME)
VALUES('1', 'GM');
INSERT INTO CLIENTE (COD_CLI, NOME)
VALUES('2', 'SMRC');
INSERT INTO CLIENTE (COD_CLI, NOME)
VALUES('3', 'SL');
INSERT INTO CLIENTE (COD_CLI, NOME)
VALUES('4', 'PELZER');

/*========================================================================================================*/
INSERT INTO ESTOQUE (COD_PECA, QUANTIDADE, DESCRICAO)
VALUES('3608', '1500', 'ALAVANCA');
INSERT INTO ESTOQUE (COD_PECA, QUANTIDADE, DESCRICAO)
VALUES('3609', '1400', 'INNER');
INSERT INTO ESTOQUE (COD_PECA, QUANTIDADE, DESCRICAO)
VALUES('3610', '1700', 'SOLEIRA');
INSERT INTO ESTOQUE (COD_PECA, QUANTIDADE, DESCRICAO)
VALUES('3611', '1200', 'ESCORREGADOR');
INSERT INTO ESTOQUE (COD_PECA, QUANTIDADE, DESCRICAO)
VALUES('3612', '1300', 'CAPA IGNICAO');
INSERT INTO ESTOQUE (COD_PECA, QUANTIDADE, DESCRICAO)
VALUES('3613', '1100', 'BOTAO');
INSERT INTO ESTOQUE (COD_PECA, QUANTIDADE, DESCRICAO)
VALUES('3614', '1800', 'DEFROST');
INSERT INTO ESTOQUE (COD_PECA, QUANTIDADE, DESCRICAO)
VALUES('3615', '1300', 'REGUA');
INSERT INTO ESTOQUE (COD_PECA, QUANTIDADE, DESCRICAO)
VALUES('3616', '1100', 'OUTER COVER');
INSERT INTO ESTOQUE (COD_PECA, QUANTIDADE, DESCRICAO)
VALUES('3617', '1350', 'RECLINER');
INSERT INTO ESTOQUE (COD_PECA, QUANTIDADE, DESCRICAO)
VALUES('3618', '1550', 'FUZZY BOX');
INSERT INTO ESTOQUE (COD_PECA, QUANTIDADE, DESCRICAO)
VALUES('3619', '1200', 'PLATE MANUAL');
INSERT INTO ESTOQUE (COD_PECA, QUANTIDADE, DESCRICAO)
VALUES('3620', '1600', 'PLATE AUTOMATICO');
INSERT INTO ESTOQUE (COD_PECA, QUANTIDADE, DESCRICAO)
VALUES('3621', '1450', 'COVER BOLT');

/*=========================================================================================================*/
INSERT INTO CLIENTE_PEDIDO (COD_CLI, QUANTIDADE_PED)
VALUES ('1','5');
INSERT INTO CLIENTE_PEDIDO (COD_CLI, QUANTIDADE_PED)
VALUES ('2','9');
INSERT INTO CLIENTE_PEDIDO (COD_CLI, QUANTIDADE_PED)
VALUES ('3','3');
INSERT INTO CLIENTE_PEDIDO (COD_CLI, QUANTIDADE_PED)
VALUES ('4','12');

/*VIEW 1===================================================================================================*/
CREATE VIEW CLIENTE_ITENS AS
SELECT *,
	(SELECT
	(B.QUANTIDADE_ITENS)
	FROM PEDIDOS B
	WHERE B.COD_PED = A.COD_CLI)
AS QUANTIDADE_ITENS
FROM CLIENTE A
GROUP BY QUANTIDADE_ITENS;

/*VIEW 2====================================================================================================*/
CREATE VIEW PEDIDOS_CLIENTE AS
SELECT *
FROM CLIENTE
WHERE COD_CLI IN 
	(SELECT COD_CLI 
	FROM PEDIDOS
	);
    
/*VIEW 3====================================================================================================*/
CREATE VIEW QUANTIDADE_ESTOQUE AS
SELECT *
FROM
(SELECT * FROM  ESTOQUE
WHERE QUANTIDADE >1500)S;

/*TRIGGER 1=================================================================================================*/
DELIMITER $$
CREATE TRIGGER tr_clientepedido_insert AFTER INSERT
ON PEDIDOS
FOR EACH ROW
BEGIN
    UPDATE CLIENTE_PEDIDO SET QUANTIDADE_PED = QUANTIDADE_PED +1
     WHERE COD_CLI = NEW.COD_CLI;
END $$

/*TRIGGER 2=================================================================================================*/
DELIMITER //
CREATE TRIGGER tr_clientepedido_delete AFTER DELETE
ON PEDIDOS
FOR EACH ROW
BEGIN
    UPDATE CLIENTE_PEDIDO SET QUANTIDADE_PED = QUANTIDADE_PED -1
	WHERE COD_CLI = OLD.COD_CLI;
	END //

/*PROCEDURE 1================================================================================================*/
DELIMITER ;;
CREATE PROCEDURE SP_VER_QUANTIDADE (VAR_QUANTIDADE SMALLINT)
SELECT CONCAT('VOCÊ TEM: ', QUANTIDADE) AS QUANTIDADE, DESCRICAO
FROM ESTOQUE
WHERE COD_PECA = VAR_QUANTIDADE;
;;
CALL SP_VER_QUANTIDADE(3608);

/*PROCEDURE 2===============================================================================================*/
DELIMITER ///
CREATE PROCEDURE SP_INSERIR_CLIENTE (
VARCOD INT(10),
VARNOME VARCHAR(50)
)
BEGIN
INSERT INTO CLIENTE (COD_CLI, NOME) VALUES (VARCOD, VARNOME);
END ///
CALL SP_INSERIR_CLIENTE('5','TESTE');
SELECT * FROM CLIENTE;
/*==========================================================================================================*/