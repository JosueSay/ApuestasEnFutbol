-- Criterio de apuesta

/*
	Casa Be65
*/
WITH RankedGames AS (
    SELECT
        leagueid,
        season,
        hometeamid,
        awayteamid,
        GREATEST(1 / b365h, 1 / b365d, 1 / b365a) AS max_probabilidad_b365,
        CASE
            WHEN 1 / b365h = GREATEST(1 / b365h, 1 / b365d, 1 / b365a) THEN 'Local'
            WHEN 1 / b365d = GREATEST(1 / b365h, 1 / b365d, 1 / b365a) THEN 'Empate'
            WHEN 1 / b365a = GREATEST(1 / b365h, 1 / b365d, 1 / b365a) THEN 'Visitante'
        END AS tipo_apuesta_b365,
        RANK() OVER (PARTITION BY leagueid, season ORDER BY GREATEST(1 / b365h, 1 / b365d, 1 / b365a) DESC) AS rank_b365
    FROM
        games
    WHERE
        b365h IS NOT NULL AND b365h <> 0 AND
        b365d IS NOT NULL AND b365d <> 0 AND
        b365a IS NOT NULL AND b365a <> 0
)
SELECT
    rk.leagueid,
	ls.name as nombre_liga,
    rk.hometeamid as nombre_equipo,
	tn.name,
    rk.tipo_apuesta_b365,
	count(*) as presencia
FROM
    RankedGames rk
join teams tn on rk.hometeamid = tn.teamid
join leagues ls on rk.leagueid = ls.leagueid
WHERE
    rank_b365 = 1
group by rk.leagueid,
	ls.name,
    rk.hometeamid,
	tn.name,
    rk.tipo_apuesta_b365
order by  1,5 desc;

/*
	Casa Betway
*/
WITH RankedGames AS (
    SELECT
        leagueid,
        season,
        hometeamid,
        awayteamid,
        GREATEST(1 / bwh, 1 / bwd, 1 / bwa) AS max_probabilidad_bw,
        CASE
            WHEN 1 / bwh = GREATEST(1 / bwh, 1 / bwd, 1 / bwa) THEN 'Local'
            WHEN 1 / bwd = GREATEST(1 / bwh, 1 / bwd, 1 / bwa) THEN 'Empate'
            WHEN 1 / bwa = GREATEST(1 / bwh, 1 / bwd, 1 / bwa) THEN 'Visitante'
        END AS tipo_apuesta_bw,
        RANK() OVER (PARTITION BY leagueid, season ORDER BY GREATEST(1 / bwh, 1 / bwd, 1 / bwa) DESC) AS rank_bw
    FROM
        games
    WHERE
        bwh IS NOT NULL AND bwh <> 0 AND
        bwd IS NOT NULL AND bwd <> 0 AND
        bwa IS NOT NULL AND bwa <> 0
)
SELECT
    rk.leagueid,
	ls.name as nombre_liga,
    rk.hometeamid as nombre_equipo,
	tn.name,
    rk.tipo_apuesta_bw,
	count(*) as presencia
FROM
    RankedGames rk
join teams tn on rk.hometeamid = tn.teamid
join leagues ls on rk.leagueid = ls.leagueid
WHERE
    rank_bw = 1
group by rk.leagueid,
	ls.name,
    rk.hometeamid,
	tn.name,
    rk.tipo_apuesta_bw
order by  1,5 desc;

/*
	Casa Interwetten
*/
WITH RankedGames AS (
    SELECT
        leagueid,
        season,
        hometeamid,
        awayteamid,
        GREATEST(1 / iwh, 1 / iwd, 1 / iwa) AS max_probabilidad_iw,
        CASE
            WHEN 1 / iwh = GREATEST(1 / iwh, 1 / iwd, 1 / iwa) THEN 'Local'
            WHEN 1 / iwd = GREATEST(1 / iwh, 1 / iwd, 1 / iwa) THEN 'Empate'
            WHEN 1 / iwa = GREATEST(1 / iwh, 1 / iwd, 1 / iwa) THEN 'Visitante'
        END AS tipo_apuesta_iw,
        RANK() OVER (PARTITION BY leagueid, season ORDER BY GREATEST(1 / iwh, 1 / iwd, 1 / iwa) DESC) AS rank_iw
    FROM
        games
    WHERE
        iwh IS NOT NULL AND iwh <> 0 AND
        iwd IS NOT NULL AND iwd <> 0 AND
        iwa IS NOT NULL AND iwa <> 0
)
SELECT
    rk.leagueid,
	ls.name as nombre_liga,
    rk.hometeamid as nombre_equipo,
	tn.name,
    rk.tipo_apuesta_iw,
	count(*) as presencia
FROM
    RankedGames rk
join teams tn on rk.hometeamid = tn.teamid
join leagues ls on rk.leagueid = ls.leagueid
WHERE
    rank_iw = 1
group by rk.leagueid,
	ls.name,
    rk.hometeamid,
	tn.name,
    rk.tipo_apuesta_iw
order by  1,5 desc;

/*
	Casa Pinnacle Sports
*/
WITH RankedGames AS (
    SELECT
        leagueid,
        season,
        hometeamid,
        awayteamid,
        GREATEST(1 / psh, 1 / psd, 1 / psa) AS max_probabilidad_ps,
        CASE
            WHEN 1 / psh = GREATEST(1 / psh, 1 / psd, 1 / psa) THEN 'Local'
            WHEN 1 / psd = GREATEST(1 / psh, 1 / psd, 1 / psa) THEN 'Empate'
            WHEN 1 / psa = GREATEST(1 / psh, 1 / psd, 1 / psa) THEN 'Visitante'
        END AS tipo_apuesta_ps,
        RANK() OVER (PARTITION BY leagueid, season ORDER BY GREATEST(1 / psh, 1 / psd, 1 / psa) DESC) AS rank_ps
    FROM
        games
    WHERE
        psh IS NOT NULL AND psh <> 0 AND
        psd IS NOT NULL AND psd <> 0 AND
        psa IS NOT NULL AND psa <> 0
)
SELECT
    rk.leagueid,
	ls.name as nombre_liga,
    rk.hometeamid as nombre_equipo,
	tn.name,
    rk.tipo_apuesta_ps,
	count(*) as presencia
FROM
    RankedGames rk
join teams tn on rk.hometeamid = tn.teamid
join leagues ls on rk.leagueid = ls.leagueid
WHERE
    rank_ps = 1
group by rk.leagueid,
	ls.name,
    rk.hometeamid,
	tn.name,
    rk.tipo_apuesta_ps
order by  1,5 desc;

/*
	Casa William Hill
*/
WITH RankedGames AS (
    SELECT
        leagueid,
        season,
        hometeamid,
        awayteamid,
        GREATEST(1 / whh, 1 / whd, 1 / wha) AS max_probabilidad_wh,
        CASE
            WHEN 1 / whh = GREATEST(1 / whh, 1 / whd, 1 / wha) THEN 'Local'
            WHEN 1 / whd = GREATEST(1 / whh, 1 / whd, 1 / wha) THEN 'Empate'
            WHEN 1 / wha = GREATEST(1 / whh, 1 / whd, 1 / wha) THEN 'Visitante'
        END AS tipo_apuesta_wh,
        RANK() OVER (PARTITION BY leagueid, season ORDER BY GREATEST(1 / whh, 1 / whd, 1 / wha) DESC) AS rank_wh
    FROM
        games
    WHERE
        whh IS NOT NULL AND whh <> 0 AND
        whd IS NOT NULL AND whd <> 0 AND
        wha IS NOT NULL AND wha <> 0
)
SELECT
    rk.leagueid,
	ls.name as nombre_liga,
    rk.hometeamid as nombre_equipo,
	tn.name,
    rk.tipo_apuesta_wh,
	count(*) as presencia
FROM
    RankedGames rk
join teams tn on rk.hometeamid = tn.teamid
join leagues ls on rk.leagueid = ls.leagueid
WHERE
    rank_wh = 1
group by rk.leagueid,
	ls.name,
    rk.hometeamid,
	tn.name,
    rk.tipo_apuesta_wh
order by  1,5 desc;

/*
	Casa VC Bet
*/
WITH RankedGames AS (
    SELECT
        leagueid,
        season,
        hometeamid,
        awayteamid,
        GREATEST(1 / vch, 1 / vcd, 1 / vca) AS max_probabilidad_vc,
        CASE
            WHEN 1 / vch = GREATEST(1 / vch, 1 / vcd, 1 / vca) THEN 'Local'
            WHEN 1 / vcd = GREATEST(1 / vch, 1 / vcd, 1 / vca) THEN 'Empate'
            WHEN 1 / vca = GREATEST(1 / vch, 1 / vcd, 1 / vca) THEN 'Visitante'
        END AS tipo_apuesta_vc,
        RANK() OVER (PARTITION BY leagueid, season ORDER BY GREATEST(1 / vch, 1 / vcd, 1 / vca) DESC) AS rank_vc
    FROM
        games
    WHERE
        vch IS NOT NULL AND vch <> 0 AND
        vcd IS NOT NULL AND vcd <> 0 AND
        vca IS NOT NULL AND vca <> 0
)
SELECT
    rk.leagueid,
	ls.name as nombre_liga,
    rk.hometeamid as nombre_equipo,
	tn.name,
    rk.tipo_apuesta_vc,
	count(*) as presencia
FROM
    RankedGames rk
join teams tn on rk.hometeamid = tn.teamid
join leagues ls on rk.leagueid = ls.leagueid
WHERE
    rank_vc = 1
group by rk.leagueid,
	ls.name,
    rk.hometeamid,
	tn.name,
    rk.tipo_apuesta_vc
order by  1,5 desc;









