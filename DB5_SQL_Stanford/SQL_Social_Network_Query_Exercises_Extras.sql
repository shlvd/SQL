/*
Highschooler ( ID, name, grade )
English: There is a high school student with unique ID and a given first name in a certain grade.

Friend ( ID1, ID2 )
English: The student with ID1 is friends with the student with ID2. Friendship is mutual, so if (123, 456) is in the Friend table, so is (456, 123).

Likes ( ID1, ID2 )
English: The student with ID1 likes the student with ID2. Liking someone is not necessarily mutual, so if (123, 456) is in the Likes table, there is no guarantee that (456, 123) is also present.
*/

--1. For every situation where student A likes student B, but student B likes a different student C, return the names and grades of A, B, and C.
select H1.name, H1.grade, H2.name, H2.grade, H3.name, H3.grade
from Highschooler H1, Highschooler H2, Highschooler H3, Likes L1, Likes L2
where H1.ID = L1.ID1 and H2.ID = L1.ID2 and (H2.ID = L2.ID1 and H3.ID = L2.ID2 and H3.ID <> H1.ID);

--2. Find those students for whom all of their friends are in different grades from themselves. Return the students' names and grades.
select name, grade
from Highschooler H1
where grade not in 
(select H2.grade from Friend, Highschooler H2 where H1.ID = Friend.ID1 and H2.ID = Friend.ID2);

--3. What is the average number of friends per student? (Your result should be just one number.)
select avg(c)
from (select count(*) as c from Friend group by ID1);

--4. Find the number of students who are either friends with Cassandra or are friends of friends of Cassandra. Do not count Cassandra, even though technically she is a friend of a friend.
select count(*) from Friend
where ID1 in (select ID2 from Friend where ID1 in (
    select ID from Highschooler where name = 'Cassandra'));

--5. Find the name and grade of the student(s) with the greatest number of friends.
select name, grade
from Highschooler inner join Friend on Highschooler.ID = Friend.ID1
group by ID1
having count(*) = (select max(c) from (
    select count(*) as c from Friend group by ID1));

