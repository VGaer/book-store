<%@ Page Language="C#" AutoEventWireup="true" CodeFile="BackstageLogin.aspx.cs" Inherits="BackstageLogin" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>后台管理</title>
    <link href="./css/bootstrap.min.css" rel="stylesheet" />
    <link href="./css/signin.css" rel="stylesheet" />
</head>
<body>
    <div class="container">
        <form class="form-signin" role="form" runat="server">
            <h2 class="form-signin-heading">请登陆</h2>
            <input type="text" id="iptUsername" class="form-control" placeholder="UserName" runat="server" required autofocus />
            <input type="password" id="iptPassword" class="form-control" placeholder="Password" runat="server" required />
            <button class="btn btn-lg btn-primary btn-block" type="submit" onserverclick="btnSignIn_Click" runat="server">登陆</button>
        </form>
        <div class="alert alert-danger" style="text-align:center" id="loginError" role="alert" runat="server" visible="false">
            <strong>Warning!</strong>       <label id="lblError" runat="server"></label>
        </div>
    </div>
</body>


</html>
