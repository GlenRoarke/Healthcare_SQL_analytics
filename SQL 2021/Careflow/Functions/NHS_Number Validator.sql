USE HDM_Local
GO

/****** Object:  UserDefinedFunction [dbo].[udf_HDMSQL_CDS_NHSNumber_Valid]    Script Date: 16/06/2021 11:24:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*=============================================
 Author:			Julian Smith
 Create date:		26/01/2010
 Description:		TT84952
					Returns a true (1) / false (0) flag if the NHS Number is valid
					Current requirements shown below:

					The NHS NUMBER is 10 numeric digits in length. The tenth digit is a check digit used to confirm its validity. The check digit is validated using the Modulus 11 algorithm and the use of this algorithm is mandatory. There are 5 steps in the validation of the check digit:
						Step 1 Multiply each of the first nine digits by a weighting factor as follows:

						Digit Position
						(starting from the left) Factor:
						1							10 
						2							 9 
						3							 8 
						4							 7 
						5							 6 
						6							 5 
						7							 4 
						8							 3 
						9							 2 

						Step 2 Add the results of each multiplication together.
						Step 3 Divide the total by 11 and establish the remainder.
						Step 4 Subtract the remainder from 11 to give the check digit.
						If the result is 11 then a check digit of 0 is used. If the result is 10 then the NHS NUMBER is invalid and not used.
						Step 5 Check the remainder matches the check digit. If it does not, the NHS NUMBER is invalid.

					
 Revisions:
 =============================================*/

-- SELECT [dbo].[udf_HDMSQL_CDS_NHSNumber_Valid]('<String to compare>')

CREATE	FUNCTION [CorpData].[udf_HDMSQL_CDS_NHSNumber_Valid]
(		@NHSNUMBER					AS		NVARCHAR(255)	= '433-834-9425'
)
RETURNS BIT
AS
BEGIN

	--DECLARE @NHSNUMBER AS NVARCHAR(255) = '433-834-9425'

	--PRINT	@NHSNUMBER

	DECLARE	@RESULT						AS		BIT,
			@LOOP						AS		BIGINT,						
			@OFFSET						AS		INT,
			@CHECKDIGIT					AS		INT
			
-- Strip out any spaces or -'s
	SET		@NHSNUMBER					=		REPLACE(@NHSNUMBER, ' ', '')		
	SET		@NHSNUMBER					=		REPLACE(@NHSNUMBER, '-', '')	

-- Basic sense check 1 - is it a number?
--TRY / CATCH not allowed in a udf, so sensible code replaced with loop
	--BEGIN TRY
	--	SET		@LOOP						=		CAST(@NHSNUMBER AS BIGINT)		
	--END TRY
	--BEGIN CATCH
	----	PRINT	'Catch caught?'
	--END CATCH
	
	--IF		@LOOP						IS		NULL
	--BEGIN
	----		PRINT	'@LOOP is null?'
	--		SET		@RESULT				=		0
	--END
	--ELSE
	
	-- Scan through first 10 characters to see if there are any non-numerics - no issue with going beyond the string passed
	SET		@LOOP		=	9
	WHILE	@LOOP		<>	0
	BEGIN
		IF		ASCII(SUBSTRING(@NHSNUMBER, @LOOP, 1))	<	ASCII('0')
				OR
				ASCII(SUBSTRING(@NHSNUMBER, @LOOP, 1))	>	ASCII('9')
		BEGIN
			BREAK
		END
		ELSE
		BEGIN
			SET		@LOOP	=	@LOOP		-1
		END
	END	
-- If the loop finished earlier than expected, then a break must have been executed and therefore a non-numeric encoutnered
	IF		@LOOP	<>	0
	BEGIN
			SET		@RESULT		=	0
	END
	ELSE
	BEGIN

-- Basic sense check 2 - is it 10 characters long?
		IF		LEN(ISNULL(@NHSNUMBER, '')) <>		10
		BEGIN	
				SET		@RESULT				=		0
		END
		ELSE
		BEGIN
				SET		@OFFSET				=		11
				SET		@LOOP				=		1
				SET		@CHECKDIGIT			=		0

				WHILE	(@LOOP				<		10)
				BEGIN	
						--PRINT	'>' + SUBSTRING(@NHSNUMBER, @LOOP, 1) + '<, ' + CAST(@LOOP AS NVARCHAR)
						SET		@CHECKDIGIT	=		@CHECKDIGIT	
													+	
													(	CAST(SUBSTRING(@NHSNUMBER, @LOOP, 1) AS INT)
														*
														(	@OFFSET 
															- 
															@LOOP	
														)	
													)
						SET		@LOOP		=		@LOOP + 1
				END
				--PRINT	@CHECKDIGIT 
				SET		@CHECKDIGIT			=		11 - ( @CHECKDIGIT % 11 )
				--PRINT	@CHECKDIGIT 
-- If the result is 11 then a check digit of 0 is used. If the result is 10 then the NHS NUMBER is invalid and not used.
				IF		@CHECKDIGIT			=	11
				BEGIN	
						SET		@CHECKDIGIT	=	0
				END
				IF		@CHECKDIGIT			=	10
				BEGIN
						SET		@RESULT		=	0
				END
				ELSE
				BEGIN
	-- Does the calculated check digit match the 10th digit?
					IF		@CHECKDIGIT			=		SUBSTRING(@NHSNUMBER, 10 ,1)
					BEGIN
							SET		@RESULT		=		1
					END
					ELSE
					BEGIN
							SET		@RESULT		=		0
					END
				END
		END
	END
	
	RETURN		@RESULT
END

GO


