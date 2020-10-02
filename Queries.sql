

--1.Distribution 
declare @semesterStart datetime  = '8/15/2020'
declare @semesterEnd datetime  = '12/15/2020'

declare @rankQuestionID int = 1
declare @ans3 varchar(1)='3'

select top(4)  c.course_name, count(ans.answer) as votes
into #top4Courses--using temp table as this is the most performant. Stores pre-calculated values so that they can be used in union query. Also temp tables can be 
from tblAnswers ans
	inner join tblQuestions q on q.question_id=ans.question_id
	inner join jnctQuestionTemplate jqt on jqt.question_id=ans.question_id
	inner join tblTemplates t on t.template_id=jqt.template_id
	inner join tblSemesterOfferings so on so.course_id=t.course_id
	inner join tblCourses c on c.course_id=t.course_id
where so.startdate= @semesterStart and so.enddate=@semesterEnd --there could be a semester table that has the dates so we could join on an id instead of dates
	and q.question_id=@rankQuestionID --assume question id =1 is the rank question
	and ans.answer > @ans3 --assumes front end is enforcing 1,2,3,4. Could make various fields like answer_int, answer_date on tblAnswers but that  implementation would make other queries more complicated, 
	--no casting in the query to avoid any failures
group by c.course_name
order by count(ans.answer) desc

select course_name, votes
from #top4Courses
union
select 'Other', count(ans.answer)-(select sum(votes) from #top4Courses)
from tblAnswers ans
	inner join tblQuestions q on q.question_id=ans.question_id
	inner join jnctQuestionTemplate jqt on jqt.question_id=ans.question_id
	inner join tblTemplates t on t.template_id=jqt.template_id
	inner join tblSemesterOfferings so on so.course_id=t.course_id
	inner join tblCourses c on c.course_id=t.course_id
where so.startdate= @semesterStart and so.enddate=@semesterEnd --there could be a semester table that has the dates so we could join on an id instead of dates
	and q.question_id=@rankQuestionID --assume question id =1 is the rank question
	and ans.answer > @ans3 --assumes front end is enforcing 1,2,3,4. Could make various fields like answer_int, answer_date on tblAnswers but that  implementation would make other queries more complicated, 
	
--clean up
drop table #top4Courses

--2. list responses
Select c.course_name, so.startdate, so.enddate,student_name, q.question_text, ans.answer
from tblAnswers ans
	inner join tblQuestions q on q.question_id=ans.question_id
	inner join jnctQuestionTemplate jqt on jqt.question_id=ans.question_id--junction table since questions can be associated with many templates and templates can have many questions
	inner join tblTemplates t on t.template_id=jqt.template_id
	inner join tblSemesterOfferings so on so.course_id=t.course_id
	inner join tblCourses c on c.course_id=t.course_id
	inner join tblStudents s on s.student_id=ans.student_id
where so.semester_offering_id=1--semester offering encapsulates courseid and semester dates
order by student_name

--3. courses at 80% or higher
declare @threeYearsAgo datetime  = '8/15/2017'

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
	inner join jnctQuestionTemplate jqt on jqt.question_id=ans.question_id
	inner join tblTemplates t on t.template_id=jqt.template_id
	inner join tblSemesterOfferings so on so.course_id=t.course_id
	
where so.startdate > @threeYearsAgo --there could be a semester table that has the dates so we could join on an id instead of dates
	and q.question_id=1 --assume question id =1 is the rank question
	and ans.answer > '3' --assumes front end is enforcing 1,2,3,4. Could make various fields like answer_int, answer_date on tblAnswers but that  implementation would make other queries more complicated, 
	--no casting in the query to avoid any failures
group by so.course_id,so.semester_offering_id
order by count(ans.answer) desc

select c.course_name
from #enrollment e
	inner join #votesOver3 vo3 on vo3.semester_offering_id=e.semester_offering_id
	inner join tblSemesterOfferings so on so.semester_offering_id=e.semester_offering_id
	inner join tblCourses c on c.course_id = so.semester_offering_id
where (vo3.votes / e.studentCnt) >= .80


--clean up
drop table #enrollment
drop table #votesOver3
 

