use SUS_Data
--Max import id- Variable 
Select max(Import_id)[Import_ID] from dbo.audit

--Maxiumn Row Count- Pass this into variable
select COUNT(1) from dbo.tmp_IP_SUS

select COUNT(1) from dbo.IP_PBR_5thDay



--updates for audit table

UPDATE CDS_Data.dbo.audit
SET  Total_Records = ?
WHERE import_id = (Select max(Import_id) from CDS_Data.dbo.audit)

--select start and end date and date of extraction
--start
UPDATE CDS_Data.dbo.audit
SET Start_Period = (select distinct CDSReportPeriodStartDate from cds_data.dbo.IP_Staging)
WHERE import_id = (Select max(Import_id) from CDS_Data.dbo.audit)

--end
UPDATE CDS_Data.dbo.audit
SET End_Period = (select distinct CDSReportPeriodEndDate from cds_data.dbo.IP_Staging)
WHERE import_id = (Select max(Import_id) from CDS_Data.dbo.audit)

--extract 
UPDATE CDS_Data.dbo.audit
SET Date_Extracted = (select distinct CDSExtractDate + ' ' + CDSExtractTime from cds_data.dbo.IP_Staging)
WHERE import_id = (Select max(Import_id) from CDS_Data.dbo.audit)


--Finished flag  
update CDS_Data.dbo.audit
SET Completed_Flag = 1
where import_id = (Select MAX(Import_id) from dbo.audit)





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


