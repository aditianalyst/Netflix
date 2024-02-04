use Netflix


select * from [dbo].[filter database]


select * from [dbo].[netflix data]

1]Retrieve all titles from the [netflix data]

select TITLE from [netflix data]

2] Count the number of entries in the [netflix_data] table.

select COUNT(*)enteries from  [netflix data]

3]Retrieve titles of movies from the [netflix_data] table released in the year 2020.

select TITLE from [netflix data]
where TYPE = 'Movie' AND  RELEASE_YEAR=2020;

4]Retrieve titles and release years of content from the [netflix_data] table with IMDb scores greater than 8.0.

select TITLE ,RELEASE_YEAR
from [dbo].[netflix data] where  IMDB_SCORE >8;

5]Retrieve titles of content from the [netflix_data] table with a specific genre, e.g., 'Comedy'.

select TITLE FROM [netflix data]
WHERE GENRE = 'Comedy'

6] Retrieve titles of content from the [netflix_data] table produced in a specific country, e.g., 'United States'.

Select TITLE from [netflix data]
where PRODUCTION_COUNTRIES = 'United States';

7]Retrieve titles and IMDb scores of movies from the [dbo].[filter_database] table with IMDb scores between 6.0 and 8.0.
select TITLE,IMDB_SCORE FROM [filter database] 
where IMDB_SCORE between 6.0 and 8.0;


8] Retrieve titles of content from the [netflix_data] table where the title contains the word 'action'.

Select TITLE from [netflix data]
where TITLE like '%Action%'

9] Retrieve titles of content from the [dbo].[filter_database] table with a runtime between 60 and 120 minutes.

select TITLE from [filter database]where RUNTIME between 60 and 120 ;

10]Retrieve the average IMDb score for all content types in the [dbo].[filter_database] table.
select TYPE,AVG(IMDB_SCORE) FROM [filter database] GROUP BY TYPE;

11]Retrieve the production countries and the count of content produced in each country from the [dbo].[filter_database] table.

select production_countries ,COUNT(*) from [filter database] group by PRODUCTION_COUNTRIES;

12]Retrieve the distinct genres of movies  AND TITLE ='Dirty Harry' in the [dbo].[filter_database] table.

select DISTINCT(GENRE)
from [filter database]  WHERE TITLE = 'Dirty Harry'AND TYPE='MOVIE';

13] Retrieve the titles and release years of content from the [dbo].[filter_database] table with the lowest 5 IMDb scores.

select TITLE , RELEASE_YEAR from [filter database]
where IMDB_SCORE<5;



#INTERMEDIATE QUESTION 


1] Retrieve titles and release years of movies from both tables released after the year 2010.


select TITLE, RELEASE_YEAR 
from [dbo].[filter database] where release_year>2010 AND TYPE= 'MOVIE'
union
select TITLE, RELEASE_YEAR 
from [dbo].[netflix data]where release_year>2010 AND TYPE= 'MOVIE'

2]Retrieve titles and release years of movies with the highest IMDb score for each genre from both tables.

select  GENRE, max(IMDB_SCORE) AS MAXIMUM_SCORE
FROM( 
 SELECT GENRE,TITLE, IMDB_SCORE  FROM [dbo].[netflix data]
UNION ALL
SELECT GENRE, TITLE,IMDB_SCORE FROM [dbo].[filter database]
)
AS ALLDATA
GROUP BY GENRE;

3]Retrieve the titles of movies with the same title but different release years.

SELECT 
    TITLE,
    STUFF((SELECT DISTINCT ',' + CAST(RELEASE_YEAR AS VARCHAR) 
           FROM [netflix data] AS t2 
           WHERE t2.TITLE = t1.TITLE 
           FOR XML PATH('')), 1, 1, '') AS ReleaseYears
FROM [netflix data] AS t1
GROUP BY TITLE
HAVING COUNT(DISTINCT RELEASE_YEAR) > 1;



4]Find the top 5 production countries with the highest average IMDb scores for movies.

Select TOP 5 production_countries ,avg(IMDB_SCORE)AS HIGHESTSCORE from [dbo].[netflix data]
WHERE TYPE = 'MOVIE'
GROUP BY production_countries
ORDER BY HIGHESTSCORE  DESC


5]List the titles and release years of movies with the lowest and highest IMDb scores for each genre.

SELECT TITLE, RELEASE_YEAR, IMDB_SCORE
FROM (
    SELECT TITLE, RELEASE_YEAR, IMDB_SCORE, ROW_NUMBER() OVER (PARTITION BY GENRE ORDER BY IMDB_SCORE ASC) AS AscRank,
    ROW_NUMBER() OVER (PARTITION BY GENRE ORDER BY IMDB_SCORE DESC) AS DescRank
    FROM [netflix data]
) AS Ranked
WHERE AscRank = 1 OR DescRank = 1;




#ADVANCE
1]Retrieve the titles and IMDb scores of movies, along with their rank within each genre based on IMDb score (highest score gets rank 1).

select title,IMDB_SCORE,GENRE,
RANK() OVER(PARTITION BY GENRE ORDER BY IMDB_SCORE)AS IMDB_RANK
FROM [dbo].[netflix data] WHERE TYPE='MOVIE'

2]Determine the median IMDb score for movies in each genre using a window function.

WITH MedianCTE AS (
    SELECT 
        TITLE, 
        GENRE, 
        IMDB_SCORE,
        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY IMDB_SCORE) 
            OVER (PARTITION BY GENRE) AS MedianScore
    FROM [netflix data] 
    WHERE TYPE = 'Movie'
)
SELECT TITLE, GENRE, IMDB_SCORE, MedianScore
FROM MedianCTE;


3]List the titles and production countries of movies along with any TV shows that share the same production country.

select m.title,m.production_countries
from [dbo].[netflix data]m
left join [dbo].[netflix data] t on m.production_countries = t.production_countries and t.type = 'TV'
WHERE m.type='MOVIE'


4]Retrieve the titles of movies and TV shows available in the dataset during a specific date range, considering their release years and seasons.

SELECT TITLE,RELEASE_YEAR,TYPE
FROM [dbo].[netflix data] 
WHERE (TYPE = 'MOVIE' AND RELEASE_YEAR BETWEEN 2000 AND 2010)
OR (TYPE = 'TV' AND SEASONS = 1 AND RELEASE_YEAR BETWEEN 2000 AND 2010)




























