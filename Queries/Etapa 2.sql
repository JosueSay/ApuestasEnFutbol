-- INCISO 1
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

-- SIN RANK
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

-- CON RANK
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
	where r.equipo = t.teamid --and s.teamid = 148
ORDER BY
    season,
    leagueid,
    ranking;


-- INCISO 3
-- JUGADORES CON MAS GOLES
SELECT a.playerid, p.name, SUM(a.goals) as total_goles
FROM appearances a
JOIN players p ON a.playerid = p.playerid
GROUP BY a.playerid, p.name
ORDER BY total_goles DESC;


-- JUGADORES CON MAS PASES QUE HAN TERMINADO EN GOL, SEA IZQUIERDO O DERECHO
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

-- QUERIE UNIDO
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
ORDER BY GT.total_goles DESC, PG.pases_izquierdos_goles DESC, PG.pases_derechos_goles DESC, PG.pases_totales DESC 
--LIMIT 10
;

-- COMPARACION (no verdadero)
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


-- EQUIPOS - JUGADORES POR GOLES
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
ORDER BY GT.total_goles DESC
LIMIT 10;

-- EQUIPOS - JUGADORES POR ASISTENCIAS
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
ORDER BY AT.asistencias_totales DESC
LIMIT 10;







