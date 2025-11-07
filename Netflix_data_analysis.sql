create database p5;
USE p5;
CREATE TABLE netflix_analysis (
  show_id VARCHAR(20),
  type VARCHAR(20),
  title VARCHAR(400),
  director VARCHAR(400),
  cast TEXT,
  country VARCHAR(400),
  date_added VARCHAR(100),
  release_year INT,
  rating VARCHAR(50),
  duration VARCHAR(50),
  listed_in VARCHAR(400),
  description TEXT
);
LOAD DATA INFILE 'E:/DA/projects/sql projects/2/netflix_titles.csv'
INTO TABLE netflix_analysis
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;
select * from netflix_analysis



1.Count Movies vs TV Shows.
select type,count(*) as total_count from netflix_analysis group by type

2.Most common rating for movies and TV shows.
select * from (select type,rating,
count(*) as tcount,row_number()over(partition by type order by count(*) desc) as rw
 from netflix_analysis group by type,rating)x where rw=1

3.List movies released in a specific year (e.g., 2020).
select show_id,type,title,release_year from netflix_analysis where release_year=2020

4.Top 5 countries with most content.
select country,count(*) tcount from netflix_analysis group by country order by count(*) desc limit 5

5.Identify the longest movie 
SELECT 
	*
FROM netflix_analysis
WHERE type = 'Movie'
ORDER BY left(duration,3) desc

6.Content added in the last 5 years.
ALTER TABLE netflix_analysis ADD COLUMN date_added_parsed DATE;

UPDATE netflix_analysis
SET  date_added_parsed = STR_TO_DATE(NULLIF(date_added, ''), '%M %e, %Y');

select show_id,type,title,date_added_parsed from netflix_analysis where date_added_parsed
>=date_sub(curdate(),interval 5 year)
 
 7.All titles by director 'Rajiv Chilaka'.
 select title from netflix_analysis where director='Rajiv Chilaka'
 
 8.TV shows with more than 5 seasons (seasons > 5).
 select type,duration from netflix_analysis where type='TV show' and left(duration,1)>5
  
9.Total no of content added 
select count(*) as totalmovies from netflix_analysis 

10.year  with total content added
select  release_year,count(*) as tcount from  netflix_analysis group by release_year order by tcount desc

11.List movies that are documentaries.
select * from netflix_analysis where listed_in like '%Documen%'

12.Content with no director (NULL).
select * from netflix_analysis where director is null

13.How many movies actor 'Salman Khan' appeared in last 10 years 
select count(*) as total_movies from netflix_analysis where type='Movie' and cast like '%salman%'

14.country with most content added
select country,count(*) tcount from netflix_analysis group by country order by count(*) desc limit 1

15.Categorize descriptions as 'Bad' if they contain kill or violence, else 'Good'; count each category.
select 
case when description like '%kill%' or description like '%violence%' then  'bad'
else 'good'
end as category,count(*)
from netflix_analysis
group by category