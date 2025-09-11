--- Mananing dates

select * 
from my_table
where updated_at >= '2025-07-21'::date;

select convert_timezone('UTC', 'America/Sao_Paulo', created_at::timestamp) as created_at, convert_timezone('UTC', 'America/Sao_Paulo', updated_at::timestamp) as updated_at
from my_table;

select date_trunc('day', convert_timezone('UTC', 'America/Sao_Paulo', created_at::timestamp)) as dia, count(*) as quantidade
from my_table;

select * 
from my_table
where date(SUBSTRING(created_at, 1, 10)) = date('2025-03-25');

select *
from my_table
where TO_DATE(created_at, 'dd/mm/yyyy') between TO_DATE('05/02/2025', 'dd/mm/yyyy') and TO_DATE('15/02/2025', 'dd/mm/yyyy')
order by TO_DATE(created_at, 'dd/mm/yyyy') asc;

--- Using alias

select *,
case
    when status = 'EMPLOYED' then 'EMPREGADO'
    else 'DESEMPREGADO'
end as situacao
from my_table;

--- Working with CTEs

with filtered_results as (
    select * 
    from my_table
    where updated_at >= '2025-07-21'::date
)

select *
from filtered_results
where id > 10;

--- Handle nullable values

select id, coalesce(description, 'No description provided') as description
from my_table;

select * 
from my_table
where description is not null;

--- Working with strings

select * 
from my_table
where description like '%redash%';

select * 
from my_table
where description ilike '%Redash%';

--- Working with aggregators

select SUM(CAST(json_extract_scalar(t.attributes, '$.salary') AS DECIMAL)) AS total
from my_table
where date(SUBSTRING(admission_date, 1, 10)) >= date('2025-01-27');

--- Working with JSON

select *
from my_table mt
where json_extract_path_text(mt.status, 'status') = 'employed'
