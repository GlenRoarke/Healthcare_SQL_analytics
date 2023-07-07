SELECT * FROM HDM_CDS.CDS.APC  Where Hosp_Provider_Spell_No IN  ('I2200026064S', 'I2200020938S')

--cast HPS to date
-- HPS end greater than 01/04/2022 then RYR
-- Check against RYR
SELECT CDS_HEADER_UNIQUE_ID
,CDS_HEADER_TYPE
,IP_EPISODE_ID
,Episode_Number
,Hosp_Provider_Spell_No
,Organisation_Code_Provider
,Organisation_Code_Patient_ID
,CDS_Activity_Date
,HPS_Start_Date
,HPS_Disch_Date
,EPISODE_START_DTTM
,EPISODE_END_DTTM
,CREATE_DTTM 
,EXCLUDE_FROM_CDS
,CDS_OUTPUT
,Withheld_Identity_Reason
,CDS_HEADER_REPORT_PERIOD_START_DATE
,CDS_HEADER_REPORT_PERIOD_END_DATE
--,case when Hosp_Provider_Spell_No in (SELECT [column1] FROM [HDM_Local].[CorpData].[CDS_MissingEpisodes]) then 'yes' ELSE 'no' END [Check]
FROM HDM_CDS.CDS.APC  
--WHERE Organisation_Code_Provider is null

WHERE Hosp_Provider_Spell_No IN  (SELECT top 5 [column1] FROM [HDM_Local].[CorpData].[CDS_MissingEpisodes])
--('I2200026064S', 'I2200020938S')
ORDER BY Hosp_Provider_Spell_No DESC , Episode_Number  asc, CREATE_DTTM desc


--overview of the different site codes and dates in the CDS file 
Select Organisation_Code_Provider
,Organisation_Code_Patient_ID
,CDS_HEADER_REPORT_PERIOD_START_DATE
,CDS_HEADER_REPORT_PERIOD_END_DATE
,CDS_OUTPUT
,EXCLUDE_FROM_CDS
,count(1)
FROM HDM_CDS.CDS.APC  

WHERE CREATE_DTTM >= '06/06/2022'

GROUP BY Organisation_Code_Provider
,Organisation_Code_Patient_ID
,CDS_HEADER_REPORT_PERIOD_START_DATE
,CDS_HEADER_REPORT_PERIOD_END_DATE
,CDS_OUTPUT
,EXCLUDE_FROM_CDS

----overview of the different site codes and dates in the CDS file 
Select 
Organisation_Code_Patient_ID_Mother
,CDS_HEADER_REPORT_PERIOD_START_DATE
,CDS_HEADER_REPORT_PERIOD_END_DATE
,CDS_OUTPUT
,EXCLUDE_FROM_CDS
,count(1)
FROM HDM_CDS.CDS.APC  

WHERE CREATE_DTTM >= '06/06/2022'

GROUP BY 
Organisation_Code_Patient_ID_Mother
,CDS_HEADER_REPORT_PERIOD_START_DATE
,CDS_HEADER_REPORT_PERIOD_END_DATE
,CDS_OUTPUT
,EXCLUDE_FROM_CDS



SELECT CDS_HEADER_UNIQUE_ID
,IP_EPISODE_ID
,Episode_Number
,Hosp_Provider_Spell_No
,Organisation_Code_Provider
,Organisation_Code_Patient_ID
,CDS_Activity_Date
,HPS_Start_Date
,HPS_Disch_Date
,EPISODE_START_DTTM
,EPISODE_END_DTTM
,CREATE_DTTM 
,EXCLUDE_FROM_CDS
,CDS_OUTPUT
,Withheld_Identity_Reason
,CDS_HEADER_REPORT_PERIOD_START_DATE
,CDS_HEADER_REPORT_PERIOD_END_DATE
--,case when Hosp_Provider_Spell_No in (SELECT [column1] FROM [HDM_Local].[CorpData].[CDS_MissingEpisodes]) then 'yes' ELSE 'no' END [Check]

FROM HDM_CDS.CDS.APC  

WHERE  Hosp_Provider_Spell_No IN ('I2100120732S', 'I2100120732S')
--and CDS_HEADER_REPORT_PERIOD_START_DATE = '2022-03-01'

ORDER BY Hosp_Provider_Spell_No DESC , Episode_Number  asc ,CREATE_DTTM desc

--BRXH00I2200033128E




--attempt to have spells in started in March all as RXH and not RYR
 UPDATE [HDM_CDS].[CDS].[APC]
SET [Organisation_Code_Patient_ID] = CASE 
										--WHEN convert(date,HPS_Start_Date, 126) >= '01/04/2022' THEN 'RYR'
										WHEN convert(date,HPS_Start_Date, 126) < '01/04/2022' THEN 'RXH' 
										ELSE 'RYR'
										END
,[Organisation_Code_Provider] = CASE 
										--WHEN convert(date,HPS_Disch_Date, 126) >= '01/04/2022' THEN 'RYR'
										WHEN convert(date,HPS_Start_Date, 126) < '01/04/2022' THEN 'RXH'
										ELSE 'RYR'
										END

,[Organisation_Code_Patient_ID_Mother] = CASE 
										--WHEN convert(date,HPS_Disch_Date, 126) >= '01/04/2022' THEN 'RYR'
										WHEN convert(date,HPS_Disch_Date, 126) < '01/04/2022' THEN 'RXH' 
										ELSE 'RYR'
										END

WHERE CDS_OUTPUT = 0






