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