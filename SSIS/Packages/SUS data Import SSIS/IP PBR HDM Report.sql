/****** Script for SelectTopNRows command from SSMS  ******/


--IP Report 
SELECT  a.[Local Patient Identifier]
,sp.DIM_PATIENT_ID
,a.[NHS Number]


,a.[GP Practice Code (Derived)] [GP_PracCodeSUS]
,a.[GP Practice Code (Original Data)] --This is an example of where SUS derivation works, Not much benefit in changing the dates.
,a.PracticeCCGs [GP CCG SUS]
,a.[GP Practice Derived from PDS]

,ghsp.HCO_MAIN_CODE
,gh.GP_PCTCODE [GP_History_CCG_PAS]

,spgp.HCO_MAIN_CODE [GP_PracCode_Spell_PAS]
,sp.GP_PCT [GP_CCG_Spell_PAS]  --GP practice date range doesn't fit in spell.



--the CCG of the Spell is not always what is the latest in the PMI
  FROM [HDM_Local].[CorpData].[Lookup_IP_PBR_CCGs] a
  inner join HDM.dbo.FACT_IP_SPELL sp with(nolock) on a.[Hospital Provider Spell No] = sp.IPSP_EXT_ID
  inner join HDM.dbo.DIM_PATIENT p with(nolock) on p.DIM_PATIENT_ID = sp.DIM_PATIENT_ID
  inner join HDM.dbo.FACT_PATIENT_GP_HISTORY gh on p.DIM_PATIENT_ID = gh.DIM_PATIENT_ID and gh.CLOSE_DTTM is null --Only brings back the active GP history
  inner join HDM.dbo.DIM_HC_ORGANISATION spgp on spgp.DIM_HCO_ID = sp.DIM_PRAC_ID 
  inner join HDM.dbo.DIM_HC_ORGANISATION ghsp on ghsp.DIM_HCO_ID = gh.DIM_HCO_ID
  WHERE 
  a.PracticeCCGs <> gh.GP_PCTCODE
  --and 
  --p.DIM_PATIENT_ID = 1522145

  
  select sum(a.[PbR Final Tariff])
  FROM [HDM_Local].[CorpData].[Lookup_IP_PBR_CCGs] a


  select top 1000 * from HDM.dbo.FACT_IP_SPELL
  select top 1000 * from HDM.dbo.DIM_PATIENT
  select top 1000 * from HDM.dbo.DIM_HC_ORGANISATION 
  select top 1000 * from hdm.dbo.FACT_PATIENT_GP_HISTORY gh
  --select count(1)  FROM [HDM_Local].[CorpData].[Lookup_IP_PBR_CCGs] a

  --truncate table   [HDM_Local].[CorpData].[Lookup_IP_PBR_CCGs]

  select c.FACT_PATIENT_GP_HISTORY_ID
  ,c.DIM_HCP_ID
  ,c.OPEN_DTTM
  ,c.CLOSE_DTTM
  ,c.GP_PCTCODE
  --select *
   from hdm.dbo.FACT_PATIENT_GP_HISTORY c
  where DIM_PATIENT_ID = 1522145