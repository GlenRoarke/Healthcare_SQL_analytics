--1 - Clear staging table
TRUNCATE TABLE  [dbo].[staging]

--3 - Insert details into audit/****** Script for incerting new record into audit log  ******/
Insert into dbo.audit (FileName, Total_Records) 
values(?,?) -- values are mapped in Parameter Mapping with to variables.


--4 - Get Import_ID/****** Script to get import_id so it can be added to imported data  ******/
SELECT max([Import_id])as Import_id 
FROM  [dbo].[audit] -- value is recorded in Result Set to a variable (User::Import_id)


--6 - Update adit log/****** Script to update audit table with information from the imorted file  ******/
Update [dbo].[audit]
Set [Export_id]= (SELECT TOP 1	SUBSTRING([CDSRecordIdentifier],8,6)
					FROM  [dbo].[staging] 
					Order by [Import_id]desc)
					
	,[Start_Period] = (SELECT TOP 1	[CDSReportPeriodStartDate]
						FROM  [dbo].[staging] 
						Order by [Import_id]desc) 
						
	,[End_Period] = (SELECT TOP 1	[CDSReportPeriodEndDate]
						FROM  [dbo].[staging] 
						Order by [Import_id]desc) 
						
	,[Date_Extracted] = (SELECT TOP 1 [CDSExtractDate]
							FROM  [dbo].[staging] 
							Order by [Import_id]desc)
							
	,[Type]=SUBSTRING(FileName, 55, 2)
	
Where  [dbo].[audit].Import_id =(select MAX([Import_id])as import_id 
											from  [dbo].[staging])


--11 - Chek for IP_F and IP_U/****** Script to check wheather processed file is unfinished or finished ******/
SELECT top 1 
			CASE 	when EndDate_Episode is null then 0 --unfinished
					else 1 --finished
					end as EndDate_Episode
FROM dbo.extracts
where Import_id = (select top 1[Import_id]
					from  [dbo].[audit] 
					order by Import_id desc)


--13a - U_F unflaged/****** Script to update Unfinished/Finished flag in audit log with value 'False'******/
Update  [dbo].[audit]
Set  [U_F_Flag]= 0
Where  [dbo].[audit].Import_id =(select MAX([Import_id])as import_id 
											from  [dbo].[staging])


--12a -Most recent unflaged/****** Script to update most recent flag in currently imported data with value 'False'******/
Update  [dbo].[extracts]
Set MostRecent_Flag = 0
Where Import_id = (SELECT Import_id 
					FROM  dbo.audit AS audit_5
					WHERE (Import_id = (SELECT MAX(Import_id) AS import_id 
					FROM dbo.audit AS audit_1)))


--14 - End of process/****** Script for updating completed flag in audit table  ******/
Update  [dbo].[audit]
Set Completed_Flag =1
where Import_id = (select top 1 Import_id 
					from  [dbo].[audit]
					order by Import_id desc)
    
  
--12b - Check if overlap/****** Script to check if currently imported data period overlap with  historic data******/
SELECT COUNT( Import_id)as Count_exceptions --if count is >0 then there is overlap with historic data
FROM dbo.audit
WHERE Import_id <> (SELECT Import_id 
					FROM dbo.audit 
					WHERE(Import_id = (SELECT MAX(Import_id) AS import_id 
										FROM dbo.audit AS audit_1))) -- current extract exluded
AND Start_Period <= (SELECT End_Period 
					FROM dbo.audit 
					WHERE(Import_id = (SELECT MAX(Import_id) AS import_id 
										FROM dbo.audit AS audit_1))) -- condition 1
AND End_Period >= (SELECT Start_Period 
					FROM dbo.audit 
					WHERE (Import_id = (SELECT MAX(Import_id) AS import_id 
										FROM dbo.audit AS audit_1)))-- condition 2
AND U_F_Flag = 1 -- ensure we ignore IP unfinished data


--13b1 - Unflag historic when extraxt date is > or equal/******  Unflag historic data when extraxt date in current data is > or equal to extract date in historic data******/
Update  [dbo].[extracts]
Set MostRecent_Flag = 0
WHERE Import_id IN (SELECT Import_id 
					FROM dbo.audit 
					WHERE Import_id <> (SELECT Import_id 
										FROM dbo.audit 
										WHERE (Import_id = (SELECT MAX(Import_id) AS import_id 
															FROM dbo.audit AS audit_1))) 
					and Start_Period <= (SELECT End_Period 
										FROM dbo.audit 
										WHERE (Import_id = (SELECT MAX(Import_id) AS import_id 
										FROM dbo.audit AS audit_1))) -- condition 1
					and End_Period >= (SELECT Start_Period 
										FROM dbo.audit 
										WHERE (Import_id = (SELECT MAX(Import_id) AS import_id	
															FROM dbo.audit AS audit_1)))--- condition 2
					and Date_Extracted <=(SELECT Date_Extracted 
											FROM dbo.audit 
											WHERE (Import_id = (SELECT MAX(Import_id) AS import_id 
																FROM dbo.audit AS audit_1))) -- condition 3
					and U_F_Flag = 1) -- getting import id’s of historic data where periods overlap and date extracted is < or = 
					
AND [CDSActivityDate] >= (SELECT Start_Period 
							FROM dbo.audit AS audit_4 
							WHERE (Import_id = (SELECT MAX(Import_id) AS import_id 
												FROM dbo.audit AS audit_1)))
AND (CDSActivityDate <= (SELECT End_Period 
							FROM dbo.audit AS audit_3 
							WHERE (Import_id = (SELECT MAX(Import_id) AS import_id 
												FROM dbo.audit AS audit_1))))


--13b2 -Version check/****** Script to check if currently imported data is older then hystoric data (exception)******/
SELECT CASE  
		when count(Import_id) = 0 	
		then 0 -- all data in current extract is most resent version 
		else 1 --current extract has data that is older than the data that is already in the db
		End  AS Version_check 
FROM dbo.audit 
WHERE Import_id <> (SELECT Import_id 
					FROM  dbo.audit	
					WHERE (Import_id = (SELECT MAX(Import_id) AS import_id 
					FROM dbo.audit AS audit_1))) -- current extract
and Start_Period <= (SELECT End_Period 
					FROM dbo.audit 
					WHERE (Import_id = (SELECT MAX(Import_id) AS import_id 
					FROM dbo.audit AS audit_1))) -- condition 1
and End_Period >= (SELECT Start_Period 
					FROM dbo.audit 
					WHERE (Import_id = (SELECT MAX(Import_id) AS import_id 
										FROM dbo.audit AS audit_1)))--- condition 2
and Date_Extracted >(SELECT Date_Extracted 
						FROM dbo.audit 
						WHERE (Import_id = (SELECT MAX(Import_id) AS import_id 
											FROM dbo.audit AS audit_1))) -- condition 3
and U_F_Flag = 1
			
					
--14b2 - Unflag imported data when extract date is </******  Unflag current data when extract date in current data is < than extract date in historic data******/ 
Update  [dbo].[extracts]
Set MostRecent_Flag = 0
where 	Import_id = (SELECT Import_id 
						FROM   dbo.audit AS audit_5 
						WHERE (Import_id = (SELECT MAX(Import_id) AS import_id 
											FROM dbo.audit AS audit_1)))
											
		AND [CDSActivityDate] >= (SELECT MIN(Start_Period) 
									FROM dbo.audit AS audit_4 
									WHERE (Import_id in (SELECT Import_id 
															FROM dbo.audit 
															WHERE  Import_id <> (SELECT Import_id 
																					FROM dbo.audit 
																					WHERE (Import_id = (SELECT MAX(Import_id) AS import_id	
																										FROM dbo.audit AS audit_1)))
									and Start_Period <= (SELECT End_Period 
														FROM dbo.audit 
														WHERE (Import_id = (SELECT MAX(Import_id) AS import_id 
																			FROM dbo.audit AS audit_1))) -- a1
									and End_Period >= (SELECT Start_Period 
														FROM dbo.audit 
														WHERE (Import_id = (SELECT MAX(Import_id) AS import_id
																							FROM dbo.audit AS audit_1)))-- a2
									and Date_Extracted > (SELECT Date_Extracted 
															FROM dbo.audit 
															WHERE (Import_id = (SELECT MAX(Import_id) AS import_id 
																								FROM dbo.audit AS audit_1))) -- a3
									and U_F_Flag = 1)))
									
		AND (CDSActivityDate <= (SELECT max(End_Period) 
									FROM dbo.audit AS audit_3 
									WHERE (Import_id in (SELECT Import_id 
															FROM dbo.audit 
															WHERE Import_id <> (SELECT Import_id 
																				FROM dbo.audit 
																				WHERE (Import_id = (SELECT MAX(Import_id) AS import_id 
																									FROM dbo.audit AS audit_1)))
									and Start_Period <= (SELECT End_Period 
														FROM dbo.audit 
														WHERE (Import_id = (SELECT MAX(Import_id) AS import_id 
																			FROM dbo.audit AS audit_1))) -- a1
									and End_Period >= (SELECT Start_Period 
														FROM dbo.audit 
														WHERE (Import_id = (SELECT MAX(Import_id) AS import_id 
														FROM dbo.audit AS audit_1)))-- a2
									and Date_Extracted >= (SELECT Date_Extracted 
															FROM dbo.audit 
															WHERE (Import_id = (SELECT MAX(Import_id) AS import_id 
																				FROM dbo.audit AS audit_1))) -- a3
									and U_F_Flag = 1))))
									
									
 --15 - On error log error description
 Insert into dbo.errorlog(Import_id, FileName, Error_description) 
 values(?,?,?)
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 