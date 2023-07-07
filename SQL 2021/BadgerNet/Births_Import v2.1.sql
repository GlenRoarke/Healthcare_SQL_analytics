-- =============================================
/* --IP Births Live Import
-- Purpose: To insert data from badgernet into HDM_Local for maternity tails Births data source.
			Duplication occurs on some records due to one too many relationship of source data and twins
			This duplication is removed in the mapping script
			**A new version is required due to new SQL Sever being used [BNet_DSS_Reporting]
			Where clauses have been provide by Julie Jenkins who is the Lead Maternity Analyst
-- Created: 04/08/2021
-- Created By: Glen Roarke
-- Updates: Add in badgernet ID & Identity column for table, and Number of babies for indication of twins figures
			Add in sub query to remove patient ids from other organisations
			-- 14/01/2022 --
			1) Left join for UKMat_Baby_PatientIndex to UKMat_Mother_PatientIndex 
			2) bpi.MotherAndBabyLinked is not null
			This is because babies who are not kept by the mother will now have an N so should still be included

*/
-- =============================================
--Need to add in the birth number to birth data this indicates if the record is a twin or not.
SELECT bpi.BadgerID
,cast (bpi.EntityID as nvarchar(36)) [EntityID]
,getdate() CREATE_DTTM
,case    
       when mpi.CareLocationID not in ('ED506929-5FAC-4B2D-A272-721B161EC63F','C2B4C5DF-0987-4BA7-ABF7-FDB06DB107AF') then a1.LocalID --RSCH and PRH sites
       else mpi.HospitalID
       end as [Mother_PatientID]
,bpi.HospitalID [Baby_PatientID]
,bcds.[SexCode]
,bcds.[Sex]
,bpi.BabyNumber
,bcds.[BirthOrder]
,bpi.DOB
,NULL BIRTH_HCIRC
,bcds.[Birthweight]
,bcds.[DeliveryMethod]
,bpi.[GestationAtBirthWeeks]
,bcds.[DateOfDelivery]
,bcds.LiveOrStillBirthCode
,bcds.[ResuscitationMethod]
,bcds.[StatusOfPersonConductingDelivery] -- DIM_PERSTYP_ID	Status of Person Conducting Delivery
,NULL [DIM_NNLVL_ID]
,NULL [DIM_DELSTAT_ID]
,NULL [DIM_REGGMP_ID]
,NULL [INIT_BREAST_FEEDING]
,NULL [ACT_BREAST_FEEDING]
,NULL[PARENT_OCCUPATION]
,NULL [BirthLength] --Birth Length
,[ApgarScore01] 
,[ApgarScore05]
,NULL [FETUS_PRES_ID]
,NULL [EX_HIPS_ID]
,NULL [JAUNDICE_ID]
,NULL [METSCR_ID]
,bpi.FinalOutcome
,bcds.[Registerable]
,ba.[Admitted]
,ba.[PASAdmissionAccount] [PASAdmissionAccount_Baby]
,ma.PASAdmissionAccount [PASAdmissionAccount_Mother]
,mpi.BadgerID [Mother_BadgerID]
,cast(mpi.EntityID as nvarchar(36)) [Mother_EntityID]
,[NumberOfBabies]
FROM [BNet_DSS_Reporting].bnf_dbsync.UKMat_Baby_PatientIndex as bpi with(nolock)

LEFT JOIN [BNet_DSS_Reporting].bnf_dbsync.UKMat_Mother_PatientIndex as mpi with(nolock) on mpi.EntityID = bpi.MotherEntityID --not all births are linked to a mother

left join     (
                     Select        EntityID
                                         ,LocalID
                     From          [BNet_DSS_Reporting].bnf_dbsync.UKMat_Mother_DIGN_LocalIdentifier with(nolock)
                     Where         LocationID in ('ED506929-5FAC-4B2D-A272-721B161EC63F','C2B4C5DF-0987-4BA7-ABF7-FDB06DB107AF') --RSCH and PRH sites
                     Group By      EntityID
                                         ,LocalID
                     ) as a1 on mpi.EntityID = a1.EntityID   --Mother Patient Index

INNER JOIN [BNet_DSS_Reporting].[bnf_dbsync].[UKMat_CDS_Baby] as bcds with(nolock) on bcds.EntityID = bpi.EntityID
inner join	[BNet_DSS_Reporting].bnf_dbsync.UKMat_Baby_DIGE_BabyDeliveryDetails as dd with(nolock) on bpi.EntityID = dd.EntityID
left join	[BNet_DSS_Reporting].bnf_dbsync.UKMat_Baby_DerivedFields as bdf with(nolock) on bpi.EntityID = bdf.EntityID
--LEFT JOIN Bnet_DSS_Business.bnf_dbsync.UKMat_Baby_DIGN_BabyDetailedENB as bd with(nolock) on bpi.EntityID = bd.EntityID
--LEFT JOIN [Bnet_DSS_Business].[bnf_dbsync].[UKMat_Baby_DIGN_BabyMedicationAndPainRelief] as ds with(nolock) on ds.EntityID = bpi.EntityID
LEFT JOIN [BNet_DSS_Reporting].[bnf_dbsync].[UKMat_Baby_DIGN_BabyAdmission] ba with(nolock) on ba.EntityID = bpi.EntityID
LEFT JOIN [BNet_DSS_Reporting].bnf_dbsync.UKMat_Mother_DIGN_Admission as ma with(nolock) on mpi.EntityID = ma.EntityID
WHERE  (bpi.Outcome = 'Livebirth' or bpi.Outcome like '%stillbirth%') --live or still birth outcomes
--and g.PASAdmissionAccount like 'I%S'
and	(ma.PASRoom in ('L13','BOLCDU') or ma.PASRoom like 'HOME%')
and ma.Admitted <= bpi.DOB
and bpi.MotherAndBabyLinked is not null --as per julies jenkins instruction

ORDER BY  bpi.BadgerID  desc



