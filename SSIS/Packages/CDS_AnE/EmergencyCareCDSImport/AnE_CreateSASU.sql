USE [CDS_AnE]
GO

/****** Object:  Table [dbo].[SASU_Attendances]    Script Date: 20/06/2017 11:44:28 ******/
DROP TABLE [dbo].[SASU_Attendances]
GO

/****** Object:  Table [dbo].[SASU_Attendances]    Script Date: 20/06/2017 11:44:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[SASU_Attendances](
	[AAndEAttendanceNumber] [varchar](12) NULL,
	[LocalPatientIdentifier] [varchar](15) NULL,
	[CareGroup] [varchar](4) NULL,
	[ArrivalDate] [Datetime] NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


