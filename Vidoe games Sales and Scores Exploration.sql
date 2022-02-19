-- Vidoe games Sales and Scores Exploration

-- Top 10 Publisher that made the most of games since 1977 - 2017.

SELECT 
Publisher,
Count(DISTINCT name) as  Amount_games
FROM vgsales 
GROUP by Publisher
ORDER by Amount_games DESC LIMIT 10 ;

-- Top 10 Publishers that made the most of games each year

WITH TOPTEN AS (
	SELECT 
	Year, 
	Publisher,
	count(DISTINCT name) Amount_games ,
	row_number()
		over (
			PARTITION BY Year ORDER by count(DISTINCT name)DESC
       
			 ) AS Ranks
	FROM vgsales
	GROUP by Year, Publisher
	ORDER by Year
				)
SELECT * FROM TOPTEN WHERE Ranks <= 10;


-- Top 10 Publishers that made the most games in 2010.

WITH TOPTEN AS (
	SELECT 
	Year, 
	Publisher,
	count(DISTINCT name) Amount_games ,
	row_number()
		over (
			PARTITION BY Year ORDER by count(DISTINCT name)DESC
       
			 ) AS Ranks
	FROM vgsales
	GROUP by Year, Publisher
	ORDER by Year
				)
SELECT * FROM TOPTEN WHERE Ranks <= 10 and Year = 2010;

-- Top 10 best seller (1997-2017) from Global sales.
SELECT name, 
sum(Global_Sales) as total_sales
from vgsales
GROUP by name
order by total_sales Desc LIMIT 10 ;

-- Top 10 platforms that have the most of games.
SELECT 
platform,
count(name) total_games
from vgsales
GROUP BY platform
ORDER by total_games desc limit 10;


-- Top 10 games score by Metacritic.
SELECT v.name,
v.Year,
v.platform,
round(m.meta_score/10.00, 2) meta_scores,
m.user_review user_scores
from vgsales v 
LEFT JOIN meta m
ON v.name = m.name and v.platform = m.platform
where meta_scores is not null and user_scores <> "tbd"
order by meta_scores DESC LIMIT 10;

-- Top 10 games score by user review.
SELECT v.name,
v.Year,
v.platform,
m.user_review user_scores,
round(m.meta_score/10.00, 2) meta_scores
from vgsales v 
LEFT JOIN meta m
ON v.name = m.name and v.platform = m.platform
where meta_scores is not null and user_scores <> "tbd"
order by user_scores DESC LIMIT 10;

-- Top 10 years that have the most sales
SELECT Year,
round(sum(Global_Sales),2) Total_sales
from vgsales
GROUP by year
Order by Total_sales DESC LIMIT 10 ;

-- The year with the lowest sales
SELECT Year,
round(sum(Global_Sales),2) Total_sales
from vgsales
GROUP by year
Order by Total_sales  ASC LIMIT 1 ;

-- Top 10 Genres that have the most sales.
SELECT Genre,
round(sum(Global_Sales),2) Total_sales
from vgsales
GROUP by Genre
Order by Total_sales DESC LIMIT 10 ;

-- Average Metacritic score by Genre.
WITH Genre_score as (
SELECT v.Genre,
round(m.meta_score/10.00, 2) meta_scores
from vgsales v 
LEFT JOIN meta m
ON v.name = m.name and v.platform = m.platform
where meta_scores is not null
order by meta_scores 
)
SELECT Genre, round(sum(meta_scores)/count(meta_scores), 2) as Meta_average_score
FROM Genre_score
GROUP by Genre
ORDER by Meta_average_score DESC;


-- Average user score by Genre.
WITH Genre_uscore as (
SELECT v.Genre,
m.user_review as user_scores
from vgsales v 
LEFT JOIN meta m
ON v.name = m.name and v.platform = m.platform
where user_scores <> "tbd"
order by user_scores
)
SELECT Genre, round(sum(user_scores)/count(user_scores), 2) as User_average_score
FROM Genre_uscore
GROUP by Genre
ORDER by User_average_score DESC;




