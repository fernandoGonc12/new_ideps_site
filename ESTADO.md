# Estado do painel de administração — IDEPS

> Arquivo de continuidade. Sempre que uma etapa mudar, atualize aqui.
> **Última atualização:** 02/10/2026 (painel completo)

---

## 1. Infraestrutura — **JÁ ESTÁ LIGADA** ✅

Ao contrário do que parecia, o Supabase **já foi criado, configurado e populado**.
Verificado por chamada real à API nesta data:

| Item | Estado | Como foi verificado |
|---|---|---|
| Projeto Supabase | ✅ no ar | `GET /auth/v1/health` → 200, GoTrue v2.196.0 |
| URL | `https://asyqrlmdeptztggapdnn.supabase.co` | — |
| Chave pública | `sb_publishable_2MwWorspfb9vupsGpmsGyw_qKz9IG-N` | preenchida em `admin.html` e `index.html` |
| Tabela `projetos` | ✅ criada | `GET /rest/v1/projetos` → 200 |
| Os 11 projetos iniciais | ✅ carregados | retorno com `quem-somos-60`, `bem-estar`, etc. |
| RLS de leitura pública | ✅ ativa | anônimo lê só `publicado = true` |
| RLS de escrita | ✅ bloqueando | `POST` anônimo → `42501 row-level security` |
| Bucket `capas` | ✅ existe, vazio | `POST /storage/v1/object/list/capas` → `[]` |
| Cadastro público desligado | ✅ | `/auth/v1/settings` → `"disable_signup": true` |

Os 4 passos do `dados/LEIA-ME.md` estão todos concluídos.

### Única coisa que não dá para verificar daqui
Se **o seu usuário de login já existe** em *Authentication → Users*. Como o
cadastro público está desligado, ele tem que ter sido criado à mão no painel.
Teste: sirva a pasta (`python -m http.server 8000`), abra `admin.html` e tente
entrar. Se não entrar, crie em **Authentication → Users → Add user**.

---

## 2. O que você precisa fazer ⚠️

O código está todo ligado. Faltam passos que só quem tem acesso ao Supabase
consegue dar:

1. **Rodar `dados/fotos-e-acesso.sql`** no SQL Editor. Sem ele, enviar fotos
   e apagar capas falha (o painel avisa) e a lista de Quem tem acesso não
   aparece. O carrossel e as Páginas funcionam mesmo sem ele.
2. **Rodar `dados/corrige-participar-e-preciso.sql`**. Os dados reais desse
   projeto (termo 32.074/2022, R$ 112.500,00, 338 inscritos) foram para
   `dados/projetos.json` em 02/09/2026, mas nunca para o banco — e o banco
   vence. Hoje o site mostra o rascunho ("R$ 000.000,00", termo de 2016).
3. **Números do topo → Desde:** o banco ainda tem `2014`; o documento
   institucional diz **2017**. Agora isso pesa mais: o ano aparece também
   no selo da capa ("desde 2014"), na linha do tempo e na ficha de Quem somos.
4. **Contato e rodapé → Endereço:** o banco tem `Rua Dona Rosemaria, 633`; o
   documento escreve **Rua Dona Rosa Maria, 633**. Confirmar qual é o certo
   (o mapa da página de contato usa esse texto).

---

## 3. O que funciona

### `index.html` (site público)
- Lê do banco: projetos publicados, números, contato, rodapé, o carrossel da
  capa e **todos os textos das páginas** (Início, Quem somos, Projetos,
  Contato, Cursos), inclusive os quatro grupos de atividades, missão, visão,
  valores e parceiros.
- Cascata de resiliência: **Supabase → `localStorage` → padrões**. Para
  projetos o último degrau é `dados/projetos.json`; para o resto,
  `dados/padroes.js`. Testado com o banco fora do ar: o site sai igual ao
  original.
- Tudo o que vem do banco passa por `esc()`: HTML digitado no painel aparece
  como texto.

### `dados/padroes.js` (novo)
Os padrões de números, contato, carrossel e textos, num arquivo só que o site e
o painel carregam. Também **descreve os campos de cada página** — o painel monta
o formulário a partir dele. Para tornar editável um texto novo: acrescente o
campo aqui, use `TEXTOS.<pagina>.<campo>` no `index.html` e suba o `?v=` das
duas tags `<script>` que carregam o arquivo.

### `admin.html` (painel) — nenhuma tela de demonstração restante
- **Avisos e novidades** — banners no alto da página inicial. Cada um tem
  tipo (Novidade, Aviso, Evento, Inscrições abertas — define etiqueta e cor),
  título, texto, botão opcional (página do site, projeto ou endereço externo),
  imagem opcional e período: com datas marcadas, entra e sai do ar sozinho;
  também dá para pausar. Prévia ao vivo, ordem por ↑↓ (grava na hora) e
  contador de avisos no ar no menu. Bloco `avisos` na tabela `conteudo` —
  não precisa de SQL novo. Um aviso sozinho ocupa a largura toda; dois ou
  mais viram cartões lado a lado (empilhados no celular).
- **Projetos**, **Números do topo**, **Contato e rodapé** — como antes. Contato
  ganhou a frase do rodapé.
- **Páginas** — lista as 5 páginas com a data da última edição; cada uma abre
  um formulário por seções, com índice lateral. Títulos obrigatórios; campo
  vazio some do site; `*palavra*` no título da capa vira o grifo amarelo;
  atividades em lista editável (ícone, nome, descrição); botão "Voltar ao
  texto original". Bloco `pagina:<id>` na tabela `conteudo`.
- **Fotos e arquivos** — envio de várias fotos (reduzidas para 1600px no
  navegador antes de subir), galeria do bucket `fotos`, carrossel com ordem e
  descrição obrigatória (bloco `fotos`). Lista as capas enviadas e deixa
  apagar as sem uso. Recusa apagar foto que está no carrossel ou capa em uso.
- **Quem tem acesso** — lista as contas (função `equipe()`), troca da própria
  senha e o passo a passo, com link direto, para criar ou remover contas no
  Supabase.
- Sair de uma tela com alteração não salva agora pede confirmação (antes, o
  menu descartava o que estava sendo digitado).

---

## 4. Como foi testado (02/10/2026)

Servidor local imitando o Supabase, com os dados reais do banco como ponto de
partida, e o Edge headless pilotado pelo protocolo de depuração: o teste edita
no painel, confere o que foi gravado e depois confere o site.
116 verificações passando — 64 do fluxo completo, 37 dos avisos (inclusive
no celular), 7 sem o SQL novo rodado e 8 com o banco fora do ar. O que **não** foi testado contra o Supabase real: o SQL de
`fotos-e-acesso.sql` e o login (não há senha nesta máquina).

---

## 5. Ideias para depois

- **Convidar pessoas pelo próprio painel**: exigiria uma Edge Function no
  Supabase segurando a chave `service_role`. Hoje é pelo painel do Supabase.
- **Foto da seção de cursos** da página inicial ainda é fixa
  (`imagens/jovem-aluna…`). Daria para virar um segundo campo do bloco `fotos`.

## 6. Riscos e observações

- **Nunca** colocar a chave `service_role` em `admin.html` ou `index.html`.
  Ela ignora todo o RLS.
- `dados/projetos.json` é um retrato congelado. Se os projetos mudarem muito
  no banco, vale regerá-lo, senão o fallback mostra conteúdo velho.
- O site é GitHub Pages (arquivos estáticos, sem servidor). Qualquer lógica
  de servidor teria que ser Edge Function do Supabase.
- Para rodar local: `python -m http.server 8000` — `file://` não funciona
  porque o navegador bloqueia as requisições.

---

## 7. Registro de progresso

| Data | O que foi feito |
|---|---|
| 09/09/2026 | Auditoria do estado real; confirmado que o Supabase já está ligado, populado e com RLS ativa. Criado este arquivo. |
| 09/09/2026 | Telas de **Números do topo** e **Contato e rodapé** ligadas ao banco. Criado `dados/conteudo.sql` (tabela `conteudo`, chave→jsonb, com RLS). O `index.html` passou a puxar do painel a faixa de números, a página de contato, o rodapé, o botão Cursos, a sede em Quem somos e o telefone da página de projeto, com valores padrão como rede de segurança. 43 testes de lógica passando (banco no ar, banco fora, valores editados, escape de HTML). **Falta rodar o SQL da §2.** |
| 02/10/2026 | Textos do site reescritos a partir do documento *IDEPS Institucional – quem somos*: nova capa ("Um espaço onde mulheres continuam florescendo"), bloco do Centro de Convivência na home, página Quem somos completa (atividades e serviços, cuidado integral, missão/visão/valores, parceiros), rodapé e contato. Fundação corrigida para **2017** e CNPJ real na ficha. Removida a seção **Transparência** do site (menu, rodapé, rota) e do painel. **Falta no painel:** trocar "Desde" para 2017 em Números do topo e conferir o endereço em Contato (ver §2). |
| 02/10/2026 | **Painel completo.** Páginas, Fotos e arquivos e Quem tem acesso ligados ao banco; nenhuma tela de demonstração restante. Criados `dados/padroes.js` (padrões compartilhados e descrição dos campos), `dados/fotos-e-acesso.sql` e `dados/corrige-participar-e-preciso.sql`. O site passou a ler do banco todos os textos das páginas, o carrossel e a frase do rodapé; o ano de fundação de Números vale para a capa, a linha do tempo e a ficha. Descoberto que a atualização de "Participar é Preciso" (02/09) nunca chegou ao banco. **Falta rodar os dois SQL e corrigir Desde/Endereço (ver §2).** |
| 02/10/2026 | **Avisos e novidades.** Nova tela no painel e faixa de banners no alto da página inicial, com tipo/cor, botão, imagem, período de exibição e pausa. Usa o bloco `avisos` da tabela `conteudo` (sem SQL novo). Envio de foto virou `subirFoto()`, compartilhado com o carrossel; foto usada em aviso não pode ser apagada. Corrigido o desalinhamento da coluna "Editar" nas tabelas do painel. |
