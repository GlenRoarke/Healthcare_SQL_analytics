select top 1 S.ADMIT_DTTM
,S.DISCH_DTTM
,AF.LOG_DTTM
,DATEDIFF(minute,S.DISCH_DTTM,AF.LOG_DTTM)   
,ATC.TRANSACTION_COMMAND

,GETDATE()      [ExtractDate]
,1                         [Count]


--91,793
select count(1)
FROM HDM.dbo.FACT_IP_SPELL S with(nolock)
inner join HDM.dbo.FACT_AUDIT_FULL AF with(nolock) on s.DIM_PATIENT_ID = af.DIM_PATIENT_ID
inner join HDM.dbo.DIM_AUDIT_TRANSACTION_COMMAND ATC with(nolock) on ATC.DIM_AUDIT_TRANSACTION_COMMAND_ID = AF.DIM_AUDIT_TRANSACTION_COMMAND_ID

WHERE S.IP_SPELL_ID > 0
--     Only return the records where the Transaction Type was Discharge Patient. 
and ATC.TRANSACTION_COMMAND = 'Discharge Inpatient'
and S.DISCH_DTTM >= '01/12/2021' and  S.DISCH_DTTM <= '31/12/2021'
order by 
       IP_SPELL_EXTERNAL_ID
       ,AF.LOG_DTTM


SELECT count(1) FROM FACT_IP_SPELL_DISPLAN 

--[Disch_Start_Plan] the majority of discharge dates are less than the start of a plan (5655 not)
-- Much bigger amount discharged before their plan date
select 
p.PAS_ID 
,a.[ADMIT_DTTM]
,a.[DISCH_DTTM]
,b.START_DTTM
,b.PLAN_DTTM
,DATEDIFF(minute,a.[DISCH_DTTM],b.START_DTTM) [Disch_Start_Plan]
,DATEDIFF(minute,a.[DISCH_DTTM],b.PLAN_DTTM) [Disch_Plan]

FROM FACT_IP_SPELL a with(nolock)
INNER JOIN FACT_IP_SPELL_DISPLAN b with(nolock) on a.[IP_SPELL_ID] = b.[IP_SPELL_ID] 
INNER JOIN HDM.dbo.DIM_PATIENT p with(nolock) on p.DIM_PATIENT_ID = a.DIM_PATIENT_ID

WHERE DATEDIFF(minute,a.[DISCH_DTTM],b.PLAN_DTTM) > 0
--DATEDIFF(minute,a.[DISCH_DTTM],b.START_DTTM) > 0

--DATEDIFF(minute,a.[DISCH_DTTM],b.PLAN_DTTM) > 0
