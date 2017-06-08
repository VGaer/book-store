<%@ Page Language="C#" AutoEventWireup="true" CodeFile="register.aspx.cs" Inherits="register" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>Sign up</title>
    <link href="./Wopop_files/style_log.css" rel="stylesheet" type="text/css" />
    <link rel="stylesheet" type="text/css" href="./Wopop_files/style.css" />
    <link rel="stylesheet" type="text/css" href="./Wopop_files/userpanel.css" />
</head>
<body>
    <form id="form1" runat="server">
    <div class="login_m">
        <div class="login_logo">
            <img src="./Wopop_files/logo.png" width="196" height="46" />
        </div>
        <div class="register_boder">
            <div class="register_padding" id="login_model">
                <asp:ScriptManager runat="server"></asp:ScriptManager>
                <asp:UpdatePanel runat="server">
                    <ContentTemplate>
                        <h2>用户名
                    <label class="error_label" id="lbl_errorUserName" runat="server"></label>
                        </h2>
                        <label>
                            <!--账号名字-->
                            <asp:TextBox ID="iptUserName" CssClass="txt_input txt_input2" runat="server" OnTextChanged="iptUserName_TextChanged" AutoPostBack="true" />
                        </label>
                        <h2>密码<label class="error_label" id="lbl_errorPassword" runat="server"></label></h2>
                        <label>
                            <!--账号密码-->
                            <asp:TextBox ID="iptPassword" TextMode="Password" CssClass="txt_input" runat="server" OnTextChanged="iptPassword_TextChanged" AutoPostBack="true" />
                        </label>

                        <h2>联系电话<label class="error_label" id="lbl_errorPhone" runat="server"></label></h2>
                        <label>
                            <!--电话-->
                            <asp:TextBox ID="iptPhone" CssClass="txt_input" runat="server" OnTextChanged="iptPhone_TextChanged" AutoPostBack="true"></asp:TextBox>
                        </label>                       
                        <br />
                        <br />
                        <div class="rem_sub">
                            <label>
                                <!--注册按钮-->
                                <input type="submit" class="sub_button" name="button" id="btnSignUp" value="注册" style="opacity: 0.7;" onserverclick="btnSignUp_ServerClick" runat="server" />
                            </label>
                        </div>
                    </ContentTemplate>
                </asp:UpdatePanel>

                <!--login_padding  Sign up end-->
            </div>
            <!--login_boder end-->
        </div>
    <!--login_m end-->
    <br />
    <br />
    </div>
    </form>
</body>
</html>
