Select Status_Person_Conduct_Del
 ,CDS_HEADER_TYPE
 ,b.Description
,count(1)
FROM HDM_CDS.CDS.APC a
INNER JOIN HDM_Local.[CorpData].[CDS_TypeCodes] b on a.CDS_HEADER_TYPE = b.[CDSTypeCode]

WHERE CDS_HEADER_TYPE IN  ('120','140')

GROUP BY Status_Person_Conduct_Del
, CDS_HEADER_TYPE
 ,b.Description

 /****** Script for SelectTopNRows command from SSMS  ******/
SELECT 
      [Status_Person_Conduct_Del]
	  ,count(1) 
     
  FROM [HDM_CDS].[CDS].[APC_Births]

  GROUP BY [Status_Person_Conduct_Del]

 UPDATE HDM_CDS.CDS.APC 
 SET Status_Person_Conduct_Del = 9
 WHERE Status_Person_Conduct_Del IN ('')
 and CDS_HEADER_TYPE IN  ('120','140')


 UPDATE [HDM_CDS].[CDS].[APC_Births]
 SET [Status_Person_Conduct_Del] = 9 
 WHERE [Status_Person_Conduct_Del] IN ('')

