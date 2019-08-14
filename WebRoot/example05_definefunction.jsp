<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<html>
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
<div id="main" style="margin:2px 2px 2px 2px;">
</div>
<script>
	$(function(){
		//example05_definefunction.jsp
		//定义easyui-panel容器控件
		myDefineForm('myForm1','main','学生信息编辑',0,0,285,380,'close;collapse;min;max');
		myDefineFieldset('myFieldset1','myForm1','通信信息',10,10,230,355);
		myDefineTextField('address','myFieldset1','家庭地址：',70,33*0+20,12,0,255,'浙江省杭州市西湖区');
		myDefineTextField('mobile','myFieldset1','手机号码：',70,33*1+20,12,0,180,'');
		myDefineTextField('homephone','myFieldset1','家庭电话：',70,33*2+20,12,0,180,'');
		myDefineTextField('email','myFieldset1','Email：',70,33*3+20,12,0,180,'zxywolf@163.com','email');
		myDefineTextField('qq','myFieldset1','QQ号：',70,33*4+20,12,0,180,'857199052');
		myDefineTextField('weixin','myFieldset1','微信号：',70,33*5+20,12,0,180,'zxywolf888');
    }); 

	function myDefineForm(id,parent,title,top,left,height,width,style){
		if (parent=='') parent='main';
		//窗体底部空4px,
	    str='<div class="easyui-panel" id="'+id+'" title="&nbsp;'+title+'" style="position:relative; background:#fafafa; margin:0px 0px 0px 0px; padding:2px 2px 2px 2px;';
	    var ph=$('#'+parent).height()-2;
		var pw=$('#'+parent).width()-2;
	    if (parent=='main'){
			if (ph<=0) ph=document.documentElement.clientHeight-4;  //body margin 2px
			if (pw<=0) pw=document.documentElement.clientWidth-4;
		}
		if (width<=0) width=pw-left*2;
		if (height<=0) height=ph-top*2;
	    if (width>0) str+='width:'+width+'px;';
	    else str+='width: 100%;';
	    if (height>0) str+='height:'+height+'px;';
	    else str+='height: 100%;';
	    if (left>0) str+='left:'+left+'px;';
	    if (top>0) str+='top:'+top+'px;';
	    str+='"\n';
	    str+='data-options="iconCls:\'panelIcon\'';
	    if (style.indexOf('close')>=0) str+=',closable:true';
	    if (style.indexOf('collapse')>=0) str+=',collapsible:true';
	    if (style.indexOf('min')>=0) str+=',minimizable:true';
	    if (style.indexOf('min')>=0) str+=',maximizable:true';
	    str+='" >';
	    str+='</div>\n';
	    console.log(str);
	    $('#'+parent).append($(str));
	    $('#'+id).panel();
		$("#"+id).attr('xparent',parent);  //自定义属性
		$("#"+id).attr('xid',id);  //自定义属性
	}
	
	function myDefineFieldset(id,parent,title,top,left,height,width){
		if (parent=='') parent='main';
		var str='';
		//str='<fieldset id="'+id+'" style="position: absolute; padding:0px 0px 0px 15px; margin:0px 0px 0px 0px; padding-right:0px; border:1px groove;">'; 
		str='<fieldset id="'+id+'" style="position: absolute; padding:0px 0px 0px 0px; margin:0px 0px 0px 0px; padding:0px 0px 0px 0px; border:1px solid #B5B8C8;">';  //groove  #990033黑色 
		if (title!='') str+='<legend style="margin:0 10px; padding:0px 0;">'+title+'</legend>';
		str+='</fieldset>';
		$("#"+parent).append($(str));
		//$("#"+id).css(myTextCss(parent,top,left,height,width));
		var css={margin:"0px 0px 0px 0px", padding:"0px 0px 0px 0px", position: "absolute", top:top+'px', left:left+'px', width:width, height:height, "z-index":2};
		$("#"+id).css(css);
		$("#"+id).css(sys.theme);
		$("#"+id).attr('type','fieldset');  //自定义属性
		$("#"+id).attr('xparent',parent);  //自定义属性
		$("#"+id).attr('xtitle',title);  //自定义属性
		$("#"+id).attr('xid',id);  //自定义属性
	}
	
	function myDefineTextField(id,parent,label,labelwidth,top,left,height,width,value,style){
		var str='';
		if (parent=='') parent='main';
		if (height==0) height=systext.height;
		if ($("#"+parent).length>0){
			console.log($("#"+parent).attr('type'));
		}	
		if (labelwidth==0 && label!=''){
			myFieldLabel(id,parent,label,labelwidth,top,left+2);
			top=1*(top+syslabel.fontsize+syslabel.topmargin+2); //换行显示文本
			labelwidth=0;
		}else{
			myFieldLabel(id,parent,label,labelwidth,top,left);
		}	
		str+='<div id="'+id+'_div"><input ';
		if (value!=undefined && value!=''){  //设置初值
			str+=' value="'+value+'"';
		}
		str+=' class="easyui-validatebox easyui-textbox" type="text" id="'+id+'" style="margin:0px 0px 0px 0px; padding:0px 6px 0px 6px;" ></div>';
		//console.log(str);
		$("#"+parent).append($(str));
		$("#"+id+'_div').css(myTextCss(parent,top,1*(left+labelwidth),height,width));
		$("#"+id).css({height:"100%", width:"100%"});
		$("#"+id).textbox({height: height});
		$("#"+id).attr('xparent',parent);  //自定义属性
		$("#"+id).attr('xlabel',label);  //自定义属性
		$("#"+id).attr('xid',id);  //自定义属性
		if (value!=undefined && value!=''){  //设置初值
			//$("#"+id).textbox('setValue',value);
		}
		myFieldStyle(id,style);
		//$('#'+id).textbox('textbox').bind('keydown',function(e){
			//myKeyDownEvent(id);
		//});

	}
</script>
</body>
</html>

