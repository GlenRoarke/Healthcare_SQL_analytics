--TRUNCATE TABLE development.[dbo].[tmp_TEST_OASIS_IP_SUS]

--TRUNCATE TABLE [dbo].[tmp_TEST_OASIS_OP_SUS]

--TRUNCATE TABLE [dbo].[tmp_TEST_OASIS_OP_SUS_Errors]

--TRUNCATE TABLE [dbo].[tmp_TEST_OASIS_IP_SUS_Errors]


truncate table [SUS_Data].[dbo].[tmp_IP_SUS]
truncate table [SUS_Data].dbo.audit
truncate table [SUS_Data].dbo.IP_PBR_5thDay

select convert(datetime,stuff(stuff([Report Period Start Date],5,0,'-'),8,0,'-'),20) [ReportPeriodStart_DTTM]
,convert(datetime,stuff(stuff([Report Period End Date],5,0,'-'),8,0,'-'),20) [ReportPeriodEnd_DTTM]
 ,convert(datetime,dateadd(month,datediff(month,0,[Hospital Provider Spell End Date]),0),103) [EndMonth]
,convert(datetime,stuff(stuff([Extract Date],5,0,'-'),8,0,'-'),20) [Extract_DTTM]
,convert(datetime,stuff(stuff([Dominant Staging Loaded Date],5,0,'-'),8,0,'-'),20) [Dominant Staging Loaded DTTM]
,count(1)
FROM SUS_Data.dbo.IP_PBR_5thDay
GROUP BY convert(datetime,stuff(stuff([Report Period Start Date],5,0,'-'),8,0,'-'),20) 
,convert(datetime,stuff(stuff([Report Period End Date],5,0,'-'),8,0,'-'),20) 
,[Finished Indicator]
,convert(datetime,stuff(stuff([Extract Date],5,0,'-'),8,0,'-'),20) 
,convert(datetime,stuff(stuff([Dominant Staging Loaded Date],5,0,'-'),8,0,'-'),20)
 ,convert(datetime,dateadd(month,datediff(month,0,[Hospital Provider Spell End Date]),0),103)
order by 3 desc