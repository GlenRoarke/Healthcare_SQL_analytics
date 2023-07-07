-- =============================================
/* --IP Deliveries Live Import
-- Purpose: To insert data from badgernet into HDM_Local for maternity tails deliveries data source.
			Duplication occurs on somw records due to one too many relationship of source data and twins
			Where clauses have been provide by Julie Jenkins who is the Lead Maternity Analyst
-- Created: 04/08/2021
-- Created By: Glen Roarke
-- Updates: Add in badgernet ID & Identity column for table
			Add in sub query to remove Patient IDs from other organisations e.g X1234456
			
			14/01/2022
			**A new version is required due to new SQL Sever being used [BNet_DSS_Reporting]
			1) Removing [UKMat_Mother_MSDS] as it is now null in the upgrade, removing the table does work and data is reproduced.
			2) Add in Sub Query for Previous live, still and lost pregnacies to replace UKMat_Mother_MSDS data items
			3)Left join for UKMat_Baby_PatientIndex to UKMat_Mother_PatientIndex 
			 bpi.MotherAndBabyLinked is not null
			This is because babies who are not kept by the mother will now have an N so should still be included
			4) Change cds previous pregancies so they add up correctly. There is more previous pregancies in the the notes table than the CDS table.
*/
-- =============================================
SELECT mpi.BadgerID
-->>>> follows generic feeds schema 
	,cast (mcds.[EntityID] as nvarchar(36))[EntityID] --IP_DEL_EXTERNAL_ID --this must be unique
       ,mda.[PASAdmissionAccount]  --IP_SPELL_ID
	   ,getdate() [CREATE_DTTM]
       --,getdate() [MODIF_DTTM]
	   ,'RXH' [TRUST_ID]
	  ,mda.[AdmissionID] --IP_EPISODE_ID not sure if episode PAS infor is here yet
      
      ,case    
       when mpi.CareLocationID not in ('ED506929-5FAC-4B2D-A272-721B161EC63F','C2B4C5DF-0987-4BA7-ABF7-FDB06DB107AF') then a1.LocalID --RSCH and PRH sites
       else mpi.HospitalID
       end as HospitalID
                                         
	  ,(pb.PreviousPregnancyLivebirths + pb.PreviousPregnancyStillbirths + pb.PreviousPregnancyLosses) [PreviousPregnancies]
	  ,mcds.NumberOfBabies
	  ,mcds.DateOfFirstAntenatalAssessment
	  ,mcds.RegisteredGPCode --NULL in current
	  ,mcds.GPPracticeCode -- NULL in current 
	  ,''  [EXP_CONF_DTTM] -- Not found yet 
	  ,''  [MATLMP_ID] -- Not found yet 
	  ,mcds.IntendedLocationOfBirth --DELIVERYPLACEI_ID
	  ,mcds.IntendedLocationOfBirthOutput
	  ,mcds.ActualDeliveryLocation --DELIVERYPLACEA_ID
	  ,mcds.ActualDeliveryLocationOutput
	  ,mcds.ReasonForChangeInIntendedLocation --DELCHGRSN_ID
	  ,mcds.ReasonForChangeInIntendedLocationOutput
	  ,pb.PreviousPregnancyLivebirths  --msds.[PreviousPregnancyLivebirths] --NUM_PLIVE Currently Null but Julie does have live birth. Lack of DM could be an issue 
	  ,pb.PreviousPregnancyStillbirths  -- msds.[PreviousPregnancyStillbirths] --NUM_PSTILL 
	  ,pb.PreviousPregnancyLosses --msds.[PreviousPregnancyLosses] --NUM_PABOR  
	  ,null [NUM_PNEDE]
	  ,mcds.Admission1Gestation_Weeks --GEST_LEN
	  ,mcds.OnsetOfLabourCode --LABON_ID
	  ,mcds.OnsetOfLabour --Not in feed just desc
	  ,mdf.[LabourTotal_Minutes] --LAB_LEN
	  ,[Smoker_InTheTwelveMonthsBeforeConception]  --SMOKE12_ID
	  ,[Smoker_AtBooking] --SMOKEBK_ID
	  ,null [SMOKEDL_ID]  --SMOKEDL_ID
	  ,AnaestheticGivenDuringLabour --LABANAE_ID
	  ,null [LABARSN_ID] 
	  ,null [DELANAE_ID]
      ,null [DELARSN_ID]
	 ,mcds.AnaestheticGivenPostLabour --PSTANAE_ID
     ,mcds.AnaestheticGivenPostLabourOutput --PSTARSN_ID
	 ,null  [DELIVBY_ID]
	 ,mpi.DateOfDelivery  --[DELIV_DTTM] --this is only avaiable from the Baby side of the data
	 ,mdf.ParaBeforeDelivery--Parity
	 ,mdf.Para
	 ,Gravida
--other data that helps with analysis and linkage
	,mpi.[EpisodeType]
      ,mpi.[PregnancyStatus]
	  ,mcds.[AdmissionDate] -- could be another fuzzy logic with wider date range
	  ,mda.PASRoom
	  ,bpi.outcome
      ,DateDiff(dd,mda.Admitted,bpi.DOB) [AdmissionDOB_DateDiff]
	  ,mda.Admitted
	  ,bpi.DOB

From          [BNet_DSS_Reporting].bnf_dbsync.UKMat_Mother_PatientIndex as mpi with(nolock)
--this ensures only local Pas IDs occur
left join     (
                     Select        EntityID
                                         ,LocalID
                     From          [BNet_DSS_Reporting].bnf_dbsync.UKMat_Mother_DIGN_LocalIdentifier with(nolock)
                     Where         LocationID in ('ED506929-5FAC-4B2D-A272-721B161EC63F','C2B4C5DF-0987-4BA7-ABF7-FDB06DB107AF') --RSCH and PRH sites
                     Group By      EntityID
                                         ,LocalID
                     ) as a1 on mpi.EntityID = a1.EntityID   --Mother Patient Index
INNER JOIN [BNet_DSS_Reporting].[bnf_dbsync].[UKMat_CDS_Mother] mcds on mcds.[EntityID] = mpi.[EntityID] -- CDS table with national look ups
INNER JOIN [BNet_DSS_Reporting].bnf_dbsync.UKMat_Mother_DerivedFields as mdf with(nolock) on mcds.EntityID = mdf.EntityID -- Derived information such as labour wait
INNER JOIN [BNet_DSS_Reporting].bnf_dbsync.UKMat_Mother_DIGE_LabourAndDelivery as mld on mld.EntityID = mpi.EntityID 
INNER JOIN [BNet_DSS_Reporting].bnf_dbsync.UKMat_Mother_DIGE_HealthHistory_Mother as mhh with(nolock) on mld.EntityID = mhh.EntityID --Smoking information 
LEFT JOIN  [BNet_DSS_Reporting].[bnf_dbsync].[UKMat_Mother_DIGN_Admission] as mda with(nolock) on mda.EntityID = mpi.EntityID -- admission notes one too many
LEFT JOIN [BNet_DSS_Reporting].bnf_dbsync.UKMat_Baby_PatientIndex as bpi with(nolock) on mpi.EntityID = bpi.MotherEntityID -- ?????are we only interested in Mothers linked to babies this could artifically improve the mother linked to baby issue in CDS artifically
--this joinage follows the diagrams provided by badger net in the documentation

LEFT JOIN (
--This sub query sums up the previous pregnacies for live births, still births and losses ('mole','miscarriage','top','ectopic')
Select		sub.EntityID
			,SUM (LiveBaby1 + LiveBaby2 + LiveBaby3 + LiveBaby4 + LiveBaby5 + LiveBaby6 + LiveBaby7 + LiveBaby8 + LiveBaby9 ) [PreviousPregnancyLivebirths]
			,SUM (Baby1 + Baby2 + Baby3 + Baby4 + Baby5 + Baby6 + Baby7 + Baby8 + Baby9) as [PreviousPregnancyStillbirths]
			,SUM (LossBaby1 + LossBaby2 + LossBaby3 + LossBaby4 + LossBaby5 + LossBaby6 + LossBaby7 + LossBaby8 + LossBaby9 )[PreviousPregnancyLosses]
			
From	( --Sums the values of each repeating unit per entity id
	Select		EntityID  
      				,sum(case when [PreviousBaby1_Outcome] = 'stillbirth' then 1 else 0 end) as Baby1 
					,sum(case when [PreviousBaby2_Outcome] = 'stillbirth' then 1 else 0 end) as Baby2
					,sum(case when [PreviousBaby3_Outcome] = 'stillbirth' then 1 else 0 end) as Baby3
					,sum(case when [PreviousBaby4_Outcome] = 'stillbirth' then 1 else 0 end) as Baby4
					,sum(case when [PreviousBaby5_Outcome] = 'stillbirth' then 1 else 0 end) as Baby5
					,sum(case when [PreviousBaby6_Outcome] = 'stillbirth' then 1 else 0 end) as Baby6
					,sum(case when [PreviousBaby7_Outcome] = 'stillbirth' then 1 else 0 end) as Baby7
					,sum(case when [PreviousBaby8_Outcome] = 'stillbirth' then 1 else 0 end) as Baby8
					,sum(case when [PreviousBaby9_Outcome] = 'stillbirth' then 1 else 0 end) as Baby9
					
					,sum(case when [PreviousBaby1_Outcome] = 'livebirth' then 1 else 0 end) as LiveBaby1
					,sum(case when [PreviousBaby2_Outcome] = 'livebirth' then 1 else 0 end) as LiveBaby2
					,sum(case when [PreviousBaby3_Outcome] = 'livebirth' then 1 else 0 end) as LiveBaby3
					,sum(case when [PreviousBaby4_Outcome] = 'livebirth' then 1 else 0 end) as LiveBaby4
					,sum(case when [PreviousBaby5_Outcome] = 'livebirth' then 1 else 0 end) as LiveBaby5
					,sum(case when [PreviousBaby6_Outcome] = 'livebirth' then 1 else 0 end) as LiveBaby6
					,sum(case when [PreviousBaby7_Outcome] = 'livebirth' then 1 else 0 end) as LiveBaby7
					,sum(case when [PreviousBaby8_Outcome] = 'livebirth' then 1 else 0 end) as LiveBaby8
					,sum(case when [PreviousBaby9_Outcome] = 'livebirth' then 1 else 0 end) as LiveBaby9
					
					,sum(case when [PreviousBaby1_Outcome] IN ('mole','miscarriage','top','ectopic')  then 1 else 0 end) as LossBaby1
					,sum(case when [PreviousBaby2_Outcome] IN ('mole','miscarriage','top','ectopic') then 1 else 0 end) as LossBaby2
					,sum(case when [PreviousBaby3_Outcome] IN ('mole','miscarriage','top','ectopic') then 1 else 0 end) as LossBaby3
					,sum(case when [PreviousBaby4_Outcome] IN ('mole','miscarriage','top','ectopic') then 1 else 0 end) as LossBaby4
					,sum(case when [PreviousBaby5_Outcome] IN ('mole','miscarriage','top','ectopic')then 1 else 0 end) as LossBaby5
					,sum(case when [PreviousBaby6_Outcome] IN ('mole','miscarriage','top','ectopic') then 1 else 0 end) as LossBaby6
					,sum(case when [PreviousBaby7_Outcome] IN ('mole','miscarriage','top','ectopic') then 1 else 0 end) as LossBaby7
					,sum(case when [PreviousBaby8_Outcome] IN ('mole','miscarriage','top','ectopic') then 1 else 0 end) as LossBaby8
					,sum(case when [PreviousBaby9_Outcome] IN ('mole','miscarriage','top','ectopic') then 1 else 0 end) as LossBaby9

		From		BNet_DSS_Reporting.bnf_dbsync.UKMat_Mother_DIGN_PreviousPregnancy as a with(nolock)

		Group By	EntityID
		) as sub
		Group By	EntityID	
		) pb on mpi.EntityID = pb.EntityID -- Joined back to main patient index

WHERE (mda.PASRoom in ('L13','BOLCDU') or mda.PASRoom like 'HOME%') --locations that are maternity
and (bpi.Outcome = 'Livebirth' or bpi.Outcome like '%stillbirth%') --live or still birth outcomes
-- PASAdmissionAccount is null
and mda.Admitted <= bpi.DOB
and DateDiff(dd,mda.Admitted,bpi.DOB) <= 1 --4 date of birth 4 days after admission date???? There are admission not linked to births in the table
--these where clauses from Julie Jenkins
and bpi.MotherAndBabyLinked is not null --as per Julie Jenkins instructions

ORDER BY BadgerID asc 