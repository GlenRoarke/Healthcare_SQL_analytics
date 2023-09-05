
--/****** Script to create blank audit table for CDS imports  ******/

CREATE TABLE [dbo].[audit](
	[Import_id] [int] Primary Key IDENTITY(1,1) NOT NULL,
	[FileName] [varchar](150),
	[Total_Records] [int],
	[Date_Imported] [datetime] DEFAULT getdate(),
	[ImportedBy] [varchar](100) DEFAULT suser_sname(),
	[Export_id] [int],
	[Start_Period] [date],
	[End_Period] [date],
	[Date_Extracted] [date],	
	[Completed_Flag] [bit] Default 'FALSE',
	[U_F_Flag] [bit] Default 'TRUE', -- this column is only applicable to IP data 
	[Type] [varchar](2) NULL
	
	) ON [PRIMARY]
	


	
	
--/****** Script to create blank errorlogtable for CDS imports  ******/
	
	CREATE TABLE [dbo].[errorlog](
	[Error_id] [int] Primary Key IDENTITY(1,1) NOT NULL,
	[Import_id] [int]  NOT NULL,
	[FileName] [varchar](250),
	[Error_description] [varchar](1000) ) ON [PRIMARY]