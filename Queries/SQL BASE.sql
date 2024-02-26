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

-- selects tablas
select * from appearances;
select * from games;
select * from leagues;
select * from players;
select * from shots;
select * from teams;
select * from teamstats;
