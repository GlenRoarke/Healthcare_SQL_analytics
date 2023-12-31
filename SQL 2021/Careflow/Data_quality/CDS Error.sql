/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 [IP_DEL_ID]
      ,[IP_DEL_EXTERNAL_ID]
      ,a.[CREATE_DTTM]
      ,a.[MODIF_DTTM]
      ,a.[DIM_TRUST_ID]
      ,a.[DIM_LOAD_ID]
      ,a.[AUDIT_REFERENCE]
      ,a.[ARCHV_FLAG]
      ,[DELIV_COUNT]
      ,[IP_SPELL_ID]
      ,[IP_EPISODE_ID]
      ,[DIM_PATIENT_ID]
      ,[NUM_PPREG]
      ,[NUM_BABIES]
      ,[FIRST_ANTE_ASS_DATE]
      ,[FIRST_ANTE_ASS_DTTM]
      ,[DIM_RESP_GP_ID]
      ,[DIM_RESP_PRAC_ID]
      ,[EXP_CONF_DATE]
      ,[EXP_CONF_DTTM]
      ,[DIM_MATLMP_ID]
      ,[DIM_DELIVERYPLACEI_ID]
      ,[DIM_DELIVERYPLACEA_ID]
      ,[DIM_DELCHGRSN_ID]
      ,[NUM_PLIVE]
      ,[NUM_PSTILL]
      ,[NUM_PABOR]
      ,[NUM_PNEDE]
      ,[GEST_LEN]
      ,[DIM_LABON_ID]
      ,[LAB_LEN]
	  ,NHS_ID
	  ,b.description
      ,[DIM_SMOKE12_ID]
      ,[DIM_SMOKEBK_ID]
      ,[DIM_SMOKEDL_ID]
      ,[DIM_LABANAE_ID]
      ,[DIM_LABARSN_ID]
      ,[DIM_DELANAE_ID]
      ,[DIM_DELARSN_ID]
      ,[DIM_PSTANAE_ID]
      ,[DIM_PSTARSN_ID]
      ,[DELIV_DATE]
      ,[DELIV_DTTM]
      ,a.[HDM_MODIF_DTTM]
      ,[DIM_DELIBY_ID]
      ,[DIM_LOOKUP_ANTE_CARETYPE_ID]
      ,[PARITY]
      ,[IP_DEL_EXTERNAL_ID_OTHER]
      ,[CDS_ANON_REASON]
  FROM [HDM].[dbo].[FACT_IP_DELIVERIES] a
  inner join HDM.dbo.DIM_LOOKUP_DELONSET b with(nolock) on a.DIM_LABON_ID = b.DIM_LOOKUP_DELONSET_ID

  WHERE b.NHS_ID = 'XXXX'

  select * from HDM.dbo.DIM_LOOKUP_DELONSET



  select [DIM_LABON_ID]
	  ,NHS_ID
	  ,b.description
	  ,count(1)
    FROM [HDM].[dbo].[FACT_IP_DELIVERIES] a
  inner join HDM.dbo.DIM_LOOKUP_DELONSET b with(nolock) on a.DIM_LABON_ID = b.DIM_LOOKUP_DELONSET_ID


 -- WHERE  [DELIV_DTTM] between '01/05/2021 00:00:00' and '10/05/2021 00:00:00' 

  GROUP BY [DIM_LABON_ID]
	  ,NHS_ID
	  ,b.description

  ORDER BY [DELIV_DTTM] desc

  select  a.	LABON_ID	,'LABON_ID' Item	,b.NHS_ID ,b.[DESCRIPTION] ,a.*
from [HDM_Generic_Feeds].[dbo].[IP_Deliveries] a with (nolock) 
left join [HDM].[DBO].	DIM_LOOKUP_DELONSET	b with (nolock) on a.	LABON_ID	= b.EXTERNAL_ID
WHERE NHS_ID = 'XXXX'

ORDER BY Deliv_DTTM desc