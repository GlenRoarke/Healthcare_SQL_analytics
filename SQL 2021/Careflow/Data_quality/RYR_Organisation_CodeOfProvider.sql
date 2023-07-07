/****** 

From 01/04/2022 (activity before 01/04/2022 should be RXH)

-- RXH00 -> RYR  OrgCodeP rovider - This Column is hardcoded to RXH 

-- RXH00 -> RYR  OrgCode_LocalPatientID

Episode End Date for finished episodes, Episode Start Date for unfinished episodes and Census Date for Psychiatric Census records

The update is not working on all records

left outer join [HDM].[dbo].[DIM_PATIENT] B with(nolock) on pas_ID =[Column 1] and MERGE_RECORD_ID is null

where pas_id is null

******/

 --A conditional update of sitecode for IP CDS
 UPDATE [HDM_CDS].[CDS].[APC]

 SET [Organisation_Code_Patient_ID] = CASE 
										WHEN convert(date,[CDS_ACTIVITY_DATE], 126) >= '01/04/2021' THEN 'RYR'
										WHEN convert(date,[CDS_ACTIVITY_DATE], 126) < '01/04/2021' THEN 'RXH' 
										END
,[Organisation_Code_Provider] = CASE 
										WHEN convert(date,[CDS_ACTIVITY_DATE], 126) >= '01/04/2021' THEN 'RYR'
										WHEN convert(date,[CDS_ACTIVITY_DATE], 126) < '01/04/2021' THEN 'RXH' 
										END



WHERE CDS_OUTPUT = 0 --Ensures only new CDS data is updated

--A conditional update of sitecode for OP CDS
UPDATE [HDM_CDS].[CDS].OP

SET [ORGANISATION_CODE_LOCAL_PATIENT_IDENTIFIER] = CASE 
										WHEN convert(date,[CDS_ACTIVITY_DATE], 126) >= '01/04/2021' THEN 'RYR'
										WHEN convert(date,[CDS_ACTIVITY_DATE], 126) < '01/04/2021' THEN 'RXH' 
										END

,[ORGANISATION_CODE_PROVIDER] = CASE 
										WHEN convert(date,[CDS_ACTIVITY_DATE], 126) >= '01/04/2021' THEN 'RYR'
										WHEN convert(date,[CDS_ACTIVITY_DATE], 126) < '01/04/2021' THEN 'RXH' 
										END
WHERE CDS_OUTPUT = 0




SELECT [CDS_APC_ID]
,CDS_HEADER_TYPE
      ,[CDS_HEADER_REPORT_PERIOD_START_DATE]
      ,[CDS_HEADER_REPORT_PERIOD_END_DATE]
      ,[Organisation_Code_Patient_ID]
	  ,[Organisation_Code_Provider]
      ,[Organisation_Code_Commissioner]
      ,[CDS_Activity_Date]
	  ,convert(date,[CDS_ACTIVITY_DATE], 126) [CDS_Activity_DTTM] --This is a derived field for activity date
	  ,EPISODE_START_DTTM
	  ,EPISODE_END_DTTM
      ,[Commissioning_Serial_Number]
      ,[NHS_Service_Agreement_Line_No]
      ,[Provider_Reference_Number]
      ,[Commissioner_Reference_Number]
      ,[Consultant_Code]
      ,[Main_Spec_ID]
      ,[TreatFunction_Code]
	  ,CDS_HEADER_PRIME_RECIPIENT_IDENTITY
	  ,CREATE_DTTM
	  ,CDS_OUTPUT
	  ,EXCLUDE_FROM_CDS
  FROM [HDM_CDS].[CDS].[APC]

  WHERE   --convert(date,[CDS_ACTIVITY_DATE], 126) > '01/04/2021' 
   convert(date,[CDS_ACTIVITY_DATE], 126) >= '01/04/2021 00:00:00' 
 and CDS_OUTPUT = 0 