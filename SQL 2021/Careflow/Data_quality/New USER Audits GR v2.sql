/****** Duplicate USER Audits ******/
--Glen Roarke 27/10/2021



--this query inserts the major and minor IDs of a patient into a temp table for joining to the audit tables
IF OBJECT_ID('tempdb.dbo.#DupsTMP', 'U') IS NOT NULL
  DROP TABLE #DupsTMP; 
SELECT 
--minor
p.DIM_PATIENT_ID [DIM_PATIENT_ID_Minor]
,p.PAS_ID [PAS_ID_Minor]
--major
,p2.DIM_PATIENT_ID [DIM_PATIENT_ID_Master]
,p.MERGE_RECORD_ID [PAS_ID_Master]
,CASE WHEN  p.MERGE_RECORD_ID
		 is not null THEN 1
		ELSE 0
		END Merged
into #DupsTMP
FROM [HDM].[dbo].[DIM_PATIENT] p 
left JOIN  [HDM].[dbo].[DIM_PATIENT] p2 with(nolock) on p.MERGE_RECORD_ID  = p2.PAS_ID
where 
--p.MERGE_RECORD_ID is not null
 p.ARCHV_FLAG = 'N'
and p.Surname <> 'Test-Patient'
and P.DIM_PATIENT_ID > 0
and p.REG_DTTM between DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE())-6, 0) --1st day previous 6 months 
    and  DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-1, -1)---- last day of previous month   

CREATE NONCLUSTERED INDEX ix_MinorTMP ON #DupsTMP ([DIM_PATIENT_ID_Minor]) --Joining to Audits via DIM patient is slow so this may improve effiecnecy
CREATE NONCLUSTERED INDEX ix_MajorTMP ON #DupsTMP ([DIM_PATIENT_ID_Master])


IF OBJECT_ID('HDM_Local.[Corpdata].Medway_Dup_Regs_User_2', 'U') IS NOT NULL
DROP TABLE HDM_Local.[Corpdata].Medway_Dup_Regs_User_2;

--this query ranks the order of audit transactions by log DTTM, links to minor IDs that have been merged

select * 
INTO HDM_Local.[Corpdata].Medway_Dup_Regs_User_2
from (

SELECT  [PAS_ID_Minor]
	,[PAS_ID_Master]
	,a.Merged --Give you a value to count the amount of merges a user has made.
	,[FACT_AUDIT_ID]
      ,[LOG_DTTM]
      ,AF2.[CREATE_DTTM]
      ,[DIM_PATIENT_ID]
	  ,[TERMINAL_NAME]
      ,AF2.[DIM_SYSTEM_USER_ID]
	  ,SU2.USERS_NAME
	  ,AF2.DIM_LOOKUP_ENTITY_ID
	  ,ENT2.DESCRIPTION
	  ,ATC2.TRANSACTION_COMMAND
	  ,row_number() over(partition by [DIM_PATIENT_ID] order by [LOG_DTTM] asc) as [First_AuditUser] --this ranks the audits by asc logged date
	  
  FROM [HDM].[dbo].[FACT_AUDIT_FULL] AF2
  INNER JOIN HDM.dbo.DIM_AUDIT_TRANSACTION_COMMAND ATC2 with(nolock) ON ATC2.DIM_AUDIT_TRANSACTION_COMMAND_ID = AF2.DIM_AUDIT_TRANSACTION_COMMAND_ID
  INNER JOIN HDM.dbo.DIM_LOOKUP_ENTITY ENT2 WITH (NOLOCK) ON ENT2.DIM_LOOKUP_ENTITY_ID=AF2.DIM_LOOKUP_ENTITY_ID  
  INNER JOIN HDM.dbo.DIM_SYSTEM_USER SU2 with(nolock) ON SU2.DIM_SYSTEM_USER_ID = AF2.DIM_SYSTEM_USER_ID
  left JOIN [HDM].[dbo].[DIM_SYSTEM_TERMINAL] st with(nolock) on st.[DIM_SYSTEM_TERM_ID] = AF2.DIM_SYSTEM_TERMINAL_ID

  INNER JOIN #DupsTMP a with(nolock) on a.[DIM_PATIENT_ID_Minor] = af2.[DIM_PATIENT_ID]

  WHERE ENT2.DESCRIPTION IN ('PATIENT', 'PERSON ID')
  and (ATC2.TRANSACTION_COMMAND ='Save Patient Demographics'or ATC2.TRANSACTION_COMMAND = 'Process A28' and [TRANSACTION_COMMAND] is not null)

  ) sub

  where sub.[First_AuditUser] = 1


 




 





