

CREATE TABLE [dbo].[jnctQuestionTemplate](
	[question_id] [int] NOT NULL,
	[template_id] [int] NOT NULL,
 CONSTRAINT [PK_jnctQuestionTemplate] PRIMARY KEY CLUSTERED 
(
	[question_id] ASC,
	[template_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[jnctStudentSemesterOffering]    Script Date: 10/2/2020 2:09:20 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[jnctStudentSemesterOffering](
	[student_id] [int] NOT NULL,
	[semester_offering_id] [int] NOT NULL,
 CONSTRAINT [PK_jnctStudentSemesterOffering] PRIMARY KEY CLUSTERED 
(
	[student_id] ASC,
	[semester_offering_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[lkuQuestionType]    Script Date: 10/2/2020 2:09:20 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[lkuQuestionType](
	[question_type_id] [int] NOT NULL,
	[question_type] [varchar](50) NOT NULL,
	[data_type] [int] NULL,
 CONSTRAINT [PK_lkuQuestionType] PRIMARY KEY CLUSTERED 
(
	[question_type_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[tblAnswers]    Script Date: 10/2/2020 2:09:20 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tblAnswers](
	[student_id] [int] NOT NULL,
	[question_id] [int] NOT NULL,
	[semester_offering_id] [int] NOT NULL,
	[answer] [varchar](300) NOT NULL,
 CONSTRAINT [PK_tblAnswers] PRIMARY KEY CLUSTERED 
(
	[student_id] ASC,
	[question_id] ASC,
	[semester_offering_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[tblCourses]    Script Date: 10/2/2020 2:09:20 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tblCourses](
	[course_id] [int] NOT NULL,
	[course_name] [varchar](30) NOT NULL,
 CONSTRAINT [PK_tblCourses] PRIMARY KEY CLUSTERED 
(
	[course_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[tblQuestions]    Script Date: 10/2/2020 2:09:20 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tblQuestions](
	[question_id] [int] NOT NULL,
	[question_text] [varchar](8000) NOT NULL,
	[question_type] [int] NULL,
 CONSTRAINT [PK_tblQuestions] PRIMARY KEY CLUSTERED 
(
	[question_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[tblSemesterOfferings]    Script Date: 10/2/2020 2:09:20 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tblSemesterOfferings](
	[semester_offering_id] [int] NOT NULL,
	[course_id] [int] NOT NULL,
	[startdate] [datetime] NOT NULL,
	[enddate] [datetime] NOT NULL,
 CONSTRAINT [PK_tblSemesterOfferings] PRIMARY KEY CLUSTERED 
(
	[semester_offering_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[tblStudents]    Script Date: 10/2/2020 2:09:20 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tblStudents](
	[student_id] [int] NOT NULL,
	[student_name] [varchar](30) NOT NULL,
 CONSTRAINT [PK_tblStudents] PRIMARY KEY CLUSTERED 
(
	[student_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[tblTemplates]    Script Date: 10/2/2020 2:09:20 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tblTemplates](
	[template_id] [int] NOT NULL,
	[template_name] [varchar](30) NOT NULL
 CONSTRAINT [PK_tblTemplates] PRIMARY KEY CLUSTERED 
(
	[template_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[lkuQuestionType] ADD  CONSTRAINT [DF_lkuQuestionType_question_type]  DEFAULT ('') FOR [question_type]
GO

ALTER TABLE [dbo].[tblAnswers] ADD  CONSTRAINT [DF_answers_answer]  DEFAULT ('') FOR [answer]
GO

ALTER TABLE [dbo].[tblCourses] ADD  CONSTRAINT [DF_tblCourses_course_name]  DEFAULT ('') FOR [course_name]
GO

ALTER TABLE [dbo].[tblQuestions] ADD  CONSTRAINT [DF_questions_question_text]  DEFAULT ('') FOR [question_text]
GO

ALTER TABLE [dbo].[tblStudents] ADD  CONSTRAINT [DF_tblStudents_student_name]  DEFAULT ('') FOR [student_name]
GO

ALTER TABLE [dbo].[tblTemplates] ADD  CONSTRAINT [DF_templates_template_name]  DEFAULT ('') FOR [template_name]
GO

ALTER TABLE [dbo].[jnctQuestionTemplate]  WITH CHECK ADD  CONSTRAINT [FK_jnctQuestionTemplate_tblQuestions] FOREIGN KEY([question_id])
REFERENCES [dbo].[tblQuestions] ([question_id])
GO

ALTER TABLE [dbo].[jnctQuestionTemplate] CHECK CONSTRAINT [FK_jnctQuestionTemplate_tblQuestions]
GO

ALTER TABLE [dbo].[jnctQuestionTemplate]  WITH CHECK ADD  CONSTRAINT [FK_jnctQuestionTemplate_tblTemplates] FOREIGN KEY([template_id])
REFERENCES [dbo].[tblTemplates] ([template_id])
GO

ALTER TABLE [dbo].[jnctQuestionTemplate] CHECK CONSTRAINT [FK_jnctQuestionTemplate_tblTemplates]
GO

ALTER TABLE [dbo].[jnctStudentSemesterOffering]  WITH CHECK ADD  CONSTRAINT [FK_jnctStudentSemesterOffering_tblSemesterOfferings] FOREIGN KEY([semester_offering_id])
REFERENCES [dbo].[tblSemesterOfferings] ([semester_offering_id])
GO

ALTER TABLE [dbo].[jnctStudentSemesterOffering] CHECK CONSTRAINT [FK_jnctStudentSemesterOffering_tblSemesterOfferings]
GO

ALTER TABLE [dbo].[jnctStudentSemesterOffering]  WITH CHECK ADD  CONSTRAINT [FK_jnctStudentSemesterOffering_tblStudents] FOREIGN KEY([student_id])
REFERENCES [dbo].[tblStudents] ([student_id])
GO

ALTER TABLE [dbo].[jnctStudentSemesterOffering] CHECK CONSTRAINT [FK_jnctStudentSemesterOffering_tblStudents]
GO

ALTER TABLE [dbo].[tblAnswers]  WITH CHECK ADD  CONSTRAINT [FK_tblAnswers_tblQuestions] FOREIGN KEY([question_id])
REFERENCES [dbo].[tblQuestions] ([question_id])
GO

ALTER TABLE [dbo].[tblAnswers] CHECK CONSTRAINT [FK_tblAnswers_tblQuestions]
GO

ALTER TABLE [dbo].[tblAnswers]  WITH CHECK ADD  CONSTRAINT [FK_tblAnswers_tblStudents] FOREIGN KEY([student_id])
REFERENCES [dbo].[tblStudents] ([student_id])
GO

ALTER TABLE [dbo].[tblAnswers] CHECK CONSTRAINT [FK_tblAnswers_tblStudents]
GO

ALTER TABLE [dbo].[tblSemesterOfferings]  WITH CHECK ADD  CONSTRAINT [FK_tblSemesterOfferings_tblCourses] FOREIGN KEY([course_id])
REFERENCES [dbo].[tblCourses] ([course_id])
GO

ALTER TABLE [dbo].[tblSemesterOfferings] CHECK CONSTRAINT [FK_tblSemesterOfferings_tblCourses]
GO




