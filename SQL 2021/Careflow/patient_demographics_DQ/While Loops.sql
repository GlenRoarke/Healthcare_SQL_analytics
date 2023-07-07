
--While loop counter
DECLARE @Counter INT 
SET @Counter=1
WHILE ( @Counter <= 10)
BEGIN
    PRINT 'The counter value is = ' + CONVERT(VARCHAR,@Counter)
    SET @Counter  = @Counter  + 1
END

--While loop with break condition
DECLARE @Counter INT 
SET @Counter=1
WHILE ( @Counter <= 10)
BEGIN
  PRINT 'The counter value is = ' + CONVERT(VARCHAR,@Counter)
  IF @Counter >=7
  BEGIN
  BREAK
  END
    SET @Counter  = @Counter  + 1
END

--Continue function 
	
DECLARE @Counter INT 
SET @Counter=1
WHILE ( @Counter <= 20)
BEGIN
 
  IF @Counter % 2 = 1 --If an odd number
  BEGIN
  SET @Counter  = @Counter  + 1
  CONTINUE
  END
    PRINT 'The counter value is = ' + CONVERT(VARCHAR,@Counter)
    SET @Counter  = @Counter  + 1
END