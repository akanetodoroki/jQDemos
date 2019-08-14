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
    <div class="easyui-panel" title="用户注册" style="width:300px">
        <div style="padding:10px 10px 10px 30px">
        <form id="form1" method="post">
            <table cellpadding="5">
                <tr>
                    <td>姓名:</td>
                    <td><input class="easyui-textbox" type="text" name="name" data-options="required:true"></input></td>
                </tr>
                <tr>
                    <td>Email:</td>
                    <td><input class="easyui-textbox" type="text" name="email" data-options="required:true,validType:'email'"></input></td>
                </tr>
                <tr>
                    <td>课程:</td>
                    <td><input class="easyui-textbox" type="text" name="subject" data-options="required:true"></input></td>
                </tr>
                <tr>
                    <td>备注:</td>
                    <td><input class="easyui-textbox" name="message" data-options="multiline:true" style="height:60px"></input></td>
                </tr>
                <tr>
                    <td>语言:</td>
                    <td>
                        <select class="easyui-combobox" name="language">
	                        <option value="cn">中文</option>
	                        <option value="uk">英文</option>
	                        <option value="jp">日文</option>
                        </select>
                    </td>
                </tr>
            </table>
        </form>
        <div style="text-align:center;padding:5px">
            <a href="javascript:void(0)" class="easyui-linkbutton" style="width:60px;" onclick="submitForm()">提交</a>
            <a href="javascript:void(0)" class="easyui-linkbutton" style="width:60px;" onclick="clearForm()">清空</a>
        </div>
        </div>
    </div>
    <script>
        function submitForm(){
            $('#form1').form('submit');  //jquery语句
        }
        function clearForm(){
            $('#form1').form('clear');  //jquery语句
        }
    </script>
</body>
</html>