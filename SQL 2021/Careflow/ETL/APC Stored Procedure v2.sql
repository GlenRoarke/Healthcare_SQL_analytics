USE [HDM_Local]
GO

/****** Object:  StoredProcedure [CorpCDS].[usp_APC_CDS_Stored_Procedure]    Script Date: 15/04/2021 14:55:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





--============================================
-- Object: IP CDS Stored Procedure
-- Purpose:  Apply DQ rules on CDS extracts
-- Created by: Glen Roarke
-- Date: 15/08/2018
-- Revisions:	15/08/2018 - RF - Tidied SQL Syntax to work across databases
--				08/11/2018 - GR - Amended SET to change unknowns to 09D 
--                       - GR - update unknown ORGANISATION_CODE_COMMISSIONER with CDS_HEADER_PRIME_RECIPIENT_IDENTITY value
--                       - GR - remove unknown values
--				03/09/2018 - YY - Remove 'Unknown' value in GP_Antenatal
--				03/09/2018 - YY - Remove 'Unknown' value in Prac_Antenatal
--				16/11/2018 - GR - Excludes unsequenced procedure codes
--				04/04/2019 - YY - Remove ready for discharge date as per Claire's request
--				05/04/2019 - AMP - Removes second code which was causing error
--				22/05/2019 - GR - Updates RTT records without WaitingList type of 01
--				12/06/2019 - YY - Updates Ethnicity to a default 99 value
--				23/07/2019 - GR - Updates Critical Care period with missing discharge dates
--				05/03/2020 - JB - Excludes where Secondary Diagnosis Codes are 3 digits
--				11/05/2020 - JB - Updates Intensity of Care Code, Sex and Age of Intensive Care Episode Start and End to blank, instead of 'X' or 'XX'
--				10/06/2020 - GR - Deletes from main CCP table
--				10/06/2020 - GR - Delete from secondary CCP table that creates delimiters
--                              - Updates unknown consultants to generic code
--				13/11/2020 - JB - Updates CC Neonatal Gest Length to default when 0
--				09/04/2021 - GR - Excludes where Secondary Diagnosis Codes are missing
--				09/04/2021 - GR - Updates organisation code of provide to RXH from RXH00
--				13/04/2021 - GR - Removes additional diagnois when Primary is null
--	            15/04/2021 - GR - Added in insert to monitor APC changed to data via SP

--=============================================

ALTER PROCEDURE [CorpCDS].[usp_APC_CDS_Stored_Procedure] AS

--deletes temp table if process is run in quick succession
if object_id('tempdb..#CDSRowCount_CorpData') is not null
drop table #CDSRowCount_CorpData


---Commissioning Updates-----------------------
			--*****MUST be first******
UPDATE [HDM_CDS].[CDS].[APC]
SET CDS_HEADER_PRIME_RECIPIENT_IDENTITY = '09X'
WHERE [ORGANISATION_CODE_COMMISSIONER] = 'Unknow' or [ORGANISATION_CODE_COMMISSIONER] = '' or [ORGANISATION_CODE_COMMISSIONER] is null
and Site_Code_of_Treatment_EpiEnd IN ('RXH28','8CD52','5P611','R9998','RXH30','RXH10','NTY32','RXH20','RXH56','RW849','5P620','RXH09','RXH39','RXH60')

UPDATE [HDM_CDS].[CDS].[APC]
SET CDS_HEADER_PRIME_RECIPIENT_IDENTITY = '09D'
WHERE [ORGANISATION_CODE_COMMISSIONER] = 'Unknow' or [ORGANISATION_CODE_COMMISSIONER] = '' or [ORGANISATION_CODE_COMMISSIONER] is null
and Site_Code_of_Treatment_EpiEnd NOT IN ('RXH28','8CD52','5P611','R9998','RXH30','RXH10','NTY32','RXH20','RXH56','RW849','5P620','RXH09','RXH39','RXH60')

-- remove unknown value from CDS_HEADER_COPY_RECIPIENT_IDENTITY 
-- 15/08/2018 - RF - Tidied SQL Syntax to work across databases
-- 08/11/2018 - GR  - Amended SET to change unknowns to 09D
-- Specify the database name as the SPROC will be in a different DB to the data tables
UPDATE [HDM_CDS].[CDS].[APC]
--UPDATE [CDS].[APC]
--SET CDS_HEADER_COPY_RECIPIENT_IDENTITY = '09D'
SET CDS_HEADER_COPY_RECIPIENT_IDENTITY = ''
WHERE CDS_HEADER_COPY_RECIPIENT_IDENTITY = 'Unkno'

-- update unknown ORGANISATION_CODE_COMMISSIONER with CDS_HEADER_PRIME_RECIPIENT_IDENTITY value 
-- 15/08/2018 - RF - Tidied SQL Syntax to work across databases
-- Specify the database name as the SPROC will be in a different DB to the data tables
UPDATE [HDM_CDS].[CDS].[APC]
--UPDATE [CDS].[APC]
SET ORGANISATION_CODE_COMMISSIONER = CDS_HEADER_PRIME_RECIPIENT_IDENTITY
WHERE ORGANISATION_CODE_COMMISSIONER = 'Unknow' or ORGANISATION_CODE_COMMISSIONER = '' or ORGANISATION_CODE_COMMISSIONER is null

------- New Updates GR -----------------------------------------------
--Remove unknown value
UPDATE [HDM_CDS].[CDS].[APC]
SET Commissioning_Serial_Number = ''
WHERE Commissioning_Serial_Number = 'Unkno='

UPDATE [HDM_CDS].[CDS].[APC]
SET NHS_Service_Agreement_Line_No = ''
WHERE NHS_Service_Agreement_Line_No = 'Unknown'

UPDATE [HDM_CDS].[CDS].[APC]
SET Commissioner_Reference_Number = ''
WHERE Commissioner_Reference_Number = 'Unknown'

---Other Updates--------------------------------------
--Remove 'Unknown' value in GP_Antenatal  --03/09/2018 - YY
UPDATE HDM_CDS.CDS.APC
SET GP_Antenatal = GP_Specified 
WHERE GP_Antenatal = 'Unknown'

--Remove 'Unknow' value in  Prac_Antenatal --03/09/2018 - YY
UPDATE HDM_CDS.CDS.APC
SET Prac_Antenatal  = GMP_Registration 
WHERE Prac_Antenatal  = 'Unknow'

--Excludes unsequenced procedure codes- 16/11/2018 GR
UPDATE HDM_CDS.CDS.APC
SET EXCLUDE_FROM_CDS = 1
WHERE Primary_Proc_OPCS IN ('') and Sec_Proc_1_OPCS NOT IN ('')
or(Sec_Proc_1_OPCS IN ('') and Sec_Proc_2_OPCS NOT IN ('') )
or(Sec_Proc_2_OPCS IN ('') and Sec_Proc_3_OPCS NOT IN ('') )
or(Sec_Proc_3_OPCS IN ('') and Sec_Proc_4_OPCS NOT IN ('') )
or(Sec_Proc_4_OPCS IN ('') and Sec_Proc_5_OPCS NOT IN ('') )
or(Sec_Proc_5_OPCS IN ('') and Sec_Proc_6_OPCS NOT IN ('') )
or(Sec_Proc_6_OPCS IN ('') and Sec_Proc_7_OPCS NOT IN ('') )
or(Sec_Proc_7_OPCS IN ('') and Sec_Proc_8_OPCS NOT IN ('') )
or(Sec_Proc_8_OPCS IN ('') and Sec_Proc_9_OPCS NOT IN ('') )
or(Sec_Proc_9_OPCS IN ('') and Sec_Proc_10_OPCS NOT IN ('') )
or(Sec_Proc_10_OPCS IN ('') and Sec_Proc_11_OPCS NOT IN ('') )
or(Sec_Proc_11_OPCS IN ('') and Sec_Proc_12_OPCS NOT IN ('') )
or(Sec_Proc_12_OPCS IN ('') and Sec_Proc_13_OPCS NOT IN ('') )
or(Sec_Proc_13_OPCS IN ('') and Sec_Proc_14_OPCS NOT IN ('') )
or(Sec_Proc_14_OPCS IN ('') and Sec_Proc_15_OPCS NOT IN ('') )
or(Sec_Proc_15_OPCS IN ('') and Sec_Proc_16_OPCS NOT IN ('') )
or(Sec_Proc_16_OPCS IN ('') and Sec_Proc_17_OPCS NOT IN ('') )
or(Sec_Proc_17_OPCS IN ('') and Sec_Proc_18_OPCS NOT IN ('') )
or(Sec_Proc_18_OPCS IN ('') and Sec_Proc_19_OPCS NOT IN ('') )
or(Sec_Proc_19_OPCS IN ('') and Sec_Proc_20_OPCS NOT IN ('') )
or(Sec_Proc_20_OPCS IN ('') and Sec_Proc_21_OPCS NOT IN ('') )
or(Sec_Proc_21_OPCS IN ('') and Sec_Proc_22_OPCS NOT IN ('') )
or(Sec_Proc_22_OPCS IN ('') and Sec_Proc_23_OPCS NOT IN ('') )
or(Sec_Proc_23_OPCS IN ('') and Sec_Proc_24_OPCS NOT IN ('') )
or(Sec_Proc_24_OPCS IN ('') and Sec_Proc_25_OPCS NOT IN ('') )


if object_id('tempdb..#CDSRowCount_CorpData') is not null
drop table #CDSRowCount_CorpData

		select getdate() [CreatedDate] 
		,@@rowcount [RowsChanged]
		, 'IP' [CDS_Type]
		, 'Excludes unsequenced procedure codes' into #CDSRowCount_CorpData


	INSERT INTO [CorpCDS].[Stored_Procedure_RecordChanges]
           ([CreatedDate]
           ,[RowsChanged]
           ,[CDS_Type]
		   ,[Error_Desc] )
		Select [CreatedDate], [RowsChanged],[CDS_Type],[Error_Desc] from #CDSRowCount_CorpData

--Remove ready for discharge date as per Claire's request - 04/04/2019 YY
UPDATE HDM_CDS.CDS.APC
SET [Disch_Ready_Date]  = null 
WHERE [Disch_Ready_Date] is not null

--Removes second code which was causing error - 05/04/2019 AMP
UPDATE HDM_CDS.[CDS].[APC] 
SET [CDS_HEADER_COPY_RECIPIENT_2_IDENTITY] = null
WHERE [CDS_HEADER_PRIME_RECIPIENT_IDENTITY] = '09D'
AND [CDS_HEADER_COPY_RECIPIENT_2_IDENTITY] = '09D'

--Updates RTT records with out WaitingList type of 01 -22/05/2019 GR
update [HDM_CDS].[CDS].[APC]
SET Waiting_Measurement_Type = '01'
WHERE (Waiting_Measurement_Type is null or Waiting_Measurement_Type IN (''))
and Patient_Pathway_ID  NOT IN ('')

-- Updates Ethnicity to a default 99 value -12/06/2019 YY
update [HDM_CDS].[CDS].[APC]
SET [Ethnic_Category] = '99'
WHERE [Ethnic_Category] not in ('A','B','C','D','E','F','G','H','J','K','L','M','N','P','R','S','Z','99')

--Updates Critical Care period with missing discharge dates 23/07/2019 GR
 update cp
 SET cp.CCP_Disch_Date = convert(date,a.CC_DISCHARGE_DTTM,103)
 ,cp.CCP_Disch_Time = convert(varchar,convert(time,a.CC_DISCHARGE_DTTM,108),8)
   from  [HDM].[dbo].[FACT_IP_CCP_EVENTS] a
  inner join hdm.dbo.DIM_PATIENT p on p.DIM_PATIENT_ID = a.DIM_PATIENT_ID
  inner join HDM_CDS.CDS.APC_CCP cp on cp.IP_CCP_EXTERNAL_ID = a.IP_CCP_EXTERNAL_ID
  inner join HDM_cds.[CDS].[APC] cds on  cds.IP_EPI_EXT_ID = cp.IP_EPISODE_External_ID

 where (CC_DISCHARGE_DTTM is not null or CC_DISCHARGE_DTTM NOT IN (''))
 and (cp.CCP_Disch_Date IN ('') or cp.CCP_Disch_Date  is null)
 and CDS_OUTPUT = 0 --Only update records that havent been outputed before as there is historic data

 --Excludes where Secondary Diagnosis Codes are 3 digits 05/03/2020 JB 
 update HDM_CDS.CDS.APC
 SET EXCLUDE_FROM_CDS = 1
 WHERE LEN(Sec_Diag_1_ICD) = 3 
or LEN(Sec_Diag_2_ICD) = 3
or LEN(Sec_Diag_2_ICD) = 3
or LEN(Sec_Diag_3_ICD) = 3
or LEN(Sec_Diag_4_ICD) = 3
or LEN(Sec_Diag_5_ICD) = 3
or LEN(Sec_Diag_6_ICD) = 3
or LEN(Sec_Diag_7_ICD) = 3
or LEN(Sec_Diag_8_ICD) = 3
or LEN(Sec_Diag_9_ICD) = 3
or LEN(Sec_Diag_10_ICD) = 3
or LEN(Sec_Diag_11_ICD) = 3
or LEN(Sec_Diag_12_ICD) = 3
or LEN(Sec_Diag_13_ICD) = 3
or LEN(Sec_Diag_14_ICD) = 3
or LEN(Sec_Diag_15_ICD) = 3
or LEN(Sec_Diag_16_ICD) = 3
or LEN(Sec_Diag_17_ICD) = 3
or LEN(Sec_Diag_18_ICD) = 3
or LEN(Sec_Diag_19_ICD) = 3
or LEN(Sec_Diag_20_ICD) = 3
or LEN(Sec_Diag_21_ICD) = 3
or LEN(Sec_Diag_22_ICD) = 3
or LEN(Sec_Diag_23_ICD) = 3
or LEN(Sec_Diag_24_ICD) = 3
or LEN(Sec_Diag_25_ICD) = 3

go

if object_id('tempdb..#CDSRowCount_CorpData') is not null
drop table #CDSRowCount_CorpData

		select getdate() [CreatedDate] 
		,@@rowcount [RowsChanged]
		, 'IP' [CDS_Type]
		, 'Excludes where Secondary Diagnosis Codes are 3 digits'[Error_Desc] into #CDSRowCount_CorpData


	INSERT INTO [CorpCDS].[Stored_Procedure_RecordChanges]
           ([CreatedDate]
           ,[RowsChanged]
           ,[CDS_Type]
		   ,[Error_Desc] )
		Select [CreatedDate], [RowsChanged],[CDS_Type],[Error_Desc] from #CDSRowCount_CorpData


--Updates Intensity of Care Code, Sex and Age of Intensive Care Episode Start and End to blank, instead of 'X' or 'XX' 11/05/2020 JB
Update [HDM_CDS].[CDS].[APC] 
set Inten_Clin_Care_Inten_EpiStart = '12'
where Inten_Clin_Care_Inten_EpiStart = 'XX'

Update [HDM_CDS].[CDS].[APC] 
set Inten_Clin_Care_Inten_EpiEnd = '12'
where Inten_Clin_Care_Inten_EpiEnd = 'XX'

Update [HDM_CDS].[CDS].[APC]
set Age_Group_Inten_EpiStart = '8'
where Age_Group_Inten_EpiStart = 'X'

Update [HDM_CDS].[CDS].[APC]
set Age_Group_Inten_EpiEnd = '8'
where Age_Group_Inten_EpiEnd = 'X'

Update [HDM_CDS].[CDS].[APC]
set Sex_of_Patient_EpiStart = '8'
where Sex_of_Patient_EpiStart = 'X'

Update [HDM_CDS].[CDS].[APC]
set Sex_of_Patient_EpiEnd = '8'
where Sex_of_Patient_EpiEnd = 'X'

Update [HDM_CDS].[CDS].[APC_WStay]
set [Inten_Clin_Care_Inten_WStay] = '12'
where [Inten_Clin_Care_Inten_WStay] ='XX' 

Update [HDM_CDS].[CDS].[APC_WStay]
set [Age_Group_Inten_WStay] = '8'
where [Age_Group_Inten_WStay] ='X' 

Update [HDM_CDS].[CDS].[APC_WStay]
set [Sex_of_Patient_WStay] = '8'
where [Sex_of_Patient_WStay] ='X'

--Deletes from main CCP table 10/06/2020 GR
DELETE b
FROM [HDM_CDS].[CDS].[APC_CCP] b
inner JOIN [HDM_CDS].[CDS].[APC_CCP_ACTS] c on  b.IP_CCP_EXTERNAL_ID = c.IP_CCP_EXTERNAL_ID
where b.IP_CCP_EVENT_ID IN  (8250,8131,8130,8596,8618,8645,8575,9264,8616
,10139,10132,9498,9649,10719,9826,10842,11433,11390,11029,12070,12107,11720
,10512,10511,12559,12107
-- IUVO Errors
,14057,16348,16064 -- GR 08/04/2020
)

--Delete from secondary CCP table that creates delimiters. 10/06/2020 GR
DELETE c
FROM  [HDM_CDS].[CDS].[APC_CCP_ACTS] c 
where c.IP_CCP_EVENT_ID IN (8250,8131,8130,8596,8618,8645,8575,9264,8616
,10139,10132,9498,9649,10719,9826,10842,11433,11390,11029,12070,12107,11720,10512,10511,12559,12107
-- IUVO Errors
,14057,16348,16064
) --Iuvo addition GR


--Updates unknown consultants to generic code
UPDATE [HDM_CDS].[CDS].[APC] 
SET Consultant_Code = 'C9999998'
WHERE Consultant_Code = 'unknown'


--Updates CC Neonatal Gest Length to default when 0 13/11/2020 JB
UPDATE [HDM_CDS].[CDS].[APC_CCP]
SET [CCP_NEO_Gest_Len] = '99'
WHERE [CCP_NEO_Gest_Len] = '0'

--excludes unsequenced diagnosis codes
UPDATE HDM_CDS.CDS.APC
SET EXCLUDE_FROM_CDS = 1
WHERE Primary_Diag_ICD IN ('') and Sec_Diag_1_ICD not in ('')
or Sec_Diag_1_ICD IN ('') and Sec_Diag_2_ICD  NOT IN ('') 
 or (Sec_Diag_2_ICD IN ('') and Sec_Diag_3_ICD NOT IN ('') )
 or (Sec_Diag_3_ICD IN ('') and Sec_Diag_4_ICD NOT IN ('') )
 or (Sec_Diag_4_ICD IN ('') and Sec_Diag_5_ICD NOT IN ('') )
 or (Sec_Diag_5_ICD IN ('') and Sec_Diag_6_ICD NOT IN ('') )
 or (Sec_Diag_6_ICD IN ('') and Sec_Diag_7_ICD NOT IN ('') )
 or (Sec_Diag_7_ICD IN ('') and Sec_Diag_8_ICD NOT IN ('') )
 or (Sec_Diag_8_ICD IN ('') and Sec_Diag_9_ICD NOT IN ('') )
 or (Sec_Diag_9_ICD IN ('') and Sec_Diag_10_ICD NOT IN ('') )
 or (Sec_Diag_10_ICD IN ('') and Sec_Diag_11_ICD NOT IN ('') )
 or (Sec_Diag_11_ICD IN ('') and Sec_Diag_12_ICD NOT IN ('') )
 or (Sec_Diag_12_ICD IN ('') and Sec_Diag_13_ICD NOT IN ('') )
 or (Sec_Diag_13_ICD IN ('') and Sec_Diag_14_ICD NOT IN ('') )
 or (Sec_Diag_14_ICD IN ('') and Sec_Diag_15_ICD NOT IN ('') )
 or (Sec_Diag_15_ICD IN ('') and Sec_Diag_16_ICD NOT IN ('') )
 or (Sec_Diag_16_ICD IN ('') and Sec_Diag_17_ICD NOT IN ('') )
 or (Sec_Diag_17_ICD IN ('') and Sec_Diag_18_ICD NOT IN ('') )
 or (Sec_Diag_18_ICD IN ('') and Sec_Diag_19_ICD NOT IN ('') )
 or (Sec_Diag_19_ICD IN ('') and Sec_Diag_20_ICD NOT IN ('') )
 or (Sec_Diag_20_ICD IN ('') and Sec_Diag_21_ICD NOT IN ('') )
 or (Sec_Diag_21_ICD IN ('') and Sec_Diag_22_ICD NOT IN ('') )
 or (Sec_Diag_22_ICD IN ('') and Sec_Diag_23_ICD NOT IN ('') )
 or (Sec_Diag_23_ICD IN ('') and Sec_Diag_24_ICD NOT IN ('') )
 or (Sec_Diag_24_ICD IN ('') and Sec_Diag_25_ICD NOT IN ('') )

 if object_id('tempdb..#CDSRowCount_CorpData') is not null
drop table #CDSRowCount_CorpData

		select getdate() [CreatedDate] 
		,@@rowcount [RowsChanged]
		, 'IP' [CDS_Type]
		, 'excludes unsequenced diagnosis codes' into #CDSRowCount_CorpData


	INSERT INTO [CorpCDS].[Stored_Procedure_RecordChanges]
           ([CreatedDate]
           ,[RowsChanged]
           ,[CDS_Type]
		   ,[Error_Desc] )
		Select [CreatedDate], [RowsChanged],[CDS_Type],[Error_Desc] from #CDSRowCount_CorpData

--Removes additional diagnois when Primary is null
Update HDM_cds.[CDS].[APC] 
SET Sec_Diag_ICD = ('')
WHERE Sec_Diag_ICD  NOT IN ('') and Primary_Diag_ICD IN ('')

if object_id('tempdb..#CDSRowCount_CorpData') is not null
drop table #CDSRowCount_CorpData


		select getdate() [CreatedDate] 
		,@@rowcount [RowsChanged]
		, 'IP' [CDS_Type]
		, 'Removes additional diagnois when Primary is null' [Error_Desc] into #CDSRowCount_CorpData

		INSERT INTO [CorpCDS].[Stored_Procedure_RecordChanges]
           ([CreatedDate]
           ,[RowsChanged]
           ,[CDS_Type]
		   ,[Error_Desc] )
		Select [CreatedDate], [RowsChanged],[CDS_Type],[Error_Desc] from #CDSRowCount_CorpData





