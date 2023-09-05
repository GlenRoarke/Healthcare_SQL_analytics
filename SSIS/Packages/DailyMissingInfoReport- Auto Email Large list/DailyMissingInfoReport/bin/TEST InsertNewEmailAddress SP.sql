



--Insert new email into the table for the IP Daily Missing Information Report.
--Duplicate emails can be selected so be careful.
--changing body line format will change layout of email for 150+ people.
--could develop SP in future with parameter???
USE DQ_Reporting
GO

CREATE PROCEDURE dbo.sp_InsertEmailTEST 
		
AS

INSERT INTO DQ_Reporting.dbo.Email_Distribution_List
           ([EmailFrom]
           ,[EmailTo]
           ,[Subject]
           ,[Body]
           ,[ReportName]
         --created date and active flag are default to getdate and 1
)
     VALUES
           ('DoNotReplyCorpData@bsuh.nhs.uk' --[EmailFrom]
           ,'' --<--Add in email address here one address as a time [EmailTo]
           ,'Daily Missing Information Report' --[Subject]
           ,'Hi,

Please find the Daily Missing Infomation Report at the following link.

This report will update several times during the day and at weekends so may show different data depending on the time of day you open it. Keep an eye on the refresh time at the top of page.

https://bireports.bsuh.nhs.uk/HDMSQL_Reports/Pages/Report.aspx?ItemPath=%2fReports%2fCorpData%2fData+Quality+Reports+(A)%2fIP+Missing+Information_LandingPage

If you need any further information or have queries please check the Guidance tab for advice or feel free to email keith.thomson@bsuh.nhs.uk

Kind Regards
The Corporate Data Team' --[Body]
           ,'IP Daily Missing Information Report' --[ReportName]
           )
    --adds in a second email       
   /*        ,('DoNotReplyCorpData@bsuh.nhs.uk' --[EmailFrom]
           ,'' --<--Add in email address here one address as a time [EmailTo]
           ,'Daily Missing Information Report' --[Subject]
           ,'Hi,

Please find the Daily Missing Infomation Report at the following link.

This report will update several times during the day and at weekends so may show different data depending on the time of day you open it. Keep an eye on the refresh time at the top of page.

https://bireports.bsuh.nhs.uk/HDMSQL_Reports/Pages/Report.aspx?ItemPath=%2fReports%2fCorpData%2fData+Quality+Reports+(A)%2fIP+Missing+Information_LandingPage

If you need any further information or have queries please check the Guidance tab for advice or feel free to email keith.thomson@bsuh.nhs.uk

Kind Regards
The Corporate Data Team' --[Body]
           ,'IP Daily Missing Information Report' --[ReportName])*/
           
 




