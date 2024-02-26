-- SQL IMPORTANTE

-- donde está un atributo
SELECT
    table_name,
    column_name
FROM
    information_schema.columns
where lower(column_name) like '%shooterid%';

-- atributos tabla
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'appearances';

SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'games';

SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'leagues';

SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'players';

SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'shots';

SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'teams';

SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'teamstats';

-- selects tablas
select * from appearances;
select * from games;
select * from leagues;
select * from players;
select * from shots;
select * from teams;
select * from teamstats;


/*
Tablas - Atributos:
	appearances:
		"leagueid"
		"playerid"
		"goals"
		"owngoals"
		"shots"
		"xgoals"
		"xgoalschain"
		"xgoalsbuildup"
		"assists"
		"keypasses"
		"xassists"
		"gameid"
		"positionorder"
		"yellowcard"
		"redcard"
		"time"
		"substitutein"
		"substituteout"
		"position"
	
	games:
		"psca"
		"leagueid"
		"season"
		"gameid"
		"hometeamid"
		"awayteamid"
		"homegoals"
		"awaygoals"
		"homeprobability"
		"drawprobability"
		"awayprobability"
		"homegoalshalftime"
		"awaygoalshalftime"
		"b365h"
		"b365d"
		"b365a"
		"bwh"
		"bwd"
		"bwa"
		"iwh"
		"iwd"
		"iwa"
		"psh"
		"psd"
		"psa"
		"whh"
		"whd"
		"wha"
		"vch"
		"vcd"
		"vca"
		"psch"
		"pscd"
		"date"
		
	leagues:
		"leagueid"
		"name"
		"understatnotation"
	
	players:
		"playerid"
		"name"
		
	shots:
		"gameid"
		"shooterid"
		"assisterid"
		"minute"
		"xgoal
		"positionx"
		"positiony"
		"shotresult"
		"situation"
		"lastaction"
		"shottype"
	
	teams:
		"teamid"
		"name"
		
	teamstats:
		"gameid"
		"teamid"
		"season"
		"corners"
		"yellowcards"
		"redcards"
		"goals"
		"xgoals"
		"shots"
		"shotsontarget"
		"deep"
		"ppda"
		"fouls"
		"date"
		"location"
		"result"
*/
