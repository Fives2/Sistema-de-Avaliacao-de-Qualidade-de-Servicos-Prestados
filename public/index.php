<!DOCTYPE html>
<html lang="pt-BR">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Avaliação de Qualidade</title>
    <link rel="stylesheet" href="css/avaliacao.css">
    <link rel="stylesheet" href="css/botao_avaliacao.css">
    <link rel="icon" href="favicon.ico">
</head>

<body>
    <div class="container_avaliacao">

        <!-- TELA INICIAL -->
        <div id="telaInicial" class="tela">
            <h1>Avaliação de Qualidade</h1>
            <p class="intro">Deseja avaliar o serviço?</p>
            <button id="btnIniciar" class="btn-principal">Avaliar</button>
        </div>

        <!-- TELAS DAS PERGUNTAS -->
        <div id="telaPerguntas" class="tela hidden">
            <div class="progresso">
                <div class="barra" id="barraProgresso"></div>
            </div>
            <p class="contador"><span id="atual">1</span> de <span id="total">0</span></p>

            <div id="perguntaContainer"></div>

            <div class="navegacao">
                <button id="btnVoltar" class="btn-secundario" disabled>Voltar</button>
                <button id="btnProximo" class="btn-principal">Avançar</button>
            </div>
        </div>

        <!-- TELA DE FEEDBACK -->
        <div id="telaFeedback" class="tela hidden">
            <h2>Feedback (opcional)</h2>
            <p>Em poucas palavras, descreva o que motivou sua nota:</p>
            <textarea id="feedback" placeholder="Ex: 'Atendimento rápido, mas ambiente sujo...'"></textarea>
            <button id="btnEnviar" class="btn-principal">ENVIAR AVALIAÇÃO</button>
        </div>

        <!-- TELA DE OBRIGADO -->
        <div id="telaObrigado" class="tela hidden">
            <h2>Obrigado!</h2>
            <p>O Estabelecimento agradece sua resposta. Ela é muito importante para nós.</p>
            <button onclick="location.reload()" class="btn-principal">Nova Avaliação</button>
        </div>
    </div>

        <!-- RODAPÉ FIXO EM TODAS AS TELAS -->
        <footer class="rodape-avaliacao">
            <p>Sua avaliação espontânea é anônima, nenhuma informação pessoal é solicitada ou armazenada.</p>
        </footer>

    <input type="hidden" id="dispositivo" value="1">  <!-- Código do dispositivo ex -->
    <script src="js/perguntas.js"></script>
</body>

</html>