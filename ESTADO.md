# Estado do painel de administração — IDEPS

> Arquivo de continuidade. Sempre que uma etapa mudar, atualize aqui.
> **Última atualização:** 02/10/2026

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

## 2. Dois ajustes no painel ⚠️

A tabela `conteudo` **já existe e está populada** (verificado pela API em
02/10/2026). Mas o banco ainda guarda dois valores antigos, e o banco vence os
padrões do código:

1. **Números do topo → Desde:** está `2014`. O documento institucional diz
   **2017**. Enquanto não trocar, a home mostra "12 anos de atuação" em vez de 9.
2. **Contato e rodapé → Endereço:** está `Rua Dona Rosemaria, 633`. O documento
   institucional escreve **Rua Dona Rosa Maria, 633**. Confirmar qual é o certo
   (o mapa da página de contato usa esse texto). O código já usa a grafia do
   documento como padrão.

---

## 3. O que já funciona de verdade

### `index.html` (site público)
- Lê os projetos publicados do Supabase.
- Cascata de resiliência: **Supabase → `localStorage` → `dados/projetos.json`**.
  A home nunca fica vazia se o banco cair.
- Linha do tempo, cartões, páginas de projeto — tudo alimentado pelo banco.

### `admin.html` (painel)
- **Login/logout** por e-mail e senha (Supabase Auth), com sessão persistida.
- **Resumo**: contadores + lista "Precisa de atenção" (calculada por `pendencias()`).
- **Projetos** — ligado ao banco:
  - listar, buscar (com tolerância a acento), filtrar por situação;
  - criar, editar, remover linhas de resultado;
  - salvar como rascunho / publicar;
  - upload de capa para o bucket `capas` (limite de 5 MB);
  - validação (nome curto ≤ 28, datas obrigatórias, fim ≥ início);
  - aviso de alterações não salvas ao sair.
- **Números do topo** — ligado ao banco (depende do SQL da §2):
  - cada número é automático (anos de atuação, total de projetos, projetos em
    andamento) ou digitado à mão — escolhido num seletor por linha;
  - os automáticos contam **só projetos publicados**, que é o que o visitante vê,
    e mostram o valor calculado na hora, com o campo travado;
  - ano de fundação editável; adicionar e remover até 4 números.
- **Contato e rodapé** — ligado ao banco (depende do SQL da §2):
  - telefone, e-mail, endereço, bairro, horário, Instagram, Facebook,
    plataforma de cursos e CNPJ;
  - prévia ao vivo do lado enquanto se digita;
  - valida e-mail e exige `https://` nos endereços.

### O que o site público passou a puxar do painel

Estes pontos estavam escritos à mão no `index.html` e agora vêm do banco:
a faixa de números da home, a página de contato (incluindo o mapa e o link do
WhatsApp, montados a partir do endereço e do telefone), o rodapé de todas as
páginas, o botão "Cursos" do topo, os links da página de cursos, o endereço da
sede em "Quem somos" e o telefone na página de cada projeto.

Se o banco não responder, tudo isso cai em valores padrão embutidos no arquivo,
idênticos ao que o site mostrava antes. A home nunca fica com rodapé vazio.

> **Atenção, uma mudança de conteúdo:** o rodapé dizia
> `contato.idepsms@gmail.com` e a página de contato dizia `idepsms@gmail.com`.
> Agora há um só e-mail, e ficou o do rodapé. Se o certo for o outro, troque
> na tela de Contato do painel.

---

## 4. O que falta — as telas de demonstração

Restam 3 telas com a tarja **"Tela de demonstração"**. Nada do que se digita
nelas é salvo.

| Tela | Rota | Alimenta o quê no site |
|---|---|---|
| Páginas | `#/paginas`, `#/pagina` | textos de Quem somos, Início, Contato |
| Fotos e arquivos | `#/midia` | carrossel do hero + banco de imagens |
| Quem tem acesso | `#/equipe` | usuários do painel |

---

## 5. Plano para as telas restantes

### Modelo de dados — já em uso

A tabela `conteudo` (`dados/conteudo.sql`) guarda uma linha por bloco, com o
conteúdo em `jsonb`. Já tem `numeros` e `contato`. **Uma tela nova não precisa
de tabela nova** — basta um id novo, por exemplo `pagina:quem-somos`.

O padrão a seguir, no `admin.html`:
`bloco(id, PADRAO)` para ler → uma função `ligarX()` chamada pelo roteador →
`salvarBloco(id, dados, botoes, msg)` para gravar.

> A seção **Transparência** foi retirada do site e do painel em 02/10/2026 —
> não será usada. Não há tabela nem bucket de documentos a criar.

### Ordem recomendada

1. ~~**Números do topo**~~ — feito em 09/09/2026.
2. ~~**Contato e rodapé**~~ — feito em 09/09/2026.
3. **Páginas** — textos longos; é o mesmo padrão `conteudo`, com mais campos.
4. **Fotos e arquivos** — listar o bucket via `storage.list()`, permitir
   upload e remoção. Também passa a alimentar o carrossel do hero.
5. **Quem tem acesso** — ⚠️ **limitação real**: listar e convidar usuários
   exige a chave `service_role`, que **não pode** ir para o navegador. Só é
   possível com uma Edge Function no Supabase. Alternativa honesta: transformar
   essa tela em instruções apontando para o painel do Supabase.

---

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
