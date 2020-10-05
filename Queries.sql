begin transaction
--students
insert into tblStudents(student_id, student_name) values(1, '1 Student')
insert into tblStudents(student_id, student_name) values(2, '2 Student')
insert into tblStudents(student_id, student_name) values(3, '3 Student')
insert into tblStudents(student_id, student_name) values(4, '4 Student')
insert into tblStudents(student_id, student_name) values(5, '5 Student')
--courses
insert into tblCourses(course_id, course_name) values(1,'1 course')
insert into tblCourses(course_id, course_name) values(2,'2 course')
insert into tblCourses(course_id, course_name) values(3,'3 course')
insert into tblCourses(course_id, course_name) values(4,'4 course')
--semester offfering
--need to make it start_date , end_date for consistency
insert into tblSemesterOfferings(semester_offering_id, course_id, startdate, enddate) values(1,1,'8/15/2020','12/15/2020')
insert into tblSemesterOfferings(semester_offering_id, course_id, startdate, enddate) values(2,2,'8/15/2020','12/15/2020')
insert into tblSemesterOfferings(semester_offering_id, course_id, startdate, enddate) values(3,3,'8/15/2020','12/15/2020')
insert into tblSemesterOfferings(semester_offering_id, course_id, startdate, enddate) values(4,4,'8/15/2020','12/15/2020')
--student_courses - Student SemesterOffering
--drop table 
insert into jnctStudentSemesterOffering(student_id, semester_offering_id) values(1,1)
insert into jnctStudentSemesterOffering(student_id, semester_offering_id) values(2,1)
insert into jnctStudentSemesterOffering(student_id, semester_offering_id) values(2,2)
insert into jnctStudentSemesterOffering(student_id, semester_offering_id) values(3,3)
insert into jnctStudentSemesterOffering(student_id, semester_offering_id) values(4,4)
insert into jnctStudentSemesterOffering(student_id, semester_offering_id) values(5,4)



--templates
insert into tblTemplates(template_id, template_name) values(1,'1 template')
insert into tblTemplates(template_id, template_name) values(2,'2 template')
insert into tblTemplates(template_id, template_name) values(3,'3 template')
insert into tblTemplates(template_id, template_name) values(4,'4 template')
--questions
--lkuQuestionType
--data type would drive GUI on what to show
insert into lkuQuestionType(question_type_id, question_type, data_type) values(1, 'Rank',1)--datatype 1 is an integer
insert into lkuQuestionType(question_type_id, question_type, data_type) values(2, 'Integer',1)--datatype 1 is an integer
insert into lkuQuestionType(question_type_id, question_type, data_type) values(3, 'Yes/No',2)--datatype 3 is a boolean
--fk to question type
insert into tblQuestions(question_id, question_text, question_type) values(1, 'Did you like the course? Rank 1 to 5',1)
insert into tblQuestions(question_id, question_text, question_type) values(2, 'How many classes did you miss?',2)
insert into tblQuestions(question_id, question_text, question_type) values(3, 'Did the class start and end on time?',3)
--jnct template
insert into jnctQuestionTemplate(question_id, template_id) values(1,1)
insert into jnctQuestionTemplate(question_id, template_id) values(2,1)
insert into jnctQuestionTemplate(question_id, template_id) values(1,2)
insert into jnctQuestionTemplate(question_id, template_id) values(3,2)

--answers
--course 1 answer
insert into tblAnswers(student_id, question_id, semester_offering_id, answer) values(1,1,1,'3')
insert into tblAnswers(student_id, question_id, semester_offering_id, answer) values(1,2,1,'10')
insert into tblAnswers(student_id, question_id, semester_offering_id, answer) values(2,1,1,'3')
insert into tblAnswers(student_id, question_id, semester_offering_id, answer) values(2,2,1,'10')
--course 2 answer
insert into tblAnswers(student_id, question_id, semester_offering_id, answer) values(2,1,2,'3')
insert into tblAnswers(student_id, question_id, semester_offering_id, answer) values(2,2,2,'10')
--course 3 answer
insert into tblAnswers(student_id, question_id, semester_offering_id, answer) values(3,1,3,'3')
insert into tblAnswers(student_id, question_id, semester_offering_id, answer) values(3,3,3,'Yes')
--course 4 answer
insert into tblAnswers(student_id, question_id, semester_offering_id, answer) values(4,1,4,'2')
insert into tblAnswers(student_id, question_id, semester_offering_id, answer) values(4,3,4,'Yes')
insert into tblAnswers(student_id, question_id, semester_offering_id, answer) values(5,1,4,'5')
insert into tblAnswers(student_id, question_id, semester_offering_id, answer) values(5,3,4,'Yes')
GO
--1.Distribution 

IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.usp_getTop4RatedCourses'))
   exec('CREATE PROCEDURE [dbo].[usp_getTop4RatedCourses] AS BEGIN SET NOCOUNT ON; END')
GO
alter proc usp_getTop4RatedCourses(  @semesterStart datetime, @semesterEnd datetime, @rankQuestionID int, @ans3 varchar(30))
as
BEGIN
	select top(4)  c.course_name, count(ans.answer) as votes
	into #top4Courses--using temp table as this is the most performant. Stores pre-calculated values so that they can be used in union query. Also temp tables can be 
	from tblAnswers ans
		inner join tblQuestions q on q.question_id=ans.question_id
		inner join tblSemesterOfferings so on ans.semester_offering_id=so.semester_offering_id
		inner join tblCourses c on c.course_id=so.course_id
	where so.startdate= @semesterStart and so.enddate=@semesterEnd --there could be a semester table that has the dates so we could join on an id instead of dates
		and q.question_id=@rankQuestionID --assume question id =1 is the rank question
		and ans.answer >= @ans3 --assumes front end is enforcing 1,2,3,4. Could make various fields like answer_int, answer_date on tblAnswers but that  implementation would make other queries more complicated, 
		--no casting in the query to avoid any failures
	group by c.course_name
	order by count(ans.answer) desc

	select course_name, votes
	from #top4Courses
	union
	select 'Other', count(ans.answer)-(select sum(votes) from #top4Courses)
	from tblAnswers ans
		inner join tblQuestions q on q.question_id=ans.question_id
		inner join tblSemesterOfferings so on ans.semester_offering_id=so.semester_offering_id
		inner join tblCourses c on c.course_id=so.course_id
	where so.startdate= @semesterStart and so.enddate=@semesterEnd --there could be a semester table that has the dates so we could join on an id instead of dates
		and q.question_id=@rankQuestionID --assume question id =1 is the rank question
		and ans.answer >= @ans3 --assumes front end is enforcing 1,2,3,4. Could make various fields like answer_int, answer_date on tblAnswers but that  implementation would make other queries more complicated, 
	
END
GO
declare @semesterStartLocal datetime  = '8/15/2020'
declare @semesterEndLocal datetime  = '12/15/2020'

declare @rankQuestionIDLocal int = 1
declare @ans3Local varchar(30)='3'
exec usp_getTop4RatedCourses @semesterStart=@semesterStartLocal, @semesterEnd=@semesterEndLocal, @rankQuestionID=@rankQuestionIDLocal, @ans3 =@ans3Local

GO 
--2. list responses
IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.usp_getResponses'))
   exec('CREATE PROCEDURE [dbo].[usp_getResponses] AS BEGIN SET NOCOUNT ON; END')
GO
alter proc usp_getResponses(@semesterOfferingID int)
AS
BEGIN
	Select c.course_name, so.startdate, so.enddate,student_name, q.question_text, ans.answer
	from tblAnswers ans
		inner join tblQuestions q on q.question_id=ans.question_id
		inner join tblSemesterOfferings so on ans.semester_offering_id=so.semester_offering_id
		inner join tblCourses c on c.course_id=so.course_id
		inner join tblStudents s on s.student_id = ans.student_id
	where so.semester_offering_id=@semesterOfferingID--semester offering encapsulates courseid and semester dates
	order by student_name
END
GO

exec usp_getResponses @semesterOfferingID=4
GO

--3. courses at 80% or higher

IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.usp_getResponses'))
   exec('CREATE PROCEDURE [dbo].[usp_getResponses] AS BEGIN SET NOCOUNT ON; END')
GO
alter proc usp_getResponses( @threeYearsAgo datetime)
AS
BEGIN
	--get total student enrollment
	Select count(sc.student_id) as studentCnt, so.course_id,so.semester_offering_id
	into #enrollment
	from jnctStudentSemesterOffering sc 
		inner join tblSemesterOfferings so on so.semester_offering_id=sc.semester_offering_id
	where so.startdate> @threeYearsAgo
		group by  so.course_id,so.semester_offering_id


	--votes over 3 enrollment

	select    count(ans.answer) as votes,so.course_id, so.semester_offering_id
	into #votesOver3--using temp table as this is the most performant. Stores pre-calculated values so that they can be used in union query. Also temp tables can be indexed
	from tblAnswers ans
		inner join tblQuestions q on q.question_id=ans.question_id
		inner join tblSemesterOfferings so on ans.semester_offering_id=so.semester_offering_id
		inner join tblCourses c on c.course_id=so.course_id	
	where so.startdate > @threeYearsAgo --there could be a semester table that has the dates so we could join on an id instead of dates
		and q.question_id=1 --assume question id =1 is the rank question
		and ans.answer >= '3' --assumes front end is enforcing 1,2,3,4. Could make various fields like answer_int, answer_date on tblAnswers but that  implementation would make other queries more complicated, 
		--no casting in the query to avoid any failures
	group by so.course_id,so.semester_offering_id
	order by count(ans.answer) desc

	select c.course_name
	from #enrollment e
		inner join #votesOver3 vo3 on vo3.semester_offering_id=e.semester_offering_id
		inner join tblSemesterOfferings so on so.semester_offering_id=e.semester_offering_id
		inner join tblCourses c on c.course_id = so.semester_offering_id
	where (vo3.votes / e.studentCnt) >= .80
END
GO
exec usp_getResponses @threeYearsAgo='10/5/2017'

rollback
