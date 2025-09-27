-- Vou separar os arquivos em "Schema" (criação e modificação de tabelas), "Data" (inserção, deleção e etc) e "Queries" (consultas no banco de dados)
CREATE DATABASE IF NOT EXISTS sistema_financeiro;
USE sistema_financeiro;

CREATE TABLE cliente (
	id_Cliente INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255),
    CPF VARCHAR(11) UNIQUE,
    data_Nascimento DATE,
    telefone VARCHAR(20),
    endereco INT,
    
    -- Cliente mora em Endereço
    CONSTRAINT fk_EnderecoCliente FOREIGN KEY (endereco) REFERENCES Endereco (id_Endereco)
	ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE dependente (
	id_dependente INT UNSIGNED AUTO_INCREMENT NOT NULL,
    id_cliente INT UNSIGNED NOT NULL,
    parentesco VARCHAR(255),
    data_Nascimento DATE,
    nome VARCHAR(255),
    
    -- Cliente pode ter Dependente
    CONSTRAINT fk_ClienteDependente FOREIGN KEY (id_cliente) REFERENCES Cliente (id_Cliente)
	ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE endereco (
	id_Endereco INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	rua VARCHAR(100),
    numero VARCHAR(10),
    cidade VARCHAR(50),
    estado VARCHAR(2),
    cep VARCHAR(10)
);

CREATE TABLE gerente (
	id_Gerente INT UNSIGNED PRIMARY KEY,
    nome VARCHAR (255),
    CPF VARCHAR(11),
    telefone VARCHAR(20),
    id_Agencia INT NOT NULL,
    
    -- Gerente atua em agencia
    CONSTRAINT fk_AgenciaGerente FOREIGN KEY (id_Agencia) REFERENCES Agencia (id_Agencia)
    ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE agencia (
	id_Agencia INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nome_Agencia VARCHAR(255),
    endereco_Agencia INT NOT NULL,
    
    -- Agencia tem Endereço
    CONSTRAINT fk_EnderecoAgencia FOREIGN KEY (endereco_Agencia) REFERENCES Endereco (id_Endereco)
    ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE conta (
	id_Conta INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    numero_Conta VARCHAR(15) NOT NULL,
    saldo DECIMAL(15,2) DEFAULT 0.0,
    data_Abertura DATE DEFAULT CURDATE(),
    id_Cliente INT NOT NULL,
    id_agencia INT UNSIGNED NOT NULL,
    
    -- Cliente possui Conta
    CONSTRAINT fk_ClienteConta FOREIGN KEY (id_Cliente) REFERENCES Cliente (id_Cliente)
    ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT FK_ContaAgen FOREIGN KEY (id_agencia) REFERENCES agencia(id_agencia)
    ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE conta_corrente(
	id_conta INT UNSIGNED PRIMARY KEY,
    tarifaMensal DECIMAL(5,2) NOT NULL, 
    
    CONSTRAINT FK_contaCOR FOREIGN KEY (id_conta) REFERENCES conta(id_conta)
    ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE conta_poupanca(
	id_conta INT UNSIGNED PRIMARY KEY,
    dataRendimento DATE DEFAULT CURDATE(),
	rendimento DECIMAL(5,2) NOT NULL,
    
    CONSTRAINT FK_contaPOU FOREIGN KEY (id_conta) REFERENCES conta(id_conta)
    ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE conta_investimento(
	id_conta INT UNSIGNED PRIMARY KEY,
    tipoInvestimento VARCHAR(63) NOT NULL,
    valorAplicado DECIMAL(11, 2) NOT NULL,
    
    CONSTRAINT FK_contaINV FOREIGN KEY (id_conta) REFERENCES conta(id_conta)
    ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE produtoFinanceiro(
	id_produtoFinanceiro INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	nomeProduto VARCHAR(127) NOT NULL,
    descricao VARCHAR(255) NOT NULL,
    tipoProduto TINYINT UNSIGNED NOT NULL
);

CREATE TABLE seguro(
	id_produtoFinanceiro INT UNSIGNED PRIMARY KEY,
	valorSegurado DECIMAL(11, 2) NOT NULL,
	tipoCobertura VARCHAR(127) NOT NULL,
    valorMensalidade DECIMAL(9,2) NOT NULL,
    
    CONSTRAINT FK_produtoFinanceiroSEG FOREIGN KEY (id_produtoFinanceiro) REFERENCES produtoFinanceiro(id_produtoFinanceiro)
    ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE emprestimo(
	id_produtoFinanceiro INT UNSIGNED PRIMARY KEY,
    valorEmprestimo DECIMAL(11,2) NOT NULL,
    juros DECIMAL (6,2) NOT NULL,
    prazoPagamento DATE NOT NULL,
    
    CONSTRAINT FK_produtoFinanceiroEMP FOREIGN KEY (id_produtoFinanceiro) REFERENCES produtoFinanceiro(id_produtoFinanceiro)
    ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE investimento(
	id_produtoFinanceiro INT UNSIGNED PRIMARY KEY,
    taxaRetorno DECIMAL(6,2) NOT NULL,
    prazoResgate DATE NOT NULL,
    
    CONSTRAINT FK_produtoFinanceiroINV FOREIGN KEY (id_produtoFinanceiro) REFERENCES produtoFinanceiro(id_produtoFinanceiro)
    ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE pagamento(
	id_pagamento INT UNSIGNED PRIMARY KEY,
    formaPagamento VARCHAR(127) NOT NULL,
    dataPagamento TIMESTAMP NOT NULL,
    valor DECIMAL(13,2) NOT NULL,
    
    id_contaOrg INT UNSIGNED,
    id_contaDest INT UNSIGNED,
    
    CONSTRAINT FK_pagContaOrg FOREIGN KEY (id_contaOrg) REFERENCES conta(id_conta)
    ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT FK_pagContaDest FOREIGN KEY (id_contaDest) REFERENCES conta(id_conta)
    ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE pix(
	id_pagamento INT UNSIGNED PRIMARY KEY,
	chaveOrg VARCHAR(255) NOT NULL,
    chaveDest VARCHAR(255) NOT NULL,
    
    CONSTRAINT FK_pagPIX FOREIGN KEY (id_pagamento) REFERENCES pagamento(id_pagamento)
    ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE boleto(
	id_pagamento INT UNSIGNED PRIMARY KEY,
	codBarras VARCHAR(127) NOT NULL,
    dataVencimento DATE NOT NULL,
    
    CONSTRAINT FK_pagBOL FOREIGN KEY (id_pagamento) REFERENCES pagamento(id_pagamento)
    ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE contrata(
	id_contrato INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	id_cliente INT UNSIGNED NOT NULL,
    id_seguro INT UNSIGNED,
    id_emprestimo INT UNSIGNED,
    
    CONSTRAINT FK_ContratoCliente FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
    ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT FK_ContratoSeg FOREIGN KEY (id_seguro) REFERENCES produtofinanceiro(id_produtofinanceiro)
    ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT FK_ContratoEmp FOREIGN KEY (id_emprestimo) REFERENCES produtofinanceiro(id_produtofinanceiro)
    ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE aplicacao (
	id_aplicacao INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    valor DECIMAL(13,2) NOT NULL,
    dataAplicacao TIMESTAMP NOT NULL,
    id_cliente INT UNSIGNED NOT NULL,
    id_produtoFinanceiro INT UNSIGNED NOT NULL,
    
    CONSTRAINT FK_AplicacaoCliente FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
    ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT FK_AplicacaoProd FOREIGN KEY (id_produtoFinanceiro) REFERENCES produtoFinanceiro(id_produtoFinanceiro)
    ON UPDATE CASCADE ON DELETE RESTRICT
);









