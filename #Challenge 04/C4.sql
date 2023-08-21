/*#Challenge 04
Samantha interviews many candidates from different colleges using coding challenges and contests. 
Write a query to print the contest_id, emp_id, name, and
the sums of t_submission, t_accept_submissions, t_views, and t_unique_views
for each contest sorted by contest_id. Exclude the contest from the result if all four sums are 0.
Note: A specific contest can be used to screen candidates at more than one college, 
but each college only holds 1 screening contest. The DDL Command is given by –
*/

create database interview_db;

use interview_db;


create table contests (
     contest_id int,
     emp_id int,
     `name` char(20));


insert into contests (contest_id, emp_id, `name`)
values (66406, 17973, "Pat"),
(66556, 79153, "Julia"),
(94828, 80275, "Matt");

#select * from contests;

 create table colleges (
college_id int,
contest_id int);

insert into colleges (college_id, contest_id)
values (11219, 66406),
(32473,66556),
(56685,94828);

select * from colleges;

create table challenges (
challenge_id int,
college_id int);

insert into challenges (challenge_id, college_id)
values (18765,11219),
(47127,11219),
(60292,32473),
(72974, 56685);

select * from challenges;

create table view_stats (
challenge_id int,
t_views int,
t_unique_views int);

insert into view_stats (challenge_id, t_views, t_unique_views)
values (47127, 26, 19),
(47127, 15, 14),
(18765, 43, 10),
(18765, 72, 13),
(75516, 35, 17),
(60292, 11, 10),
(72974, 41, 15),
(75516, 75, 11);

select * from view_stats;

create table submission_stats (
challenge_id int,
t_submissions int,
t_accept_submissions int);

insert into submission_stats (challenge_id, t_submissions, t_accept_submissions)
values (75516, 34, 12),
(47127, 27, 10),
(47127, 56, 18),
(75516, 74, 12),
(75516, 83, 8),
(72974, 68, 24),
(72974, 82, 14),
(47127, 28, 11);

select * from submission_stats;

/*--------------------------------------------Query--------------------------------------------*/

SELECT 
    C.contest_id,C.emp_id,C.`name`,
    COALESCE(SUM(ss.t_submissions) ,0) AS sum_t_submission,
    COALESCE(SUM(ss.t_accept_submissions),0) AS sum_t_accept_submissions,
    COALESCE(SUM(vs.t_views),0) AS sum_t_views,
    COALESCE(SUM(vs.t_unique_views),0) AS sum_t_unique_views
FROM
    contests C
        INNER JOIN
    colleges Cl ON C.contest_id = Cl.contest_id
        INNER JOIN
    challenges Ch ON Cl.college_id = Ch.college_id
        LEFT JOIN
    (SELECT 
        challenge_id,
        SUM(t_submissions) AS t_submissions,
        SUM(t_accept_submissions) AS t_accept_submissions
    FROM
        submission_stats
    GROUP BY challenge_id) ss ON Ch.challenge_id = ss.challenge_id
        LEFT JOIN
    (SELECT 
        challenge_id,
        SUM(t_views) AS t_views,
        SUM(t_unique_views) AS t_unique_views
    FROM
        view_stats
    GROUP BY challenge_id) vs ON Ch.challenge_id = vs.challenge_id
GROUP BY C.contest_id , C.emp_id , C.`name`
HAVING !( SUM(ss.t_submissions) = 0 
	AND SUM(ss.t_accept_submissions) = 0
    AND SUM(vs.t_views) = 0 
    AND SUM(vs.t_unique_views) = 0)
ORDER BY C.contest_id;