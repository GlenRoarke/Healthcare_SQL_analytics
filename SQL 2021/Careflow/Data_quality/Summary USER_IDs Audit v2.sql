DECLARE @From date
DECLARE @To date

SET  @From  =  DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE())-6, 0) --1st day previous month 
SET @To =  DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-1, -1)--1st day previous month   -- last day of previous month 		

--INSERT INTO HDM_Local.[Corpdata].Medway_Dup_Regs_User
SELECT 
B.Username
,Yearmonth
,Count(B.PAS_ID)
,Sum(B.Merged)
,Systm
,GETDATE()


FROM [HDM].[dbo].[DIM_PATIENT] C WITH (NOLOCK) 

Left outer join (
SELECT DISTINCT CP.PAS_ID
,EOMONTH(CP.REG_DTTM) Yearmonth
,AF.CREATE_DTTM Logged
,ENT.DESCRIPTION Entity
,ATC.TRANSACTION_COMMAND command
,(CASE WHEN  MERGE_RECORD_ID
		 is not null THEN 1
		ELSE 0
		END) Merged
,ISNULL(MERGE_RECORD_ID,'') [Merged into PAS_ID]
,A.USERS_NAME Username
,case when ATC.TRANSACTION_COMMAND = 'Save Patient Demographics' then 'Medway' 
	when ATC.TRANSACTION_COMMAND = 'Unknown' and ENT.DESCRIPTION = 'Person Id' then 'Symphony' else 'Other' end Systm
,case	when convert(date,CP.REG_DTTM)<>convert(date,AF.CREATE_DTTM) then 1 
		when AF.CREATE_DTTM is null then 1 else 0 end no_audit

FROM [HDM].[dbo].[DIM_PATIENT] CP WITH (NOLOCK) 

Left outer join (SELECT cp2.PAS_ID, MIN(AF2.CREATE_DTTM) as CREATE_DTTM, SU2.USERS_NAME
		FROM [HDM].[dbo].[DIM_PATIENT] CP2 WITH (NOLOCK) 

		inner join HDM.dbo.FACT_AUDIT_FULL AF2 with(nolock) 
						ON CP2.DIM_PATIENT_ID=AF2.DIM_PATIENT_ID
		inner join HDM.dbo.DIM_AUDIT_TRANSACTION_COMMAND ATC2 with(nolock)
						on ATC2.DIM_AUDIT_TRANSACTION_COMMAND_ID = AF2.DIM_AUDIT_TRANSACTION_COMMAND_ID and (ATC2.TRANSACTION_COMMAND ='Save Patient Demographics' or ATC2.TRANSACTION_COMMAND = 'Process A28')
		INNER JOIN HDM.dbo.DIM_LOOKUP_ENTITY ENT2 WITH (NOLOCK)   
						ON ENT2.DIM_LOOKUP_ENTITY_ID=AF2.DIM_LOOKUP_ENTITY_ID  --and ENT2.DESCRIPTION = 'PATIENT'
		Inner join HDM.dbo.DIM_SYSTEM_USER SU2 with(nolock) 
						on SU2.DIM_SYSTEM_USER_ID = AF2.DIM_SYSTEM_USER_ID		
		Where  (ENT2.DESCRIPTION = 'PATIENT' or ENT2.DESCRIPTION = 'PERSON ID')
		and cp2.REG_DTTM >= @From
		and cp2.REG_DTTM <= @To
			
		group by cp2.PAS_ID, SU2.USERS_NAME) A on a.PAS_ID =cp.PAS_ID --and AF.CREATE_DTTM = A.CREATE_DTTM


inner join HDM.dbo.FACT_AUDIT_FULL AF with(nolock) 
						ON CP.DIM_PATIENT_ID=AF.DIM_PATIENT_ID and AF.CREATE_DTTM = A.CREATE_DTTM

inner join HDM.dbo.DIM_AUDIT_TRANSACTION_COMMAND ATC with(nolock) on ATC.DIM_AUDIT_TRANSACTION_COMMAND_ID = AF.DIM_AUDIT_TRANSACTION_COMMAND_ID 
	and (ATC.TRANSACTION_COMMAND ='Save Patient Demographics' or ATC.TRANSACTION_COMMAND = 'Unknown' or ATC.TRANSACTION_COMMAND = 'Process A28')

INNER JOIN HDM.dbo.DIM_LOOKUP_ENTITY ENT WITH (NOLOCK)   
						ON ENT.DIM_LOOKUP_ENTITY_ID=AF.DIM_LOOKUP_ENTITY_ID  
						and (ENT.DESCRIPTION = 'PATIENT' or ENT.DESCRIPTION = 'Person Id')

Inner join HDM.dbo.DIM_SYSTEM_USER SU with(nolock) 
						on SU.DIM_SYSTEM_USER_ID = AF.DIM_SYSTEM_USER_ID


		
		--where convert(date,CP.REG_DTTM)=convert(date,AF.CREATE_DTTM)	

		) B on C.PAS_ID = B.PAS_ID 

Where C.REG_DTTM >= @From
and C.REG_DTTM <= @To
and C.PAS_ID is not null
and B.Username IS NOT NULL
and no_audit = 0


GROUP BY B.Username, B.YearMonth, Systm
		
order by 1