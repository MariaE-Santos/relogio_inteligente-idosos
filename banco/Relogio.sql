CREATE DATABASE relogio_inteligente;
USE relogio_inteligente;

CREATE TABLE usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100),
    idade INT,
    telefone VARCHAR(20),
    endereco VARCHAR(150),
    data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE responsaveis (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100),
    telefone VARCHAR(20),
    email VARCHAR(100)
);

CREATE TABLE usuario_responsavel (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT,
    responsavel_id INT,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
    FOREIGN KEY (responsavel_id) REFERENCES responsaveis(id)
);

CREATE TABLE medicoes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT,
    movimento DECIMAL(10,2),
    batimentos_cardiacos INT,
    status_queda ENUM('Nenhuma', 'Leve', 'Grave'),
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);

CREATE TABLE configuracoes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT,
    limite_queda_leve DECIMAL(10,2),
    limite_queda_grave DECIMAL(10,2),
    tempo_resposta INT,
    ultima_atualizacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);

CREATE TABLE log_eventos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT,
    evento ENUM('Queda Leve', 'Queda Grave', 'Alerta Enviado', 'Emergencia Acionada'),
    descricao TEXT,
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);

CREATE TABLE alertas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT,
    responsavel_id INT,
    tipo ENUM('Notificacao', 'Emergencia'),
    status ENUM('Enviado', 'Recebido', 'Cancelado'),
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
    FOREIGN KEY (responsavel_id) REFERENCES responsaveis(id)
);

INSERT INTO usuarios (nome, idade, telefone, endereco) VALUES
('João Silva', 72, '11999999999', 'Rua A, 123'),
('Dona Maria', 80, '11977777777', 'Rua B, 456');

INSERT INTO responsaveis (nome, telefone, email) VALUES
('Carlos Silva', '11988888888', 'carlos@email.com'),
('Ana Souza', '11966666666', 'ana@email.com');

INSERT INTO usuario_responsavel (usuario_id, responsavel_id) VALUES
(1,1),
(2,2);

INSERT INTO configuracoes (usuario_id, limite_queda_leve, limite_queda_grave, tempo_resposta) VALUES
(1, 1.5, 3.0, 10),
(2, 1.2, 2.8, 8);

INSERT INTO medicoes (usuario_id, movimento, batimentos_cardiacos, status_queda) VALUES
(1, 0.3, 72, 'Nenhuma'),
(1, 1.8, 85, 'Leve'),
(1, 4.2, 110, 'Grave'),

(2, 0.5, 70, 'Nenhuma'),
(2, 2.0, 88, 'Leve'),
(2, 3.5, 105, 'Grave');

INSERT INTO log_eventos (usuario_id, evento, descricao) VALUES
(1, 'Queda Leve', 'Usuário sofreu leve impacto'),
(1, 'Alerta Enviado', 'Família notificada'),
(1, 'Queda Grave', 'Sem resposta do usuário'),
(1, 'Emergencia Acionada', 'SAMU acionado'),

(2, 'Queda Grave', 'Usuário caiu no banheiro'),
(2, 'Alerta Enviado', 'Responsável informado');

INSERT INTO alertas (usuario_id, responsavel_id, tipo, status) VALUES
(1,1,'Notificacao','Recebido'),
(1,1,'Emergencia','Enviado'),

(2,2,'Notificacao','Recebido'),
(2,2,'Emergencia','Cancelado');

SELECT * FROM medicoes ORDER BY data_hora DESC;

SELECT u.nome, m.movimento, m.batimentos_cardiacos, m.data_hora
FROM medicoes m
JOIN usuarios u ON m.usuario_id = u.id
WHERE m.status_queda = 'Grave';

SELECT u.nome AS usuario, r.nome AS responsavel, a.tipo, a.status
FROM alertas a
JOIN usuarios u ON a.usuario_id = u.id
JOIN responsaveis r ON a.responsavel_id = r.id;

SELECT u.nome, l.evento, l.descricao, l.data_hora
FROM log_eventos l
JOIN usuarios u ON l.usuario_id = u.id
ORDER BY l.data_hora DESC;




