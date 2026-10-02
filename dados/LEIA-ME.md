# Ligar o painel ao banco de dados

O site é hospedado no GitHub Pages, que serve arquivos e não roda código de
servidor. Quem guarda o conteúdo é o Supabase. São quatro passos, uma vez só.

## 1. Criar o projeto no Supabase

Em <https://supabase.com>, crie um projeto novo. Escolha a região
**South America (São Paulo)** — é a mais perto de Campo Grande e deixa o site
mais rápido.

## 2. Criar as tabelas

No painel do Supabase, abra **SQL Editor**, cole o conteúdo inteiro de
[`supabase.sql`](supabase.sql) e rode. Depois repita, nesta ordem, com:

1. [`conteudo.sql`](conteudo.sql) — os blocos editáveis: números do topo,
   contato, textos das páginas e carrossel.
2. [`fotos-e-acesso.sql`](fotos-e-acesso.sql) — o espaço das fotos e a lista
   de quem tem acesso ao painel.

Isso cria a tabela de projetos, as regras de acesso, os espaços para imagens
e já carrega os 11 projetos que estavam no site.

Pode rodar de novo depois sem medo: nada é apagado nem duplicado.

## 3. Criar o seu usuário

Ainda no Supabase:

1. **Authentication → Providers → Email**: desligue *Enable sign ups*. Sem isso,
   qualquer pessoa poderia criar uma conta no painel.
2. **Authentication → Users → Add user**: crie sua conta com e-mail e senha.

## 4. Preencher as chaves

Em **Project Settings → API**, copie:

- *Project URL* — algo como `https://abcdefgh.supabase.co`
- *Project API keys → anon public*

Cole as duas nos dois arquivos, no começo do `<script>`:

| Arquivo | Linhas |
|---|---|
| `admin.html` | `const SUPABASE_URL=''` e `const SUPABASE_ANON=''` |
| `index.html` | as mesmas duas linhas |

**A chave `anon` é pública de propósito** — ela vai no código que qualquer
visitante lê. Quem protege o banco são as regras de acesso do passo 2: sem
login, dá para ler apenas os projetos publicados, e não dá para gravar nada.

**Nunca coloque a chave `service_role` aqui.** Ela ignora todas as regras.

## Pronto

Abra `admin.html`, entre com seu e-mail e senha e edite os projetos. O que você
publicar aparece na página inicial.

## Para ver o site na sua máquina

Abrir o arquivo com dois cliques não funciona mais: o navegador bloqueia a
leitura dos dados em endereços `file://`. Rode, dentro da pasta do site:

```
python -m http.server 8000
```

E abra <http://localhost:8000>. No ar, pelo GitHub Pages, funciona normalmente.

## O que o painel grava

Todas as telas gravam no banco e o site lê de lá: **Projetos**, **Avisos e
novidades** (os banners no alto da página inicial), **Páginas**,
**Números do topo**, **Fotos e arquivos** (o carrossel da capa), **Contato e
rodapé** e **Quem tem acesso** (a lista e a troca de senha).

Criar e remover contas do painel continua sendo no painel do Supabase
(*Authentication → Users*): isso exige a chave `service_role`, que não pode ir
para o navegador. A tela Quem tem acesso tem o passo a passo e o link direto.

O andamento fica em [`../ESTADO.md`](../ESTADO.md).

## Os arquivos desta pasta

| Arquivo | Para que serve |
|---|---|
| `supabase.sql` | Cria a tabela de projetos e o espaço das capas. Rodar uma vez. |
| `conteudo.sql` | Cria a tabela dos blocos editáveis (números, contato, páginas, carrossel). Rodar uma vez, depois de `supabase.sql`. |
| `fotos-e-acesso.sql` | Cria o espaço `fotos`, deixa o painel listar e apagar capas e cria a função `equipe()`. Rodar uma vez, depois de `conteudo.sql`. |
| `corrige-participar-e-preciso.sql` | Correção avulsa: leva ao banco os dados reais desse projeto, que só tinham ido para `projetos.json`. Só altera se o rascunho antigo ainda estiver lá. |
| `padroes.js` | Os textos e valores padrão do site, os tipos e cores dos avisos, lidos pelo `index.html` e pelo `admin.html`. Valem até alguém editar no painel e também quando o banco não responde. Descreve os campos de cada página: um campo novo aqui aparece sozinho no painel. |
| `projetos.json` | Cópia dos projetos que fica no repositório. O site recorre a ela se o banco estiver fora do ar, para a página inicial nunca ficar vazia. **Não edite projetos aqui:** o banco vence. Edite no painel. |
