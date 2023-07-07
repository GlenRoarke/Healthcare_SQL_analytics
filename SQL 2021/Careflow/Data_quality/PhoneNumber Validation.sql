sp_configure 'clr enabled', 1
GO
RECONFIGURE WITH OVERRIDE

--Then you’ll need to create the function using the DLL attached (changing the file path in the script):

IF OBJECT_ID('[Migration].[udf_RegExMatches]') IS NOT NULL
       DROP FUNCTION [Migration].[udf_RegExMatches]

IF (SELECT COUNT(*) FROM sys.assemblies WHERE Name = 'CLRFunctions') = 1
       DROP ASSEMBLY [CLRFunctions]

CREATE ASSEMBLY [CLRFunctions] FROM 'C:\CLRFunction.dll' WITH PERMISSION_SET = SAFE;

--Then you can use the following to show Invalid numbers (or valid by changing the where clause to be = 1).

DECLARE @vPhoneValidationPattern NVARCHAR(255) = '(^[0][1-9]\d{8,}|^[+]\d{12,})(;ext=\d{1,})?$'

SELECT [fields]
FROM [table]
WHERE [Migration].[udf_RegExMatches](<field>, ISNULL(@vPhoneValidationPattern, '')) = 0 
