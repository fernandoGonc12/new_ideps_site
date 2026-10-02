-- ============================================================
-- IDEPS — fotos do site e lista de quem tem acesso ao painel
-- Cole este arquivo inteiro no SQL Editor do Supabase e rode uma vez.
-- Pode rodar de novo sem estragar nada: tudo é "if not exists",
-- "on conflict do nothing" ou "create or replace".
--
-- Rode DEPOIS de supabase.sql e conteudo.sql.
--
-- Liga duas telas do painel:
--   Fotos e arquivos → o espaço "fotos", para o carrossel da página inicial
--   Quem tem acesso  → a função equipe(), que lista as contas do painel
-- ============================================================

-- ---------- espaço das fotos ----------
-- Público para leitura: as fotos aparecem no site sem login.
-- Até 5 MB por foto, só imagem. O painel já reduz a foto antes de enviar.
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('fotos', 'fotos', true, 5242880, array['image/jpeg','image/png','image/webp'])
on conflict (id) do nothing;

-- Listar o espaço é só para quem está logado: o visitante abre cada foto
-- pelo endereço dela, mas não precisa ver a lista inteira.
drop policy if exists "fotos: editor lê" on storage.objects;
create policy "fotos: editor lê"
  on storage.objects for select to authenticated
  using (bucket_id = 'fotos');

drop policy if exists "fotos: editor envia" on storage.objects;
create policy "fotos: editor envia"
  on storage.objects for insert to authenticated
  with check (bucket_id = 'fotos');

drop policy if exists "fotos: editor troca" on storage.objects;
create policy "fotos: editor troca"
  on storage.objects for update to authenticated
  using (bucket_id = 'fotos');

drop policy if exists "fotos: editor remove" on storage.objects;
create policy "fotos: editor remove"
  on storage.objects for delete to authenticated
  using (bucket_id = 'fotos');

-- ---------- capas: faltava o editor poder listar ----------
-- supabase.sql só deu leitura ao visitante (anon). Sem esta regra, o painel
-- logado não enxerga as capas enviadas e não consegue apagar as sem uso:
-- o Supabase exige permissão de leitura para apagar.
drop policy if exists "capas: editor lê" on storage.objects;
create policy "capas: editor lê"
  on storage.objects for select to authenticated
  using (bucket_id = 'capas');

-- ---------- quem tem acesso ----------
-- As contas ficam em auth.users, que o navegador não alcança. Esta função
-- lê de lá só o necessário (e-mail e datas) e responde apenas para quem
-- está logado no painel. Criar e remover contas continua sendo feito no
-- painel do Supabase: isso exigiria a chave service_role no navegador.
create or replace function public.equipe()
returns table (email text, criado_em timestamptz, ultimo_acesso timestamptz)
language sql
stable
security definer
set search_path = ''
as $$
  select u.email::text, u.created_at, u.last_sign_in_at
  from auth.users u
  where auth.uid() is not null
  order by u.created_at
$$;

-- O Supabase libera funções novas para todo mundo; esta é só do painel.
revoke execute on function public.equipe() from public, anon;
grant execute on function public.equipe() to authenticated;
