
IF OBJECT_ID('tempdb.dbo.#GlenDup', 'U') IS NOT NULL
  DROP TABLE #GlenDup; 

SELECT 
substring([APPLIED_NOTE],22,10) [NHS_Number]
,Min(p.PAS_ID) [Patient_ID_1]
,Max(p.PAS_ID) [Patient_ID_2]

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

INTO #GlenDup
FROM [HDM].dbo.DIM_PATIENT p with(nolock)
  INNER JOIN [HDM].[dbo].[FACT_PATIENT_ALERTS] a with(nolock) on a.Dim_patient_id = p.Dim_patient_id
  INNER JOIN [HDM].[dbo].DIM_LOOKUP_ALERTCODE b with(nolock) on a.DIM_CODE_ID = b.DIM_LOOKUP_ALERTCODE_ID --Alert code description
  INNER JOIN  [HDM].[dbo].DIM_LOOKUP_ALERTTYPE c with(nolock) on a.DIM_TYPE_ID = c.DIM_LOOKUP_ALERTTYPE_ID --type of alert eg clerical admin
  left JOIN HDM_Local.main.CasenoteLocation d with(nolock) on p.DIM_PATIENT_ID = d.DIM_PATIENT_ID
 WHERE a.DIM_CODE_ID = 18 --Duplicate alert code 
 --and DIM_LOOKUP_DEATH_STATUS_ID = 6 --live patients
 and a.END_DTTM is null --exludes not dups when alerts endated YY
 and CasenoteLocation  is null
and a.CREATE_DTTM < '01/11/2018'
--
 
--This sub query excludes merged records-------------------------------------------------------------------------------------------------------------------------------------------
 and p.PAS_ID IN (SELECT p.[PAS_ID] FROM [HDM].dbo.DIM_PATIENT p with(nolock)
											INNER JOIN [HDM].[dbo].[FACT_PATIENT_ALERTS] a with(nolock) on a.Dim_patient_id = p.Dim_patient_id
											INNER JOIN [HDM].[dbo].DIM_LOOKUP_ALERTCODE b with(nolock) on a.DIM_CODE_ID = b.DIM_LOOKUP_ALERTCODE_ID --Alert code description
											INNER JOIN  [HDM].[dbo].DIM_LOOKUP_ALERTTYPE c with(nolock) on a.DIM_TYPE_ID = c.DIM_LOOKUP_ALERTTYPE_ID --type of alert eg clerical admin
											WHERE DIM_CODE_ID = 18--CodeID can change 
											and DIM_LOOKUP_DEATH_STATUS_ID = 6
											GROUP BY  p.[PAS_ID] 
											HAVING count(1) = 1)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


GROUP BY substring([APPLIED_NOTE],22,10)
,p.[HCO_MAINCODE]
having  Min(p.PAS_ID) <> MAX(p.PAS_ID)

--and substring([APPLIED_NOTE],22,10) is not null
Order by 1 desc


select top 200 a.NHS_Number
,Patient_ID_1
,Patient_ID_2
,p1.[HCO_MAINCODE]
,p2.[HCO_MAINCODE]
,p1.SURNAME
,P2.SURNAME
,P1.MPHONE_NUMBER
,P2.MPHONE_NUMBER
,P1.HPHONE_NUMBER
,P2.HPHONE_NUMBER
from #glendup a
inner join hdm.dbo.dim_patient p1 on Patient_ID_1 = p1.PAS_ID
inner join hdm.dbo.dim_patient p2 on Patient_ID_2 = p2.PAS_ID
--where  p1.[HCO_MAINCODE] = p2.[HCO_MAINCODE]
--and p1.POSTCODE = p2.POSTCODE
 --p1.Forename =  p2.Forename

