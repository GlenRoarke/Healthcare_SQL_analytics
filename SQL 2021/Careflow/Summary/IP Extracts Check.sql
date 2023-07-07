select   b.FileName
,OrganisationCode_CodeOfCommissioner
,[CDSReportPeriodStartDate]
      ,[CDSReportPeriodEndDate]
	  ,count(1)

	  FROM CDS_Data.dbo.IP_Extracts a
	  INNER JOIN [CDS_Data].[dbo].[audit] b on a.Import_ID = b.Import_id

	  GROUP BY  b.FileName
	  ,OrganisationCode_CodeOfCommissioner
,[CDSReportPeriodStartDate]
      ,[CDSReportPeriodEndDate]

ORDER BY 3 desc, 5 desc 