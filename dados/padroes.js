/* ============================================================
   IDEPS — conteúdo padrão do site
   Lido pelo index.html e pelo admin.html, para os dois nunca discordarem.

   Tudo aqui é editável no painel e fica na tabela "conteudo" do Supabase.
   Estes valores são a rede de segurança: valem enquanto ninguém editou um
   bloco no painel e também quando o banco não responde. O site nunca fica
   com página vazia.

   Ao mudar este arquivo, suba o número de "?v=" nas duas tags <script>
   que o carregam, para o navegador não usar a cópia antiga.
   ============================================================ */

/* faixa de números da página inicial — bloco "numeros".
   "fonte" diz de onde sai o número:
     anos   → ano atual menos o ano de fundação
     total  → quantos projetos publicados existem
     ativos → quantos estão em andamento
     manual → o que estiver em "numero" */
const NUMEROS_PADRAO={desde:2017,itens:[
  {fonte:'anos',rotulo:'anos de atuação'},
  {fonte:'total',rotulo:'projetos executados'},
  {fonte:'ativos',rotulo:'projetos em andamento'},
  {fonte:'manual',numero:'+900',rotulo:'pessoas atendidas'}]};

/* contato, redes e rodapé — bloco "contato" */
const CONTATO_PADRAO={telefone:'67 99289-9775',email:'contato.idepsms@gmail.com',
  endereco:'Rua Dona Rosa Maria, 633',bairro:'Tiradentes — Campo Grande, MS',
  horario:'Segunda a sexta, das 8h às 17h',
  instagram:'https://www.instagram.com/idepsms/',facebook:'https://www.facebook.com/idepsms',
  cursos:'https://cursos.idepsms.org',cnpj:'29.768.758/0001-56',
  frase:'Organização da Sociedade Civil em Campo Grande, MS. Desde 2017 construindo oportunidades e fortalecendo vidas.'};

/* carrossel da capa — bloco "fotos" */
const FOTOS_PADRAO={carrossel:[
  {src:'imagens/image13-1024x800.jpg',alt:'Participantes do IDEPS com seus certificados ao fim de uma formação'},
  {src:'imagens/jovem-aluna-ouvindo-professora-de-ingles-1024x617.jpg',alt:'Aluna acompanhando uma aula na plataforma de cursos do IDEPS'}]};

/* ---------- avisos e novidades — bloco "avisos" ----------
   Banners no alto da página inicial. A ordem da lista é a ordem no site.
   Cada item: { id, tipo, titulo, texto, link, botao, imagem, inicio, fim, pausado }
     link    "" (sem botão), "#/rota" (página do site) ou "https://…"
     inicio  "AAAA-MM-DD" ou "" — antes desse dia o banner não aparece
     fim     "AAAA-MM-DD" ou "" — último dia em que aparece
   O site começa sem nenhum banner. */
const AVISOS_PADRAO={itens:[]};

/* o tipo dá o rótulo e a cor do banner — mesmas cores da paleta do site */
const TIPOS_AVISO={
  novidade:  {rotulo:'Novidade',          cor:'#F5008C',clara:'#FDE4F1',texto:'#D4007A'},
  aviso:     {rotulo:'Aviso',             cor:'#F98A00',clara:'#FFF1DC',texto:'#8A4C00'},
  evento:    {rotulo:'Evento',            cor:'#120A8B',clara:'#EAE9F6',texto:'#120A8B'},
  inscricoes:{rotulo:'Inscrições abertas',cor:'#00C000',clara:'#E2F7E2',texto:'#046B04'}};

/* "2026-10-02" no fuso de quem está vendo: o banner vira à meia-noite local */
const hojeISO=()=>{const d=new Date(),p=n=>String(n).padStart(2,'0');
  return `${d.getFullYear()}-${p(d.getMonth()+1)}-${p(d.getDate())}`;};

/* 'no-ar' | 'agendado' | 'encerrado' | 'pausado' — o painel e o site usam a mesma regra */
const situacaoDoAviso=(a,hoje=hojeISO())=>
  a.pausado?'pausado':a.inicio&&a.inicio>hoje?'agendado':a.fim&&a.fim<hoje?'encerrado':'no-ar';

/* ---------- textos das páginas — blocos "pagina:<id>" ----------
   Cada página é uma lista de seções, e cada seção uma lista de campos.
   O painel monta o formulário a partir daqui; o site lê os valores.
   Tipos de campo:
     titulo      uma linha, obrigatório
     linha       uma linha, pode ficar vazio (some do site)
     texto       um parágrafo
     paragrafos  cada linha vira um parágrafo
     lista       um item por linha
     atividades  lista de { icone, nome, texto } */
const PAGINAS=(()=>{
const campo=(k,rotulo,tipo,padrao,dica)=>({k,rotulo,tipo,padrao,dica:dica||''});

const CHAMADA='O texto pequeno, em maiúsculas, acima do título.';
const POR_LINHA='Cada linha vira um parágrafo.';

/* as 14 atividades, agrupadas pelas quatro dimensões do cuidado integral que o
   documento institucional descreve: "a psicologia oferece escuta; a nutrição,
   escolhas conscientes; o movimento, disposição; a arte e a convivência,
   pertencimento". A cor de cada grupo é fixa e segue a ordem. */
const grupo=(n,titulo,lema,icone,itens)=>({
  titulo:`Atividades — grupo ${n}`,
  campos:[
    campo(`dim${n}_titulo`,'Nome do grupo','titulo',titulo),
    campo(`dim${n}_lema`,'Palavra-chave','linha',lema,'Aparece em maiúsculas, acima do nome.'),
    campo(`dim${n}_icone`,'Ícone','linha',icone,'Um emoji.'),
    campo(`dim${n}_itens`,'Atividades','atividades',
      itens.map(([icone,nome,texto])=>({icone,nome,texto})),
      'Na página inicial aparece só o nome; aqui em Quem somos, também a descrição.')]});

return [
 {id:'inicio',nome:'Início',rota:'/',secoes:[
  {titulo:'Capa',campos:[
    campo('capa_titulo','Título','titulo','Um espaço onde mulheres continuam *florescendo*.',
      'Ponha entre asteriscos a palavra que ganha o grifo amarelo, assim: *florescendo*.'),
    campo('capa_texto','Texto','texto','O IDEPS é uma Organização da Sociedade Civil que promove desenvolvimento humano, cidadania, inclusão social e qualidade de vida para pessoas em situação de vulnerabilidade, com atenção especial às mulheres idosas.'),
    campo('capa_verbos','Palavras em destaque','lista',['Cuidar','Acolher','Incluir','Desenvolver','Transformar'],
      'Uma por linha. Aparecem separadas por pontos, abaixo do texto.')]},
  {titulo:'Centro de Convivência',campos:[
    campo('centro_chamada','Chamada','linha','Centro de Convivência',CHAMADA),
    campo('centro_titulo','Título','titulo','Um lugar para continuar vivendo, aprendendo e florescendo.'),
    campo('centro_texto','Texto','texto','Uma de nossas principais frentes é o Centro de Convivência para Pessoas Idosas, com atenção especial às mulheres idosas em situação de vulnerabilidade. Um lugar de encontro, aprendizagem e cuidado, onde muitas mulheres redescobrem talentos, constroem novos vínculos e se tornam protagonistas de suas próprias histórias.',
      'Abaixo dele entram os quatro grupos de atividades, que se editam em Quem somos.')]},
  {titulo:'Linha do tempo',campos:[
    campo('tempo_titulo','Título','titulo','Cada projeto é um compromisso.'),
    campo('tempo_texto','Texto','texto','Com as pessoas atendidas, com nossos parceiros e com a sociedade. Cada linha abaixo é um termo de fomento, com prazo e metas definidos. A cor indica a área de atuação.')]},
  {titulo:'Plataforma de cursos',campos:[
    campo('cursos_chamada','Chamada','linha','Plataforma de cursos',CHAMADA),
    campo('cursos_titulo','Título','titulo','Aprender algo novo, em qualquer fase da vida.'),
    campo('cursos_texto','Texto','texto','Cursos online e gratuitos, feitos para caber na rotina de quem trabalha, cuida da casa e da família.'),
    campo('cursos_itens','Vantagens','lista',['Gratuitos.',
      'No seu horário. Você assiste quando der, de onde estiver.',
      'Com certificado. Para usar em processos seletivos e no currículo.'],
      'Uma por linha. A primeira frase de cada linha sai em negrito.')]}]},

 {id:'quem-somos',nome:'Quem somos',rota:'/quem-somos',secoes:[
  {titulo:'Abertura',campos:[
    campo('abre_titulo','Título','titulo','Desde 2017, transformando vidas.'),
    campo('abre_subtitulo','Subtítulo','texto','Por meio da convivência, do cuidado, da inclusão e do desenvolvimento social.'),
    campo('abre_texto','Texto','paragrafos','O IDEPS é uma Organização da Sociedade Civil que promove desenvolvimento humano, cidadania, inclusão social e qualidade de vida para pessoas em situação de vulnerabilidade — sempre pautado no acolhimento, na garantia de direitos e no fortalecimento dos vínculos comunitários.\n\nHoje, uma de nossas principais frentes é o Centro de Convivência para Pessoas Idosas, com atenção especial às mulheres idosas em situação de vulnerabilidade econômica e social. É um lugar de encontro, aprendizagem e cuidado, onde muitas mulheres redescobrem talentos, constroem novos vínculos e se tornam protagonistas de suas próprias histórias.',POR_LINHA)]},
  {titulo:'Ficha ao lado',campos:[
    campo('razao_social','Razão social','linha','Instituto de Desenvolvimento Pró-Social'),
    campo('natureza','Natureza jurídica','linha','Organização da Sociedade Civil',
      'O ano de fundação vem de Números do topo; a sede e o CNPJ, de Contato e rodapé.')]},
  {titulo:'Centro de Convivência',campos:[
    campo('centro_chamada','Chamada','linha','Um centro de convivência para mulheres idosas',CHAMADA),
    campo('centro_titulo','Título','titulo','Um lugar para continuar vivendo, aprendendo e florescendo.'),
    campo('centro_destaque','Frase em destaque','texto','No IDEPS, acreditamos que envelhecer não significa deixar de sonhar, aprender e criar.',
      'Sai grande, com um fio colorido ao lado.'),
    campo('centro_texto','Texto','paragrafos','A terceira idade pode ser uma fase de novas descobertas, amizades e possibilidades.\n\nPor isso, nosso Centro de Convivência é muito mais do que um espaço de atividades: é onde amizades nascem, talentos são descobertos e novos projetos de vida ganham forma. Atendemos principalmente mulheres idosas em vulnerabilidade, com foco em ampliar autonomia, autoestima, saúde, convivência, participação social e qualidade de vida.',POR_LINHA)]},
  {titulo:'Atividades e serviços',campos:[
    campo('ativ_chamada','Chamada','linha','Nossas atividades e serviços',CHAMADA),
    campo('ativ_titulo','Título','titulo','Uma programação diversificada.'),
    campo('ativ_texto','Texto','texto','Construída para atender aos interesses e às diferentes dimensões do envelhecimento.')]},
  grupo(1,'Psicologia e autocuidado','Escuta','🧠',[
    ['🧠','Atendimento psicológico individual','Escuta, acolhimento e acompanhamento das demandas emocionais de cada participante.'],
    ['💜','Apoio psicológico em grupo','Espaços de diálogo e troca onde vivências são compartilhadas e vínculos se fortalecem.'],
    ['💆','Massagem terapêutica','Momentos de relaxamento e autocuidado, com atenção plena ao corpo.']]),
  grupo(2,'Nutrição e alimentação','Escolhas conscientes','🥗',[
    ['🥗','Atendimento nutricional individual','Acompanhamento personalizado para hábitos alimentares mais saudáveis e conscientes.'],
    ['🍎','Apoio nutricional em grupo','Alimentação saudável, aproveitamento de alimentos e segurança nutricional em encontros coletivos.'],
    ['👩‍🍳','Cursos e oficinas de culinária','Conhecimento, convivência e novas habilidades ao redor da mesa.'],
    ['🥦','Segurança alimentar e nutricional','Projetos e parcerias que ampliam o acesso a alimentos e à educação alimentar.']]),
  grupo(3,'Movimento e bem-estar','Disposição','🧘',[
    ['🧘','Pilates e atividades corporais','Movimento, disposição e autonomia para um estilo de vida mais ativo.'],
    ['🏊','Hidroginástica','Saúde, convivência e bem-estar em um ambiente coletivo e leve.'],
    ['💃','Dança e expressão corporal','Alegria, socialização e fortalecimento da autoestima em movimento.']]),
  grupo(4,'Arte, aprendizagem e convivência','Pertencimento','🎨',[
    ['🎨','Arte, cultura e criatividade','Pintura, artesanato, crochê e bordado que revelam talentos e geram renda.'],
    ['💻','Inclusão digital','Autonomia no uso de celulares, aplicativos e internet para se comunicar e informar.'],
    ['📚','Palestras e atividades educativas','Saúde, direitos, cidadania e bem-estar como ferramentas de autonomia.'],
    ['🤝','Convivência e vínculos','O coração do IDEPS: pertencimento, amizade e novos vínculos a cada encontro.']]),
  {titulo:'Cuidado integral',campos:[
    campo('cuidado_chamada','Chamada','linha','Cuidado integral',CHAMADA),
    campo('cuidado_titulo','Título','titulo','Cuidar é olhar para a pessoa como um todo.'),
    campo('cuidado_texto','Texto','paragrafos','Entendemos o envelhecimento a partir de uma perspectiva integral: corpo, saúde emocional, alimentação, vínculos, autonomia e história caminham juntos. A psicologia oferece escuta; a nutrição, escolhas conscientes; o movimento, disposição; a arte e a convivência, pertencimento. Todas essas experiências convergem para o que buscamos diariamente — mais qualidade de vida e mais possibilidades.',POR_LINHA)]},
  {titulo:'Mulheres que continuam florescendo',campos:[
    campo('florescer_chamada','Chamada','linha','Mulheres que continuam florescendo',CHAMADA),
    campo('florescer_titulo','Título','titulo','A vida não para depois dos 60.'),
    campo('florescer_texto','Texto','paragrafos','Uma mulher pode aprender algo novo, descobrir um talento, fazer amizades, cuidar de si, voltar a estudar ou encontrar uma nova possibilidade de renda — em qualquer fase da vida.\n\nPor isso o IDEPS não quer apenas oferecer atividades. Queremos oferecer possibilidades: de convivência, aprendizagem, autonomia, cuidado, participação — e de continuar florescendo.',POR_LINHA)]},
  {titulo:'Missão, visão e valores',campos:[
    campo('missao','Missão','texto','Promover o desenvolvimento humano e social, fortalecendo a autonomia, a cidadania, a convivência, o cuidado e a qualidade de vida de pessoas em situação de vulnerabilidade, com especial atenção às mulheres idosas.'),
    campo('visao','Visão','texto','Ser uma organização social reconhecida pela seriedade, acolhimento, transparência e impacto de suas ações, contribuindo para uma sociedade mais inclusiva, participativa e comprometida com o envelhecimento digno.'),
    campo('valores','Valores','lista',['Humanização','Acolhimento','Respeito','Inclusão','Autonomia','Cidadania',
      'Solidariedade','Participação','Ética','Transparência'],'Um por linha.')]},
  {titulo:'Frase de fechamento',campos:[
    campo('frase_titulo','Frase','titulo','Toda pessoa merece oportunidades para viver com dignidade, autonomia e pertencimento.'),
    campo('frase_fecho','Complemento','linha','É por isso que o IDEPS existe.','Sai logo abaixo da frase, em cor de destaque.'),
    campo('frase_verbos','Palavras em destaque','lista',['Acolher','Ouvir','Ensinar','Cuidar','Alimentar','Conectar','Fortalecer','Transformar'],'Uma por linha.'),
    campo('frase_texto','Texto','texto','Como Organização da Sociedade Civil, conduzimos nossas ações com responsabilidade, ética e transparência. Cada projeto é um compromisso com as pessoas atendidas, com nossos parceiros e com a sociedade — porque transformar uma vida também é transformar uma comunidade.')]},
  {titulo:'Parceiros',campos:[
    campo('parceiros_titulo','Título','titulo','Juntos, conseguimos chegar mais longe.'),
    campo('parceiros_texto','Texto','paragrafos','Nenhuma transformação social acontece de forma isolada. Construímos uma rede que compartilha o compromisso de melhorar a vida das pessoas — entre eles a Rede Comper de Supermercados e instituições do Sistema S, como SENAR e SESC. Buscamos sempre novas parcerias com empresas, órgãos públicos e organizações comprometidas com o desenvolvimento social.',POR_LINHA),
    campo('parceiros_destaque','Frase em destaque','texto','Para o IDEPS, cada parceria representa a união de forças em torno de um propósito maior: transformar oportunidades em impacto social.'),
    campo('parceiros_lista','Parceiros','lista',['SEAD','SAS','Secretaria de Estado de Educação','SENAR','SESC','Mesa Brasil',
      'CMAS','CMDPI','Fórum das Entidades','Comper','República das Arteiras','Cleber das Onças','ISA'],'Um por linha, na ordem em que devem aparecer.'),
    campo('parceiros_convite','Convite final','linha','Faça parte dessa rede de transformação.','Fica ao lado do botão “Fale com a gente”.')]}]},

 {id:'projetos',nome:'Projetos',rota:'/projetos',secoes:[
  {titulo:'Abertura',campos:[
    campo('titulo','Título','titulo','Tudo o que já fizemos, e o que está em curso.'),
    campo('texto','Texto','texto','Filtre por situação ou por área de atuação.',
      'Os projetos em si se editam na tela Projetos.')]}]},

 {id:'contato',nome:'Contato',rota:'/contato',secoes:[
  {titulo:'Abertura',campos:[
    campo('titulo','Título','titulo','Venha até a sede ou fale com a gente.'),
    campo('texto','Texto','texto','Para participar das atividades, apoiar o instituto ou propor uma parceria. Faça parte dessa rede de transformação.',
      'Telefone, e-mail e endereço se editam em Contato e rodapé.')]}]},

 {id:'cursos',nome:'Cursos',rota:'/cursos',secoes:[
  {titulo:'Abertura',campos:[
    campo('titulo','Título','titulo','Cursos gratuitos, do seu jeito.'),
    campo('texto','Texto','texto','A plataforma de cursos continua sendo a mesma que você já usa. O acesso é por aqui.',
      'O endereço da plataforma se edita em Contato e rodapé.')]}]}
];
})();

/* { inicio:{capa_titulo:'…', …}, 'quem-somos':{…}, … } */
const TEXTOS_PADRAO=Object.fromEntries(PAGINAS.map(p=>[p.id,
  Object.fromEntries(p.secoes.flatMap(s=>s.campos).map(c=>[c.k,c.padrao]))]));
