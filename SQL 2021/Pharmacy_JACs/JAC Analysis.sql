/******JACS MPI Analysis******/

     
 -- Active to inactive patients
 -- Does not seem to be death status
 Select COUNT(1) 
 ,a.status
  FROM DQ_Reporting.JAC.Patient_Basic a
 
  GROUP BY a.status

 --Records in PAS not in JAC
 --Ones checked are deceased or merged
 ----4593 records not deceased of 40,000 10%
 --Is there a deceased flag in JAC?
select [DIM_PATIENT_ID]
      ,a.[SURNAME]
      ,a.[FORENAME]
      ,[PAS_ID]
      ,[NHS_NUMBER]
      ,[NNNST_DESC5]
      ,[BIRTH_DTTM]
      ,[DEATH_DTTM]
	  ,case when [DEATH_DTTM] is null then 'Live' ELSE 'Deceased' END as [DeceasedFlag]
      ,[POSTCODE]
      ,[HCO_NHSCODE]
      ,[MERGE_RECORD_ID]
      ,[Date_Imported]
	  ,b.[patient_basic]
FROM DQ_Reporting.[dbo].[Careflow_dim_patient] a
left join DQ_Reporting.JAC.[Patient_Basic] b on a.PAS_ID = b.[hospital_no]

WHERE b.hospital_no is null
--and MERGE_RECORD_ID is null
--and DEATH_DTTM is null --4593 records not deceased

and a.Surname <> 'Test-Patient'
and a.Surname <> 'ERS Patient'
and a.DIM_PATIENT_ID <> -1
and a.MERGE_RECORD_ID is null

ORDER BY Death_DTTM desc


--Records in JAC but not in PAS.
--These are invalid formats and Legacy and Superceeded IDs
--Notes- Checked several 7 digit hospital numbers and the legacy IDs are primary in JACs
--K numbers are a valid legacy ID which were migrated into PAS
select [patient_basic]
      ,[lnkpid]
      ,[hospital_no]
	  ,len([hospital_no]) [Length_of_Hospital_No]
	  ,left([hospital_no],1) [Hospital_No_Start]
      ,a.[surname]
      ,a.[forenames]
      ,[def_costcentre]
      ,[status]
      ,[date_added]
      ,[date_amended]
      ,[nhs_no]
      ,[consultant]
	  ,b.DIM_Patient_ID

FROM  DQ_Reporting.JAC.[Patient_Basic] a
left join DQ_Reporting.[dbo].[Careflow_dim_patient] b on a.hospital_no = b.PAS_ID

WHERE b.PAS_ID is null
and b.Surname <> 'Test-Patient'
and b.Surname <> 'ERS Patient'
and b.DIM_PATIENT_ID <> -1
and b.MERGE_RECORD_ID is null


/****** PAS and JAC Match with different NHS Nos ******/



select [DIM_PATIENT_ID]
      ,a.[SURNAME]
      ,a.[FORENAME]
      ,[PAS_ID]
      ,[NHS_NUMBER]
	  ,replace([NHS_NUMBER],' ','') PAS_NHS_No
	  ,b.[nhs_no] [JAC_NHS_No]
      ,[NNNST_DESC5]
      ,[BIRTH_DTTM]
      ,[DEATH_DTTM]
	  ,case when [DEATH_DTTM] is null then 'Live' ELSE 'Deceased' END as [DeceasedFlag]
      ,[POSTCODE]
      ,[HCO_NHSCODE]
      ,[MERGE_RECORD_ID]
      ,[Date_Imported]
	  ,b.[patient_basic]
FROM DQ_Reporting.[dbo].[Careflow_dim_patient] a
inner join DQ_Reporting.JAC.[Patient_Basic] b on a.PAS_ID = b.[hospital_no]
WHERE replace([NHS_NUMBER],' ','')  <> b.[nhs_no]

and a.Surname <> 'Test-Patient'
and a.Surname <> 'ERS Patient'
and a.DIM_PATIENT_ID <> -1
and a.MERGE_RECORD_ID is null


/****** NHS number NOT NULL in PAS NULL in JAC ******/
--i think it is important for downstreams systems to have a reference list of what records had NHS numbers removed as this causes large differences in NHS Nos
--93141
select a.[DIM_PATIENT_ID]
      ,a.[SURNAME]
	  ,b.surname [surname_JAC]
      ,a.[FORENAME]
	  ,b.forenames [forenames_JAC]
      ,[PAS_ID]
      ,[NHS_NUMBER]
	  ,replace([NHS_NUMBER],' ','') PAS_NHS_No
	  ,b.[nhs_no] [JAC_NHS_No]
      ,[NNNST_DESC5]
      ,[BIRTH_DTTM]
      ,[DEATH_DTTM]
	  ,case when [DEATH_DTTM] is null then 'Live' ELSE 'Deceased' END as [DeceasedFlag]
      ,[Date_Imported]
	  ,b.[patient_basic]
	 -- ,c.DIM_CODE_ID
FROM DQ_Reporting.[dbo].[Careflow_dim_patient] a
inner join DQ_Reporting.JAC.[Patient_Basic] b on a.PAS_ID = b.[hospital_no]
--left join DQ_Reporting.[PAS].[FACT_PATIENT_ALERTS] c on c.DIM_Patient_ID = a.DIM_PATIENT_ID
WHERE a.[NHS_NUMBER] is not null and  b.[nhs_no] is null 
and a.Surname <> 'Test-Patient'
and a.Surname <> 'ERS Patient'
and a.DIM_PATIENT_ID <> -1
and a.MERGE_RECORD_ID is null
--and c.END_DTTM is null


/****** NHS number NOT NULL in JAC NULL in PAS******/
--there is a large proportion of NHS number miss match due to PAS DM removal of NHS No.
select a.[DIM_PATIENT_ID]
      ,a.[SURNAME]
	  ,b.surname [surname_JAC]
      ,a.[FORENAME]
	  ,b.forenames [forenames_JAC]
      ,[PAS_ID]
      ,[NHS_NUMBER]
	  ,replace([NHS_NUMBER],' ','') PAS_NHS_No
	  ,b.[nhs_no] [JAC_NHS_No]
      ,[NNNST_DESC5]
      ,[BIRTH_DTTM]
      ,[DEATH_DTTM]
	  ,case when [DEATH_DTTM] is null then 'Live' ELSE 'Deceased' END as [DeceasedFlag]
      ,[Date_Imported]
	  ,b.[patient_basic]
	  --,c.DIM_CODE_ID
FROM DQ_Reporting.[dbo].[Careflow_dim_patient] a
inner join DQ_Reporting.JAC.[Patient_Basic] b on a.PAS_ID = b.[hospital_no]
--left join DQ_Reporting.[PAS].[FACT_PATIENT_ALERTS] c on c.DIM_Patient_ID = a.DIM_PATIENT_ID
WHERE a.[NHS_NUMBER] is  null and  b.[nhs_no] is not null 
--and (c.DIM_CODE_ID <> 18 or c.DIM_CODE_ID is  null) --Not flagged as a duplicate in DM
--and c.END_DTTM is null -- only shows open alerts
and a.Surname <> 'Test-Patient'
and a.Surname <> 'ERS Patient'
and a.DIM_PATIENT_ID <> -1
and a.MERGE_RECORD_ID is null

ORDER BY 1 desc

/****** PAS and JAC Match NHS null in PAS no histroic duplicate flag ******/
--there is a large proportion of NHS number miss match due to PAS DM removal of NHS No.
select a.[DIM_PATIENT_ID]
      ,a.[SURNAME]
	  ,b.surname [surname_JAC]
      ,a.[FORENAME]
	  ,b.forenames [forenames_JAC]
      ,[PAS_ID]
      ,[NHS_NUMBER]
	  ,replace([NHS_NUMBER],' ','') PAS_NHS_No
	  ,b.[nhs_no] [JAC_NHS_No]
      ,[NNNST_DESC5]
      ,[BIRTH_DTTM]
      ,[DEATH_DTTM]
	  ,case when [DEATH_DTTM] is null then 'Live' ELSE 'Deceased' END as [DeceasedFlag]
      ,[Date_Imported]
	  ,b.[patient_basic]
	  ,c.DIM_CODE_ID
FROM DQ_Reporting.[dbo].[Careflow_dim_patient] a
inner join DQ_Reporting.JAC.[Patient_Basic] b on a.PAS_ID = b.[hospital_no]
left join DQ_Reporting.[PAS].[FACT_PATIENT_ALERTS] c on c.DIM_Patient_ID = a.DIM_PATIENT_ID
WHERE 
a.[NHS_NUMBER] is  null and  b.[nhs_no] is not null 
and MERGE_RECORD_ID is null
and c.DIM_CODE_ID <> 18 --Duplicate patient flag.
and c.END_DTTM is null
and a.Surname <> 'Test-Patient'
and a.Surname <> 'ERS Patient'
and a.DIM_PATIENT_ID <> -1
and a.MERGE_RECORD_ID is null




--Matches with PAS MPI
SELECT Count(1)
FROM DQ_Reporting.[dbo].[Careflow_dim_patient] a
inner join DQ_Reporting.JAC.[Patient_Basic] b on a.PAS_ID = b.[hospital_no]
and a.Surname <> 'Test-Patient'
and a.Surname <> 'ERS Patient'
and a.DIM_PATIENT_ID <> -1
and a.MERGE_RECORD_ID is null




--NHS number completeness
--70%
select case when nhs_no is null then 'NULL_NHS_No.' ELSE 'NHS_No' END [NHS_No]

, count(1) [Count]
FROM DQ_Reporting.[JAC].[Patient_Basic]

GROUP BY case when nhs_no is null then 'NULL_NHS_No.' ELSE 'NHS_No' END

--Total Jac
select count(1) FROM DQ_Reporting.[JAC].[Patient_Basic]

--WHERE b.hospital_no is null
--and MERGE_RECORD_ID is null
--and DEATH_DTTM is null --4593 records not deceased

ORDER BY Death_DTTM desc

--Hospital No duplication
select b.[hospital_no] 
,count(1) [Count]
FROM DQ_Reporting.JAC.[Patient_Basic] b 
WHERE b.[hospital_no] is not null 
GROUP BY b.[hospital_no] 
HAVING count(1) >1


--JAC NULL hospital Numbers
select * 
FROM DQ_Reporting.JAC.[Patient_Basic] b 
WHERE [hospital_no] is null



  --JAC MPI cross checked with PAS_IDs
  --shows you 
  select top 5 PERCENT a.DIM_PATIENT_ID
  ,a.[IDENTIFIER]
      ,[IDENTIFIER_RAW]
	   ,d.Description [ID_STATUS]
      ,a.[DIM_LOOKUP_PATID_TYPE_ID]
	  ,c.Description [ID_TYPE]
  ,[patient_basic]
      ,b.[lnkpid]
      ,[hospital_no]
      ,[surname]
      ,[forenames]
	  ,[birth_date]
      ,[date_added]
      ,[date_amended]
      ,[nhs_no]
      ,[consultant]
  FROM  [DQ_Reporting].[dbo].[FACT_PATIENT_IDENTIFIER] a
  inner join [DQ_Reporting].[JAC].[Patient_Basic] b on a.[IDENTIFIER_RAW] = b.hospital_no
  inner join [DQ_Reporting].[dbo].[DIM_LOOKUP_PATID_TYPE] c on c.[DIM_LOOKUP_PATID_TYPE_ID] = a.[DIM_LOOKUP_PATID_TYPE_ID]
  inner join [DQ_Reporting].dbo.[DIM_LOOKUP_PATID_STATUS] d on d.[DIM_LOOKUP_PATID_STATUS_ID] = a.[DIM_LOOKUP_PATID_STATUS_ID]
  inner join [DQ_Reporting].[JAC].[patient_demographics] e on e.[lnkpid] = b.[lnkpid]

  WHERE [birth_date] between '1992-08-01' and '1992-08-31'

  ORDER BY [birth_date] desc, [surname] desc
   



  --Summary of cross check between FACT_Patient_Identifier and Patient_Basic
   SELECT count(1)
  ,d.Description [ID_Status]
      ,a.[DIM_LOOKUP_PATID_TYPE_ID]
	  ,c.Description [ID_Type]
	  ,year(b.[date_amended]) [Year]
  FROM  [DQ_Reporting].[dbo].[FACT_PATIENT_IDENTIFIER] a
  inner join [DQ_Reporting].[JAC].[Patient_Basic] b on a.[IDENTIFIER_RAW] = b.hospital_no
  inner join [DQ_Reporting].[dbo].[DIM_LOOKUP_PATID_TYPE] c on c.[DIM_LOOKUP_PATID_TYPE_ID] = a.[DIM_LOOKUP_PATID_TYPE_ID]
  inner join [DQ_Reporting].dbo.[DIM_LOOKUP_PATID_STATUS] d on d.[DIM_LOOKUP_PATID_STATUS_ID] = a.[DIM_LOOKUP_PATID_STATUS_ID]

 --WHERE b.[date_amended] between '01/01/2020 00:00:00' and getdate()

  GROUP BY  d.Description 
      ,a.[DIM_LOOKUP_PATID_TYPE_ID]
	  ,c.Description 
	  ,year(b.[date_amended])

 ORDER BY  year(b.[date_amended]) desc


    select case when PT.MERGE_RECORD_ID  is null then PT.PAS_id else PT.MERGE_RECORD_ID end Master_ID
,PTI.IDENTIFIER_RAW Other_ID
,PIT.DESCRIPTION Type
,Case when PTIS.DESCRIPTION = 'Master' and PT.MERGE_RECORD_ID  is null then 'Master' else 'Secondary' end Status
,PTI.START_DTTM
from HDM.dbo.DIM_PATIENT PT with(nolock)
inner join HDM.dbo.FACT_PATIENT_IDENTIFIER PTI with(nolock)
on PTI.DIM_PATIENT_ID = PT.DIM_PATIENT_ID
inner join HDM.dbo.DIM_LOOKUP_PATID_STATUS PTIS with(nolock)
on PTIS.DIM_LOOKUP_PATID_STATUS_ID = PTI.DIM_LOOKUP_PATID_STATUS_ID
inner join HDM.dbo.DIM_LOOKUP_PATID_STATUS PTISPM with(nolock)
on PTISPM.DIM_LOOKUP_PATID_STATUS_ID = PTI.DIM_LOOKUP_PATID_STATUS_ID_PM
inner join HDM.dbo.DIM_LOOKUP_PATID_TYPE PIT with(nolock)
on PIT.DIM_LOOKUP_PATID_TYPE_ID = PTI.DIM_LOOKUP_PATID_TYPE_ID
where PT.ARCHV_FLAG = 'N' and PT.DIM_PATIENT_ID > 0

ORDER BY 1 desc
 
 Select count(1)
 ,PIT.DESCRIPTION Type
FROM HDM.dbo.FACT_PATIENT_IDENTIFIER
inner join HDM.dbo.DIM_LOOKUP_PATID_TYPE PIT with(nolock)
on PIT.DIM_LOOKUP_PATID_TYPE_ID = PTI.DIM_LOOKUP_PATID_TYPE_ID

GROUP BY PIT.DESCRIPTION Type order by 2 desc
  


Select max(LEN(forenames)) FROM DQ_Reporting.[JAC].[Patient_Basic] ORDER BY 1 desc

and len(a.hospital_no) <> 7 --These are invalid formats of PAS_ID

ORDER BY  date_added desc

[JAC].[Patient_Basic]

--This appears to all be legacy IDs. Check against DIM_Patient_ID
select a.* FROM  [JAC MPI1SQL].[dbo].[JAC_patient_basic] a
left join [JAC MPI1SQL].[dbo].[Careflow_dim_patient] b on a.hospital_no = b.PAS_ID

WHERE b.PAS_ID is null
and len(a.hospital_no) = 7 --These are invalid formats of PAS_ID

ORDER BY  date_added desc


SELECT b.* FROM  [JAC MPI1SQL].[dbo].[JAC_patient_basic] b
WHERE hospital_no = '2466630'
 
 /****** Script for SelectTopNRows command from SSMS  ******/
SELECT  [patient_basic]
      ,[lnkpid]
      ,[hospital_no]
	  ,len([hospital_no])
	  ,left([hospital_no],1) [1st_Digit_Hosp]
      ,[surname]
      ,[forenames]
      ,[def_costcentre]
      ,[status]
      ,[date_added]
      ,[date_amended]
      ,[nhs_no]
      ,[consultant]
  FROM [JAC MPI1SQL].[dbo].[JAC_patient_basic]
  WHERE len([hospital_no]) <> 7

  or left([hospital_no],1) NOT IN ('1','2','3','4')

  ORDER BY [date_added] desc


  SELECT len([hospital_no])
  ,count(1)
    FROM [JAC MPI1SQL].[dbo].[JAC_patient_basic]
-- WHERE len([hospital_no]) <> 7
  GROUP BY len([hospital_no])
  ORDER BY 1 desc