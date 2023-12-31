/****** Script for SelectTopNRows command from SSMS  ******/

--Import to HDM_Local
---[Patient Postcode Derived PCT Type]
--- P = PDS lookup from submitted NHS Number
--- S = Lookup from submitted postcode

--[GP Practice Derived from PDS]
--Values are 0 if not derived from PDS, 1 if PDS has supplied a GP


--this is the IP PBR data that will be copied to HDM_Local, This data will link to HDM via SpellNo and/or LocalPatientIdentifier
SELECT 
[Hospital Provider Spell No]
--Practice
,[PCT Derived from GP Practice] [PDS_PracticeCCG]
,[Commissioner Code (Original Data)] [PAS_PracticeCCG] 
,[GP Practice Code (Derived)] [PDS_PracticeCode]
,[GP Practice Code (Original Data)] [PAS_PracticeCode]
,[GP Practice Derived from PDS] 
--Postcode
,[Patient Postcode Derived PCT] [PDS_PostCodeCCG]
,[Organisation Code (PCT of Residence)] [PAS_PostcodeCCG]
,[Postcode of Usual Address] [PostCode] --Seems to be Medway
,[Patient Postcode Derived PCT Type] --could case statement this make it easy to read.
,cast([PbR Final Tariff] as int) [PbR Final Tariff]
FROM [SUS_Data].[dbo].[tmp_IP_SUS]
WHERE  ([GP Practice Code (Derived)] <> [GP Practice Code (Original Data)]
and [Hospital Provider Spell No] NOT IN ('') --Removes rows with no spellID due to confidentiality
and [Last Episode in Spell Indicator] = 1) -- DischargeEpisode, want to link directly to the spells table 1:1

or([Patient Postcode Derived PCT] <> [Organisation Code (PCT of Residence)]
and [Hospital Provider Spell No] NOT IN ('')
and [Last Episode in Spell Indicator] = 1)


