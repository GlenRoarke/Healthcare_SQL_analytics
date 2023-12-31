
   
  --Truncate table [DQ_Reporting].[dbo].[NHSMail_Distribution_List]
  
  SELECT TOP 1000 [EmailID]
      ,[EmailFrom]
      ,[EmailTo]
      ,[Subjetct]
      ,[Body]
      ,[ReporName]
      ,[CreatedDate]
      ,[ActiveFlag]
  FROM [DQ_Reporting].[dbo].[NHSMail_Distribution_List]
  WHERE [EmailTo] like '%user%'



  
  --Inactivate email addresses of staff
  UPDATE [DQ_Reporting].[dbo].[NHSMail_Distribution_List]
  SET [ActiveFlag] = 0
  WHERE [EmailTo] IN ('user.email@nhs.net')
  
  
  --check for duplicaton
  select [EmailTo], COUNT(1)  FROM [DQ_Reporting].[dbo].[NHSMail_Distribution_List]
  group by [EmailTo]
  HAVING COUNT(1)   > 1