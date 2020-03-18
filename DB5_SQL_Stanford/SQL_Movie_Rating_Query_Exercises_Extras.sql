/*
Movie ( mID, title, year, director )
English: There is a movie with ID number mID, a title, a release year, and a director.

Reviewer ( rID, name )
English: The reviewer with ID number rID has a certain name.

Rating ( rID, mID, stars, ratingDate )
English: The reviewer rID gave the movie mID a number of stars rating (1-5) on a certain ratingDate.
*/


--1. Find the names of all reviewers who rated Gone with the Wind.
select distinct name
from Movie inner join Rating using(mID)
inner join Reviewer using(rID)
where title = 'Gone with the Wind';

--2. For any rating where the reviewer is the same as the director of the movie, return the reviewer name, movie title, and number of stars.
select name, title, stars
from Movie inner join Rating using(mID)
inner join Reviewer using(rID)
where name = director;

--3. Return all reviewer names and movie names together in a single list, alphabetized. (Sorting by the first name of the reviewer and first word in the title is fine; no need for special processing on last names or removing "The".)
select name
from Reviewer
union
select title
from Movie
order by name, title;

--4. Find the titles of all movies not reviewed by Chris Jackson.
select title
from Movie 
where mID not in 
(select mID from Rating inner join Reviewer using(rID) where name = 'Chris Jackson');

--5. For all pairs of reviewers such that both reviewers gave a rating to the same movie, return the names of both reviewers. Eliminate duplicates, don't pair reviewers with themselves, and include each pair only once. For each pair, return the names in the pair in alphabetical order.
select distinct r1.name, r2.name
from Reviewer r1, Reviewer r2, Rating rt1, Rating rt2
where rt1.mID = rt2.mID and rt1.rID = r1.rID and r2.rID = rt2.rID and r1.name < r2.name;

--6. For each rating that is the lowest (fewest stars) currently in the database, return the reviewer name, movie title, and number of stars.
select name, title, stars
from Movie inner join Rating using(mID)
inner join Reviewer using(rID)
where stars in (select min(stars) from Rating);

--7. List movie titles and average ratings, from highest-rated to lowest-rated. If two or more movies have the same average rating, list them in alphabetical order.
select title, avg(stars) as average
from Movie inner join Rating using(mID)
group by mID
order by average desc, title;

--8. Find the names of all reviewers who have contributed three or more ratings. (As an extra challenge, try writing the query without HAVING or without COUNT.)
SELECT name
FROM Reviewer
WHERE (SELECT COUNT(*) FROM Rating WHERE Rating.rId = Reviewer.rId) >= 3;

-- 9. Some directors directed more than one movie. For all such directors, return the titles of all movies directed by them, along with the director name. Sort by director name, then movie title.
SELECT title, director
FROM Movie M1
WHERE (SELECT COUNT(*) FROM Movie M2 WHERE M1.director = M2.director) > 1
ORDER BY director, title;

-- 10. Find the movie(s) with the highest average rating. Return the movie title(s) and average rating.
SELECT title, AVG(stars) AS average
FROM Movie
INNER JOIN Rating USING(mId)
GROUP BY mId
HAVING average = (
  SELECT MAX(average_stars)
  FROM (
    SELECT title, AVG(stars) AS average_stars
    FROM Movie
    INNER JOIN Rating USING(mId)
    GROUP BY mId
  )
);

-- 11. Find the movie(s) with the lowest average rating. Return the movie title(s) and average rating.
SELECT title, AVG(stars) AS average
FROM Movie
INNER JOIN Rating USING(mId)
GROUP BY mId
HAVING average = (
  SELECT MIN(average_stars)
  FROM (
    SELECT title, AVG(stars) AS average_stars
    FROM Movie
    INNER JOIN Rating USING(mId)
    GROUP BY mId
  )
);

-- 12. For each director, return the director's name together with the title(s) of the movie(s) they directed that received the highest rating among all of their movies, and the value of that rating. Ignore movies whose director is NULL. 
SELECT director, title, MAX(stars)
FROM Movie
INNER JOIN Rating USING(mId)
WHERE director IS NOT NULL
GROUP BY director;

