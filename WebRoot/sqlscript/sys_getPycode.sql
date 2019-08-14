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
    SET @word=SUBSTRING(@str,@i,1)   /* ��ȡһ�����֡�*/
    SELECT @py = @py+ CASE 
    WHEN @word<=N'Z' THEN @word
    WHEN @word<=N'�' THEN 'A'
    WHEN @word<=N'��' THEN 'B' 
    WHEN @word<=N'�e' THEN 'C'
    WHEN @word<=N'�z' THEN 'D'
    WHEN @word<=N'��' THEN 'E'
    WHEN @word<=N'�v' THEN 'F'
    WHEN @word<=N'�B' THEN 'G'
    WHEN @word<=N'�[' THEN 'H' 
    WHEN @word<=N'�h' THEN 'J'
    WHEN @word<=N'�U' THEN 'K'
    WHEN @word<=N'��' THEN 'L'
    WHEN @word<=N'�J' THEN 'M'
    WHEN @word<=N'Ŵ' THEN 'N' 
    WHEN @word<=N'�a' THEN 'O'
    WHEN @word<=N'��' THEN 'P'
    WHEN @word<=N'�d' THEN 'Q' 
    WHEN @word<=N'�U' THEN 'R'
    WHEN @word<=N'�R' THEN 'S'  
    WHEN @word<=N'�X' THEN 'T'
    WHEN @word<=N'�F' THEN 'W'
    WHEN @word<=N'�R' THEN 'X'
    WHEN @word<=N'�' THEN 'Y'
WHEN @word<=N'��' THEN 'Z'  
ELSE ' '   END 
SET @i=@i+1
END
RETURN @py 
END
GO
SELECT dbo.sys_GetMemoCode('ͷ�߿�뿷�ɢƬPT12')
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
    SET @word=SUBSTRING(@str,@i,1)   /* ��ȡһ�����֡�*/
    if (UNICODE(@word)>=19968) SELECT @pycode = @pycode+xpy from sys_unicodes where xchn=@word
    else SELECT @pycode = @pycode+@word
	SET @i=@i+1
  	END
END
GO
declare @s varchar(100)
exec sys_GetPycode '�ֱ���...ף����',@s output
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
    SET @word=SUBSTRING(@str,@i,1)   /* ��ȡһ�����֡�*/
    if (UNICODE(@word)>=19968) SELECT @pycode = @pycode+xpy from sys_unicodes where xchn=@word
    else SELECT @pycode = @pycode+@word
	SET @i=@i+1
  END
  return @pycode
END
GO
select .dbo.sys_GenPycode('�ֱ���...ף����')