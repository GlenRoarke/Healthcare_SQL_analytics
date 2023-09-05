INSERT INTO [SUS_Data].[dbo].[audit]
           ([FileName]
           ,[Type])
     VALUES
           (substring(?,59,100) --only brings back filename
           ,'IP_PBR_5D')
           
GO

