use SUS_Data
--Max import id- Variable 
Select max(Import_id)[Import_ID] from dbo.audit

--Maxiumn Row Count- Pass this into variable
select COUNT(1)[RowCount] from dbo.tmp_OP_SUS

select COUNT(1) from dbo.OP_PBR_5thDay

use SUS_Data

--updates for audit table

--update the counts from Variable
Update dbo.audit
SET Total_Records = ?
Where import_id = (Select max(Import_id) from dbo.audit)

--Select start and end period, and date of extraction.
--Start Period
update dbo.audit
SET Start_Period = (Select min(convert(datetime,stuff(stuff([Report Period Start Date],5,0,'-'),8,0,'-'),20))[Report Period Start_DTTM]
						FROM SUS_Data.dbo.tmp_OP_SUS)
												
where import_id = (Select max(Import_id) from dbo.audit)
--End Period
update dbo.audit
SET End_Period = (Select max(convert(datetime,stuff(stuff([Report Period End Date],5,0,'-'),8,0,'-'),20))[Report Period Start_DTTM]
						FROM SUS_Data.dbo.tmp_OP_SUS)
where  import_id = (Select MAX(Import_id) from dbo.audit)

--Extract Date
update dbo.audit
SET Date_Extracted = (SELECT min(convert(datetime,stuff(stuff([Extract Date],5,0,'-'),8,0,'-'),20)) [Extract_DTTM]
						from SUS_Data.dbo.tmp_OP_SUS)
where  import_id = (Select MAX(Import_id) from dbo.audit)



  
--Finished flag  
update dbo.audit
SET Completed_Flag = 1
where import_id = (Select MAX(Import_id) from dbo.audit)
  
  
  
  
         
           SELECT TOP 1000 [Import_id]
      ,[FileName]
      ,[Total_Records]
      ,[Date_Imported]
      ,[ImportedBy]
      ,[Start_Period]
      ,[End_Period]
      ,[Date_Extracted]
      ,[Completed_Flag]
      ,[Type]
  FROM [SUS_Data].[dbo].[audit]


