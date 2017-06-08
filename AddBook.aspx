<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AddBook.aspx.cs" Inherits="AddBook" %>

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
        window.onunload = function () {
            EV_closeAlert();    //窗口关闭时去掉遮罩效果
            window.opener.location.reload(true);
        }
    </script>
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div class="col-md-3">
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title">新增书籍</h3>
                </div>
                <div class="panel-body">
                    <asp:Label ID="lblBookName" runat="server">书籍名称</asp:Label>
                    <asp:TextBox Style="float: right" ID="tbBookName" runat="server"></asp:TextBox>
                    <br />
                    <br />
                    <asp:Label ID="lblPrice" runat="server">价格</asp:Label>
                    <asp:TextBox ID="tbPrice" Style="float: right" runat="server"></asp:TextBox>
                    <br />
                    <br />
                    <asp:Label ID="lblStock" runat="server">库存</asp:Label>
                    <asp:TextBox ID="tbStock" Style="float: right" runat="server"></asp:TextBox>
                    <br />
                    <br />
                    <asp:Label ID="lblAuthor" runat="server">作者</asp:Label>
                    <asp:TextBox ID="tbAuthor" Style="float: right" runat="server"></asp:TextBox>
                    <br />
                    <br />
                    <asp:Label ID="lblPublisher" runat="server">出版社</asp:Label>
                    <asp:TextBox ID="tbPublisher" Style="float: right" runat="server"></asp:TextBox>
                    <br />
                    <br />
                    <asp:Label ID="lblPbTime" runat="server">出版时间</asp:Label>
                    <asp:TextBox ID="tbPbTime" Style="float: right" runat="server"></asp:TextBox>
                    <br />
                    <br />
                    <asp:Label ID="lblBrief" runat="server">简介</asp:Label>
                    <asp:TextBox ID="tbBrief" Style="float: right" runat="server"></asp:TextBox>
                    <br />
                    <br />
                    <asp:Button ID="btnAddBook" Style="margin-left: 45%" runat="server" class="btn btn-sm btn-success" Text="提交" OnClick="btnAddBook_Click" />
                    <br />
                    <br />
                    <div class="alert alert-success" id="SuccessDiv" style="text-align:center" role="alert" runat="server" visible="false">
                        <asp:Label ID="LabelSuccess" runat="server">添加成功</asp:Label>
                    </div>
                    <div class="alert alert-danger" id="AlertDiv" style="text-align:center" role="alert" runat="server" visible="false">
                        <asp:Label ID="lblAlert" runat="server">添加失败</asp:Label>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
