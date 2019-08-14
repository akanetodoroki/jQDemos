<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>jQuery UI Datepicker - Default functionality</title>
  <script type="text/javascript" src="jquery/jquery-1.11.3.js"></script>
  <script type="text/javascript" src="jquery/jquery-ui-1.11.4.js"></script>
  <script type="text/javascript" src="system/jq_functions.js"></script>
  <link rel="stylesheet" href="system/css/jquery.css">
  <link rel="stylesheet" href="system/css/jquery-ui.css">
  <script>
  $(document).ready(function() {
	myDefineTextField('text1','main','学号：',70,240,100,0,100,'zxywolf');
	//$( "#text1" ).attr("value","zxywolf ok");
	
	//$("#main").append("<input type=\"text\" name=\"text1\"+ \"\"/>");
    $( "#datepicker1" ).datepicker();
    //offset()获取当前元素基于浏览的位置  
    var top1=$("#datepicker1" ).offset().top;   
 	var left1=$("#datepicker1").offset().left;
 	//position()获取当前元素基于父容器的位置 
    //var top1=$("#datepicker1" ).position().top;   
 	//var left1=$("#datepicker1").position().left;
	$("#datepicker2").css({position: "absolute","top":top1+28,"left":left1,"z-index":2});
	//设置成jquery样式
    $( "#submit" ).button();
    $( "#check" ).button();
    $( "#format" ).buttonset();
    //$( "#radio" ).buttonset();  //设置成jquery风格
    //设置toolbar
	$( "#beginning" ).button({
      text: false, icons: {
        primary: "ui-icon-seek-start"
      }
    });
    $( "#rewind" ).button({
      text: false, icons: {
        primary: "ui-icon-seek-prev"
      }
    });
    $( "#play" ).button({
      text: false, icons: {
        primary: "ui-icon-play"
      }
    });   
    

    $( "#element" )
    .button()
    .click(function() {
		JqSetValue("datepicker1","text","11/5/2015");
		JqSetValue("datepicker2","text","zxywolf@126.com");
		JqSetValue("check1","checkbox","check1");
		$("#check1").attr("checked", true);   
		$("#radio1").attr("checked", true);		
      });
    
    
    
//设置菜单
$( "#rerun" )
      .button()
      .click(function() {
        alert( "Running the last action" );
      })
      .next()
        .button({
          text: false,
          icons: {
            //primary: "ui-icon-triangle-1-s"
          }
        })
        .click(function() {
          var menu = $( this ).parent().next().show().position({
            my: "left top",
            at: "left bottom",
            of: this
          });
          $( document ).one( "click", function() {
            menu.hide();
          });
          return false;
        })
        .parent()
        .buttonset()
        .next()
        .hide()
        .menu();
    
    
//------------------------------//    
  });
  
function JqGetValue(controlID, controltype) {  
 var objValue = "";  
 switch (controltype) {  
  case 'text': //文本输入框  
   objValue = $.trim($("#" + controlID + "").attr("value")); //取值去左右空格  
   break;  
  case 'radio': //单选框  
   objValue = $("input[name='" + controlID + "']:checked").attr("value");  
   break;  
  case 'select': //下拉列表  
   objValue = $("#" + controlID + "").attr("value");  
   break;  
  case 'checkbox': //多选框  
   $("input[name='" + controlID + "']:checked").each(function () {  
    objValue += $(this).val() + ",";  
   });  
   break;  
  default:  
   break;  
 }  
  return objValue;   
}  

//Jquery设置控件的值  
function JqSetValue(controlID, controltype, controlvalue) {  
 switch (controltype) {  
  case 'text': //文本输入框
   $("#" + controlID + "").attr("value", controlvalue);  
   //$("#txtUserID").attr("value", '这是绑定内容'); //填充内容  
   //$("input[name='radio1'][value='上海']").attr("checked", true); //单选组radio：设置value='上海'的项目为当前选中项  
   //$("#select1").attr("value", '葡萄牙'); //下拉框select：设置value='中国'的项目为当前选中项  
   //$("input[name='checkbox1'][value='黑色'],[value='蓝色']").attr("checked", true); //多选框：设置多个值为当前选中项  
   //$("#" + controlID + "").attr("value", controlvalue); //填充内容  
   break;  
  case 'radio': //单选框  
   $("input[name='" + controlID + "'][value='" + controlvalue + "']").attr("checked", true);  
   break;  
  case 'select': //下拉列表  
   $("#" + controlID + "").attr("value", controlvalue);  
   break;  
  case 'checkbox': //多选框  
   //$("input[name='" + controlID + "'][value='" + controlvalue + "'],[value='" + controlvalue + "']").attr("checked", true); //多选框：设置多个值为当前选中项  
   $("input[name='" + controlID + "'][value='" + controlvalue + "']").attr("checked", true); //多选框：设置多个值为当前选中项  
   break;  
  default:  
   break;  
 }  
} 
  
  </script>
</head>
<body>
<div id="main"> 
<div> 
<form id="form1">

<div id="toolbar" class="ui-widget-header ui-corner-all">
  <button id="beginning">go to beginning</button>
  <button id="rewind">rewind</button>
  <button id="play">play</button>
  <button id="stop">stop</button>
  <button id="forward">fast forward</button>
  <button id="end">go to end</button>
  <input type="checkbox" id="shuffle"><label for="shuffle">Shuffle</label>
  <span id="repeat">
    <input type="radio" id="repeat0" name="repeat" checked="checked"><label for="repeat0">No Repeat</label>
    <input type="radio" id="repeat1" name="repeat"><label for="repeat1">Once</label>
    <input type="radio" id="repeatall" name="repeat"><label for="repeatall">All</label>
  </span>
</div>

<p>Date: <input type="text" id="datepicker1"></p>
<p>Date: <input type="text" id="datepicker2" style="TOP: 100px; LEFT: 300px; HEIGHT: 18px; WIDTH: 180px; POSITION: absolute" cellSpacing=2 cellPadding=1 width=500 align=left border=1></p>
<div>
<input type="button" id="element" value="set value button">
<input type="submit" id="submit" value="A submit button">
<a href="#">An anchor</a>
</div>

<input type="checkbox" id="check"><label for="check">Toggle</label>
<div id="checkbox">
  <input type="checkbox" id="check1"><label for="check1">Business</label>
  <input type="checkbox" id="check2"><label for="check2">IT technology</label>
  <input type="checkbox" id="check3"><label for="check3">University</label>
</div>

<div id="radio">
    <input type="radio" id="radio1" name="radio"><label for="radio1">Choice 1</label>
    <input type="radio" id="radio2" name="radio" checked="checked"><label for="radio2">Choice 2</label>
    <input type="radio" id="radio3" name="radio"><label for="radio3">Choice 3</label>
</div>


<div>
  <div>
    <button id="rerun">Run last action</button>
    <button id="select">Select an action</button>
  </div>
  <ul>
    <li>Open...</li>
    <li>Save</li>
    <li>Delete</li>
  </ul>
</div>

</form>
</body>
</html>