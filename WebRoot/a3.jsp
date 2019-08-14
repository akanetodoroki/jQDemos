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
<body>
	<div id="main" style="margin:2px 2px 2px 2px;">
	<div class="easyui-panel" id="myForm1" title="&nbsp;商品信息" style="position:relative; background:#fafafa;" data-options="iconCls:'panelIcon'" >
		<fieldset id="myFieldset1" style="position:absolute; top:10px; left:10px; width:310px; height:270px; padding: 2px 0px 0px 16px; border:1px solid #B5B8C8;" >
			<legend>基本信息</legend>
			<label id="pid_label">商品编号：</label>
			<div id="pid_div"><input class="easyui-textbox" type="text" id="pid" ></input></div>
			<label id="pname_label">商品名称：</label>
			<div id="pname_div"><input class="easyui-textbox" type="text" id="pname"></input></div>
			<label id="psize_label">规格型号：</label>
			<div id="psize_div"><input class="easyui-textbox" type="text" id="psize"></input></div>
			<label id="pweight_label">计量单位：</label>
			<div id="pweight_div"><input class="easyui-textbox" type="text" id="pweight"></input></div>
			<label id="code_label">条形码：</label>
			<div id="code_div"><input class="easyui-textbox" type="text" id="code"></input></div>
			<label id="opendate_label">上市日期：</label><div id="opendate_div"><input class="easyui-datebox" type="text" id="opendate"></input></div>
			<label id="lastdate_label">保质期：</label>
			<div id="lastdate_div"><input class="easyui-textbox" type="text" id="lastdate"></input></div>
			<label id="lastdatex_label">（天）</label>
			<label id="pprice_label">单价：</label>
			<div id="pprice_div"><input class="easyui-textbox" type="text" id="pprice"></input></div>
			<label id="pincrease_label" for="pincrease">增值税率：</label>
			<div id="pincrease_div"><input class="easyui-textbox" type="text" id="pincrease" value="17"></input></div>
			<label id="pincreasex_label">（%）</label>
			<label id="supplier_label">供应商：</label>
			<div id="supplier_div"><input class="easyui-textbox" type="text" id="supplier"></input></div>
		</fieldset>
		<fieldset id="myFieldset2" style="position:absolute; top:10px; left:350px; width:310px; height:270px; padding: 2px 0px 0px 16px; border:1px solid #B5B8C8;" >
			<legend>辅助信息</legend>
			<label id='address_label'>原产地：</label>
			<div id="address_div">
				<input type="radio" checked="checked" name="place" class="radiostyle" style="padding:0px 2px 0px 4px">国产
				<input type="radio" name="place" class="radiostyle" style="padding:0px 2px 0px 4px">进口
				<input type="radio" name="place" class="radiostyle" style="padding:0px 2px 0px 4px">其他
			</div> 
			<label id='brand_label'>品牌名称：</label>
			<div id="brand_div"><input class="easyui-textbox" type="text" id="brand" style="padding:0px 2px 0px 4px"></input></div> 
			<label id='ind_label'>配料表：</label>
			<div id="ind_div"><input class="easyui-textbox" type="text" id="ind" style="padding:0px 2px 0px 4px"></input></div>
			<label id='keepway_label'>贮藏方式：</label>
			<div id="keepway_div"><input class="easyui-textbox" type="text" id="keepway" style="padding:0px 2px 0px 4px"></input></div>
			<label id='introduction_label'>产品简介：</label>
			<div id="introduction_div"><input class="easyui-textbox" type="text" data-options="multiline:true" id="introduction" style="padding:0px 2px 0px 4px"></input></div>
			<div id="torf_div"><input type="checkbox" checked="checked" id="torf"  style="padding:0px 2px 0px 4px"></input></div>
			<label id='torf_label'>是否含糖？</label>
		</fieldset>
		<div id="sandc">
			<input class="easyui-linkbutton" type="button" id="submit" value="保存" style="width:60px"></input><input class="easyui-linkbutton" type="button" id="cancel" value="取消" style="width:60px;margin-left:10px;"></input>
		</div>
	</div>
	</div>
 <script>
 $(document).ready(function(){
	    $("#pid_label").css({position: "absolute", top:"23px", left:"10px", width:"65px", "text-align":"right", "z-index":2});
		$("#pid_div").css({position: "absolute", top:"20px", left:"76px", "z-index":2});
		$("#pid").textbox({width:"232px"});

		$("#pname_label").css({position: "absolute", top:"53px", left:"10px", width:"65px", "text-align":"right", "z-index":2});
		$("#pname_div").css({position: "absolute", top:"50px", left:"76px","z-index":2});
		$("#pname").textbox({width:"232px"});

		$("#psize_label").css({position: "absolute", top:"83px", left:"10px", width:"65px", "text-align":"right", "z-index":2});
		$("#psize_div").css({position: "absolute", top:"80px", left:"76px", "z-index":2});
		$("#psize").textbox({width:"232px"});

		$("#pweight_label").css({position: "absolute", top:"113px", left:"10px", width:"65px", "text-align":"right", "z-index":2});
		$("#pweight_div").css({position: "absolute", top:"110px", left:"76px", "z-index":2});
		$("#pweight").textbox({width:"232px"});

		$("#code_label").css({position: "absolute", top:"143px", left:"10px", width:"65px", "text-align":"right", "z-index":2});
		$("#code_div").css({position: "absolute", top:"140px", left:"76px", "z-index":2});
		$("#code").textbox({width:"232px"});
		
		$("#opendate_label").css({position: "absolute", top:"173px", left:"10px", width:"65px", "text-align":"right", "z-index":2});
		$("#opendate_div").css({position: "absolute",top:"170px", left:"76px", "z-index":2});
		$("#opendate").textbox({width:"90px"});

		$("#lastdate_label").css({position: "absolute", top:"173px", left:"170px", width:"65px", "text-align":"right", "z-index":3});
		$("#lastdate_div").css({position: "absolute", top:"170px", left:"236px", "z-index":2});
		$("#lastdatex_label").css({position: "absolute", top:"173px", left:"250px", width:"65px", "text-align":"right", "z-index":2});
		$("#lastdate").textbox({width:"40px"});
		
		$("#pprice_label").css({position: "absolute", top:"203px", left:"10px", width:"65px", "text-align":"right", "z-index":2});
		$("#pprice_div").css({position: "absolute", top:"200px", left:"76px", "z-index":2});
		$("#pprice").css({width:"70px"});
		
		$("#pincrease_label").css({position: "absolute", top:"203px", left:"170px", width:"65px", "text-align":"right", "z-index":2});
		$("#pincrease_div").css({position: "absolute",top:"200px", left:"236px", "z-index":2});
		$("#pincreasex_label").css({position: "absolute", top:"203px", left:"250px", width:"65px", "text-align":"right", "z-index":2});
		$("#pincrease").css({width:"40px"});
		
		$("#supplier_label").css({position: "absolute", top:"233px", left:"10px", width:"65px", "text-align":"right", "z-index":2});
		$("#supplier_div").css({position: "absolute", top:"230px", left:"76px", "z-index":2});
		$("#supplier").textbox({width:"232px"});

		$("#address_label").css({position: "absolute", top:"23px", left:"10px", width:"65px", "text-align":"right", "z-index":2});
		$("#address_div").css({position: "absolute", top:"20px", left:"76px", "z-index":2});

		$("#brand_label").css({position: "absolute", top:"53px", left:"10px", width:"65px", "text-align":"right", "z-index":2});
		$("#brand_div").css({position: "absolute", top:"50px", left:"76px", "z-index":2});
		$("#brand").textbox({width:"232px"});

		$("#ind_label").css({position: "absolute", top:"83px", left:"10px", width:"65px", "text-align":"right", "z-index":2});
		$("#ind_div").css({position: "absolute", top:"80px", left:"76px", "z-index":2});
		$("#ind").textbox({width:"232px"});

		$("#keepway_label").css({position: "absolute", top:"113px", left:"10px", width:"65px", "text-align":"right", "z-index":2});
		$("#keepway_div").css({position: "absolute", top:"110px", left:"76px", "z-index":2});
		$("#keepway").textbox({width:"232px"});

		$("#introduction_label").css({position: "absolute", top:"143px", left:"10px", width:"65px", "text-align":"right", "z-index":2});
		$("#introduction_div").css({position: "absolute", top:"140px", left:"76px", "z-index":2});
		$("#introduction").textbox({width:"232px",height:"90px"});
		
		$("#torf_label").css({position: "absolute", top:"233px", left:"25px", width:"65px", "text-align":"right", "z-index":2});
		$("#torf_div").css({position: "absolute", top:"233px", left:"10px", "z-index":2});
		
		$("#sandc").css({position:"absolute",top:"300px",left:"540px","z-index":2});

		$("#myForm1").panel({width:700, height:365});
		$("#pid").textbox('setValue','请输入商品编号');
		$("#pname").textbox('setValue','请输入商品名称');
		$("#psize").textbox('setValue','请输入规格型号');
		$("#pweight").textbox('setValue','请输入计量单位');
		$("#code").textbox('setValue','请输入条形码');
		$("#supplier").textbox('setValue','请输入供应商');
		$("#lastdate").textbox('setValue','365');
		$("#lastdate").numberbox('textbox').css('text-align','right');
		$("#opendate").datebox('setValue','2009-1-1');
		$("#pprice").numberbox({precision:2, max:200, min:30});
		$("#pprice").textbox('setValue','56.45');
		$("#pprice").numberbox('textbox').css('text-align','right');
		
		$("#brand").textbox('setValue','请输入品牌名称');
		$("#ind").textbox('setValue','请输入配料表');
		$("#keepway").textbox('setValue','请输入贮藏方式');
		$("#introduction").textbox('setValue','不超过500字');

		//设置combobox
		$("#pincrease").spinner(
			
		);
		
 });
 </script>
</body>
</html>