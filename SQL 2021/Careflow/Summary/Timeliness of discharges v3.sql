--timeliness of discharges v3
--method: Spell = Audit = GUID entity ID
-- Issues a patient can multiple discharges in a spell. eg when they are discharged incorrectly then un discharged again

--Raw Data
SELECT p.PAS_ID
,S.IP_SPELL_ID
,s.[IPSP_EXT_ID]
,ATC.TRANSACTION_COMMAND
,ENT.DESCRIPTION [Entity_ID]
,su.SSU_NAME
,S.ADMIT_DTTM
,S.DISCH_DTTM
,S.SPELL_COUNT
,AF.LOG_DTTM
,DATEDIFF(minute,S.DISCH_DTTM,AF.LOG_DTTM)  [Disch_DTTM_diff_Log_DTTM]
,DATEDIFF(hour,S.DISCH_DTTM,AF.LOG_DTTM)  [Hour Disch_DTTM_diff_Log_DTTM]
,CASE WHEN DATEDIFF(minute,S.DISCH_DTTM,AF.LOG_DTTM) <= 16 then 1 else 0 end as [LessThan_15_Mins] --1 = Y 
,CASE WHEN DATEDIFF(minute,S.DISCH_DTTM,AF.LOG_DTTM) <= 1440 then 1 else 0 end as [LessThan_1_Day]
FROM HDM.dbo.FACT_IP_SPELL S with(nolock) --697557
INNER JOIN HDM.dbo.FACT_AUDIT_FULL AF with(nolock) on AF.ENTITY_EXTERNAL_ID = S.IP_SPELL_EXTERNAL_ID --4527370
INNER JOIN HDM.dbo.DIM_AUDIT_TRANSACTION_COMMAND ATC with(nolock) on ATC.DIM_AUDIT_TRANSACTION_COMMAND_ID = AF.DIM_AUDIT_TRANSACTION_COMMAND_ID --4527370
INNER JOIN HDM.dbo.DIM_LOOKUP_ENTITY ENT WITH (NOLOCK) ON ENT.DIM_LOOKUP_ENTITY_ID = AF.DIM_LOOKUP_ENTITY_ID 
INNER JOIN HDM.dbo.DIM_PATIENT p with(nolock) ON p.dim_patient_id = s.dim_patient_id
INNER JOIN HDM.dbo.DIM_SITE_SERVICE_UNIT su with(nolock) on su.DIM_SSU_ID = s.DIM_DIS_WARD_ID

WHERE  S.IP_SPELL_ID > 0  
--and AF.[DIM_LOOKUP_ENTITY_ID] = 119 -- IP SPELL only as there is commands for discharges for Episodes and Patients
and ATC.TRANSACTION_COMMAND = 'Discharge Inpatient'
--and S.DISCH_DTTM >= @StartDate and  S.DISCH_DTTM <= @EndDate 
--and S.DISCH_DTTM >= DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE())-2, 0) and  S.DISCH_DTTM <= getdate()
and S.DISCH_DTTM between DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE())-6, 0) and getdate()

and DATEDIFF(minute,S.DISCH_DTTM,AF.LOG_DTTM)  >=0 -- to reduce multiple discharge actions casuing negative datediff

--and su.SSU_NAME like 'RSCH Emergency Ambulatory Care Unit'
--ORDER BY S.IP_SPELL_ID asc

--Raw Data


 	select DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE())-6, 0) [StartDate]
	 ,getdate() [EndDate]


--Summary Inncorrect grouping
SELECT s.DIM_DIS_WARD_ID
,su.SSU_NAME
,count(1) [Spell_Count]
,DATEDIFF(minute,S.DISCH_DTTM,AF.LOG_DTTM)  [Disch_DTTM_diff_Log_DTTM]
,DATEDIFF(hour,S.DISCH_DTTM,AF.LOG_DTTM)  [Hour Disch_DTTM_diff_Log_DTTM]
,CASE WHEN DATEDIFF(minute,S.DISCH_DTTM,AF.LOG_DTTM) <= 16 then 1 else 0 end as [15_Mins] --Less than 15 mins
,CASE WHEN DATEDIFF(minute,S.DISCH_DTTM,AF.LOG_DTTM) <= 1440 then 1 else 0 end as [1_Day] 
FROM HDM.dbo.FACT_IP_SPELL S with(nolock) --697557
INNER JOIN HDM.dbo.FACT_AUDIT_FULL AF with(nolock) on AF.ENTITY_EXTERNAL_ID = S.IP_SPELL_EXTERNAL_ID --4527370
INNER JOIN HDM.dbo.DIM_AUDIT_TRANSACTION_COMMAND ATC with(nolock) on ATC.DIM_AUDIT_TRANSACTION_COMMAND_ID = AF.DIM_AUDIT_TRANSACTION_COMMAND_ID --4527370
INNER JOIN HDM.dbo.DIM_LOOKUP_ENTITY ENT WITH (NOLOCK) ON ENT.DIM_LOOKUP_ENTITY_ID = AF.DIM_LOOKUP_ENTITY_ID 
INNER JOIN HDM.dbo.DIM_PATIENT p with(nolock) ON p.dim_patient_id = s.dim_patient_id
INNER JOIN HDM.dbo.DIM_SITE_SERVICE_UNIT su with(nolock) on su.DIM_SSU_ID = s.DIM_DIS_WARD_ID

 WHERE  S.IP_SPELL_ID > 0  
--and AF.[DIM_LOOKUP_ENTITY_ID] = 119 -- IP SPELL only as there is commands for discharges for Episodes and Patients
and ATC.TRANSACTION_COMMAND = 'Discharge Inpatient'
and S.DISCH_DTTM >= @StartDate and  S.DISCH_DTTM <= @EndDate --9449 /9687 (spells in Dec) 
and DATEDIFF(minute,S.DISCH_DTTM,AF.LOG_DTTM)  >=0 -- to reduce multiple discharge actions casuing negative datediff

and su.SSU_NAME like 'BGH A Block Dermatology & Plastics Day Surgery'

GROUP BY s.DIM_DIS_WARD_ID
,su.SSU_NAME
,DATEDIFF(minute,S.DISCH_DTTM,AF.LOG_DTTM)
,DATEDIFF(hour,S.DISCH_DTTM,AF.LOG_DTTM)  
,CASE WHEN DATEDIFF(minute,S.DISCH_DTTM,AF.LOG_DTTM) >= 16 then 1 else 0 end
,CASE WHEN DATEDIFF(minute,S.DISCH_DTTM,AF.LOG_DTTM) >= 1440 then 1 else 0 end






--Indicators (non-interval)


case when DATEDIFF(MINUTE,a.admit_DTTM,a.create_DTTM) <= 16 then 1
else 0 end as Indicator15,
case when DATEDIFF(MINUTE,a.admit_DTTM,a.create_DTTM) <= 1440 then '< 1 day'
else '> 1 day' end as IndicatorDAY,
case when DATEDIFF(MINUTE,a.admit_DTTM,a.create_DTTM) <= 10080 then '< 1 week'
else '> 1 week' end as IndicatorWEEK,
case when DATEDIFF(MINUTE,a.admit_DTTM,a.create_DTTM) <= 43800 then '< 1 month'
else '> 1 month' end as IndicatorMONTH,
case when DATEDIFF(MINUTE,a.admit_DTTM,a.create_DTTM) <= 87600 then '< 2 month'
else '> 2 month' end as Indicator2MONTH,




