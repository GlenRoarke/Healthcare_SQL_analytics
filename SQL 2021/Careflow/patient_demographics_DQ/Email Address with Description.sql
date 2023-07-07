USE [HDM_Local]
GO

/****** Object:  UserDefinedFunction [CorpData].[fnAppEmailCheck]    Script Date: 19/05/2021 10:41:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [CorpData].[fnAppEmailCheck_2](@email VARCHAR(255))   
--Returns true if the string is a valid email address.  
RETURNS bit  
as  
BEGIN  
     DECLARE @valid bit 
	
     IF @email IS NOT NULL   
          SET @email = LOWER(@email)  
          SET @valid = 0  
          IF @email like '[a-z,0-9,_,\-]%@[a-z,0-9,_,-]%.[a-z][a-z]%' 
             --AND LEN(@email) = LEN(CorpData.fnAppStripNonEmail(@email))  
             AND @email NOT like '%@%@%'  --Not double @
             AND CHARINDEX('.@',@email) = 0  --no .before@
            -- AND CHARINDEX('..',@email) = 0  --no double.
             AND CHARINDEX(',',@email) = 0  --no comma
			 AND CHARINDEX(' ',@email) = 0 --check for spaces in the middle of the email address
             AND RIGHT(@email,1) between 'a' AND 'z'  
               SET @valid=1  
     RETURN @valid 

END 


BEGIN

DECLARE @Description varchar(50)

SELECT 
CASE WHEN @email like '[a-z,0-9,_,\-]%@[a-z,0-9,_,-]%.[a-z][a-z]%' THEN  @Description = 'ABC' END as @Description --Format
RETURN @Description
END


END 

GO


