# Netflix Movies and TV Shows Data Analysis using SQL

## 🎯 Project Objectives
- Compare the number of Movies vs TV Shows
- Identify the most common ratings by content type
- Analyze content trends by year and country
- Identify longest movies and high-season TV shows
- Analyze recent content additions
- Study director, actor, and genre-based patterns
- Categorize content based on description sentiment

---
## 🎯 Business Problem
With thousands of movies and TV shows on Netflix, it is challenging to understand content trends,
audience preferences, and platform growth using raw data alone. Netflix needs insights into content
distribution by type, country, rating, release year, and genre to make informed decisions on content
strategy, regional focus, and user engagement.

This project analyzes Netflix’s Movies and TV Shows dataset using SQL to uncover meaningful
business insights and content trends.

---

##  Dataset Description
-	show_id
-	type	
-	title	
-	director
-	cast
-	country
-	date_added	
-	release_year	
-	rating	
-	duration	
-	listed_in	
-	description

## 🛠 Tools & Technologies Used
- **MySQL** – Data querying and analysis  
- **SQL Window Functions** – Ranking and categorization  
- **Excel / CSV** – Data source
  
## 🗃 Database & Table Creation
```sql
CREATE DATABASE p5;
USE p5; 

CREATE TABLE Netflix_analysis (
    show_id VARCHAR(10),
    type VARCHAR(10),
    title VARCHAR(255),
    director VARCHAR(255),
    cast TEXT,
    country VARCHAR(255),
    date_added VARCHAR(50),
    release_year INT,
    rating VARCHAR(50),
    duration VARCHAR(50),
    listed_in VARCHAR(255),
    description TEXT
);
```
## Data Loading
```sql
LOAD DATA INFILE 'E:/DA/projects/sql projects/2/netflix_titles.csv'
INTO TABLE netflix_analysis
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;
```

## 📌 Business Problems and SQL Analysis

### 1.Count Movies vs TV Shows.
```sql
select type,count(*) as total_count from netflix_analysis group by type
 ```

### 2.Most common rating for movies and TV shows.
```sql
select * from (select type,rating,
count(*) as tcount,row_number()over(partition by type order by count(*) desc) as rw
 from netflix_analysis group by type,rating)x where rw=1
```
 
### 3.List movies released in a specific year (e.g., 2020).
```sql
select show_id,type,title,release_year from netflix_analysis where release_year=2020
```
 
### 4.Top 5 countries with most content.
```sql
select country,count(*) tcount from netflix_analysis
 group by country order by count(*) desc limit 5
```
 
### 5.Identify the longest movie 
```sql
SELECT 	title,duration FROM netflix_analysis
WHERE type = 'Movie'
ORDER BY left(duration,2) desc
 ```

### 6.Content added in the last 5 years.
```sql
ALTER TABLE netflix_analysis ADD COLUMN date_added_parsed DATE;

UPDATE netflix_analysis
SET  date_added_parsed = STR_TO_DATE(NULLIF(date_added, ''), '%M %e, %Y');

select show_id,type,title,date_added_parsed from netflix_analysis where date_added_parsed
>=date_sub(curdate(),interval 5 year)
 ```
 
 ### 7.All titles by director 'Rajiv Chilaka'.
 ```sql
 select title from netflix_analysis where director='Rajiv Chilaka'
 ```
 
 ### 8.TV shows with more than 5 seasons (seasons > 5).
 ```sql
 select type,duration from netflix_analysis where type='TV show' and left(duration,1)>5 
```
  
### 9.Total no of content added 
```sql
select count(*) as totalmovies from netflix_analysis 
``` 

### 10.year  with total content added
```sql
select  release_year,count(*) as tcount from  netflix_analysis
group by release_year order by tcount desc
``` 

### 11.List movies that are documentaries.
```sql
select title,listed_in from netflix_analysis where type='Movie' and  listed_in like '%Documen%'
``` 

### 12.Content with no director (NULL).
```sql
select * from netflix_analysis where director is null
``` 

### 13.How many movies actor 'Salman Khan' appeared in last 10 years 
```sql
select count(*) as total_movies from netflix_analysis where type='Movie' and cast like '%salman%'
```

### 14.country with most content added
```sql
select country,count(*) tcount from netflix_analysis
 group by country order by count(*) desc limit 1
 ```

### 15.Categorize descriptions as 'Bad' if they contain kill or violence, else 'Good'; count each category.
```sql

select 
case when description like '%kill%' or description like '%violence%' then  'bad'
else 'good' 
end as category,count(*) as total
from netflix_analysis
group by category
``` 

## Top 5 recommendations
-	Netflix’s Indian content production peaked between 2019–2021, aligning with the platform’s push for regional diversification and original programming.
-	From 2021 Tvshows increased rapidly.so add more content.
-	Add movies or tv show that don’t have violence
-	Netflix heavily invested in regional content like Sacred Games, Delhi Crime, and Lust Stories during this time.
-	Try to add more movies rather than tv show and that are in English
  
## Final Project Summary
This SQL analysis highlights Netflix’s strong emphasis on drama-based and Indian regional content, steady increase in local production after 2018, and the importance of metadata quality. The insights can help Netflix optimize its content acquisition and improve search personalization.

