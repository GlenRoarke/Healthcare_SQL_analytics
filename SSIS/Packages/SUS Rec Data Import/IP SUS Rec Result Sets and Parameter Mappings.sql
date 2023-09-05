use SUS_Data
--Max import id- Variable 
Select max(Import_id)[Import_ID] from dbo.SUS_RecIP_Audit

--Maxiumn Row Count- Pass this into variable
select COUNT(1) [RowCount] from dbo.IP_SUS_Rec_Staging

--select COUNT(1) from dbo.IP_PBR_5thDay


--updates for audit table

UPDATE SUS_Data.dbo.SUS_RecIP_Audit
SET  Total_Records = ?
WHERE import_id = (Select max(Import_id)[Import_ID] from dbo.SUS_RecIP_Audit)

--select start and end date and date of extraction
--start
UPDATE SUS_Data.dbo.SUS_RecIP_Audit
SET Start_Period = (select distinct [Applicable Costing Period] from SUS_Data.dbo.[IP_SUS_Rec_Staging])
WHERE import_id = (Select max(Import_id)[Import_ID] from dbo.SUS_RecIP_Audit)

/*--end not possible in this extract
UPDATE CDS_Data.dbo.audit
SET End_Period = (select distinct [Report Period End Date] from SUS_Data.dbo.[IP_SUS_Rec_Staging])
WHERE import_id = (Select max(Import_id)[Import_ID] from dbo.SUS_RecIP_Audit) */

--extract 
UPDATE SUS_Data.dbo.SUS_RecIP_Audit
SET Date_Extracted = (select distinct top 1 [Extract Date] from SUS_Data.dbo.[IP_SUS_Rec_Staging])
WHERE import_id = (Select max(Import_id)[Import_ID] from dbo.SUS_RecIP_Audit)


--Finished flag  
update CDS_Data.dbo.audit
SET Completed_Flag = 1
where import_id = (Select max(Import_id)[Import_ID] from dbo.SUS_RecIP_Audit)





--update the max import ID from Variable
Update dbo.audit
SET Total_Records = ?
Where import_id = (Select max(Import_id) from dbo.audit)

--Select start and end period, and date of extraction.
--Start Period
update dbo.audit
SET Start_Period = (Select MIN(convert(datetime,stuff(stuff([Hospital Provider Spell End Date],5,0,'-'),8,0,'-'),20)) [DischargeStartDate]
						FROM SUS_Data.dbo.tmp_IP_SUS)
												
where import_id = (Select max(Import_id) from dbo.audit)
--End Period
update dbo.audit
SET End_Period = (Select MAX(convert(datetime,stuff(stuff([Hospital Provider Spell End Date],5,0,'-'),8,0,'-'),20)) [DischargeEndDate]
					FROM SUS_Data.dbo.tmp_IP_SUS)
where  import_id = (Select MAX(Import_id) from dbo.audit)

--Extract Date
update dbo.audit
SET Date_Extracted = (select max(convert(datetime,stuff(stuff([Extract Date],5,0,'-'),8,0,'-'),20)) [Extract_DTTM]
						from SUS_Data.dbo.tmp_IP_SUS)
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


