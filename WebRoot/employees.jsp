<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<!doctype html>
<html lang="en">
<style type="text/css">
</style>
<head>
	<meta charset="utf-8">
	<link rel="stylesheet" type="text/css" href="jqeasyui/themes/default/easyui.me.css">
	<link rel="stylesheet" type="text/css" href="jqeasyui/themes/icon.css">
    <link rel="stylesheet" type="text/css" href="system/css/icon.css">
    <script type="text/javascript" src="jqeasyui/jquery.min.js"></script>
    <script type="text/javascript" src="jqeasyui/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="jqeasyui/easyui-lang-zh_CN.js"></script>	
	<script type="text/javascript" src="system/easyui_functions.js"></script>
</head>
<body class="easyui-layout" fit="true" style="margin: 2px 2px 2px 2px;">
	<div id='toolbar' class='easyui-panel' data-options="region:'north'" style="overflow:hidden; background-color: #E0ECFF; height:33px; padding: 1px 1px 1px 10px;">
		<a href="indexx.jsp" id="btnreturn" class="easyui-linkbutton" data-options="iconCls:'returnIcon',plain:true" style="margin-left: 660px;">返回首页</a>
	</div>
	<div id='main' class='easyui-panel' data-options="region:'center'" style="padding: 1px 1px 1px 1px;"></div>
<script>
	$(function() {
		var pmyGrid1={};
		pmyGrid1.id='myGrid1';
		pmyGrid1.parent='main';
		pmyGrid1.staticsql="select employeeID,Name,department,case when Gender='f' then '女' else '男' end as gender,";
		pmyGrid1.staticsql+="birthdate,province+' '+city as hometown,mobile,homephone,email,weixin,qq from employees";
		pmyGrid1.activesql=pmyGrid1.staticsql;
		pmyGrid1.gridfields='[@c%c#90]姓名/name;[@c%c#90]性别/gender;[@c%c#110,2]部门/department;[%d#90@c]出生日期/birthdate;[@c#100]所属城市/hometown;';
		pmyGrid1.gridfields+='[110]联系电话/mobile;[110]家庭电话/homephone;[140]Email/email;[130]微信号/weixin;[100]QQ号/qq';
		pmyGrid1.fixedfields='[@l%c#100]工号/employeeid';
		pmyGrid1.title='学生列表';
		pmyGrid1.menu='myMenu1';
		pmyGrid1.checkbox='single';
		pmyGrid1.pagesize=20;
		pmyGrid1.keyfield='employeeid';
		pmyGrid1.rownumbers=true;
		pmyGrid1.collapsible=true;
		pmyGrid1.height=600;
		pmyGrid1.width=0;
		pmyGrid1.rowindex=0;
		//定义grid
		myGrid(pmyGrid1);
		//初始化，显示第一页记录
		myLoadGridData(pmyGrid1,1);			
		//myGrid1定义结束
		//定义窗口及其编辑控件
		myWindow('myEditWin1','编辑商品',0,0,335,660,'save;cancel','modal;close;drag');
		myFieldset('myFieldset1','myEditWin1','员工信息',10,10,240,410);
		myFieldset('myFieldset2','myEditWin1','',17,435,233,198);
		//myTextField('parentnode','myFieldset1','父类名称：',70,36*0+20,18,0,310,'','hidden');
		myTextField('employeeid','myFieldset1','工号：',70,36*0+20,18,0,120,'');
		myTextField('name','myFieldset1','姓名：',70,36*1+20,18,0,310,'');
		myTextField('department','myFieldset1','部门：',70,36*2+20,18,0,310,'');
		myTextField('city','myFieldset1','所属城市：',70,36*3+20,18,0,310,'');
		myTextField('mobile','myFieldset1','联系电话：',70,36*4+20,18,0,130,'');
		myTextField('gender','myFieldset1','性别：',40,36*4+20,258,24,100,12,2,'0');
		myFileField('file1','myFieldset1',36*5+20,16,0,384,'right','fnUpload');
		//定义文件上传控件
		myImageField('image1','myFieldset2','',0,1,1,231,188,'');
		myHiddenFields("addoredit;level;parentnodeid;ancester");  //隐藏用作变量		
		//定义关键字下拉框和查询文本输入框
		myMenu('myMenu1','新增节点/mnadd/addIcon;修改节点/mnedit/editIcon;-;删除/mndelete/deleteIcon;-;刷新/mnrefresh/refreshIcon','');
		var tmp='';  ////从网格中提取列标题作为下拉框选项
		for (var i=0;i<pmyGrid1.columns.length;i++){
			if (tmp!='') tmp+=';';
			tmp+=pmyGrid1.columns[i].title;
		}
		myComboField('searchfield','toolbar','选择关键字:',75,4,10,0,260,tmp,'','checkbox');
		myTextField('searchtext','toolbar','快速过滤：',65,4,380,0,200,'','');
		myTextField('locatetext','toolbar','',0,4,644,0,24,'','');
		//过滤记录
		$('#searchtext').textbox({
			buttonIcon:'icon-filter',
			onClickButton: function(e){
				wheresql=fnGenWhereSql('filter');
				if (wheresql!='') pmyGrid1.activesql='select * from ('+pmyGrid1.staticsql+') as p where '+wheresql;
				else pmyGrid1.activesql=pmyGrid1.staticsql;
				console.log(pmyGrid1.activesql);
				var opts =$("#myGrid1").datagrid('getPager').data("pagination").options; 
				opts.pageNumber=1;
				pmyGrid1.rowindex=0;
				myLoadGridData(pmyGrid1,1);            	
			}
		});
		//定位记录
		$('#locatetext').textbox({
			buttonIcon:'locateIcon',
			onClickButton: function(e){
				wheresql=fnGenWhereSql();
				if (wheresql!=''){
					sql="select top 1 "+pmyGrid1.keyfield+" from ("+pmyGrid1.activesql+") as p where "+wheresql;
					console.log(sql);
					var results=myRunSelectSql(sysdatabasestring, sql);
					if (results.length>0){
						var keyvalue=eval('results[0].'+pmyGrid1.keyfield);
						sql='select count(*)+1 as rowno from ('+pmyGrid1.activesql+') as p where '+pmyGrid1.keyfield+"<'"+keyvalue+"'";
						console.log(sql);
						var sources=myRunSelectSql(sysdatabasestring, sql);
						var rowno=sources[0].rowno;
						var opts =$("#myGrid1").datagrid('getPager').data("pagination").options; 
						var pageno=parseInt((rowno-1)/opts.pageSize)+1;
						pmyGrid1.rowindex=rowno-(pageno-1)*opts.pageSize-1;
						myLoadGridData(pmyGrid1,pageno);
					}else{
						$.messager.alert('系统提示','没有找到满足条件的记录！','info');
					}
				}	
			}
		});

		function fnGenWhereSql(action){
			var xtext=$('#searchtext').textbox("getValue");
			var xfields=';'+$('#searchfield').combobox("getText")+';';
			var wheresql='';
			for (var i=0;i<pmyGrid1.columns.length;i++){
				if (xfields.indexOf(';'+pmyGrid1.columns[i].title+';')>=0){
					if (wheresql!='') wheresql+=' or ';
					wheresql+=pmyGrid1.columns[i].field+" like '%"+xtext+"%'";
				}
			}
			return wheresql;
		}
		//菜单新增按钮事件
		$('#mnadd').bind('click',function(item){
			$("#addoredit").val('add');
			$("#employeeid").textbox("setValue",'');
			$("#name").textbox("setValue",'');
			$("#department").textbox("setValue",'');
			$("#city").textbox("setValue",'');
			$("#mobile").textbox("setValue",'');
			$("#gender").textbox("setValue",'');
			$("#image1").attr('src','');
			$("#employeeid").textbox("readonly",false);  //设置主键可编辑
			$('#myEditWin1').window('open');		
		});
		//修改节点eeeeee
		$('#mnedit').bind('click',function(item){
			$("#addoredit").val('edit');
			var records=$('#myGrid1').datagrid("getSelections");
			console.log($(records));
			if (records.length>0){
				$("#employeeid").textbox("setValue",records[0].employeeid);
				$("#name").textbox("setValue",records[0].name);
				$("#department").textbox("setValue",records[0].department);
				$("#city").textbox("setValue",records[0].hometown);
				$("#mobile").textbox("setValue",records[0].mobile);
				$("#gender").textbox("setValue",records[0].gender);
				$("#employeeid").textbox("readonly",true);  //设置主键只读
				var src='mybase/employees/'+records[0].employeeid+'.jpg';
				$("#image1").attr('src',src);
				myResizeImage('image1',src,231,198);
				//alert(src);
				$("#myEditWin1").window("open");
			}			
		});
		//删除节点及其子节点dddddd
		$('#mndelete').bind('click',function(item){
			var msg='删除成功';
			var row = $('#myGrid1').datagrid('getSelected');
			var rowno = $('#myGrid1').datagrid('getRowIndex',row);
			if (row){
				$.messager.confirm('系统提示', msg, function(r){
					if (r){
						var sql="delete employees where employeeid='"+row.employeeid+"'";
						$('#myGrid1').datagrid('deleteRow',rowno);
						var result=myRunUpdateSql('jqdemos',sql);
						if (result.error==''){
							
						};

					}
				});
			}else{
				$.messager.confirm('系统提示','不存在记录，删除失败！');
			}
		});
		//设计保存按钮事件ssssssave
		$('#myEditWin1SaveBtn').bind('click',function(item){
			var errmsg=[];
			var addoredit=$("#addoredit").val();
			var s1=$("#employeeid").textbox('getValue');
			var s2=$("#name").textbox('getValue');
			var s3=$("#department").textbox('getValue');
			var s4=$("#city").textbox('getValue');
			var s5=$("#mobile").textbox('getValue');
			var s6=$("#gender").textbox('getValue');
			if (s6=='女') s6='F'; 
			if (s6=='男') s6='M'; 
			if (addoredit=='edit'){  //修改记录
				var sql="update employees set name='"+s2+"',";
				sql+="department='"+s3+"',";
				sql+="city='"+s4+"',";
				sql+="mobile='"+s5+"',";
				sql+="gender='"+s6+"'";
				sql+=" where employeeid='"+s1+"'";
			}else{	//新增记录
				var sql="insert into employees (employeeid,name,department,city,mobile,gender)";
				sql+="values('"+s1+"','"+s2+"','"+s3+"','"+s4+"','"+s5+"','"+s6+"')";
			}
			console.log(sql);
			var result=myRunUpdateSql(sysdatabasestring, sql); //执行删除
			if (result.error!=''){
				errmsg.push(result.error);
				$.messager.show({
					title:'系统提示',
					msg:'记录保存失败！',
					showType:'show',
					width:200,
					timeout:0,
					style:{
						top: 120,
						left:540
					}
				});
			}else{  //修改或插入成功之后更新节点
				var row = $('#myGrid1').datagrid('getSelected');
				var rowno = $('#myGrid1').datagrid('getRowIndex',row);
				var s6=$("#gender").textbox('getValue');
				var data={
					'employeeid':s1,
					'name':s2,
					'department':s3,
					'city':s4,
					'mobile':s5,
					'gender':s6
				};
				$('#myGrid1').datagrid('updateRow',{index:rowno, row:data}); //修改更新当前节点
				//修改树中节点之后关闭窗口
				$('#myEditWin1').window('close'); 	
			}
		}); //保存结束
		//设计关闭窗口按钮事件
		$('#myEditWin1CancelBtn').bind('click',function(item){
			$('#myEditWin1').window('close');	
		});
		//定义窗口关闭事件
		$("#myEditWin1").window({
			//如果在窗口编辑商品信息时用户选择“取消”，则关闭窗口，并将空节点删除。
			onClose:function(){
				var records=$('#myGrid1').datagrid("getSelections");
				if (records.length>0 ){
					
				}
			}		
		});	
		//函数全部结束，设置初值，一开始窗口是关闭的。
		$('#myEditWin1').window('close');	
	//---------------------
	});  //endofjquery

	function fnUpload(){  //下载多个文件
 		var targetname = $("#employeeid").textbox("getValue");
 		var filename=$("#file1").val();
 		var fileext=filename.substring(filename.lastIndexOf(".")+1,255).toLowerCase();//文件扩展名
 		//alert(filename+'---'+fileext);
 		if (fileext.toLowerCase()=='jpg'){ //本地限制上传文件类型，服务器端程序不作限制
	 		console.log($("#file1")[0]);
	 		var fileObj = $("#file1")[0].files[0]; // 获取文件对象IE不支持
			var form = new FormData();  // FormData 对象
			form.append("file", fileObj);// 文件对象
			var xhr = new XMLHttpRequest(); //XMLHttpRequest 对象
			xhr.open("post", "system/easyui_fileUpLoad.jsp?targetname="+targetname+"&targetpath=mybase/employees", true);
			xhr.onload = function () {
				if(xhr.status == 200){    
					var data = JSON.parse(xhr.responseText);   
					if (data.error == 0) {  
						//上传成功
						//var src='${pageContext.request.contextPath}/images/head.jpg?timestemp='+new Date().getTime();
						var src=photopath+data.targetfile+'?timestemp='+new Date().getTime();
						$("#image1").attr('src',src);
						resizeImage('image1',src,230,224);
						$.messager.show({
							title:'系统提示',
							width:200,
							msg:'文件已经上传成功!',
							timeout:2000,
							showType:'slide'
						}); 
						$("#file1button").linkbutton('disable');
						console.log('文件上传成功!'+src+'，文件大小：'+data.filesize);
					}else{
						$.messager.alert('系统提示','文件上传失败！','error');
						console.log(data.message);	        		
					}
					$("#file1").val('');
				} 
			};
			xhr.send(form);
		}else{
			$.messager.alert('系统提示','文件类型选择错误，必须是JPG文件！','info');
		}
    }
	//图形缩放函数
	function resizeImage(img,src,winheight,winwidth){
		var image=new Image();
		image.src=src;
		image.onload=function() {  //必须放在onload事件中
			var aheight=image.height+0;  
			var awidth=image.width+0;
			if (awidth>0 && aheight>0) {
				//调整图片大小,按比例缩放
				var Ratio = 1; 
				var wRatio = winwidth / awidth; 
				var hRatio = winheight / aheight; 
				if (wRatio<1 || hRatio<1){ 
					Ratio = (wRatio<=hRatio?wRatio:hRatio); 
				} 
				if (Ratio!=0){ 
					awidth = awidth * Ratio; 
					aheight = aheight * Ratio; 
				}
				$("#image1").css({width:awidth, height:aheight});
			}
		};
		return {};				
	}		
	
	
	function myGridEvents(){
		
		
	}
</script>
</body>
</html>