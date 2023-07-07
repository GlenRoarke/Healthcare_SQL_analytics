--DQ Completeness Report
--This code will be added to an SSRS report fot the DQ completeness dashboard

--NHS Number Gauge

SELECT sum(case when p.NNNST_MAINCODE = '01' then 1  
	else 0 end ) [NHS_No_01]
,count(1) total
,round(sum(case when p.NNNST_MAINCODE = '01' then 1  else 0 end )/ cast(count(1) as decimal),3) [Verified_NHS_No_Percentage]
FROM HDM.[dbo].[DIM_Patient] P with(nolock)
WHERE  p.ARCHV_FLAG = 'N'
 and P.DIM_PATIENT_ID >0
 and p.MERGE_RECORD_ID is NULL
 and p.Surname <> 'Test-Patient'
 --and p.REG_DTTM >= '01/11/2018'

 --NHS Number Graph
 SELECT sum(case when p.NNNST_MAINCODE = '01' then 1  
	else 0 end ) [NHS_No_01]
,count(1) total
,round(sum(case when p.NNNST_MAINCODE = '01' then 1  else 0 end )/ cast(count(1) as decimal),3) [Verified_NHS_No_Percentage]
,convert(datetime,dateadd(month,datediff(month,0,p.REG_DTTM),0),103) [Reg_Month]

FROM HDM.[dbo].[DIM_Patient] P with(nolock)
WHERE  p.ARCHV_FLAG = 'N'
 and P.DIM_PATIENT_ID >0
 and p.MERGE_RECORD_ID is NULL
 and p.Surname <> 'Test-Patient'
 and p.REG_DTTM >= '01/04/2021'

 GROUP BY convert(datetime,dateadd(month,datediff(month,0,p.REG_DTTM),0),103)
 
 ORDER BY  4 desc


 --GP Practice Gauge
 Select sum(case when p.[HCO_NHSCODE] NOT IN ('V81999','V81998','V81997','Unknown','') and [HCO_NHSCODE] is not null  THEN 1 end) [Complete_GPs]
 ,count(1) Total
 ,sum(case when p.[HCO_NHSCODE] NOT IN ('V81999','V81998','V81997','Unknown','') and [HCO_NHSCODE] is not null  THEN 1 end) / cast(count(1) as decimal) [GP_Percent]
 FROM [hdm].[dbo].[DIM_PATIENT] p
 WHERE  p.ARCHV_FLAG = 'N'
 and P.DIM_PATIENT_ID >0
 and p.MERGE_RECORD_ID is NULL
 and p.Surname <> 'Test-Patient'
 
 --GP Practice Graph
  Select sum(case when p.[HCO_NHSCODE] NOT IN ('V81999','V81998','V81997','Unknown','') and [HCO_NHSCODE] is not null  THEN 1 end) [Complete_GPs]
 ,count(1) Total
 ,sum(case when p.[HCO_NHSCODE] NOT IN ('V81999','V81998','V81997','Unknown','') and [HCO_NHSCODE] is not null  THEN 1 end) / cast(count(1) as decimal) [GP_Percent]
 ,convert(datetime,dateadd(month,datediff(month,0,p.REG_DTTM),0),103) [Reg_Month]
 FROM [hdm].[dbo].[DIM_PATIENT] p
 WHERE  p.ARCHV_FLAG = 'N'
 and P.DIM_PATIENT_ID >0
 and p.MERGE_RECORD_ID is NULL
 and p.Surname <> 'Test-Patient'

 group by convert(datetime,dateadd(month,datediff(month,0,p.REG_DTTM),0),103)


 --Postcode Gauge
 SELECT sum(case when p.POSTCODE  NOT LIKE 'ZZ%' and p.Postcode IS NOT NULL and p.Postcode NOT IN ('')THEN 1 ELSE 0 END) [CompletePostcodes]
  ,count(1) Total
  ,sum(case when p.POSTCODE  NOT LIKE 'ZZ%' and p.Postcode IS NOT NULL and p.Postcode NOT IN ('')THEN 1 ELSE 0 END) / cast(count(1) as decimal)
  FROM [hdm].[dbo].[DIM_PATIENT] p
 WHERE  p.ARCHV_FLAG = 'N'
 and P.DIM_PATIENT_ID >0
 and p.MERGE_RECORD_ID is NULL
 and p.Surname <> 'Test-Patient'

--Postcode Graph
  SELECT sum(case when p.POSTCODE  NOT LIKE 'ZZ%' and p.Postcode IS NOT NULL and p.Postcode NOT IN ('')THEN 1 ELSE 0 END) [CompletePostcodes]
  ,count(1) Total
  ,sum(case when p.POSTCODE  NOT LIKE 'ZZ%' and p.Postcode IS NOT NULL and p.Postcode NOT IN ('')THEN 1 ELSE 0 END) / cast(count(1) as decimal) [PostCode_Percent]
  ,convert(datetime,dateadd(month,datediff(month,0,p.REG_DTTM),0),103) [Reg_Month]
  FROM [hdm].[dbo].[DIM_PATIENT] p
 WHERE  p.ARCHV_FLAG = 'N'
 and P.DIM_PATIENT_ID >0
 and p.MERGE_RECORD_ID is NULL
 and p.Surname <> 'Test-Patient'
 and p.REG_DTTM >= '01/04/2021'

 GROUP BY convert(datetime,dateadd(month,datediff(month,0,p.REG_DTTM),0),103)

 --Ethnicity Gauge

SELECT [ETHNC_DESC]
,[ETHNC_MAINCODE]
,count(1)

FROM [hdm].[dbo].[DIM_PATIENT] p
  WHERE  p.ARCHV_FLAG = 'N'
 and P.DIM_PATIENT_ID >0
 and p.MERGE_RECORD_ID is NULL
 and p.Surname <> 'Test-Patient'
 and p.REG_DTTM >= '01/04/2021'

GROUP BY [ETHNC_DESC]
,[ETHNC_MAINCODE]

ORDER BY 3 desc

--Ethnicity Gauge - Incomplete is NotSet, Nulls blanks, Notstated is complete??
SELECT sum(case when p.[ETHNC_MAINCODE] NOT IN ('NOTSE','') and [ETHNC_MAINCODE] is not null  THEN 1 ELSE 0 END) [CompleteEthnicity]
,count(1) [Total]
,sum(case when p.[ETHNC_MAINCODE] NOT IN ('NOTSE','') and [ETHNC_MAINCODE] is not null  THEN 1 ELSE 0 END)/ cast(count(1) as decimal)
FROM [hdm].[dbo].[DIM_PATIENT] p
  WHERE  p.ARCHV_FLAG = 'N'
 and P.DIM_PATIENT_ID >0
 and p.MERGE_RECORD_ID is NULL
 and p.Surname <> 'Test-Patient'
 --and p.REG_DTTM >= '01/04/2021'


 --Ethnicity Graph Incomplete is NotSet, Nulls blanks, Notstated is complete??
SELECT sum(case when p.[ETHNC_MAINCODE] NOT IN ('NOTSE','') and [ETHNC_MAINCODE] is not null  THEN 1 ELSE 0 END) [CompleteEthnicity]
,count(1) [Total]
,sum(case when p.[ETHNC_MAINCODE] NOT IN ('NOTSE','') and [ETHNC_MAINCODE] is not null  THEN 1 ELSE 0 END)/ cast(count(1) as decimal)
 ,convert(datetime,dateadd(month,datediff(month,0,p.REG_DTTM),0),103) [Reg_Month]

FROM [hdm].[dbo].[DIM_PATIENT] p
  WHERE  p.ARCHV_FLAG = 'N'
 and P.DIM_PATIENT_ID >0
 and p.MERGE_RECORD_ID is NULL
 and p.Surname <> 'Test-Patient'
 and p.REG_DTTM >= '01/04/2021'

 GROUP BY convert(datetime,dateadd(month,datediff(month,0,p.REG_DTTM),0),103) 

 --Next of Kin - Gauge

SELECT	sum(case when p.[DIM_LOOKUP_NOKREL_ID] = -1 then 1 ELSE 0 END) [NOK_Completeness]
,count(1) [Total]
,sum(case when p.[DIM_LOOKUP_NOKREL_ID] = -1 then 1 ELSE 0 END)/cast(count(1) as decimal) [NOK_Percentage]
FROM [HDM].[dbo].[DIM_PATIENT] p with(nolock)
WHERE  p.ARCHV_FLAG = 'N'
 and P.DIM_PATIENT_ID >0
 and p.MERGE_RECORD_ID is NULL
 and p.Surname <> 'Test-Patient'
 and p.REG_DTTM >= '01/04/2021'

 --Next of Kin - Graph 

 SELECT	sum(case when p.[DIM_LOOKUP_NOKREL_ID] = -1 then 1 ELSE 0 END) [NOK_Completeness]
,count(1) [Total]
,sum(case when p.[DIM_LOOKUP_NOKREL_ID] = -1 then 1 ELSE 0 END)/cast(count(1) as decimal)
,convert(datetime,dateadd(month,datediff(month,0,p.REG_DTTM),0),103) [Reg_Month]
FROM [HDM].[dbo].[DIM_PATIENT] p with(nolock)
WHERE  p.ARCHV_FLAG = 'N'
 and P.DIM_PATIENT_ID >0
 and p.MERGE_RECORD_ID is NULL
 and p.Surname <> 'Test-Patient'
 and p.REG_DTTM >= '01/04/2021'

 GROUP BY convert(datetime,dateadd(month,datediff(month,0,p.REG_DTTM),0),103)

 ORDER BY 4 desc

 --Sexuality

--Add in Not know to NULL
--Sexuality Gauge
SELECT 
sum(case when p.SEXUAL_ORIENT_MAINCODE NOT IN ('NS','','NOTKN') then 1 ELSE 0 END) [Completed_Sexuality]
,count(1) [Total]
,sum(case when p.SEXUAL_ORIENT_MAINCODE NOT IN ('NS','','NOTKN') then 1 ELSE 0 END) /cast(count(1) as decimal)
FROM [HDM].[dbo].[DIM_PATIENT] p with(nolock)
WHERE  p.ARCHV_FLAG = 'N'
 and P.DIM_PATIENT_ID >0
 and p.MERGE_RECORD_ID is NULL
 and p.Surname <> 'Test-Patient'
 --and p.REG_DTTM >= '01/04/2021'


 --Sexuality Gauge
SELECT 
sum(case when p.SEXUAL_ORIENT_MAINCODE NOT IN ('NS','') then 1 ELSE 0 END) [Completed_Sexuality]
,count(1) [Total]
,sum(case when p.SEXUAL_ORIENT_MAINCODE NOT IN ('NS','') then 1 ELSE 0 END) /cast(count(1) as decimal) [Sexuality_Percentage]
FROM [HDM].[dbo].[DIM_PATIENT] p with(nolock)
WHERE  p.ARCHV_FLAG = 'N'
 and P.DIM_PATIENT_ID >0
 and p.MERGE_RECORD_ID is NULL
 and p.Surname <> 'Test-Patient'

 --Sexuality Graph 

 SELECT 
sum(case when p.SEXUAL_ORIENT_MAINCODE NOT IN ('NS','') then 1 ELSE 0 END) [Completed_Sexuality]
,count(1) [Total]
,sum(case when p.SEXUAL_ORIENT_MAINCODE NOT IN ('NS','') then 1 ELSE 0 END) /cast(count(1) as decimal)
,convert(datetime,dateadd(month,datediff(month,0,p.REG_DTTM),0),103) [Reg_Month]
 
FROM [HDM].[dbo].[DIM_PATIENT] p with(nolock)
WHERE  p.ARCHV_FLAG = 'N'
 and P.DIM_PATIENT_ID >0
 and p.MERGE_RECORD_ID is NULL
 and p.Surname <> 'Test-Patient'
 and p.REG_DTTM >= '01/04/2021'

 GROUP BY convert(datetime,dateadd(month,datediff(month,0,p.REG_DTTM),0),103) 


 	select DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE())-12, 0) [StartDate]
	 ,getdate() [EndDate]


--Telephones Gauge
SELECT sum(case when p.[HPHONE_NUMBER] is not NULL or p.[MPHONE_NUMBER] is not null or [WPHONE_NUMBER] is not NULL then 1 ELSE 0 end) [PhoneNumberCheck]
,count(1) [Total]
,sum(case when p.[HPHONE_NUMBER] is not NULL or p.[MPHONE_NUMBER] is not null or [WPHONE_NUMBER] is not NULL then 1 ELSE 0 end) / cast(count(1) as decimal) [Telephone_Percentage 
 
--,MPHONE_NUMBER
--,[WPHONE_NUMBER]
FROM [HDM].[dbo].[DIM_PATIENT] p with(nolock)
WHERE  p.ARCHV_FLAG = 'N'
 and P.DIM_PATIENT_ID >0
 and p.MERGE_RECORD_ID is NULL
 and p.Surname <> 'Test-Patient'
 --and p.REG_DTTM >= '01/04/2021'



 --Telephones Graph
SELECT sum(case when p.[HPHONE_NUMBER] is not NULL or p.[MPHONE_NUMBER] is not null or [WPHONE_NUMBER] is not NULL then 1 ELSE 0 end) [PhoneNumberCheck]
,count(1) [Total]
,sum(case when p.[HPHONE_NUMBER] is not NULL or p.[MPHONE_NUMBER] is not null or [WPHONE_NUMBER] is not NULL then 1 ELSE 0 end) / cast(count(1) as decimal) [Telephone_Percentage]
,convert(datetime,dateadd(month,datediff(month,0,p.REG_DTTM),0),103) [Reg_Month]

FROM [HDM].[dbo].[DIM_PATIENT] p with(nolock)
WHERE  p.ARCHV_FLAG = 'N'
 and P.DIM_PATIENT_ID >0
 and p.MERGE_RECORD_ID is NULL
 and p.Surname <> 'Test-Patient'
 and p.REG_DTTM >= '01/04/2021'

 GROUP BY convert(datetime,dateadd(month,datediff(month,0,p.REG_DTTM),0),103) 














 