/*INSERTS:*/ 

-- Endereços
INSERT INTO endereco (rua, numero, cidade, estado, cep) VALUES
('Av. Central', '100', 'Brasília', 'DF', '70000000'),
('Rua das Flores', '200', 'São Paulo', 'SP', '01001000');

-- Clientes
INSERT INTO cliente (nome, CPF, data_nascimento, telefone, endereco) VALUES
('João Silva', '12345678901', '1990-05-20', '61999998888', 1),
('Maria Souza', '98765432100', '1985-11-10', '61988887777', 2);

-- Dependentes
INSERT INTO dependente (id_cliente, parentesco, data_nascimento, nome) VALUES
(1, 'Filho', '2015-03-15', 'Pedro Silva'),
(2, 'Filha', '2010-07-22', 'Ana Souza');

-- Agências
INSERT INTO agencia (nome_agencia, endereco_agencia) VALUES
('Agência Central', 1),
('Agência Paulista', 2);

-- Gerentes
INSERT INTO gerente (id_gerente, nome, CPF, telefone, id_agencia) VALUES
(1, 'Carlos Lima', '11122233344', '61977776666', 1),
(2, 'Fernanda Alves', '55566677788', '1133334444', 2);

-- Contas
INSERT INTO conta (numero_conta, saldo, data_abertura, id_cliente, id_agencia) VALUES
('0001-1', 1500.00, '2023-01-01', 1, 1),
('0002-2', 3000.00, '2023-02-10', 2, 2);

-- Conta Corrente e Poupança
INSERT INTO conta_corrente (id_conta, tarifaMensal) VALUES (1, 25.00);
INSERT INTO conta_poupanca (id_conta, dataRendimento, rendimento) VALUES (2, '2023-12-01', 0.50);

-- Produto Financeiro
INSERT INTO produtoFinanceiro (nomeProduto, descricao, tipoProduto) VALUES
('Seguro de Vida', 'Cobertura completa', 1),
('Empréstimo Pessoal', 'Crédito rápido', 2),
('CDB', 'Certificado de Depósito Bancário', 3);

-- Seguro
INSERT INTO seguro (id_produtoFinanceiro, valorSegurado, tipoCobertura, valorMensalidade)
VALUES (1, 100000.00, 'Vida', 200.00);

-- Empréstimo
INSERT INTO emprestimo (id_produtoFinanceiro, valorEmprestimo, juros, prazoPagamento)
VALUES (2, 5000.00, 2.5, '2026-01-01');

-- Investimento
INSERT INTO investimento (id_produtoFinanceiro, taxaRetorno, prazoResgate)
VALUES (3, 1.2, '2028-12-31');

-- Contrato
INSERT INTO contrata (id_cliente, id_seguro, id_emprestimo) VALUES
(1, 1, 2);

-- Aplicação
INSERT INTO aplicacao (valor, dataAplicacao, id_cliente, id_produtoFinanceiro) VALUES
(2000.00, '2024-01-05', 2, 3);

-- Pagamento
INSERT INTO pagamento (id_pagamento, formaPagamento, dataPagamento, valor, id_contaOrg, id_contaDest) VALUES
(1, 'PIX', NOW(), 500.00, 1, 2),
(2, 'BOLETO', NOW(), 300.00, 2, 1);

-- PIX
INSERT INTO pix (id_pagamento, chaveOrg, chaveDest) VALUES
(1, 'joao@banco.com', 'maria@banco.com');

-- BOLETO
INSERT INTO boleto (id_pagamento, codBarras, dataVencimento) VALUES
(2, '34191876543210987654321098765432109876543210', '2025-10-15');



/****************/

/*UPDATES:*/

-- Atualizar saldo da conta do João após pagamento
UPDATE conta
SET saldo = saldo - 500
WHERE id_conta = 1;

-- Atualizar saldo da conta da Maria após recebimento
UPDATE conta
SET saldo = saldo + 500
WHERE id_conta = 2;

-- Alterar telefone do cliente Maria
UPDATE cliente
SET telefone = '61955554444'
WHERE CPF = '98765432100';

-- Reajustar valor do empréstimo com juros acumulados
UPDATE emprestimo
SET valorEmprestimo = valorEmprestimo * 1.05
WHERE id_produtoFinanceiro = 2;

-- Aumentar rendimento da poupança
UPDATE conta_poupanca
SET rendimento = rendimento + 0.10
WHERE id_conta = 2;