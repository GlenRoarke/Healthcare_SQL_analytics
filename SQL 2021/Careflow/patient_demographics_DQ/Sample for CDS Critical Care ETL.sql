	 
--Server SVCBIDBPRDSQL\HDMSQL 
--example of CDS Critical Care data, it is not used in any reporting or contracting processes 
--For an SSIS routine i would take all of table b & c as a minimum
	 select [CDS_HEADER_UNIQUE_ID]
	 ,a.Local_Patient_Identifier
,a.Hosp_Provider_Spell_No
,a.EPISODE_START_DTTM
,a.EPISODE_END_DTTM
      ,b.[IP_CCP_EXTERNAL_ID]
      ,b.[IP_SPELL_ID]
	  ,b.CCP_Start_Date
	  ,b.CCP_Start_Date
      ,b.[CCP_Order]
      ,b.[CCP_Type]
      ,b.[CCP_Local_Identifier]
	  ,c.IP_CCP_ACTIVITY_EXTERNAL_ID
FROM HDM_cds.[CDS].[APC] a --Main APC CDS for link to PAS IDs etc
inner JOIN [HDM_CDS].[CDS].[APC_CCP] b on a.IP_EPI_EXT_ID = b.IP_EPISODE_External_ID --Critical Care periods
inner JOIN [HDM_CDS].[CDS].[APC_CCP_ACTS] c on  b.IP_CCP_EXTERNAL_ID = c.IP_CCP_EXTERNAL_ID --Critical Care activity


