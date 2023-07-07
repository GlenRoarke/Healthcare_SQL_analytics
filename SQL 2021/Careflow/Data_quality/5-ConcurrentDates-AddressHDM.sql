/*** 5-ConcurrentDates-AddressHDM

5	Overlapping Dates
5.1	Validation
PDS and Medway only support the ability to have one current record of a particular type i.e. only one active home address. This can be caused by an overlap in start and end dates, two open ended records or a future end date over lapping with an open record.
4.1	Validation
PDS and Medway historically supported future start and end dates for Telecoms and Addresses. 
However, since the implementation of Spine2 by HSCIC, the support for future end dates has been removed. 
This is to ensure that records are updated in real-time rather than having a ‘predicted’ start or expiry that may not occur.

It will not be possible to save an address or telecoms entry without correcting these dates 
or removing the entry and therefore to prevent the user from needing to do this it is advised that these are cleanse pre-go live.

CJD

Medway BI already does a potential adjustment for this, so we may not get the full picture
End dates are they just the date no time?

Needed:
1 Patient details where patient has more than one open address record
2 patient details where patient has one open address record and a closed record with CLOSE DTTM > START DTTM of the open record
***/
USE [HDM]


--1 Patient details where patient has more than one open address record
select 
PAT.[PATIENT_EXTERNAL_ID] 
, PAT.PAS_ID
, [DADDT].[DESCRIPTION]  AS 'Addr Type'
, pah.OPEN_DTTM, pah.CLOSE_DTTM
, PAH.[ADDRESS1] , PAH.[ADDRESS2] , PAH.[ADDRESS3] 
 from
dbo.FACT_PATIENT_ADDRESS_HISTORY pah with(nolock)
INNER JOIN (SELECT [DIM_PATIENT_ID]
				,[DIM_LOOKUP_ADDTYPE_ID]
				, COUNT(*) AS [PAHC]
				FROM [dbo].[FACT_PATIENT_ADDRESS_HISTORY] pah with (nolock)
				WHERE [ARCHV_FLAG] = 'N'
				AND ISNULL([pah].[CLOSE_DTTM],GETDATE()) >= GETDATE()
				GROUP BY
				[DIM_PATIENT_ID]
				,[DIM_LOOKUP_ADDTYPE_ID]
				HAVING COUNT(*) >1 ) [PC] 
	ON [PC].[DIM_PATIENT_ID] = [pah].[DIM_PATIENT_ID]
	AND [PC].[DIM_LOOKUP_ADDTYPE_ID] = [pah].[DIM_LOOKUP_ADDTYPE_ID]
	AND ISNULL([PAH].[CLOSE_DTTM],GETDATE()) >= GETDATE()
	AND [PAH].[ARCHV_FLAG] = 'N'

INNER JOIN dbo.FACT_CURRENT_PATIENT PAT WITH(NOLOCK)
ON PAT.FACT_CURRENT_PATIENT_ID= pah.DIM_PATIENT_ID

INNER JOIN [dbo].[DIM_LOOKUP_ADDTYPE] [DADDT] with (nolock)
ON [DADDT].[DIM_LOOKUP_ADDTYPE_ID] = [pah].[DIM_LOOKUP_ADDTYPE_ID] 

ORDER BY PAT.PAS_ID
, pah.[DIM_LOOKUP_ADDTYPE_ID] 
, pah.OPEN_DTTM

;

-- 2 patient details where patient has one open address record and a closed record with CLOSE DTTM > START DTTM of the open record
select 
PAT.[PATIENT_EXTERNAL_ID] 
, PAT.PAS_ID
, [DADDT].[DESCRIPTION]  AS 'Addr Type'
, pah.OPEN_DTTM  AS 'Closed Overlapping OPEN'
, pah.CLOSE_DTTM AS 'Closed Overlapping CLOSE'
, [PC].[OPEN_DTTM] AS 'CurrentlyOpenSTART'
, PAH.[ADDRESS1] , PAH.[ADDRESS2] , PAH.[ADDRESS3] 
 from
dbo.FACT_PATIENT_ADDRESS_HISTORY pah with(nolock)
INNER JOIN (SELECT 
			[pah1].[DIM_PATIENT_ID]
			, [pah1].[DIM_LOOKUP_ADDTYPE_ID]
			, [pah1].[OPEN_DTTM]
			, [pah1].[CLOSE_DTTM]  --NULL
			FROM [dbo].[FACT_PATIENT_ADDRESS_HISTORY] pah1 with (nolock)
			INNER JOIN
				(SELECT [DIM_PATIENT_ID]
				,[DIM_LOOKUP_ADDTYPE_ID]
				, COUNT(*) AS [PAHC]
				FROM [dbo].[FACT_PATIENT_ADDRESS_HISTORY] pah with (nolock)
					WHERE [ARCHV_FLAG] = 'N'
					AND [pah].[CLOSE_DTTM] IS NULL
					AND [DIM_PATIENT_ID] <> -1
				GROUP BY
				[DIM_PATIENT_ID]
				,[DIM_LOOKUP_ADDTYPE_ID]
				HAVING COUNT(*) =1 ) PC1 
			ON [pah1].[DIM_PATIENT_ID] = [PC1].[DIM_PATIENT_ID]
			AND [pah1].[DIM_LOOKUP_ADDTYPE_ID] = [PC1].[DIM_LOOKUP_ADDTYPE_ID]
			AND [pah1].[CLOSE_DTTM] IS NULL
			AND [pah1].[ARCHV_FLAG] = 'N' ) [PC] 
	ON [PC].[DIM_PATIENT_ID] = [pah].[DIM_PATIENT_ID]
	AND [PC].[DIM_LOOKUP_ADDTYPE_ID] = [pah].[DIM_LOOKUP_ADDTYPE_ID]
	AND [PAH].[CLOSE_DTTM] > [PC].[OPEN_DTTM] 
	AND [PAH].[ARCHV_FLAG] = 'N'

INNER JOIN dbo.FACT_CURRENT_PATIENT PAT WITH(NOLOCK)
ON PAT.FACT_CURRENT_PATIENT_ID= pah.DIM_PATIENT_ID

INNER JOIN [dbo].[DIM_LOOKUP_ADDTYPE] [DADDT] with (nolock)
ON [DADDT].[DIM_LOOKUP_ADDTYPE_ID] = [pah].[DIM_LOOKUP_ADDTYPE_ID] 

ORDER BY 
PAT.PAS_ID
, pah.[DIM_LOOKUP_ADDTYPE_ID] 
, pah.OPEN_DTTM

;
