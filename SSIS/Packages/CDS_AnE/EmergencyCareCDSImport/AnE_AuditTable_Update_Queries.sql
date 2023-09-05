

/***** 1)Inserting Filename and total records into audit table from flat file. 
SSIS features- Result Set-None, Parameter Mapping- FileName, Total_Records***/
Insert into dbo.audit (FileName, Total_Records) values(?,?)


/**** 3)Getting Max ImportID from audit table
SSIS features Result Set-Single row, Variable-Import_id***/

SELECT max([Import_id])as Import_id FROM [dbo].[audit]

/**** 5) Updates audit Table with extract and activity dates and flagging.
Notes the select Top 1 and Order by desc gives the same result as the max import id (latest record uploaded) 
The set function allows you to determine the value each field in the audit table will be given.*****/ 

Update [dbo].[audit]
Set [Export_id]= (SELECT TOP 1	SUBSTRING([CDS Message Reference],8,6)FROM [dbo].[staging] Order by [Import_id]desc)
	,[Start_Period] = (SELECT TOP 1	[CDS ReportPeriod StartDate] FROM [dbo].[staging] Order by [Import_id]desc) 
	,[End_Period] = (SELECT TOP 1	[CDS ReportPeriod EndDate]FROM [dbo].[staging] Order by [Import_id]desc) 
	,[Date_Extracted] = (SELECT TOP 1	[CDS Extract Date] FROM [dbo].[staging] Order by [Import_id]desc)
	,[Type]=SUBSTRING(FileName, 58, 2) 

Where [dbo].[audit].Import_id =(select MAX([Import_id])as import_id from [dbo].[staging]) -- is this the safest option what if staging table and audit differ

/****Updating Most recently imported data ****/

Update [dbo].[Extract]
Set MostRecent_Flag = 1
where Import_id = (SELECT MAX(Import_id) AS Import_id
											FROM dbo.audit)
/***Removed flag on all previous imports***/

Update [dbo].[Extract]
Set MostRecent_Flag = 0
where Import_id <> (SELECT MAX(Import_id) AS Import_id
											FROM dbo.audit)

/****End of process sql to flag that everything has run correctly*****/

Update [dbo].[audit]
  Set Completed_Flag =1
  where Import_id = (select top 1 Import_id from [dbo].[audit]order by Import_id desc)
  
/****updates the audit table with the count of AnE CDS excl SASU patients (SSIS query) ******/  
  UPDATE [dbo].[Audit]
SET [SASU_Exclusion_Count] = (?)
WHERE [Import_id] = (SELECT max([Import_id]) from [dbo].[Audit])