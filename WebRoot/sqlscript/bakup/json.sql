declare @result varchar(8000),@array1 varchar(8000),@array2 varchar(8000),@array3 varchar(8000),@array4 varchar(8000),@var varchar(8000)
declare c1 cursor scroll for 
select '"areid":"'+rtrim(AreaID)+'","areaname":"'+RTRIM(areaname)+'","parentnodeid":"'+RTRIM(parentnodeid)+'"' as 'label',
 areaid,areaname,parentnodeid,isparentflag,level,parentnodes from Areas order by parentnodes+areaid
 open c1
 declare @s1 varchar(100),@s2 varchar(15),@s3 varchar(40),@s4 varchar(15),@s5 int,@s6 int,@s7 varchar(150),@i int
 select @result='',@array1='',@array2='',@array3='',@array4=''
 set @i=1;
 declare @ss1 varchar(100),@ss2 varchar(15),@ss3 varchar(40),@ss4 varchar(15),@ss5 int,@ss6 int,@ss7 varchar(150)
 fetch last from c1 into @s1,@s2,@s3,@s4,@s5,@s6,@s7
 while @@FETCH_STATUS=0
 begin
    if (@s5=1)
    begin
      if @s6=1 set @var=@array1
      else if @s6=2 set @var=@array2
      else if @s6=3 set @var=@array3

      if @s6=1 select @array1=@array1+case when @array1<>'' then ',' else '' end+'{'+@s1+ ',items:['+@array2+']}'+CHAR(13),@array2=''
      if @s6=2 select @array2=@array2+case when @array2<>'' then ',' else '' end+'{'+@s1+ ',items:['+@array3+']}'+CHAR(13),@array3=''
      if @s6=3 select @array3=@array3+case when @array3<>'' then ',' else '' end+'{'+@s1+ ',items:['+@array4+']}'+CHAR(13),@array4=''

      if @s6=1 print str(@s6,2)+'-'+@s2+'-->'+char(13)+@array1
      --if @s6=2 print str(@s6,2)+'-'+@s2+'-->'+char(13)+@array2
	  --if (@s6=2) print 's1='+@var+'---'+@array2+char(13)

    end
    set @var=@s1
   -- //if @s6=1 select @array1=case when @array1<>'' then ',' else '' end+@array1+'{'+@s1+'}'+CHAR(13)
    if @s6=1 select @array1=@array1+case when @array1<>'' then ',' else '' end +'{'+@var+'}'+CHAR(13)
    if @s6=2 select @array2=@array2+case when @array2<>'' then ',' else '' end +'{'+@var+'}'+CHAR(13)
    if @s6=3 select @array3=@array3+case when @array3<>'' then ',' else '' end +'{'+@var+'}'+CHAR(13)
    if @s6=4 select @array4=@array4+case when @array4<>'' then ',' else '' end +'{'+@var+'}'+CHAR(13)
    --if @s6=1 set @result=@result+@array1+CHAR(13)
 
    fetch prior from c1 into @s1,@s2,@s3,@s4,@s5,@s6,@s7
 
 end
 deallocate c1
 --print @result
 go
 
select '"areid:"'+rtrim(AreaID)+'","areaname":'+RTRIM(areaname)+'","parentnodeid":"'+RTRIM(parentnodeid)+'"' as 'label',
 areaid,areaname,parentnodeid,isparentflag,level,parentnodes from Areas order by parentnodes+areaid


