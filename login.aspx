<%@ Page Language="C#" AutoEventWireup="true" CodeFile="login.aspx.cs" Inherits="login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Sign in to site</title>
    <link href="./Wopop_files/style_log.css" rel="stylesheet" type="text/css" />
    <link rel="stylesheet" type="text/css" href="./Wopop_files/style.css" />
    <link rel="stylesheet" type="text/css" href="./Wopop_files/userpanel.css" />
</head>
<body class="login">
    <form runat="server">
    <div class="login_m">
        <div class="login_logo">
            <h1 style="font-size:30px">购书商城</h1>
        </div>
        <br />
        <br />
        <br /> 
        <!--错误提示-->
        <div id="loginError" class="login_error_boder" runat="server" visible="false">
            <label id="lblError" runat="server"></label>
        </div>
        <div class="login_boder">
            <div class="login_padding" id="login_model">
                <h2>用户名</h2>
                <label>
                    <!--账号名字-->
                    <input type="text" id="iptUsername" class="txt_input txt_input2" placeholder="Your name" runat="server"/>
                    <label id="text"></label>
                </label>
                <h2>密码</h2>
                <label>
                     <!--账号密码-->
                    <input type="password" id="iptPassword" class="txt_input" placeholder="Your password" runat="server"/>
                </label>
                <p class="forgot">
                    <a style="float:left;" id="iregister" href="register.aspx">Register</a>
                    <a style="float:right;" id="iforget" href="javascript:void(0);">Forgot your password?</a>
                </p>
                <br />
                <div class="rem_sub">
                    <label>
                        <!--登录按钮-->
                        <input type="submit" class="sub_button" name="button" id="btnSignIn" value="登录" style="opacity: 0.7;" onserverclick="btnSignIn_Click" runat="server"/>
                    </label>
                </div>
            </div>           
            <!--login_padding  Sign up end-->
        </div>
        <!--login_boder end-->
    </div>
    <!--login_m end-->
    <br />
    <br />
    </form>          
</body>


</html>
