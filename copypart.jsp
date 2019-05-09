<%@ page contentType="text/html; charset=UTF-8" language="java"
         import="java.sql.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="false" deferredSyntaxAllowedAsLiteral="true" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://"
            + request.getServerName() + ":" + request.getServerPort()
            + path + "/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta http-equiv="Pragma" content="no-cache"/>
    <meta http-equiv="Cache-Control" content="no-cache"/>
    <meta http-equiv="Expires" content="0"/>
    <link href="<c:url value='/css/style.css'/>" rel="stylesheet"
          type="text/css"/>
    <link href="<c:url value='/css/base.css'/>" rel="stylesheet"
          type="text/css"/>
    <link href="<c:url value='/css/easyui.css'/>" rel="stylesheet"
          type="text/css"/>
    <link href="<c:url value='/css/jquery.steps.css'/>" rel="stylesheet"
          type="text/css"/>
    <link href="<c:url value='/css/jquery.dataTables.min.css'/>"
          rel="stylesheet" type="text/css"/>
    <!--[if lt IE 9]>
    <script src="<c:url value='/js/html5.js'/>"></script>
    <![endif]-->
    <script src="<c:url value='/js/jquery.js'/>"></script>
    <script src="<c:url value='/js/jquery.easyui.min_1.3.5.js'/>"></script>
    <script src="<c:url value='/js/treegrid-dnd.js'/>"></script>
    <script src="<c:url value='/js/jquery.ui.widget.js'/>"></script>
    <script src="<c:url value='/js/jquery.iframe-transport.js'/>"></script>
    <script src="<c:url value='/js/jquery.fileupload.js'/>"></script>
    <script src="<c:url value='/js/jquery.dataTables.min.js'/>"></script>
    <script src="<c:url value='/js/jquery.validate.js'/>"></script>
    <script src="<c:url value='/js/messages_zh.js'/>"></script>


    <title>信息录入</title>
    <style>
        .hide {
            display: none;
        }

        .query_hint {
            border: 5px solid #939393;
            width: 250px;
            height: 50px;
            line-height: 55px;
            padding: 0 20px;
            position: absolute;
            left: 50%;
            margin-left: -140px;
            top: 50%;
            margin-top: -40px;
            font-size: 15px;
            color: #333;
            font-weight: bold;
            text-align: center;
            background-color: #f9f9f9;
        }
        /*遮挡层*/
        #barrier{
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: black;
            opacity: 0.5;
            z-index: 102;
            display: none;
        }
        #barrier img{
            left: 50%;
            /* z-index: 114; */
            position: absolute;
            top: 50%;
            width: 236px;
            margin-top: -88px;
            margin-left: -118px;
        }

        /* .query_hint img{position:relative;top:8px;left:-8px;} */
    </style>
    <script>

        $(function () {

            $('#btnQuery').on('click', function () {
                $('#btnAddMenu').addClass("hide");
                var projectid = $("select[name='projectname']").val();
                if (projectid == -1) {
                    alert("请选择有效值！");
                    return false;
                }
                $("input[name='projectselectname']").val(projectid);
                $.ajax({
                    cache: true,
                    type: "POST",
                    url: "../menu/menujson",
                    data: {
                        "projectid": projectid
                    },
                    async: true,
                    beforeSend: function () {
                        show_query_hint("query_hint");
                    },
                    success: function (data) {
                        queryHintCallback("query_hint");
                        var json = JSON.parse(data.replace(/parentId/g,
                                "_parentId"));
                        $('#tt').treegrid("loadData", json).treegrid(
                                'collapseAll');
                        if (json.rows.length == 0)
                            $('#btnAddMenu').removeClass("hide");
                    }
                });

            });
            $('#btnQuery1').on('click', function () {
                $('#btnAddMenu').addClass("hide");
                var projectid1 = $("select[name='projectname1']").val();
                if (projectid1 == -1) {
                    alert("请选择有效值！");
                    return false;
                }
                $("input[name='projectselectname1']").val(projectid1);
                $.ajax({
                    cache: true,
                    type: "POST",
                    url: "../menu/menujson",
                    data: {
                        "projectid": projectid1
                    },
                    async: true,
                    beforeSend: function () {
                        show_query_hint("query_hint");
                    },
                    success: function (data) {
                        queryHintCallback("query_hint");
                        var json = JSON.parse(data.replace(/parentId/g,
                                "_parentId"));
                        $('#tt1').treegrid("loadData", json).treegrid(
                                'collapseAll');
                        if (json.rows.length == 0)
                            $('#btnAddMenu').removeClass("hide");
                    }
                });

            });
            $('#btnQuery3').on('click',function () {
                $('#barrier').show();
                var devTypeNodes = $('#tt').treegrid("getSelections");

                //初始化一个数组
                var devTypeArr = new Array();
                for(var i=0;i < devTypeNodes.length;i++){
                    //用数组接收勾选的数据
                    devTypeArr[i] = devTypeNodes[i].id;
                }
                console.log(devTypeArr);

                var devTypeNodes1 = $('#tt1').treegrid("getSelections");

                //初始化一个数组
                var devTypeArr1 = new Array();
                for(var i=0;i < devTypeNodes1.length;i++){
                    //用数组接收勾选的数据
                    devTypeArr1[i] = devTypeNodes1[i].id;
                }
                console.log(devTypeArr1);

                $.ajax({
                    type:'POST',
                    url:'../menuPart/copyPart',
                    data:{
                        menuId:devTypeArr,
                        targetId:devTypeArr1
                    },
                    success:function (data) {
                        $('#barrier').hide();
                        if(data.code == 200){
                            alert(data.msg);
                            $('#tt').treegrid('unselectAll');
                            var projectid1 = $("select[name='projectname1']").val();
                            $.ajax({
                                cache: true,
                                type: "POST",
                                url: "../menu/menujson",
                                data: {
                                    "projectid": projectid1
                                },
                                async: true,
                                beforeSend: function () {
                                    show_query_hint("query_hint");
                                },
                                success: function (data) {
                                    queryHintCallback("query_hint");
                                    var json = JSON.parse(data.replace(/parentId/g,
                                            "_parentId"));
                                    $('#tt1').treegrid("loadData", json).treegrid(
                                            'collapseAll');
                                    if (json.rows.length == 0)
                                        $('#btnAddMenu').removeClass("hide");
                                }
                            });
                        }

                    }
                });
            });
        });




        function onbeforeExpand(row) {
            if (row.children.length == 0) {
                var projectid = $("input[name='projectselectname']").val();
                //动态设置展开查询的url
                $.ajax({
                    cache: true,
                    type: "POST",
                    url: "../menu/menujson",
                    data: {
                        "projectid": projectid,
                        "parentid": row.id
                    },
                    async: false,
                    beforeSend: function () {
                        show_query_hint("query_hint");
                    },
                    success: function (data) {
                        queryHintCallback("query_hint");
                        var json = JSON.parse(data
                                .replace(/parentId/g, "_parentId"));
                        $('#tt').treegrid("append", {
                            parent: row.id,
                            data: json,
                        });
                    }
                });
            }
            return true;
        }

        function onbeforeExpand1(row) {
            if (row.children.length == 0) {
                var projectid1 = $("input[name='projectselectname1']").val();
                //动态设置展开查询的url
                $.ajax({
                    cache: true,
                    type: "POST",
                    url: "../menu/menujson",
                    data: {
                        "projectid": projectid1,
                        "parentid": row.id
                    },
                    async: false,
                    beforeSend: function () {
                        show_query_hint("query_hint");
                    },
                    success: function (data) {
                        queryHintCallback("query_hint");
                        var json = JSON.parse(data
                                .replace(/parentId/g, "_parentId"));
                        $('#tt1').treegrid("append", {
                            parent: row.id,
                            data: json,

                        });
                    }
                });
            }
            return true;
        }
        /**
         * @description  * 显示查询等待层
         * @param query_hint
         */
        function show_query_hint(query_hint) {
            var query_hint = document.getElementById(query_hint);
            query_hint.style.display = "block";
        }

        /**
         * @description 查询结果回调函数
         * @param query_hint 要隐藏的提示层id
         */
        function queryHintCallback(query_hint) {
            var query_hint = document.getElementById(query_hint);
            query_hint.style.display = "none";
        }


    </script>
</head>
<body>

<section class="rt_wrap content mCustomScrollbar">
    <h2 class='h2separate'></h2>
    <div class='place'>
        <span>位置：</span>
        <ul class='placeul'>
            <li><a href="#" class='active'>菜单管理</a></li>
            <li><a href="#">菜单复制</a></li>
        </ul>
    </div>
    <h1></h1>
    <div class="rt_content">
        <%--  <h1>${project.name }</h1> --%>
        <section>
            <input type="hidden" name="projectselectname"/>
            <input type="hidden" name="projectselectname1"/>
            <span class="item_name" style="width: 120px;">产品名称：</span>
            <select name="projectname" class="select" style="width: 210px;">
                <option value="-1">==源==</option>
                <c:forEach items="${projects }" var="item">
                    <option value="${item.id }">${item.name }</option>
                </c:forEach>
            </select>
            <button class="link_btn" id="btnQuery">查询</button>

            <select name="projectname1" class="select" style="width: 210px;margin-left: 305px;">
                <option value="-1">==目标==</option>
                <c:forEach items="${projects }" var="item">
                    <option value="${item.id }">${item.name }</option>
                </c:forEach>
            </select>
            <button class="link_btn" id="btnQuery1">查询</button>
            <button class="link_btn" id="btnQuery3">复制</button>
<div style="    position: absolute;
    top: 154px;
    left: 0;">
    <table id="tt" class="easyui-treegrid" style="display:inline-block;height:400px;width: 600px;margin-right: 50px"
           data-options="
				idField: 'id',
				treeField: 'chinese',
				collapsible: false,
				fitColumns: true,
				 striped : false,

                singleSelect : false,
                checkOnSelect : true,
                selectOnCheck : true,

                columns:[[ {
                    title : 'id',
                    field : 'id',
                    checkbox : true,
                    align : 'center',
                    width : 60
                },{
                    field : 'chinese',
                    title : '菜单名称',
                    align : 'left',
                    width : 120
                } ] ],

				onBeforeExpand:onbeforeExpand,
				onLoadSuccess: function(row){
					$(this).treegrid('enableDnd', row?row.id:null);


				},
				onBeforeDrop(targetRow,sourceRow,point){
					if(typeof(targetRow._parentId) == 'undefined' && (point == 'top' || point == 'bottom'))
						return false;
					if(confirm('确认调整菜单顺序？')){
				    	drop(targetRow.id,sourceRow.id,point)
				    }else{
				    	return false;
				    }
				}
				">
        <thead>
        <tr>
            <th data-options="field:'chinese'" width="300">菜单名称</th>
        </tr>
        </thead>
    </table>
</div>

<div style="    position: absolute;
    top: 154px;
    left: 650px;">
    <table id="tt1" class="easyui-treegrid" style="display:inline-block;height:400px;width: 600px;margin-right: 50px"
           data-options="
				idField: 'id',
				treeField: 'chinese',
				collapsible: false,
				fitColumns: true,
				singleSelect : false,
                checkOnSelect : true,
                selectOnCheck : true,
                 columns:[[ {
                    title : 'id',
                    field : 'id',
                    checkbox : true,
                    align : 'center',
                    width : 60
                },{
                    field : 'chinese',
                    title : '菜单名称',
                    align : 'left',
                    width : 120
                } ] ],
				onBeforeExpand:onbeforeExpand1,
				onLoadSuccess: function(row){
					$(this).treegrid('enableDnd', row?row.id:null);
				},
				onBeforeDrop(targetRow,sourceRow,point){
					if(typeof(targetRow._parentId) == 'undefined' && (point == 'top' || point == 'bottom'))
						return false;
					if(confirm('确认调整菜单顺序？')){
				    	drop(targetRow.id,sourceRow.id,point)
				    }else{
				    	return false;
				    }
				}
				">
        <thead>
        <tr>
            <th data-options="field:'chinese'" width="300">菜单名称</th>
        </tr>
        </thead>
    </table>
</div>

        </section>

        <!-- 诊断资源选择板块 -->
        <section id="query_hint" class="query_hint"
                 style="display: none; Z-index:1;"><img
                src="../images/loading.gif"/>正在查询，请稍等...
        </section>
    </div>
</section>

<#--遮挡层-->
    <div id="barrier">
        <img src="http://blog-10039692.file.myqcloud.com/1508382587648_934_1508382611328.gif" alt="">
    </div>
</body>
</html>
