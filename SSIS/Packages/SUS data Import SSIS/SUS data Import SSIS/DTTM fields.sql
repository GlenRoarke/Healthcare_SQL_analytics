
--OP DTTM Columns

  ,convert(datetime,stuff(stuff([Extract Date],5,0,'-'),8,0,'-'),20) [Extract_DTTM]
      ,convert(datetime,stuff(stuff([Report Period Start Date],5,0,'-'),8,0,'-'),20) [Report Period Start_DTTM]
	  ,convert(datetime,stuff(stuff([Report Period End Date],5,0,'-'),8,0,'-'),20) [Report Period End_DTTM]
	  ,convert(datetime,stuff(stuff([Appointment Date],5,0,'-'),8,0,'-'),20)[Appointment_DTTM]
	  ,convert(datetime,stuff(stuff([CDS Activity Date],5,0,'-'),8,0,'-'),20)[CDS Activity_DTTM]
	  ,convert(datetime,stuff(stuff([Staging Loaded Date],5,0,'-'),8,0,'-'),20) [Staging Loaded_DTTM]


















/* IP date columns 
 convert(datetime,stuff(stuff([Start Date (Hospital Provider Spell)],5,0,'-'),8,0,'-'),20) [Start Date (Hospital Provider Spell)_DTTM]
	  ,convert(datetime,stuff(stuff([End Date (Hospital Provider Spell)],5,0,'-'),8,0,'-'),20) [End Date (Hospital Provider Spell)_DTTM]
	  ,convert(datetime,stuff(stuff([PbR Spell Start Date],5,0,'-'),8,0,'-'),20) [PbR Spell Start_DTTM]
	  ,convert(datetime,stuff(stuff([PbR Spell End Date],5,0,'-'),8,0,'-'),20) [PbR Spell End_DTTM]
	  ,convert(datetime,stuff(stuff([Hospital Provider Spell Discharge Date],5,0,'-'),8,0,'-'),20) [Hospital Provider Spell Discharge_DTTM]
	  ,convert(datetime,stuff(stuff([Hospital Provider Spell End Date],5,0,'-'),8,0,'-'),20) [Hospital Provider Spell End_DTTM]
	  ,convert(datetime,stuff(stuff([Episode Start Date],5,0,'-'),8,0,'-'),20) [Episode Start_DTTM]
	  ,convert(datetime,stuff(stuff([Episode End Date],5,0,'-'),8,0,'-'),20) [Episode End_DTTM]
	  ,convert(datetime,stuff(stuff([CDS Activity Date],5,0,'-'),8,0,'-'),20) [CDS Activity_DTTM]
	  ,convert(datetime,stuff(stuff([Episode Start Date Original],5,0,'-'),8,0,'-'),20) [Episode Start Date Original_DTTM]
 ,convert(datetime,stuff(stuff([Extract Date],5,0,'-'),8,0,'-'),20) [Extract_DTTM]
      ,convert(datetime,stuff(stuff([Report Period Start Date],5,0,'-'),8,0,'-'),20) [ReportPeriodStart_DTTM]
	  ,convert(datetime,stuff(stuff([Report Period End Date],5,0,'-'),8,0,'-'),20) [ReportPeriodEnd_DTTM]

	  ,convert(datetime,stuff(stuff([Dominant Staging Loaded Date],5,0,'-'),8,0,'-'),20) [Dominant Staging Loaded_DTTM] */
	  
	  
	  
select MIN(convert(datetime,stuff(stuff([Hospital Provider Spell End Date],5,0,'-'),8,0,'-'),20)) [DischargeStartDate]
	  ,max(convert(datetime,stuff(stuff([Hospital Provider Spell End Date],5,0,'-'),8,0,'-'),20)) [DischargeEndDate]
	  ,convert(datetime,stuff(stuff([Hospital Provider Spell End Date],5,0,'-'),8,0,'-'),20) [Staging Loaded Date]
	 
 --USe these for audit
,count(1)
FROM SUS_Data.dbo.tmp_IP_SUS
GROUP BY convert(datetime,stuff(stuff([Report Period Start Date],5,0,'-'),8,0,'-'),20) 
	  ,convert(datetime,stuff(stuff([Report Period End Date],5,0,'-'),8,0,'-'),20)
	  ,convert(datetime,stuff(stuff([Hospital Provider Spell End Date],5,0,'-'),8,0,'-'),20) 
order by 3 desc

