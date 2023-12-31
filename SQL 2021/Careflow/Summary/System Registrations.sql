/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 
      [IDENTIFIER]
	  ,p.PAS_ID
      ,[IDENTIFIER_RAW]
      ,a.[DIM_LOOKUP_PATID_STATUS_ID]
	  ,b.description 
      ,[DIM_LOOKUP_PATID_STATUS_ID_PM]
      ,a.[DIM_LOOKUP_PATID_TYPE_ID]
	  ,c.description
      ,a.[DIM_LOOKUP_NNNST_ID]
      ,a.[DIM_PATIENT_ID]
      ,a.[FACT_CURRENT_PATIENT_ID]
      ,a.[CREATE_DTTM]
      ,a.[START_DTTM]
  FROM [HDM].[dbo].[FACT_PATIENT_IDENTIFIER] a with(nolock)
  inner join hdm.dbo.DIM_LOOKUP_PATID_STATUS b with(nolock) 
  on a.DIM_LOOKUP_PATID_STATUS_ID = b.DIM_LOOKUP_PATID_STATUS_ID
  inner join hdm.[dbo].[DIM_LOOKUP_PATID_TYPE] c with(nolock) on a.[DIM_LOOKUP_PATID_TYPE_ID] = c.[DIM_LOOKUP_PATID_TYPE_ID]
  inner join hdm..DIM_PATIENT p with(nolock) on p.dim_patient_id = a.dim_patient_id 

  WHERE a.[DIM_LOOKUP_PATID_TYPE_ID] = 1

  ORDER BY p.PAS_ID asc


  Select
    a.[DIM_LOOKUP_PATID_TYPE_ID]
	,convert(datetime,dateadd(month,datediff(month,0,a.[CREATE_DTTM]),0),103) [Month]
	  ,c.description
	  ,count(1) [Count]
    FROM [HDM].[dbo].[FACT_PATIENT_IDENTIFIER] a with(nolock)
  inner join hdm.dbo.DIM_LOOKUP_PATID_STATUS b with(nolock) 
  on a.DIM_LOOKUP_PATID_STATUS_ID = b.DIM_LOOKUP_PATID_STATUS_ID
  inner join hdm.[dbo].[DIM_LOOKUP_PATID_TYPE] c with(nolock) 
  on a.[DIM_LOOKUP_PATID_TYPE_ID] = c.[DIM_LOOKUP_PATID_TYPE_ID]
    inner join hdm..DIM_PATIENT p with(nolock) on p.dim_patient_id = a.dim_patient_id 
  WHERE a.[CREATE_DTTM] >= '01/04/2021 00:00:00'
  and a.[DIM_LOOKUP_PATID_TYPE_ID] IN (1,14,38) -- Hospital no, Symphony & badernet 
  and P.MERGE_RECORD_ID is null
and p.ARCHV_FLAG = 'N'
and p.Surname <> 'Test-Patient'
and P.DIM_PATIENT_ID >0

  group by   a.[DIM_LOOKUP_PATID_TYPE_ID]
  --,convert(datetime,dateadd(month,datediff(month,0,a.[CREATE_DTTM]),0),103) 
	  ,c.description

	  IF OBJECT_ID('tempdb.dbo.#MergesTMP2', 'U') IS NOT NULL
  DROP TABLE #MergesTMP2; 

select MERGE_RECORD_ID into #MergesTMP2 from DIM_PATIENT dp2 with(nolock) where dp2.MERGE_RECORD_ID is not null

CREATE NONCLUSTERED INDEX ix_MergesTMP ON #MergesTMP2 (MERGE_RECORD_ID)

	    Select
    a.[DIM_LOOKUP_PATID_TYPE_ID]
	,convert(datetime,dateadd(month,datediff(month,0,a.[CREATE_DTTM]),0),103) [Month]
	  ,c.description
	  ,count(1) [Count]
	  --,sum(case when m.MERGE_RECORD_ID is not null then 1 ELSE 0 END) as [Merged]
    FROM [HDM].[dbo].[FACT_PATIENT_IDENTIFIER] a with(nolock)
  inner join hdm.dbo.DIM_LOOKUP_PATID_STATUS b with(nolock) 
  on a.DIM_LOOKUP_PATID_STATUS_ID = b.DIM_LOOKUP_PATID_STATUS_ID
  inner join hdm.[dbo].[DIM_LOOKUP_PATID_TYPE] c with(nolock) 
  on a.[DIM_LOOKUP_PATID_TYPE_ID] = c.[DIM_LOOKUP_PATID_TYPE_ID]
    inner join hdm..DIM_PATIENT p with(nolock) on p.dim_patient_id = a.dim_patient_id 
	--left join HDM.dbo.#MergesTMP2  m with(nolock) on m.MERGE_RECORD_ID = p.PAS_ID

  WHERE 
  
  p.REG_DTTM >= '01/04/2021 00:00:00'
and p.REG_DTTM <= '30/06/2021 23:59:59'
  and a.[DIM_LOOKUP_PATID_TYPE_ID] IN (1,14,38) -- Hospital no, Symphony & badernet 
  and P.MERGE_RECORD_ID is null
and p.ARCHV_FLAG = 'N'
and p.Surname <> 'Test-Patient'
and P.DIM_PATIENT_ID >0

  group by   a.[DIM_LOOKUP_PATID_TYPE_ID]
  ,convert(datetime,dateadd(month,datediff(month,0,a.[CREATE_DTTM]),0),103) 
	  ,c.description
	  --,sum(case when m.MERGE_RECORD_ID is not null then 1 ELSE 0 END)



IF OBJECT_ID('tempdb.dbo.#MergesTMP2', 'U') IS NOT NULL
  DROP TABLE #MergesTMP2; 

select MERGE_RECORD_ID into #MergesTMP2 from DIM_PATIENT dp2 with(nolock) where dp2.MERGE_RECORD_ID is not null

CREATE NONCLUSTERED INDEX ix_MergesTMP ON #MergesTMP2 (MERGE_RECORD_ID)


select * from #MergesTMP2


	  SELECT 
      [IDENTIFIER]
	  ,p.PAS_ID
      ,[IDENTIFIER_RAW]
      ,a.[DIM_LOOKUP_PATID_STATUS_ID]
	  ,convert(datetime,dateadd(month,datediff(month,0,a.[CREATE_DTTM]),0),103) [Month]
      ,[DIM_LOOKUP_PATID_STATUS_ID_PM]
      ,a.[DIM_LOOKUP_PATID_TYPE_ID]
	  ,c.description [ID Type]
	  ,m.Merge_Record_ID
   
  FROM [HDM].[dbo].[FACT_PATIENT_IDENTIFIER] a with(nolock)
  inner join hdm.dbo.DIM_LOOKUP_PATID_STATUS b with(nolock) 
  on a.DIM_LOOKUP_PATID_STATUS_ID = b.DIM_LOOKUP_PATID_STATUS_ID
  inner join hdm.[dbo].[DIM_LOOKUP_PATID_TYPE] c with(nolock) on a.[DIM_LOOKUP_PATID_TYPE_ID] = c.[DIM_LOOKUP_PATID_TYPE_ID]
  inner join hdm..DIM_PATIENT p with(nolock) on p.dim_patient_id = a.dim_patient_id
  left join HDM.dbo.#MergesTMP2  m with(nolock) on m.MERGE_RECORD_ID = p.PAS_ID --Removes merges

    WHERE a.[CREATE_DTTM] >= '01/04/2021 00:00:00'
  and a.[DIM_LOOKUP_PATID_TYPE_ID] IN (1,14,38) -- Hospital no, Symphony & badernet 
  and P.MERGE_RECORD_ID is null
and p.ARCHV_FLAG = 'N'
and p.Surname <> 'Test-Patient'
and P.DIM_PATIENT_ID >0
and m.Merge_Record_ID is not null