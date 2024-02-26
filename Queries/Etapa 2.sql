-- INCISO 1
/*
	Saber la cantidad de partidos jugagos como visitante o local por cada temporada de cada liga
*/
SELECT 
  g.leagueID, 
  g.season, 
  t.name, 
  COUNT(*) as partidos_jugados
FROM (
  SELECT leagueID, season, homeTeamID as team
  FROM games
	
  UNION ALL
	
  SELECT leagueID, season, awayTeamID as team
  FROM games
) as g
JOIN teams t ON g.team = t.teamID
GROUP BY g.leagueID, g.season, t.name
order by g.leagueID, g.season, t.name;

-- INCISO 2
/*
	Diferencia de goles de cada equipo por cada liga, temporada sin Ranking
*/
WITH DiferenciaGoles AS (
    SELECT
        season,
        leagueid,
        hometeamid AS equipo,
        SUM(homegoals - awaygoals) AS diferencia_goles
    FROM
        games
    GROUP BY
        season,
        leagueid,
        hometeamid
    UNION ALL
    SELECT
        season,
        leagueid,
        awayteamid AS equipo,
        SUM(awaygoals - homegoals) AS diferencia_goles
    FROM
        games
    GROUP BY
        season,
        leagueid,
        awayteamid
)
SELECT
   	season,
    leagueid,
	t.name
    equipo,
    SUM(diferencia_goles) AS goles_equipo_total
FROM
    DiferenciaGoles d, teams t
	where d.equipo = t.teamid
GROUP BY
    season,
    leagueid,
    equipo,
	t.name
ORDER BY
    4 DESC;

/*
	Diferencia de goles de cada equipo por cada liga, temporada con Ranking
*/
WITH DiferenciaGoles AS (
    SELECT
        season,
        leagueid,
        hometeamid AS equipo,
        SUM(homegoals - awaygoals) AS diferencia_goles
    FROM
        games
    GROUP BY
        season,
        leagueid,
        hometeamid
    UNION ALL
    SELECT
        season,
        leagueid,
        awayteamid AS equipo,
        SUM(awaygoals - homegoals) AS diferencia_goles
    FROM
        games
    GROUP BY
        season,
        leagueid,
        awayteamid
)
, RankingEquipos AS (
    SELECT
        season,
        leagueid,
        equipo,
        SUM(diferencia_goles) AS diferencia_total,
        RANK() OVER (PARTITION BY season, leagueid ORDER BY SUM(diferencia_goles) DESC) AS ranking
    FROM
        DiferenciaGoles
    GROUP BY
        season,
        leagueid,
        equipo
)
SELECT
    season,
    leagueid,
    t.name,
    diferencia_total,
    ranking
FROM
    RankingEquipos r, teams t 
	where r.equipo = t.teamid
ORDER BY
    season,
    leagueid,
    ranking;


-- INCISO 3

/*
	Saber los jugadores con más goles en todas las temporadas
*/
SELECT a.playerid, p.name, SUM(a.goals) as total_goles
FROM appearances a
JOIN players p ON a.playerid = p.playerid
GROUP BY a.playerid, p.name
ORDER BY total_goles DESC;


/*
	Saber los jugadores con más goles en todas asistencias que terminaron en gol (el pase sea derecho o izquierdo)
*/
SELECT 
    s.shooterid,
    p.name,
    COUNT(CASE WHEN s.shottype = 'LeftFoot' AND s.shotresult = 'Goal' THEN 1 END) AS izquierdos_goles,
    COUNT(CASE WHEN s.shottype = 'RightFoot' AND s.shotresult = 'Goal' THEN 1 END) AS derechos_goles,
    SUM(CASE WHEN s.shottype = 'LeftFoot' AND s.shotresult = 'Goal' THEN 1 ELSE 0 END +
        CASE WHEN s.shottype = 'RightFoot' AND s.shotresult = 'Goal' THEN 1 ELSE 0 END) as pases_totales
FROM shots s
JOIN players p ON s.shooterid = p.playerid
GROUP BY s.shooterid, p.name
ORDER BY izquierdos_goles DESC, derechos_goles DESC, pases_totales DESC;

/*
	Este querie da una los jugadores con más goles y asistencias
*/
WITH GolesTotales AS (
    SELECT 
        a.playerid,
        p.name,
        SUM(a.goals) as total_goles
    FROM appearances a
    JOIN players p ON a.playerid = p.playerid
    GROUP BY a.playerid, p.name
),
PasesGoles AS (
    SELECT 
        s.shooterid,
        p.name,
        COUNT(CASE WHEN s.shottype = 'LeftFoot' AND s.shotresult = 'Goal' THEN 1 END) AS pases_izquierdos_goles,
        COUNT(CASE WHEN s.shottype = 'RightFoot' AND s.shotresult = 'Goal' THEN 1 END) AS pases_derechos_goles,
        SUM(CASE WHEN s.shottype = 'LeftFoot' AND s.shotresult = 'Goal' THEN 1 ELSE 0 END +
            CASE WHEN s.shottype = 'RightFoot' AND s.shotresult = 'Goal' THEN 1 ELSE 0 END) as pases_totales
    FROM shots s
    JOIN players p ON s.shooterid = p.playerid
    GROUP BY s.shooterid, p.name
)
SELECT 
    GT.playerid,
    GT.name,
    GT.total_goles,
    PG.pases_izquierdos_goles,
    PG.pases_derechos_goles,
    PG.pases_totales
FROM GolesTotales GT
JOIN PasesGoles PG ON GT.playerid = PG.shooterid
ORDER BY GT.total_goles DESC, PG.pases_izquierdos_goles DESC, PG.pases_derechos_goles DESC, PG.pases_totales DESC;

-- COMPARACION (no verdadero)
/*
	Este querie da una idea base de los equipos de los jugadores con más goles y asistencias
*/
WITH GolesTotales AS (
    SELECT 
        a.playerid,
        p.name,
        SUM(a.goals) as total_goles
    FROM appearances a
    JOIN players p ON a.playerid = p.playerid
    GROUP BY a.playerid, p.name
),
PasesGoles AS (
    SELECT 
        s.shooterid,
        p.name,
        COUNT(CASE WHEN s.shottype = 'LeftFoot' AND s.shotresult = 'Goal' THEN 1 END) AS pases_izquierdos_goles,
        COUNT(CASE WHEN s.shottype = 'RightFoot' AND s.shotresult = 'Goal' THEN 1 END) AS pases_derechos_goles,
        SUM(CASE WHEN s.shottype = 'LeftFoot' AND s.shotresult = 'Goal' THEN 1 ELSE 0 END +
            CASE WHEN s.shottype = 'RightFoot' AND s.shotresult = 'Goal' THEN 1 ELSE 0 END) as pases_totales
    FROM shots s
    JOIN players p ON s.shooterid = p.playerid
    GROUP BY s.shooterid, p.name
)
SELECT 
    GT.playerid,
    GT.name,
    GT.total_goles,
    PG.pases_izquierdos_goles,
    PG.pases_derechos_goles,
    PG.pases_totales,
    ARRAY(SELECT DISTINCT t."name" FROM teamstats ts JOIN teams t ON ts.teamid = t.teamid WHERE ts.gameid IN (SELECT gameid FROM appearances ap WHERE ap.playerid = GT.playerid)) AS equipos
FROM GolesTotales GT
JOIN PasesGoles PG ON GT.playerid = PG.shooterid
ORDER BY GT.total_goles DESC, PG.pases_totales DESC
LIMIT 10;


/*
	Querie que determina a los posibles equipos de los jugadores con más goles
*/
WITH GolesTotales AS (
    SELECT 
        a.playerid,
        p.name,
        SUM(a.goals) as total_goles
    FROM appearances a
    JOIN players p ON a.playerid = p.playerid
    GROUP BY a.playerid, p.name
)
SELECT 
    GT.playerid,
    GT.name,
    GT.total_goles,
    ARRAY(SELECT DISTINCT t."name" FROM teamstats ts JOIN teams t ON ts.teamid = t.teamid WHERE ts.gameid IN (SELECT gameid FROM appearances ap WHERE ap.playerid = GT.playerid)) AS equipos
FROM GolesTotales GT
ORDER BY GT.total_goles DESC;

/*
	Querie que determina a los posibles equipos de los jugadores con más asistencias
*/
WITH AsistenciasTotales AS (
    SELECT 
        s.shooterid,
        p.name,
        COUNT(CASE WHEN s.shottype = 'LeftFoot' AND s.shotresult = 'Goal' THEN 1 END) AS asistencias_izquierdas,
        COUNT(CASE WHEN s.shottype = 'RightFoot' AND s.shotresult = 'Goal' THEN 1 END) AS asistencias_derechas,
        SUM(CASE WHEN s.shottype = 'LeftFoot' AND s.shotresult = 'Goal' THEN 1 ELSE 0 END +
            CASE WHEN s.shottype = 'RightFoot' AND s.shotresult = 'Goal' THEN 1 ELSE 0 END) as asistencias_totales
    FROM shots s
    JOIN players p ON s.shooterid = p.playerid
    GROUP BY s.shooterid, p.name
)
SELECT 
    AT.shooterid,
    AT.name,
    AT.asistencias_izquierdas,
    AT.asistencias_derechas,
    AT.asistencias_totales,
    ARRAY(SELECT DISTINCT t."name" FROM teamstats ts JOIN teams t ON ts.teamid = t.teamid WHERE ts.gameid IN (SELECT gameid FROM shots s WHERE s.shooterid = AT.shooterid)) AS equipos
FROM AsistenciasTotales AT
ORDER BY AT.asistencias_totales DESC;


-- INCISO 4
/*
	Cuantas ligas hay (5) y que tipo (1 - 5)
*/

select count(distinct leagueid) as cantidad_ligas
from leagues;

select distinct leagueid
from leagues 
order by leagueid;

/*
	Cuantas temporadas hay (7) y de que tipo (2014 - 2020)
*/
select count (distinct season) 
from games;

select distinct season 
from games 
order by season;

/*
	Casas de apuestas:
		b365: Bet365
		bw: Betway
		iw: Interwetten
		ps: Pinnacle Sports
		wh: William Hill
		vc: VC Bet
		
	Opciones:
		h = apuesta a home
		d = apuesta a empate
		a = apuesta a visitante
*/
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'games';


/*
	Probabilidad máxima para la alguna casa
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
    leagueid,
    season,
    hometeamid,
    awayteamid,
    max_probabilidad_b365,
    tipo_apuesta_b365
FROM
    RankedGames
WHERE
    rank_b365 = 1;


/*
	Probabilidad máxima para la casa B365 ordenada por su maxima probabilidad de apuesta
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
    rg.leagueid,
    rg.season,
    rg.hometeamid,
    th.name AS hometeam_name,
    rg.awayteamid,
    ta.name AS awayteam_name,
    rg.max_probabilidad_b365,
    rg.tipo_apuesta_b365
FROM
    RankedGames rg
JOIN teams th ON rg.hometeamid = th.teamid
JOIN teams ta ON rg.awayteamid = ta.teamid
WHERE
    rg.rank_b365 = 1
ORDER BY rg.max_probabilidad_b365 DESC;


/*
	Probabilidad máxima para la casa BW ordenada por su maxima probabilidad de apuesta
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
    rg.leagueid,
    rg.season,
    rg.hometeamid,
    th.name AS hometeam_name,
    rg.awayteamid,
    ta.name AS awayteam_name,
    rg.max_probabilidad_bw,
    rg.tipo_apuesta_bw
FROM
    RankedGames rg
JOIN teams th ON rg.hometeamid = th.teamid
JOIN teams ta ON rg.awayteamid = ta.teamid
WHERE
    rg.rank_bw = 1
ORDER BY rg.max_probabilidad_bw DESC;
	
/*
	Probabilidad máxima para la casa iw ordenada por su maxima probabilidad de apuesta
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
    rg.leagueid,
    rg.season,
    rg.hometeamid,
    th.name AS hometeam_name,
    rg.awayteamid,
    ta.name AS awayteam_name,
    rg.max_probabilidad_iw,
    rg.tipo_apuesta_iw
FROM
    RankedGames rg
JOIN teams th ON rg.hometeamid = th.teamid
JOIN teams ta ON rg.awayteamid = ta.teamid
WHERE
    rg.rank_iw = 1
ORDER BY rg.max_probabilidad_iw DESC;

/*
	Probabilidad máxima para la casa ps ordenada por su maxima probabilidad de apuesta
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
    rg.leagueid,
    rg.season,
    rg.hometeamid,
    th.name AS hometeam_name,
    rg.awayteamid,
    ta.name AS awayteam_name,
    rg.max_probabilidad_ps,
    rg.tipo_apuesta_ps
FROM
    RankedGames rg
JOIN teams th ON rg.hometeamid = th.teamid
JOIN teams ta ON rg.awayteamid = ta.teamid
WHERE
    rg.rank_ps = 1
ORDER BY rg.max_probabilidad_ps DESC;
	
/*
	Probabilidad máxima para la casa wh ordenada por su maxima probabilidad de apuesta
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
    rg.leagueid,
    rg.season,
    rg.hometeamid,
    th.name AS hometeam_name,
    rg.awayteamid,
    ta.name AS awayteam_name,
    rg.max_probabilidad_wh,
    rg.tipo_apuesta_wh
FROM
    RankedGames rg
JOIN teams th ON rg.hometeamid = th.teamid
JOIN teams ta ON rg.awayteamid = ta.teamid
WHERE
    rg.rank_wh = 1
ORDER BY rg.max_probabilidad_wh DESC;

/*
	Probabilidad máxima para la casa vc ordenada por su maxima probabilidad de apuesta
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
    rg.leagueid,
    rg.season,
    rg.hometeamid,
    th.name AS hometeam_name,
    rg.awayteamid,
    ta.name AS awayteam_name,
    rg.max_probabilidad_vc,
    rg.tipo_apuesta_vc
FROM
    RankedGames rg
JOIN teams th ON rg.hometeamid = th.teamid
JOIN teams ta ON rg.awayteamid = ta.teamid
WHERE
    rg.rank_vc = 1
ORDER BY rg.max_probabilidad_vc DESC;

-- INCISO 6

SELECT
    players.name,
    teams.name AS team_name,
    leagues.name AS league_name,
    games.season,
    SUM(appearances.goals) AS total_goals,
    SUM(appearances.shots) AS total_shots,
    SUM(appearances.keypasses) AS total_keypasses,
    SUM(appearances.assists) AS total_assists
FROM
    players
JOIN
    appearances ON appearances.playerid = players.playerid
JOIN
    games ON appearances.gameid = games.gameid
JOIN
    leagues ON games.leagueid = leagues.leagueid
LEFT JOIN (
    SELECT
        appearances.gameid,
        appearances.playerid,
        CASE
            WHEN games.hometeamid = teams.teamid THEN teams.name
            WHEN games.awayteamid = teams.teamid THEN teams.name
            ELSE 'Unknown'
        END AS team_name
    FROM
        appearances
    JOIN
        games ON appearances.gameid = games.gameid
    LEFT JOIN
        teams ON games.hometeamid = teams.teamid OR games.awayteamid = teams.teamid
) AS player_teams ON appearances.gameid = player_teams.gameid AND appearances.playerid = player_teams.playerid
LEFT JOIN
    teams ON player_teams.team_name = teams.name
GROUP BY
    players.name, teams.name, leagues.name, games.season
ORDER BY
    total_goals DESC, total_shots DESC, total_keypasses DESC, total_assists DESC
LIMIT 35; -- El limite se puede variar para ver N cantidad de respuestas

-- INCISO 7
-- Rendimiento promedio de cada equipo basado en goles y goles esperados

SELECT
    t.name,
    ts.location,
    AVG(ts.goals) AS Goles,
    AVG(NULLIF(ts.xgoals::float,0)) AS Goles_Esperados,
    AVG(ts.goals) - AVG(NULLIF(ts.xgoals::float,0)) AS Diferencia
FROM
    teams AS t
LEFT JOIN
    teamstats AS ts ON t.teamid = ts.teamid
GROUP BY
    t.name,
    ts.location
ORDER BY
    Goles DESC,
    Goles_Esperados DESC
LIMIT 10;

-- INCISO 8
SELECT 
    liga,
    equipo,
    goles,
    tiros,
    tiro_al_arco,
    temporada,
    victorias
FROM 
    (SELECT 
        liga,
        equipo,
        goles,
        tiros,
        tiro_al_arco,
        temporada,
        victorias,
        ROW_NUMBER() OVER (PARTITION BY liga, temporada ORDER BY victorias DESC) AS row_num
    FROM 
        (SELECT 
            leagues.name AS liga,
            teams.name AS equipo,
            SUM(teamstats.goals) AS goles,
            SUM(teamstats.shots) AS tiros,
            SUM(teamstats.shotsontarget) AS tiro_al_arco,
            teamstats.season AS temporada,
            COUNT(*) FILTER (WHERE teamstats.result = 'W') AS victorias
        FROM 
            teamstats
        JOIN 
            games ON teamstats.gameid = games.gameid
        JOIN 
            leagues ON leagues.leagueid = games.leagueid
        JOIN 
            teams ON teams.teamid = teamstats.teamid
        GROUP BY 
            leagues.name, teams.name, teamstats.season) AS victorias_por_equipo
    ) AS ranked
WHERE 
    row_num = 1;

-- INCISO 9
/*
	Probabilidad de ganar en cada temporada según el valor máximo de apuesta en la casa B365
*/
WITH RankedGames AS (
	SELECT
        season,
        hometeamid,
        awayteamid,
        GREATEST(1 / b365h, 1 / b365d, 1 / b365a) AS max_probabilidad_b365,
        CASE
            WHEN 1 / b365h = GREATEST(1 / b365h, 1 / b365d, 1 / b365a) THEN 'Local'
            WHEN 1 / b365d = GREATEST(1 / b365h, 1 / b365d, 1 / b365a) THEN 'Empate'
            WHEN 1 / b365a = GREATEST(1 / b365h, 1 / b365d, 1 / b365a) THEN 'Visitante'
        END AS tipo_apuesta_b365,
        RANK() OVER (PARTITION BY season ORDER BY GREATEST(1 / b365h, 1 / b365d, 1 / b365a) DESC) AS rank_b365,
        RANK() OVER (PARTITION BY season ORDER BY GREATEST(1 / b365h, 1 / b365d, 1 / b365a) DESC) AS rank_season
    FROM
        games
    WHERE
        b365h IS NOT NULL AND b365h <> 0 AND
        b365d IS NOT NULL AND b365d <> 0 AND
        b365a IS NOT NULL AND b365a <> 0
)
SELECT
    rg.season,
    rg.hometeamid,
    th.name AS hometeam_name,
    rg.awayteamid,
    ta.name AS awayteam_name,
    rg.max_probabilidad_b365,
    rg.tipo_apuesta_b365
FROM
    RankedGames rg
JOIN teams th ON rg.hometeamid = th.teamid
JOIN teams ta ON rg.awayteamid = ta.teamid
WHERE
    rg.rank_season = 1
ORDER BY 1;

-- INCISO 10
-- Equipos más limpios
SELECT 
    teams.name AS nombre_equipo,
    SUM(teamstats.fouls) AS faltas,
    SUM(teamstats.yellowcards) AS tarjetas_amarillas,
    SUM(teamstats.redcards) AS tarjetas_rojas
FROM 
    teams
INNER JOIN 
    teamstats ON teams.teamid = teamstats.teamid
GROUP BY 
    teams.name
ORDER BY 
    faltas ASC, tarjetas_amarillas ASC, tarjetas_rojas ASC
LIMIT 10;

-- Equipos más sucios
SELECT 
    teams.name AS nombre_equipo,
    SUM(teamstats.fouls) AS faltas,
    SUM(teamstats.yellowcards) AS tarjetas_amarillas,
    SUM(teamstats.redcards) AS tarjetas_rojas
FROM 
    teams
INNER JOIN 
    teamstats ON teams.teamid = teamstats.teamid
GROUP BY 
    teams.name
ORDER BY 
    faltas DESC, tarjetas_amarillas DESC, tarjetas_rojas DESC
LIMIT 10;


