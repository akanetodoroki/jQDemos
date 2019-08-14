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
<body style="margin: 2px 2px 2px 2px;">
<div id='main' fit="true" style="margin:0px 0px 0px 0px;">
	<div id="myGrid1" data-options="region:'center'" class="easyui-datagrid"></div> 
	<div id="information" data-options="region:'south'" class="easyui-panel" style="height:200px;width:200px;"></div>
</div>    
<script>
	$(function() {
		//定义网格数据源
		var griddata={"total":"20","rows":[
			 {"rownumber":"1","studentid":"20090202001","name":"陈蓉","pycode":"chenrong","gender":"女","birthdate":"1995-03-22","province":"贵州省","city":"德江县","mobile":"","homephone":"","email":"CR1995@163.com","weixin":"chenrong766","qq":""}
			,{"rownumber":"2","studentid":"20090202002","name":"蒋晓芸","pycode":"jiangxiaoyi","gender":"女","birthdate":"1994-06-05","province":"浙江省","city":"泰顺县","mobile":"13957724282","homephone":"0577-88862276","email":"2919323406@qq.com","weixin":"2919323406@qq.com","qq":"2919323406"}
			,{"rownumber":"3","studentid":"20090202003","name":"施丽君","pycode":"shilijun","gender":"女","birthdate":"1996-01-20","province":"浙江省","city":"天台县","mobile":"13905767383","homephone":"0576-88227797","email":"0364625112@qq.com","weixin":"0364625112","qq":"0364625112"}
			,{"rownumber":"4","studentid":"20090202004","name":"王丽娟","pycode":"wanglijuan","gender":"女","birthdate":"1995-03-16","province":"浙江省","city":"泰顺县","mobile":"13905777716","homephone":"0577-87228337","email":"wangHJ629@126.com","weixin":"wangHJ629@126.com","qq":"3042799899"}
			,{"rownumber":"5","studentid":"20090202005","name":"王琼瑶","pycode":"wangqiongyao","gender":"女","birthdate":"1995-06-06","province":"浙江省","city":"江山市","mobile":"18657038054","homephone":"0570-88438707","email":"WQY1995@163.com","weixin":"18657038054","qq":""}
			,{"rownumber":"6","studentid":"20090202006","name":"王旋玲","pycode":"wangxuanling","gender":"女","birthdate":"1995-04-11","province":"广西壮族自治区","city":"环江毛南族自治县","mobile":"18677813600","homephone":"0778-42471266","email":"wangXL342@126.com","weixin":"wangXL342@126.com","qq":"2594059588"}
			,{"rownumber":"7","studentid":"20090202007","name":"许广莲","pycode":"huanlian","gender":"女","birthdate":"1994-01-14","province":"福建省","city":"闽侯县","mobile":"13505917800","homephone":"0591-05210825","email":"huanlian042@sina.com","weixin":"7746907973","qq":"7746907973"}
			,{"rownumber":"8","studentid":"20090202008","name":"张媛媛","pycode":"zhangyuanyuan","gender":"女","birthdate":"1994-06-30","province":"浙江省","city":"景宁畲族自治县","mobile":"18683335394","homephone":"0578-85809176","email":"zhangYY501@126.com","weixin":"zhangYY501@126.com","qq":"5976366030"}
			,{"rownumber":"9","studentid":"20090202009","name":"赵琳","pycode":"tiaolin","gender":"女","birthdate":"1996-05-04","province":"内蒙古自治区","city":"扎兰屯市","mobile":"","homephone":"","email":"7677701556@qq.com","weixin":"7677701556","qq":"7677701556"}
			,{"rownumber":"10","studentid":"20090202010","name":"赵怡怡","pycode":"tiaoyiyi","gender":"女","birthdate":"1994-03-27","province":"辽宁省","city":"朝阳县","mobile":"18907309609","homephone":"0421-59192887","email":"tiaoYY429@126.com","weixin":"18907309609","qq":""}
			,{"rownumber":"11","studentid":"20090202011","name":"周晓楠","pycode":"zhouxiaonan","gender":"女","birthdate":"1995-11-12","province":"安徽省","city":"来安县","mobile":"13905508194","homephone":"0550-13673440","email":"zhouxiaonan@126.com","weixin":"13905508194","qq":""}
			,{"rownumber":"12","studentid":"20090202012","name":"诸葛文静","pycode":"zhugewenjing","gender":"女","birthdate":"1996-02-01","province":"浙江省","city":"仙居县","mobile":"13907914493","homephone":"0576-82543615","email":"ZGWJ1996@163.com","weixin":"13907914493","qq":""}
			,{"rownumber":"13","studentid":"20090202013","name":"刘伟明","pycode":"liuweiming","gender":"男","birthdate":"1994-12-08","province":"山东省","city":"沂南县","mobile":"13503669481","homephone":"0539-61414202","email":"LWM1994@163.com","weixin":"13503669481","qq":""}
			,{"rownumber":"14","studentid":"20090202014","name":"钱鑫源","pycode":"jianxinyuan","gender":"男","birthdate":"1994-11-23","province":"湖南省","city":"宁远县","mobile":"","homephone":"","email":"jianxinyuan037@sina.com","weixin":"jianxinyuan707","qq":""}
			,{"rownumber":"15","studentid":"20090202015","name":"邵建波","pycode":"shaojianbei","gender":"男","birthdate":"1993-12-14","province":"云南省","city":"麻栗坡县","mobile":"","homephone":"","email":"4088976967@qq.com","weixin":"4088976967@qq.com","qq":"4088976967"}
			,{"rownumber":"16","studentid":"20090202016","name":"施永南","pycode":"shiyongna","gender":"男","birthdate":"1995-05-17","province":"湖南省","city":"溆浦县","mobile":"13807455184","homephone":"0745-79855673","email":"shiYN271@126.com","weixin":"13807455184","qq":""}
			,{"rownumber":"17","studentid":"20090202017","name":"宋建彪","pycode":"songjianbiao","gender":"男","birthdate":"1995-12-22","province":"内蒙古自治区","city":"化德县","mobile":"","homephone":"","email":"8333462777@qq.com","weixin":"8333462777","qq":"8333462777"}
			,{"rownumber":"18","studentid":"20090202018","name":"宋子观","pycode":"songziguan","gender":"男","birthdate":"1996-06-01","province":"浙江省","city":"苍南县","mobile":"13856984004","homephone":"0577-86877767","email":"4817324986@qq.com","weixin":"4817324986","qq":"4817324986"}
			,{"rownumber":"19","studentid":"20090202019","name":"孙兆宏","pycode":"sunzhaohong","gender":"男","birthdate":"1994-03-24","province":"浙江省","city":"平阳县","mobile":"13905776220","homephone":"0577-80854092","email":"","weixin":"","qq":"2759399858"}
			,{"rownumber":"20","studentid":"20090202020","name":"唐胜利","pycode":"tangshengli","gender":"男","birthdate":"1995-05-01","province":"浙江省","city":"慈溪市","mobile":"13905748349","homephone":"0574-88495772","email":"tangshengli@hotmail.com","weixin":"13905748349","qq":""}
		]};		
		var xcolumns=[[
			{ title: '序号', field: 'rownumber', width: 90, halign:'center', align: 'right'	},
			{ title: '商品编码', field:'name', width: 90, halign:'center', align: 'right' },
			{ title: '商品名称', field:'pycode', width: 110, halign:'center', align: 'center' },
			{ title: '规格型号', field: 'birthdate', width: 95, halign:'center', align: 'center'},
			{ title: '计量单位', field: 'mobile', width: 110, halign:'center', align: 'center' },
			{ title: '数量', field: 'homephone', width: 110, halign:'center', align: 'right' },
			{ title: '单价', field: 'email', width: 140, halign:'center', align: 'right' },
			{ title: '金额', field: 'weixin', width: 130, halign:'center', align: 'right' }
		]];
		var xfixedcolumns=[[
			//{ field: 'id', width: 20, checkbox: true, align: 'center'}
		]];
		//定义myGrid1属性
		$('#myGrid1').datagrid({
			title: '&nbsp;学生列表',
			iconCls: "panelIcon",
			width:780,
			height:355,
			data: griddata,
			nowrap: true,
			autoRowHeight: false,
			rownumbers: false,
			striped: true,
			collapsible: true,
			singleSelect: true, //false,
			//fitColumns: true,
			//sortName: 'studentid',
			//sortOrder: 'asc',
			//remoteSort: false,
			//idField: 'studentid',
			columns: xcolumns,
			frozenColumns: xfixedcolumns
		});	
		$("#information").panel('move',{
		    left:100,
		    top:100
		}); 
		//$('#myGrid1').datagrid('loadData',griddata);
		
	//--------------------//
	});  //endofjquery 
    $("#information").panel({
    	title:'订单明细',
		iconCls:'panelIcon',
		tools: [{
			iconCls:'addIcon',
			handler:function(){ fn_add();}
	    },{
			iconCls:'deleteIcon',
			handler:function(){ fn_delete();}
	    },{
			iconCls:'saveIcon',
			handler:function(){ fn_save();}
	    },{
			iconCls:'freshIcon',
			handler:function(){ fnRefresh();}
	    }]
    })
</script>
</body>
</html>