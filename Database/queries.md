-- Select all actors, which have no other professions
select * from namebasics where primaryprofession LIKE 'actor';

--Count the number of alive actors
select count(*) from namebasics where primaryprofession LIKE '%actor%' AND deathyear is null;

-- Select all actresses, who also have other professions in the film industry
select * from namebasics where primaryprofession LIKE '%actress%';

-- Select all actresses, which have no other professions
select * from namebasics where primaryprofession LIKE 'actress';

-- Count the number of alive actresses
select count(*) from namebasics where primaryprofession LIKE '%actress%' AND deathyear is null;

-- Select the average rating of movies per country, as well as the number of votes
SELECT avg(rating.averagerating) AS avg,
sum(rating.numvotes) AS numberOfVotes,
aka.region FROM AKAS AS aka
JOIN ratings AS rating
ON aka.titleid = rating.tconst
GROUP BY aka.region
ORDER BY avg;


SELECT * FROM episode;
SELECT * FROM crew;
SELECT * FROM principals;
SELECT * FROM ratings;
SELECT * FROM akas;
SELECT * FROM titlebasics;
SELECT * FROM namebasics;

-- Count the genres by year range
SELECT count(*), genres
from titlebasics
WHERE startyear > 1910 AND startyear < 1920
group by genres;