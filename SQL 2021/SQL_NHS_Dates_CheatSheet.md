# SQL NHS cheatsheet 

A collection of SQL to manipulate dates using SQL 2012. These are system specific examples and date columns would need replacing with the relevant columns.

Its main purpose for me was to store common dates requests I used in reporting.                         |


# Dates

Common date manipulations used on a range of different healthcare systems. Usually these would be used with other columns so the select is removed for convenience.

shows date as mmyyyy in text format
```sql

SELECT RIGHT(CONVERT(VARCHAR(10), ip.AdmissionDate, 103), 7) AS [AdmissionMonth]

```

To group date by day and correct format
```sql
SELECT cast((DateAdd(dd,0,DateDiff(dd,0,WL.TCIDate))) as smalldatetime) as TCIDate
```

To generate weekending date 
```sql 
,cast(DateAdd(day, DateDiff(day, 6, op.AppointmentDate-1) /7*7 + 7, 6) as smalldatetime) as WkEnding
```
	 
To convert DateTIme to Date
```sql 
	convert(date,pat_created,103) 
```
 
To display date as small date time
```sql
convert(smalldatetime,[epd_created],103) as EPISODE_START_DATE
```
 
To display date weekly date through Excel SQL connection
```sql
	convert(smalldatetime,dateadd(week,datediff(week,0,b.APPT_DTTM),0),103)
```

To display date monthly date through Excel SQL connection.
Note- smalldatetime must be used instead of date for correct formatting
```sql
	convert(smalldatetime,dateadd(month,datediff(month,0,b.APPT_DTTM),0),103) 
```	

```sql

--To convert a varchar yyyy-mm-dd hh:mm:si value to a smalldatetime time (2005)
	convert(smalldatetime,start_date,20) 
	
--yyyy-mm-dd to month in medway CDS
	,convert(date,dateadd(month,datediff(month,0,convert(date,[CDS_ACTIVITY_DATE], 126)),0),103)  [CDS_Activity_Month]
	
--yyyymmddhhmmss to datetime
	convert(datetime,STUFF(STUFF(STUFF(STUFF(DateApplied,5,0,'-'),8,0,'-'),11,0,' '),14,0,':'),20) [DateApplied]
```	
	
	
Age at Episode start date
```sql
,CONVERT(int,ROUND(DATEDIFF(hour,[DATE_OF_BIRTH],EPISODE_START_DATE)/8766.0,0)) AS AgeYearsIntRound

-- Different types of age
--	Pasted from <https://stackoverflow.com/questions/1572110/how-to-calculate-age-in-years-based-on-date-of-birth-and-getdate>
	DECLARE @dob  datetime
SET @dob='1992-01-09 00:00:00'
	SELECT DATEDIFF(hour,@dob,GETDATE())/8766.0 AS AgeYearsDecimal
    ,CONVERT(int,ROUND(DATEDIFF(hour,@dob,GETDATE())/8766.0,0)) AS AgeYearsIntRound
    ,DATEDIFF(hour,@dob,GETDATE())/8766 AS AgeYearsIntTrunc

	--Age at admission
	,CASE
	WHEN DATEADD(YY,DATEDIFF(YY,P.[BIRTH_DTTM],IPS.[ADMIT_DTTM]),P.[BIRTH_DTTM]) > IPS.[ADMIT_DTTM] 
	THEN DATEDIFF(YY,P.[BIRTH_DTTM],IPS.[ADMIT_DTTM]) - 1
		ELSE DATEDIFF(YY,P.[BIRTH_DTTM],IPS.[ADMIT_DTTM])
			 END AS 'Age At Admission'
	
```	

## Common Month/Year end dates

These can be very useful when added the WHERE clauses.

```sql
--Current Financial year start 
Select cast(DATEADD(year,DATEDIFF(month,'20180401',getdate())/12,'20180401') as smalldatetime) [Financial_Year_Start]

--Brings back the last three months of data rolling
	>= DATEADD(MONTH, -3, GETDATE())
	
--First day of previous month
select DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE())-1, 0)
	
--Last Day of previous month
select DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-1, -1) +1
	
--First day of previous week
select DATEADD(WEEK, DATEDIFF(WEEK, 0, GETDATE())-1, 0)
	
--Last day of previous week
select DATEADD(WEEK, DATEDIFF(WEEK, 0, GETDATE())-1, 7)
	
	
--Last three months of data
select DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE())-3, 0) [StartDate]
	 ,DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-1, -1) [EndDate]

```

Brings back the pervious months dates  2018-03-31 hh:mm:ss
```sql
SELECT ip.DischargeDate
FROM BSUH_Development.dbo.IP_Episodes ip
WHERE DATEPART(m, ip.DischargeDate) = DATEPART(m, DATEADD(m, -1, getdate()))
AND DATEPART(yyyy, ip.DischargeDate) = DATEPART(yyyy, DATEADD(m, -1, getdate()))
	 
GROUP BY ip.DischargeDate
ORDER bY 1 desc 
	
--Another pervious month query 
SELECT	
DATEADD(ms, 3, DATEADD(mm, DATEDIFF(mm, 0, MAX([EPI_END_DTTM] )), 0)) AS StartDate,
DATEADD(ms, - 3, DATEADD(mm, DATEDIFF(mm, 0, MAX([EPI_END_DTTM] )) +1, 0)) AS EndDate
FROM [dbo].[FACT_IP_EPISODES] WITH(NOLOCK)
WHERE [EPI_END_DTTM] < GETDATE()
AND [ARCHV_FLAG] = 'N'
	
	
--Date to yyyymmdd        
convert(char(8),DateOfBirth,112) as DateOfBirth
--Dim Date monthly pick 
select top 1000 convert(datetime,dateadd(month,datediff(month,0,date),0),103)
from hdm.dbo.dim_date
where date between '01-01-2018' and convert(date,getdate(),103)
Group by convert(datetime,dateadd(month,datediff(month,0,date),0),103)
Order by 1 asc
	
-- using a system generated date reference table. This feature is not used in many healthcare databases.
select date
from hdm.dbo.dim_date
where date between '01-01-2018' and convert(date,getdate(),103)
Order by 1 asc
-- Group by convert(datetime,dateadd(month,datediff(month,0,date),0),103)
--Week start and dates using HDM_DIM_DATE
select
DATEADD(dd, -(DATEPART(dw, date)-1), date) [WeekStart]
,WeekEnding
from hdm.dbo.DIM_DATE a
where date between '01/10/2018 00:00' and getdate()
GROUP BY DATEADD(dd, -(DATEPART(dw, date)-1), date) 
,WeekEnding
	
ORDER BY 1 asc
```



