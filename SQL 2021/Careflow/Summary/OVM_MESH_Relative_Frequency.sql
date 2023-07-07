

select sum(case when [HO_STATUS_C_1] = '01' THEN 1 ELSE 0 END) [Paid]
,round(sum(case when [HO_STATUS_C_1] = '01' THEN 1 ELSE 0 END)/ convert(decimal,count(1)),2) [Paid Percentage]
	,sum(case when [HO_STATUS_C_1] = '02' THEN 1 ELSE 0 END) [Likely Chargable]
	,round(sum(case when [HO_STATUS_C_1] = '02' THEN 1 ELSE 0 END)/ convert(decimal,count(1)),2)[Likely Chargable Percentage]
	,sum(case when [HO_STATUS_C_1] = '03' THEN 1 ELSE 0 END) [Update: Patient has ILR]
	,round(sum(case when [HO_STATUS_C_1] = '03' THEN 1 ELSE 0 END)/ convert(decimal,count(1)),2) [Update: Patient has ILR Percentage]
	,sum(case when [HO_STATUS_C_1] IN ('') THEN 1 ELSE 0 END) [Check]
	,round(sum(case when [HO_STATUS_C_1] IN ('') THEN 1 ELSE 0 END)/ convert(decimal,count(1)),2) [Check Percentage]
	  ,count(1) [Total Number]
	  --,count(1)/ sum(count(1))
	   FROM (
  SELECT 
  a.[Import_ID] ,a.[Date_Imported],b.[Type],[RESPONSE_CODE],a.[NHS_NUMBER],[DATE_OF_BIRTH],[HO_STATUS_C_1],[HO_STATUS_1],[OVM_STATUS],[ALLOC_DATE]
      ,[SUPERSEDED_BY],[FAMILY_NAME],[GIVEN_NAME],[OTHER_NAME],[GENDER],[DATE_OF_DEATH],[ADDRESS_LINE1],[ADDRESS_LINE2]
	  ,[ADDRESS_LINE3],[ADDRESS_LINE4],[ADDRESS_LINE5],a.[POSTCODE],[ADD_BEF_DATE],[PHONE],[GP_PRACTICE_C],[GP_REG_DATE],[HO_STATUS_C_2],[HO_STATUS_2]
      ,[HO_END_DATE],[HO_REFERENCE],[HO_BRP],[HO_COUNTRY_C],[HO_COUNTRY],[OVM_STATUS_1],[OVM_SEEN_DATE],[OVM_COUNTRY_C]
      ,[OVM_COUNTRY],[OVM_DATE APPLIED],[EHIC_ID_NO],[EHIC_CARD_NO],[EHIC_EXP_DATE],[EHIC_INST_ID],[EHIC_COUNTRY_C],[EHIC_COUNTRY] ,[S1_STATUS_C]
      ,[S1_STATUS] ,[S2_COUNTRY_C],[S2_COUNTRY],[S2_FROM],[S2_TO],[PRC_ID_NO],[PRC_CARD_NO],[PRC_INST_ID],[PRC_EHIC_EXP_DATE],[PRC_COUNTRY_C],[PRC_COUNTRY],[PRC_FROM],[PRC_TO]

  ,row_number() over(partition by [NHS_NUMBER] order by [NHS_NUMBER], a.date_imported desc) as [dup] --displays most recent trace for duplicates via date imported 
  FROM [HDM_Local].[CorpData].[OVM_Returns_2] a
  Inner join [HDM_Local].[CorpData].[OVM_Audit_2] b on a.import_ID = b .Import_ID
  
  ) sub
  inner join [HDM].[dbo].[FACT_PATIENT_IDENTIFIER] pa with(nolock) on pa.[IDENTIFIER_RAW] = sub.[NHS_NUMBER] and DIM_LOOKUP_PATID_TYPE_ID IN (18,13) --Active and Unverified NHS nos
  inner join [HDM].[dbo].[DIM_Patient] p with(nolock) on p.DIM_Patient_id = pa.DIM_patient_ID 
  left join [HDM].[dbo].[FACT_PATIENT_ALERTS] pl with(nolock)  on pa.DIM_Patient_id = pl.DIM_PATIENT_ID and pl.DIM_CODE_ID = 47

WHERE (dup = 1 and HO_STATUS_C_1 <> ('') or (dup = 1 and OVM_Status <> (''))

or (dup = 1 and [EHIC_CARD_NO] <> (''))

or (dup = 1 and [S1_STATUS_C] <> (''))

 or (dup = 1 and [PRC_ID_NO] <> ('')))

 and pl.[END_DTTM] is null
 and p.[ARCHV_FLAG] = 'N'