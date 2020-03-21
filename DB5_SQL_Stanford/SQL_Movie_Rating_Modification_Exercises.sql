/*
Movie ( mID, title, year, director )
English: There is a movie with ID number mID, a title, a release year, and a director.

Reviewer ( rID, name )
English: The reviewer with ID number rID has a certain name.

Rating ( rID, mID, stars, ratingDate )
English: The reviewer rID gave the movie mID a number of stars rating (1-5) on a certain ratingDate.
*/

--1. Add the reviewer Roger Ebert to your database, with an rID of 209.
insert into Reviewer
values ('209', 'Roger Ebert');

--2. Insert 5-star ratings by James Cameron for all movies in the database. Leave the review date as NULL.
insert into Rating
select (select rId from Reviewer where name = "James Cameron"), mId, 5, NULL
from Movie;

--3. For all movies that have an average rating of 4 stars or higher, add 25 to the release year. (Update the existing tuples; don't insert new tuples.)
update Movie
set year = year + 25
where mId in (
  select mId from Movie inner join Rating using(mId)
  group by mId
  having avg(stars) >= 4);

--4. Remove all ratings where the movie's year is before 1970 or after 2000, and the rating is fewer than 4 stars.
delete from Rating
where mId in (select mId from Movie where year < 1970 or year > 2000) and stars < 4;
