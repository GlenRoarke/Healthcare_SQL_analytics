USE [GlenTest]
GO

ALTER TABLE [dbo].[Audit] DROP CONSTRAINT [DF__Audit__Completed__64E397F5]
GO

ALTER TABLE [dbo].[Audit] DROP CONSTRAINT [DF__Audit__ImportedB__63EF73BC]
GO

ALTER TABLE [dbo].[Audit] DROP CONSTRAINT [DF__Audit__Date_Impo__62FB4F83]
GO

/****** Object:  Table [dbo].[Audit]    Script Date: 20/06/2017 13:44:53 ******/
DROP TABLE [dbo].[Audit]
GO

/****** Object:  Table [dbo].[Audit]    Script Date: 20/06/2017 13:44:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[Audit](
	[Import_id] [int] IDENTITY(1,1) NOT NULL,
	[FileName] [varchar](150) NULL,
	[Total_Records] [int] NULL,
	[SASU_Exclusion_Count] [int] NULL,
	[Date_Imported] [datetime] NULL,
	[ImportedBy] [varchar](100) NULL,
	[Export_id] [int] NULL,
	[Start_Period] [date] NULL,
	[End_Period] [date] NULL,
	[Date_Extracted] [date] NULL,
	[Completed_Flag] [bit] NULL,
	[Type] [varchar](2) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[Audit] ADD  DEFAULT (getdate()) FOR [Date_Imported]
GO

ALTER TABLE [dbo].[Audit] ADD  DEFAULT (suser_sname()) FOR [ImportedBy]
GO

ALTER TABLE [dbo].[Audit] ADD  DEFAULT ('FALSE') FOR [Completed_Flag]
GO


