<%@ Page Language="C#" AutoEventWireup="true" CodeFile="succeedToAddOrder.aspx.cs" Inherits="succeedToAddOrder" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <link href="css/bootstrap.min.css" rel="stylesheet"/>
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div  class="container" style="position:relative;width:100%;text-align:center">
     <input   readonly="readonly" value="" style="border-width:0px;position: relative;margin-bottom:300px"/>
        <br />
    <asp:Label ID="label_show" Text="成功加入购物车！" style="font-size:30px;color:black;" runat="server"></asp:Label>
   <br /><br /><br />
   <asp:Button id="btn_contiShop" OnClick="btn_contiShop_Click" type="button" Class="btn btn-lg btn-danger"  Text="继续购物" runat="server"/>
   <asp:Button id="btn_payOrder"  OnClick="btn_payOrder_Click" type="button" Class="btn btn-lg btn-danger"  Text="立即支付" runat="server"/>
         </div>
    </form>
</body>
</html>
