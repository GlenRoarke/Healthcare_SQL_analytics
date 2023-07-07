/* Object:  Script [CorpData].[Medway_Dup_Regs_by_User_with_IDs]    Alex Potter	Script Date: 17/05/2019
	We need to know which users need further support in identifying patients from the Spine and not creating a duplicate registration.

	This script gets the PAS_IDs of patients registered on Medway, identifies any that were merged with another patient record at a later date,
	tells us which of the two records is the major record and identifies the user who created the duplicate registration. 
	This output lists the patients with duplicate registrations created by the staff member selected. */


DECLARE @From date
DECLARE @To date

SET  @From  =  DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE())-6, 0) --1st day previous month 
SET @To =  DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-1, -1)--1st day previous month   -- last day of previous month 	

--INSERT INTO HDM_Local.[Corpdata].Medway_Dup_Regs_UserIDs	


SELECT DISTINCT SU.USERS_NAME Username
,CP.REG_DTTM --GR changed as wanted time for staff feedback
,CP.PAS_ID
,ISNULL(MERGE_RECORD_ID,'') [Merged into PAS_ID]
,(CASE WHEN  MERGE_RECORD_ID
		 is not null THEN 1
		ELSE 0
		END) Merged
,case	when convert(date,CP.REG_DTTM)<>convert(date,AF.CREATE_DTTM) then 1 
		when AF.CREATE_DTTM is null then 1 else 0 end no_audit

FROM [HDM].[dbo].[DIM_PATIENT] CP WITH (NOLOCK) 

	Left outer join (
			SELECT cp2.PAS_ID, MIN(AF2.[LOG_DTTM]) as CREATE_DTTM, SU2.USERS_NAME
		FROM [HDM].[dbo].[DIM_PATIENT] CP2 WITH (NOLOCK) 

		inner join HDM.dbo.FACT_AUDIT_FULL AF2 with(nolock) 
						ON CP2.[DIM_PATIENT_ID]=AF2.DIM_PATIENT_ID
		inner join HDM.dbo.DIM_AUDIT_TRANSACTION_COMMAND ATC2 with(nolock)
						on ATC2.DIM_AUDIT_TRANSACTION_COMMAND_ID = AF2.DIM_AUDIT_TRANSACTION_COMMAND_ID and ATC2.TRANSACTION_COMMAND ='Save Patient Demographics' or ATC2.TRANSACTION_COMMAND = 'Process A28' --Add in Process A28
		INNER JOIN HDM.dbo.DIM_LOOKUP_ENTITY ENT2 WITH (NOLOCK)   
						ON ENT2.DIM_LOOKUP_ENTITY_ID=AF2.DIM_LOOKUP_ENTITY_ID  --and ENT2.DESCRIPTION = 'PATIENT'
		Inner join HDM.dbo.DIM_SYSTEM_USER SU2 with(nolock) 
						on SU2.DIM_SYSTEM_USER_ID = AF2.DIM_SYSTEM_USER_ID		
		Where  (ENT2.DESCRIPTION = 'PATIENT' or ENT2.DESCRIPTION = 'PERSON ID')
		and cp2.REG_DTTM >= @From
		and cp2.REG_DTTM <= @To
			
		group by cp2.PAS_ID, SU2.USERS_NAME) A on a.PAS_ID =cp.PAS_ID 


	inner join HDM.dbo.FACT_AUDIT_FULL AF with(nolock) 
						ON CP.[DIM_PATIENT_ID]=AF.DIM_PATIENT_ID and AF.CREATE_DTTM = A.CREATE_DTTM --this links log date

	inner join HDM.dbo.DIM_AUDIT_TRANSACTION_COMMAND ATC with(nolock) 
						on ATC.DIM_AUDIT_TRANSACTION_COMMAND_ID = AF.DIM_AUDIT_TRANSACTION_COMMAND_ID 
						and (ATC.TRANSACTION_COMMAND ='Save Patient Demographics' or ATC.TRANSACTION_COMMAND = 'Unknown'or ATC.TRANSACTION_COMMAND = 'Process A28') --Add in  or Process A28

	INNER JOIN HDM.dbo.DIM_LOOKUP_ENTITY ENT WITH (NOLOCK)   
						ON ENT.DIM_LOOKUP_ENTITY_ID=AF.DIM_LOOKUP_ENTITY_ID  
						and (ENT.DESCRIPTION = 'PATIENT' or ENT.DESCRIPTION = 'Person Id')

	Inner join HDM.dbo.DIM_SYSTEM_USER SU with(nolock) 
						on SU.DIM_SYSTEM_USER_ID = AF.DIM_SYSTEM_USER_ID 

WHERE --SU.USERS_NAME = 'Bridger, Jason (Mr)'
CP.PAS_ID is not null
and SU.USERS_NAME IS NOT NULL
and convert(date,CP.REG_DTTM)=convert(date,AF.CREATE_DTTM)
and AF.CREATE_DTTM is not null 
GROUP BY SU.USERS_NAME, CP.REG_DTTM, AF.CREATE_DTTM, CP.PAS_ID, ENT.DESCRIPTION, ATC.TRANSACTION_COMMAND,ISNULL(MERGE_RECORD_ID,'')

,(CASE WHEN  MERGE_RECORD_ID
		 is not null THEN 1
		ELSE 0
		END) 
,case	when convert(date,CP.REG_DTTM)<>convert(date,AF.CREATE_DTTM) then 1 
		when AF.CREATE_DTTM is null then 1 else 0 end 

order by SU.USERS_NAME, CP.PAS_ID

