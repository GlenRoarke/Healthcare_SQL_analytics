Select
    a.[DIM_LOOKUP_PATID_TYPE_ID]
	,convert(datetime,dateadd(month,datediff(month,0,a.[CREATE_DTTM]),0),103) [Month]
	  ,c.description
	  ,count(1) [Count]
    FROM [HDM].[dbo].[FACT_PATIENT_IDENTIFIER] a with(nolock)
  INNER JOIN hdm.dbo.DIM_LOOKUP_PATID_STATUS b with(nolock) on a.DIM_LOOKUP_PATID_STATUS_ID = b.DIM_LOOKUP_PATID_STATUS_ID
  INNER JOIN hdm.[dbo].[DIM_LOOKUP_PATID_TYPE] c with(nolock) on a.[DIM_LOOKUP_PATID_TYPE_ID] = c.[DIM_LOOKUP_PATID_TYPE_ID]
  INNER JOIN hdm..DIM_PATIENT p with(nolock) on p.dim_patient_id = a.dim_patient_id 
  WHERE a.[CREATE_DTTM] >= '01/04/2021 00:00:00'
  and a.[DIM_LOOKUP_PATID_TYPE_ID] IN (1,14,38) -- Hospital no, Symphony & badernet 
  and P.MERGE_RECORD_ID is null
and p.ARCHV_FLAG = 'N'
and p.Surname <> 'Test-Patient'
and P.DIM_PATIENT_ID >0

  group by   a.[DIM_LOOKUP_PATID_TYPE_ID]
  ,convert(datetime,dateadd(month,datediff(month,0,a.[CREATE_DTTM]),0),103) 
	  ,c.description



SELECT 
      [IDENTIFIER]
	  ,p.PAS_ID
      ,[IDENTIFIER_RAW]
      ,a.[DIM_LOOKUP_PATID_STATUS_ID]
	  ,convert(datetime,dateadd(month,datediff(month,0,a.[CREATE_DTTM]),0),103) [Month]
      ,[DIM_LOOKUP_PATID_STATUS_ID_PM]
      ,a.[DIM_LOOKUP_PATID_TYPE_ID]
	  ,c.description [ID Type]
   
  FROM [HDM].[dbo].[FACT_PATIENT_IDENTIFIER] a with(nolock)
  inner join hdm.dbo.DIM_LOOKUP_PATID_STATUS b with(nolock) 
  on a.DIM_LOOKUP_PATID_STATUS_ID = b.DIM_LOOKUP_PATID_STATUS_ID
  inner join hdm.[dbo].[DIM_LOOKUP_PATID_TYPE] c with(nolock) on a.[DIM_LOOKUP_PATID_TYPE_ID] = c.[DIM_LOOKUP_PATID_TYPE_ID]
  inner join hdm..DIM_PATIENT p with(nolock) on p.dim_patient_id = a.dim_patient_id 

    WHERE a.[CREATE_DTTM] >= '01/04/2021 00:00:00'
  and a.[DIM_LOOKUP_PATID_TYPE_ID] IN (1,14,38) -- Hospital no, Symphony & badernet 
  and P.MERGE_RECORD_ID is null
and p.ARCHV_FLAG = 'N'
and p.Surname <> 'Test-Patient'
and P.DIM_PATIENT_ID >0