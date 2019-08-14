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
        var studentsource=[
            {"bookid":"9787020002207","bookname":"红楼梦","pycode":"hongloumeng","category":"文学","releasedate":"2003-01-01","writer":"曹雪芹","price":"33.6","press":"人民文学出版社","baozhuang":"平装"},
            {"bookid":"9787550292505","bookname":"牛奶可乐经济学","pycode":"keleniunaijingjixue","category":"经济","releasedate":"2017-01-01","writer":"罗伯特·弗兰克","price":"30.0","press":"北京联合出版公司","baozhuang":"平装"},
            {"bookid":"9787544547642","bookname":"名侦探柯南90","pycode":"mingzhentankenan90","category":"动漫/幽默 ","releasedate":"2017-03-01","writer":"青山刚昌","price":"9.0","press":"长春出版社","baozhuang":"平装"}
        ];//修改书本编码，与此同时将与之对应的书本图片的名字改为书本编码.jpg
        myWindow('myWin1','JSon格式数据',10,400,200,520,'','close');
        myTextareaField('xformvalues','myWin1','',0,2,1,152,482,'','');
        myForm('myForm1','main','书本信息',0,0,500,540,'');
        myFieldset('myFieldset1','myForm1','基本信息',10,10,430,280);
        myLabel('bookidx','myFieldset1','书本编码：',36*0+25,12,0,0);
        myTextField('bookname','myFieldset1','书本名称：',70,36*1+20,12,0,175);
        myTextField('pycode','myFieldset1','汉语拼音：',70,36*2+20,12,0,175,'');
        myDateField('releasedate','myFieldset1','出版日期：',70,36*3+20,12,0,120,'1997-2-17');
        myComboField('category','myFieldset1','类别：',70,36*4+20,12,0,120,'文学;艺术;动漫/幽默 ;娱乐时尚;旅游;心理;管理;经济','');
        myTextField('writer','myFieldset1','作者：',70,36*5+20,12,0,175,'');
        myNumberField('price','myFieldset1','价格：',70,36*6+20,12,0,45,'');
        myTextField('press','myFieldset1','出版社：',70,36*7+20,12,0,175,'');
        myLabel('kaiben','myFieldset1','开本：',36*8+20,12,0,0);
        myTextField('baozhuang','myFieldset1','包装：',70,36*9+20,12,0,175,'');
        //定义书本对应的下拉框combobox
        str='<div id="bookid_div" style="border:0px;">';
        str+='<div class="easyui-combobox" id="bookid" style="padding:0px 6px 0px 6px" ></div>';
        str+='</div>';
        str+='<label id="kaibenx"><input checked="true" class="radio" value="16" name="kaiben" type="radio"/>16开&nbsp;&nbsp;&nbsp;<input class="radio" value="32" name="kaiben" type="radio"/>32开</label>';
        str+='<div id="button"><input class="easyui-linkbutton" type="button" id="submit" value="确定" style="width:60px"/><input class="easyui-linkbutton" type="button" id="cancel" value="取消" style="width:60px;margin-left:10px;"/></div>';
        //也可以用myButton函数
        $("#myFieldset1").append($(str));
        $("#bookid_div").css({position:'absolute',top:'24px', left:'86px'});
        $("#price").numberbox({precision:1, max:200, min:0});
        $("#bookid").combobox({
            width:175,
            panelHeight: 'auto',
            editable: false,
            data: studentsource,
            valueField: 'bookid',
            textField: 'bookid'
        });
        $("#kaibenx").css({position:'absolute',top:'306px',left:'84px'});
        //定义图片
        var str='<img id="image1" src="" style="position: absolute; top:18px; left:305px;"></img>';
        str+='<div style="position: absolute; top:230px; left:305px; width:200px;">';
        str+='<input id="slider1" class="easyui-slider" value="0" ></div>';
        $("#myForm1").append($(str));
        //定义slider
        $("#button").css({position:'absolute',top:'390px',left:'80px'});
        $("#slider1").slider({
            showTip: true,
            min:1,
            max:100,
            rule: [0,'|',25,'|',50,'|',75,'|',100],
            tipFormatter: function(value){
                return value;
            }
        });
        //定义下拉框的onselect事件
        $("#bookid").combobox({
            onSelect: function(record) {  //选中事件
                if (record){
                    $("#bookname").textbox("setValue",record.bookname);
                    $("#pycode").textbox("setValue",record.pycode);
                    $("#category").textbox("setValue",record.category);
                    $("#releasedate").textbox("setValue",record.releasedate);
                    $("#writer").textbox("setValue",record.writer);
                    $("#price").textbox("setValue",record.price);
                    $("#press").textbox("setValue",record.press);
                    $("#baozhuang").textbox("setValue",record.baozhuang);
                    $("#slider1").slider('setValue',60);
                    var src="system/images/"+record.bookid+".jpg";
                    $("#image1").attr('src',src);
                    resizeImage('image1',src);
                }
            }
        });
        //定义slider1的onchange事件
        $("#slider1").slider({
            onChange: function(value){
              var src=$("#image1").attr("src");
              resizeImage('image1',src,value);
           }
        });
        //设置初值
        $("#slider1").slider('setValue',60);
        $('#bookid').combobox('select',studentsource[0].bookid);
       
        //定义图片缩放函数
        function resizeImage(img,src){
            var image=new Image();
            image.src=src;
            ratio=$("#slider1").val()/100.0;           
            image.onload=function() {  //必须放在onload事件中
                var aheight=image.height+0; 
                var awidth=image.width+0;
                //调整图片大小,按比例缩放
                if (ratio!=0){
                    awidth = awidth * ratio;
                    aheight = aheight * ratio;
                    $("#image1").css({width: awidth, height: aheight});
                }
            }
        }
        //取出值
        $("#submit").click(function(event) {
            var data='';
            $("#xformvalues").val('');
            $('input, select, textarea').each(function(index){
                var input = $(this);
                var id=input.attr('id');
                var value=undefined;
                var type=input.attr('type');
                var hidden=input.attr('hidden');
                if (id!=undefined){
                    if (type=='text' && hidden!='hidden'){
                        value=input.textbox('getValue');
                    }else if (type=='combobox'){
                        value=input.combobox('getValue');
                    }else if (type=='checkbox'){
                        if (input.is(':checked')) value=input.attr('xtext');
                    }else if (type!='button'){
                        value=input.val();         
                    }
                    if (value!=undefined){
                        if (data!='') data+=',';           
                        data+='"'+id+'":"'+value+'"';
                        console.log(id+'----'+type+'----'+value);
                    }
                }
           });
           data='{'+data+'}';
           $("#myWin1").window('open');
           $("#xformvalues").val(data);       
        });
        $("combobox:first").next("span").find("input").focus();
    });
</script>
</body>
</html>