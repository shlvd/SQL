/*
Movie ( mID, title, year, director )
English: There is a movie with ID number mID, a title, a release year, and a director.

Reviewer ( rID, name )
English: The reviewer with ID number rID has a certain name.

Rating ( rID, mID, stars, ratingDate )
English: The reviewer rID gave the movie mID a number of stars rating (1-5) on a certain ratingDate.
*/


-- 1. Find the titles of all movies directed by Steven Spielberg.
select title 
from Movie
where director = 'Steven Spielberg';

--2. Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order.
select distinct year
from Movie inner join Rating
on Movie.mID = Rating.mID
where stars >= 4
order by year;

--3. Find the titles of all movies that have no ratings.
select title
from Movie left join Rating
on Movie.mID = Rating.mID
where stars is NULL;

SELECT title
FROM Movie
WHERE mId NOT IN (SELECT mID FROM Rating);

--4. Some reviewers didn't provide a date with their rating. Find the names of all reviewers who have ratings with a NULL value for the date.
select name
from Reviewer inner join Rating
on Reviewer.rID = Rating.rID
where ratingDate is NULL;

--5. Write a query to return the ratings data in a more readable format: reviewer name, movie title, stars, and ratingDate. Also, sort the data, first by reviewer name, then by movie title, and lastly by number of stars.
select name as reviewerName, title as movieTitle, stars, ratingDate
from (Movie inner join Rating on Movie.mID = Rating.mID) inner join Reviewer on Rating.rID = Reviewer.rID
order by reviewerName, movieTitle, stars;

--6. For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time, return the reviewer's name and the title of the movie.
select name, title
from Movie inner join Rating rt1 on Movie.mID = rt1.mID 
inner join Rating rt2 on rt1.rID = rt2.rID
inner join Reviewer rv on rt2.rID = rv.rID
where rt1.mID = rt2.mID AND rt1.ratingDate < rt2.ratingDate AND rt1.stars < rt2.stars;

--7. For each movie that has at least one rating, find the highest number of stars that movie received. Return the movie title and number of stars. Sort by movie title.
select title, max(stars)
from Movie join Rating using(mID)
group by mID
order by title;

--8. For each movie, return the title and the 'rating spread', that is, the difference between highest and lowest ratings given to that movie. Sort by rating spread from highest to lowest, then by movie title.
select title, (max(stars) - min(stars)) as spread
from Movie join Rating using(mID)
group by mID
order by spread desc, title;

--9. Find the difference between the average rating of movies released before 1980 and the average rating of movies released after 1980. (Make sure to calculate the average rating for each movie, then the average of those averages for movies before 1980 and movies after. Don't just calculate the overall average rating before and after 1980.)
select avg(Before1980.avg) - avg(After1980.avg)
from 
 (select avg(stars) as avg from Movie inner join Rating using(mId) where year < 1980 group by mId) 
 as Before1980,
 (select avg(stars) as avg from Movie inner join Rating using(mId) where year > 1980 group by mId)
 as After1980;