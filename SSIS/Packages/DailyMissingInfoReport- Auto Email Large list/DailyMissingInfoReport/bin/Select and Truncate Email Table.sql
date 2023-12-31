
   
  --Truncate table [DQ_Reporting].[dbo].[Email_Distribution_List]
  
  SELECT TOP 1000 [EmailID]
      ,[EmailFrom]
      ,[EmailTo]
      ,[Subject]
      ,[Body]
      ,[ReportName]
      ,[CreatedDate]
      ,[ActiveFlag]
  FROM [DQ_Reporting].[dbo].[Email_Distribution_List]
  WHERE [EmailTo] like 'no%'



  
  --Inactivate email addresses of staff
  UPDATE [DQ_Reporting].[dbo].[Email_Distribution_List]
  SET [ActiveFlag] = 0
  WHERE [EmailTo] IN ('Noelia.Francisco@bsuh.nhs.uk')
  
  
  --check for duplicaton
  select [EmailTo], COUNT(1)  FROM [DQ_Reporting].[dbo].[Email_Distribution_List]
  group by [EmailTo]
  HAVING COUNT(1)   > 1