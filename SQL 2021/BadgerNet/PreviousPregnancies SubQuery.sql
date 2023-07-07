
--This sub query sums up the previous pregnacies for live births, still births and losses ('mole','miscarriage','top','ectopic')
--Glen Roarke 14/01/2022
LEFT JOIN (
--This sub query sums up the previous pregnacies for live births, still births and losses ('mole','miscarriage','top','ectopic')
Select		sub.EntityID
			,SUM (LiveBaby1 + LiveBaby2 + LiveBaby3 + LiveBaby4 + LiveBaby5 + LiveBaby6 + LiveBaby7 + LiveBaby8 + LiveBaby9 ) [PreviousPregnancyLivebirths]
			,sum (Baby1 + Baby2 + Baby3 + Baby4 + Baby5 + Baby6 + Baby7 + Baby8 + Baby9) as [PreviousPregnancyStillbirths]
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
		) pb on mpi.EntityID = pb.EntityID -- Joined back to main patient index if needed
