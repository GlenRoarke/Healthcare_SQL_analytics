Declare @StartDate as nvarchar(10)
Declare @EndDate as nvarchar(19)



Set @StartDate = '2021-10-01' -- enter start date format yyyy-mm-dd
Set @EndDate = '2021-10-31 23:59:59' -- enter end date format yyyy-mm-dd 23:59:59


Select distinct
case
when a.CareLocationID not in ('ED506929-5FAC-4B2D-A272-721B161EC63F','C2B4C5DF-0987-4BA7-ABF7-FDB06DB107AF') then a1.LocalID
else a.HospitalID
end as HospitalID
,a.Surname
,a.Forename
,cast(a.DOB as smalldatetime) as [DateOfBirth]
,a.Postcode
,cast(b.LMP as smalldatetime) as [DateOfLMP]
,cast(a.ReferralDate as smalldatetime) as [DateOfReferral]
,cast((DateAdd(dd,0,DateDiff(dd,0,a.BookingDate))) as smalldatetime) as [BookingDate]
,cast(a.AgreedEDD as smalldatetime) as [FinalDueDate]
,e.ParaBeforeDelivery as [ParityAtBooking]
,case
when e.IntendedLocationOfDelivery = 'Princess Royal Hospital, Haywards Heath' then 'PRH'
when e.IntendedLocationOfDelivery = 'Princess Royal, Haywards Heath' then 'PRH'
when e.IntendedLocationOfDelivery = 'Royal Sussex County Hospital' then 'RSCH'
when c.LocationName = 'Princess Royal Hospital, Haywards Heath' then 'PRH'
when c.LocationName = 'Royal Sussex County Hospital' then 'RSCH'
else 'RSCH'
end as [IntendedResponsibleHospital]
,e.IntendedPlaceOfBirthDisplay as [IntendedDeliveryPlace]
,e.GestationAtBooking as [Weeks]
,case
when e.GestationAtBooking <= 12 then '<12 weeks'
when e.GestationAtBooking >= 28 then 'exclude'
when e.GestationAtBooking > 12 then '>12 weeks'
end as [Outcome]
,cast(DateAdd(m,DateDiff(m,0,a.BookingDate),0) as smalldatetime) as [Month]
,case
when e.GestationAtBooking <= 10 then '<10 weeks'
when e.GestationAtBooking >= 28 then 'exclude'
when e.GestationAtBooking > 10 then '>10 weeks'
end as [10WkOutcome]
,d.[EthnicCategoryMother] as [EthnicOrigin]
,b.ReasonBookedLate
,f.Smoker_AtBooking as [SmokerAtBooking]

From BNet_DSS_Reporting.bnf_dbsync.UKMat_Mother_PatientIndex as a with(nolock)
left join (
Select EntityID
,LocalID
From BNet_DSS_Reporting.bnf_dbsync.UKMat_Mother_DIGN_LocalIdentifier with(nolock)
Where LocationID in ('ED506929-5FAC-4B2D-A272-721B161EC63F','C2B4C5DF-0987-4BA7-ABF7-FDB06DB107AF')
Group By EntityID
,LocalID
) as a1 on a.EntityID = a1.EntityID -- advised by Lauren Cottrell at Badgernet 16/09/2021 to get our hospital number instead of another Trust's
inner join BNet_DSS_Reporting.bnf_dbsync.UKMat_Mother_DIGE_CurrentPregnancyDetails as b with(nolock) on a.EntityID = b.EntityID
inner join BNet_DSS_Reporting.bnf_dbsync.CareLocations as c with(nolock) on a.CareLocationID = c.EntityID
inner join BNet_DSS_Reporting.bnf_dbsync.UKMat_Mother_DIGE_Registration_MothersDetails as d with(nolock) on a.EntityID = d.EntityID
inner join BNet_DSS_Reporting.bnf_dbsync.UKMat_Mother_DerivedFields as e with(nolock) on a.EntityID = e.EntityID
inner join BNet_DSS_Reporting.bnf_dbsync.UKMat_Mother_DIGE_HealthHistory_Mother as f with(nolock) on a.EntityID = f.EntityID



Where a.EpisodeType = 'pregnancy'
and a.BookingDate between @StartDate and @EndDate



Order By [BookingDate]