
--Change Subject of the email


  --Change Body of Email Message 
UPDATE [DQ_Reporting].[dbo].[Email_Distribution_List]
SET [Body] = 'Hi,

Please find the Daily Missing Infomation Report at the following link.

Please can you forward your new NHS Mail email address to glen.roarke@nhs.net

https://bireports.bsuh.nhs.uk/HDMSQL_Reports/Pages/Report.aspx?ItemPath=%2fReports%2fCorpData%2fData+Quality+Reports+(A)%2fIP+Missing+Information_LandingPage

Kind Regards
The Corporate Data Team'
			 
WHERE ReportName = 'IP Daily Missing Information Report'
  
  