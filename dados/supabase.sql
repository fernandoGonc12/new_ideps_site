-- ============================================================
-- IDEPS — banco do painel do site
-- Cole este arquivo inteiro no SQL Editor do Supabase e rode uma vez.
-- Pode rodar de novo sem estragar nada: tudo é "if not exists" ou
-- "on conflict do nothing".
-- ============================================================

-- ---------- tabela ----------
create table if not exists public.projetos (
  id            text primary key,          -- slug da URL: #/projeto/<id>
  nome          text not null,             -- nome curto da linha do tempo (até 28)
  titulo        text not null,
  eixo          text not null check (eixo in (
                  'Direitos e cidadania','Pessoas idosas','Mulheres',
                  'Segurança alimentar','Saúde e convivência','Juventude')),
  status        text not null default 'ativo' check (status in ('ativo','feito')),
  publicado     boolean not null default false,
  inicio        date,
  fim           date,
  capa          text,
  termo         text,
  periodo       text,
  valor         text,
  publico       text,
  resumo        text,
  objeto        text,
  texto         text,
  resultados    text[] not null default '{}',
  criado_em     timestamptz not null default now(),
  atualizado_em timestamptz not null default now()
);

create index if not exists projetos_publicado_idx on public.projetos (publicado, inicio);

-- ---------- carimbo de última edição ----------
create or replace function public.toca_atualizado_em()
returns trigger language plpgsql as $$
begin
  new.atualizado_em = now();
  return new;
end $$;

drop trigger if exists projetos_atualizado_em on public.projetos;
create trigger projetos_atualizado_em
  before update on public.projetos
  for each row execute function public.toca_atualizado_em();

-- ---------- RLS: quem pode ler e escrever ----------
-- Sem isto, a chave pública do site permitiria qualquer pessoa apagar tudo.
alter table public.projetos enable row level security;

drop policy if exists "anon lê publicados" on public.projetos;
create policy "anon lê publicados"
  on public.projetos for select to anon
  using (publicado);

drop policy if exists "editor lê tudo" on public.projetos;
create policy "editor lê tudo"
  on public.projetos for select to authenticated
  using (true);

drop policy if exists "editor cria" on public.projetos;
create policy "editor cria"
  on public.projetos for insert to authenticated
  with check (true);

drop policy if exists "editor edita" on public.projetos;
create policy "editor edita"
  on public.projetos for update to authenticated
  using (true) with check (true);

drop policy if exists "editor remove" on public.projetos;
create policy "editor remove"
  on public.projetos for delete to authenticated
  using (true);

-- ---------- storage das capas ----------
insert into storage.buckets (id, name, public)
values ('capas','capas',true)
on conflict (id) do nothing;

drop policy if exists "capas: leitura pública" on storage.objects;
create policy "capas: leitura pública"
  on storage.objects for select to anon
  using (bucket_id = 'capas');

drop policy if exists "capas: editor envia" on storage.objects;
create policy "capas: editor envia"
  on storage.objects for insert to authenticated
  with check (bucket_id = 'capas');

drop policy if exists "capas: editor troca" on storage.objects;
create policy "capas: editor troca"
  on storage.objects for update to authenticated
  using (bucket_id = 'capas');

drop policy if exists "capas: editor remove" on storage.objects;
create policy "capas: editor remove"
  on storage.objects for delete to authenticated
  using (bucket_id = 'capas');

-- ---------- conteúdo inicial: os 11 projetos que já estavam no site ----------
insert into public.projetos
  (id, nome, titulo, eixo, status, publicado, inicio, fim, capa,
   termo, periodo, valor, publico, resumo, objeto, texto, resultados)
values
  ('quem-somos-60', 'Quem Somos 60', 'Pessoas idosas no município de Campo Grande/MS', 'Pessoas idosas', 'ativo', true, '2023-01-01', '2026-12-31', 'imagens/Quem-Somos-60-300x300.png', 'TF-12-S-FMAS/2023', '36 meses', 'R$ 000.000,00', '120 pessoas idosas', 'Mapeia e acompanha a população idosa do município, garantindo acesso a direitos e serviços.', 'Levantar o perfil das pessoas idosas do município e articular a rede de proteção para ampliar o acesso a serviços públicos.', 'O projeto nasce da constatação de que boa parte da população idosa do bairro Tiradentes desconhece os serviços a que tem direito. A ação combina escuta ativa, visitas domiciliares e articulação com a rede socioassistencial.', array['Perfil socioeconômico das participantes mapeado', 'Encaminhamentos à rede de proteção social', 'Grupos de convivência formados no território']),
  ('mulheres-que-apoiam-mulheres', 'Mulheres que Apoiam', 'Mulheres que Apoiam Mulheres', 'Mulheres', 'ativo', true, '2024-01-01', '2026-12-31', 'imagens/Mulheres-que-apoiam-mulheres-300x300.png', 'TF-08-S-FMAS/2024', '24 meses', 'R$ 000.000,00', '80 mulheres', 'Rede de apoio mútuo, formação sobre direitos e enfrentamento à violência doméstica.', 'Fortalecer redes de apoio entre mulheres em situação de vulnerabilidade, com formação em direitos e autonomia econômica.', 'A iniciativa cria espaços seguros de escuta e formação, onde as participantes reconhecem situações de violência, conhecem os canais de denúncia e constroem alternativas de geração de renda.', array['Rodas de conversa mensais no território', 'Formação sobre a Lei Maria da Penha', 'Encaminhamento para serviços especializados']),
  ('bem-estar', 'Bem-Estar IDEPS', 'Projeto Bem-Estar IDEPS', 'Saúde e convivência', 'ativo', true, '2024-01-01', '2026-12-31', 'imagens/Bem-estar-IDEPS-300x300.png', 'TF-19-S-FMAS/2024', '24 meses', 'R$ 000.000,00', '90 pessoas idosas', 'Pilates, massagem terapêutica, nutrição e escuta psicológica para as idosas do Tiradentes.', 'Promover saúde física e mental de pessoas idosas por meio de atividades continuadas de bem-estar.', 'As atividades acontecem semanalmente na sede do instituto e combinam movimento, cuidado corporal e acompanhamento profissional. A frequência regular é o que sustenta o vínculo das participantes com o instituto.', array['Turmas semanais de pilates adaptado', 'Atendimento nutricional individual', 'Escuta psicológica sob demanda']),
  ('conhecer-para-participar', 'Conhecer para Participar', 'Conhecer para Participar — IDEPS', 'Direitos e cidadania', 'ativo', true, '2025-01-01', '2026-12-31', 'imagens/Conhecer-para-participar-300x300.png', 'TF-30-S-FMAS/2025', '12 meses', 'R$ 000.000,00', '100 participantes', 'Oficinas sobre políticas públicas, direitos humanos e participação cidadã.', 'Oportunizar o acesso a informações sobre políticas públicas, direitos humanos e participação cidadã, estimulando o protagonismo social e a autonomia.', 'O projeto surge da necessidade de oferecer espaços de formação cidadã para populações vulneráveis, visando o fortalecimento de vínculos comunitários. A iniciativa promove o empoderamento e o acesso a direitos para ressignificar trajetórias de vida.', array['Ampliação do conhecimento sobre direitos', 'Desenvolvimento do protagonismo social', 'Fortalecimento dos vínculos familiares e comunitários']),
  ('apoio-as-familias', 'Apoio às Famílias', 'Projeto Apoio às Famílias', 'Segurança alimentar', 'ativo', true, '2025-01-01', '2026-12-31', 'imagens/Imagem-do-WhatsApp-de-2025-02-19-as-21.38.26_5eb9fdb6-300x300.jpg', 'TF-27-S-FMAS/2025', '12 meses', 'R$ 000.000,00', '150 famílias', 'Kits nutricionais e alimentos do Mesa Brasil SESC para famílias do território.', 'Garantir segurança alimentar a famílias em vulnerabilidade por meio da distribuição de kits e da articulação com parceiros doadores.', 'Os kits nutricionais são obtidos via doações de parceiros e complementados com alimentos do Mesa Brasil SESC. A entrega é feita junto ao acompanhamento das famílias, e não como ação isolada.', array['Entrega mensal de kits nutricionais', 'Parceria ativa com o Mesa Brasil SESC', 'Acompanhamento das famílias atendidas']),
  ('alimentando-direitos', 'Alimentando Direitos', 'Alimentando Direitos', 'Segurança alimentar', 'feito', true, '2022-01-01', '2023-12-31', 'imagens/2-1-300x300.png', 'TF-14-S-FMAS/2022', '18 meses', 'R$ 000.000,00', '200 famílias', 'Segurança alimentar associada à formação sobre o direito humano à alimentação.', 'Associar a distribuição de alimentos à formação sobre o direito humano à alimentação adequada.', 'Mais do que distribuir alimentos, o projeto tratou a alimentação como direito, formando as famílias sobre as políticas públicas às quais podem recorrer.', array['Formação sobre direito à alimentação', 'Distribuição continuada de alimentos', 'Famílias inseridas na rede de proteção']),
  ('fala-jovem', 'Fala Jovem', 'Fala Jovem', 'Juventude', 'feito', true, '2020-01-01', '2022-12-31', 'imagens/1-300x300.png', 'TF-05-S-FMAS/2020', '24 meses', 'R$ 000.000,00', '70 jovens', 'Protagonismo juvenil e participação em espaços de decisão.', 'Estimular o protagonismo de adolescentes e jovens do território em espaços de participação social.', 'O projeto formou jovens do bairro para atuar em conselhos e coletivos, tratando participação como habilidade que se aprende na prática.', array['Jovens formados em participação social', 'Coletivo juvenil constituído', 'Participação em conselhos municipais']),
  ('cozinhar-bem-faz-bem', 'Cozinhar Bem Faz Bem', 'Cozinhar Bem Faz Bem', 'Segurança alimentar', 'feito', true, '2020-01-01', '2021-12-31', 'imagens/Imagem-do-WhatsApp-de-2025-02-19-as-21.38.26_f0c2e00e-300x300.jpg', 'TF-11-S-FMAS/2020', '12 meses', 'R$ 000.000,00', '60 participantes', 'Oficinas de aproveitamento integral de alimentos e geração de renda.', 'Capacitar participantes no aproveitamento integral dos alimentos, com foco em nutrição e geração de renda.', 'As oficinas ensinaram técnicas de aproveitamento integral, reduzindo desperdício e abrindo caminho para pequenas atividades de geração de renda.', array['Oficinas culinárias realizadas', 'Redução do desperdício nas casas', 'Iniciativas de renda a partir da cozinha']),
  ('familias-em-seguranca-alimentar', 'Famílias em Seg. Alimentar', 'Famílias em Segurança Alimentar e Nutricional', 'Segurança alimentar', 'feito', true, '2021-01-01', '2022-12-31', 'imagens/Imagem-do-WhatsApp-de-2025-02-19-as-21.38.25_09bcd780-300x300.jpg', 'TF-09-S-FMAS/2021', '12 meses', 'R$ 000.000,00', '130 famílias', 'Acompanhamento nutricional de famílias em insegurança alimentar.', 'Acompanhar famílias em situação de insegurança alimentar com apoio nutricional e encaminhamento à rede.', 'O acompanhamento nutricional identificou situações de risco e permitiu encaminhamentos rápidos à rede de saúde e assistência.', array['Avaliação nutricional das famílias', 'Encaminhamentos à rede de saúde', 'Apoio alimentar continuado']),
  ('semeando-direitos-humanos', 'Semeando Direitos', 'Semeando Direitos Humanos', 'Direitos e cidadania', 'feito', true, '2018-01-01', '2020-12-31', 'imagens/Semeando-DH.png', 'TF-03-S-FMAS/2018', '24 meses', 'R$ 000.000,00', '150 participantes', 'Educação em direitos humanos em escolas e espaços comunitários.', 'Difundir a educação em direitos humanos em escolas e espaços comunitários do município.', 'O projeto levou formação em direitos humanos para dentro de escolas e associações de bairro, alcançando públicos que não chegariam à sede do instituto.', array['Formações em escolas do município', 'Material educativo produzido', 'Multiplicadores formados no território']),
  ('participar-e-preciso', 'Participar é Preciso', 'Participar é Preciso', 'Direitos e cidadania', 'feito', true, '2016-01-01', '2018-12-31', 'imagens/Logo-Participar-e-Preciso-8-sem-fundo-300x300.png', 'TF-01-S-FMAS/2016', '24 meses', 'R$ 000.000,00', '90 participantes', 'Formação de lideranças comunitárias para o controle social.', 'Formar lideranças comunitárias para atuação qualificada em conselhos e instâncias de controle social.', 'Um dos primeiros projetos do instituto, formou lideranças que seguem atuando no território até hoje.', array['Lideranças comunitárias formadas', 'Participação em conselhos ampliada', 'Base para os projetos seguintes'])
on conflict (id) do nothing;
