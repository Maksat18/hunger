create database hunger;
show databases;
use hunger;

/* adding pks*/
alter table food_deficit add column id int
NOT NULL AUTO_INCREMENT PRIMARY KEY FIRST;
alter table number_undernourished add column id int
NOT NULL AUTO_INCREMENT PRIMARY KEY FIRST;
alter table prevalence_of_stunning add column id int
NOT NULL AUTO_INCREMENT PRIMARY KEY FIRST;
alter table prevalence_of_underweight add column id int
NOT NULL AUTO_INCREMENT PRIMARY KEY FIRST;
alter table prevalence_of_wasting add column id int
NOT NULL AUTO_INCREMENT PRIMARY KEY FIRST;

-- using the select --
select
	entity,
    year,
    food_deficit_kilocalories_per_person_per_day
from food_deficit;
-- where clause --
select
	entity,
    year,
    food_deficit_kilocalories_per_person_per_day
from food_deficit
where entity='Turkmenistan';

-- and, or, not operators  --
select
	*
from food_deficit
where entity='Turkmenistan' and entity= 'Uzbekistan';

select
	*
from food_deficit
where entity='Turkmenistan' or entity= 'Uzbekistan';

select
	*
from food_deficit
where not entity='Turkmenistan';

-- order  by and limit functions--
select
	*
from food_deficit
where entity='Turkmenistan' or entity= 'Uzbekistan'
order by year desc
limit 20;

-- in and between operator --
select 
	*
from prevalence_of_stunning
where year in('2014','2015','2016')
order by year;

select 
	*
from prevalence_of_stunning
where year between 2010 and 2018
order by year desc;

-- creating aggregate function tables through inner and left join--
create table min_value as select
f.entity as country_name,
f.year as year,
min(round((f.food_deficit_kilocalories_per_person_per_day),2)) as min_kilocalrories,
min(round((n.number_undernourished),2)) as min_undernourished,
min(round((s.height_for_age),2)) as min_height_for_age,
min(round((u.weight_for_age),2)) as min_weight_for_age,
min(round((w.weight_for_height),2)) as min_weight_for_height
from food_deficit f
inner join number_undernourished n on n.code=f.code
inner join prevalence_of_stunning s on s.code=n.code
inner join prevalence_of_underweight u on u.code=s.code
inner join prevalence_of_wasting w on w.code=u.code
group by f.entity;

create table max_value as select
f.entity as country_name,
f.year as year,
max(round((f.food_deficit_kilocalories_per_person_per_day),2)) as max_kilocalrories,
max(round((n.number_undernourished),2)) as max_undernourished,
max(round((s.height_for_age),2)) as max_height_for_age,
max(round((u.weight_for_age),2)) as max_weight_for_age,
max(round((w.weight_for_height),2)) as max_weight_for_height
from food_deficit f
inner join number_undernourished n on n.code=f.code
inner join prevalence_of_stunning s on s.code=n.code
inner join prevalence_of_underweight u on u.code=s.code
inner join prevalence_of_wasting w on w.code=u.code
group by f.entity;

create table avg_value as select
f.entity as country_name,
f.year as year,
avg(round((f.food_deficit_kilocalories_per_person_per_day),2)) as avg_kilocalrories,
avg(round(n.number_undernourished ,2)) as avg_undernourished,
avg(round(s.height_for_age, 2)) as avg_height_for_age,
avg(round(u.weight_for_age,2)) as avg_weight_for_age,
avg(round(w.weight_for_height,2)) as avg_weight_for_height
from food_deficit f
inner join number_undernourished n on n.code=f.code
inner join prevalence_of_stunning s on s.code=n.code
inner join prevalence_of_underweight u on u.code=s.code
inner join prevalence_of_wasting w on w.code=u.code
group by f.entity;

-- union all --
select distinct
	entity,
    year, 
   height_for_age
from prevalence_of_stunning
union all
select
	entity,
    year,
    weight_for_height
from prevalence_of_wasting; 

-- cross join --
select distinct 
	f.entity,
    f.year,
    f.food_deficit_kilocalories_per_person_per_day,
    n.number_undernourished
from food_deficit f
cross join number_undernourished n
where f.entity = n.entity;

-- subsqueries with wild- cards--
select 
	f.entity,
    f.food_deficit_kilocalories_per_person_per_day,
    n.number_undernourished
from food_deficit f, number_undernourished n
where food_deficit_kilocalories_per_person_per_day >
	(select 
		avg(food_deficit_kilocalories_per_person_per_day)
        from food_deficit);
        
select 
	s.entity,
    s.height_for_age,
    u.weight_for_age
from prevalence_of_stunning s ,prevalence_of_underweight u
where weight_for_age <=
	(select 
		avg(weight_for_age)
        from prevalence_of_underweight);
        
-- case command--
select *,
	CASE WHEN food_deficit_kilocalories_per_person_per_day <= 241.56 THEN 'Urgent'
	WHEN food_deficit_kilocalories_per_person_per_day >= 241.56 THEN 'Not Urgent'
	ELSE'No Ignorance'
	END AS Comment_on_food_deficit
	FROM food_deficit 
    order by food_deficit_kilocalories_per_person_per_day;
    
-- locate--
select distinct *,
locate('stan', entity) as MatchPosition
from number_undernourished; 

select distinct *,
locate('stan', entity) as MatchPosition
from number_undernourished
where locate('stan', entity)>5;

-- position--

select distinct *,
position("stan" in entity)as MatchPostion
from prevalence_of_stunning;

select distinct *,
position('stan' in entity) as MatchPosition
from prevalence_of_stunning
where position('stan' in entity)>5;

-- insert function in case insensitiv--
select *, Insert( entity, locate ("Stan",entity), 0, "-")  as countries_ends_stan 
from number_undernourished
where locate ("stan", entity)>0;








