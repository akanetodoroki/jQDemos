use jqdemos
IF (OBJECT_ID('sys_GetMemoCode') IS NOT NULL)  DROP FUNCTION sys_GetMemoCode
GO
CREATE FUNCTION sys_GetMemoCode ( @str nvarchar(1000) ) 
RETURNS nvarchar(1000)
AS
BEGIN 
  DECLARE @word nchar(1),@py nvarchar(1000),@i int 
  SELECT @py='',@i=1   
  WHILE @i<=LEN(@str) 
  BEGIN
    SET @word=SUBSTRING(@str,@i,1)   /* ÌáÈ¡Ò»¸öºº×Ö¡£*/
    SELECT @py = @py+ CASE 
    WHEN @word<=N'Z' THEN @word
    WHEN @word<=N'òˆ' THEN 'A'
    WHEN @word<=N'²¾' THEN 'B' 
    WHEN @word<=N'åe' THEN 'C'
    WHEN @word<=N'ùz' THEN 'D'
    WHEN @word<=N'˜Þ' THEN 'E'
    WHEN @word<=N'öv' THEN 'F'
    WHEN @word<=N'ÄB' THEN 'G'
    WHEN @word<=N'ì[' THEN 'H' 
    WHEN @word<=N'”h' THEN 'J'
    WHEN @word<=N'ôU' THEN 'K'
    WHEN @word<=N'ö²' THEN 'L'
    WHEN @word<=N'íJ' THEN 'M'
    WHEN @word<=N'Å´' THEN 'N' 
    WHEN @word<=N'a' THEN 'O'
    WHEN @word<=N'ÆØ' THEN 'P'
    WHEN @word<=N'Ñd' THEN 'Q' 
    WHEN @word<=N'úU' THEN 'R'
    WHEN @word<=N'ÎR' THEN 'S'  
    WHEN @word<=N'»X' THEN 'T'
    WHEN @word<=N'úF' THEN 'W'
    WHEN @word<=N'èR' THEN 'X'
    WHEN @word<=N'í' THEN 'Y'
WHEN @word<=N'…ø' THEN 'Z'  
ELSE ' '   END 
SET @i=@i+1
END
RETURN @py 
END
GO
SELECT dbo.sys_GetMemoCode('Í·æß¿Ëë¿·ÖÉ¢Æ¬PT12')
GO
IF (OBJECT_ID('sys_GetPycode') IS NOT NULL)  DROP Procedure sys_GetPycode 
GO
CREATE Procedure sys_GetPycode ( @str nvarchar(250),@pycode nvarchar(1000) output) 
AS
BEGIN 
  DECLARE @word nchar(1),@i int 
  SELECT @pycode='',@i=1   
  WHILE @i<=LEN(@str) 
  BEGIN
    SET @word=SUBSTRING(@str,@i,1)   /* ÌáÈ¡Ò»¸öºº×Ö¡£*/
    if (UNICODE(@word)>=19968) SELECT @pycode = @pycode+xpy from sys_unicodes where xchn=@word
    else SELECT @pycode = @pycode+@word
	SET @i=@i+1
  	END
END
GO
declare @s varchar(100)
exec sys_GetPycode '¼Ö±¦Óñ...×£ÎýÓÀ',@s output
print @s

GO
IF (OBJECT_ID('sys_GenPycode') IS NOT NULL)  DROP function sys_GenPycode 
GO
CREATE function sys_GenPycode ( @str nvarchar(250)) 
returns varchar(1000)
AS
BEGIN 
  DECLARE @word nchar(1),@i int 
  declare @pycode varchar(100)
  SELECT @pycode='',@i=1   
  WHILE @i<=LEN(@str) 
  BEGIN
    SET @word=SUBSTRING(@str,@i,1)   /* ÌáÈ¡Ò»¸öºº×Ö¡£*/
    if (UNICODE(@word)>=19968) SELECT @pycode = @pycode+xpy from sys_unicodes where xchn=@word
    else SELECT @pycode = @pycode+@word
	SET @i=@i+1
  END
  return @pycode
END
GO
select .dbo.sys_GenPycode('¼Ö±¦Óñ...×£ÎýÓÀ')