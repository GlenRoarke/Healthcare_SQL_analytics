USE HDM
GO

/*******************************************************************************************************************************************************************************/
-- Angle 1 - the consultant
/*******************************************************************************************************************************************************************************/

-- look for the consultant who had the spurious treatment function (the email references Dr Malcolm Johnstone)
SELECT * FROM dbo.DIM_HC_PROFESSIONAL HCP WITH(NOLOCK) WHERE HCP.SURNAME = 'Johnston' AND HCP.FORENAME = 'Malcolm' 

-- Find any audit records relating to the consultant (using the ENTITY_EXTERNAL_ID)
-- We can see the changes made by Maria referenced in the email -  Saludas Cohi, Maria (Ms) - saludascohim
SELECT		
			ddate.Date
			,atc.TRANSACTION_COMMAND
			,st.TERMINAL_NAME
			,st.TERMINAL_DESC
			,st.SYSTEM_NAME
			,su.USERS_NAME
			,su.USER_ID
			,e.DESCRIPTION AS LookupEntity
			,FAF.*
FROM		dbo.FACT_AUDIT_FULL FAF WITH (NOLOCK)
INNER JOIN	dbo.DIM_DATE ddate WITH (NOLOCK)
							ON	FAF.LOG_DATE = ddate.DIM_DATE_ID
			--     Get the Transaction Name that created the Audit Record
INNER JOIN	dbo.DIM_AUDIT_TRANSACTION_COMMAND ATC with(nolock)
												ON	FAF.DIM_AUDIT_TRANSACTION_COMMAND_ID = ATC.DIM_AUDIT_TRANSACTION_COMMAND_ID
			--     Get the Terminal that the action was carried out on
INNER JOIN	dbo.DIM_SYSTEM_TERMINAL ST with(nolock)
									ON	FAF.DIM_SYSTEM_TERMINAL_ID = ST.DIM_SYSTEM_TERM_ID
			--     Get the User that carried out the action
INNER JOIN	dbo.DIM_SYSTEM_USER SU WITH(NOLOCK)
									ON	FAF.DIM_SYSTEM_USER_ID = SU.DIM_SYSTEM_USER_ID
			--     Get the Entity type of the action
INNER JOIN	dbo.DIM_LOOKUP_ENTITY E WITH(NOLOCK)
									ON	FAF.DIM_LOOKUP_ENTITY_ID = E.DIM_LOOKUP_ENTITY_ID
WHERE		FAF.ENTITY_EXTERNAL_ID = '37286D81-43C7-40A2-9597-E62287A381EB' -- the consultant whose record was modified incorrectly
ORDER BY	FAF.LOG_DTTM DESC

 -- Look for all the specialties associated with the consultant who had the spurious treatment function (the email show the associated specialties to Mr Johnstone and whether they are configured as a main specialty and / or treatment function)
SELECT * FROM dbo.DIM_HC_PROFESSIONAL_SPECIALTY HCPS WITH(NOLOCK) WHERE HCPS.DIM_HCP_ID = 143551

-- Find any audit records relating to the consultant's associated specialties (using the ENTITY_EXTERNAL_ID)
SELECT		
			ddate.Date
			,atc.TRANSACTION_COMMAND
			,st.TERMINAL_NAME
			,st.TERMINAL_DESC
			,st.SYSTEM_NAME
			,su.USERS_NAME
			,su.USER_ID
			,e.DESCRIPTION AS LookupEntity
			,FAF.*
FROM		dbo.FACT_AUDIT_FULL FAF WITH (NOLOCK)
INNER JOIN	dbo.DIM_DATE ddate WITH (NOLOCK)
							ON	FAF.LOG_DATE = ddate.DIM_DATE_ID
			--     Get the Transaction Name that created the Audit Record
INNER JOIN	dbo.DIM_AUDIT_TRANSACTION_COMMAND ATC with(nolock)
												ON	FAF.DIM_AUDIT_TRANSACTION_COMMAND_ID = ATC.DIM_AUDIT_TRANSACTION_COMMAND_ID
			--     Get the Terminal that the action was carried out on
INNER JOIN	dbo.DIM_SYSTEM_TERMINAL ST with(nolock)
									ON	FAF.DIM_SYSTEM_TERMINAL_ID = ST.DIM_SYSTEM_TERM_ID
			--     Get the User that carried out the action
INNER JOIN	dbo.DIM_SYSTEM_USER SU WITH(NOLOCK)
									ON	FAF.DIM_SYSTEM_USER_ID = SU.DIM_SYSTEM_USER_ID
			--     Get the Entity type of the action
INNER JOIN	dbo.DIM_LOOKUP_ENTITY E WITH(NOLOCK)
									ON	FAF.DIM_LOOKUP_ENTITY_ID = E.DIM_LOOKUP_ENTITY_ID
WHERE		FAF.ENTITY_EXTERNAL_ID = '1BAF131C-84BE-4357-A379-C3AAF829C950'	-- the specialties associated with the consultant whose record was modified incorrectly
OR			FAF.ENTITY_EXTERNAL_ID = 'BFE3BB86-AD82-4D4F-95A9-3BC0B4CD3B7B'	-- the specialties associated with the consultant whose record was modified incorrectly
OR			FAF.ENTITY_EXTERNAL_ID = 'EEC0A69D-B1FE-4886-BB8C-4FA1BBCCEF09'	-- the specialties associated with the consultant whose record was modified incorrectly
OR			FAF.ENTITY_EXTERNAL_ID = 'F06407B0-8652-4867-BECE-11CEDCE73785'	-- the specialties associated with the consultant whose record was modified incorrectly
OR			FAF.ENTITY_EXTERNAL_ID = '3003B115-CD7D-EB11-80ED-005056ADA528'	-- the specialties associated with the consultant whose record was modified incorrectly

ORDER BY	FAF.ENTITY_EXTERNAL_ID
			,FAF.LOG_DTTM DESC

/*******************************************************************************************************************************************************************************/
-- Angle 2 - the lookup entity
/*******************************************************************************************************************************************************************************/

-- Find lookup entities that look like they might relate to a specialty (the email references a specialty being created on 6th Jan 2022 16:03)
SELECT * FROM HDM.dbo.DIM_LOOKUP_ENTITY WITH(NOLOCK) WHERE DESCRIPTION LIKE '%specialty%' -- investigate 'CA12954F-5F92-4549-A3C9-75EF6438BF9B' -- description "Specialty"

-- Look for auudit records relating to the "Specialty" lookup entity that were made on the 6th Jan 2022 16:03
SELECT		
			ddate.Date
			,atc.TRANSACTION_COMMAND
			,st.TERMINAL_NAME
			,st.TERMINAL_DESC
			,st.SYSTEM_NAME
			,su.USERS_NAME
			,su.USER_ID
			,e.DESCRIPTION AS LookupEntity
			,FAF.*
FROM		dbo.FACT_AUDIT_FULL FAF WITH (NOLOCK)
INNER JOIN	dbo.DIM_DATE ddate WITH (NOLOCK)
							ON	FAF.LOG_DATE = ddate.DIM_DATE_ID
							AND	ddate.Date = '06 Jan 2022'
			--     Get the Transaction Name that created the Audit Record
INNER JOIN	dbo.DIM_AUDIT_TRANSACTION_COMMAND ATC with(nolock)
												ON	FAF.DIM_AUDIT_TRANSACTION_COMMAND_ID = ATC.DIM_AUDIT_TRANSACTION_COMMAND_ID
			--     Get the Terminal that the action was carried out on
INNER JOIN	dbo.DIM_SYSTEM_TERMINAL ST with(nolock)
									ON	FAF.DIM_SYSTEM_TERMINAL_ID = ST.DIM_SYSTEM_TERM_ID
			--     Get the User that carried out the action
INNER JOIN	dbo.DIM_SYSTEM_USER SU WITH(NOLOCK)
									ON	FAF.DIM_SYSTEM_USER_ID = SU.DIM_SYSTEM_USER_ID
			--     Get the Entity type of the action
INNER JOIN	dbo.DIM_LOOKUP_ENTITY E WITH(NOLOCK)
									ON	FAF.DIM_LOOKUP_ENTITY_ID = E.DIM_LOOKUP_ENTITY_ID
									AND	e.EXTERNAL_ID = 'CA12954F-5F92-4549-A3C9-75EF6438BF9B'
WHERE		FAF.LOG_DTTM >= '06 Jan 2022 16:00' -- around the time of 16:03
AND			FAF.LOG_DTTM <= '06 Jan 2022 16:05' -- around the time of 16:03
 
 
-- See if this matches the specialty record identified (Toni's specialty details screenshot in the email)
SELECT * FROM dbo.DIM_SPECIALTY WHERE EXTERNAL_ID = '13FA67C0-DE8C-E311-9637-005056AB069F' -- Yes, it does!

-- In his email, Glen said that this specialty was created on the 6th Jan 2022, but HDM says it was created on 17th Jan 2022 
-- Check to see if there are any other specialty records identified as 811
SELECT * FROM dbo.DIM_SPECIALTY WHERE NHS_ID = '811' -- Nope!

-- Check the entire audit trail for the "811" specialty record
-- The audit trail for the record goes back as far as 3rd July 2018 so we can't trust the create_dttm field in DIM_SPECIALTY
SELECT		
			ddate.Date
			,atc.TRANSACTION_COMMAND
			,st.TERMINAL_NAME
			,st.TERMINAL_DESC
			,st.SYSTEM_NAME
			,su.USERS_NAME
			,su.USER_ID
			,e.DESCRIPTION AS LookupEntity
			,FAF.*
FROM		dbo.FACT_AUDIT_FULL FAF WITH (NOLOCK)
INNER JOIN	dbo.DIM_DATE ddate WITH (NOLOCK)
							ON	FAF.LOG_DATE = ddate.DIM_DATE_ID
			--     Get the Transaction Name that created the Audit Record
INNER JOIN	dbo.DIM_AUDIT_TRANSACTION_COMMAND ATC WITH(NOLOCK)
												ON	FAF.DIM_AUDIT_TRANSACTION_COMMAND_ID = ATC.DIM_AUDIT_TRANSACTION_COMMAND_ID
			--     Get the Terminal that the action was carried out on
INNER JOIN	dbo.DIM_SYSTEM_TERMINAL ST WITH(NOLOCK)
									ON	FAF.DIM_SYSTEM_TERMINAL_ID = ST.DIM_SYSTEM_TERM_ID
			--     Get the User that carried out the action
INNER JOIN	dbo.DIM_SYSTEM_USER SU WITH(NOLOCK)
									ON	FAF.DIM_SYSTEM_USER_ID = SU.DIM_SYSTEM_USER_ID
			--     Get the Entity type of the action
INNER JOIN	dbo.DIM_LOOKUP_ENTITY E WITH(NOLOCK)
									ON	FAF.DIM_LOOKUP_ENTITY_ID = E.DIM_LOOKUP_ENTITY_ID
WHERE		FAF.ENTITY_EXTERNAL_ID = '13FA67C0-DE8C-E311-9637-005056AB069F'
ORDER BY	FAF.LOG_DTTM DESC 
 
/*******************************************************************************************************************************************************************************/
-- Conclusion so far
/*******************************************************************************************************************************************************************************/

-- We can see that the consultant record has been updated, but it doesn't always seem to be captured what the values within the record were changed from and to
-- We can see the specialty details were changed, but there is no record of what changed





/*******************************************************************************************************************************************************************************/
-- other things we are yet to investigate to reach a full suite of config change checks
/*******************************************************************************************************************************************************************************/

/* 

SELECT * FROM HDM.dbo.DIM_LOOKUP_ENTITY WITH(NOLOCK) WHERE DESCRIPTION LIKE '%ward%'
SELECT * FROM HDM.dbo.DIM_LOOKUP_ENTITY WITH(NOLOCK) WHERE DESCRIPTION LIKE '%outcome%'
SELECT * FROM HDM.dbo.DIM_LOOKUP_ENTITY WITH(NOLOCK) WHERE DESCRIPTION LIKE '%RTT%'

 */