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
        <div id='left' class='easyui-panel' data-options="region:'west'" style="padding: 1px 1px 1px 1px;width:300px"></div>
        <div id='container' class='easyui-panel' data-options="region:'main'" style="padding: 1px 1px 1px 1px">
        	<div id='tool' data-optioins="region:'north'" class='easyui-panel' style=" background-color: #E0ECFF; height:33px; padding: 1px 1px 1px 300px;">
                <a href="#" class="btn-separator"></a>
                <a href="#" id="btnadd" class="easyui-linkbutton" data-options="iconCls:'addIcon', plain:true,onClick:fn_add" style="">新增</a>
                <a href="#" id="btnedit" class="easyui-linkbutton" data-options="iconCls:'editIcon', plain:true,onClick:fn_edit" style="">修改</a>
                <a href="#" id="btndelete" class="easyui-linkbutton" data-options="iconCls:'deleteIcon',plain:true,onClick:fn_delete" style="">删除</a>
                <!-- 在上边设置了事件函数 -->
                <a href="#" class="btn-separator"></a>
                <a href="#" id="btnsave" class="easyui-linkbutton" data-options="iconCls:'saveIcon',plain:true,onClick:fn_save" style="">保存</a>
                <a href="#" class="btn-separator"></a>
                <a href="indexx.jsp" id="btnreturn" class="easyui-linkbutton" data-options="iconCls:'returnIcon',plain:true" style="">返回首页</a>
            </div>
            <div id="main" data-options="region:'center'" class="easyui-panel" style="padding: 1px 1px 1px 10px;"></div>
        </div>
        
        <script>
        $(document).ready(function() {
        	myForm('myForm1','left','客户分类',0,0,0,0,'drag');
        	var str='<div id="myTree5" class="easyui-tree" style="fit:auto; border: true; padding:5px;"></div>';
    		$("#myForm1").append($(str));
    		$("#myTree5").tree({
    			checkbox: false,
    			lines:true
    		});
    		$("#myTree5").tree('append',{
    			parent:null,
    			data:{text:"所有客户  2016333504015  朱佳瑶",id:"*"}
    		});   
    		$.ajax({
    			url: "system/easyui_runSelectStoredProcedure.jsp",
    			data:{
       				database:'jqdemos', 
       				sqlprocedure:'testtree', 
       				paramvalues:''
       			},  
    			async: false, method: 'post',    
    			success: function(data) {
    				var source=eval(data);
    				var root = $("#myTree5").tree("getRoot");
					var pnode=root.target;
    	    		$("#myTree5").tree('append',{
    	    			parent: pnode,
    	    			data:source
    	    		});  //加载json数据到树
    			}    
    		});
    		$("#myTree5").tree({
    			onClick: function (node){  //点击展开事件
    				var pid=node.id;
    				var root = $("#myTree5").tree("getRoot");
					var pnode=root.target;
					if(pid=='more'){
    				   	$.ajax({
    				   		url: "system/easyui_runSelectStoredProcedure.jsp",
    				   		data:{
    				   			database:'jqdemos', 
    				   			sqlprocedure:'testtree2', 
    				   			paramvalues:pid
    				   		}, 
    				   		async: false, method: 'post',    
    				   		success: function(data) {
    				   			eval("source="+data);
    				   			//console.log(source);
    							$("#myTree5").tree('remove',node.target); //删除子节点
    							$("#myTree5").tree('append', {  //增加数据作为子节点
    								parent: pnode,
    								data: source 
    							});
    			   			}     
    			   		}); 
					  }
					else{

					}
    				}
    			
    		});	
    		//到此为止左侧树完成
    		//开始右侧表格
    		myForm('myForm2','main','',0,280,800,1400,'drag');
    		myTextField('customerid', 'myForm2', '客户编码:', 60, 34, 40, 0, 120, '', '', '');
            myTextField('customername', 'myForm2', '客户名称:', 60, 64, 40, 0, 200, '', '', '');
            myTextField('pycode', 'myForm2', '拼音:', 60, 94, 40, 0, 120, '', '', '');
            myTextField('contactid', 'myForm2', '联系编码:', 60, 124, 40, 0, 200, '', '', '');
            myComboField('employeeid', 'myForm2', '员工编码:', 60, 154, 40, 0, 120, '', '', '');
            myTextField('address', 'myForm2', '地址:', 60, 184, 40, 0, 200, '', '', '');
            myTextField('cityid', 'myForm2', '城市编码:', 60, 214, 40, 0, 200, '', '', '');
            myTextField('provinceid', 'myForm2', '省份编码:', 60, 244, 40, 0, 200, '', '', '');
            myTextField('phone', 'myForm2', '联系电话:', 60, 274, 40, 0, 200, '', '', '');
            myTextField('homepage', 'myForm2', '网址:', 60, 304, 40, 0, 200, '', '', '');
            
            $.ajax({     
    			type: "Post",     
    			url: "system/easyui_execSelect.jsp",     
    			//contentType: "application/json; charset=utf-8",     
    			//dataType: "json", 
    			data: {
    				database: 'jqdemos', 
    				selectsql: "select customerid,customername,employeeid,phone from customers"				
    			}, 
    			async: false, method: 'post',    
    			success: function(data) {
    				console.log(data);
    				var source=eval(data);
    				$("#customerid").combogrid({
    					panelWidth:440,  
    				    idField:'customerid',
    				    textField:'customerid',
    				    data:source,
    				    columns:[[
    					{field:'customerid',title:'公司编码',width:70},
    				    {field:'customername',title:'公司名称',width:210},
    				    {field:'employeeid',title:'接头员工',width:70},
    				    {field:'phone',title:'联系方式',width:90}
    				    ]]
    				    
    				});
    				$("#employeeid").combobox({
    					data:source,
    					idField:'employeeid',
				    	textField:'employeeid',
				    	field:'employeeid'
    				});
    			}    
    		});
        });
        
        $(document).ready(function() {
        myWindow('myWin225','客户详情',0,0,335,660,'','modal;close;drag');
        var pmyGrid225 = {};
        pmyGrid225.id = 'myGrid225';
        pmyGrid225.parent = 'myWin225';
        pmyGrid225.staticsql = "select orderid,productid,unitprice,";
        pmyGrid225.staticsql += "quantity,discount,amount from orderitems";
        pmyGrid225.activesql = pmyGrid225.staticsql;
        pmyGrid225.searchsql = "select customerID from orderitems";
        pmyGrid225.gridfields = '[@c%c#110,2]产品编号/productid;[%d#90@c]单价/unitprice;[@c#100]数量/quantity;';
        pmyGrid225.gridfields += '[110]折扣/discount;[110]金额/amount';
        pmyGrid225.fixedfields = '[@l%c#90]订单编号/orderid';
        pmyGrid225.title = false;
        pmyGrid225.menu = 'myMenu1';
        pmyGrid225.checkbox = 'single';
        pmyGrid225.pagesize = 100;
        pmyGrid225.keyfield = 'orderid';
        pmyGrid225.rownumbers = true;
        pmyGrid225.collapsible = true;
        pmyGrid225.height = 900;
        pmyGrid225.width = 900;
        pmyGrid225.rowindex = 0;
        //定义grid
        myGrid(pmyGrid225);
        //初始化，显示第一页记录
        myLoadGridData(pmyGrid225, 1);
        //myGrid1定义结束	
        });
        

        
        var addoredit = false; //创建一个变量，表示现在是否要新增一行。

        function fn_add() {
        	$("#customerid").textbox("setValue", '');
            $("#customername").textbox("setValue",'');
            $("#pycode").textbox("setValue", '');
            $("#contactid").textbox("setValue", '');
            $("#employeeid").textbox("setValue", '');
            $("#address").textbox("setValue", '');
            $("#cityid").textbox("setValue", '');
            $("#provinceid").textbox("setValue", '');
            $("#phone").textbox("setValue", '');
            $("#homepage").textbox("setValue", '');
            addoredit = true; //点击了增加所以将addoredit变量值设置为真。
        }

        function fn_edit() {
            addoredit = false; //点击了编辑所以将addoredit变量值设置为假。
            var row = $('#myTree5').tree('getSelected');
            console.log(row);
            var xsql="select customerid,customername,pycode,contactid,employeeid,address,cityid,provinceid,phone,homepage from customers";
			xsql+=" where customerid='" + row.id + "'";
			var source = myRunSelectSql('jqdemos', xsql);
			//console.log(source);
            $("#customerid").textbox("setValue", source[0].customerid);
            $("#customername").textbox("setValue", source[0].customername);
            $("#pycode").textbox("setValue", source[0].pycode);
            $("#contactid").textbox("setValue", source[0].contactid);
            $("#employeeid").textbox("setValue", source[0].employeeid);
            $("#address").textbox("setValue", source[0].address);
            $("#cityid").textbox("setValue", source[0].cityid);
            $("#provinceid").textbox("setValue", source[0].provinceid);
            $("#phone").textbox("setValue", source[0].phone);
            $("#homepage").textbox("setValue", source[0].homepage);
        }

        function fn_save() {
        	var row = $('#myTree5').tree('getSelected');
            if (addoredit) {
            	//var root = $("#myTree5").tree("getRoot");
				var pnode=$("#myTree5").tree("find",'*');
				console.log(pnode);
        		$("#myTree5").tree('append',{
        			parent:pnode.target,
        			data:{
        				id:$("#customerid").textbox('getValue'),
        				text:$("#customerid").textbox('getValue')+' 255 '+$("#customername").textbox('getValue')
        			}
        		});
                var insql = "insert into customers (customerID,customerName) values ('" + $("#customerid").textbox('getValue') + "',' ')"
                myRunUpdateSql('jqdemos', insql);
            }
            var sql = "update customers set ";
            sql += "customername='" + $("#customername").textbox('getValue') + "',";
            sql += "pycode='" + $("#pycode").textbox('getValue') + "',";
            sql += "contactid='" + $("#contactid").textbox('getValue') + "',";
            sql += "employeeid='" + $("#employeeid").combobox('getValue') + "',";
            sql += "address='" + $("#address").textbox('getValue') + "',";
            sql += "cityid='" + $("#cityid").textbox('getValue') + "',";
            sql += "provinceid='" + $("#provinceid").textbox('getValue') + "',";
            sql += "phone='" + $("#phone").textbox('getValue') + "',";
            sql += "homepage='" + $("#homepage").textbox('getValue') + "'";
            sql += " where customerID='" + $("#customerid").textbox('getValue') + "'";
            //console.log(sql);
            var result = myRunUpdateSql('jqdemos', sql);
            if (result.error == '') {
            	
            		if((row)&&(addoredit==false)){
            			$("#myTree5").tree('update',{
            				target:row.target,
            				text:$("#customerid").textbox('getValue')+' 225 '+$("#customername").textbox('getValue')
            			});
            		
            	}
            }
            addoredit = false; //将变量改回假。
        }

        function fn_delete() { //点击删除。
        	var row = $('#myTree5').tree('getSelected'); //获取当前行内容。
            var desql = "delete customers where customerID='" + row.id + "'"; //在数据库中删除这行。
            console.log(desql);
            var result = myRunUpdateSql('jqdemos', desql);
            if (result.error == '') {
                fnRefresh(); 
            	$("#myTree5").tree('remove',row.target);
            }

        }
        function fnRefresh(){
        	
    		
        }
        function myGridEvents(id,e){
    		
    	}
        
        </script>
    </body>

    </html>