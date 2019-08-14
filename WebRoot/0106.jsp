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
        <div id='container' class='easyui-panel' data-options="region:'north'" style="overflow:hidden; background-color: #E0ECFF; height:33px; ">
            <div id='tool' class='easyui-panel' style="overflow:hidden; background-color: #E0ECFF; height:33px; padding: 1px 1px 1px 10px;">
                <a href="#" class="btn-separator"></a>
                <a href="#" id="btnadd" class="easyui-linkbutton" data-options="iconCls:'addIcon', plain:true,onClick:fn_add" style="">新增</a>
                <a href="#" id="btnedit" class="easyui-linkbutton" data-options="iconCls:'editIcon', plain:true,onClick:fn_edit" style="">修改</a>
                <a href="#" id="btndelete" class="easyui-linkbutton" data-options="iconCls:'deleteIcon',plain:true,onClick:fn_delete" style="">删除</a>
                <!-- 在上边设置了事件函数 -->
                <a href="#" class="btn-separator"></a>
                <a href="#" id="btnsave" class="easyui-linkbutton" data-options="iconCls:'saveIcon',plain:true,onClick:fn_save" style="">保存</a>
            </div>
        </div>
        <div id='main' class='easyui-panel' data-options="region:'center'" style="padding: 1px 1px 1px 1px;"></div>
        <div id='bottom' class='easyui-panel' data-options="region:'east'" style="padding: 1px 1px 1px 1px;width:400px"></div>
        <script>
            $(function() {
                var pmyGrid1 = {};
                pmyGrid1.id = 'myGrid1';
                pmyGrid1.parent = 'main';
                pmyGrid1.staticsql = "select productid,productname,quantityperunit,unit,";
                pmyGrid1.staticsql += "quantity,unitprice,quantity*unitprice as amount from products";
                pmyGrid1.activesql = pmyGrid1.staticsql;
                pmyGrid1.searchsql = "select ProductID from orderitems";
                pmyGrid1.gridfields = '[@c%c#250,2]商品名称/productname;[@c%c#110,2]规格型号/quantityperunit;[%d#90@c]计量单位/unit;[@c#100]数量/quantity;';
                pmyGrid1.gridfields += '[110]单价/unitprice;[110]金额/amount';
                pmyGrid1.fixedfields = '[@l%c#90]商品编号/productid';
                pmyGrid1.title = false;
                pmyGrid1.menu = 'myMenu1';
                pmyGrid1.checkbox = 'single';
                pmyGrid1.pagesize = 100;
                pmyGrid1.keyfield = 'productid';
                pmyGrid1.rownumbers = true;
                pmyGrid1.collapsible = true;
                pmyGrid1.height = 900;
                pmyGrid1.width = 900;
                pmyGrid1.rowindex = 0;
                //定义grid
                myGrid(pmyGrid1);
                //初始化，显示第一页记录
                myLoadGridData(pmyGrid1, 1);
                //myGrid1定义结束
                $('#bottom').panel({
                    title: '订单明细',
                    iconCls: 'panelIcon',
                });
                myTextField('productid', 'bottom', '商品编码:', 60, 34, 10, 0, 120, '', '', '');
                myTextField('productname', 'bottom', '商品名称:', 60, 64, 10, 0, 200, '', '', '');
                myTextField('quantityperunit', 'bottom', '规格型号:', 60, 94, 10, 0, 200, '', '', '');
                myTextField('unit', 'bottom', '计量单位:', 60, 124, 10, 0, 120, '', '', '');
                myTextField('quantity', 'bottom', '数量:', 60, 154, 10, 0, 120, '', '', '');
                myTextField('unitprice', 'bottom', '单价:', 60, 184, 10, 0, 120, '', '', '');
                myTextField('amount', 'bottom', '金额:', 60, 214, 10, 0, 120, '', '', '');
                //定义关键字下拉框和查询文本输入框
                var tmp = ''; ////从网格中提取列标题作为下拉框选项
                for (var i = 0; i < pmyGrid1.columns.length; i++) {
                    if (tmp != '') tmp += ';';
                    tmp += pmyGrid1.columns[i].title;
                }
                $('#orderid').textbox({
                    buttonIcon: 'icon-filter',
                    onClickButton: function(e) {
                        wheresql = fnGenWhereSql('filter');
                        var togesql = pmyGrid1.columns[0].field + " in (" + pmyGrid1.searchsql + " ";
                        if (wheresql != '') pmyGrid1.activesql = 'select * from (' + pmyGrid1.staticsql + ') as p where ' + togesql + wheresql + ")";
                        else pmyGrid1.activesql = pmyGrid1.staticsql;
                        //console.log(pmyGrid1.activesql);
                        var opts = $("#myGrid1").datagrid('getPager').data("pagination").options;
                        opts.pageNumber = 1;
                        pmyGrid1.rowindex = 0;
                        myLoadGridData(pmyGrid1, 1);
                        var s = "select a.customerid,CustomerName from orders a join Customers b on a.CustomerID=b.CustomerID " + wheresql;
                        t = myRunSelectSql('jqdemos', s);
                        console.log($(t));
                        $('#customername').textbox("setValue", t[0].customername);
                        $('#customerid').textbox("setValue", t[0].customerid);
                    }
                });

                function fnGenWhereSql(action) {
                    var xtext = $('#orderid').textbox("getValue");
                    var wheresql = '';
                    //wheresql+=pmyGrid1.columns[0].field+" in ("+pmyGrid1.searchsql+" ";
                    wheresql += "where orderid='" + xtext + "'";
                    return wheresql;
                }
                //---------------------
            }); //endofjquery
            var isAdd = false; //创建一个变量，表示现在是否要新增一行。

            function fn_add() {
                $("#productid").textbox("setValue", '');
                $("#productname").textbox("setValue", '');
                $("#quantityperunit").textbox("setValue", '');
                $("#unit").textbox("setValue", '');
                $("#quantity").textbox("setValue", '');
                $("#unitprice").textbox("setValue", '');
                $("#amount").textbox("setValue", '');
                isAdd = true; //点击了增加所以将isAdd变量值设置为真。
            }

            function fn_edit() {
                isAdd = false; //点击了编辑所以将isAdd变量值设置为假。
                var row = $('#myGrid1').datagrid('getSelected');
                console.log(row);
                $("#productid").textbox("setValue", row.productid);
                $("#productname").textbox("setValue", row.productname);
                $("#quantityperunit").textbox("setValue", row.quantityperunit);
                $("#unit").textbox("setValue", row.unit);
                $("#quantity").textbox("setValue", row.quantity);
                $("#unitprice").textbox("setValue", row.unitprice);
                $("#amount").textbox("setValue", row.quantity * row.unitprice);
            }

            function fn_save() {
                if (isAdd) {
                    var insql = "insert into Products (ProductID,ProductName) values ('" + $("#productid").textbox('getValue') + "',' ')"
                    myRunUpdateSql('jqdemos', insql);
                    //如果要新增就先新插入一行。之后再用本来的update语句输入内容。
                }
                var sql = "update products set ";
                sql += "productname='" + $("#productname").textbox('getValue') + "',";
                sql += "quantityperunit='" + $("#quantityperunit").textbox('getValue') + "',";
                sql += "unit='" + $("#unit").textbox('getValue') + "',";
                sql += "quantity='" + $("#quantity").textbox('getValue') + "',";
                sql += "unitprice='" + $("#unitprice").textbox('getValue') + "'";
                sql += " where productid='" + $("#productid").textbox('getValue') + "'";
                var result = myRunUpdateSql('jqdemos', sql);
                if (result.error == '') {
                    fnRefresh();
                }
                isAdd = false; //将变量改回假。
            }

            function fn_delete() { //点击删除。
                var row = $('#myGrid1').datagrid('getSelected'); //获取当前行内容。
                var desql = "delete from Products where ProductID=" + row.productid; //在数据库中删除这行。
                var result = myRunUpdateSql('jqdemos', desql);
                if (result.error == '') {
                    fnRefresh(); //如果删除成功就刷新数据网格。
                }

            }

            function fnRefresh() { //刷新记录
                var pmyGrid1 = {};
                pmyGrid1.id = 'myGrid1';
                pmyGrid1.parent = 'main';
                pmyGrid1.staticsql = "select productid,productname,quantityperunit,unit,";
                pmyGrid1.staticsql += "quantity,unitprice,quantity*unitprice as amount from products";
                pmyGrid1.activesql = pmyGrid1.staticsql;
                pmyGrid1.searchsql = "select ProductID from orderitems";
                pmyGrid1.gridfields = '[@c%c#250,2]商品名称/productname;[@c%c#110,2]规格型号/quantityperunit;[%d#90@c]计量单位/unit;[@c#100]数量/quantity;';
                pmyGrid1.gridfields += '[110]单价/unitprice;[110]金额/amount';
                pmyGrid1.fixedfields = '[@l%c#90]商品编号/productid';
                pmyGrid1.title = false;
                pmyGrid1.menu = 'myMenu1';
                pmyGrid1.checkbox = 'single';
                pmyGrid1.pagesize = 10;
                pmyGrid1.keyfield = 'productid';
                pmyGrid1.rownumbers = true;
                pmyGrid1.collapsible = true;
                pmyGrid1.height = 400;
                pmyGrid1.width = 0;
                pmyGrid1.rowindex = 0;
                //定义grid
                myGrid(pmyGrid1);
                //初始化，显示第一页记录
                myLoadGridData(pmyGrid1, 1);
            }

            function myGridEvents(id,e){
        		e=e.toLowerCase();
        		if(e=='onselect')
        			{
        				var row = $('#myGrid1').datagrid('getSelected');
        				$("#productid").textbox("setValue",row.productid);
        				$("#productname").textbox("setValue",row.productname);
        				$("#quantityperunit").textbox("setValue",row.quantityperunit);
        				$("#unit").textbox("setValue",row.unit);
        				$("#quantity").textbox("setValue",row.quantity);
        				$("#unitprice").textbox("setValue",row.unitprice);
        				$("#amount").textbox("setValue",row.quantity*row.unitprice);
        			}
        	}
        </script>
    </body>

    </html>