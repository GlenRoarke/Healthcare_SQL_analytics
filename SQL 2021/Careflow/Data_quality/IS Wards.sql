Select DIM_SSU_ID, SSU_MAIN_CODE, SSU_NAME, *
from HDM.dbo.DIM_SITE_SERVICE_UNIT
where SSU_NAME  like  '%(ISP)%'


Step 2: then, we would add a code to CDS management to use information from this table. Something like 

update A.[HDM_CDS].[CDS].[APC]
set A.[Site_Code_of_Treatment_EpiEnd] = B.ODS_Site_Code
from [HDM_CDS].[CDS].[APC] A 
    inner [HDM_Local].[Contracting].[ISP_Site_Codes] B -- new table to create
              on A.[Ward_Code_EpiEnd] = B.Ward_Code

--This way we wouldn’t need to make changes to the CDS script at all when new ISPs are created and added to the master table e.g. [HDM_Local].[Contracting].[ISP_Site_Codes]


select 
Ward_Code_EpiStart
,Ward_Code_EpiEnd
,Site_Code_of_Treatment_EpiEnd
,Ward_Code_EpiStart
,b.SSU_NAME

,count(1) [Activity]
 FROM HDM_CDS.CDS.APC a
 INNER JOIN HDM.dbo.DIM_SITE_SERVICE_UNIT b on a.Ward_Code_EpiEnd = b.SSU_MAIN_CODE

 WHERE Ward_Code_EpiEnd IN  ( Select SSU_MAIN_CODE from HDM.dbo.DIM_SITE_SERVICE_UNIT where SSU_NAME  like  '%(ISP)%')
 and Epi_End_Date >= '01/04/2022'

 GROUP BY Ward_Code_EpiStart
,Ward_Code_EpiEnd
,Site_Code_of_Treatment_EpiEnd
,Ward_Code_EpiStart
,b.SSU_NAME

ORDER BY 6 desc


SELECT DIM_HCO_ID, HCO_MAIN_CODE, HCO_NAME ,HCO_ACTIVE_FLAG 
FROM DIM_HC_ORGANISATION WHERE HCO_NHS_CODE IN ('A5M4L','O4F7H','A1R7Z','B9S0X','J0W1P','O6E9T','O6E9T','L3N4Q','I1F1U')

select Local_Patient_Identifier, Hosp_Provider_Spell_No, Epi_Start_Date, Epi_End_Date
 FROM HDM_CDS.CDS.APC a
 INNER JOIN HDM.dbo.DIM_SITE_SERVICE_UNIT b on a.Ward_Code_EpiEnd = b.SSU_MAIN_CODE

 WHERE Ward_Code_EpiEnd IN  ( Select SSU_MAIN_CODE from HDM.dbo.DIM_SITE_SERVICE_UNIT where SSU_NAME  like  '%(ISP)%')
 --and Ward_Code_EpiEnd = 'GHH'

 ORDER BY Epi_End_Date desc

 New ODS	New ODS Description
A5M4L	LISTER HOSPITAL
O4F7H	THE MONTEFIORE HOSPITAL
A1R7Z	SUSSEX NUFFIELD HOSPITAL (brighton nuffield)
B9S0X	ASHDOWN NUFFIELD HOSPITAL (haywards heath nuffield)
J0W1P	THE PRINCESS GRACE HOSPITAL
O6E9T	SpaMedica Brighton
O6E9T	SpaMedica Brighton
L3N4Q	CROMWELL HOSPITAL
I1F1U	SPIRE TUNBRIDGE WELLS HOSPITAL



--Updates IS sites to correct national site code via ward code epi end 
 UPDATE [HDM_CDS].[CDS].[APC] SET [Site_Code_of_Treatment_EpiEnd] = 'O4F7H' where Ward_Code_EpiEnd = 'MONTW'
 UPDATE [HDM_CDS].[CDS].[APC] SET [Site_Code_of_Treatment_EpiEnd] = 'B9S0X' where Ward_Code_EpiEnd = 'ASH'
 UPDATE [HDM_CDS].[CDS].[APC] SET [Site_Code_of_Treatment_EpiEnd] = 'A1R7Z' where Ward_Code_EpiEnd = 'NUFFB'
 UPDATE [HDM_CDS].[CDS].[APC] SET [Site_Code_of_Treatment_EpiEnd] = 'O6E9T' where Ward_Code_EpiEnd = 'SEHSPAM'
 UPDATE [HDM_CDS].[CDS].[APC] SET [Site_Code_of_Treatment_EpiEnd] = 'A5M4L' where Ward_Code_EpiEnd = 'LIST'
 UPDATE [HDM_CDS].[CDS].[APC] SET [Site_Code_of_Treatment_EpiEnd] = 'J0W1P' where Ward_Code_EpiEnd = 'PGHLISP'
 UPDATE [HDM_CDS].[CDS].[APC] SET [Site_Code_of_Treatment_EpiEnd] = 'L3N4Q' where Ward_Code_EpiEnd = 'CROM'
 --UPDATE [HDM_CDS].[CDS].[APC] SET [Site_Code_of_Treatment_EpiEnd] = 'Reg needed' where Ward_Code_EpiEnd = 'WELLLND'
 

 --Reg Pending 
-- A5M4L
--J0W1P
--L3N4Q
--I1F1U

 

 
 --UPDATE [HDM_CDS].[CDS].[APC] SET [Site_Code_of_Treatment_EpiEnd] = 'A1R7Z' where Ward_Code_EpiEnd = 'WELLLND'
 
 x MONTW
x ASH
 xNUFFB
x SEHSPAM
WELLLND -- Reg pending 
LIST x
CROM
PGHLISP
SPIRETW


-- Updates Treatment Site Code in CDS for IS activity -07/04/2022 YY
UPDATE [HDM_CDS].[CDS].[APC] SET [Site_Code_of_Treatment_EpiEnd] = 'NW603' WHERE [Provider_Reference_Number]  = 'NW603'
UPDATE [HDM_CDS].[CDS].[APC] SET [Site_Code_of_Treatment_EpiEnd] = 'NT364' WHERE [Provider_Reference_Number]  = 'NT364'
UPDATE [HDM_CDS].[CDS].[APC] SET [Site_Code_of_Treatment_EpiEnd] = 'NT205' WHERE [Provider_Reference_Number]  = 'NT205'
UPDATE [HDM_CDS].[CDS].[APC] SET [Site_Code_of_Treatment_EpiEnd] = 'NT218' WHERE [Provider_Reference_Number]  = 'NT218'
UPDATE [HDM_CDS].[CDS].[APC] SET [Site_Code_of_Treatment_EpiEnd] = 'NW601' WHERE [Provider_Reference_Number]  = 'NW601'
UPDATE [HDM_CDS].[CDS].[APC] SET [Site_Code_of_Treatment_EpiEnd] = 'I9A4A' WHERE [Provider_Reference_Number]  = 'I9A4A'
UPDATE [HDM_CDS].[CDS].[APC] SET [Site_Code_of_Treatment_EpiEnd] = 'NV7R1' WHERE [Provider_Reference_Number]  = 'NV7R1'
UPDATE [HDM_CDS].[CDS].[APC] SET [Site_Code_of_Treatment_EpiEnd] = 'NT310' WHERE [Provider_Reference_Number]  = 'NT310'