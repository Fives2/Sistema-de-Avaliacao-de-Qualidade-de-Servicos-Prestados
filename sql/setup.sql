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
    CONSTRAINT dispositivo_status_check CHECK (disstatus >= 0 AND disstatus <= 1)
);

COMMENT ON TABLE dispositivo IS 'Tabela dos dispositivos do sistema';
COMMENT ON COLUMN dispositivo.discodigo IS 'Código identificador do dispositivo';
COMMENT ON COLUMN dispositivo.disnome IS 'Nome do dispositivo';
COMMENT ON COLUMN dispositivo.disstatus IS 'Status do dispositivo';

ALTER TABLE dispositivo ADD CONSTRAINT dispositivo_pk PRIMARY KEY (discodigo);

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
-- TABELA: AVALIAÇÃO
-- ===========================
CREATE TABLE avaliacao (
    avacodigo     INTEGER NOT NULL,
    discodigo     INTEGER NOT NULL,
    avadatahora   TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL
);

COMMENT ON TABLE avaliacao IS 'Tabela das avaliações do sistema';
COMMENT ON COLUMN avaliacao.avacodigo IS 'Código identificador da avaliação';
COMMENT ON COLUMN avaliacao.discodigo IS 'Código identificador do dispositivo';
COMMENT ON COLUMN avaliacao.avadatahora IS 'Data e hora da avaliação';

ALTER TABLE avaliacao ADD CONSTRAINT avaliacao_pk PRIMARY KEY (avacodigo);
ALTER TABLE avaliacao ADD CONSTRAINT avaliacao_dispositivo_fk FOREIGN KEY (discodigo) REFERENCES dispositivo (discodigo);

-- ===========================
-- TABELA: AVALIAÇÃO_PERGUNTA (antigo ratingquestions)
-- ===========================
CREATE TABLE avaliacaopergunta (
    avpcodigo INTEGER NOT NULL,
    avacodigo INTEGER NOT NULL,
    pegcodigo INTEGER NOT NULL
);

COMMENT ON TABLE avaliacaopergunta IS 'Tabela de ligação entre avaliações e perguntas';
COMMENT ON COLUMN avaliacaopergunta.avpcodigo IS 'Código identificador da avaliação-pergunta';
COMMENT ON COLUMN avaliacaopergunta.avacodigo IS 'Código da avaliação';
COMMENT ON COLUMN avaliacaopergunta.pegcodigo IS 'Código da pergunta';

ALTER TABLE avaliacaopergunta ADD CONSTRAINT avaliacaopergunta_pk PRIMARY KEY (avpcodigo);
ALTER TABLE avaliacaopergunta ADD CONSTRAINT avaliacaopergunta_avaliacao_fk FOREIGN KEY (avacodigo) REFERENCES avaliacao (avacodigo);
ALTER TABLE avaliacaopergunta ADD CONSTRAINT avaliacaopergunta_pergunta_fk FOREIGN KEY (pegcodigo) REFERENCES pergunta (pegcodigo);

-- ===========================
-- TABELA: RESPOSTAS
-- ===========================
CREATE TABLE resposta (
    avpcodigo     INTEGER NOT NULL,
    resnota       SMALLINT NOT NULL,
    resfeedback   VARCHAR(300),
    CONSTRAINT resposta_resnota_check CHECK (resnota >= 0 AND resnota <= 10)
);

COMMENT ON TABLE resposta IS 'Tabela de respostas das avaliações';
COMMENT ON COLUMN resposta.avpcodigo IS 'Código da relação avaliação-pergunta';
COMMENT ON COLUMN resposta.resnota IS 'Nota atribuída à pergunta (0-10)';
COMMENT ON COLUMN resposta.resfeedback IS 'Comentário ou observação do respondente';

ALTER TABLE resposta ADD CONSTRAINT resposta_pk PRIMARY KEY (avpcodigo);
ALTER TABLE resposta ADD CONSTRAINT resposta_avaliacaopergunta_fk FOREIGN KEY (avpcodigo) REFERENCES avaliacaopergunta (avpcodigo);

-- Dados de exemplo
INSERT INTO dispositivo (discodigo, disnome) VALUES 
(1, 'Recepção'),
(2, 'Caixa'),
(3, 'Vendas');

INSERT INTO pergunta (pegcodigo, pegtexto) VALUES
(1, 'Como você avalia o atendimento recebido?'),
(2, 'O ambiente está limpo e organizado?'),
(3, 'O tempo de espera foi adequado?');