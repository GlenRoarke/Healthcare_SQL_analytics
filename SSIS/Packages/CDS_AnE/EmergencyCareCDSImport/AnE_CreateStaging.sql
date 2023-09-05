USE [CDS_AnE]
GO

ALTER TABLE [dbo].[Staging] DROP CONSTRAINT [DF__Staging__MostRec__5812160E]
GO

/****** Object:  Table [dbo].[Staging]    Script Date: 20/06/2017 11:46:07 ******/
DROP TABLE [dbo].[Staging]
GO

/****** Object:  Table [dbo].[Staging]    Script Date: 20/06/2017 11:46:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[Staging](
	[Import_id] [int] NOT NULL,
	[MostRecent_Flag] [bit] NULL,
	[CDS Message Type] [varchar](6) NULL,
	[CDS Message Version Number] [varchar](8) NULL,
	[CDS Message Reference] [varchar](14) NULL,
	[CDS Record Identifier] [varchar](35) NULL,
	[CDS TypeCode] [varchar](3) NULL,
	[CDS ProtocolIdentifierCode] [varchar](3) NULL,
	[CDS UniqueIdentifier] [varchar](35) NULL,
	[CDS BulkReplacementGroupCode] [varchar](3) NULL,
	[CDS Extract Date] [varchar](10) NULL,
	[CDS Extract Time] [varchar](17) NULL,
	[CDS ReportPeriod StartDate] [varchar](10) NULL,
	[CDS ReportPeriod EndDate] [varchar](10) NULL,
	[CDS ActivityDate] [varchar](10) NULL,
	[OrganisationCode_CDSSenderIdentity] [varchar](5) NULL,
	[OrganisationCode_CDSPrimeRecipientIdentity] [varchar](5) NULL,
	[OrganisationCode_CDSCopyRecipientIdentity_1] [varchar](5) NULL,
	[OrganisationCode_CDSCopyRecipientIdentity_2] [varchar](5) NULL,
	[OrganisationCode_CDSCopyRecipientIdentity_3] [varchar](5) NULL,
	[OrganisationCode_CDSCopyRecipientIdentity_4] [varchar](5) NULL,
	[OrganisationCode_CDSCopyRecipientIdentity_5] [varchar](5) NULL,
	[OrganisationCode_CDSCopyRecipientIdentity_6] [varchar](5) NULL,
	[OrganisationCode_CDSCopyRecipientIdentity_7] [varchar](5) NULL,
	[UniqueBookingReferenceNumber_Converted] [varchar](12) NULL,
	[PatientPathwayIdentifier] [varchar](20) NULL,
	[OrganisationCode_PatientPathwayIdentifierIssuer] [varchar](6) NULL,
	[ReferralToTreatmentPeriod_Status] [varchar](2) NULL,
	[WaitingTimeMeasurementType] [varchar](2) NULL,
	[ReferralToTreatmentPeriod_StartDate] [varchar](10) NULL,
	[ReferralToTreatmentPeriod_EndDate] [varchar](10) NULL,
	[LocalPatientIdentifier] [varchar](19) NULL,
	[OrganisationCode_LocalPatientIdentifier] [varchar](5) NULL,
	[NHSNumber] [varchar](10) NULL,
	[NHSNumberStatusIndicatorCode] [varchar](2) NULL,
	[PersonFullName] [varchar](70) NULL,
	[PersonTitle] [varchar](35) NULL,
	[PersonGivenName] [varchar](35) NULL,
	[PersonFamilyName] [varchar](35) NULL,
	[PersonNameSuffix] [varchar](35) NULL,
	[PersonInititials] [varchar](35) NULL,
	[PersonRequestedName] [varchar](70) NULL,
	[UnstructuredAddress] [varchar](175) NULL,
	[StructuredAddressLine_1] [varchar](35) NULL,
	[StructuredAddressLine_2] [varchar](35) NULL,
	[StructuredAddressLine_3] [varchar](35) NULL,
	[StructuredAddressLine_4] [varchar](35) NULL,
	[StructuredAddressLine_5] [varchar](35) NULL,
	[PostcodeOfUsualAddress] [varchar](8) NULL,
	[OrganisationCode_ResidenceResponsibility] [varchar](3) NULL,
	[WithheldIdentityReason] [varchar](2) NULL,
	[PersonBirthDate] [varchar](10) NULL,
	[PersonGenderCodeCurrent] [varchar](1) NULL,
	[CarerSupportIndicator] [varchar](2) NULL,
	[EthnicCategory] [varchar](2) NULL,
	[GeneralMedicalPractitioner_Specified] [varchar](8) NULL,
	[GeneralPractice_PatientRegistration] [varchar](6) NULL,
	[SiteCodeOfTreatment] [varchar](9) NULL,
	[AAndEAttendanceNumber] [varchar](12) NULL,
	[AAndEArrivalModeCode] [varchar](1) NULL,
	[AAndEAttendanceCategoryCode] [varchar](1) NULL,
	[AAndEAttendanceDisposalCode] [varchar](2) NULL,
	[AAndEIncidentLocationType] [varchar](2) NULL,
	[AAndEPatientGroup] [varchar](2) NULL,
	[SourceOfReferralForAAndE] [varchar](2) NULL,
	[AAndEDepartmentType] [varchar](2) NULL,
	[ArrivalDate] [varchar](10) NULL,
	[ArrivalTimeAtAAndE] [varchar](17) NULL,
	[AgeAtCDSActivityDate] [varchar](3) NULL,
	[OverseasVisitorStatusClassificationAtCDSActivityDate] [varchar](1) NULL,
	[AAndEInitialAssessmentDate] [varchar](10) NULL,
	[AAndEInitialAssessmentTime] [varchar](17) NULL,
	[AAndEDateSeenForTreatment] [varchar](10) NULL,
	[AAndETimeSeenForTreatment] [varchar](17) NULL,
	[AAndEAttendanceConclusionDate] [varchar](10) NULL,
	[AAndEAttendanceConclusionTime] [varchar](17) NULL,
	[AAndEDepartureDate] [varchar](10) NULL,
	[AAndEDepartureTime] [varchar](17) NULL,
	[AmbulanceIncidentNumber] [varchar](20) NULL,
	[ORGANISATION CODE (CONVEYING AMBULANCE TRUST)] [varchar](3) NULL,
	[CommissioningSerialNumber] [varchar](6) NULL,
	[NHSServiceAgreementLineNumber] [varchar](10) NULL,
	[ProviderReferenceNumber] [varchar](17) NULL,
	[CommissionerReferenceNumber] [varchar](17) NULL,
	[OrganisationCode_CodeOfProvider] [varchar](5) NULL,
	[OrganisationCode_CodeOfCommissioner] [varchar](5) NULL,
	[AAndEStaffMemberCode] [varchar](3) NULL,
	[DiagnosisSchemeInUse_ICD] [varchar](2) NULL,
	[PrimaryDiagnosis_ICD] [varchar](6) NULL,
	[PresentOnAdmissionIndicator_ICD] [varchar](1) NULL,
	[SecondaryDiagnosis_ICD_1] [varchar](6) NULL,
	[PresentOnAdmissionIndicator_ICD_1] [varchar](1) NULL,
	[SecondaryDiagnosis_ICD_2] [varchar](6) NULL,
	[PresentOnAdmissionIndicator_ICD_2] [varchar](1) NULL,
	[SecondaryDiagnosis_ICD_3] [varchar](6) NULL,
	[PresentOnAdmissionIndicator_ICD_3] [varchar](1) NULL,
	[SecondaryDiagnosis_ICD_4] [varchar](6) NULL,
	[PresentOnAdmissionIndicator_ICD_4] [varchar](1) NULL,
	[SecondaryDiagnosis_ICD_5] [varchar](6) NULL,
	[PresentOnAdmissionIndicator_ICD_5] [varchar](1) NULL,
	[SecondaryDiagnosis_ICD_6] [varchar](6) NULL,
	[PresentOnAdmissionIndicator_ICD_6] [varchar](1) NULL,
	[SecondaryDiagnosis_ICD_7] [varchar](6) NULL,
	[PresentOnAdmissionIndicator_ICD_7] [varchar](1) NULL,
	[SecondaryDiagnosis_ICD_8] [varchar](6) NULL,
	[PresentOnAdmissionIndicator_ICD_8] [varchar](1) NULL,
	[SecondaryDiagnosis_ICD_9] [varchar](6) NULL,
	[PresentOnAdmissionIndicator_ICD_9] [varchar](1) NULL,
	[SecondaryDiagnosis_ICD_10] [varchar](6) NULL,
	[PresentOnAdmissionIndicator_ICD_10] [varchar](1) NULL,
	[SecondaryDiagnosis_ICD_11] [varchar](6) NULL,
	[PresentOnAdmissionIndicator_ICD_11] [varchar](1) NULL,
	[SecondaryDiagnosis_ICD_12] [varchar](6) NULL,
	[PresentOnAdmissionIndicator_ICD_12] [varchar](1) NULL,
	[SecondaryDiagnosis_ICD_13] [varchar](6) NULL,
	[PresentOnAdmissionIndicator_ICD_13] [varchar](1) NULL,
	[DiagnosisSchemeInUse_READ] [varchar](2) NULL,
	[PrimaryDiagnosis_READ] [varchar](7) NULL,
	[SecondaryDiagnosis_READ_1] [varchar](7) NULL,
	[SecondaryDiagnosis_READ_2] [varchar](7) NULL,
	[SecondaryDiagnosis_READ_3] [varchar](7) NULL,
	[SecondaryDiagnosis_READ_4] [varchar](7) NULL,
	[SecondaryDiagnosis_READ_5] [varchar](7) NULL,
	[SecondaryDiagnosis_READ_6] [varchar](7) NULL,
	[SecondaryDiagnosis_READ_7] [varchar](7) NULL,
	[SecondaryDiagnosis_READ_8] [varchar](7) NULL,
	[SecondaryDiagnosis_READ_9] [varchar](7) NULL,
	[SecondaryDiagnosis_READ_10] [varchar](7) NULL,
	[SecondaryDiagnosis_READ_11] [varchar](7) NULL,
	[SecondaryDiagnosis_READ_12] [varchar](7) NULL,
	[SecondaryDiagnosis_READ_13] [varchar](7) NULL,
	[DiagnosisSchemeInUse] [varchar](2) NULL,
	[PrimaryDiagnosis_AAndE] [varchar](6) NULL,
	[SecondaryDiagnosis_AAndE_1] [varchar](6) NULL,
	[SecondaryDiagnosis_AAndE_2] [varchar](6) NULL,
	[SecondaryDiagnosis_AAndE_3] [varchar](6) NULL,
	[SecondaryDiagnosis_AAndE_4] [varchar](6) NULL,
	[SecondaryDiagnosis_AAndE_5] [varchar](6) NULL,
	[SecondaryDiagnosis_AAndE_6] [varchar](6) NULL,
	[SecondaryDiagnosis_AAndE_7] [varchar](6) NULL,
	[SecondaryDiagnosis_AAndE_8] [varchar](6) NULL,
	[SecondaryDiagnosis_AAndE_9] [varchar](6) NULL,
	[SecondaryDiagnosis_AAndE_10] [varchar](6) NULL,
	[SecondaryDiagnosis_AAndE_11] [varchar](6) NULL,
	[SecondaryDiagnosis_AAndE_12] [varchar](6) NULL,
	[SecondaryDiagnosis_AAndE_13] [varchar](6) NULL,
	[InvestigationSchemeInUse] [varchar](2) NULL,
	[PrimaryInvestigation_AAndE] [varchar](6) NULL,
	[SecondaryInvestigation_AAndE_1] [varchar](6) NULL,
	[SecondaryInvestigation_AAndE_2] [varchar](6) NULL,
	[SecondaryInvestigation_AAndE_3] [varchar](6) NULL,
	[SecondaryInvestigation_AAndE_4] [varchar](6) NULL,
	[SecondaryInvestigation_AAndE_5] [varchar](6) NULL,
	[SecondaryInvestigation_AAndE_6] [varchar](6) NULL,
	[SecondaryInvestigation_AAndE_7] [varchar](6) NULL,
	[SecondaryInvestigation_AAndE_8] [varchar](6) NULL,
	[SecondaryInvestigation_AAndE_9] [varchar](6) NULL,
	[SecondaryInvestigation_AAndE_10] [varchar](6) NULL,
	[SecondaryInvestigation_AAndE_11] [varchar](6) NULL,
	[ProcedureSchemeInUse_OPCS] [varchar](2) NULL,
	[PrimaryProcedure_OPCS] [varchar](4) NULL,
	[PrimaryProcedureDate_OPCS] [varchar](10) NULL,
	[ProfessionalRegistrationIssuerCode_OPCS] [varchar](2) NULL,
	[ProfessionalRegistrationEntryIdentifier_OPCS] [varchar](12) NULL,
	[ProfessionalRegistrationIssuerCode_OPCS1] [varchar](2) NULL,
	[ProfessionalRegistrationEntryIdentifier (2nd/Anaes)_OPCS] [varchar](12) NULL,
	[SecondaryProcedure_OPCS_1] [varchar](4) NULL,
	[ProcedureDate_OPCS_1] [varchar](10) NULL,
	[ProfessionalRegistrationIssuerCode_OPCS_1] [varchar](2) NULL,
	[ProfessionalRegistrationEntryIdentifier_OPCS_1] [varchar](12) NULL,
	[ProfessionalRegistrationIssuerCode_OPCS_1_1] [varchar](2) NULL,
	[ProfessionalRegistrationEntryIdentifier (2nd)/Anaes_OPCS_1] [varchar](12) NULL,
	[SecondaryProcedure_OPCS_2] [varchar](4) NULL,
	[ProcedureDate_OPCS_2] [varchar](10) NULL,
	[ProfessionalRegistrationIssuerCode_OPCS_2] [varchar](2) NULL,
	[ProfessionalRegistrationEntryIdentifier_OPCS_2] [varchar](12) NULL,
	[ProfessionalRegistrationIssuerCode_OPCS_2_2] [varchar](2) NULL,
	[ProfessionalRegistrationEntryIdentifier (2nd)/Anaes_OPCS_2] [varchar](12) NULL,
	[SecondaryProcedure_OPCS_3] [varchar](4) NULL,
	[ProcedureDate_OPCS_3] [varchar](10) NULL,
	[ProfessionalRegistrationIssuerCode_OPCS_3] [varchar](2) NULL,
	[ProfessionalRegistrationEntryIdentifier_OPCS_3] [varchar](12) NULL,
	[ProfessionalRegistrationIssuerCode_OPCS_3_1] [varchar](2) NULL,
	[ProfessionalRegistrationEntryIdentifier (2nd)/Anaes_OPCS_3] [varchar](12) NULL,
	[SecondaryProcedure_OPCS_4] [varchar](4) NULL,
	[ProcedureDate_OPCS_4] [varchar](10) NULL,
	[ProfessionalRegistrationIssuerCode_OPCS_4] [varchar](2) NULL,
	[ProfessionalRegistrationEntryIdentifier_OPCS_4] [varchar](12) NULL,
	[ProfessionalRegistrationIssuerCode_OPCS_4_1] [varchar](2) NULL,
	[ProfessionalRegistrationEntryIdentifier (2nd)/Anaes_OPCS_4] [varchar](12) NULL,
	[SecondaryProcedure_OPCS_5] [varchar](4) NULL,
	[ProcedureDate_OPCS_5] [varchar](10) NULL,
	[ProfessionalRegistrationIssuerCode_OPCS_5] [varchar](2) NULL,
	[ProfessionalRegistrationEntryIdentifier_OPCS_5] [varchar](12) NULL,
	[ProfessionalRegistrationIssuerCode_OPCS_5_1] [varchar](2) NULL,
	[ProfessionalRegistrationEntryIdentifier (2nd)/Anaes_OPCS_5] [varchar](12) NULL,
	[SecondaryProcedure_OPCS_6] [varchar](4) NULL,
	[ProcedureDate_OPCS_6] [varchar](10) NULL,
	[ProfessionalRegistrationIssuerCode_OPCS_6] [varchar](2) NULL,
	[ProfessionalRegistrationEntryIdentifier_OPCS_6] [varchar](12) NULL,
	[ProfessionalRegistrationIssuerCode_OPCS_6_1] [varchar](2) NULL,
	[ProfessionalRegistrationEntryIdentifier (2nd)/Anaes_OPCS_6] [varchar](12) NULL,
	[SecondaryProcedure_OPCS_7] [varchar](4) NULL,
	[ProcedureDate_OPCS_7] [varchar](10) NULL,
	[ProfessionalRegistrationIssuerCode_OPCS_7] [varchar](2) NULL,
	[ProfessionalRegistrationEntryIdentifier_OPCS_7] [varchar](12) NULL,
	[ProfessionalRegistrationIssuerCode_OPCS_7_1] [varchar](2) NULL,
	[ProfessionalRegistrationEntryIdentifier (2nd)/Anaes_OPCS_7] [varchar](12) NULL,
	[SecondaryProcedure_OPCS_8] [varchar](4) NULL,
	[ProcedureDate_OPCS_8] [varchar](10) NULL,
	[ProfessionalRegistrationIssuerCode_OPCS_8] [varchar](2) NULL,
	[ProfessionalRegistrationEntryIdentifier_OPCS_8] [varchar](12) NULL,
	[ProfessionalRegistrationIssuerCode_OPCS_8_1] [varchar](2) NULL,
	[ProfessionalRegistrationEntryIdentifier (2nd)/Anaes_OPCS_8] [varchar](12) NULL,
	[SecondaryProcedure_OPCS_9] [varchar](4) NULL,
	[ProcedureDate_OPCS_9] [varchar](10) NULL,
	[ProfessionalRegistrationIssuerCode_OPCS_9] [varchar](2) NULL,
	[ProfessionalRegistrationEntryIdentifier_OPCS_9] [varchar](12) NULL,
	[ProfessionalRegistrationIssuerCode_OPCS_9_1] [varchar](2) NULL,
	[ProfessionalRegistrationEntryIdentifier (2nd)/Anaes_OPCS_9] [varchar](12) NULL,
	[SecondaryProcedure_OPCS_10] [varchar](4) NULL,
	[ProcedureDate_OPCS_10] [varchar](10) NULL,
	[ProfessionalRegistrationIssuerCode_OPCS_10] [varchar](2) NULL,
	[ProfessionalRegistrationEntryIdentifier_OPCS_10] [varchar](12) NULL,
	[ProfessionalRegistrationIssuerCode_OPCS_10_1] [varchar](2) NULL,
	[ProfessionalRegistrationEntryIdentifier (2nd)/Anaes_OPCS_10] [varchar](12) NULL,
	[SecondaryProcedure_OPCS_11] [varchar](4) NULL,
	[ProcedureDate_OPCS_11] [varchar](10) NULL,
	[ProfessionalRegistrationIssuerCode_OPCS_11] [varchar](2) NULL,
	[ProfessionalRegistrationEntryIdentifier_OPCS_11] [varchar](12) NULL,
	[ProfessionalRegistrationIssuerCode_OPCS_11_1] [varchar](2) NULL,
	[ProfessionalRegistrationEntryIdentifier (2nd)/Anaes_OPCS_11] [varchar](12) NULL,
	[ProcedureSchemeInUse_READ] [varchar](2) NULL,
	[PrimaryProcedure_READ] [varchar](7) NULL,
	[PrimaryProcedureDate_READ] [varchar](10) NULL,
	[SecondaryProcedure_READ_1] [varchar](7) NULL,
	[ProcedureDate_READ_1] [varchar](10) NULL,
	[SecondaryProcedure_READ_2] [varchar](7) NULL,
	[ProcedureDate_READ_2] [varchar](10) NULL,
	[SecondaryProcedure_READ_3] [varchar](7) NULL,
	[ProcedureDate_READ_3] [varchar](10) NULL,
	[SecondaryProcedure_READ_4] [varchar](7) NULL,
	[ProcedureDate_READ_4] [varchar](10) NULL,
	[SecondaryProcedure_READ_5] [varchar](7) NULL,
	[ProcedureDate_READ_5] [varchar](10) NULL,
	[SecondaryProcedure_READ_6] [varchar](7) NULL,
	[ProcedureDate_READ_6] [varchar](10) NULL,
	[SecondaryProcedure_READ_7] [varchar](7) NULL,
	[ProcedureDate_READ_7] [varchar](10) NULL,
	[SecondaryProcedure_READ_8] [varchar](7) NULL,
	[ProcedureDate_READ_8] [varchar](10) NULL,
	[SecondaryProcedure_READ_9] [varchar](7) NULL,
	[ProcedureDate_READ_9] [varchar](10) NULL,
	[SecondaryProcedure_READ_10] [varchar](7) NULL,
	[ProcedureDate_READ_10] [varchar](10) NULL,
	[SecondaryProcedure_READ_11] [varchar](7) NULL,
	[ProcedureDate_READ_11] [varchar](10) NULL,
	[ProcedureSchemeInUseTreatment] [varchar](2) NULL,
	[PrimaryTreatment_AAndE] [varchar](6) NULL,
	[PrimaryProcedureDate_AAndE] [varchar](10) NULL,
	[SecondaryTreatment_AAndE_1] [varchar](6) NULL,
	[ProcedureDate_AAndE_1] [varchar](10) NULL,
	[SecondaryTreatment_AAndE_2] [varchar](6) NULL,
	[ProcedureDate_AAndE_2] [varchar](10) NULL,
	[SecondaryTreatment_AAndE_3] [varchar](6) NULL,
	[ProcedureDate_AAndE_3] [varchar](10) NULL,
	[SecondaryTreatment_AAndE_4] [varchar](6) NULL,
	[ProcedureDate_AAndE_4] [varchar](10) NULL,
	[SecondaryTreatment_AAndE_5] [varchar](6) NULL,
	[ProcedureDate_AAndE_5] [varchar](10) NULL,
	[SecondaryTreatment_AAndE_6] [varchar](6) NULL,
	[ProcedureDate_AAndE_6] [varchar](10) NULL,
	[SecondaryTreatment_AAndE_7] [varchar](6) NULL,
	[ProcedureDate_AAndE_7] [varchar](10) NULL,
	[SecondaryTreatment_AAndE_8] [varchar](6) NULL,
	[ProcedureDate_AAndE_8] [varchar](10) NULL,
	[SecondaryTreatment_AAndE_9] [varchar](6) NULL,
	[ProcedureDate_AAndE_9] [varchar](10) NULL,
	[SecondaryTreatment_AAndE_10] [varchar](6) NULL,
	[ProcedureDate_AAndE_10] [varchar](10) NULL,
	[SecondaryTreatment_AAndE_11] [varchar](6) NULL,
	[ProcedureDate_AAndE_11] [varchar](10) NULL,
	[SecondaryDiagnosis_ICD_count] [varchar](3) NULL,
	[SecondaryDiagnosis_ICD] [varchar](6) NULL,
	[SecondaryDiagnosis_READ_count] [varchar](3) NULL,
	[SecondaryDiagnosis_READ] [varchar](7) NULL,
	[SecondaryProcedure_OPCS_count] [varchar](3) NULL,
	[SecondaryProcedure_OPCS] [varchar](14) NULL,
	[SecondaryProcedure_READ_count] [varchar](3) NULL,
	[SecondaryProcedure_READ] [varchar](17) NULL,
	[Alert_AE_Attendance_Num] [varchar](20) NULL,
	[Alert_AE_Staff_Mem_Code] [varchar](20) NULL,
	[CDS Message Reference 2] [varchar](14) NULL,
	[Oasis Attendance ID] [varchar](15) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[Staging] ADD  DEFAULT ('FALSE') FOR [MostRecent_Flag]
GO

