<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Backstage.aspx.cs" Inherits="_Backstage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link href="css/bootstrap.min.css" rel="stylesheet" />
    <link href="css/bootstrap-theme.min.css" rel="stylesheet" />
    <link href="css/dashboard.css" rel="stylesheet" />
    <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
    <script src="js/jquery.min.js"></script>
    <!-- Include all compiled plugins (below), or include individual files as needed -->
    <script src="js/bootstrap.min.js"></script>
    <script src="js/OpenModal.js"></script>
    <script>
        window.onfocus = GetFocus;
        window.onclick = GetFocus;

        function ShowHidden(sid, ev) {
            ev = ev || window.event;
            var target = ev.target || ev.srcElement;
            var oDiv = document.getElementById("div" + sid);
            oDiv.style.display = oDiv.style.display == "none" ? "block" : "none";
            target.innerHTML = oDiv.style.display == "none" ? "展开列表" : "隐藏列表";
            $.ajax({
                url: 'BackstageDataLoad.ashx',
                type: 'get',
                data: {
                    type: 'GridRow',
                    row: sid
                },
                dataType: 'html',
                timeout: 10000
            })
        }

        function GetFocus() {
            if (typeof (window.childWindow) != "undefined") {//如果子窗口存在，将焦点转到子窗口
                window.childWindow.focus();
            }
        }

        function ShowNew(sid, ev) {
            ev = ev || window.event;
            var target = ev.target || ev.srcElement;
            var oDiv = document.getElementById("div" + sid);

            var gv = document.getElementById("<%=CategoryGridView.ClientID %>");
            var rowIndex = 1 + 2 * (sid - 1);
            var category = gv.rows[rowIndex].cells[1].innerText;

            var url = "AddBook.aspx";
            var winName = "child";
            var awidth = screen.availWidth / 6 * 2;       //窗口宽度,需要设置  
            var aheight = screen.availHeight / 5 * 2;         //窗口高度,需要设置   
            var atop = (screen.availHeight - aheight) / 2;  //窗口顶部位置,一般不需要改  
            var aleft = (screen.availWidth - awidth) / 2;   //窗口放中央,一般不需要改  
            var param0 = "scrollbars=0,status=0,menubar=0,resizable=no,location=0"; //新窗口的参数  
            var params = "top=" + atop + ",left=" + aleft + ",width=" + awidth + ",height=" + aheight + "," + param0;
            EV_modeAlert();
            window.childWindow = window.open(url, winName, params); //打开新窗口  
            window.childWindow.focus(); //新窗口获得焦点   
            $.ajax({
                url: 'BackstageDataLoad.ashx',
                type: 'get',
                data: {
                    type: 'btnGridRowAdd',
                    categoryName: category
                },
                dataType: 'html',
                timeout: 10000
            })
        }

        function refresh() {
            this.location = this.location;
        }
    </script>
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <nav class="navbar navbar-inverse navbar-fixed-top" role="navigation">
            <div class="container-fluid">
                <div class="navbar-header">
                    <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
                        <span class="sr-only">Toggle navigation</span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                    </button>
                    <a class="navbar-brand" href="#">后台管理系统</a>
                </div>
            </div>
        </nav>

        <div class="container-fluid">
            <div class="row">
                <div class="col-sm-3 col-md-2 sidebar">
                    <ul class="nav nav-sidebar">
                        <li class="active">
                            <asp:LinkButton ID="btn" runat="server" OnClick="btn_Click">菜单栏</asp:LinkButton></li>
                        <li>
                            <asp:LinkButton ID="CategoryManager" runat="server" OnClick="CategoryManager_Click">分类管理</asp:LinkButton></li>
                        <li>
                            <asp:LinkButton ID="UserManager" runat="server" OnClick="UserManager_Click">用户管理</asp:LinkButton></li>
                        <li>
                            <asp:LinkButton ID="OrderManager" runat="server" OnClick="OrderManager_Click">订单管理</asp:LinkButton></li>
                        <li>
                            <asp:LinkButton ID="Quit" runat="server" OnClick="Quit_Click">退出</asp:LinkButton></li>
                    </ul>
                </div>

                <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
                    <h1 class="page-header">后台管理系统</h1>
                    <div class="table-responsive">

                        <asp:Panel ID="indexPanel" runat="server">
                            <div class="panel panel-default">
                                <div class="panel-heading">
                                    <h3 class="panel-title">首页</h3>
                                </div>
                                <div class="panel-body">
                                    <div class="col-xs-6 col-md-2">用户名：<asp:Label class="label label-default" ID="txtUsername" runat="server"></asp:Label></div>
                                </div>
                            </div>
                        </asp:Panel>

                        <asp:ScriptManager ID="ScriptMgr1" runat="server" />
                        <asp:UpdatePanel ID="CategoryPanel" UpdateMode="Conditional" ChildrenAsTriggers="false" runat="server">
                            <ContentTemplate>
                                <div class="panel panel-default">
                                    <div class="panel-heading">
                                        <h3 style="padding: 6px; float: left" class="panel-title">分类信息</h3>
                                        <asp:Button class="btn btn-sm btn-primary" ID="btnRefreshCategory" runat="server" OnClick="btnRefreshCategory_Click" Text="刷新" />
                                    </div>
                                    <div class="panel-body" style="width: auto; height: auto">
                                        <asp:GridView ID="CategoryGridView" runat="server" class="table table-striped"
                                            AutoGenerateColumns="False" OnRowDataBound="CategoryGridView_RowCommand" AllowPaging="true" PageSize="10"
                                            PagerSettings-Mode="Numeric" PagerStyle-HorizontalAlign="Center"
                                            OnPageIndexChanging="CategoryGridView_PageIndexChanging">
                                            <Columns>
                                                <asp:BoundField DataField="Id" HeaderText="ID" ReadOnly="True" />
                                                <asp:BoundField DataField="CategoryName" HeaderText="分类名" />
                                                <asp:TemplateField>
                                                    <ItemTemplate>
                                                        <!---点击用于列表展开，执行JS函数--->
                                                        <span id="btnShowHidden<%#Eval("ID") %>" onclick="ShowHidden('<%#Eval("ID") %>',event)" class="btn btn-primary">展开列表</span>
                                                        <tr>
                                                            <td colspan="100%">
                                                                <div id="div<%#Eval("ID") %>" style="display: none;">
                                                                    <div style="float: left; font-size: small">
                                                                        └
                                                                    </div>
                                                                    <div class="panel-body">
                                                                        <asp:UpdatePanel ID="BookPanel" runat="server">
                                                                            <ContentTemplate>
                                                                                <!---绑定内层Gridview--->
                                                                                <asp:GridView ID="BookGridView" class="table table-striped" runat="server"
                                                                                    AutoGenerateColumns="false" AllowPaging="true" PageSize="3"
                                                                                    OnRowEditing="BookGridView_RowEditing"
                                                                                    OnRowDeleting="BookGridView_RowDeleting"
                                                                                    OnRowCancelingEdit="BookGridView_RowCancelingEdit"
                                                                                    OnRowUpdating="BookGridView_RowUpdating"
                                                                                    OnPageIndexChanging="BookGridView_PageIndexChanging">
                                                                                    <Columns>
                                                                                        <asp:BoundField DataField="Id" HeaderText="ID" ReadOnly="true" />
                                                                                        <asp:BoundField DataField="Name" HeaderText="书籍名称" />
                                                                                        <asp:BoundField DataField="Price" HeaderText="销售价格" />
                                                                                        <asp:BoundField DataField="Stock" HeaderText="库存数量" />
                                                                                        <asp:CommandField HeaderText="编辑" ShowEditButton="True" />
                                                                                        <asp:CommandField HeaderText="删除" ShowDeleteButton="True" />
                                                                                    </Columns>
                                                                                    <PagerTemplate>
                                                                                        <table align="center">
                                                                                            <tr>
                                                                                                <td align="center">第<asp:Label ID="lblPageIndex" runat="server" Text='<%# ((GridView)Container.Parent.Parent).PageIndex + 1  %>' />页
                                                                                                    共/<asp:Label ID="lblPageCount" runat="server" Text='<%# ((GridView)Container.Parent.Parent).PageCount  %>' />页
                                                                                                    <asp:LinkButton ID="btnFirst" runat="server" CausesValidation="False" CommandArgument="First" CommandName="Page" Text="首页" />
                                                                                                    <asp:LinkButton ID="btnPrev" runat="server" CausesValidation="False" CommandArgument="Prev" CommandName="Page" Text="上一页" />
                                                                                                    <asp:LinkButton ID="btnNext" runat="server" CausesValidation="False" CommandArgument="Next" CommandName="Page" Text="下一页" />
                                                                                                    <asp:LinkButton ID="btnLast" runat="server" CausesValidation="False" CommandArgument="Last" CommandName="Page" Text="尾页" />
                                                                                                </td>
                                                                                            </tr>
                                                                                        </table>
                                                                                    </PagerTemplate>
                                                                                </asp:GridView>
                                                                                <span style="margin-left: 45%" id="btnShowNew<%#Eval("ID") %>" onclick="ShowNew('<%#Eval("ID") %>', event)" class="btn btn-primary">添加书籍</span>
                                                                            </ContentTemplate>
                                                                        </asp:UpdatePanel>
                                                                    </div>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                            </Columns>
                                            <PagerTemplate>
                                                <table align="center">
                                                    <tr>
                                                        <td align="center">第<asp:Label ID="lblPageIndex" runat="server" Text='<%# ((GridView)Container.Parent.Parent).PageIndex + 1  %>' />页
                                                            共/<asp:Label ID="lblPageCount" runat="server" Text='<%# ((GridView)Container.Parent.Parent).PageCount  %>' />页
                                                            <asp:LinkButton ID="btnFirst" runat="server" CausesValidation="False" CommandArgument="First" CommandName="Page" Text="首页" />
                                                            <asp:LinkButton ID="btnPrev" runat="server" CausesValidation="False" CommandArgument="Prev" CommandName="Page" Text="上一页" />
                                                            <asp:LinkButton ID="btnNext" runat="server" CausesValidation="False" CommandArgument="Next" CommandName="Page" Text="下一页" />
                                                            <asp:LinkButton ID="btnLast" runat="server" CausesValidation="False" CommandArgument="Last" CommandName="Page" Text="尾页" />
                                                        </td>
                                                    </tr>
                                                </table>
                                            </PagerTemplate>
                                        </asp:GridView>
                                    </div>
                                </div>
                            </ContentTemplate>
                            <Triggers>
                                <asp:AsyncPostBackTrigger ControlID="btnRefreshCategory" EventName="Click" />
                            </Triggers>
                        </asp:UpdatePanel>

                        <asp:Panel ID="UserPanel" runat="server">
                            <asp:UpdatePanel ID="updateUserPanel" ChildrenAsTriggers="false" UpdateMode="Conditional" runat="server">
                                <ContentTemplate>
                                    <div class="panel panel-default">
                                        <div class="panel-heading">
                                            <h3 style="padding: 6px; float: left" class="panel-title">用户信息</h3>
                                            <asp:Button class="btn btn-sm btn-primary" ID="refreshUser" runat="server" OnClick="refreshUser_Click" Text="刷新" />
                                        </div>

                                        <div class="panel-body">
                                            <asp:GridView ID="UserGridView" runat="server" class="table table-striped"
                                                AutoGenerateColumns="False">
                                                <Columns>
                                                    <asp:BoundField DataField="Id" HeaderText="ID" />
                                                    <asp:BoundField DataField="UserName" HeaderText="用户名" ReadOnly="True" />
                                                    <asp:BoundField DataField="Telephone" HeaderText="联系电话" />
                                                </Columns>
                                            </asp:GridView>
                                        </div>
                                    </div>
                                </ContentTemplate>
                                <Triggers>
                                    <asp:AsyncPostBackTrigger ControlID="refreshUser" EventName="Click" />
                                </Triggers>
                            </asp:UpdatePanel>
                        </asp:Panel>

                        <asp:Panel ID="OrderPanel" runat="server">
                            <asp:UpdatePanel ID="UpdateOrderPanel" runat="server">
                                <ContentTemplate>
                                    <div class="panel panel-default">
                                        <div class="panel-heading">
                                            <h3 style="padding: 6px; float: left" class="panel-title">订单信息</h3>
                                            <asp:Button class="btn btn-sm btn-primary" ID="refreshOrder" runat="server" OnClick="refreshOrder_Click" Text="刷新" />
                                        </div>

                                        <div class="panel-body">
                                            <asp:GridView ID="OrderGridView" runat="server" class="table table-striped"
                                                AutoGenerateColumns="False"
                                                AllowPaging="true" PageSize="10"
                                                PagerSettings-Mode="Numeric" PagerStyle-HorizontalAlign="Center"
                                                OnPageIndexChanging="OrderGridView_PageIndexChanging"
                                                OnRowCommand="OrderGridView_RowCommand"
                                                OnRowDataBound="OrderGridView_RowDataBound">
                                                <Columns>
                                                    <asp:BoundField DataField="Id" HeaderText="ID" />
                                                    <asp:BoundField DataField="CurState" HeaderText="状态" />
                                                    <asp:BoundField DataField="Cost" HeaderText="金额" />
                                                    <asp:BoundField DataField="UserName" HeaderText="买家名称" ReadOnly="True" />
                                                    <asp:BoundField DataField="Time" HeaderText="下单时间" />
                                                    <asp:BoundField DataField="Address" HeaderText="收货地址" />
                                                    <asp:BoundField DataField="Receiver" HeaderText="收货人" />
                                                    <asp:BoundField DataField="Phone" HeaderText="联系电话" />
                                                    <asp:TemplateField HeaderText="操作">
                                                        <ItemTemplate>
                                                            <asp:Button ID="sendGoods" CommandName="sendGood" class="btn btn-primary" runat="server" Text="发货" Visible="false" />
                                                            <!---点击用于列表展开，执行JS函数--->
                                                            <span id="btnShowHidden<%#Eval("ID") %>" onclick="ShowHidden('<%#Eval("ID") %>',event)" class="btn btn-primary">展开列表</span>
                                                            <tr>
                                                                <td colspan="100%">
                                                                    <div id="div<%#Eval("ID") %>" style="display: none;">
                                                                        <div style="float: left; font-size: small">
                                                                            └
                                                                        </div>
                                                                        <div class="panel-body">
                                                                            <asp:UpdatePanel ID="BookPanel" runat="server">
                                                                                <ContentTemplate>
                                                                                    <!---绑定内层Gridview--->
                                                                                    <asp:GridView ID="BookDetailGridView" class="table table-striped" runat="server"
                                                                                        AutoGenerateColumns="false" AllowPaging="true" PageSize="3"
                                                                                        OnPageIndexChanging="BookDetailGridView_PageIndexChanging">
                                                                                        <Columns>
                                                                                            <asp:BoundField DataField="Id" HeaderText="ID" ReadOnly="true" />
                                                                                            <asp:BoundField DataField="Name" HeaderText="书籍名称" />
                                                                                            <asp:BoundField DataField="Amount" HeaderText="数量" />
                                                                                            <asp:BoundField DataField="Stock" HeaderText="库存数量" />
                                                                                        </Columns>
                                                                                        <PagerTemplate>
                                                                                            <table align="center">
                                                                                                <tr>
                                                                                                    <td align="center">第<asp:Label ID="lblPageIndex" runat="server" Text='<%# ((GridView)Container.Parent.Parent).PageIndex + 1  %>' />页
                                                                                                    共/<asp:Label ID="lblPageCount" runat="server" Text='<%# ((GridView)Container.Parent.Parent).PageCount  %>' />页
                                                                                                    <asp:LinkButton ID="btnFirst" runat="server" CausesValidation="False" CommandArgument="First" CommandName="Page" Text="首页" />
                                                                                                        <asp:LinkButton ID="btnPrev" runat="server" CausesValidation="False" CommandArgument="Prev" CommandName="Page" Text="上一页" />
                                                                                                        <asp:LinkButton ID="btnNext" runat="server" CausesValidation="False" CommandArgument="Next" CommandName="Page" Text="下一页" />
                                                                                                        <asp:LinkButton ID="btnLast" runat="server" CausesValidation="False" CommandArgument="Last" CommandName="Page" Text="尾页" />
                                                                                                    </td>
                                                                                                </tr>
                                                                                            </table>
                                                                                        </PagerTemplate>
                                                                                    </asp:GridView>
                                                                                </ContentTemplate>
                                                                            </asp:UpdatePanel>
                                                                        </div>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                </Columns>
                                                <PagerTemplate>
                                                    <table align="center">
                                                        <tr>
                                                            <td align="center">第<asp:Label ID="lblPageIndex" runat="server" Text='<%# ((GridView)Container.Parent.Parent).PageIndex + 1  %>' />页
                                                                共/<asp:Label ID="lblPageCount" runat="server" Text='<%# ((GridView)Container.Parent.Parent).PageCount  %>' />页
                                                                <asp:LinkButton ID="btnFirst" runat="server" CausesValidation="False" CommandArgument="First" CommandName="Page" Text="首页" />
                                                                <asp:LinkButton ID="btnPrev" runat="server" CausesValidation="False" CommandArgument="Prev" CommandName="Page" Text="上一页" />
                                                                <asp:LinkButton ID="btnNext" runat="server" CausesValidation="False" CommandArgument="Next" CommandName="Page" Text="下一页" />
                                                                <asp:LinkButton ID="btnLast" runat="server" CausesValidation="False" CommandArgument="Last" CommandName="Page" Text="尾页" />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </PagerTemplate>
                                            </asp:GridView>
                                        </div>
                                    </div>
                                </ContentTemplate>
                                <Triggers>
                                    <asp:AsyncPostBackTrigger ControlID="refreshOrder" EventName="Click" />
                                </Triggers>
                            </asp:UpdatePanel>
                        </asp:Panel>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
