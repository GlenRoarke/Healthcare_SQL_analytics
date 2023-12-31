/****** Script for SelectTopNRows command from SSMS  ******/
SELECT  [PAS_ID]
      ,a.[HCO_NAME]
	  ,a.HCO_MAINCODE
	  ,c.[HCO_MAIN_CODE] [Branch]
	  ,a.MODIF_DTTM
     
  FROM [HDM].[dbo].[DIM_PATIENT] a
  INNER JOIN HDM.dbo.DIM_HC_ORGANISATION b with(nolock) on a.[HCO_NHSCODE] = b.HCO_NHS_CODE
  INNER JOIN  HDM.dbo.DIM_HC_ORGANISATION c with(nolock) on b.HCO_PARENT_HCO = c.DIM_HCO_ID

  WHERE a.[HCO_NAME] like '%vaccination%'
  
  
  
  --[HCO_NHSCODE] IN (SELECT HCO_NHS_CODE FROM HDM.dbo.DIM_HC_ORGANISATION b WHERE b.HCO_NAME like '%vaccination%')



  select * from HDM.dbo.DIM_HC_ORGANISATION a
 
  WHERE HCO_NHS_CODE IN (SELECT HCO_NHS_CODE FROM HDM.dbo.DIM_HC_ORGANISATION b WHERE b.HCO_NAME like '%vaccination%')
  
  SELECT HCO_NHS_CODE FROM HDM.dbo.DIM_HC_ORGANISATION b WHERE b.HCO_NAME like '%vaccination%'