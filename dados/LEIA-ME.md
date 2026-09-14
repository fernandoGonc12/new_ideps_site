# Ligar o painel ao banco de dados

O site é hospedado no GitHub Pages, que serve arquivos e não roda código de
servidor. Quem guarda o conteúdo é o Supabase. São quatro passos, uma vez só.

## 1. Criar o projeto no Supabase

Em <https://supabase.com>, crie um projeto novo. Escolha a região
**South America (São Paulo)** — é a mais perto de Campo Grande e deixa o site
mais rápido.

## 2. Criar as tabelas

No painel do Supabase, abra **SQL Editor**, cole o conteúdo inteiro de
[`supabase.sql`](supabase.sql) e rode. Depois repita com
[`conteudo.sql`](conteudo.sql), que cria os blocos editáveis (números do topo,
contato e rodapé). Isso cria a tabela de projetos, as regras
de acesso, o espaço para as imagens de capa e já carrega os 11 projetos que
estavam no site.

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

## O que ainda não salva

Gravam no banco: **Projetos**, **Números do topo** e **Contato e rodapé**.
Páginas, Transparência, Fotos e arquivos e Quem tem acesso continuam como
demonstração — cada uma dessas telas avisa isso no topo.

O andamento fica em [`../ESTADO.md`](../ESTADO.md).

## Os arquivos desta pasta

| Arquivo | Para que serve |
|---|---|
| `supabase.sql` | Cria a tabela de projetos e o espaço das capas. Rodar uma vez. |
| `conteudo.sql` | Cria a tabela dos blocos editáveis: números do topo e contato. Rodar uma vez, depois de `supabase.sql`. |
| `projetos.json` | Cópia dos projetos que fica no repositório. O site recorre a ela se o banco estiver fora do ar, para a página inicial nunca ficar vazia. |
