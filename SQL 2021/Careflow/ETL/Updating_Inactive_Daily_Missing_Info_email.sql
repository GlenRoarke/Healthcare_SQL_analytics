/****** Changing flag from inactive to active ******/

SELECT TOP (1000) [EmailID]
      ,[EmailFrom]
      ,[EmailTo]
      ,[Subject]
      ,[Body]
      ,[ReportName]
      ,[CreatedDate]
      ,[ActiveFlag]
  FROM [DQ_Reporting].[dbo].[NHSMail_Distribution_List]
  WHERE [EmailTo] = ''
  
  UPDATE [DQ_Reporting].[dbo].[NHSMail_Distribution_List]
  SET [ActiveFlag] = 1
  WHERE [EmailTo] = ''