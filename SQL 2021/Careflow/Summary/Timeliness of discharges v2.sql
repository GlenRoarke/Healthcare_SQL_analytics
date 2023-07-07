
--Timeliness of discharges
--purpose: to monitor the delay in entering inpatient discharges

--questions
--how does the date range of disch or log dttm differ in counts

--Approach 
-- 3) Spell > audit > Command 
		--log DTTM 91,793
		--disch DTTM 114,518
-- I am concerned about the volume of minus -1 for DIM_Patient_ID in the Audit table


/*SELECT AF.ENTITY_EXTERNAL_ID
,AF.LOG_DTTM
,ATC.[TRANSACTION_COMMAND] */

SELECT top 1000 
p.PAS_ID
,s.[IP_SPELL_ID]
,s.[IPSP_EXT_ID]
,S.ADMIT_DTTM
,S.DISCH_DTTM
,AF.LOG_DTTM
,DATEDIFF(minute,S.DISCH_DTTM,AF.LOG_DTTM)                    "Datediff MINS"  
,ATC.TRANSACTION_COMMAND
FROM  HDM.dbo.FACT_IP_SPELL S with(nolock)
inner join HDM.dbo.FACT_AUDIT_FULL AF with(nolock) on s.DIM_PATIENT_ID = af.DIM_PATIENT_ID --this join is not unique enough one patient can have many spells and audits
inner join HDM.dbo.DIM_AUDIT_TRANSACTION_COMMAND ATC with(nolock) on ATC.DIM_AUDIT_TRANSACTION_COMMAND_ID = AF.DIM_AUDIT_TRANSACTION_COMMAND_ID
inner join HDM.dbo.DIM_PATIENT p with(nolock) on p.DIM_PATIENT_ID = s.DIM_PATIENT_ID --gets PAS ID


WHERE S.IP_SPELL_ID > 0
--     Only return the records where the Transaction Type was Discharge Patient. 
and ATC.TRANSACTION_COMMAND = 'Discharge Inpatient'
and S.DISCH_DTTM >= '01/12/2021' and  S.DISCH_DTTM <= '31/12/2021'

ORDER BY IP_SPELL_ID

/*HDM.dbo.FACT_AUDIT_FULL AF with(nolock)
inner join HDM.dbo.DIM_AUDIT_TRANSACTION_COMMAND ATC with(nolock) on ATC.DIM_AUDIT_TRANSACTION_COMMAND_ID = AF.DIM_AUDIT_TRANSACTION_COMMAND_ID

where  ATC.TRANSACTION_COMMAND = 'Discharge Inpatient'
and AF.LOG_DTTM >= '01/12/2021' and  AF.LOG_DTTM <= '31/12/2021' */



select top 1 S.ADMIT_DTTM
,AF.LOG_DTTM
,DATEDIFF(minute,S.DISCH_DTTM,AF.LOG_DTTM)                    "Datediff MINS"  
,ATC.TRANSACTION_COMMAND
,'Discharges' "Event Type"
,GETDATE()      "ExtractDate"
,1                         "Count"
,1                         "Number of entries"
                     
from 
       HDM.dbo.FACT_IP_SPELL S with(nolock)
--     Join to latest audit record for this FACT record
       inner join HDM.dbo.FACT_AUDIT_FULL AF with(nolock)
              on AF.ENTITY_EXTERNAL_ID = S.IP_SPELL_EXTERNAL_ID
--     Get the Transaction Name that created the Audit Record
       inner join HDM.dbo.DIM_AUDIT_TRANSACTION_COMMAND ATC with(nolock)
              on ATC.DIM_AUDIT_TRANSACTION_COMMAND_ID = AF.DIM_AUDIT_TRANSACTION_COMMAND_ID

where 
       S.IP_SPELL_ID > 0
--     Only return the records where the Transaction Type was Discharge Patient. 
       and ATC.TRANSACTION_COMMAND = 'Discharge Inpatient'
and S.DISCH_DTTM > '01/12/2021'
order by 
       IP_SPELL_EXTERNAL_ID
       ,AF.LOG_DTTM



select  AF.ENTITY_EXTERNAL_ID 
from 
       HDM.dbo.FACT_IP_SPELL S with(nolock)


--     Join to latest audit record for this FACT record
       inner join HDM.dbo.FACT_AUDIT_FULL AF with(nolock)
              on s.DIM_PATIENT_ID = af.DIM_PATIENT_ID
--     Get the Transaction Name that created the Audit Record
       inner join HDM.dbo.DIM_AUDIT_TRANSACTION_COMMAND ATC with(nolock)
              on ATC.DIM_AUDIT_TRANSACTION_COMMAND_ID = AF.DIM_AUDIT_TRANSACTION_COMMAND_ID

where 
       S.IP_SPELL_ID > 0
--     Only return the records where the Transaction Type was Discharge Patient. 
      and ATC.TRANSACTION_COMMAND = 'Discharge Patient'
and S.DISCH_DTTM >= '01/12/2021' and  S.DISCH_DTTM <= '02/12/2021'
order by 
       IP_SPELL_EXTERNAL_ID
       ,AF.LOG_DTTM






SELECT count(1) FROM HDM.dbo.DIM_AUDIT_TRANSACTION_COMMAND ATC
WHERE ATC.TRANSACTION_COMMAND = 'Discharge Inpatient'

select top 1000 * from HDM.dbo.FACT_AUDIT_FULL AF where DIM_AUDIT_TRANSACTION_COMMAND_ID = 20


--There is not a dischare patient in this code.
Select ATC2.TRANSACTION_COMMAND
,ENT2.DESCRIPTION
,count(1)
 FROM [HDM].[dbo].[FACT_AUDIT_FULL] AF2
  INNER JOIN HDM.dbo.DIM_AUDIT_TRANSACTION_COMMAND ATC2 with(nolock) ON ATC2.DIM_AUDIT_TRANSACTION_COMMAND_ID = AF2.DIM_AUDIT_TRANSACTION_COMMAND_ID
  INNER JOIN HDM.dbo.DIM_LOOKUP_ENTITY ENT2 WITH (NOLOCK) ON ENT2.DIM_LOOKUP_ENTITY_ID=AF2.DIM_LOOKUP_ENTITY_ID  

  GROUP BY ATC2.TRANSACTION_COMMAND
,ENT2.DESCRIPTION

ORDER BY ATC2.TRANSACTION_COMMAND asc
,ENT2.DESCRIPTION asc


  WHERE ATC2.TRANSACTION_COMMAND = 'Discharge Inpatient'


  select * from HDM.dbo.DIM_LOOKUP_ENTITY 