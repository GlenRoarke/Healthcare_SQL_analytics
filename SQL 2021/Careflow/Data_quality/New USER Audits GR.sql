/****** Ranking 1st Order by ******/
--Add in username joins
--Add in date range of previous 6th months 
--attempt to add an index to audit data?

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
into #DupsTMP
FROM [HDM].[dbo].[DIM_PATIENT] p 
INNER JOIN  [HDM].[dbo].[DIM_PATIENT] p2 with(nolock) on p.MERGE_RECORD_ID  = p2.PAS_ID
where p.MERGE_RECORD_ID is not null
and p.ARCHV_FLAG = 'N'
and p.Surname <> 'Test-Patient'
and P.DIM_PATIENT_ID > 0
and p.REG_DTTM between  DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE())-6, 0) --1st day previous 6 months 
    and  DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-1, -1)---- last day of previous month   

CREATE NONCLUSTERED INDEX ix_MinorTMP ON #DupsTMP ([DIM_PATIENT_ID_Minor])
CREATE NONCLUSTERED INDEX ix_MajorTMP ON #DupsTMP ([DIM_PATIENT_ID_Master])



--this query ranks the order of audit transactions by log DTTM, links to minor IDs that have been merged
select * from (

SELECT  [PAS_ID_Minor]
	,[PAS_ID_Master]
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
	  ,row_number() over(partition by [DIM_PATIENT_ID] order by [LOG_DTTM] desc) as [First_AuditUser]
  FROM [HDM].[dbo].[FACT_AUDIT_FULL] AF2
  INNER JOIN HDM.dbo.DIM_AUDIT_TRANSACTION_COMMAND ATC2 with(nolock) ON ATC2.DIM_AUDIT_TRANSACTION_COMMAND_ID = AF2.DIM_AUDIT_TRANSACTION_COMMAND_ID
  INNER JOIN HDM.dbo.DIM_LOOKUP_ENTITY ENT2 WITH (NOLOCK) ON ENT2.DIM_LOOKUP_ENTITY_ID=AF2.DIM_LOOKUP_ENTITY_ID  
  INNER JOIN HDM.dbo.DIM_SYSTEM_USER SU2 with(nolock) ON SU2.DIM_SYSTEM_USER_ID = AF2.DIM_SYSTEM_USER_ID
  left JOIN [HDM].[dbo].[DIM_SYSTEM_TERMINAL] st with(nolock) on st.[DIM_SYSTEM_TERM_ID] = AF2.DIM_SYSTEM_TERMINAL_ID

  INNER JOIN #DupsTMP a with(nolock) on a.[DIM_PATIENT_ID_Minor] = af2.[DIM_PATIENT_ID]

  WHERE ENT2.DESCRIPTION IN ('PATIENT', 'PERSON ID')
  and (ATC2.TRANSACTION_COMMAND ='Save Patient Demographics'or ATC2.TRANSACTION_COMMAND = 'Process A28')

  ) sub

  where sub.[First_AuditUser] = 1








