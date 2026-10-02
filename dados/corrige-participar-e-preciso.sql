-- ============================================================
-- IDEPS — leva ao banco os dados reais do projeto "Participar é Preciso"
-- Cole no SQL Editor do Supabase e rode uma vez.
--
-- Em 02/09/2026 estes dados foram atualizados só em dados/projetos.json,
-- que é a cópia de reserva. O site lê primeiro o banco, e lá ficou o
-- rascunho antigo (termo de 2016, valor "R$ 000.000,00") — é ele que
-- aparece no site hoje.
--
-- Só altera se o rascunho ainda estiver lá: se alguém já corrigiu o
-- projeto pelo painel, rodar isto não muda nada.
-- O termo informa só mês e ano; o banco pede o dia, então ficou o
-- primeiro dia do início e o último dia do fim. Ajuste no painel se precisar.
-- ============================================================

update public.projetos set
  inicio     = date '2022-07-01',
  fim        = date '2023-03-31',
  termo      = $t$32.074/2022$t$,
  periodo    = $t$8 meses$t$,
  valor      = $t$R$ 112.500,00$t$,
  publico    = $t$100 participantes$t$,
  resumo     = $t$O projeto tem como metas a adesão de 15 municípios, a capacitação de 100 pessoas, cursos e encontros, uma biblioteca virtual e 15 E-books dos diagnósticos socioterritoriais com ênfase na criança e no adolescente.$t$,
  objeto     = $t$Capacitar conselheiros de direito e adolescentes para participarem nos conselhos de direitos e do adolescente.$t$,
  texto      = $t$O projeto nasceu do Termo de Fomento nº 32.074/2022, firmado com a Secretaria de Estado de Direitos Humanos, Assistência Social e Trabalho (SEDHAST), e reuniu a adesão de 15 municípios de MS — Água Clara, Bataiporã, Corumbá, Coxim, Deodápolis, Dourados, Fátima do Sul, Iguatemi, Itaquiraí, Jardim, Ladário, Nova Andradina, Ribas do Rio Pardo, Três Lagoas e Ponta Porã — por meio de Termo de Adesão. As atividades começaram em julho de 2022 com o curso on-line "Conhecer para Garantir", dividido em 4 módulos (Participação, Sistema de Garantia de Direitos, Controle Social e Indicadores Sociais), oferecido pelo site do IDEPS junto com uma biblioteca virtual, encontros on-line e um encontro presencial em Campo Grande, no dia 30 de novembro. A meta de capacitar 100 pessoas foi superada: 338 se inscreveram e 131 foram certificadas até o fechamento do relatório, resultado que levou à prorrogação do Termo de Fomento para que o curso continuasse disponível aos cursistas.$t$,
  resultados = array[
    $t$15 municípios de MS aderiram ao projeto por Termo de Adesão$t$,
    $t$338 inscritos e 131 certificados no curso "Conhecer para Garantir" (meta de 100 superada)$t$,
    $t$15 E-books de Diagnóstico Socioterritorial produzidos, com ênfase na criança e no adolescente$t$
  ]
where id = 'participar-e-preciso'
  and valor = 'R$ 000.000,00';
