create database Alunos;
use Alunos;

CREATE TYPE prioridade_enum AS ENUM ('baixa', 'media', 'alta');

CREATE TABLE usuarios (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    senha VARCHAR(255) NOT NULL
);

CREATE TABLE categorias (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    usuario_id INT REFERENCES usuarios(id) ON DELETE CASCADE,
    nome VARCHAR(50) NOT NULL,
    CONSTRAINT uq_user_cat UNIQUE (usuario_id, nome)
);

CREATE TABLE tarefas (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    usuario_id INT NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
    categoria_id INT REFERENCES categorias(id) ON DELETE SET NULL,
    titulo VARCHAR(255) NOT NULL,
    concluida BOOLEAN DEFAULT FALSE,
    prioridade prioridade_enum DEFAULT 'media',
    prazo TIMESTAMP,
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_prazo CHECK (prazo >= criado_em)
);

CREATE TABLE subtarefas (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    tarefa_id INT NOT NULL REFERENCES tarefas(id) ON DELETE CASCADE,
    titulo VARCHAR(255) NOT NULL,
    concluida BOOLEAN DEFAULT FALSE
);

CREATE TABLE logs (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    usuario_id INT NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
    acao VARCHAR(50) NOT NULL,
    data_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE OR REPLACE FUNCTION concluir_tarefa(p_id INT, p_user INT) RETURNS VOID AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM tarefas WHERE id = p_id AND usuario_id = p_user) THEN
        RAISE EXCEPTION 'Acesso negado ou invalido';
    END IF;

    IF EXISTS (SELECT 1 FROM subtarefas WHERE tarefa_id = p_id AND NOT concluida) THEN
        RAISE EXCEPTION 'Subtarefas pendentes';
    END IF;

    UPDATE tarefas SET concluida = TRUE WHERE id = p_id;
    INSERT INTO logs (usuario_id, acao) VALUES (p_user, 'CONCLUIDA_' || p_id);
EXCEPTION 
    WHEN OTHERS THEN
        INSERT INTO logs (usuario_id, acao) VALUES (p_user, 'ERRO_' || SQLSTATE);
        RAISE;
END;
$$ LANGUAGE plpgsql;