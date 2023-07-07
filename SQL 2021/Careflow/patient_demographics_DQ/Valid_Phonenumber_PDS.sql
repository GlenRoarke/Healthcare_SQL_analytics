USE [HDM_Local]
GO

/****** Object:  UserDefinedFunction [dbo].[udf_HDMSQL_Valid_Phonenumber_PDS]    Script Date: 19/05/2021 11:02:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO









CREATE FUNCTION [dbo].[udf_HDMSQL_Valid_Phonenumber_PDS]
(		@TEST						AS		NVARCHAR(max)
)
RETURNS nvarchar(100)

AS
BEGIN

	DECLARE @RETURNstring varchar(100);
	SET  @RETURNstring = (
	CASE
	WHEN @TEST IS NULL THEN 'NULLPhoneNumber'
	WHEN LEN(@TEST) =0 THEN 'EMPTYSTRINGPhoneNumber'
	WHEN @TEST IN ('Not recorded','Notrecorded') THEN 'NOTRECORDEDPhoneNumber'
	WHEN @TEST LIKE '[1-9][0-9][0-9][0-9][0-9][0-9]' THEN 'Invalid-SixNumericMayNeedSTD'
	WHEN LEFT(@TEST,1) NOT IN ('+','0') THEN 'Invalid-FirstCharacterNot+Or0'
	WHEN (LEFT(@TEST,13)  LIKE '+[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
			OR LEFT(@TEST,11)  LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')THEN 'Valid-PrefixAndCoreNumberLength'
	ELSE	
			 'Invalid-DespiteValidFirstCharacter'
	END	)	
	RETURN @RETURNstring
	
END; 







GO


