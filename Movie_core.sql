/* Create the database*/
/*create database Movie;*/
use Movie;

/* Delete the tables if they already exist */
drop table if exists Movie;
drop table if exists Reviewer;
drop table if exists Rating;

/* Create the schema for our tables */
create table Movie(mID int, title text, year int, director text);
create table Reviewer(rID int, name text);
create table Rating(rID int, mID int, stars int, ratingDate date);

/* Populate the tables with our data */
insert into Movie values(101, 'Gone with the Wind', 1939, 'Victor Fleming');
insert into Movie values(102, 'Star Wars', 1977, 'George Lucas');
insert into Movie values(103, 'The Sound of Music', 1965, 'Robert Wise');
insert into Movie values(104, 'E.T.', 1982, 'Steven Spielberg');
insert into Movie values(105, 'Titanic', 1997, 'James Cameron');
insert into Movie values(106, 'Snow White', 1937, null);
insert into Movie values(107, 'Avatar', 2009, 'James Cameron');
insert into Movie values(108, 'Raiders of the Lost Ark', 1981, 'Steven Spielberg');

insert into Reviewer values(201, 'Sarah Martinez');
insert into Reviewer values(202, 'Daniel Lewis');
insert into Reviewer values(203, 'Brittany Harris');
insert into Reviewer values(204, 'Mike Anderson');
insert into Reviewer values(205, 'Chris Jackson');
insert into Reviewer values(206, 'Elizabeth Thomas');
insert into Reviewer values(207, 'James Cameron');
insert into Reviewer values(208, 'Ashley White');

insert into Rating values(201, 101, 2, '2011-01-22');
insert into Rating values(201, 101, 4, '2011-01-27');
insert into Rating values(202, 106, 4, null);
insert into Rating values(203, 103, 2, '2011-01-20');
insert into Rating values(203, 108, 4, '2011-01-12');
insert into Rating values(203, 108, 2, '2011-01-30');
insert into Rating values(204, 101, 3, '2011-01-09');
insert into Rating values(205, 103, 3, '2011-01-27');
insert into Rating values(205, 104, 2, '2011-01-22');
insert into Rating values(205, 108, 4, null);
insert into Rating values(206, 107, 3, '2011-01-15');
insert into Rating values(206, 106, 5, '2011-01-19');
insert into Rating values(207, 107, 5, '2011-01-20');
insert into Rating values(208, 104, 3, '2011-01-02');

/*Find the titles of all movies directed by Steven Spielberg. */
select distinct title from Movie
where director = 'Steven Spielberg';

/*Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order.*/
select distinct year
from Movie, Rating
where Movie.mID = Rating.mID
order by year;

/*Find the titles of all movies that have no ratings.*/
select title from Movie
where mID not in (select mID from Rating);

/*Some reviewers didn't provide a date with their rating. Find the names of all reviewers who have ratings with a NULL value for the date. */
select name
from Reviewer
where rID in (select rID from Rating where ratingDate is null);

/*Write a query to return the ratings data in a more readable format: reviewer name, movie title, stars, and ratingDate. Also, sort the data, 
first by reviewer name, then by movie title, and lastly by number of stars. */
select name, title, stars, ratingDate
from Movie, Reviewer, Rating
where Movie.mID = Rating.mID and Reviewer.rID = Rating.rID
order by name, title, stars;

/*For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time,
return the reviewer's name and the title of the movie. */
select Re1.name, title
from Movie, Reviewer as Re1, Rating as R1, Rating as R2
where Movie.mID = R1.mID and Movie.mID = R2.mID
and Re1.rID = R1.rID and R1.rID = R2.rID
and R1.ratingDate < R2.ratingDate and R2.stars > R1.stars;

/*For each movie that has at least one rating, find the highest number of stars that movie received. 
Return the movie title and number of stars. Sort by movie title.*/
select title, max(stars)
from Movie, Rating
where Movie.mID = Rating.mID
group by Movie.mID
order by title;

/*For each movie, return the title and the 'rating spread', that is, the difference between highest and lowest ratings given to that movie.
Sort by rating spread from highest to lowest, then by movie title. */
select title, max(stars) - min(stars) as spread
from Movie, Rating
where Movie.mID = Rating.mID
group by Movie.mID
order by spread desc, title;

/* Find the difference between the average rating of movies released before 1980 and the average rating of movies released after 1980.
(Make sure to calculate the average rating for each movie, then the average of those averages for movies before 1980 and movies after. 
Don't just calculate the overall average rating before and after 1980.) */
select 
(select avg(avgers) 
from (select avg(stars) as avgers
from Movie, Rating 
where Movie.mID = Rating.mID and year< 1980
group by Movie.mID) as beforeAvg)
- 
(select avg(avgers) 
from (select avg(stars) as avgers
from Movie, Rating 
where Movie.mID = Rating.mID and year > 1980
group by Movie.mID) as afterAvg) 
as difference;

