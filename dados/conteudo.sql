-- ============================================================
-- IDEPS — blocos de conteúdo editáveis pelo painel
-- Cole este arquivo inteiro no SQL Editor do Supabase e rode uma vez.
-- Pode rodar de novo sem estragar nada: tudo é "if not exists" ou
-- "on conflict do nothing".
--
-- Rode DEPOIS de supabase.sql: reaproveita a função de carimbo criada lá.
--
-- Uma linha por bloco do site. O conteúdo vai em jsonb, então uma tela nova
-- do painel não precisa de uma tabela nova — basta um id novo aqui.
--   'numeros' → a faixa de números da página inicial
--   'contato' → contato, redes e rodapé
-- ============================================================

create table if not exists public.conteudo (
  id            text primary key,
  dados         jsonb not null default '{}',
  atualizado_em timestamptz not null default now()
);

-- carimbo de última edição (a função vem de supabase.sql)
drop trigger if exists conteudo_atualizado_em on public.conteudo;
create trigger conteudo_atualizado_em
  before update on public.conteudo
  for each row execute function public.toca_atualizado_em();

-- ---------- RLS ----------
-- Estes blocos são o conteúdo público do site: qualquer visitante lê.
-- Só quem está logado no painel escreve.
alter table public.conteudo enable row level security;

drop policy if exists "anon lê conteúdo" on public.conteudo;
create policy "anon lê conteúdo"
  on public.conteudo for select to anon
  using (true);

drop policy if exists "editor lê conteúdo" on public.conteudo;
create policy "editor lê conteúdo"
  on public.conteudo for select to authenticated
  using (true);

drop policy if exists "editor cria conteúdo" on public.conteudo;
create policy "editor cria conteúdo"
  on public.conteudo for insert to authenticated
  with check (true);

drop policy if exists "editor edita conteúdo" on public.conteudo;
create policy "editor edita conteúdo"
  on public.conteudo for update to authenticated
  using (true) with check (true);

-- Não há política de delete de propósito: estes blocos são fixos do site.
-- Apagar um deles deixaria a página inicial sem a faixa de números.

-- ---------- conteúdo inicial: o que hoje está escrito à mão no index.html ----------
-- "fonte" diz de onde sai o número:
--   anos   → ano atual menos o ano de fundação
--   total  → quantos projetos publicados existem
--   ativos → quantos estão em andamento
--   manual → o que estiver em "numero"
insert into public.conteudo (id, dados) values
  ('numeros', '{
     "desde": 2014,
     "itens": [
       {"fonte":"anos",   "rotulo":"anos de atuação"},
       {"fonte":"total",  "rotulo":"projetos executados"},
       {"fonte":"ativos", "rotulo":"projetos em andamento"},
       {"fonte":"manual", "numero":"+900", "rotulo":"pessoas atendidas"}
     ]
   }'::jsonb),
  ('contato', '{
     "telefone":  "67 99289-9775",
     "email":     "contato.idepsms@gmail.com",
     "endereco":  "Rua Dona Rosemaria, 633",
     "bairro":    "Tiradentes — Campo Grande, MS",
     "horario":   "Segunda a sexta, das 8h às 17h",
     "instagram": "https://www.instagram.com/idepsms/",
     "facebook":  "https://www.facebook.com/idepsms",
     "cursos":    "https://cursos.idepsms.org",
     "cnpj":      "29.768.758/0001-56"
   }'::jsonb)
on conflict (id) do nothing;
