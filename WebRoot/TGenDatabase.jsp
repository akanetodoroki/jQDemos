<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="com.DBConn" %>
<%@ page import="com.UserBean" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<link rel="stylesheet" type="text/css" href="ext4.2/resources/css/ext-all.css">  <!-- ext系统样式 -->
		<link rel="stylesheet" type="text/css" href="system/css/mystyle.css"> <!-- ext图标文件 -->
		<script type="text/javascript" src="ext4.2/ext-all.js"></script>  <!-- Ext核心源码 -->
		<script type="text/javascript" src="ext4.2/locale/ext-lang-zh_CN.js"></script>
		<script type="text/javascript" src="system/decimalfield.js"></script>   <!-- 自定义加零数值型控件 -->
		<script type="text/javascript" src="system/fn_function.js"></script>  <!-- 公共函数 -->
		<style>
		</style>
	</head>
	<body>
    <div class="logo">
    	<!-- <img src="system/images/login.png" /> -->
	</div>
	<%
		String filepath = request.getRealPath("/");
		filepath=filepath.replace("\\","\\\\");
	 %>
	
	<script type="text/javascript">
  	//选中子节点，保存后，再过滤，出现问题
	Ext.require(['Ext.form.*','Ext.tree.*','Ext.panel.*','Ext.tab.*','Ext.data.*','Ext.grid.*','Ext.toolbar.*','Ext.menu.*','Ext.Viewport']);
	Ext.onReady(function(){
		Ext.QuickTips.init();
		Ext.form.Field.prototype.msgTarget='side';//统一指定错误信息提示方式//'dtip','title','under'
		Ext.getDoc().on("contextmenu", function(e){  //去掉这个页面的右键菜单
			e.stopEvent();
        });
		eval(sysDisableBackSpace()); //知识点2：处理退格键keycode=8，禁止网页倒回
		sysSetMessageText();      //知识点3：设置EXTJS中messageBox的按钮，以汉字显示
		eval(sysSetTreeStore());  //知识点4：用于避免多次重复加载树！！重要
		var path='<%=filepath %>';
		//菜单存储在crmlab数据库
		sysdatabasestring=myGetSqlConnection().databasestring;
		var maxReturnNumber=1000;
		var rowHeight=32;
    	eval(myDefineForm('myForm1','',200,165,true));
    	eval(myDefineButton('button1','myForm1','win7(64)备份恢复',20,20,40,120));
    	eval(myDefineButton('button2','myForm1','win7(32)备份恢复',75,20,40,120));
    	eval(myDefineButton('button3','myForm1','SQL脚本运行',135,20,40,120));
  		//
   		function button1Click(btn){
   			if (btn.id=='button1'){
				var file=path+'\system\\sqlservers\\'+sys.dbname+'64.bak';
				var filedesc=path+'<br>\system\\sqlservers\\'+sys.dbname+'64.bak';
				var flag='64位';
			}else{
				var file=path+'\system\\sqlservers\\'+sys.dbname+'32.bak';
				var filedesc=path+'<br>\system\\sqlservers\\'+sys.dbname+'32.bak';
				var flag='32位';
			}
			var xerrmsg='';		
			var xmsg='注意：数据恢复会覆盖原有数据库<font color=blue><b>【'+sys.dbname+'】</b></font>！';
			xmsg+='<br>本次操作只支持windows7('+flag+')MSSQL2008版本。'; 
			xmsg+='<br>要求备份所在路径：'+filedesc+'。'; 
			xmsg+='<br><br>是否确认本次操作？<br><br>';
			Ext.MessageBox.show({   
				title: '系统提示',   
				msg: xmsg, 
				icon: Ext.MessageBox.QUESTION,  //icon: Ext.MessageBox.INFO  
				buttons: Ext.Msg.YESNO,
				fn: function(btn){
					if (btn=='yes'){
						sql=" use master if db_id('"+sys.dbname+"') is not null ";	
						sql+=" begin ";
						sql+=" ALTER DATABASE "+sys.dbname+" SET OFFLINE WITH ROLLBACK IMMEDIATE";
						sql+=" end ";
						sql+=" restore database "+sys.dbname+" from disk='"+file+"' with replace ";
						sql+=" ALTER DATABASE "+sys.dbname+" SET ONLINE WITH ROLLBACK IMMEDIATE";
						Ext.Ajax.request({
							url:'system//fn_executeSql.jsp',
							params:{ database: sysdatabasestring, updateSql: sql, selectSql: '' },									
     						method: 'POST',async:false,
							callback:function(options,success,response){
								xerrmsg=Ext.decode(response.responseText).errors;
								if (xerrmsg!=''){
									eval(sysError("服务器端数据库"+sys.dbname+"恢复失败！"+"<br>"+xerrmsg,0,0));						
			  					}else{
									eval(sysInfo("服务器端数据库"+sys.dbname+"恢复成功！"+"<br>重新刷新页面后生效！",0,0));						
			  					}  //error
       						}  //callback
        				});  //ajax						
					}
				}
			});		   		
  		
   		}
   			
   		function button2Click(btn){
   			button1Click(btn);
   		}
   			
   		function button3Click(){
   			var xmsg='注意：本次操作会覆盖原有数据库<font color=blue><b>【'+sys.dbname+'】</b></font>数据！';
			xmsg+='<br>本次操作大约需要30秒生成全部模拟数据，'; 
			xmsg+='<br>之后刷新页面，数据得到全部更新。'; 
			xmsg+='<br><br>是否确认本次操作？<br><br>';
			Ext.MessageBox.show({   
				title: '系统提示',   
				msg: xmsg, 
				icon: Ext.MessageBox.QUESTION,  //icon: Ext.MessageBox.INFO  
				buttons: Ext.Msg.YESNO,
				fn: function(btn){
					if (btn=='yes'){			
						Ext.Ajax.request({
							url:'system/fn_genDatabase.jsp',
							params:{ database: sysdatabasestring, dbName:sys.dbname, sqlFile:'' },									
			     			method: 'POST',async:false,
							callback:function(options,success,response){
								xerrmsg=(''+response.responseText).myTrim();
								if (xerrmsg!=''){
									eval(sysError("服务器端数据库"+sys.dbname+"脚本运行失败！<br>"+xerrmsg,0,0));						
			  					}else{
									eval(sysInfo("服务器端数据库"+sys.dbname+"脚本运行成功！"+"<br>重新刷新页面后生效！",0,0));
			  					}  //
			       			}  //callback
			        	});  //ajax
			        }
				}//func
	        });							
   		}
	//****************************end of extjs**************************//		
	}); 
  
  </script>
  </body>
</html>
