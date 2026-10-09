CREATE DATABASE agenda;
USE agenda;

CREATE TABLE usuario (
    usuario_id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    senha VARCHAR(255) NOT NULL
);

CREATE TABLE categoria (
    categoria_id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    nome VARCHAR(50) NOT NULL,

    CONSTRAINT uq_user_cat
        UNIQUE (usuario_id, nome),

    FOREIGN KEY (usuario_id)
        REFERENCES usuario(usuario_id)
        ON DELETE CASCADE
);

CREATE TABLE tarefa (
    tarefa_id INT AUTO_INCREMENT PRIMARY KEY,

    usuario_id INT NOT NULL,
    categoria_id INT NULL,

    titulo VARCHAR(255) NOT NULL,
    descricao TEXT,

    concluida BOOLEAN DEFAULT FALSE,

    prioridade ENUM('baixa', 'media', 'alta')
        DEFAULT 'media',

    prazo TIMESTAMP NULL,

    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_prazo
        CHECK (prazo IS NULL OR prazo >= criado_em),

    FOREIGN KEY (usuario_id)
        REFERENCES usuario(usuario_id)
        ON DELETE CASCADE,

    FOREIGN KEY (categoria_id)
        REFERENCES categoria(categoria_id)
        ON DELETE SET NULL
);

CREATE TABLE subtarefa (
    subtarefa_id INT AUTO_INCREMENT PRIMARY KEY,

    tarefa_id INT NOT NULL,

    titulo VARCHAR(255) NOT NULL,

    concluida BOOLEAN DEFAULT FALSE,

    FOREIGN KEY (tarefa_id)
        REFERENCES tarefa(tarefa_id)
        ON DELETE CASCADE
);

CREATE TABLE logs (
    logs_id INT AUTO_INCREMENT PRIMARY KEY,

    usuario_id INT NOT NULL,

    acao VARCHAR(100) NOT NULL,

    data_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (usuario_id)
        REFERENCES usuario(usuario_id)
        ON DELETE CASCADE
);

DELIMITER $$

CREATE PROCEDURE concluir_tarefa (
    IN p_id INT,
    IN p_user INT
)
BEGIN

    DECLARE qtd_tarefa INT;
    DECLARE qtd_subtarefas INT;

    SELECT COUNT(*)
    INTO qtd_tarefa
    FROM tarefa
    WHERE tarefa_id = p_id
      AND usuario_id = p_user;

    IF qtd_tarefa = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'Acesso negado ou tarefa inexistente';
    END IF;

    SELECT COUNT(*)
    INTO qtd_subtarefas
    FROM subtarefa
    WHERE tarefa_id = p_id
      AND concluida = FALSE;

    IF qtd_subtarefas > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'Existem subtarefas pendentes';
    END IF;


    UPDATE tarefa
    SET concluida = TRUE
    WHERE tarefa_id = p_id;

    INSERT INTO logs (usuario_id, acao)
    VALUES (
        p_user,
        CONCAT('CONCLUIDA_', p_id)
    );

END$$

DELIMITER ;
