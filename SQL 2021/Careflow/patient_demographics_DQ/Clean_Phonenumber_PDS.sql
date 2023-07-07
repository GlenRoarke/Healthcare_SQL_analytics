USE [HDM_Local]
GO

/****** Object:  UserDefinedFunction [dbo].[udf_HDMSQL_Clean_Phonenumber_PDS]    Script Date: 19/05/2021 11:06:38 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






CREATE FUNCTION [dbo].[udf_HDMSQL_Clean_Phonenumber_PDS]
(		@TEST						AS		NVARCHAR(max)
)
RETURNS nvarchar(100)

AS
BEGIN
-- remove invalid characters 

	DECLARE @RETURNstring varchar(100);
	SET  @RETURNstring = 
REPLACE(
REPLACE(
REPLACE(
REPLACE(
REPLACE(
REPLACE(
@TEST
, ' '    ,'')
, 'tel:' ,'')
, '('    ,'')
, ')'    ,'') 
, '-'    ,'')
, ''''   ,'')

	RETURN @RETURNstring
	
END; 




GO


