//A:link { color: #000000; TEXT-DECORATION: none}
//A:visited { COLOR: #000000; TEXT-DECORATION: none}
//A:hover { COLOR: #ff7f24; text-decoration: underline;}
//A:active { COLOR: #ff7f24; text-decoration: underline;}

//Project->Properties->javabuildpath+Libraries下，可以Add一个Jar到这个Project里。
//修改部署的文件路径，修改工种目录中的.project文件中的<name>项
//1. Eclipse-->Preferences..（MyEclipse--> Window -->Preferences:） 2. 在“type filter text“的框框里输入”ContentTypes;3. 点击右边的Text，选择Java Properties File，看一下 下面的两个选项  
//Project->Properties->javabuildpath+Libraries下，可以Add一个Jar到这个Project里。
//修改部署的文件路径，修改工种目录中的.project文件中的<name>项
//windows+preferences+general -> appearance -> colors and fonts 右边展开basic -> text font
pxmlfile='xml//resource.xml';
//pxmlfile='xml//resourcecategory.xml';
//pxmlfile='xml//km.xml';
sysdbname="melab";  //数据库名称变量
syshostname='localhost';  //数据库服务器名称变量
syssqlpassword='sql2008';   //数据库服务器sa用户登录密码变量
sysdatabasestring=syshostname+'	'+syssqlpassword+'	'+sysdbname;  //数据库连接字符串:hostname+password+dbname
rowHeight=32;
colWidth=8;
pmyWidth={};  //记录字段值的宽度
sysdateformat='Y-n-j';  //日期控件的日期格式，不足0
sysfulldateformat='Y-m-d';  //日期控件的日期格式,补足0  
syslabel={};
systext={};
sysbutton={};
syslabel.fontname='宋体'; //label显示的字体
syslabel.topmargin=4;  //label与输入框的高度差
syslabel.align='left';  //label与text之间字体对齐
syslabel.fontsize=13;  //label字体大小
syslabel.fontbold=false;  //label字体是否加黑 
systext.fontname='Times New roman'; //输入框的字体
systext.height=24;  //输入框的默认高度
systext.rowheight=36;  //表单控件间的行距
sysbutton.height=24;
sysbutton.width=65;
sys={};
sys.browser=myCheckBrowser();  //游览器类别
if (sys.browser=='firefox' ) sys.dateformat='Y-m-d';  //补足0
else if (sys.browser=='ie')  sys.dateformat='Y/m/d';
sys.windowcon='movie.png';
//sys.theme={theme: "web"};  //样式
sys.theme={ theme: "default" };
sys.fusionchartno=1;
sys.tab=String.fromCharCode(9);  //tab键
sys.ftab='['+String.fromCharCode(9)+']';  //tab键分隔各字段名称
sys.vtab='['+String.fromCharCode(9)+']';  //tab键分隔各字段值
sys.sqltab='@'+String.fromCharCode(9)+'@';  //sql语句之间tab键分隔
sys.gridcellpix=6;  //表格中每个字符的像素值
sys.treemenuwidth=190;
sys.urlpath="";  //工程路径
sys.project="";  //工程名称
url=window.location.pathname; //hostname; //href;
arrUrl=url.split("/");
if (arrUrl.length>1) sys.project=arrUrl[1];
sys.userid="";
sys.useraccount="admin",
sys.username="admin";
sys.userright='';
sys.usertype='';
sys.userpassword='';
sys.userlogindate='';
sys.useraction='';
sys.usernotes='';
//
sys.realpath='';
sys.path=url;
sys.urlright='';  //用户进入的程序链接名称，用于权限设置
sys.menuurl='';  //用户进入的程序链接名称，用于权限设置
sys.buttonright='';  //按钮权限
sys.screenwidth=window.screen.width;
sys.screenheight=window.screen.height;
sys.windowheight=sysGetWinSize().h;
sys.windowwidth=sysGetWinSize().w;
sys.menubutton=['addflag','updateflag','deleteflag','reviewflag','uploadflag','downloadflag','printflag'];
sys.chnnumber=['一','二','三','四','五','六','七','八','九','十'];
sys.keyeventcmp=';text;combo;combobox;numberbox;datebox;textbox;password;';
sys.maxfilenumber=100;
//控件
sys.cmp = [
		'textfield','combo','combofield','label','labelfield',
		'readonlyfield','displayfield','linkfield',
		'textpicker','gridpicker','treepicker','editbutton',
		'checkbox','memofield','memo',
		'sysuser','sysdate','sysusername','sysnumber',
		'fileupload','filedownload','filefield','imageupload',
		'datefield','password',
		'numberfield','decimalfield','rmb','rmbfield','totalfields','summaryfields',
		'spinfield',
		'report','footer',
		'groupbox','tab','form'
	];
//属性
sys.xattrs=['title','text','label','length','value','blanktext','minvalue','maxvalue','filename','datafields','nodefields','filterfields','sortfield','style','rmb','sumfields','avgfields','countfields','maxfields','minfields','summarycolumn',
'keyfield','lockedfields','decimal','sql','items','valuefields','labelwidth','masterfield','url','font','rule','rowheight','checkbox','modal','align','table',
'documentdate','reviewfields','format','titlerows','titlefont'];

//可编辑列数据类型
sys.editableColumnfields="/textfield/datefield/decimalfield/numberfield/combo/combofield/editbutton/";  
//上传后附件的存放路径
syspath={};
syspath.master="mybase//";
syspath.teachers="mybase//photos//teachers//";
syspath.students="mybase//photos//students//";
syspath.labs="mybase//labs//";
syspath.contacts="mybase//contacts//";  //存放联系人附件
syspath.employees="mybase//employees//";  //存放员工附件
syspath.products="mybase//products//";   //存放产品附件
syspath.activities="mybase//activities//";   //存放活动附件
syspath.services="mybase//services//";   //存放服务附件
syspath.customers="mybase//customers//";   //存放客户附件
syspath.collections="mybase//collections//";  //存放回笼单附件
syspath.orders="mybase//orders//";  //存放订单附件
syspath.faqs="mybase//faqs//";    //存放faq附件
syspath.troubles="mybase//troubles//";    //存放故障附件
syspath.invoices="mybase//invoices//";   //存放发票附件
syspath.resources="mybase//resources//";   //存放资源附件
sysfilenotfound="system//images//filenotfound.png";  
prowppx=26;
pcolppx=7;   
pgridrowheight=21;
pwinheight=600;
pwinwidth=800;
pitemsPerPage=20;  //grid中每页显示的记录数量
maxReturnNumber=20;  //一次从后台返回记录的数量，超过该值树中节点将分层获取。
//以下为函数
function myCheckBrowser(){
	//返回当前正在使用的游览器的类型
	var type=navigator.userAgent.toLowerCase();
	var browser=navigator.userAgent;
	if (type.indexOf('msie')>=0 && type.indexOf('opera')<0) {
		browser='ie';
	}else if (type.indexOf('firefox')>=0) {
		browser='firefox';
	}else if (type.indexOf('opera')>=0) {
		browser='opera';
	}else if (type.indexOf('chrome')>=0) {
		browser='chrome';
	}else if (type.indexOf('safari')>=0) {
		browser='safari';
	}
	return (browser);	 	
}

function sysGetWinSize(){
	//获取窗口高度和宽度。
	var p={};
	p.w=0; p.h=0;
	if (window.innerHeight)
		p.h = window.innerHeight;
	else if ((document.body) && (document.body.clientHeight))
		p.h = document.body.clientHeight;
	//通过深入Document内部对body进行检测，获取窗口大小
	if (document.documentElement && document.documentElement.clientHeight && document.documentElement.clientWidth){
		p.h = document.documentElement.clientHeight;
	}
	//winHeight=window.screen.height;
	//球宽度
	if (window.innerWidth)//Internet Explorer,Chrome,Firefox,Opera,Safari;
		p.w = window.innerWidth;
	else if ((document.body) && (document.body.clientWidth))//Internet Explorer 8,7,6,5
		p.w = document.body.clientWidth;
	//通过深入Document内部对body进行检测，获取窗口大小
	if (document.documentElement && document.documentElement.clientHeight && document.documentElement.clientWidth){
		p.w = document.documentElement.clientWidth;
	}
	return(p);
}


function myBanBackSpace(e){
	var ev = e || window.event;
	var obj = ev.target || ev.srcElement;
	var t = obj.type || obj.getAttribute('type');
	var vReadOnly = obj.readOnly;
	var vDisabled = obj.disabled;
	vReadOnly = (vReadOnly == undefined) ? false : vReadOnly;
	vDisabled = (vDisabled == undefined) ? true : vDisabled;
	var flag1= ev.keyCode == 8 && (t=='password' || t=='text' || t=='textarea')&& (vReadOnly==true || vDisabled==true);
	var flag2= ev.keyCode == 8 && t != 'password' && t != 'text' && t != 'textarea' ;
	var flag3= (ev.keyCode == 33 || ev.keyCode == 34) && t== 'textarea' && mycheckBrowser()=='chrome' ;
	if(flag2 || flag1 || flag3) return false;
}

function trim(str){
	if (str!=undefined) return str.replace(/(^\s*)|(\s*$)/g,'');
	else return '';
}


String.prototype.replaceAll = function (str1,str2){
	var str = this;
	if (str==undefined) str=''; 
	var result = str.replace(eval("/"+str1+"/gi"),str2);
	return result;
}

function myToSqlValue(value){
	if (value==undefined) value=''; 
	//value=value.replace(/\r/g,"&nbsp;")
	value=value.replace(/\n/g,"<br>") 
	value=value.replaceAll("'","''");
	return value;
}

function mySpace(n){
	var str='';
	for (var i=1; i<=n; i++) str+='&nbsp;';
	return str;
}


function myToUnicode(str){  //汉字转换成unicode，英文字母也是4位数字
	var result='';
	if (str!=''){
		for(var i=0;i<str.length;i++){
			var chr=parseInt(str[i].charCodeAt(0),10).toString(16);
			//if (chr.length<4) chr+='%%%%';
			result+=chr.substr(0,4);
		}
	}
	//return escape(str).toLocaleLowerCase().replace(/%u/gi, '#u');     
	return result;
}

function xmyToChn(str){  //unicode转换为汉字和英文字母
	var result='';
	if (str!=''){
		for (var i=0;i<str.length;i++){
			var chr=str.substr(i*4,4);
			chr=chr.replace('%','');
			result+=String.fromCharCode(parseInt(chr,16).toString(10));
		}
	} 
	return result;
 	//return unescape(str.replace(/\#u/gi, '%u'));  	
}

//按格式取系统当前日期时间
function mySysDateTime(format){
	var date = new Date();
	var ms =date.getMilliseconds();
	var y = date.getFullYear();
	var m= (date.getMonth()+1)+'';
	var d= date.getDate()+''
	if (m.length<2) m='0'+m;
	if (d.length<2) d='0'+d;
	var h=date.getHours()+'';
	var mi=date.getMinutes()+'';
	var s=date.getSeconds()+'';
	if (h.length<2) h='0'+h;
	if (mi.length<2) mi='0'+mi;
	if (s.length<2) s='0'+s;
	var t=h+':'+mi+':'+s+':'+ms;
	var result='';
	if (format=='date') result=y+'-'+m+'-'+d;
	else if (format=='time') result=t;
	else if (format=='fulltime') result=y+'-'+m+'-'+d+'-'+h+'-'+mi+'-'+s+'-'+ms;
	else if (format=='second') result=date.getTime();
	else result=y+'-'+m+'-'+d+' '+t;
	
	return result;
}

function dateadd(date,days){
	date = date.replace(/-/g,"/"); //更改日期格式  
    var nd = new Date(date);  
    nd = nd.valueOf();  
    nd = nd + days * 24 * 60 * 60 * 1000;  
    nd = new Date(nd);  
    var y = nd.getFullYear();  
    var m = nd.getMonth()+1;  
    var d = nd.getDate();  
    if(m <= 9) m = "0"+m;  
    if(d <= 9) d = "0"+d;   
    var cdate = y+"-"+m+"-"+d;  
    return cdate;  
}

//按格式取日期
function myDateboxValue(id,format){
	var result='';
	if (format==undefined || format=='') var format='long';
	if ($("#"+id).length>0){
		var s=$("#"+id).textbox('getValue');
		var tmp=s.split('-');
		if (tmp.length==3){
			if (tmp[1].length<2) tmp[1]='0'+tmp[1];
			if (tmp[2].length<2) tmp[2]='0'+tmp[2];
			if (format=='long' || format=='day' ){
				result=tmp[0]+'年'+tmp[1]+'月'+tmp[2]+'日';
			}else if (format=='month'){
				result=tmp[0]+'年'+tmp[1]+'月';
			}else if (format=='year'){
				result=tmp[0]+'年';
			}
		}	
	}
	return result;
}

//定义简单消息框
function myMessage(msg,icon,width,callback){
	var title='系统提示';
	if (callback==undefined) callback='myMessageEvent';
	if (msg.constructor == window.Array){  //数组时
		var str=''
		for (var i=0;i<msg.length;i++){
			if (i>0) str+='@n';
			str+=msg[i];
		}
		str=str.replaceAll('<br>','@n');
	}else{
		var str=msg;
	}
	var tmp=str.split('@n');
	if (icon==undefined || icon=='') var icon='info';
	else if (icon=='warn') icon='warning';
	else if (icon=='alert') icon='info';
	var k=0;
	str='';
	//alert(tmp.length);
	for (var i=0;i<tmp.length;i++){
		var s=tmp[i].replaceAll(' ','&nbsp;');
		if (tmp[i]=='') s='<div style="margin:5px 0px 0px 0px;"></div>';
		else if (k==1) s='<div style="margin:0px 12px 5px 0px;">'+s+'</div>';
		else if (tmp.length==1) s='<div style="margin:8px 12px 5px 0px;">'+s+'</div>';//只有一行
		else s='<div style="margin:0px 0px 5px 30px;">'+s+'</div>';
		s='<center>'+s+'</center>';
		if (tmp[i]!='') k++;  
		str+=s;
	}
	if (width!=undefined && width>0){
		$.messager.alert({
			title:title,
			msg:str+'<br>',
			width: width,
			icon:icon,
			fn: eval(callback)
		});
	}else{
		//$.messager.alert(title,str,icon);
		$.messager.alert({
			title:title,
			msg:str,
			icon:icon,
			fn: eval(callback)			
		});
	}
}

function myMessageEvent(){  //空事件

}

//定义提示框
function myMessageShow(msg,width){
	if (width==undefined || width==0) width=200; 
	$.messager.show({
		title: '系统提示',
		width: width,
		msg: "<center>"+msg+"</center>",
		timeout:2000,
		showType:'slide'
	});
}	 

//定义控件位置样式Style
function myDefineLabelStyle(top,left,height,width){
	var str='';
	if (top!=undefined && left!=undefined){
		str+='style=\\"';
		if (syslabel.fontbold) str+='font-weight:bold; ';
		str+='font-size: '+syslabel.fontsize+'px; font-family: '+syslabel.fontname+'; TOP: '+top+'px; LEFT: '+left+'px; ';
		if (height!=undefined && height>0){
			str+=' height: '+height+'px;';
		}	
		if (width!=undefined && width>0){
			str+=' width: '+width+'px;';
		}
		str+=' position: absolute';
	}	
	return str; 
}

//独立的label
function myLabel(id,parent,label,top,left,style){
	if (parent=='') parent='document.body';
	if (style==undefined) var style='';
	else style=';'+style+';';
	//alert(style);
	var str='';
	str+="<label id='"+id+"' align='left'>";
	if (style.indexOf(';b;')>=0) str+='<b>'; 
	if (style.indexOf(';u;')>=0) str+='<u>'; 
	if (style.indexOf(';i;')>=0) str+='<i>'; 
	if (style.indexOf(';a;')>=0) str+='<a>'; 
	str+=label;
	if (style.indexOf(';a;')>=0) str+='</a>'; 
	if (style.indexOf(';i;')>=0) str+='</i>'; 
	if (style.indexOf(';u;')>=0) str+='</u>'; 
	if (style.indexOf(';b;')>=0) str+='</b>';
	str+="</label>"; 
	$("#"+parent).append($(str));
	//alert(str);
	$("#"+id).css(myLabelCss(parent,top,left,0,0));
	$("#"+id).attr('type','label');
	$("#"+id).attr('xparent',parent);
	$("#"+id).attr('xid',id);
}

//文本文字样式
function myLabelCss(parent,top,left,height,width){
	var css='';
	if (sys.browser=='firefox' && parent!=undefined && $("#"+parent).length>0 && $("#"+parent).attr('type')=='fieldset'){
		top=top-16;   //firefox游览器
	}
	var str='var css={position: "absolute"';
	if (syslabel.fontbold) str+=', font-weight:bold';
	str+=', "font-size":'+syslabel.fontsize+', "font-family":"'+syslabel.fontname+'"';
	if (top!=undefined && left!=undefined){
		str+=', "top":'+top+', "left":'+left;
		if (width!=undefined && width>0){
			str+=', "width": '+width;
		}
		if (height!=undefined && height>0){
			str+=', "height": '+height;
		}
		str+=', "z-index":2};\n';
	}else{
		str+="};\n";
	}
	//console.log(str);
	eval(str);
	return css;		
}

//定义控件位置样式CSS
function myTextCss(parent,top,left,height,width){
	var str='';
	var css='';
	if (top!=undefined && left!=undefined){
		if (sys.browser=='firefox' && parent!=undefined && $("#"+parent).length>0 && $("#"+parent).attr('type')=='fieldset'){
			top=top-16;
		}
		str='var css={padding:"0px 2px 0px 4px", position: "absolute", top:"'+top+'px", left:"'+left+'px"';
		if (width!=undefined && width>0){
			str+=', width: '+width;
		}
		if (height!=undefined && height>0){
			str+=', height: '+height;
		}
		str+=', "z-index":2};\n';
	}else{
		str+="\n";
	}
	eval(str);
	//console.log(str);
	return css;		
}

function myFieldStyle(id,style){  //设置style只读、图标
	if (style!=undefined && style!=''){
		var tmp=(style+';').split(';');
		for (var i=0;i<tmp.length;i++){
			//console.log(tmp[i]);
			if (tmp[i]=='readonly'){
				$("#"+id).textbox({readonly: true});
				$("#"+id).attr('xreadonly',true);
			} 
			if (tmp[i]=='email') $("#"+id).textbox({validType:'email'});
			if (tmp[i]=='url') $("#"+id).textbox({validType:'url'});
			if (tmp[i]=='password') $("#"+id).textbox({type:'password'});
			if (tmp[i].indexOf('icon:')>=0){
				var x1=tmp[i].indexOf('icon:');
				var x2=tmp[i].indexOf(';',x1+1);
				if (x1>=0 && x2>0) var icon=tmp[i].substring(x1+5,x2-1); 
				else var icon=tmp[i].substr(x1+5,255);
				//$("#"+id).textbox({iconCls: icon});  //
				$("#"+id).textbox({buttonIcon: icon}); 
			}
		}
	}
}	

function myFieldLabel(id,parent,label,labelwidth,top,left,height,width){
	//定义控件中的label
	if (label!=undefined && label!=''){
		if (label.substr(0,1)=='*'){
			label=label.substring(1);
			$("#"+parent).append("<label id='xlabel"+id+"' align='"+syslabel.align+"'>*</label>");
			$("#xlabel"+id).css(myLabelCss(parent,top+syslabel.topmargin,left+labelwidth+width+12,0,0));
		}
		$("#"+parent).append("<label id='label"+id+"' align='"+syslabel.align+"'>"+label+"</label>");
		if (labelwidth>0){
			$("#label"+id).css(myLabelCss(parent,top+syslabel.topmargin,left,0,labelwidth));
		}else{
			$("#label"+id).css(myLabelCss(parent,top,1*left+2,0,label.length*syslabel.fontsize));
			top=1*(top+syslabel.fontsize+syslabel.topmargin); //换行显示文本
		}
	}else labelwidth=0;
}

function myHiddenFields(fields){
	var str='';
	var parent='main';
	var items=fields.split(';');
	for (var i=0; i<items.length; i++){
		str='<input hidden="true" type="hidden" id="'+items[i]+'" style="left:0px; top:0px; height:0px; width:0px; padding:0px 0;" />';
		//console.log(str);
		$("#"+parent).append($(str));
		$("#"+items[i]).attr('xid',items[i]);
	}
}

function myTextField(id,parent,label,labelwidth,top,left,height,width,value,style){
	var str='';
	if (parent=='') parent='main';
	if (height==0) height=systext.height;
	if (labelwidth==0 && label!=''){
		myFieldLabel(id,parent,label,labelwidth,top,left+2,height,width);
		top=1*(top+syslabel.fontsize+syslabel.topmargin+2); //换行显示文本
		labelwidth=0;
	}else{
		myFieldLabel(id,parent,label,labelwidth,top,left,height,width);
	}	
	str+='<div id="'+id+'_div" style="margin:0; padding:0;" ><input ';
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
	if (style!=undefined) myFieldStyle(id,style);
	//$('#'+id).textbox('textbox').bind('keydown',function(e){
		//myKeyDownEvent(id);
	//});
}

//定义date控件
function myDateField(id,parent,label,labelwidth,top,left,height,width,value,style){
	var str='';
	if (parent=='') parent='main';
	if (height==0) height=systext.height;
	if (labelwidth==0 && label!=''){
		myFieldLabel(id,parent,label,labelwidth,top,left+2,height,width);
		top=1*(top+syslabel.fontsize+syslabel.topmargin+2); //换行显示文本
		labelwidth=0;
	}else{
		myFieldLabel(id,parent,label,labelwidth,top,left,height,width);
	}	
	str+='<div id="'+id+'_div"><input ';
	if (value!=undefined && value!=''){  //设置初值
		str+=' value="'+value+'"';
	}
	str+=' class="easyui-datebox" type="text" id="'+id+'" style="padding:0px 6px 0px 6px;" ></div>';
	//console.log(str);
	$("#"+parent).append($(str));
	$("#"+id+'_div').css(myTextCss(parent,top,1*(left+labelwidth),height,width));
	$("#"+id).datebox({height: height, width: width});
	$("#"+id).attr('xparent',parent);  //自定义属性
	$("#"+id).attr('xlabel',label);  //自定义属性
	$("#"+id).attr('xid',id);  //自定义属性
	if (value!=undefined && value!=''){  //设置初值
		//$("#"+id).datebox('setValue',value);
	}
	myFieldStyle(id,style);
}

//textarea
function myMemoField(id,parent,label,labelwidth,top,left,height,width,value,style){
	//myTextField(id,parent,label,labelwidth,top,left,height,width,value,style);
	//$("#"+id).textbox({multiline: true});
	myTextareaField(id,parent,label,labelwidth,top,left,height,width,value,style);
}

function myTextareaField(id,parent,label,labelwidth,top,left,height,width,value,style){
	var str='';
	if (parent=='') parent='main';
	if (height==0) height=systext.height;
	if (labelwidth==0 && label!=''){
		myFieldLabel(id,parent,label,labelwidth,top,left+2,height,width);
		top=1*(top+syslabel.fontsize+syslabel.topmargin+2); //换行显示文本
		labelwidth=0;
	}else{
		myFieldLabel(id,parent,label,labelwidth,top,left,height,width);
	}
	var str='<div id="'+id+'_div"><textarea ';
	if (value!=undefined && value!=''){  //设置初值
		str+=' value="'+value+'"';
	}
	str+=' id="'+id+'" style="resize:none; padding:5px 5px 0px 5px;" ></textarea></div>';
	$("#"+parent).append($(str));
	$("#"+id+"_div").css(myTextCss(parent,top,1*(left+labelwidth),height,width));
	$("#"+id).css({ height: height, width: width });
	$("#"+id).attr('type','textarea');  //修改控件类别，系统不会自己加入，在赋值函数中使用到。
	$("#"+id).attr('xparent',parent);  //自定义属性
	$("#"+id).attr('xlabel',label);  //自定义属性
	$("#"+id).attr('xid',id);  //自定义属性
	if (value!=undefined && value!=''){  //设置初值
		$("#"+id).val(value);
	}
	myFieldStyle(id,style);	
}

//定义decimal控件
function myNumberField(id,parent,label,labelwidth,top,left,height,width,length,decimal,value,min,max,style){
	var str='';
	if (height==0) height=systext.height+2;
	if (parent=='') parent='main';
	if (labelwidth==0 && label!=''){
		myFieldLabel(id,parent,label,labelwidth,top,left+2,height,width);
		top=1*(top+syslabel.fontsize+syslabel.topmargin+2); //换行显示文本
		labelwidth=0;
	}else{
		myFieldLabel(id,parent,label,labelwidth,top,left,height,width);
	}	
	str+='<div id="'+id+'_div"><input ';
	if (value!=undefined && value!=''){  //设置初值
		str+=' value="'+value+'"';
	}
	str+=' class="easyui-numberbox" type="text" id="'+id+'" style="text-align:right; padding:0px 4px 0px 4px;" ';
	if (value!='') str+=" value='"+value+"'";
	str+='\n data-options="';
	if (decimal>0) str+="precision:"+decimal+"";
	else str+="precision:0";
	if (!isNaN(min)) str+=",min:"+min+"";
	if (!isNaN(max)) str+=",max:"+max+"";
	str+='"></div>\n';
	//console.log(str);
	$("#"+parent).append($(str));
	$("#"+id+'_div').css(myTextCss(parent,top,1*(left+labelwidth),height,width));
	$("#"+id).numberbox({height:height, width:width});
	$("#"+id).numberbox('textbox').css('text-align','right');  //右对齐
	$("#"+id).attr('xparent',parent);  //自定义属性
	$("#"+id).attr('xlabel',label);  //自定义属性
	$("#"+id).attr('xid',id);  //自定义属性
}

function myNumericField(id,parent,label,labelwidth,top,left,height,width,length,decimal,value,min,max,style){
	myNumberField(id,parent,label,labelwidth,top,left,height,width,length,decimal,value,min,max,style);
}

function mySearchField(id,parent,label,labelwidth,top,left,height,width,value,style){
	var str='';
	if (parent=='') parent='main';
	if (height==0) height=systext.height;
	if (labelwidth==0 && label!=''){
		myFieldLabel(id,parent,label,labelwidth,top,left+2,height,width);
		top=1*(top+syslabel.fontsize+syslabel.topmargin+2); //换行显示文本
		labelwidth=0;
	}else{
		myFieldLabel(id,parent,label,labelwidth,top,left,height,width);
	}	
	str+='<div id="'+id+'_div"><input ';
	str+=' class="easyui-searchbox easyui-textbox" data-options="prompt:\''+value+'\'" id="'+id+'" style="margin:0px 0px 0px 0px; padding:0px 6px 0px 6px;" ></div>';
	//console.log(str);
	$("#"+parent).append($(str));
	$("#"+id+'_div').css(myTextCss(parent,top,1*(left+labelwidth),height,width));
	$("#"+id).css({height:"100%", width:"100%"});
	$("#"+id).searchbox({height: height});
	$("#"+id).attr('xparent',parent);  //自定义属性
	$("#"+id).attr('xlabel',label);  //自定义属性
	$("#"+id).attr('xid',id);  //自定义属性
	myFieldStyle(id,style);
}

//定义数组checkbox   cccccccheck
function myCheckBoxField(id,parent,label,labelwidth,top,left,rowheight,cols,items){
	//cols为列数，rowheight为行高,items=[c70]aaaa;[u80]bbbbbb;[80]ccccc   u-unchecked  ,c--checked
	//增加一个value值控件，名称为id+'_value'
	if (style!=undefined && style!='') style=';'+style+';';
	else var style='';
	//if (label=='') labelwidth=0;
	if (rowheight<=0) rowheight=systext.rowheight;
	if (parent=='') parent='main';
	if (labelwidth==0 && label!=''){
		myFieldLabel(id,parent,label,labelwidth,top,left+2,0,0);
		top=1*(top+syslabel.fontsize+syslabel.topmargin+2); //换行显示文本
		labelwidth=0;
	}else{
		myFieldLabel(id,parent,label,labelwidth,top,left,0,0);
	}	
	var tmp=items.split(';');
	var r=0;  //记录行数
	var c=1   //记录列数
	var posx=0;
	var posy=0;
	var values='';
	for (var i=1;i<=tmp.length;i++){
		var index1=tmp[i-1].lastIndexOf('[');
		var index2=tmp[i-1].lastIndexOf(']');
		var checked='c';
		var width=0;
		var text=''
		if (index2>index1 && index1>=0){
			text=tmp[i-1].substr(index2+1);
			var checked=tmp[i-1].substr(index1+1,1);
			if (checked=='u' || checked=='c'){
				width=tmp[i-1].substring(index1+2,index2);
			}else{
				width=tmp[i-1].substring(index1+1,index2);
			}
			if (width=='') width='0';	
		}else{
			text=tmp[i-1];
		}
		if (checked=='u') var checked=false;  //布尔值
		else var checked=true;
		values+=';'+text;
		if (i==1 && tmp.length==1) var itemid=id;
		else itemid=id+i;
		if (width==0) width=text.length*syslabel.fontsize+32;
		var str='<div id="'+itemid+'_div"><input type="checkbox" id="'+itemid+'" />'+text+'</div>';  //value为自定义属性
		$("#"+parent).append($(str));
		$("#"+itemid+'_div').css(myTextCss(parent,top+posy,left+labelwidth+1*posx,0,width));
		//console.log(str);
		$("#"+itemid).prop('checked',checked);  //设置初值选中状态
		$("#"+itemid).attr('xparent',parent);  //自定义属性
		$("#"+itemid).attr('xlabel',label);  //自定义属性
		$("#"+itemid).attr('type','checkboxitem');  //自定义属性
		$("#"+itemid).attr('xtype','checkboxitem');  //自定义属性
		$("#"+itemid).attr("xtext",text);  //自定义属性设置文本值，子项标题
		$("#"+itemid).attr("xid",itemid);  //
		if (i==1 && tmp.length==1) $("#"+itemid).attr("xgroupid",'');  //所在组的ID为空，只有一个选项的情况
		else $("#"+itemid).attr("xgroupid",id);  //设置所在组的ID，赋值函数中使用到
		if (c>=cols){
			posx=0; c=1; posy+=rowheight;
		}else{
			posx+=1.0*width; c++;		
		}
	}//for
	if (tmp.length>1){
		$("#"+parent).append("<input hidden='true' type='hidden' id='"+id+"' />");
		$("#"+id).val(values.substr(1));
		$("#"+id).attr('type','checkboxgroup');  //自定义属性
		$("#"+id).attr('xparent',parent);  //自定义属性
		$("#"+id).attr('xlabel',label);  //自定义属性
		$("#"+id).attr('xid',id);  //自定义属性
	}
	$("#"+id).attr('xitemcount',tmp.length);  //自定义属性，记录子项个数
	//onchange事件
	for (var i=1;i<=tmp.length;i++){
		if (i==1 && tmp.length==1) var itemid=id;
		else itemid=id+i;
		$("#"+itemid).on("change", function (event) {
			myCheckBoxChange(id,values.substr(1));
		});
	}
}
	
//定义数组combo
function myComboField(id,parent,label,labelwidth,top,left,height,width,items,value,style){
	if (style!=undefined && style!='' ) style=';'+style+';';
	else var style='';
	//if (label=='') labelwidth=0;
	if (height==0) height=systext.height;
	if (parent=='') parent='main';
	if (labelwidth==0 && label!=''){
		myFieldLabel(id,parent,label,labelwidth,top,left+2,height,width);
		top=1*(top+syslabel.fontsize+syslabel.topmargin+2); //换行显示文本
		labelwidth=0;
	}else{
		myFieldLabel(id,parent,label,labelwidth,top,left,height,width);
	}	
	var str='var '+id+'source =[';
	var tmp=items.split(';');
	for (var i=0;i<tmp.length;i++){
		if (i>0) str+=',';
		str+='{"'+id+'":"'+tmp[i]+'","sysid":"'+i+'"}';
	}
	str+='];';
	eval(str);
	str='<div style="margin:0;" id="'+id+'_div" ><input ';
	if (value!=undefined && value!=''){  //设置初值
		str+=' value="'+value+'"';
	}
	str+=' class="easyui-combobox" id="'+id+'" style="padding:0px 6px 0px 6px;" /></div>';
	$("#"+parent).append($(str));
	$("#"+id+'_div').css(myTextCss(parent,top,1*(left+labelwidth),height,width));
	$("#"+id).css({width: width, height: height});
	$('#'+id).combobox({
		data: eval(id+'source'),
		valueField: id,
		textField: id,
		formatter: function(row){
			return '<div align="left" style="padding:2px 0px 0px 4px;">' + eval('row.'+id)+'</div>';
		}
	});	
	if (style.indexOf('readonly')>=0) $('#'+id).combobox({'readonly': true});
	if (style.indexOf('autodrop')>=0) $('#'+id).combobox({'editable': false});
	if (tmp.length<=12) $('#'+id).combobox({panelHeight: 'auto'});
	else $('#'+id).combobox({panelHeight: 12*(syslabel.fontsize+8)});
	$('#'+id).attr('type','combobox');  //自定义属性
	$("#"+id).attr('xparent',parent);  //自定义属性
	$("#"+id).attr('xlabel',label);  //自定义属性
	$("#"+id).attr('xid',id);  //自定义属性
	//事件
	$('#'+id).combobox({
		onSelect: function(record) {  //选中事件
			if (record) {
			//console.log(record);
				$("#"+id).attr('xrecord',JSON.stringify(record));  //自定义属性，记录当前选中的选项记录
				$("#"+id).attr('xindex',record.sysrowno-1);  //自定义属性，记录当前选中的选项记录				
			}else{
				$("#"+id).attr('xrecord','{}');  //自定义属性，记录当前选中的选项记录
				$("#"+id).attr('xindex',-1);  //自定义属性，记录当前选中的选项记录				
			}
			if (style.indexOf(';fnselect;')>=0) fnonSelectCombo(id,record);
			$("#"+id).next("span").find("input").focus();
		}
	});
	//事件定义放在最后
	//复选事件
	if (style.indexOf(';checkbox;')>=0){
		$("#"+id).combobox({
			formatter: function(row){
				var s ='<input type="checkbox" class="combobox-checkbox">'+eval("row."+id);
				return s;
			},
			multiple:true,
			editable: false,
			separator:';',
			onLoadSuccess:function(){
				var opts = $(this).combobox('options');
				var target = this;
				var values = $(target).combobox('getValues');
				$.map(values, function(value){
					var el = opts.finder.getEl(target, value);
					el.find('input.combobox-checkbox')._propAttr('checked', true);
				})
			},
			onSelect:function(row){
				var opts = $(this).combobox('options');
				var el = opts.finder.getEl(this, row[opts.valueField]);
				el.find('input.combobox-checkbox')._propAttr('checked', true);
			},
			onUnselect:function(row){
				var opts = $(this).combobox('options');
				var el = opts.finder.getEl(this, row[opts.valueField]);
				el.find('input.combobox-checkbox')._propAttr('checked', false);
			}
		});		
	} //if
	if (value==undefined || value==''){  //设置初值
		//设置初值选中第一行
		$('#'+id).combobox('select',eval(id+'source[0].'+id));
	}
		
}

//获取多选下拉框中已经选中条目的下标，返回数组
function myGetSelectedComboIndex(field){
	var index=[];
	var xvalue=$('#'+field).combobox("getValues");
	var xdata=$('#'+field).combobox("getData");
	for (var i=0;i<xvalue.length;i++){
		for (var j=0;j<xdata.length; j++){
			if (xvalue[i]==eval('xdata['+j+'].'+field)){
				index.push(j);
				break;
			}
		}
	}
	return index;
}
//cttttttttttt  ctreeeeeeeeeeeee
function myDBComboTreeField(id,parent,label,labelwidth,top,left,height,width,sql,keyfield,sortfield,style){
	//style可能的选项：checkbox;animate;lien;edit
	//if (label=='') labelwidth=0;
	if (height==0) height=systext.height;
	if (parent=='') parent='main';
	if (labelwidth==0 && label!=''){
		myFieldLabel(id,parent,label,labelwidth,top,left+2,height,width);
		top=1*(top+syslabel.fontsize+syslabel.topmargin+2); //换行显示文本
		labelwidth=0;
	}else{
		myFieldLabel(id,parent,label,labelwidth,top,left,height,width);
	}	
	if (style!=undefined && style!='' ) style=';'+style+';';
	else var style='';
    var xcheckbox='false';
	var xanimate='false';
	var xline='true';
	var xedit='false';
	var xleafselect=0;
	if (style!='') style=';'+style+';';
	if (style.indexOf(';checkbox;')>=0) xcheckbox='true'; 
	if (style.indexOf(';line;')>=0) xline='true'; 
	if (style.indexOf(';animate;')>=0) xanimate='true'; 
	if (style.indexOf(';edit;')>=0) xedit='true';
	if (style.indexOf(';leafselect;')>=0) xleafselect=1;
	var str='<div id="'+id+'_div"><input id="'+id+'" style="overflow:auto;" class="easyui-combotree" data-options="animate:'+xanimate+', checkbox:'+xcheckbox+', lines:'+xline;
	if (xedit=='true'){
		str+=',onClick: function(node){ $(this).tree(\'beginEdit\',node.target);}';
	}	
	str+='" /></div>';
	$("#"+parent).append($(str));
	$("#"+id+'_div').css(myTextCss(parent,top,1*(left+labelwidth),height,width+20));
	if (height>0) $("#"+id).css({ height: height });
	if (width>0) $("#"+id).css({width: width});
	$("#"+id).attr('xsql',sql);  //自定义属性，记录基本的sql语句
	$("#"+id).attr('xparent',parent);  //自定义属性
	$("#"+id).attr('xid',id);  //自定义属性
	var source=myLoadComboTreeData(id,sql,keyfield,sortfield,style);
	$('#'+id).combotree({
		valueField:id
	});
	$('#'+id).combotree({ data: source });
	if (source.length<=12) $('#'+id).combotree({panelHeight: 'auto'});
	else $('#'+id).combotree({panelHeight: 12*(syslabel.fontsize+8)});
	var cbtree=$('#'+id).combotree('tree');
	if (source.length > 0) {
		//cbtree.tree('setValue', eval("source[0]."+id));
	}
	cbtree.tree('collapseAll');
	//onBeforeExpand:

	//选中第一个结点
	//var item = cbtree.tree('getRoot');
	//if (item.children) cbtree.tree('expand', item.target);
	//cbtree.tree('select', item.target);
}

function myDBComboField(id,parent,label,labelwidth,top,left,height,width,sql,textfield,masterfield,style){
	//source_id,dataAdapter_id
	if (style!=undefined && style!='' ) style=';'+style+';';
	else var style='';
	var mid='';  //master控件  masterfield="province(provinceid)"为例
	var mfield='';  //master控件对应的值列  
	var index1=masterfield.indexOf("(");
	var index2=masterfield.indexOf(")");
	if (index1>=0 && index2>index1){
		mid=masterfield.substring(0,index1);
		mfield=masterfield.substring(index1+1,index2);
	}else{
		mid=masterfield;
		mfield==masterfield;
	}
	if (mid=='' && mfield!='') mid=mfield;
	if (mid!='' && mfield=='') mfield=mid;
	//masterfield处理结束
	//if (label=='') labelwidth=0;
	if (parent=='') parent='main';
	if (height==0) height=systext.height;
	if (labelwidth==0 && label!=''){
		myFieldLabel(id,parent,label,labelwidth,top,left+2,height,width);
		top=1*(top+syslabel.fontsize+syslabel.topmargin+2); //换行显示文本
		labelwidth=0;
	}else{
		myFieldLabel(id,parent,label,labelwidth,top,left,height,width);
	}	
	if (textfield=='') textfield=id;	
	var str='<div id="'+id+'_div"><input class="easyui-combobox" id="'+id+'" data-options="valueField:\''+id+'\',textField:\''+textfield+'\'"></div>';
	$("#"+parent).append($(str));
	$("#"+id+"_div").css(myTextCss(parent,top,1*(left+labelwidth),0,width));
	$("#"+id).css({width: width, height: height});
	$('#'+id).combobox({
		panelHeight: 'auto',
		valueField: id,
		textField: textfield,
		formatter: function(row){
			return '<div align="left" style="padding:2px 0px 0px 4px;">' + eval('row.'+textfield)+'</div>';
		},		
		onSelect: function(record) {  //选中事件
			if (record) {
				$("#"+id).attr('xrecord',JSON.stringify(record));  //自定义属性，记录当前选中的选项记录
				$("#"+id).attr('xindex',record.sysrowno-1);  //自定义属性，记录当前选中的选项记录				
			}else{
				$("#"+id).attr('xrecord','{}');  //自定义属性，记录当前选中的选项记录
				$("#"+id).attr('xindex',-1);  //自定义属性，记录当前选中的选项记录				
			}
			if (style.indexOf(';fnselect;')>=0) fnonSelectCombo(id,record);
			$("#"+id).next("span").find("input").focus();
		}
	});
	if (style.indexOf('readonly')>=0) $('#'+id).combobox({'readonly': true});
	if (style.indexOf('autodrop')>=0) $('#'+id).combobox({'editable': false});
	$("#"+id).attr('xparent',parent);  //自定义属性
	//$("#"+id).attr('xmasterfield',mid);  //自定义属性
	$("#"+id).attr('xlabel',label);  //自定义属性
	$("#"+id).attr('xid',id);  //自定义属性
	//$("#"+id).attr('xismasterfield',false);  //自定义属性
	//定义联动事件cascade
	//console.log(mid+'----'+masterfield+'---'+id);
	if (masterfield!=undefined && masterfield!=''){
		//$("#"+mid).attr('xismasterfield',true);
		$("#"+mid).combobox({
			onSelect: function(record) {  //选中事件
				if (record) {
					$("#"+mid).attr('xrecord',JSON.stringify(record));  //自定义属性，记录当前选中的选项记录
					$("#"+mid).attr('xindex',record.sysrowno-1);  //自定义属性，记录当前选中的选项记录				
					//var xvalue = $("#"+mid).combobox('getValue');
					var xvalue=eval("record."+mfield);
					var sql=$("#"+id).attr('xsql');
					if (xvalue!='')	sql = "select * from ("+sql+") as p where "+mfield+"='"+xvalue+"'";
					//console.log(xvalue+'---'+sql);
					$("#"+id).combobox('clear');
					myGetComboxData(id,sql);
					myBindKeyDownEvent(id);	
				}else{
					$("#"+mid).attr('xrecord','{}');  //自定义属性，记录当前选中的选项记录
					$("#"+mid).attr('xindex',-1);  //自定义属性，记录当前选中的选项记录
				}
				if (style.indexOf(';fnselect;')>=0) fnonSelectCombo(mid,record);
				$("#"+mid).next("span").find("input").focus();
				mySelectOnFocus();
			}
		}); // masterfield event
		//keyboard event放在之后，如果之后出现.combobox()则事件无效
	}else{
		myGetComboxData(id,sql);
	}
	//联动事件结束
	$("#"+id).attr('xsql',sql);  //自定义属性，记录基本的sql语句
	$('#'+id).attr('type','combobox');  //自定义属性
	if (mid!='') mySelectComboByIndex(mid,0);  //选中主下拉框，使其触发select事件
}


//定义checkcombo
function myCheckComboField(id,parent,label,labelwidth,top,left,height,width,items,value){

}

//定义图片combo
function myImageComboField(id,parent,label,labelwidth,top,left,height,width,items,value){

}


function myImageIcon(filename){
	var icon='download64.jpg';
	if (filename!=''){ 
		fileext=filename.substring(filename.lastIndexOf(".")+1,255).toLowerCase();//文件扩展名
		var xvideo=';avi;rmvb;mov;asf;wmv;3gp;flv;mkv;rm;mid;vob;webm;';
		var xaudio=';mp3;wav;wma;';
		var ximage=';jpg;jpeg;gif;pcx;png;bmp;psd;';
		if (fileext==undefined) fileext='';
		if (fileext=='doc' || fileext=='docx') icon='word64.png';
		else if (fileext=='xls' || fileext=='xlsx') icon='excel64.png';  
		else if (fileext=='ppt' || fileext=='pptx') icon='ppt64.png';  
		else if (fileext=='pdf') icon='pdf64.png';
		else if (fileext=='swf') icon='swf64.png';
		else if (fileext=='fla') icon='flash64.png';
		else if (fileext=='html' || fileext=='htm') icon='html64.png';  
		else if (fileext=='rar') icon='rar64.png';
		else if (fileext=='zip') icon='zip64.png';
		else if (fileext=='swf') icon='swf64.png';
		else if (fileext=='exe') icon='fileexe64.png';
		else if (ximage.indexOf(fileext)>=0) icon='image64.png';
		else if (xaudio.indexOf(fileext)>=0) icon='audio64.png';
		else if (xvideo.indexOf(fileext)>=0) icon='video64.png';
	}
	return icon;
}

//定义image控件iiiimmmmmmmage
function myImageField(id,parent,label,labelwidth,top,left,height,width,src){
	var str='';
	if (width==0) width=300;
	if (parent=='') parent='main';
	if (height==0) height=systext.height;
	if (labelwidth==0 && label!=''){
		myFieldLabel(id,parent,label,labelwidth,top,left+2,height,width);
		top=1*(top+syslabel.fontsize+syslabel.topmargin+2); //换行显示文本
		labelwidth=0;
	}else{
		myFieldLabel(id,parent,label,labelwidth,top,left,height,width);
	}
	var str='<img src="'+src+'" id="'+id+'" style="position: absolute; top:'+top+'px; left:'+left+'px; width:'+width+'px; height:'+height+'px; padding-left:0px 0px 0px 0px; border:false" />';
	$("#"+parent).append($(str));
	$("#"+id).css(myTextCss(parent,top,1*(left+labelwidth),0,width));
	
	$("#"+id).attr('xparent',parent);  //自定义属性
	$("#"+id).attr('xlabel',label);  //自定义属性
	$("#"+id).attr('xtype','image');  //自定义属性
	$("#"+id).attr('type','image');  //自定义属性
	$("#"+id).attr('xid',id);  //自定义属性
	$("#"+id).attr('xwidth',width);  //自定义属性
	$("#"+id).attr('xheight',height);  //自定义属性
	if (src!='' && height>0 && width>0) myResizeImage(id,src,height,width);	
}

//图形缩放函数
function myResizeImage(img,src,winheight,winwidth){
	if (winheight>0 && winwidth>0){
		var image=new Image();
		image.src=src;
		aheight=image.height+0;  
		awidth=image.width+0;
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
				$("#"+img).css({width:awidth, height:aheight});
			}
		};
		return ({width:awidth, height:aheight});
	}				
}		

function myHLine(id,parent,top,left,height,width,style){
	if (style==undefined) var style='black';
	var src='system/images/hline.gif';
	var str='<img src="'+src+'" id="'+id+'" style="position: absolute; top:'+top+'px; left:'+left+'px; width:'+width+'px; height:'+height+'px; padding-left:0; border:false" />';
	$("#"+parent).append($(str));
	$("#"+id).css(myTextCss(parent,top,left,height,width));
}
function myLine(id,parent,top,left,height,width,style,color){
	//alert(height+'---'+width);
	if (color==undefined) var color='black';
	if (style==undefined) var style='';
	style=';'+style+';';
	if (style.indexOf(";bevel;")>=0){
		if (height==1){
			var str='<div id="'+id+'1"><table border="0" cellspacing="0" cellpadding="0" height='+height+' style="border-color:gray; border-left-style:solid; border-width:'+width+'px"><tr><td valign=top></table></div>';	
			str+='<div id="'+id+'2"><table border="0" cellspacing="0" cellpadding="0" height='+height+' style="border-color:white; border-left-style:solid; border-width:'+width+'px"><tr><td valign=top></table></div>';	
			$("#"+parent).append($(str));
			$("#"+id+'1').css(myTextCss(parent,top,left,height,width));
			$("#"+id+'2').css(myTextCss(parent,top+height,left,height,width));
		}else if (width==1){
			var str='<div id="'+id+'1"><table border="0" cellspacing="0" cellpadding="0" height='+height+' style="border-color:gray; border-left-style:solid; border-width:'+width+'px"><tr><td valign=top></table></div>';	
			str+='<div id="'+id+'2"><table border="0" cellspacing="0" cellpadding="0" height='+height+' style="border-color:white; border-left-style:solid; border-width:'+width+'px"><tr><td valign=top></table></div>';	
			$("#"+parent).append($(str));
			$("#"+id+'1').css(myTextCss(parent,top,left,height,width));
			$("#"+id+'2').css(myTextCss(parent,top,left+width,height,width));
		}
	}else{
		//var str='<div id="'+id+'"><hr style="position:absolute; top:'+top+'px; left:'+left+'px; height:'+height+'px; width:'+width+'px;" /></div>';
		var str='<div id="'+id+'"><table border="0" cellspacing="0" cellpadding="0" height='+height+' style="border-color:'+color+'; border-left-style:solid; border-width:'+width+'px"><tr><td valign=top></table></div>';	
		$("#"+parent).append($(str));
		$("#"+id).css(myTextCss(parent,top,left,height,width));
	}
}

function myClearFileField(fieldset){
	//清空file选择框
	var fields=fieldset.split(';');
	for (var i=0;i<fields.length;i++){
		var id=fields[i];
		var file = document.getElementById(id);
		if (file.outerHTML) {  // for IE, Opera, Safari, Chrome
			file.outerHTML = file.outerHTML;
		}else{ // FF(包括3.5)
			file.value = "";
		}
		//清空后onchange事件失效，需要重新定义
		btnid=id+'button';
		if ($("#"+btnid).length>0) $("#"+btnid).linkbutton('disable');
	}	
}

function myFileFieldChange(fieldset){
	//清空file选择框
	var fields=fieldset.split(';');
	for (var i=0;i<fields.length;i++){
		var id=fields[i];
		//清空后onchange事件失效，需要重新定义
		var btnid=id+'button';
		if ($("#"+btnid).length>0){
			$("#"+id).bind('change',function(v){
				var filename = $("#"+id).val();
				if (filename=='') $("#"+btnid).linkbutton('disable');
				else $("#"+btnid).linkbutton('enable');
			});
		}
	}	
}



function myAddAttachment(fileupload,parent){
	//console.log($('#'+fileupload));
	var icon=myImageIcon($('#'+fileupload).attr('xsourcefile'));
	for (var n=1; n<=sys.maxfilenumber; n++){
		if ($('#filediv'+n).length==0){
			break;
		}
	}
	myHiddenFields('filesizedesc'+n+';filesourcename'+n+';fileosname'+n+';filesize'+n+';fileext'+n+';uploaddate'+n);
	mySetValue('filesizedesc'+n,$('#'+fileupload).attr('xfilesizedesc'));
	mySetValue('filesourcename'+n,$('#'+fileupload).attr('xsourcefile'));
	mySetValue('fileosname'+n,$('#'+fileupload).attr('xfileosname'));
	mySetValue('filesize'+n,$('#'+fileupload).attr('xfilesize'));
	mySetValue('fileext'+n,$('#'+fileupload).attr('xfileext'));
	mySetValue('uploaddate'+n,mySysDateTime('datetime'));
	mySetValue('downloadtimes'+n,'0');
	$('#filediv'+(n)).remove();
	var str='';
	str+='<div id="filediv'+(n)+'" style="width:220px; display:block; float:left; margin:4px 0px 0px 4px;"></div>';
	$('#'+parent).append($(str));
	str='<div><a href="javascript:myDeleteAttachment('+n+');"><img src="system/images/deletefile.png" height="16px" width="16px" /></a><center><img src="system/images/'+icon+'" height="64px" width="64px" /></div>';
	str+='<div style="text-align:center; width:100%; margin:4px 0px 4px 0px;" >'+myGetValue('filesourcename'+n)+'</div>';
	str+='<div style="text-align:center;" >文件大小：'+myGetValue('filesizedesc'+n)+'</div>';
	str+='</center>';
	$('#filediv'+n).append($(str));
	//console.log(str);
}

function myShowAttachment(result,parent){
	for (var n=1; n<=sys.maxfilenumber; n++){
		$('#filediv'+n).remove();
		mySetValue('fileosname'+n,'');
	}  
	for (var n=1;n<=result.length;n++){
		var icon=myImageIcon(result[n-1].filesourcename);
		myHiddenFields('filesizedesc'+n+';filesourcename'+n+';fileosname'+n+';filesize'+n+';fileext'+n+';downloadtimes'+n+';uploaddate'+n);
		mySetValue('filesizedesc'+n,result[n-1].filesizedesc);
		mySetValue('filesourcename'+n,result[n-1].filesourcename);
		mySetValue('fileosname'+n,result[n-1].fileosname);
		mySetValue('filesize'+n,result[n-1].filesize);
		mySetValue('fileext'+n,result[n-1].fileext);
		mySetValue('uploaddate'+n,result[n-1].uploaddate);
		mySetValue('downloadtimes'+n,result[n-1].downloadtimes);
		var str='';
		str+='<div id="filediv'+n+'" style="width:220px; display:block; float:left; margin:4px 0px 0px 4px;"></div>';
		$('#'+parent).append($(str));
		//console.log(parent+'---'+$('#'+parent).length);
		str='<div><a href="javascript:myDeleteAttachment('+n+');"><img src="system/images/deletefile.png" height="16px" width="16px" /></a><center><img src="system/images/'+icon+'" height="72px" width="72px" /></div>';
		str+='<div style="text-align:center; width:100%; margin:4px 0px 4px 0px;" >'+myGetValue('filesourcename'+n)+'</div>';
		str+='<div style="text-align:center;" >文件大小：'+myGetValue('filesizedesc'+n)+'</div>';
		str+='</center>';
		$('#filediv'+n).append($(str));
		//console.log(str);
	}
}

function myDownLoadAttachment(result,parent){
	for (var n=1; n<=sys.maxfilenumber; n++){
		$('#filediv'+n).remove();
		mySetValue('fileosname'+n,'');		
	}  
	for (var n=1;n<=result.length;n++){
		var icon=myImageIcon(result[n-1].filesourcename);
		myHiddenFields('filesizedesc'+n+';filesourcename'+n+';fileosname'+n+';filesize'+n+';fileext'+n+';downloadtimes'+n+';uploaddate'+n);
		mySetValue('filesizedesc'+n,result[n-1].filesizedesc);
		mySetValue('filesourcename'+n,result[n-1].filesourcename);
		mySetValue('fileosname'+n,result[n-1].fileosname);
		mySetValue('filesize'+n,result[n-1].filesize);
		mySetValue('fileext'+n,result[n-1].fileext);
		mySetValue('uploaddate'+n,result[n-1].uploaddate);
		mySetValue('downloadtimes'+n,result[n-1].downloadtimes);
		var str='';
		str+='<div id="filediv'+n+'" style="width:220px; display:block; float:left; margin:4px 0px 0px 4px;"></div>';
		$('#'+parent).append($(str));
		str='<div><a href="javascript:myDownLoadFile('+n+');"><center><img src="system/images/'+icon+'" height="72px" width="72px" /></div>';
		str+='<div style="text-align:center; width:100%; margin:4px 0px 4px 0px;" >'+myGetValue('filesourcename'+n)+'</div>';
		str+='<div style="text-align:center;" >文件大小：'+myGetValue('filesizedesc'+n)+'</div>';
		str+='</center></a>';
		$('#filediv'+n).append($(str));
		//console.log(str);
	}
}

function myDeleteAttachment(n){
	$('#filediv'+n).remove();
	$("#fileosname"+n).val('');  //设置fileosename为空
}
	
//定义fileupload控件fffffupload
function myFileField(id,parent,top,left,height,width,buttonalign){
	//上传按钮名称：id+'button'; 进度条id+'bar'
	var btnid=id+'button';
	var barid=id+'bar';
	var winid=id+'window';
	var str='';
	if (width==0) width=300;
	if (parent=='') parent='main';
	if (height==0) height=systext.height;
	/*
	if (labelwidth==0 && label!=''){
		myFieldLabel(id,parent,label,labelwidth,top,left+2,height,width);
		top=1*(top+syslabel.fontsize+syslabel.topmargin+2); //换行显示文本
		labelwidth=0;
	}else{
		myFieldLabel(id,parent,label,labelwidth,top,left,height,width);
	}
	*/
	var btnleft=left+4;
	var btntop=top+height+4;
	var xtop=top;
	var xleft=left;
	if (buttonalign=='right'){
		width=width-75;
		var btnleft=left+width+9;
		var btntop=top-2;
	}else if (buttonalign=='left'){
		var btnleft=left;
		var btntop=top-2;
		left=left+75;
		width=width-75;
	}
	var str='<input type="file" id="'+id+'" style="position: absolute; top:'+top+'px; left:'+left+'px; width:'+width+'px; height:'+height+'px; padding-left: 4px;" />\n';
	$("#"+parent).append($(str));
	$("#"+id).css(myTextCss(parent,top,left,0,width));
	//定义进度条窗口
	myWindow(winid,'正在上传',0,0,70,320,'','');
	str="<div class='easyui-progressbar' id='"+barid+"'></div>";
	$("#"+winid).append($(str));
	$("#"+barid).css(myTextCss(winid,4,2,24,300));
	$("#"+barid).progressbar();
	if (buttonalign!='none'){ //不显示按钮
		myButton(btnid,parent,'上传',btntop,btnleft,26,68,'uploadIcon','','');
		var filename = $("#"+id).val();
		if (filename=='') $("#"+btnid).linkbutton('disable');
		else $("#"+btnid).linkbutton('enable');
		$("#"+id).bind('change',function(v){
			var filename = $("#"+id).val();
			if (filename=='') $("#"+btnid).linkbutton('disable');
			else $("#"+btnid).linkbutton('enable');
		});
		/*
		$("#"+id).change(function(){  
            var filename = $(this).val();
			if (filename=='') $("#"+btnid).linkbutton('disable');
			else $("#"+btnid).linkbutton('enable');
        });
        */		
		$("#"+btnid).bind('click',function(e){
			//myFileEvents(id,'click');
		});
	}
	$("#"+id).attr('xparent',parent);  //自定义属性
	$("#"+id).attr('xlabel',''); //label //自定义属性
	$("#"+id).attr('xid',id);  //自定义属性
	$("#"+id).attr('xsourcefile','');  
	$("#"+id).attr('xfileosname','');  
	$("#"+id).attr('xtargetfile','');  
	$("#"+id).attr('xfilesize',0);  
	$("#"+id).attr('xfilesizedesc','');  
	$("#"+id).attr('xtargetpath','');  
	$("#"+id).attr('xfileext','');  
}

//fffffffffffff???????
function myFileupLoad(id,targetpath,targetname,filetype){  //下载多个文件
	if (filetype==undefined) var filetype='';
	var data={};
	var btnid=id+'button';
	var winid=id+'window';
	var barid=id+'bar';
	var filename=$("#"+id).val();
	var fileext=filename.substring(filename.lastIndexOf(".")+1,255).toLowerCase();//文件扩展名
	//alert(filetype+'------'+fileext+'---'+(';'+filetype+';').indexOf(';'+fileext+';'));
	if (filetype!='' && (';'+filetype+';').indexOf(';'+fileext+';')<0){
		data={"error":"文件类型错误，上传失败！"};
		var msg=filetype.replaceAll(';',',');  //;为回车符代号
		myMessage('文件扩展名限于：'+msg+'@n文件类型错误，上传失败！','info');
		myClearFileField(id); //清空file选择框,onchange事件失效
		myFileFieldChange(id); //清空file选择框,onchange事件失效
	}else{	
		$("#"+winid).window('open');
		$("#"+barid).progressbar('setValue',0);
		//var fileObj = $("#"+id)[0].files[0]; // 获取文件对象
		var fileObj = document.getElementById(id).files[0];
		var form = new FormData();  // FormData 对象
		form.append("file", fileObj);// 文件对象
		var xhr = new XMLHttpRequest(); //XMLHttpRequest 对象
		xhr.open("post", "system//easyui_fileUpLoad.jsp?targetname="+targetname+"&targetpath="+targetpath, true);
		xhr.onload = function () {
			if (xhr.status == 200){
				data = JSON.parse(xhr.responseText);
				$("#"+id).attr('xerror',data.error);  
				if (data.error == ''){
					$("#"+id).attr('xfilesize',data.filesize);  
					$("#"+id).attr('xfilesizedesc',data.filesizedesc);
					$("#"+id).attr('xfileosname',data.fileosname);  
					$("#"+id).attr('xsourcefile',data.sourcefile);  
					$("#"+id).attr('xtargetfile',data.targetfile);  
					$("#"+id).attr('xtargetpath',data.targetpath);  
					$("#"+id).attr('xfileext',data.fileext);
					myMessageShow('文件已经上传成功！');
					$("#"+btnid).linkbutton('disable');
				}else{
					myMessage('文件上传失败！','error');
					//console.log(data.message);	        		
				}
				$("#"+winid).window('close');
				myClearFileField(id); //清空file选择框,onchange事件失效
				myFileFieldChange(id); //清空file选择框,onchange事件失效
				myFileEvents(id,'upload');  //执行上传之后的补充动作
			} 
		};
		
		//侦查当前附件上传情况
		xhr.upload.onprogress = function(evt) {
			loaded = evt.loaded;
			tot = evt.total;
			per = Math.floor(100.00 * loaded / tot); //已经上传的百分比
			//console.log(per);
			//$("#bar"+id).css("width", per+"%");
			$("#"+id+"bar").progressbar('setValue', per);
		};		
		xhr.send(form);
	}	
	//console.log(data);
	return data;
}
    
//定义编辑器
function myEditorField(id,parent,label,labelwidth,top,left,height,width,value){
	var str='';
	if (parent=='') parent='main';
	if (height==0) height=systext.height;
	if (labelwidth==0 && label!=''){
		myFieldLabel(id,parent,label,labelwidth,top,left+2,height,width);
		top=1*(top+syslabel.fontsize+syslabel.topmargin+2); //换行显示文本
		labelwidth=0;
	}else{
		myFieldLabel(id,parent,label,labelwidth,top,left,height,width);
	}	
	$("#"+parent).append("<div id='"+id+"_div'><textarea id='"+id+"'></textarea></div>");
	$("#"+id+"_div").css(myTextCss(parent,top,1*(left+labelwidth),height,width));
	if (height>0) $("#"+id).jqxEditor({height: height});
	else $("#"+id).jqxEditor({height: '100%'});
	if (width>0) $("#"+id).jqxEditor({width: width});
	else $("#"+id).jqxEditor({width: '100%'});
	$("#"+id).jqxEditor(sys.theme);
	if (value!=undefined && value!=''){  //设置初值
		$("#"+id).val(value);
	}
	//编辑器本地化
	$("#"+id).jqxEditor({localization: {"bold": "加粗","italic": "斜体","underline": "下划线","format": "格式", "font": "字体","size": "字体大小", "color": "字体颜色", "background": "背景颜色",	"left": "左对齐", "center": "居中",	"right": "右对齐", 
	"outdent": "文字左移", "indent": "文字右移", "ul": "分段", "ol": "分级", "image": "插入图片", "link": "插入链接", "html": "html语言", "clean": "格式化" }});
}

function myHref(id,parent,label,top,left,height,width,url,style){
	myhref(id,parent,label,top,left,height,width,url,style);
}
function myhref(id,parent,label,top,left,height,width,url,style){
	if (style!=undefined) style=';'+style+';';
	else var style='';
	var target='';
	if (url=='') url='#';
	if (style.indexOf(";blank;")>=0) target='_blank';
	var str='<div id="'+id+'_div" style="position:absolute">';
	//alert(style);
	if (style.indexOf(';[')>=0) str+='【';
	str+='<a id="'+id+'" href="'+url+'" target="'+target+'" >'+label+'</a>';
	if (style.indexOf('];')>=0) str+='】';
	str+='</div>';
	//console.log(str);
	$("#"+parent).append($(str));
	$("#"+id+"_div").css(myTextCss(parent,top,left,height,width));
	$("#"+id+"_div").css({"font-size":syslabel.fontsize});
}

//ttttttttree
//function myDBTree(id,parent,title,top,left,height,width,sql,keyfield,sortfield,style){
function myDBTree(pmyTree1){
	//style可能的选项：checkbox;animate;lien;edit;full;menu:
	var str='';
	if (pmyTree1.parent=='') pmyTree1.parent='main';
	var xcheckbox='false';
	var xanimate='false';
	var xline='false';
	var xedit='false';
	if (pmyTree1.checkbox) xcheckbox='true'; 
	if (pmyTree1.line) xline='true'; 
	if (pmyTree1.animate) xanimate='true'; 
	if (pmyTree1.editable) xedit='true';
	str+='<div id="'+pmyTree1.id+'" style="overflow:auto;" class="easyui-tree" data-options="animate:'+xanimate+', checkbox:'+xcheckbox+', lines:'+xline;
	if (xedit=='true'){
		str+=',onClick: function(node){ $(this).tree(\'beginEdit\',node.target);}';
	}	
	str+='"></div>';
	//alert(pmyTree1.parent);
	$("#"+pmyTree1.parent).append($(str));
	var h=$("#"+pmyTree1.parent).height()*1;
	var w=$("#"+pmyTree1.parent).width()*1;
	if (pmyTree1.height>0) $("#"+id).css({ height: pmyTree1.height });
	else $("#"+pmyTree1.id).css({ height: '100%' });
	if (pmyTree1.width>0) $("#"+pmyTree1.id).css({width: pmyTree1.width});
	else $("#"+pmyTree1.id).css({width: '100%'});
	$("#"+pmyTree1.id).attr('xsql',pmyTree1.sql);  //自定义属性，记录基本的sql语句
	$("#"+pmyTree1.id).attr('xtype','tree');  //自定义属性，记录基类型
	$("#"+pmyTree1.id).attr('xparent',pmyTree1.parent);  //自定义属性
	$("#"+pmyTree1.id).attr('xtitle',pmyTree1.title);  //自定义属性
	$("#"+pmyTree1.id).attr('xid',pmyTree1.id);  //自定义属性
	var source=myLoadTreeData(pmyTree1);
	$('#'+pmyTree1.id).tree({ data: source });
	$("#"+pmyTree1.id).tree('collapseAll');
	$('#'+pmyTree1.id).tree({  //双击展开或收缩结点
		 onDblClick: function(node){
			if (node.state=='closed') $(this).tree('expand', node.target);
			else $(this).tree('collapse', node.target);
			myTreeEvents(pmyTree1.id,'ondblclick',node);
		},
		 onSelect: function(node){
		 	pmyTree1.selectednode=node;
			myTreeEvents(pmyTree1.id,'onselect',node);
		}
	});
	//选中第一个结点
	var item = $('#'+pmyTree1.id).tree('getRoot');
	if (item!=null){
		if (item.children) $("#"+pmyTree1.id).tree('expand', item.target);
		$("#"+pmyTree1.id).tree('select', item.target);
	}
	return pmyTree1;
}

//加载树结点，分两种模式
function myLoadTreeData(pmyTree1){
	if (pmyTree1.style!='full'){ //逐级展开,子节点的id值为‘*’+父节点值
		$("#"+pmyTree1.id).tree({
			onBeforeExpand: function (node){  //点击展开事件
				var pid=node.id;
				//var sql=$('#'+pmyTree1.id).attr('xsql');
				var child_node = $('#'+pmyTree1.id).tree('getChildren', node.target);
				if (child_node.length==1 && child_node[0].id=='_'+pid){ //生成子节点
					if (pmyTree1.sql!='') xsql="select * from ("+pmyTree1.sql+") as p where parentnodeid='"+pid+"'";
					else xsql='';
					//console.log(xsql);	
					$.ajax({
						url: "system//easyui_getChildNodes.jsp",
						data: { database: sysdatabasestring, selectsql: xsql, keyfield:pmyTree1.keyfield, sortfield:pmyTree1.sortfield, style:pmyTree1.style }, 
						async: false, method: 'post',						    
						success: function(data) {
							var source=eval(data);
							$('#'+pmyTree1.id).tree('remove', child_node[0].target); //删除子节点
							$('#'+pmyTree1.id).tree('append', {  //增加数据作为子节点
								parent: node.target,
								data: source 
							});
						}    
					});
				};
				myTreeEvents(pmyTree1.id,'onBeforeExpand',node);
			}
		});		
	}//if 'full'判断结束
	var source=[];  
	if (pmyTree1.style=='full'){ //一次性全部获取
		$.ajax({
			url: "system//easyui_getAllTreeNodes.jsp",
			data: { database: sysdatabasestring, selectsql:pmyTree1.sql, keyfield:pmyTree1.keyfield, sortfield:pmyTree1.sortfield }, 
			async: false, method:'post',
			success: function(data) {
				source=eval(data);
			}    
		});
	}else{  
		//分层展开结点
		if (pmyTree1.sql!='') xsql="select * from ("+pmyTree1.sql+") as p where parentnodeid=''";  //第一层
		else xsql='';
		$.ajax({
			url: "system//easyui_getChildNodes.jsp",
			data: { database: sysdatabasestring, selectsql: xsql, keyfield:pmyTree1.keyfield, sortfield:pmyTree1.sortfield, style:pmyTree1.style }, 
			async: false, method: 'post',						    
			success: function(data) {
				source=eval(data);
			}    
		});
		//$("#"+id).tree('collapseAll');
	}
	return source; 
}	

//加载树结点，分两种模式
function myLoadComboTreeData(id,sql,keyfield,sortfield,style){
	if ((';'+style+';').indexOf(';full;')<0){ //逐级展开
		$("#"+id).combotree({
			onBeforeExpand: function (node){  //点击展开事件
				var pid=eval("node."+keyfield);
				//var sql=$('#'+id).attr('xsql');
				var xcbtree=$('#'+id).combotree('tree');
				var child_node = xcbtree.tree('getChildren', node.target);
				if (child_node.length==1 && child_node[0].id=='_'+pid){ //生成子节点
					if (sql!='') xsql="select * from ("+sql+") as p where parentnodeid='"+pid+"'";
					else xsql='';
					//alert(xsql);
					$.ajax({
						url: "system/easyui_getChildNodes.jsp",
						data: { database: sysdatabasestring, selectsql: xsql, keyfield:keyfield, sortfield:'' }, 
						async: false, method: 'post',						    
						success: function(data) {
							var source=eval(data);
							xcbtree.tree('remove', child_node[0].target); //删除子节点
							xcbtree.tree('append', {  //增加数据作为子节点
								parent: node.target,
								data: source 
							});
						}    
					});
				};
			}
		});		
	}//if 'full'判断结束
	
	//var cbtree=$('#'+id).combotree('tree');	
	var source=[];  
	if ((';'+style+';').indexOf(';full;')>=0){ //一次性全部获取
		$.ajax({
			url: "system/easyui_getAllTreeNodes.jsp",
			data: { database: sysdatabasestring, selectsql: sql, keyfield:keyfield, sortfield:sortfield }, 
			async: false, method: 'post',    
			success: function(data) {
				//console.log(data);
				source=eval(data);
				//$('#'+id).tree({ data: source });
			}    
		});
		//$("#"+id).tree('collapseAll');
	}else{  
		//分层展开结点
		if (sql!='') xsql="select * from ("+sql+") as p where parentnodeid=''";  //第一层
		else xsql='';
		$.ajax({
			url: "system/easyui_getChildNodes.jsp",
			data: { database: sysdatabasestring, selectsql: xsql, keyfield:keyfield, sortfield:sortfield, style:style }, 
			async: false, method: 'post',						    
			success: function(data) {
				source=eval(data);
				//$('#'+id).tree({ data: source });  //加载json数据到树
			}    
		});
		//cbtree.tree('collapseAll');
	}
	return source; 
}	

//生成fieldset
function myFieldset(id,parent,title,top,left,height,width){
	if (parent=='') parent='main';
	var str='';
	//str='<fieldset id="'+id+'" style="position: absolute; padding:0px 0px 0px 15px; margin:0px 0px 0px 0px; padding-right:0px; border:1px groove;">'; 
	str='<fieldset id="'+id+'" style="position: absolute; margin:0; padding:0; border:1px solid #B5B8C8;">';  //groove  #990033黑色 
	if (title!='') str+='<legend style="margin:0 10px; padding:0;">'+title+'</legend>';
	str+='</fieldset>';
	$("#"+parent).append($(str));
	//$("#"+id).css(myTextCss(parent,top,left,height,width));
	var css={margin:"0", padding:"0", position:"absolute", top:top+'px', left:left+'px', width:width, height:height, "z-index":2};
	$("#"+id).css(css);
	$("#"+id).css(sys.theme);
	$("#"+id).attr('type','fieldset');  //自定义属性
	$("#"+id).attr('xparent',parent);  //自定义属性
	$("#"+id).attr('xtitle',title);  //自定义属性
	$("#"+id).attr('xid',id);  //自定义属性
}

//生成groupbox
function myGroupbox(id,parent,top,left,height,width,border){
	var str='';
	if (border==1) xborder=true;
	else xborder=false;
	str='<div id="'+id+'" style="position:absolute; top:'+top+'px; left:'+left+'px; padding:0px 0;border:'+xborder+' ">';
	//str+='<fieldset id="'+id+'" style="position:relative; top:0;left:0; width:100%; height:100%; padding:0px 0;border:'+border+'px groove"></fieldset>';
	str+='</div>';
	if (parent!=''){
		$("#"+parent).append($(str));
		$("#"+id+"").css(myTextCss(parent,top,left,height,width));
		$("#"+id).attr('xparent',parent);  //自定义属性
		$("#"+id).attr('xid',id);  //自定义属性
	}
	return str;
}

function myPanel(id,parent,title,top,left,height,width,style){
	if (parent=='') parent='main';
	//窗体底部空4px,
    str='<div class="easyui-panel" id="'+id+'" title="&nbsp;'+title+'" style="position:relative; background:#fafafa; margin:0px 0px 0px 0px; padding:2px 2px 2px 2px;';
    if (width>0) str+='width:'+width+'px;';
    else str+='width: 100%;';
    if (height>0) str+='height:'+height+'px;';
    else str+='height: 100%;';
    str+='"\n';
    str+='data-options="border:false';
    if (height==0 && width==0) str+=',fit:true';
    str+='';
    if (style.indexOf('border')>=0) str+=',border:true';
    else str+=',border:false';
    if (style.indexOf('close')>=0) str+=',closable:true';
    if (style.indexOf('min')>=0) str+=',minimizable:true';
    if (style.indexOf('min')>=0) str+=',maximizable:true';
    if (style.indexOf('collapse')>=0) str+=',collapsible:true';
    str+='" >';
    str+='</div>';
    //console.log(str);
    $('#'+parent).append($(str));
    $('#'+id).panel();
    //if (top>0 && left>0) $("#"+id+"_div").css(myTextCss(parent,top,left,0,0));
	//$("#"+id).attr('type','panel');  //自定义属性
	$("#"+id).attr('xparent',parent);  //自定义属性
	$("#"+id).attr('xid',id);  //自定义属性
	$("#"+id).attr('xtitle',title);  //自定义属性
}


//生成splitbutton
function mySplitButton(id,parent,text,top,left,height,width,icon,style,event){
	if (parent=='') parent='main';
	if (width==0) height=sysbutton.width;
	if (height==0) height=sysbutton.height;
	if (style!='') style=';'+style+';';
	var str='';
	if (style!=undefined && style.indexOf(';menu;')>=0) var menuflag=true;
	else var menuflag=false;
	if (style!=undefined && style.indexOf(';btnsep;')>=0){ //按钮分隔符
		str+='<a href="javascript:void(0)" id="'+id+'_sep" class="btn-separator"></a>';
	}
	str+='<a href="javascript:void(0)" id="'+id+'" class="easyui-splitbutton" style="padding:0; margin:0;"></a>';
	$("#"+parent).append($(str));
	$("#"+id).css(myTextCss(parent,top,left,height,width));
	$("#"+id).attr('xparent',parent);  //自定义属性
	$("#"+id).attr('xid',id);  //自定义属性
	if (icon!=''){
		$("#"+id).splitbutton({'iconCls': icon, iconAlign:'left'});
	}
	if (text!=''){
		$("#"+id).splitbutton({'text': text});
	} 
	if (style!=undefined && style.indexOf(';plain;')>=0){
		$("#"+id).splitbutton({'plain':true});
	}
	if (event!=undefined && event!=''){
		//console.log(event+"(e);");
		$('#'+id).bind('click',function(e){
			eval(event+"(e);");
		});
	}
}	

//生成linkbutton
function myButton(id,parent,text,top,left,height,width,icon,style,event){
	if (parent=='') parent='main';
	if (width==0) height=sysbutton.width;
	if (height==0) height=sysbutton.height;
	if (style!='') style=';'+style+';';
	var str='';
	if (style!=undefined && style.indexOf(';menu;')>=0) var menuflag=true;
	else var menuflag=false;
	if (style!=undefined && style.indexOf(';btnsep;')>=0){ //按钮分隔符
		str+='<a href="javascript:void(0)" id="'+id+'_sep" class="btn-separator"></a>';
	}
	if (menuflag) str+='<a href="javascript:void(0)" id="'+id+'" class="easyui-menubutton" style="padding:0; margin:0;"></a>';
	else str+='<a href="javascript:void(0)" id="'+id+'" class="easyui-linkbutton" style="padding:0; margin:0;"></a>';
	$("#"+parent).append($(str));
	$("#"+id).css(myTextCss(parent,top,left,height,width));
	$("#"+id).attr('xparent',parent);  //自定义属性
	$("#"+id).attr('xid',id);  //自定义属性
	$("#"+id).attr('xtype','linkbutton');  //自定义属性
	if (icon!=''){
		if (menuflag) $("#"+id).menubutton({'iconCls': icon, iconAlign:'left'});
		else $("#"+id).linkbutton({'iconCls': icon, iconAlign:'left'});
	}
	if (text!=''){
		if (menuflag) $("#"+id).menubutton({'text': text});
		else $("#"+id).linkbutton({'text': text});
	} 
	if (style!=undefined && style.indexOf(';plain;')>=0){
		if (menuflag) $("#"+id).menubutton({plain:true});
		else $("#"+id).linkbutton({plain:true});
	}else{
		if (menuflag) $("#"+id).menubutton({plain:false});
		else $("#"+id).linkbutton({plain:false});
	}
	if (event!=undefined && event!=''){
		//console.log(event+"(e);");
		$('#'+id).bind('click',function(e){
			eval(event+"(e);");
		});
	}
}	

function myToolbar(id,parent,buttons,height,width,color){
	if (color==undefined || color=='') var color='#E0ECFF';
	if (height==0) xheight=sysbutton.height+2;
	var str='<div id="'+id+'_div" class="easyui-panel" style="padding:1px 6px 1px 8px; height:'+xheight+'px; position:relative; ';
	if (color!='') str+=' background:'+color+'; ';
	str+=' border-bottom:1px solid #B5B8C8;"></div>';  //只有地边框线
	$("#"+parent).append($(str));
	myButtonGroup(id,id+'_div',buttons,height,width);
}	//

function myButtonGroup(id,parent,buttons,height,width){
	//分隔线的id为id+'_sep'+k。例如:gridbtn_sep1...
	if (parent=='') parent='main';
	if (width==0) width=65;
	var tmp=buttons.split(';');
	var k=1;
	for (var i=0; i<tmp.length; i++){
		var fields=tmp[i].split('/');
		var fid='';
		var icon='';
		var text='';
		var menu='';
		if (fields.length>=1){
			text=fields[0];
			if (fields.length>=2) fid=fields[1];
			if (fields.length>=3) icon=fields[2];
			if (fields.length>=4) menu=fields[3];
			if (text=='-' || fields.length==1){
				//alert(id);
				var str='<span style="padding:3px 0;"><a id="'+id+'_sep'+k+'" href="javascript:void(0)" class="btn-separator" style="';
				if (height>0) str+='height:'+height+'px;';
				str+='"></a></span>';
				$("#"+parent).append($(str));
				k++;
			}else{
				if (menu=='') var str='<a href="javascript:void(0)" id="'+fid+'" class="easyui-linkbutton" data-options="plain:true';
				else var str='<a href="javascript:void(0)" id="'+fid+'" class="easyui-menubutton" data-options="plain:true, menu:\'#'+menu+'\'';
				if (icon!='') str+=',iconCls:\''+icon+'\'';
				//str+='" style="width:'+width+'px;';
				if (height>0) str+='height:'+height+'px;'; 
				str+='">'+text+'</a>';	
				$("#"+parent).append($(str));
				if (menu==''){
					$("#"+fid).linkbutton({width:width});
					$("#"+fid).attr('xtype','linkbutton');
				}else{
					$("#"+fid).menubutton({width:width+20});
					$("#"+fid).attr('xtype','menubutton');
				}
			}
			//console.log(str);
		}
	}
}

//按钮、菜单分隔符
function mySep(id,parent,top,left,style){
	if (parent=='') parent='main';
	if (style!='') style=';'+style+';';
	var str='';
	if (style!=undefined && style.indexOf(';menu;')>=0){ //按钮分隔符
		str+='<div id="'+id+'_div"><a href="javascript:void(0)" id="'+id+'_sep" class="menu-sep"></a></div>';
	}else{
		str+='<div style="margin:2px 0;" id="'+id+'_div"><a href="javascript:void(0)" id="'+id+'_sep" class="btn-separator" style="margin:'+top+'px 0;" ></a></div>';
	}
	$("#"+parent).append($(str));
	$("#"+id+"_div").css(myTextCss(parent,top,left,0,0));
	//$("#"+id).attr('xparent',parent);  //自定义属性
	//$("#"+id).attr('xid',id);  //自定义属性
}	

//生成表单
function myForm(id,parent,title,top,left,height,width,style){
	if (parent=='') parent='main';
	//窗体底部空4px,
    if (parent=='main' && (width<=0 || height<=0)){
   		$("#main").removeClass();
		$("#main").addClass('easyui-layout');
		$("#main").panel({'fit':true});
	}
    str='<div class="easyui-panel" id="'+id+'" title="&nbsp;'+title+'" style="position:relative; background:#fafafa; margin:0; padding:0px 0px 0px 0px;';
    var ph=$('#'+parent).height()-2;
	var pw=$('#'+parent).width()-2;
    if (width>0) str+='width:'+width+'px;';
    else str+='width: auto;';
    if (height>0) str+='height:'+height+'px;';
    else str+='height: auto;';
    if (left>0) str+='left:'+left+'px;';
    if (top>0) str+='top:'+top+'px;';
    str+='"\n';
    str+='data-options="iconCls:\'panelIcon\'';
    if (height==0 && width==0) str+=',fit:true';
    if (style.indexOf('close')>=0) str+=',closable:true';
    if (style.indexOf('collapse')>=0) str+=',collapsible:true';
    if (style.indexOf('min')>=0) str+=',minimizable:true';
    if (style.indexOf('min')>=0) str+=',maximizable:true';
    str+='" >';
    str+='</div>\n';
	//console.log(str);
    $('#'+parent).append($(str));
    $('#'+id).panel();
	//$("#"+id).attr('type','form');  //自定义属性
	$("#"+id).attr('xparent',parent);  //自定义属性
	$("#"+id).attr('xid',id);  //自定义属性
	$("#"+id).attr('xtitle',title);  //自定义属性
}

//生成tabs
function myTabs(id,parent,items,top,left,height,width,style){
	if (parent=='') parent='main';
	var xid=id+'Panel';
	if (style.indexOf('close')>=0) var flag=true;
	else flag=false;
	//-19px经过调试确定，取掉底部空隙,left,top为空隙
	var str='<div id="'+id+'" class="easyui-tabs" style="overflow: auto; ';
	if (top>0) str+='margin: '+top+'px 0px -19px ';
	else str+='margin: 0px 0px -19px ';
	if (left>0) str+=left+'px; padding:0px 0px 0px 0px;">\n';
	else str+='0px; padding:0px 0px 0px 0px;">\n';
	var tmp=items.split(';');
	for (var i=0; i<tmp.length; i++){
	    str+='<div id="'+id+(i+1)*1+'" title="'+tmp[i]+'" data-options="closable:'+flag+'" style="top:0px; left:0px; position:relative; overflow:auto;">\n';
		str+="</div>\n";
	}	
	str+='</div>\n';
	//console.log(str);
	$("#"+parent).append($(str));
	$("#"+id).attr('xparent',parent);  //自定义属性
	$("#"+id).attr('xid',id);  //自定义属性
	$("#"+id).attr('type','tabs');  //自定义属性
	$("#"+id).tabs();
	//父类日期的高度与宽度,splitter变动时改变
	if (width<=0 && height<=0)$("#"+id).tabs({fit:true});
	else{
		if (width<=0 && $('#'+parent).length>0){
			width=$('#'+parent).width()-0;
		}	
		if (height<=0 && $('#'+parent).length>0){
			height=$('#'+parent).height()-0;
		}	
		$("#"+id).tabs({width: width, height: height});
	}	
	$("#"+parent).attr('xtab',id);  //自定义属性，记录其中的tab名称
	//更新tab，否则第一页不会显示
	if (tmp.length>0){
		for (var i=1; i<tmp.length; i++){
			$("#"+id).tabs('select',i);  //每个都选中一次，解决显示格式问题
		}	
		$("#"+id).tabs('select',0);
	}
	var currTab = $('#'+id).tabs('getTab', 0);
	$('#'+id).tabs('update', { tab: currTab, options:{} });
}


//生成表单+tabs
function myTabForm(id,parent,title,tabs,top,left,height,width,style){
	//生成表单myTabForm-主窗体, myTab1,2...
	var xid=id+'Form';
	myForm(xid,parent,title,top,left,height,width,style);
	/*
	if (height>0) var ph=$("#"+xid).height()-33;
	else var ph=0;
	if (width>0) var pw=$("#"+xid).width()-6;
	else var pw=0;
	myTabs(id,xid,tabs,0,0,ph,pw,style);
	*/
	myTabs(id,xid,tabs,0,0,0,0,style);
}

//生成菜单按钮
function myMenuButton(id,parent,title,top,left,height,width,menuitem){
	var str='<a href="javascript:void(0)" id="'+id+'" class="easyui-menubutton" data-options="plain:true, menu:\'#'+menuitem+'\'" style="';
	if (width>0) str+='width:'+width+'px';
	if (height>0) str+='height:'+height+'px';
	if (top>0 && left>0) str+='position:absolute; top:'+top+'px; left:'+left+"px;";
	str+='">'+title+'</a>';
	$("#"+parent).append($(str));
	$("#"+id).attr('xtype','menubutton');
	$("#"+id).menubutton();
	
}

//定义菜单并绑定到对象，如表单
function myMenu(id,items,bindobj){
	myMenuItem(id,items);
	var tmp=bindobj.split(';');
	if (tmp.length>0){
		var str='';
		for (var i=0;i<tmp.length;i++){
			if (i>0) str+=',';
			// alert(tmp[i]);
			str+='#'+tmp[i];
			//if ($("#"+tmp[i]).length>0) alert($("#"+tmp[i]).attr('xtype')); 
			//console.log(tmp[i]+'---'+$('#'+tmp[i]).attr('xtype'));
			/*
			onContextMenu: function(e, rowIndex, rowData){
				e.preventDefault();
				$("#myMenu1").menu('show', {
					left: e.pageX,
					top: e.pageY
				});
			}
			*/				
		}
	}
}

//定义菜单，但不绑定。如果没有主菜单，则生成一个id
function myMenuItem(id,items){
	//items---add/新增/addIcon;edit/修改
	var str='';
	if ($("#"+id).length==0){
		str='<div id="'+id+'" xtype="menu" class="easyui-menu" data-options="" style="width:auto"></div>';
		$("#main").append($(str));
	}
	$("#"+id).menu();  //不能缺
	var k=1;
	str='';
	var tmp=items.split(';');
	for (var i=1;i<=tmp.length;i++){
		var mn=tmp[i-1].split('/');
		if (mn.length==1 && mn[0]=='-'){  //-为分割线
			$("#"+id).menu('appendItem',{
				id:id+'_sep'+k,
				separator:true  //class: 'menu-sep'
			});
			k++;
		}else if (mn.length==2){
			$("#"+id).menu('appendItem',{
				xtype:"menuitem", 
				text:mn[0],
				id:mn[1]
			});
			$("#"+mn[1]).attr('xtype','menuitem');
			$("#"+mn[1]).attr('xparent',id);
		}else if (mn.length==3){
			$("#"+id).menu('appendItem',{
				xtype:"menuitem",
				text:mn[0],
				id:mn[1],
				iconCls:mn[2]
			});
			$("#"+mn[1]).attr('xtype','menuitem');
			$("#"+mn[1]).attr('xparent',id);
		}
	}		  
}

function myWinTitle(win,title){
	$("#"+win).window('setTitle','<div style=\'margin:0px 0px 0px 4px; \'>'+title+'</div>');
}

//生成窗体modal
function myWindow(id,title,top,left,height,width,buttons,style){
	//CancelBtn,CloseBtn,OkBtn,SaveBtn
	if (style==undefined) var style='';
	var xid=id+'Form'; 
	var str='<div id="'+id+'" class="easyui-window" title="<div style=\'margin:0px 0px 0px 4px; \'>'+title+'" data-options="iconCls:\'panelIcon\'" ';
	str+='style="';
	//是否隐藏滚动条
	if (style.indexOf(';scrollbar;')>=0) str+='overflow:auto;';
	else str+='overflow:hidden;';
	str+='position:relative; margin:0px 0px 0px 0px; padding:0px 0px 0px 0px;"></div>';
	$("#main").append($(str));	
	if (width<=0) width=500;
	if (height<=0) height=400;
	var xstyle='({width:'+width+', height:'+height;
	if (style==undefined || style=='') style='close';
	if (buttons==undefined) buttons='';
	style=';'+style+';'
	if (style.indexOf(';resize;')>=0)	xstyle+=' ,resizable: true';
	else xstyle+=' ,resizable: false';
	if (style.indexOf(';drag;')>=0) xstyle+=' ,draggable: true';
	else xstyle+=' ,draggable: false';
	if (style.indexOf(';close;')>=0) xstyle+=' ,closable:true';
	else xstyle+=' ,closable:false';
	if (style.indexOf(';collapse;')>=0) xstyle+=' ,collapsible:true';
	else xstyle+=' ,collapsible:false';
	if (style.indexOf(';max;')>=0) xstyle+=' ,maximizable:true';
	else xstyle+=' ,maximizable:false';
	if (style.indexOf(';min;')>=0) xstyle+=' ,minimizable:true';
	else xstyle+=' ,minimizable:false';
	if (style.indexOf(';modal;')>=0) xstyle+=' ,modal:true';
	else xstyle+=' ,modal:false';
	xstyle+='})';
	if (top>0 && left>0) $("#"+id).window({left:left, top:top});
	$("#"+id).window( eval(xstyle) );
	$("#"+id).attr('type','window');
	$("#"+id).window('close'); //初始状态先关闭
	if (buttons!=undefined && buttons!=''){
		buttons=';'+buttons+';'
		var btntop=height-74;
		var btnleft=width-sysbutton.width-30;
		if (buttons.indexOf(';cancel;')>=0){
			myButton(id+"CancelBtn",id,"取消",btntop,btnleft,sysbutton.height,sysbutton.width,'','');
			btnleft=btnleft-sysbutton.width-1;
		}
		if (buttons.indexOf(';close;')>=0){
			myButton(id+"CloseBtn",id,"关闭",btntop,btnleft,sysbutton.height,sysbutton.width,'','');
			btnleft=btnleft-sysbutton.width;
			$("#"+id+"CancelBtn").on('click', function () {
				$("#"+id).window('close');		
			});
		}
		if (buttons.indexOf(';save;')>=0){
			myButton(id+"SaveBtn",id,"保存",btntop,btnleft,sysbutton.height,sysbutton.width,'','');
			btnleft=btnleft-sysbutton.width;
		}
		if (buttons.indexOf(';ok;')>=0){
			myButton(id+"OkBtn",id,"确定",btntop,btnleft,sysbutton.height,sysbutton.width,'','');
			btnleft=btnleft-sysbutton.width;
		}
	}
}

function myGridColumns(fieldset){
	//[#230%n@r]资源名称/resourcename;
	var xcolumns=[];
	for (var i=0;i<=255;i++){
		xcolumns[i]={};
		xcolumns[i].name='';
		xcolumns[i].title='';
		xcolumns[i].align='';
		xcolumns[i].type='c';
		xcolumns[i].length='100';
		xcolumns[i].dec='0';
		xcolumns[i].fixed=0;
	}
	var result=[];
	var xfields=fieldset.split(';');
	for (var i=0;i<xfields.length;i++){
		var s=xfields[i].toLowerCase();
		var p1=s.indexOf('[');
		var p2=s.indexOf(']');
		if (p1>=0 && p2>p1){
			var ss=s.substring(p1+1,p2);
			//console.log(ss);
			var x1=ss.indexOf('@');
			if (x1>=0){
				xcolumns[i].align=ss.substr(x1+1,1);
				ss=ss.replace('@'+xcolumns[i].align,'');  //删除该描述
			}
			var x2=ss.indexOf('%');
			if (x2>=0){
				xcolumns[i].type=ss.substr(x2+1,1);
				ss=ss.replace('%'+xcolumns[i].type,'');  //删除该描述
			}
			var x3=ss.indexOf('#');
			var s1='';
			var s2='';
			if (x3>=0)	s1=ss.substring(x3+1,255);
			else s1=ss;
			//console.log('s1='+s1+'---ss='+ss);
			var x4=s1.indexOf(',');
			if (x4<0){
				xcolumns[i].length=s1;
			}else{
				xcolumns[i].length=s1.substring(0,x4);
				xcolumns[i].dec=s1.substr(x4+1,2);
			}
			s=s.substring(p2+1,255);
		}
		var x1=s.indexOf('/');
		if (x1>0){
			xcolumns[i].title=s.substring(0,x1);		
			xcolumns[i].name=s.substring(x1+1);		
		}else{
			xcolumns[i].title=s;		
			xcolumns[i].name=s;		
		}
		if (xcolumns[i].align=='' && xcolumns[i].type=='d') xcolumns[i].align='c'; 
		if (xcolumns[i].align=='' && xcolumns[i].type=='n') xcolumns[i].align='r'; 
		if (xcolumns[i].align=='' && xcolumns[i].type=='f') xcolumns[i].align='r'; 
		if (xcolumns[i].align=='c') xcolumns[i].align='center';
		else if (xcolumns[i].align=='r') xcolumns[i].align='right';
		else xcolumns[i].align='left';
		//console.log(xcolumns[i].name+'--'+xcolumns[i].align+'--'+xcolumns[i].title+'--'+xcolumns[i].type+'--'+xcolumns[i].length+'--'+xcolumns[i].dec);
		if ((xcolumns[i].type=='n' || xcolumns[i].type=='f')){  //数值型有小数点
			var str="{title: xcolumns[i].title, field:xcolumns[i].name, sortable:false, width:xcolumns[i].length, halign:'center', align: xcolumns[i].align, formatter: function(value){\n";
			 //非零打印
			str+="	if (value!=undefined) value=(1.0*value).toFixed("+xcolumns[i].dec+");\n";
			str+="	else value='0';\n";
			if (xcolumns[i].type=='n') str+="	if (value==undefined || value=='' || 1*value==0) value='&nbsp;';\n";
			str+="	return '<a href=\"javascript:void(0)\" style=\"padding:0 0px; font-size:'+(syslabel.fontsize-1)+'px; color:#000000;\" >";
			str+="<div>' + value+'</div></a>';}}\n";
			//str+="<div align=\"right\">' + value+'</div></a>';}}\n";
			//<a href=\"#\">
		}else if (xcolumns[i].type=='d'){  //日期时间型
			var str="{title: xcolumns[i].title, field:xcolumns[i].name, sortable:false, width:xcolumns[i].length, halign:'center', align: xcolumns[i].align, formatter: function(value){\n";
  			str+="	if (value=='' || value==undefined) value='&nbsp;';";
			str+="	return '<a href=\"javascript:void(0)\" style=\"padding:0 0px; font-size:'+(syslabel.fontsize-1)+'px; color:#000000;\" >";
			str+="<div>' + value+'</div></a>';}}\n";
			//<a href=\"#\">
		}else if (xcolumns[i].type=='g'){  //根据扩展名显示图片24位，.title指定默认图片的后缀
			//field:'sysdownload'
			var str="{title:'', field:'sysfiletype', sortable:false, width:xcolumns[i].length, halign:'center', align:'center', formatter:function(value,row,index){\n";
  			str+="	var v1=row."+xcolumns[i].name+";\n";  //根据该列的值确定图标的名称
  			str+="	var v2='"+xcolumns[i].title+".png';\n";
  			str+="	if (v1.lastIndexOf('.pdf')>0) v2='pdf24.png';\n";
  			str+="	else if (v1.lastIndexOf('.swf')>0) v2='swf24.png';\n";
  			str+="	else if (v1.lastIndexOf('.doc')>0) v2='word24.png';\n";
  			str+="	else if (v1.lastIndexOf('.xls')>0) v2='excel24.png';\n";
  			str+="	else if (v1.lastIndexOf('.ppt')>0) v2='ppt24.png';\n";
  			str+="	else if (v1.lastIndexOf('.rar')>0) v2='rar24.png';\n";
  			str+="	else if (v1.lastIndexOf('.zip')>0) v2='zip24.png';\n";
  			str+="	else if (v1.lastIndexOf('.mp3')>0) v2='audio24.png';\n";
  			str+="	else if (v1.lastIndexOf('.wav')>0) v2='audio24.png';\n";
  			str+="	else if (v1.lastIndexOf('.png')>0) v2='pct24.png';\n";
  			str+="	else if (v1.lastIndexOf('.gif')>0) v2='pct24.png';\n";
  			str+="	else if (v1.lastIndexOf('.jpg')>0) v2='pct24.png';\n";
			str+="	v2='system/images/'+v2;\n";
			//str+="	console.log(v2);\n";
			str+="	return '<a href=\"javascript:void(0)\"><img border=\"0\" style=\"height:20px; width:20px; border:0;\" src=\"'+v2+'\" /></a>';}}\n";
		}else{
  			var str="{title: xcolumns[i].title, field:xcolumns[i].name, nowrap:false, sortable:false, width:xcolumns[i].length, halign:'center', align: xcolumns[i].align, formatter: function(value){";
  			str+="	if (value=='' || value==undefined) value='&nbsp;';";
			str+="	return '<a href=\"javascript:void(0)\" style=\"padding:0 0px; font-size:'+syslabel.fontsize+'px; color:#000000;\" >";
			str+="<div>'+ value+'</div>";
			str+="</a>';";
			//str+="return value;";
			str+="}}\n";
			//console.log(str);
  		}
  		//console.log(str);
  		eval("var s="+str+";");  //str to json
		result.push(s);
	} //for
	return result; 
}

function myLoadGridData(pmyGrid1,pageNumber){
	var myGrid1=pmyGrid1.id;
	//三种方法同时刷新页和行号才有效
	if (pageNumber<=0){  //为0时刷新当前列
		var opts =$("#"+pmyGrid1.id).datagrid('getPager').data("pagination").options; 
		pageNumber=opts.pageNumber;
	}
	var pager =$("#"+pmyGrid1.id).datagrid('getPager');
	pager.pagination('refresh',{	// 改变选项，并刷新分页栏信息
		pageNumber: pageNumber
	});
	var opts =$("#"+pmyGrid1.id).datagrid('getPager').data("pagination").options; 
	opts.pageNumber=pageNumber;
	var pageSize=opts.pageSize;
	if (pageSize!=undefined) pageSize=pmyGrid1.pagesize;
	var opts = $("#"+pmyGrid1.id).datagrid('options');
	opts.pageNumber=pageNumber;
	opts.pageSize=pageSize;
	$.ajax({     
		type: "Post",     
		url: "system/easyui_getGridData.jsp",     
		//contentType: "application/json; charset=utf-8",     
		//dataType: "json", 
		data: {
			database: sysdatabasestring, 
			selectsql: pmyGrid1.activesql,
			keyfield: pmyGrid1.keyfield,
			sortfield: pmyGrid1.sortfield,
			limit: pageSize,
			start: (pageNumber-1)*pageSize,
			summeryfields:pmyGrid1.summeryfields				
		}, 
		async: false, method: 'post',    
		success: function(data) {
			eval("var source="+data+";");
			$("#"+pmyGrid1.id).datagrid("reload");  //放在loaddata之前，触发onBeforeLoad事件
			$("#"+pmyGrid1.id).datagrid("loadData", source );  //必须用loaddata
			//根据总行数改变行号的列宽度，改css
			var rowcount=$("#"+pmyGrid1.id).datagrid('getData').total+'';  //转换为字符型
			var width=(rowcount.length*6+8);
			if (width<25) width=25;
			var px=width+'px';
			$('.datagrid-header-rownumber,.datagrid-cell-rownumber').css({"width": px});
			$("#"+pmyGrid1.id).datagrid('resize');  //必须写
			if (rowcount>0){
				var rows=$("#"+pmyGrid1.id).datagrid('getRows');    // get current page rows
				if (pmyGrid1.rowindex==undefined || pmyGrid1.rowindex<0 || pmyGrid1.rowindex>=rowcount){
					pmyGrid1.rowindex=0;
				}	
				$("#"+pmyGrid1.id).datagrid('selectRow',pmyGrid1.rowindex); //选中某行
				pmyGrid1.record=rows[pmyGrid1.rowindex];
				pmyGrid1.pagenumber=pageNumber;
				pmyGrid1.pagecount=parseInt((rowcount-1)/pmyGrid1.pagesize)+1;
			}else{
				pmyGrid1.record=null;
				pmyGrid1.pagenumber=0;
				pmyGrid1.pagecount=-1;
				pmyGrid1.rowindex=-1;
			}
			pmyGrid1.rowcount=rowcount;
			myGridEvents(pmyGrid1.id,'onload');
		}    
	});
	return pmyGrid1;
}

function myGridPaging(pmyGrid1){
	var myGrid1=pmyGrid1.id;
	$("#"+pmyGrid1.id).datagrid({ 
		pagination: true,	
		pageSize: pmyGrid1.pagesize
	});
	//var opts = $("#"+pmyGrid1.id).datagrid('options');
	var opts =$("#"+pmyGrid1.id).datagrid('getPager').data("pagination").options; 
	//opts.pageNumber=1;
	//opts.pageSize=pmyGrid1.pagesize;	
	//定义分页栏模式
	var pg = $("#"+pmyGrid1.id).datagrid("getPager");  
	pg.pagination({  
		pageList: [10,20,50,100,500],
		showPageList: false,  //是否显示设置每页显示行数的下拉框
		beforePageText: '第', //页数文本框前显示的汉字  
		afterPageText: '页    共 {pages} 页', 
		displayMsg: '当前显示{from}～{to}行，共{total}行',
		onRefresh:function(pageNumber,pageSize){
			if (pmyGrid1.rowindex>=0) $("#myGrid1").datagrid('endEdit',pmyGrid1.rowindex);
			pmyGrid1.rowindex=0;  
			myLoadGridData(pmyGrid1,pageNumber);  
			myGridEvents(pmyGrid1.id,'onRefresh');
		},  
		onChangePageSize:function(pageSize){  
			if (pmyGrid1.rowindex>=0) $("#myGrid1").datagrid('endEdit',pmyGrid1.rowindex);
			var opts = $("#"+pmyGrid1.id).datagrid('options');
			//var opts =$("#"+pmyGrid1.id).datagrid('getPager').data("pagination").options; 
			opts.pageSize=pageSize;	
			pmyGrid1.rowindex=0;			
			myLoadGridData(pmyGrid1,1);  
			myGridEvents(pmyGrid1.id,'onChangePageSize');
		},  
		onSelectPage:function(pageNumber,pageSize){
			if (pmyGrid1.rowindex>=0) $("#myGrid1").datagrid('endEdit',pmyGrid1.rowindex);
			var opts = $("#"+pmyGrid1.id).datagrid('options');
			//var opts =$("#"+pmyGrid1.id).datagrid('getPager').data("pagination").options; 
			opts.pageNumber=pageNumber;
			opts.pageSize=pageSize;
			pmyGrid1.rowindex=0;
			myLoadGridData(pmyGrid1,pageNumber);
			myGridEvents(pmyGrid1.id,'onSelectPage');						  
		}  
	});
}

//gggggggggrid
function myGrid(pmyGrid1){
	if (pmyGrid1.summeryfields==undefined) pmyGrid1.summeryfields='';
	var str='';
	if (pmyGrid1.top>0 || pmyGrid1.left>0){
		str+='<div id="'+pmyGrid1.id+'_div" style="position:absolute;';
		if (pmyGrid1.top>0) str+=" top:"+pmyGrid1.top+"px;";
		if (pmyGrid1.left>0) str+=" left:"+pmyGrid1.left+"px;";
		str+='">';
	} 
	str+='<div id="'+pmyGrid1.id+'" class="easyui-datagrid" data-options="';
	if (pmyGrid1.toolbar!=undefined && pmyGrid1.toolbar!='') str+='toolbar:'+pmyGrid1.toolbar+'';
	str+='" style="position:absolute;" ></div>';
	if (pmyGrid1.top>0 || pmyGrid1.left>0){
		str+='</div>';
	} 
	$("#"+pmyGrid1.parent).append($(str));
	//console.log(str);
	if (pmyGrid1.sortfield==undefined || pmyGrid1.sortfield=='') pmyGrid1.sortfield=pmyGrid1.keyfield;
	//if (pmyGrid1.sortway==undefined) pmyGrid1.sortway='';
	if (pmyGrid1.checkonclick==undefined) pmyGrid1.checkonclick=1; //单击是否改变checkbox状态
	pmyGrid1.rowcount=0;
	pmyGrid1.columns=[];
	pmyGrid1.scrollcolumns=[];
	pmyGrid1.fixedcolumns=[];
	pmyGrid1.checkboxcolumn=[];
	pmyGrid1.scrollcolumns=myGridColumns(pmyGrid1.gridfields);
	pmyGrid1.fixedcolumns=(pmyGrid1.fixedcolumns).concat(myGridColumns(pmyGrid1.fixedfields));;
	pmyGrid1.columns=(pmyGrid1.fixedcolumns).concat(pmyGrid1.scrollcolumns);
	if (pmyGrid1.checkbox!=''){
		pmyGrid1.checkboxcolumn.push({field:"checkedflag", width: 20, checkbox: true, align:"center"});
	}
	if (pmyGrid1.fixedfields!='') pmyGrid1.fixedcolumns=pmyGrid1.checkboxcolumn.concat(pmyGrid1.fixedcolumns)
	else pmyGrid1.fixedcolumns=pmyGrid1.checkboxcolumn;
	if (pmyGrid1.width<=0) pmyGrid1.width='100%';
	if (pmyGrid1.height<=0) pmyGrid1.height='100%';
	var myGrid1=pmyGrid1.id;
	pmyGrid1.rowindex=-1;
	if (pmyGrid1.striped==undefined || pmyGrid1.striped=='') pmyGrid1.striped=false;
	else pmyGrid1.striped=true; 
	if (pmyGrid1.checkbox=='single') var selectoncheck=true;
	else var selectoncheck=false;
	$("#"+pmyGrid1.id).datagrid({
		title: '&nbsp;'+pmyGrid1.title,
		width: pmyGrid1.width,
		height: pmyGrid1.height,
		iconCls: "panelIcon",
		nowrap: true,
		//sortName: pmyGrid1.keyfield,
		remoteSort:false,
		sortOrder: 'asc', 		
		pagePosition: 'bottom',  //top,both
		autoRowHeight: false,
		selectOnCheck: selectoncheck, //true,
		checkOnSelect: selectoncheck, //true,
		//pageNumber: 1,
		//pagination: true,
		//pageSize: pmyGrid1.pagesize	,	
		striped: pmyGrid1.striped,
		frozenColumns: [pmyGrid1.fixedcolumns],
		columns: [pmyGrid1.scrollcolumns]
	});
	$("#"+pmyGrid1.id).attr('xcontextmenu',pmyGrid1.menu); //自定义属性
	$("#"+pmyGrid1.id).attr('xcheckbox',pmyGrid1.checkbox); //自定义属性
	if (pmyGrid1.menu!=undefined && pmyGrid1.menu!=''){
		$("#"+pmyGrid1.id).datagrid({
			onRowContextMenu: function(e,index,record){
				e.preventDefault(); //阻止浏览器捕获右键事件  
				var xmenu=$(this).attr('xcontextmenu');  //自定义属性
				var xcheckbox=$(this).attr('xcheckbox');
				//alert($('#'+xmenu).length);
				if (xcheckbox=='single') $(this).datagrid("selectRow", index); //根据索引选中该行  
				$('#'+xmenu).menu('show', {   //显示右键菜单  
					left: e.pageX, //在鼠标点击处显示菜单  
					top: e.pageY  
				});
				myGridEvents(pmyGrid1.id,'onRowContextMenu');
			}
		});
	}
	if (pmyGrid1.title==''){
		$("#"+pmyGrid1.id).datagrid({noheader: true});
	}
	if (pmyGrid1.rownumbers){
		$("#"+pmyGrid1.id).datagrid({rownumbers:true});	
	}
	if (pmyGrid1.collapsible){
		$("#"+pmyGrid1.id).datagrid({collapsible:true});	
	}
	if (pmyGrid1.checkbox=='single'){
		$("#"+pmyGrid1.id).datagrid({singleSelect:true});
	}else if (pmyGrid1.checkbox=='multiple'){
		$("#"+pmyGrid1.id).datagrid({singleSelect:false});
	}
	if (pmyGrid1.sortablefields!=undefined && pmyGrid1.sortablefields!=''){
		var cols=$("#myGrid1").datagrid('options').columns[0];
		//$("#myGrid1").datagrid('options').columns[0][0].align="right";
		//$("#myGrid1").datagrid('options').columns[0][0].sortable=true;
		//$("#myGrid1").datagrid();  //修改之后paging和loadgriddata
	}
		
	$("#"+pmyGrid1.id).datagrid({
		onDblClickRow:function(index,row){
			myGridEvents(pmyGrid1.id,'onDblClickRow');
		},
		onSelect:function(index,row){
			pmyGrid1.record=row;
			pmyGrid1.rowindex=index;
			myGridEvents(pmyGrid1.id,'onSelect');
			//alert(myIsRowChecked(pmyGrid1));
		},
		onClickRow:function(index,row){
			pmyGrid1.record=row;
			pmyGrid1.rowindex=index;
			if (pmyGrid1.checkonclick==0){
				//单击不改变checkbox状态
				//if (myIsRowChecked(pmyGrid1)) $(this).datagrid('uncheckRow',pmyGrid1.rowindex);
				//else $(this).datagrid('checkRow',pmyGrid1.rowindex);
				//$(this).datagrid('uncheckRow',pmyGrid1.rowindex);
				//$(this).datagrid('unselectRow',pmyGrid1.rowindex);
			}
			if (pmyGrid1.singleselect==1){
				var rows=$("#myGrid1").datagrid("getRows");
				for (var i=0;i<rows.length;i++){
					if (pmyGrid1.rowindex!=i) $(this).datagrid('unselectRow',i);
				}
				$(this).datagrid('selectRow',pmyGrid1.rowindex);
			}
			myGridEvents(pmyGrid1.id,'onClickRow');
		},
		onClickCell:function(index,field,value){
			pmyGrid1.rowindex=index;
			pmyGrid1.cellfield=field;
			pmyGrid1.cellvalue=value;
			var rows=$("#"+pmyGrid1.id).datagrid('getRows');    // get current page rows
			pmyGrid1.record=rows[pmyGrid1.rowindex];
			myGridEvents(pmyGrid1.id,'onClickCell');
		}		
	});	
	if (pmyGrid1.pagesize>0){
		myGridPaging(pmyGrid1);  //定义分页栏模式
	}
	return pmyGrid1;
}

function myIsRowChecked(pmyGrid1){
	var flag=false;
	var grid=$("#"+pmyGrid1.id);
	var rows=grid.datagrid("getChecked"); //getChecked
	for (var i=0; i<rows.length; i++){
		if (pmyGrid1.record.rownumber==rows[i].rownumber){
			flag=true; break;
		}
	}
	return flag;
}
//------------------------------eeeeeeeeeeeevents---------------------
function myCheckBoxChange(id,items){
	//讲选中值保存到id_hiddenfield控件中
	var str='';
	var tmp=items.split(';');
	for (var i=1;i<=tmp.length;i++){
		if (i==1 &&tmp.length==1) var itemid=id;
		else var itemid=id+i;
		if ($('#'+itemid).is(':checked')) str+=';'+tmp[i-1];
	}
	$('#'+id).val(str.substr(1));
	//console.log($('#'+id).val());
}

function myGetComboxData(id,sql){  //从后台获取数据直接给客户端
	$.ajax({     
		type: "Post",     
		url: "system/easyui_getComboxData.jsp",     
		//contentType: "application/json; charset=utf-8",     
		//dataType: "json", 
		data: {database: sysdatabasestring, selectsql: sql}, 
		async: false, method: 'post',    
		success: function(data) {     
			//返回的数据用data获取内容,直接复制到客户端数组source      
			//console.log(data);
			var source=eval(data); 
			$("#"+id).combobox({data: source});
			/*
			var items = $('#'+id).combobox('getData');
			if (items.length<=12) $('#'+id).combobox({panelHeight: 'auto'});
			else $('#'+id).combobox({panelHeight: 12*(syslabel.fontsize+8)});
			if (items.length > 0) {
				$("#"+id).combobox('select', eval("items[0]."+id));
			}
			*/
			if (source.length<=12) $('#'+id).combobox({panelHeight: 'auto'});
			else $('#'+id).combobox({panelHeight: 12*(syslabel.fontsize+8)});
			if (source.length > 0) {
				//$("#"+id).combobox('select', eval("source[0]."+id));  //会触发select事件，出错
				$("#"+id).combobox('setValue', eval("source[0]."+id));
			}
			
		},     
		error: function(err) {     
			console.log(err);     
		}     
	}); 
}

function mySetComboxByIndex(id,index){  //设置combobox选项
	if ($('#'+id).length>0){
		var items = $('#'+id).combobox('getData');
		if (items.length > 0 && index<items.length) {
			$("#"+id).combobox('setValue', eval("items[index]."+id));
		}
	}
}

function mySelectComboByIndex(id,index){  //设置combobox选项
	if ($('#'+id).length>0){
		var items = $('#'+id).combobox('getData');
		if (items.length > 0 && index<items.length) {
			$("#"+id).combobox('select', eval("items[index]."+id));
		}
	}
}

function mySetTreeNodeByIndex(id,index){  //设置combobox选项
	//选中第n个结点
	var item = $('#'+id).tree('getRoot');
	if (item.children) $("#"+id).tree('expand', item.target);
	$("#"+id).tree('select', item.target);
	//$("#"+id).tree('select', index);
	//$("#"+id).tree('find', value);
}

//将表格或树节点值赋值到表单
function mySetFormValues(fieldset,source){
	//将符合Json格式的行或节点值复制到表单fieldset中
	var xfields=[];
	var k=0;
	if (fieldset==undefined || fieldset==''){
		$.each(source, function(id, value) {  //取json中每个列及其值
			xfields[k]=id; k++;
		});
	}else{
		xfields=fieldset.split(';');
	}
	for (var k=0;k<xfields.length;k++){
		var value=eval("source."+xfields[k]);
		//console.log(value+'----'+xfields[k]);
		if (value!=undefined) mySetValue(xfields[k],value);
	}
}

//将表格设置为只读或取消只读rrrrrrrreadonly
//function mySetFormReadonly(flag){  //对函数定义的控件（包括xid自定义属性的）只读
	//mySetReadonly('',flag);
//}

function mySetReadonly(c,flag){  //对函数定义的控件（包括xid自定义属性的）只读
	//c为空时，对所有xid属性非空的控件设置只读
	var xfields=[];
	if (c!='') xfields=c.split(';');
	else{
		var k=0;
		$('input, select, textarea').each(function(index){  
			var input = $(this);
			if (input.attr('id')!=undefined && input.attr('xid')!=undefined && input.attr('xid')!=''){
				xfields[k]=input.attr('id');
				//console.log(xfields[k]+'----'+input.attr('xid'));
				k++;
			}	
		});	
	}	
	//alert(xfields.length);
	var type='';
	var id='';
	var value='';
	var hidden='';
	var pid='';  //checkbox的大组名称
	for (k=0;k<xfields.length;k++){
		//var input = $(this);
		var input=$("#"+xfields[k]);
		id=input.attr('id');
		type=input.attr('type');
		hidden=input.attr('hidden');
		if (id!=undefined && hidden!='hidden'){
			if (type=='text') $("#"+id).textbox('readonly',flag);
			else if (type=='textarea') $("#"+id).attr('readonly',flag);
			else if (type=='combobox') $("#"+id).combobox('readonly',flag);
			else if (type=='checkbox') $("#"+id).attr('disabled',flag);
			else $("#"+id).attr('readonly',flag);
			//myBindKeyDownEvent(id);
		}
		//console.log(id+'----'+type+'----'+value);
   	}
}

function myShowPanel(c,flag){  //隐藏或显示panel
	var xfields=c.split(';');
	for (var k=0;k<xfields.length;k++){
		var input=$('#'+xfields[k]);
		if (xfields[k]!='' && input.length>0){
			if (flag) input.panel('open');
			else input.panel('close');;
		}
	}	
}

function myShowButton(c,flag){  //隐藏或显示控件
	var xfields=c.split(';');
	for (var k=0;k<xfields.length;k++){
		var input=$("#"+xfields[k]);
		if (xfields[k]!='' && input.length>0){
			if (flag) input.show();
			else input.hide();
		}
	}	
}

function mySetEnabled(c,flag){  //对函数定义的控件（包括xid自定义属性的）只读
	var xfields=c.split(';');
	for (var k=0;k<xfields.length;k++){
		var input=$("#"+xfields[k]);
		if (input.length>0){
			type=input.attr('xtype');
			if (type=='linkbutton'){
				if (flag) input.linkbutton('enable');
				else{
					input.linkbutton('disable');
				} 
			}else if (type='menuitem'){
				var parent=$("#"+input.attr('xparent'));
				if (flag){
					parent.menu('enableItem',$("#"+xfields[k]));
				}else{
					parent.menu('disableItem',$("#"+xfields[k]));
				}
			}
		}
   	}
}

function myClearForm(fieldset){  //重置表单	
	var xfields=[];
	var i=0;
	if (fieldset==undefined || fieldset==''){
		$('input, select, textarea').each(function(index){  
			var input = $(this);
			id=input.attr('id');
			xfields[i]=id;
			i++;
		});
	}else{
		xfields=fieldset.split(';');
	}
	for (var i=0;i<xfields.length;i++){
		mySetValue(xfields[i],'');
   	}
}

function mySetValue(id,value){	
	var input = $("#"+id);
	if (input.length>0){
		value=value+"";  //转换类型
		if (value!='') value=value.replaceAll("<br>","\n");  //将<br>替换为回车
		var type=input.attr('type');
		if (type==undefined) var type=input.attr('xtype');
		var hidden=input.attr('hidden');
		var parent=input.attr('xparent');
		//console.log(id+'--'+value+'---'+type);
		if (type=='text' && hidden!='hidden'){ 
			input.textbox('setValue',value);
		}else if (type=='combobox'){ 
			input.combobox('setValue',value);
		}else if (type=='checkbox'){  //单个checkbox
			var groupid=input.attr('xgroupid');  //是否是父类中的一个子项
			if (groupid==undefined || groupid==''){
				var xtext=input.attr('xtext');  //取单项文本值, 为自定义属性
				if ((';'+value+';').indexOf(';'+xtext+';')>=0) var checked=true;
				else var checked=false;
				$("#"+id).prop("checked", checked);
			}	
		}else if (type=='checkboxgroup'){  //checkbox组
			var count=input.attr('xitemcount');
			for (var i=0;i<count;i++){
				var checked=false;
				var item=$("#"+id+(i+1));
				if ((';'+value+';').indexOf(';'+item.attr('xtext')+';')>=0) var checked=true;
				else var checked=false;
				item.prop("checked",checked);
			}	
		}else if (type=='label'){ 
			input.html(value);
		}else if (type=='image'){ //图形
			input.attr('src',value);
			myResizeImage(id,value,input.attr('xheight'),input.attr('xwidth'));
		}else{
			input.val(value);			
		}			
	}
}

function myGetValue(id){	
	var input = $("#"+id);
	var value='';
	if (input.length>0){
		var type=input.attr('type');
		if (type==undefined) var type=input.attr('xtype');
		var hidden=input.attr('hidden');
		var parent=input.attr('xparent');
		var flag=1;
		//if ($("#"+parent)!=undefined){
		 //	if ($("#"+parent).attr('type')!=undefined && $("#"+parent).attr('type')=='window') flag=0;
		//}   
		if (type=='text' && hidden!='hidden'){ //textbox
			value=input.textbox('getValue');
		}else if (type=='combobox'){ 
			value=input.combobox('getValue');
		}else if (type=='checkbox'){  //单个checkbox
			if (input.is(':checked')) value=input.attr('xtext');
			else value='';
		}else if (type=='checkboxgroup'){  //checkbox组合
			var count=input.attr('xitemcount');
			var value='';
			for (var i=0;i<count;i++){
				if (i==1 && count==1) var itemid=id;
				else var itemid=id+(i+1);
				if ($('#'+itemid).is(':checked')) value+=';'+$('#'+itemid).attr('xtext');
			}
			value=value.substr(1);
		}else if (type=='label'){ 
			value=input.html();
		}else if (type=='image'){ //图形
			value=input.attr('src');
		}else{
			value=input.val();			
		}			
		//console.log(id+'----'+type+'----'+value);
	}
	return trim(value);
}

function mySetRecordValuebyForm(record,fieldset){  //将表单数据赋值到记录或树节点中
	var xfields=[];
	if (fieldset==undefined || fieldset==''){
		k=0;
		$.each(record, function(id,value){
			xfields[k]=id; k++;
		});
	}else{
		xfields=fieldset.split(';');
	}
	for (var k=0;k<xfields.length;k++){
		eval('record.'+xfields[k]+'="'+myGetValue(xfields[k])+'";');
	}	
	return (record);
}

function mySetRecordValuebyJson(record,source){  //将表单数据赋值到记录或树节点中
	$.each(source, function(id,value){
		eval('record.'+id+'="'+value+'";');
	});
	return (record);
}

function myGenJsonData(json,fieldset){  //根据表单值生成一个json格式数据
	//获取json中包含的列或fieldset的列，生成json格式数据
	var xfields=[];
	if (fieldset==undefined || fieldset==''){
		k=0;
		$.each(json, function(id,value){
			xfields[k]=id; k++;
		});
	}else{
		xfields=fieldset.split(';');
	}
	var result='{';
	for (var k=0;k<xfields.length;k++){
		if (k>0) result+=',';
		result+='"'+xfields[k]+'":"'+myGetValue(xfields[k])+'"';
	}
	result+='}';
	return (result);
}


function myGenInsertSql(xsysdatabasestring,tablename){  //获取一个表中可编辑的列名
	var fieldset='';
	$.ajax({     
		type: "Post",     
		url: "system//easyui_getEditableFields.jsp",     
		//contentType: "application/json; charset=utf-8",     
		//dataType: "json", 
		data: {
			database: xsysdatabasestring, 
			tablename: tablename
		}, 
		async: false, method: 'post',    
		success: function(data) {   
			eval("fieldset="+data+";");
		}     
	});
	var sql='';
	if (fieldset!=''){
		var insertsql1="insert into "+tablename+"(";
		var insertsql2="values(";
		for (var i=0; i<fieldset.length; i++){
			var field=fieldset[i].field;
			if (i>0){
				insertsql1+=','  
				insertsql2+=','
			}
			insertsql1+=field;
			insertsql2+="'"+myToSqlValue(myGetValue(field))+"'";
		}
		sql+=insertsql1+') '+insertsql2+')';
	}
   	return(sql);
};	

//生成update语句
function myGenUpdateSql(xsysdatabasestring,tablename,keyfield){  //获取一个表中可编辑的列名
	var fieldset='';
	$.ajax({     
		type: "Post",     
		url: "system//easyui_getEditableFields.jsp",     
		//contentType: "application/json; charset=utf-8",     
		//dataType: "json", 
		data: {
			database: xsysdatabasestring, 
			tablename: tablename
		}, 
		async: false, method: 'post',    
		success: function(data) {
			eval("fieldset="+data+";");
		}   
	});
	//console.log(fieldset.length);
	//console.log(fieldset[0].field);
	var sql='';
	if (fieldset.length>0){
		sql="update "+tablename+" set ";
		for (var i=0; i<fieldset.length; i++){
			if (i>0){
				sql+=','  
			}
			var field=fieldset[i].field;
			//console.log(field);
			sql+=field+"='"+myToSqlValue(myGetValue(field))+"'";
		}
		sql+=" where "+keyfield+"='"+myToSqlValue(myGetValue(keyfield))+"'";
	}
   	return(sql);
};	

function myKeyDownEvent(c){   //kkkkkkkkkeydown
 	var pfield=[];
 	var k=0;
 	var ptype=''; 
 	var pid='';
 	var phidden='';
 	if (c!=undefined && c!='') pfield=c.split(';');
 	else{
 	 	//$('input, select, textarea').each(function(index){  
		$('input').each(function(index){  
			pfield[k]=$(this).attr('id');
			k++;
		});
	}		
	for (k=0; k<pfield.length; k++){
		pid=pfield[k];
		var pinput = $("#"+pfield[k]);    //$(this);
		ptype=pinput.attr('type');
		phidden=pinput.attr('hidden');
		//alert(ptype);
		//console.log(ptype+'------'+phidden+'------'+pinput+'------'+sys.keyeventcmp);
		//console.log(sys.keyeventcmp.indexOf(';'+ptype+';'));
		//if (pid!=undefined && pinput!=undefined && phidden!='hidden' && ptype!='checkbox' && ptype!='textarea' && ptype!='file' && ptype!='button' ){
		if (pid!=undefined && pinput!=undefined && phidden!='hidden' && sys.keyeventcmp.indexOf(';'+ptype+';')>=0){
			myBindKeyDownEvent(pid);
			//var focused=document.activeElement;
			//if (this==focused) xno=i;
		}	
 	}  //for k
} 	
 	
function myBindKeyDownEvent(id){   //kkkkkkkkkeydown
	var type=$('#'+id).attr('type');
	var cmp=$('#'+id);
	if (type!='checkbox' && type!='textarea' && type!='button' && type!='file'){
		//console.log(id);
		$('#'+id).textbox('textbox').bind('keydown',function(e){
			var key=e.which;
			//e.preventDefault();  //不能加，否则只读
			var xcmp=[];
			var xtype=[];
			var i=0;
			if (key==13 || key==40 || key==38){ //  || key==35 || key==36){  //38--up  40--down
				var xno=-1;
				//$('input, select, textarea').each(function(index){  
				$('input').each(function(index){  
					var input = $(this);
					field=input.attr('id');
					type=input.attr('type');
					hidden=input.attr('hidden');
					//console.log(field+'---'+type+'----'+hidden);					
					if (field!=undefined && hidden!='hidden'){
						//console.log(field+'---'+type+'----'+hidden);
						if (id==field) xno=i;
						xcmp[i]=field;
						xtype[i]=type;
						i++;
					}
				});
				if (xno<xcmp.length && xno>=0){
					var n=0;
					if (key==13 || key==40 ){  //向下
						if (xno<=i) n=xno+1;
						else n=i;
					}else if (key==38 ){   //向上
						if (xno>0) n=xno-1;
						else n=0;
					} 
					var xnewcmp=xcmp[n];
					var xtype=xtype[n];
					//$('#'+xnewcmp).next().find('input').focus();
					if (xtype=='textarea') $("#"+xnewcmp).focus();
					else $("#"+xnewcmp).next("span").find("input").focus();
				}
			}
		});
	}
}	

function myDisableCmp(items,flag){
	var tmp=items.split(';')
	for (var i=0; i<tmp.length; i++){
		var cmp=$("#"+tmp[i]);
		if (cmp){
			var xclass=cmp.attr('class');
			//console.log(tmp[i]+'----'+cmp.attr('class'));
			//console.log(cmp);
			if (xclass.indexOf('linkbutton')>=0){ 
				//cmp.prop('disabled', flag);
				if (flag) cmp.linkbutton('disable');
				else cmp.linkbutton('enable');
			}else if (xclass.indexOf('menubutton')>=0 || xclass.indexOf('menu-item')>=0){
				if (flag) cmp.menubutton({'disabled':true, hasDownArrow: false});
				else cmp.menubutton({'disabled':false, hasDownArrow: false});			
			}
		}
	}
}

function myFocus(id){
	var cmp=$("#"+id);
	var xtype=cmp.attr('type');
	if (xtype=='textarea') cmp.focus();
	else cmp.next("span").find("input").focus();
}

function xmySelectOnFocus(){
//IE第一个控件不会选中
	$("input").focus(function(){
	    $(this).on("click.a keyup.a", function(e){      
	        $(this).off("click.a keyup.a").select();
	    });
	});
}
	
function mySelectOnFocus(){
	$('input').on('focus', function() {
		var $this = $(this)
		.one('mouseup.mouseupSelect', function() {
			$this.select();
			return false;
		})
		.one('mousedown', function() {
			// compensate for untriggered 'mouseup' caused by focus via tab
			$this.off('mouseup.mouseupSelect');
		})
		.select();
	});
}


function myGetChartXMLHeader(pmyChart){
	//返回fusionchart图表文件的xml文件头
	var str="<chart caption=\""+pmyChart.title+"\" XAxisName=\""+pmyChart.xAxisName+"\" YAxisName=\""+pmyChart.yAxisName+"\"";
	str+="\n numberPrefix=\"\" showValues=\"0\" formatNumberScale=\"0\" showAboutMenuItem=\"0\"";
	str+="\n seriesNameInToolTip=\"1\" chartTopMargin=\"10\" chartBottomMargin=\"10\" chartLeftMargin=\"10\" chartRightMargin=\"10\"";
	str+="\n baseFont=\"宋体\" baseFontSize=\"10\"";
	str+="\n exportEnabled=\"1\" exportDialogMessage=\"正在导出,请稍候...\" exportFormats=\"JPEG=导出为JPG图片|PNG=导出为PNG图片|PDF=导出为PDF文件\"";
	str+="\n exportDataMenuItemLabel=\"导出图片\" showExportDataMenuItem=\"1\" exportAtClient=\"1\"";
	str+="\n useRoundEdges=\"1\" animation=\"0\" palette=\"2\" >";
	return(str);
};	

function myGetChartXMLFooter(pmyChart){
	//返回fusionchart图表文件的xml文件尾部
	var str="\n <styles>";
	str+="\n <definition>";
	str+="\n <style type=\"font\" color=\"666666\" name=\"CaptionFont\" font=\"黑体\" size=\"16\" />";
	str+="\n <style type=\"font\" name=\"SubCaptionFont\" font=\"宋体\" size=\"12\" bold=\"0\" />";
	str+="\n </definition>";
	str+="\n <application>";
	str+="\n <apply toObject=\"caption\" styles=\"CaptionFont\" />";
	str+="\n <apply toObject=\"SubCaption\" styles=\"SubCaptionFont\" />";
	str+="\n </application>";
	str+="\n </styles>";
	str+="\n </chart>";
	return(str);
};

function myGetFunnelXML(pmyChart){
	var xml='<chart caption="销售额排名前10名" decimals="0" numberPrefix="$" streamlinedData="0" bgColor="f7f2ea" borderColor="f7f2ea" chartLeftMargin="50" chartRightMargin="50" chartTopMargin="5" chartBottomMargin="5" baseFont="宋体" baseFontSize="12" exportEnabled="1" showAboutMenuItem="0" borderthickness="0" bgAlpha="100" >';
	for (var i=0;i<pmyChart.data.length;i++){
		var s1=eval('pmyChart.data['+i+'].'+pmyChart.labelfield);
		var s2=eval('pmyChart.data['+i+'].'+pmyChart.valuefield);
		xml+="<set label='"+eval('pmyChart.data['+i+'].'+pmyChart.labelfield)+"'";
		xml+=" value='"+eval('pmyChart.data['+i+'].'+pmyChart.valuefield)+"'";
		if (pmyChart.sliced){
			xml+=" issliced='1'"; 		    
	    }
	    xml+=' />\n';
	}
	xml+='\n</chart>';
	return xml;
}

function myGetAngularXML(pmyChart){
	var deltax=70+parseInt(pmyChart.radius-pmyChart.label.length*12/2);
	var deltay=parseInt(pmyChart.height/2)+25;
	pmyChart.xml='';
	pmyChart.xml+='<chart bgCOlor="FFFFFF" upperLimit="'+pmyChart.max+'" lowerLimit="'+pmyChart.min+'" showAboutMenuItem="0" baseFontColor="FFFFFF"'+  
	'\n majorTMNumber="9" majorTMColor="FFFFFF"  majorTMHeight="8" majorTMThickness="5" minorTMNumber="5" minorTMColor="FFFFFF"'+ 
	'\n	chartTopMargin="0" chartBottomMargin="0" minorTMHeight="3" minorTMThickness="2" pivotRadius="10" pivotBgColor="000000" pivotBorderColor="FFFFFF" '+
	'\n	pivotBorderThickness="2" hoverCapBorderColor="FFFFFF" toolTipBgColor="333333"  gaugeOuterRadius="110" '+
  	'\n	gaugeScaleAngle="300" gaugeAlpha="0" decimalPrecision="0" displayValueDistance="0" showColorRange="0"'+ 
  	'\n	placeValuesInside="1" pivotFillMix="" showPivotBorder="1" annRenderDelay="0">'+
	'\n	<dials>'+ 	
	'\n	<dial value="'+pmyChart.value+'" bgColor="000000" borderColor="FFFFFF" borderAlpha="100" baseWidth="4" topWidth="4" editMode="1" borderThickness="2"/>'+
	'\n	</dials>'+
  	'\n	<annotations>'+
	'\n	<annotationGroup xPos="'+parseInt(pmyChart.width/2)+'" yPos="'+parseInt(pmyChart.height/2)+'">'+
	'\n	<annotation type="circle" radius="'+pmyChart.radius+'" startAngle="0" endAngle="360" fillAsGradient="1" fillColor="4B4B4B, AAAAAA" fillAlpha="100,100"  fillRatio="95,5" />'+
	'\n	<annotation type="circle" xPos="0" yPos="0" radius="'+(pmyChart.radius-10)+'" startAngle="0" endAngle="360" showBorder="1" borderColor= "cccccc" fillAsGradient="1"  fillColor="ffffff, 000000"  fillAlpha="50,100"  fillRatio="1,99" />'+
	'\n	</annotationGroup>'+
	'\n	<annotationGroup xPos="'+deltax+'" yPos="'+deltay+'" showBelow="1">'+
	'\n	<annotation type="text" label="'+pmyChart.label+'" fontColor="FFFFFF" fontSize="12" isBold="0"/>'+
	'\n	</annotationGroup>'+
	'\n	</annotations>'+
	'\n</chart>';

	
	


	return (pmyChart.xml);	
}
	
//生成fusionchart的xml
function myGetChartXML(pmyChart){
	var data=pmyChart.data;
	pmyChart.drilldownfields=[];
	if (pmyChart.drilldown!=undefined && pmyChart.drilldown!=''){
	   	var x1=pmyChart.drilldown.indexOf('(');
	   	var x2=pmyChart.drilldown.indexOf(')');
	   	var s=pmyChart.drilldown.substring(x1+1,x2);
	   	var str='';  //参数值
	   	pmyChart.drilldownfields=s.split(',');  //分离参数
	   	pmyChart.drilldown=pmyChart.drilldown.substring(0,x1);
	}
	pmyChart.xml='';
	var xml='\n';
	if (pmyChart.type=='single' || pmyChart.type=='ss'){ //单序列
		for (var i=0;i<pmyChart.data.length;i++){
			var s1=eval('pmyChart.data['+i+'].'+pmyChart.labelfield);
			var s2=eval('pmyChart.data['+i+'].'+pmyChart.valuefield);
			//console.log(s1+'-------'+s2);
			xml+="<set label='"+eval('pmyChart.data['+i+'].'+pmyChart.labelfield)+"'";
			xml+=" value='"+eval('pmyChart.data['+i+'].'+pmyChart.valuefield)+"'";
			if (pmyChart.sliced){
				xml+=" issliced='1'"; 		    
		    }
		    //处理钻取的链接参数1
		    if (pmyChart.drilldown!=undefined && pmyChart.drilldown!=''){
		    	var pstr='';
		    	for (var m=0;m<pmyChart.drilldownfields.length;m++){
					var f=pmyChart.drilldownfields[m];
					if (f.substr(0,1)=='"' || f.substr(0,1)=="'") var v=eval(f);
					else var v=eval('pmyChart.data['+i+'].'+f);
					if (m>0) pstr+=',';
					if (v!=undefined) pstr+="\""+v+"\"";
					else pstr+="\""+f+"\"";
		    	}
		    	xml+=" link='javascript:"+pmyChart.drilldown+"("+pstr+")'";		    
		    	//xml+=" link='javascript:"+pmyChart.drilldown+"(\""+s1+"\")'";		    
		    }
		    xml+=' />\n';
		}
		pmyChart.xml=myGetChartXMLHeader(pmyChart);  //取xml的文件头部分
		pmyChart.xml+=xml;
		console.log(xml);
		pmyChart.xml+=myGetChartXMLFooter(pmyChart);
	}else if (pmyChart.type=='multiple' || pmyChart.type=='ms'){  //多序列
		xml+="\n<categories>";
		for (var i=0;i<pmyChart.data.length;i++){
			var s1=eval('pmyChart.data['+i+'].'+pmyChart.labelfield);
			xml+="\n	<category label=\""+s1+"\" />";
		}	
		xml+="\n</categories>";
		var yfields=pmyChart.valuefield.split(';');
		var ylabels=pmyChart.yAxisName.split(';');
		//处理某个指标
		var xcolor=[]
		if (pmyChart.colorset!=undefined) xcolor=pmyChart.colorset.split(';');
		j=0;
		for (var k=0;k<yfields.length;k++){  //第一个序列指标
			xml+="\n<dataset seriesname=\""+ylabels[k]+"\"";
			if (k>0) xml+=" parentYAxis=\"S\"";
			xml+=" >";
			for (var i=0;i<pmyChart.data.length;i++){
				var s1=eval('pmyChart.data['+i+'].'+pmyChart.labelfield);
				var s2=eval('pmyChart.data['+i+'].'+yfields[k]);
				xml+="\n	<set ";
				if (xcolor.length>0){
					xml+=" color=\""+xcolor[j]+"\"";
					j++;
					if (j>=xcolor.length) j=0;
				}
				xml+=" value=\""+s2+"\"";

			    //处理钻取的链接参数2
			    if (pmyChart.drilldown!=undefined && pmyChart.drilldown!=''){
			    	var pstr='';
			    	for (var m=0;m<pmyChart.drilldownfields.length;m++){
						var f=pmyChart.drilldownfields[m];
						if (f.substr(0,1)=='"' || f.substr(0,1)=="'") var v=eval(f);
						else var v=eval('pmyChart.data['+i+'].'+f);
						if (m>0) pstr+=',';
						if (v!=undefined) pstr+="\""+v+"\"";
						else pstr+="\""+f+"\"";
			    	}
			    	xml+=" link='javascript:"+pmyChart.drilldown+"("+pstr+")'";		    
			    	//xml+=" link='javascript:"+pmyChart.drilldown+"(\""+s1+"\")'";		    
			    }
				xml+=" />";
			}
			xml+="\n</dataset>";
		}		
		pmyChart.xml=myGetChartXMLHeader(pmyChart);  //取xml的文件头部分
		pmyChart.xml+=xml;
		pmyChart.xml+='\n'+myGetChartXMLFooter(pmyChart);
		//console.log(xml);
	}else if (pmyChart.type=='angular'){
		pmyChart.xml=myGetAngularXML(pmyChart);
	}else if (pmyChart.type=='funnel'){
		pmyChart.xml=myGetFunnelXML(pmyChart);
	}
	return pmyChart;
}	

//显示fusionchart图表ffffffusion
function myShowFusionChart(pmyChart,swf,div){
	//Pyramid;仪表盘/AngularGauge;温度计/Thermometer
	var pw=$("#"+div).width();
	var ph=$("#"+div).height();
	var xwidth=0;
	var xheight=0;
	var charttype=[];
	charttype[1]=";MSSpline;MSColumn3D;MSColumn3DLineDY;MSSplineArea;MSLine;MSColumn2D;MSColumnLine3D;MSArea;";  //多序列
	charttype[1]+="Line;Column3D;Column2D;Area2D;";    //折线图、圆柱体、面积图
	charttype[2]=";MSBar3D;MSBar2D;Bar2D;";  //栏位图
	charttype[3]=";Doughnut3D;Doughnut2D;Pie3D;Pie2D;";    //圆饼图环形图
	charttype[4]=";Pyramid;";  
	charttype[5]=";funnel;";    //圆饼图环形图
	//ert(charttype.length);
	if (pmyChart.data!=undefined)var n=pmyChart.data.length;
	else var n=1;
	for (var i=1;i<charttype.length-1;i++) charttype[i]=charttype[i].toLowerCase();
	var xswf=";"+swf.toLowerCase()+";";
	if (charttype[1].indexOf(xswf)>=0){  //折线图圆柱图
		xwidth=Math.max(n*7*6+172,600);
		xheight=300;
	}else if (charttype[2].indexOf(xswf)>=0){  //栏位图
		xheight=Math.max(Math.min(280+n*12,700),450);
		xwidth=300;
	}else if (charttype[3].indexOf(xswf)>=0){  //圆饼图
		xwidth=Math.max(Math.min(300+n*20,600),400);
		xheight=Math.max(Math.min(200+n*10,400),300);
		if (pmyChart.width>0){
			xwidth=pmyChart.width;
			pw=xwidth;
		}
		if (pmyChart.height>0){
			xheight=pmyChart.height;
			ph=xheight;
		}
	}else if (charttype[4].indexOf(xswf)>=0){  //圆锥图
		xheight=Math.max(Math.min(350+n*12,700),450);
		xwidth=600;
	}
	
	if (pmyChart.width<=0 && xwidth<pw) xwidth='100%';
	else xwidth=Math.max(xwidth,pmyChart.width);
	if (pmyChart.height<=0 && xheight<ph) xheight='99%';
	else xheight=Math.max(xheight,pmyChart.height);
	//显示chart
	var chart = new FusionCharts("jqeasyui/fusioncharts/swf/"+swf+".swf","chartid_"+sys.fusionchartno,""+xwidth+"",""+xheight+"","0","1");
	//var chart = new FusionCharts("system/fusioncharts/swf/MSColumnLine3D.swf", "myChart1","748","400","0","0");
  	chart.setDataXML(pmyChart.xml);
	//chart.setDataURL("system/fusioncharts/xml/Bar2D.xml");
  	chart.render(div);
  	//pmyChart.chartno++;
  	sys.fusionchartno++;
  	return pmyChart;
}	

//调用后台excel转换程序
function myExportExcelReport(xsysdatabasestring,pmyReport1){
	//?问号方式传递无法向后台传递带%的字符
	pmyReport1.headercells=pmyReport1.headercells.replace(eval("/"+"%"+"/g"),"％");
	pmyReport1.footercells=pmyReport1.footercells.replace(eval("/"+"%"+"/g"),"％");
	var filename="";
	$.ajax({
		url:'system//easyui_toExcelFile.jsp?headercells='+pmyReport1.headercells+'&footercells='+pmyReport1.footercells,
		data:{ database:xsysdatabasestring, 
			template:pmyReport1.template, 
			selectsql:pmyReport1.sql,
			fields:pmyReport1.fields,
			headerrange:pmyReport1.headerrange, 
			regionrange:pmyReport1.regionrange
		},									
		//method: 'POST',
		async:false, method: 'post',
   		success:function(data){
    		//console.log(data);
   			eval("var result="+data);
    		filename=result[0].filename;
    		//console.log('f='+filename);
		}	
	});
	var xsourcefilename=filename;
	var url='system//easyui_fileDownLoad.jsp?source='+filename+'&target='+pmyReport1.targetfilename;
	//console.log(filename);
	//console.log(url);
	window.location.href=url;
	return(url);
}

//生成uniqueidentifier newid()
function myGenNewID(sysdatabasestring, tablename){
	
	
}

function myGetIPAddress(){  //获取IP地址
	var source=[];
	$.ajax({     
		url: "system/easyui_getIPAddress.jsp",     
		async: false, method: 'post', 
		success: function(data) {     
			//返回的数据用data获取内容,直接复制到客户端数组source
			eval("source="+data); 
		}     
	});
	return source;
}
	

function myRunSelectSql(databasestring, sql){  //单行结果集
	source=[];
	$.ajax({     
		type: "Post",     
		url: "system/easyui_execSelect.jsp",     
		//contentType: "application/json; charset=utf-8",     
		//dataType: "json", 
		data: {database: sysdatabasestring, selectsql: sql}, 
		async: false, method: 'post',    
		success: function(data) {     
			//返回的数据用data获取内容,直接复制到客户端数组source
			source=eval(data); 
		}     
	});
	return source;
	//return (jQuery.parseJSON(source)); 
}


function myRunUpdateSql(databasestring, sql){  //单行结果集
	if (tablename==undefined) var tablename='';
	result={};
	$.ajax({     
		type: "Post",     
		url: "system/easyui_execUpdate.jsp",     
		//contentType: "application/json; charset=utf-8",     
		//dataType: "json", 
		data: {database: sysdatabasestring, updatesql: sql}, 
		async: false, method: 'post',   
		success: function(data) {     
			//返回的数据用data获取内容,直接复制到客户端数组source      
			eval("result="+data);
		},     
		error: function(err) {     
			result="{'error':'"+err+"'}";     
		}     
	});
	return (result); 
}


/**
 * linkbutton方法扩展，在disable方法下禁止点击
 * @param {Object} jq
 */
$.extend($.fn.linkbutton.methods, {
    /**
     * 激活选项（覆盖重写）
     * @param {Object} jq
     */
    enable: function(jq){
        return jq.each(function(){
            var state = $.data(this, 'linkbutton');
            if ($(this).hasClass('l-btn-disabled')) {
                var itemData = state._eventsStore;
                //恢复超链接
                if (itemData.href) {
                    $(this).attr("href", itemData.href);
                }
                //回复点击事件
                if (itemData.onclicks) {
                    for (var j = 0; j < itemData.onclicks.length; j++) {
                        $(this).bind('click', itemData.onclicks[j]);
                    }
                }
                //设置target为null，清空存储的事件处理程序
                itemData.target = null;
                itemData.onclicks = [];
                $(this).removeClass('l-btn-disabled');
            }
        });
    },
    /**
     * 禁用选项（覆盖重写）
     * @param {Object} jq
     */
    disable: function(jq){
        return jq.each(function(){
            var state = $.data(this, 'linkbutton');
            if (!state._eventsStore)
                state._eventsStore = {};
            if (!$(this).hasClass('l-btn-disabled')) {
                var eventsStore = {};
                eventsStore.target = this;
                eventsStore.onclicks = [];
                //处理超链接
                var strHref = $(this).attr("href");
                if (strHref) {
                    eventsStore.href = strHref;
                    $(this).attr("href", "javascript:void(0)");
                }
                //处理直接耦合绑定到onclick属性上的事件
                var onclickStr = $(this).attr("onclick");
                if (onclickStr && onclickStr != "") {
                    eventsStore.onclicks[eventsStore.onclicks.length] = new Function(onclickStr);
                    $(this).attr("onclick", "");
                }
                //处理使用jquery绑定的事件
                var eventDatas = $(this).data("events") || $._data(this, 'events');
                if (eventDatas["click"]) {
                    var eventData = eventDatas["click"];
                    for (var i = 0; i < eventData.length; i++) {
                        if (eventData[i].namespace != "menu") {
                            eventsStore.onclicks[eventsStore.onclicks.length] = eventData[i]["handler"];
                            $(this).unbind('click', eventData[i]["handler"]);
                            i--;
                        }
                    }
                }
                state._eventsStore = eventsStore;
                $(this).addClass('l-btn-disabled');
            }
        });
    }
});

$.fn.treegrid.defaults.loadFilter = function(data, parentId){
	var opts = $.data(this, 'treegrid').options;
	if (!opts.columns){
		var dgOpts = $.data(this, 'datagrid').options;
		opts.columns = dgOpts.columns;
		opts.frozenColumns = dgOpts.columns;
	}
	return data;
};

//只求下一层的子节点，默认是所有层次的子节点，即包括子节点的子节点
$.extend($.fn.tree.methods,{
	getLeafChildren:function(jq, params){
		var nodes = [];
		$(params).next().children().children("div.tree-node").each(function(){
			nodes.push($(jq[0]).tree('getNode',this));
		});
		return nodes;
	}
});		
