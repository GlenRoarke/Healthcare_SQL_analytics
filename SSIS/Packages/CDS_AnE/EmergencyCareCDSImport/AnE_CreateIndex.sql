
USE [CDS_AnE]

CREATE NONCLUSTERED INDEX [IX_Import_id] ON extract ([Import_id]);
CREATE NONCLUSTERED INDEX [IX_MostRecent_Flag] ON extract ([MostRecent_Flag]);
CREATE NONCLUSTERED INDEX [IX_CDS UniqueIdentifier] ON extract ([CDS UniqueIdentifier]);
CREATE NONCLUSTERED INDEX [IX_CDS Extract Date] ON extract ([CDS Extract Date]);
CREATE NONCLUSTERED INDEX [IX_CDS Extract Time] ON extract ([CDS Extract Time]);
CREATE NONCLUSTERED INDEX [IX_CDS ReportPeriod StartDate] ON extract ([CDS ReportPeriod StartDate]);
CREATE NONCLUSTERED INDEX [IX_CDS ReportPeriod EndDate] ON extract ([CDS ReportPeriod EndDate]);
CREATE NONCLUSTERED INDEX [IX_CDS ActivityDate] ON extract ([CDS ActivityDate]);
CREATE NONCLUSTERED INDEX [IX_LocalPatientIdentifier] ON extract ([LocalPatientIdentifier]);
CREATE NONCLUSTERED INDEX [IX_NHSNumber] ON extract ([NHSNumber]);
CREATE NONCLUSTERED INDEX [IX_NHSNumberStatusIndicatorCode] ON extract ([NHSNumberStatusIndicatorCode]);
CREATE NONCLUSTERED INDEX [IX_PostcodeOfUsualAddress] ON extract ([PostcodeOfUsualAddress]);
CREATE NONCLUSTERED INDEX [IX_OrganisationCode_ResidenceResponsibility] ON extract ([OrganisationCode_ResidenceResponsibility]);
CREATE NONCLUSTERED INDEX [IX_PersonBirthDate] ON extract ([PersonBirthDate]);
CREATE NONCLUSTERED INDEX [IX_EthnicCategory] ON extract ([EthnicCategory]);
CREATE NONCLUSTERED INDEX [IX_GeneralMedicalPractitioner_Specified] ON extract ([GeneralMedicalPractitioner_Specified]);
CREATE NONCLUSTERED INDEX [IX_GeneralPractice_PatientRegistration] ON extract ([GeneralPractice_PatientRegistration]);
CREATE NONCLUSTERED INDEX [IX_SiteCodeOfTreatment] ON extract ([SiteCodeOfTreatment]);
CREATE NONCLUSTERED INDEX [IX_AAndEAttendanceNumber] ON extract ([AAndEAttendanceNumber]);
CREATE NONCLUSTERED INDEX [IX_AAndEArrivalModeCode] ON extract ([AAndEArrivalModeCode]);
CREATE NONCLUSTERED INDEX [IX_AAndEAttendanceDisposalCode] ON extract ([AAndEAttendanceDisposalCode]);
CREATE NONCLUSTERED INDEX [IX_ArrivalDate] ON extract ([ArrivalDate]);
CREATE NONCLUSTERED INDEX [IX_ArrivalTimeAtAAndE] ON extract ([ArrivalTimeAtAAndE]);
CREATE NONCLUSTERED INDEX [IX_AAndEInitialAssessmentDate] ON extract ([AAndEInitialAssessmentDate]);
CREATE NONCLUSTERED INDEX [IX_AAndEInitialAssessmentTime] ON extract ([AAndEInitialAssessmentTime]);
CREATE NONCLUSTERED INDEX [IX_AAndEDateSeenForTreatment] ON extract ([AAndEDateSeenForTreatment]);
CREATE NONCLUSTERED INDEX [IX_AAndETimeSeenForTreatment] ON extract ([AAndETimeSeenForTreatment]);
CREATE NONCLUSTERED INDEX [IX_AAndEAttendanceConclusionDate] ON extract ([AAndEAttendanceConclusionDate]);
CREATE NONCLUSTERED INDEX [IX_AAndEAttendanceConclusionTime] ON extract ([AAndEAttendanceConclusionTime]);
CREATE NONCLUSTERED INDEX [IX_AAndEDepartureDate] ON extract ([AAndEDepartureDate]);
CREATE NONCLUSTERED INDEX [IX_AAndEDepartureTime] ON extract ([AAndEDepartureTime]);
CREATE NONCLUSTERED INDEX [IX_OrganisationCode_CodeOfCommissioner] ON extract ([OrganisationCode_CodeOfCommissioner]);
CREATE NONCLUSTERED INDEX [IX_AAndEStaffMemberCode] ON extract ([AAndEStaffMemberCode]);
CREATE NONCLUSTERED INDEX [IX_PrimaryDiagnosis_AAndE] ON extract ([PrimaryDiagnosis_AAndE]);
CREATE NONCLUSTERED INDEX [IX_PrimaryInvestigation_AAndE] ON extract ([PrimaryInvestigation_AAndE]);
CREATE NONCLUSTERED INDEX [IX_PrimaryTreatment_AAndE] ON extract ([PrimaryTreatment_AAndE]);



