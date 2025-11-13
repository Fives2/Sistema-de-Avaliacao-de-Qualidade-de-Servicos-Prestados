const telas = {
    inicial: document.getElementById('telaInicial'),
    perguntas: document.getElementById('telaPerguntas'),
    feedback: document.getElementById('telaFeedback'),
    obrigado: document.getElementById('telaObrigado')
};

const elementos = {
    btnIniciar: document.getElementById('btnIniciar'),
    btnVoltar: document.getElementById('btnVoltar'),
    btnProximo: document.getElementById('btnProximo'),
    btnEnviar: document.getElementById('btnEnviar'),
    perguntaContainer: document.getElementById('perguntaContainer'),
    barraProgresso: document.getElementById('barraProgresso'),
    atualSpan: document.getElementById('atual'),
    totalSpan: document.getElementById('total'),
    feedbackTextarea: document.getElementById('feedback'),
    dispositivo: document.getElementById('dispositivo')
};

let perguntas = [];
let indiceAtual = 0;
let respostas = {};

// Iniciar
elementos.btnIniciar.addEventListener('click', () => {
    carregarPerguntas();
});

// Carregar perguntas do banco
function carregarPerguntas() {
    fetch('php/perguntas.php')
        .then(r => r.json())
        .then(data => {
            if (!data.length) {
                alert("Nenhuma pergunta cadastrada.");
                return;
            }
            perguntas = data;
            elementos.totalSpan.textContent = perguntas.length;
            mostrarTela('perguntas');
            mostrarPergunta(0);
        })
        .catch(() => alert("Erro ao carregar perguntas."));
}

// Mostrar tela
function mostrarTela(tela) {
    Object.values(telas).forEach(t => t.classList.add('hidden'));
    telas[tela].classList.remove('hidden');
}

// Mostrar pergunta atual
function mostrarPergunta(indice) {
    indiceAtual = indice;
    const p = perguntas[indice];

    elementos.atualSpan.textContent = indice + 1;
    elementos.barraProgresso.style.width = `${((indice + 1) / perguntas.length) * 100}%`;

    elementos.perguntaContainer.innerHTML = `
        <div class="pergunta">
            <h3>${p.pegtexto}</h3>
            <div class="escala">
                ${Array.from({length: 11}, (_, i) => `
                    <label>
                        <input type="radio" name="p${p.pegcodigo}" value="${i}" 
                               ${respostas[p.pegcodigo] === i ? 'checked' : ''}>
                        <span>${i}</span>
                    </label>
                `).join('')}
            </div>
        </div>
    `;

    // Atualizar botões
    elementos.btnVoltar.disabled = indice === 0;
    elementos.btnProximo.textContent = indice === perguntas.length - 1 ? 'Concluir' : 'Avançar';

    // Eventos dos radios
    document.querySelectorAll('input[type="radio"]').forEach(radio => {
        radio.addEventListener('change', () => {
            respostas[p.pegcodigo] = parseInt(radio.value);
            habilitarAvancar();
        });
    });

    habilitarAvancar();
}

function habilitarAvancar() {
    const respondida = respostas[perguntas[indiceAtual].pegcodigo] !== undefined;
    elementos.btnProximo.disabled = !respondida;
}

// Navegação
elementos.btnProximo.addEventListener('click', () => {
    if (indiceAtual === perguntas.length - 1) {
        mostrarTela('feedback');
    } else {
        mostrarPergunta(indiceAtual + 1);
    }
});

elementos.btnVoltar.addEventListener('click', () => {
    if (indiceAtual > 0) {
        mostrarPergunta(indiceAtual - 1);
    }
});

// Enviar
elementos.btnEnviar.addEventListener('click', () => {
    const data = {
        dispositivo: elementos.dispositivo.value,
        respostas: respostas,
        feedback: elementos.feedbackTextarea.value.trim()
    };

    elementos.btnEnviar.disabled = true;
    elementos.btnEnviar.textContent = 'ENVIANDO...';

    fetch('submit.php', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(data)
    })
    .then(r => r.json())
    .then(result => {
        if (result.success) {
            mostrarTela('obrigado');
        } else {
            alert('Erro: ' + (result.message || 'Tente novamente.'));
            elementos.btnEnviar.disabled = false;
            elementos.btnEnviar.textContent = 'ENVIAR AVALIAÇÃO';
        }
    })
    .catch(() => {
        alert('Erro de conexão. Verifique sua internet.');
        elementos.btnEnviar.disabled = false;
        elementos.btnEnviar.textContent = 'ENVIAR AVALIAÇÃO';
    });
});