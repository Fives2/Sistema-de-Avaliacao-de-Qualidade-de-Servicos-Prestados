-- ===========================
-- TABELA: SETOR
-- ===========================
CREATE TABLE setor (
    setcodigo     INTEGER NOT NULL,
    setnome       VARCHAR(100) NOT NULL,
    setstatus     SMALLINT DEFAULT 1 NOT NULL,
    CONSTRAINT setor_status_check CHECK (setstatus >= 0 AND setstatus <= 1)
);

COMMENT ON TABLE setor IS 'Tabela dos setores do sistema';
COMMENT ON COLUMN setor.setcodigo IS 'Código identificador do setor';
COMMENT ON COLUMN setor.setnome IS 'Nome do setor';
COMMENT ON COLUMN setor.setstatus IS 'Status do setor';

ALTER TABLE setor ADD CONSTRAINT setor_pk PRIMARY KEY (setcodigo);

-- ===========================
-- TABELA: DISPOSITIVOS
-- ===========================
CREATE TABLE dispositivo (
    discodigo INTEGER NOT NULL,
    disnome   VARCHAR(100) NOT NULL,
    disstatus SMALLINT DEFAULT 1 NOT NULL,
    setcodigo INTEGER
    CONSTRAINT dispositivo_status_check CHECK (disstatus >= 0 AND disstatus <= 1)
);

COMMENT ON TABLE dispositivo IS 'Tabela dos dispositivos do sistema';
COMMENT ON COLUMN dispositivo.discodigo IS 'Código identificador do dispositivo';
COMMENT ON COLUMN dispositivo.disnome IS 'Nome do dispositivo';
COMMENT ON COLUMN dispositivo.disstatus IS 'Status do dispositivo';

ALTER TABLE dispositivo ADD CONSTRAINT dispositivo_pk PRIMARY KEY (discodigo);

ALTER TABLE dispositivo ADD CONSTRAINT dispositivo_setor_fk FOREIGN KEY (setcodigo) REFERENCES setor (setcodigo);

-- ===========================
-- TABELA: PERGUNTAS
-- ===========================
CREATE TABLE pergunta (
    pegcodigo INTEGER NOT NULL,
    pegtexto  VARCHAR(200) NOT NULL,
    pegstatus SMALLINT DEFAULT 1 NOT NULL,
    CONSTRAINT pergunta_status_check CHECK (pegstatus >= 0 AND pegstatus <= 1)
);

COMMENT ON TABLE pergunta IS 'Tabela das perguntas do sistema';
COMMENT ON COLUMN pergunta.pegcodigo IS 'Código identificador da pergunta';
COMMENT ON COLUMN pergunta.pegtexto IS 'Texto da pergunta';
COMMENT ON COLUMN pergunta.pegstatus IS 'Status da pergunta';

ALTER TABLE pergunta ADD CONSTRAINT pergunta_pk PRIMARY KEY (pegcodigo);

-- ===========================
-- TABELA: AVALIACOES (nova tabela substituindo avaliacao, avaliacaopergunta e resposta)
-- ===========================
CREATE TABLE avaliacoes (
    avacodigo     INTEGER NOT NULL,
    setcodigo     INTEGER NOT NULL,
    pegcodigo     INTEGER NOT NULL,
    discodigo     INTEGER NOT NULL,
    resnota       SMALLINT NOT NULL,
    resfeedback   VARCHAR(300),
    avadatahora   TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT avaliacoes_resnota_check CHECK (resnota >= 0 AND resnota <= 10)
);

COMMENT ON TABLE avaliacoes IS 'Tabela das avaliações do sistema';
COMMENT ON COLUMN avaliacoes.avacodigo IS 'ID da avaliação (PK)';
COMMENT ON COLUMN avaliacoes.setcodigo IS 'ID do setor (FK)';
COMMENT ON COLUMN avaliacoes.pegcodigo IS 'ID da pergunta (FK)';
COMMENT ON COLUMN avaliacoes.discodigo IS 'ID do dispositivo (FK)';
COMMENT ON COLUMN avaliacoes.resnota IS 'Resposta (0 a 10) (obrigatório)';
COMMENT ON COLUMN avaliacoes.resfeedback IS 'Feedback Textual (opcional)';
COMMENT ON COLUMN avaliacoes.avadatahora IS 'Data/Hora da avaliação (obrigatório – data/hora atuais)';

ALTER TABLE avaliacoes ADD CONSTRAINT avaliacoes_pk PRIMARY KEY (avacodigo);
ALTER TABLE avaliacoes ADD CONSTRAINT avaliacoes_setor_fk FOREIGN KEY (setcodigo) REFERENCES setor (setcodigo);
ALTER TABLE avaliacoes ADD CONSTRAINT avaliacoes_pergunta_fk FOREIGN KEY (pegcodigo) REFERENCES pergunta (pegcodigo);
ALTER TABLE avaliacoes ADD CONSTRAINT avaliacoes_dispositivo_fk FOREIGN KEY (discodigo) REFERENCES dispositivo (discodigo);

-- Dados de exemplo
INSERT INTO setor (setcodigo, setnome) VALUES
(1, 'Atendimento'),
(2, 'Financeiro'),
(3, 'Vendas');

INSERT INTO dispositivo (discodigo, disnome, setcodigo) VALUES 
(1, 'tablet1', 1),
(2, 'tablet2', 1),
(3, 'tablet3', 1);

INSERT INTO pergunta (pegcodigo, pegtexto) VALUES
(1, 'Como você avalia o atendimento recebido?'),
(2, 'O ambiente está limpo e organizado?'),
(3, 'O tempo de espera foi adequado?');

/* MODIFICAR alterar a tabela avaliacoes adicionar mais pks*/