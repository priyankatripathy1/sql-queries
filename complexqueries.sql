-----------Get the program with the maximum number of batches

select batch_program_id , count(batch_id)
from tbl_lms_batch
group by (batch_program_id)
order by count(batch_id) desc limit 1


select batchPrgraomCount.cnt, lp.* from tbl_lms_program lp
inner join 
(select batch_program_id,count(batch_id) as cnt
from tbl_lms_batch b
group by (batch_program_id)
order by count(batch_id) desc limit 1) as batchPrgraomCount
on lp.program_id = batchPrgraomCount.batch_program_id

------Get the program with the maximum number of users
select count (urm.user_id),b.batch_program_id from tbl_lms_batch b
inner join tbl_lms_userbatch_map ubm
 on b.batch_id=ubm.batch_id
inner join tbl_lms_userrole_map urm
 on urm.user_role_id=ubm.user_role_id
group by (b.batch_program_id)
 order by count(urm.user_id) desc limit 1
 
 ------Get batch with maximum number of users
 select count (u.user_id),b.batch_id from tbl_lms_batch b
inner join tbl_lms_userbatch_map ubm 
	on b.batch_id=ubm.batch_id
inner join tbl_lms_userrole_map urm	
	on ubm.user_role_id=urm.user_role_id
inner join tbl_lms_user u
	on urm.user_id=u.user_id
group by b.batch_id
order by count (u.user_id) desc limit 1;

-------For a particular user mark his status as Inactive and mark the role also as inactive

update tbl_lms_userrole_map 
set user_role_status='INACTIVE' 
where user_id='U01';
	
update tbl_lms_user_login
set user_login_status='INACTIVE' 
where user_id='U01';

select * from tbl_lms_user_login
----Two tables cannot update in one query---------

------Get all users for a batch and then get the user with the highest grade for a particular assignment
	
select s.sub_student_id,max (s.grade)from tbl_lms_batch b
inner join tbl_lms_assignments a
	on b.batch_id=a.a_batch_id	
inner join tbl_lms_submissions s
	on s.sub_a_id=a.a_id
where a.a_id=2 and b.batch_id=2
group by s.sub_student_id;
		
	
select s.sub_student_id,max (s.grade)from tbl_lms_batch b
inner join tbl_lms_assignments a
	on b.batch_id=a.a_batch_id	
inner join tbl_lms_submissions s
	on s.sub_a_id=a.a_id
where a.a_id=2 
group by s.sub_student_id;

--select * from tbl_lms_assignments;
--select * from tbl_lms_submissions;

------Delete an exisiting role (all relevant tables should be affected)

INSERT INTO public.tbl_lms_user(
 user_id,user_first_name, user_last_name, user_phone_number, user_location, user_time_zone, user_linkedin_url, user_edu_ug, user_edu_pg, user_comments, user_visa_status, creation_time, last_mod_time)
 VALUES ('U13','Priya', 'Tripathy', '6052050088', 'Atlanta', 'EST', 'https://www.linkedin.com/in/priyankatripathy/', 'BCA', 'MBA', null, 'H4-EAD', LOCALTIMESTAMP,LOCALTIMESTAMP);

INSERT INTO public.tbl_lms_role(
 role_id, role_name, role_desc, creation_time, last_mod_time)
 VALUES ('R05', 'Instructor', 'LMS_Instructor', LOCALTIMESTAMP, LOCALTIMESTAMP);
 
INSERT INTO public.tbl_lms_userrole_map(
 user_id, role_id, user_role_status, creation_time, last_mod_time)
 VALUES ('U13','R05','Active', LOCALTIMESTAMP,LOCALTIMESTAMP ); 

INSERT INTO public.tbl_lms_batch(
 batch_id, batch_name, batch_description, batch_status, batch_program_id, batch_no_of_classes, creation_time, last_mod_time)
 VALUES (99, '100', 'Api Testing using POSTMAN', 'Active',3, 2, LOCALTIMESTAMP,LOCALTIMESTAMP );

INSERT INTO public.tbl_lms_userbatch_map(
 ub_map_id, user_role_id, batch_id)
 VALUES ('UR01',12, 99);
 
Delete from tbl_lms_role
where role_id='R05';

----1) Get users by name 2) Get users by Program

select * from tbl_lms_user where user_first_name = 'Priyanka' and user_last_name = 'Tripathy'

select p.program_id, u.* from tbl_lms_user u
inner join tbl_lms_userrole_map urm
 on u.user_id = urm.user_id
inner join tbl_lms_userbatch_map ubm
 on urm. user_role_id = ubm.user_role_id
inner join tbl_lms_batch b
 on ubm.batch_id = b.batch_id
inner join tbl_lms_program p
 on b.batch_program_id = p.program_id
order by p.program_id
