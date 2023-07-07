
--Coding comparison of figures


--differences in code are
--Toms
--Sub that links data via coding status of N
--the discharge episode flag is set to Y, this means the episode has to be the last in a spell
--date logic is different but not that important.

--Mine uses NULL Diagnosis ID to achieve coding status (agreed by gaynor dixon)
--Uses Not NULL spell end for only finished SPELLS (not last in the episode)


-- no partially coded in the BI 

--Corps Glens
SELECT sum(case when ipep.DIM_CODING_PRIMDIAG_ID = -1 THEN 1 ELSE 0 END) [Uncoded Episodes]
,sum(case when ipep.DIM_CODING_PRIMDIAG_ID <> -1 THEN 1 ELSE 0 END)/ convert(decimal,(count(1))) [PercentageUncoded]
--,sp.[Total Finished Episodes]
From HDM.[dbo].[FACT_IP_EPISODES] IPEP with(nolock)
--INNER JOIN hdm.dbo.FACT_IP_SPELL IPSP on IPEP.FACT_IP_SPELLS_ID = IPSP.IP_SPELL_ID --joins episode to spell, needed to link Episodes to CDS
INNER JOIN HDM.[DBO].[DIM_Patient] P with(nolock) on ipep.dim_patient_id = p.dim_patient_id
INNER JOIN HDM.[DBO].[DIM_LOOKUP_ADMIMETH] ADMM WITH(NOLOCk) ON IPEP.DIM_LOOKUP_ADMET_id = ADMM.[DIM_LOOKUP_ADMIMETH_ID] --admissionmethod elective and non elective
INNER JOIN HDM.[DBO].[DIM_LOOKUP_ADMISORC] ADMS WITH(NOLOCK) ON IPEP.DIM_LOOKUP_ADSOR_ID = ADMS.[DIM_LOOKUP_ADMISORC_ID]
INNER JOIN HDM.[DBO].[DIM_SPECIALTY] S WITH(NOLOCK) ON IPEP.DIM_SPECT_ID = S.DIM_SPECialty_ID --national specialty code
INNER JOIN HDM.dbo.DIM_CODING cd WITH(NOLOCK) on cd.DIM_CODING_ID = ipep.DIM_CODING_PRIMDIAG_ID
Where ipep.ip_episode_ID <> '-1' 
and ipep.ARCHV_FLAG = 'N'
and ipep.DISCH_DTTM between '01/04/2021 00:00:00' and getdate()--date ranges logic can be changed here for current month.
and ipep.DISCH_DTTM is not null --finished spells 
--and ipep.DIM_CODING_PRIMDIAG_ID <> -1 --coding complete flag does not indicate NULL values right now.


ORDER BY 1





--TOMs and CIU 
select
count(1)
from 
[HDM].[dbo].[FACT_IP_EPISODES] a with (nolock)
left join [HDM_Local].[Main].[CasenoteLocation] b with (nolock)
on a.DIM_PATIENT_ID = b.DIM_PATIENT_ID
--left join  --left as apparently missing casrnote volumes
----[HDM].[dbo].[FACT_CASENOTE_VOLUMES] b with (nolock)
--	(
--	select
--	*
--	,row_number() over (partition by b.CASENOTE_ID order by b.SERIAL desc) as latestVolume
--	from
--	[HDM].[dbo].[FACT_CASENOTE_VOLUMES] b with (nolock)
--	)
--b
--on a.dim_patient_id = b.DIM_PATIENT_ID
--and b.latestVolume = 1
--left join [HDM].[dbo].[DIM_SITE_SERVICE_UNIT] c with (nolock)
--on b.DIM_CURNT_SSU_ID = c.[DIM_SSU_ID]
--left join [HDM].[dbo].[DIM_SITE_SERVICE_UNIT] d with (nolock)
--on b.[DIM_CURNT_SUB_SSU_ID] = d.[DIM_SSU_ID]
inner join [HDM].[DBO].[DIM_HC_PROFESSIONAL] e with (nolock) 
on a.DIM_HCP_ID = e.DIM_HCP_ID
inner join [HDM].[dbo].[vw_DIM_PATIENT] f with (nolock)
on a.DIM_PATIENT_ID = f.DIM_PATIENT_ID
inner join [HDM].[dbo].[FACT_IP_SPELL] g with (nolock)
on a.FACT_IP_SPELLS_ID = g.IP_SPELL_ID
inner join [HDM].[dbo].[DIM_SITE_SERVICE_UNIT] h with (nolock)
on g.DIM_DIS_WARD_ID = h.[DIM_SSU_ID]
inner join [HDM].[dbo].[DIM_SPECIALTY] i with (nolock)
on a.DIM_SPECT_ID = i.DIM_SPECIALTY_ID
inner join [HDM].[dbo].[DIM_LOOKUP_DISMETH] j with (nolock)
on g.DIM_DISME_ID = j.[DIM_LOOKUP_DISMETH_ID]
left join [HDM_Local].[Reference].[Lookup_MeanIPPrices] k with (nolock)
on i.NHS_ID = k.NationalSpecialtyCode
inner join [HDM].[DBO].[DIM_LOOKUP_ADMIMETH] l with (nolock)
on a.DIM_LOOKUP_ADMET_id = l.[DIM_LOOKUP_ADMIMETH_ID]
left join
	(
	select distinct
	a.FACT_IP_SPELLS_ID
	from [HDM].[dbo].[FACT_IP_EPISODES] a with (nolock)
	where 
	a.ARCHV_FLAG = 'N'
	and a.IP_EPISODE_ID != -1
	and a.CODING_COMPLETE_FLAG = 'N'
	) suba
on a.FACT_IP_SPELLS_ID = suba.FACT_IP_SPELLS_ID

where 
a.ARCHV_FLAG = 'N'
and a.IP_EPISODE_ID != -1
--below changed 18/04/2019 so it pulls spell with a coded discharge episode but earlier uncoded episodes
and suba.FACT_IP_SPELLS_ID is not null --a.CODING_COMPLETE_FLAG = 'N'
--and a.DIS_EPI_FLAG = 'Y'
and a.DISCH_DTTM between '01/04/2021 00:00:00' and getdate()
--and a.[DIM_CODING_PRIMDIAG_ID] = -1 --might need if coding_status isn't always right



