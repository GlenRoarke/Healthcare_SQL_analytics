select
Merged_Hospital_ID,
merge_time,
datename(Month,merge_time) as MONTH,
datepart(Year,merge_time) as YEAR 
FROM [HDM_Local].[Corpdata].[Merges_Audit]
inner join HDM.dbo.

where convert(date,merge_time,102) between '01/04/2021' and '30/09/2021'

@From and @To