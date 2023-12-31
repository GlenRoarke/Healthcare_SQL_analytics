/****** 6-ConcurrentTelecomTypeBIrep

PDS and Medway support the following telecom role types 
• "HP" - home
• “WP” - work
• “MC” - mobile number
• “EC” - emergency contact n.b. DON'T KNOW HOW EMERGENCY CONTACTS ARE STORED
• “email” - Email	- OR EMAIL
Only one of each combination is allowed at a single time by PDS and therefore a validation must be applied to ensure there is only one. 

pete holds telephone numbers with roles:
Home
Mobile number
SMS Number
Work

need something else to check em contact and email


  ******/
USE [Sigma_BI_REP] 
 
SELECT 
[PETE].[PETE_PERSONID] 
, [PPI].[PATI_NO_RAW] as 'PAS ID'
, ' '+[PETE].[PETE_VALUE]  as 'TelNumber'
--, [PETE].[PETE_RTYPE]
, [LRTY].[LK_DESC] AS [TelecomRole]
--, [TRTY].[LKTA_NAME] AS 'fromTable'
, [PETE].[PETE_STDATE] 
, [PETE].[PETE_ENDATE] 
FROM
 Patient.[PERSON_TELECOM] PETE  WITH(NOLOCK)
 INNER JOIN (
	-- multiple patient trt combinations that re NULL enddated or future enddated
	SELECT 
		[PETE].[PETE_PERSONID] 
		, [PETE].[PETE_RTYPE]
	FROM
	 Patient.[PERSON_TELECOM] PETE  WITH(NOLOCK)
	WHERE [PETE].[PETE_DELETED] = 0
		AND ISNULL([PETE].[PETE_ENDATE], GETDATE()) >= GETDATE()
	GROUP BY
		[PETE].[PETE_PERSONID] 
		, [PETE].[PETE_RTYPE]
	HAVING COUNT(*) >1 ) [PETEC]
ON [PETEC].[PETE_PERSONID] = [PETE].[PETE_PERSONID]
AND [PETEC].[PETE_RTYPE] =  [PETE].[PETE_RTYPE]
AND [PETE].[PETE_DELETED] = 0
AND ISNULL([PETE].[PETE_ENDATE], GETDATE()) >= GETDATE()

INNER JOIN [CORE].[ALL_LOOKUP_ITEM] [LRTY] WITH (NOLOCK)
ON [LRTY].[LK_ID]  = [PETE].[PETE_RTYPE]
INNER JOIN [Core].[ALL_LOOKUP_TABLE] [TRTY] with (nolock)
ON [TRTY].[LKTA_ID] = [LRTY].[LK_LKTAID] 

INNER JOIN [Patient].[PERSON_IDENTIFIER] [PPI] WITH (NOLOCK)
ON [PPI].[PATI_PERSONID] = [PETE].[PETE_PERSONID] 
AND [PPI].[PATI_DELETED] = 0
  
INNER JOIN --[Patient].[PA_LOOKUP_ITEM] <<<<< this JOIN does not work - use Core instead
[Core].[ALL_LOOKUP_ITEM] [IDT] WITH (NOLOCK)
ON [IDT].[LK_ID] = [PPI].[PATI_TYPE] 
AND [IDT].[LK_DESC] = 'Hospital Number'

ORDER BY
[PPI].[PATI_NO_RAW] 
, [PETE].[PETE_RTYPE]
, [LRTY].[LK_DESC]
, [PETE] .[PETE_VALUE]  
, [PETE].[PETE_STDATE]
;


/***--which Telecom Role Type values are used
SELECT 
[TRTY].[LKTA_NAME] 
, PETE.[PETE_RTYPE]
, [LRTY].[LK_DESC] AS [TelecomRole]
,COUNT(*)
FROM
 Patient.[PERSON_TELECOM] PETE  WITH(NOLOCK)
 INNER JOIN [CORE].[ALL_LOOKUP_ITEM] [LRTY] WITH (NOLOCK)
ON [LRTY].[LK_ID]  = PETE.[PETE_RTYPE]
AND PETE.[PETE_DELETED] = 0
INNER JOIN [Core].[ALL_LOOKUP_TABLE] [TRTY] WITH (NOLOCK)
ON [TRTY].[LKTA_ID] = [LRTY].[LK_LKTAID] 
GROUP BY
[TRTY].[LKTA_NAME] 
, PETE.[PETE_RTYPE]
, [LRTY].[LK_DESC] 
;
***/
/***
SELECT TOP 10  [PPI].[PATI_NO_RAW] , [PETE].*
FROM
 Patient.[PERSON_TELECOM] PETE  WITH(NOLOCK)
   INNER JOIN [Patient].[PERSON_IDENTIFIER] [PPI] WITH (NOLOCK)
  ON [PPI].[PATI_PERSONID] = [PETE].[PETE_PERSONID] 
  AND [PPI].[PATI_DELETED] = 0
  
  INNER JOIN --[Patient].[PA_LOOKUP_ITEM] <<<<< this JOIN does not work - use Core instead
	[Core].[ALL_LOOKUP_ITEM] [IDT] WITH (NOLOCK)
  ON [IDT].[LK_ID] = [PPI].[PATI_TYPE] 
  AND [IDT].[LK_DESC] = 'Hospital Number'

 WHERE
 PETE_PERSONID = 'CED08468-9A5B-4D47-BEAE-000000312BBC'
ORDER BY
[PETE].[PETE_PERSONID] 
, [PETE].[PETE_RTYPE]
, [PETE].[PETE_STDATE] ;
 ***/
