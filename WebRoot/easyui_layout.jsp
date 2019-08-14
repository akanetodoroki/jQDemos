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
    <script>
	$(document).ready(function() {
		var jqsql={};  //sql语句中不能有双引号
		jqsql.area="select rtrim(areaid)+' '+rtrim(areaname) as 'text',areaid,areaname,parentnodeid,isparentflag,level,ancester from Areas ";
		jqsql.account="select accountid+' '+accountname as 'text',* from Accounts";
		jqsql.product="select productid,productname,quantityperunit,unitprice,a.supplierid,companyname as suppliername from Products a join suppliers b on a.supplierid=b.supplierid";
		jqsql.tree="select rtrim(id)+' '+rtrim(name) as 'text',* from tree ";
		myDBTree('myTree1','left','科目分类',0,0,0,0,jqsql.account,'accountid','','full');
		myTabs('myForm','righttop','基本信息;联系信息;研究方向;个人简历;上传照片',2,2,0,0,'');
		//myFieldset('myFieldset1','myTab1','基本信息',10,10,240,290);
		//myFieldset('myFieldset2','myTab2','通信信息',10,10,240,370);
		
		myTabs('myTab','rightbottom','科目列表;产品列表',2,2,0,0,'collapse;drag');
		myDBTree('myTree2','myTab1','科目分类',10,10,0,300,jqsql.account,'accountid','','full');
		myDBTree('myTree3','myTab2','资源分类',0,0,0,300,jqsql.tree,'id','','checkbox;full');
		$("#myTree1").tree('collapseAll');
		//var source={"total":"77","rows":[{"sysrowno":'1',"productid":"1111","productname":"Chai","quantityperunit":"10 boxes x 20 bags","unitprice":"18.0000"},{"sysrowno":'2',"productid":"1112","productname":"Ipoh Coffee","quantityperunit":"16 - 500 g tins","unitprice":"46.0000"},{"sysrowno":'3',"productid":"1121","productname":"Chang","quantityperunit":"24 - 12 oz bottles","unitprice":"19.0000"},{"sysrowno":'4',"productid":"1122","productname":"Guarana Fantastica","quantityperunit":"12 - 355 ml cans","unitprice":"3.2500"},{"sysrowno":'5',"productid":"1211","productname":"Sasquatch Ale","quantityperunit":"24 - 12 oz bottles","unitprice":"14.0000"},{"sysrowno":'6',"productid":"1212","productname":"Steeleye Stout","quantityperunit":"24 - 12 oz bottles","unitprice":"18.0000"},{"sysrowno":'7',"productid":"1213","productname":"Laughing Lumberjack Lager","quantityperunit":"24 - 12 oz bottles","unitprice":"14.0000"},{"sysrowno":'8',"productid":"1214","productname":"Outback Lager","quantityperunit":"24 - 355 ml bottles","unitprice":"15.0000"},{"sysrowno":'9',"productid":"1215","productname":"Rhonbrau Klosterbier","quantityperunit":"24 - 0.5 l bottles","unitprice":"7.7500"},{"sysrowno":'10',"productid":"1221","productname":"Cote de Blaye","quantityperunit":"12 - 75 cl bottles","unitprice":"263.5000"},{"sysrowno":'11',"productid":"1222","productname":"Chartreuse verte","quantityperunit":"750 cc per bottle","unitprice":"18.0000"},{"sysrowno":'12',"productid":"1223","productname":"Lakkalikoori","quantityperunit":"500 ml","unitprice":"18.0000"},{"sysrowno":'13',"productid":"2101","productname":"Chef Anton's Cajun Seasoning","quantityperunit":"48 - 6 oz jars","unitprice":"22.0000"},{"sysrowno":'14',"productid":"2102","productname":"Chef Anton's Gumbo Mix","quantityperunit":"36 boxes","unitprice":"21.3500"},{"sysrowno":'15',"productid":"2103","productname":"Northwoods Cranberry Sauce","quantityperunit":"12 - 12 oz jars","unitprice":"40.0000"},{"sysrowno":'16',"productid":"2104","productname":"Louisiana Fiery Hot Pepper Sauce","quantityperunit":"32 - 8 oz bottles","unitprice":"21.0500"},{"sysrowno":'17',"productid":"2105","productname":"Original Frankfurt Green Sauce","quantityperunit":"12 boxes","unitprice":"13.0000"},{"sysrowno":'18',"productid":"2201","productname":"Aniseed Syrup","quantityperunit":"12 - 550 ml bottles","unitprice":"10.0000"},{"sysrowno":'19',"productid":"2202","productname":"Genen Shouyu","quantityperunit":"24 - 250 ml bottles","unitprice":"15.5000"},{"sysrowno":'20',"productid":"2203","productname":"Gula Malacca","quantityperunit":"20 - 2 kg bags","unitprice":"19.4500"}]};
		//me.css,datagrid-cell-rownumber改变rownumber的宽度，默认25px
//---------------------
});
	
</script>
    
    
</head>
<body>
<div id='main'>
	<div class="easyui-layout" style="height:700px;">
        <div id='top' data-options="region:'north'" style="height:40px"></div>
        <div id='left' data-options="region:'west',split:true, title:'tree'" style="width:300px;height:400px;"></div>
        <div data-options="region:'center'">
            <div class="easyui-layout" data-options="fit:true">
                <div id='righttop' data-options="region:'north',split:true,border:false" style="height:50%"></div>
                <div id='rightbottom' data-options="region:'center',border:false"></div>
            </div>
        </div>
    </div> 	
 	    
</div>    
</body>
</html>