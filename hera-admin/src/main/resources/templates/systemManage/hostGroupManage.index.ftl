<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/html" xmlns="http://www.w3.org/1999/html">
<head>
    <title>机器组管理</title>
    <base href="${request.contextPath}" id="contextPath">
  	<#import "/common/common.macro.ftl" as netCommon>
	<@netCommon.commonStyle />
    <link rel="stylesheet" href="${request.contextPath}/plugins/ztree/zTreeStyle.css">

    <style>

        h3, table {
            margin: 20px;
        }

        .error{
            color: red;
        }
        #toolbar {
            margin-left: 20px;
        }
    </style>
</head>


<body class="hold-transition skin-green sidebar-mini">

<div class="wrapper">
    <!-- header -->
	<@netCommon.commonHeader />
    <!-- left -->
	<@netCommon.commonLeft "hostgroup"/>
    <div class="content-wrapper">
        <h3>机器组管理</h3>
        <div id="toolbar">
            <button class="btn btn-default" id="addHostGroup">添加</button>
        </div>
        <table id="selectTable"
               data-url="${request.contextPath}/hostGroup/list" class="table" data-pagination="true" data-toggle="table"
               data-search="true" data-toolbar="#toolbar"
               data-show-refresh="true">
            <thead>
            <tr>
                <th data-field="name" data-title="名称"></th>
                <th data-field="effective" data-title="状态"></th>
                <th data-field="description" data-title="描述"></th>
                <th data-title="操作" data-formatter="operator"></th>
            </tr>
            </thead>
        </table>
    </div>
</div>

<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="myModalLabel">模态框（Modal）标题</h4>
            </div>
            <div class="modal-body">
                <form action="" method="post" role="form" id="hostGroupTable">
                    <fieldset>
                        <div class="form-group" style="display: none">
                            <label for="name">id</label>
                            <input type="text" class="form-control" name="id" id="id" placeholder="请输入名称">
                        </div>
                        <div class="form-group">
                            <label for="name">名称</label>
                            <input type="text" class="form-control required" name="name" id="name" placeholder="请输入名称">
                        </div>
                        <div class="form-group">
                            <label for="effective">状态</label>
                            <input type="text" class="form-control number required" name="effective" id="effective" placeholder="状态">
                        </div>
                        <div class="form-group">
                            <label for="description">描述</label>
                            <input type="text" class="form-control" name="description" id=description" placeholder="描述">
                        </div>
                    </fieldset>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="submitFormat">提交更改</button>
            </div>
        </div><!-- /.modal-content -->
    </div><!-- /.modal -->
</div>

<@netCommon.commonScript />
<script src="${request.contextPath}/plugins/jquery/jquery.validate.min.js"></script>
<script src="${request.contextPath}/plugins/jquery/messages_zh.js"></script>
<script>
    var contextPath = $('#contextPath').attr("href");
    var form = $("#hostGroupTable");
    var groupCache = {};
    $(function () {
        initEvent();
    });

    function operator(val, row) {
        groupCache[row.id] = row;
        return '<a href="javascript:edit(' + row.id + ')"><i class="glyphicon glyphicon-edit" ></i></a>&nbsp;&nbsp;' +
                '<a href="javascript:del(' + row.id + ')"><i class="glyphicon glyphicon-remove" ></i></a>';
    }

    function edit(id) {
        $('#myModalLabel').text("编辑机器组");
        form[0].reset();
        formDataLoad("hostGroupTable", groupCache[id]);
        $('#myModal').modal('show');
    }
    function del(id) {
        if (confirm("确认删除 " + groupCache[id].name + "?" )) {
            $.ajax({
                url: contextPath + '/hostGroup/del',
                type: "post",
                data: {
                    id: id
                },
                success: function (data) {
                    alert(data.msg);
                    $('#selectTable').bootstrapTable('refresh');
                }
            })
        }
    }

    function initEvent() {
        form.validate();
        $('#addHostGroup').on('click', function () {
            $('#myModalLabel').text("添加机器组");
            form[0].reset();
            $('#myModal').modal('show')
        });

        $('#submitFormat').on('click', function () {
            $.ajax({
                url: contextPath + '/hostGroup/saveOrUpdate',
                type: "post",
                data: form.serialize(),
                success: function (data) {
                    alert(data.msg);
                    $('#myModal').modal('hide')
                    $('#selectTable').bootstrapTable('refresh');

                }
            })
        });
    }

</script>
</body>

</html>


