<%@ Page Language="C#" AutoEventWireup="true" CodeFile="BuyInfoPage.aspx.cs" Inherits="BuyInfoPage" %>

<!DOCTYPE html>

<html>
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
      <link href="css/bootstrap.min.css" rel="stylesheet" />
    <link href="css/bookstore.css" rel="stylesheet" />

    <script src="js/jquery.min.js"></script>
    <script src="js/bootstrap.min.js"></script>
    <style type="text/css">
        td {
            text-align:left;
        }
    </style>
    <title>填写订单信息</title>
</head>
<body>
    <form id="form1" runat="server">
    <div  class="container" style="position:relative;width:100%;text-align:center">
        <div  class="container" style="position:relative;width:50%;float:left;text-align:center">
                         <asp:ScriptManager ID="ScriptManager1" runat="server"> </asp:ScriptManager>
  <asp:UpdatePanel ID="UpdatePanel2" runat="server" ChildrenAsTriggers="True" UpdateMode="Always">
            <ContentTemplate>
            <table Class="table table-striped" style="text-align:center" ID="tb_deliveryInfo" runat="server">
                          <thead>
                            <tr>
                              <th>收货人</th>
                              <th>邮政编码</th>
                             <th>收货地址</th>
                             <th>联系电话</th>
                               <th>选择</th>
                            </tr>

                          </thead>                     
                   </table>
            </ContentTemplate>
        </asp:UpdatePanel>
                   
        </div>
        <div  class="container" style="position:relative;width:50%;float:right;text-align:left">
        <asp:UpdatePanel ID="UpdatePanel1" runat="server" ChildrenAsTriggers="True" UpdateMode="Always">
            <ContentTemplate>

         <input  readonly="readonly" value="填写收货信息:" style="font-size:25px;border-width:0px;position: relative;width:auto;margin-top:10%"/>
      <br /> <br />       
        <input  readonly="readonly" value="收货人:" style="font-size:20px;border-width:0px;position: relative;width:auto;"/>
    <%--<asp:TextBox id="textbox_receiver" style="font-size:20px;" runat="server"></asp:TextBox>    --%> 
          <input id="input_receiver" style="font-size:20px;" runat="server"/>
        <br />       
        <input  readonly="readonly" value="邮政编码:" style="font-size:20px;border-width:0px;position: relative;width:auto;"/>
   <%-- <asp:TextBox id="textbox_postcode" style="font-size:20px;" runat="server"></asp:TextBox>  --%>  
         <input id="input_postcode" style="font-size:20px;" runat="server"/>
        <br />       
        <input  readonly="readonly" value="收货地址:" style="font-size:20px;border-width:0px;position: relative;width:auto;"/>
     <asp:TextBox id="textbox_address" style="font-size:20px;" runat="server"></asp:TextBox> 
               <%-- <input id="input_address" style="font-size:20px;" runat="server"/>--%>
        <br />       
        <input  readonly="readonly" value="联系方式:" style="font-size:20px;border-width:0px;position: relative;width:auto;"/>
    <%--<asp:TextBox id="textbox_phone" style="font-size:20px;" runat="server"></asp:TextBox> --%>   
          <input id="input_phone" style="font-size:20px;" runat="server"/>
       <br /><br />
         <asp:Label ID="label_warn" style="font-size:20px;color:red;" Text="" runat="server"></asp:Label>
        <br/><br/>
        <asp:Button id="btn_commit" Text="确定" style="font-size:20px" OnClick="btn_commit_Click" runat="server" />
        <asp:Button id="btn_cancal" Text="取消" style="font-size:20px" OnClick="btn_cancal_Click" runat="server" />
            </ContentTemplate>

        </asp:UpdatePanel>
        
         </div>
    </div>

    </form>
</body>
    <script type="text/javascript">
         var username = "<%= Session["Username"] %>";
        function onAccountClick() {
            if (username == "") self.location = "login.aspx";
            self.location = "Homepage.aspx";
        }
        function onOrderClick() {
            if (username == "") self.location = "login.aspx";
        }
        function onCartClick() {
            if (username == "") self.location = "login.aspx";
            self.location = "Cart.aspx";
        }
        function setInfo(btn) {
            var id = btn.id;
            var table = document.getElementById("tb_deliveryInfo");  //获取表格
            var row = table.getElementsByTagName("tr")[id];  //获取第id个tr
            var cell0 = row.cells[0].innerText;  //获取td的内容
            var cell1 = row.cells[1].innerText;
            var cell2 = row.cells[2].innerText;
            var cell3 = row.cells[3].innerText;
            var receiver = document.getElementById("input_receiver");
            var address = document.getElementById("textbox_address");
            var postcode = document.getElementById("input_postcode");
            var phone = document.getElementById("input_phone");
            receiver.value = cell0;
            postcode.value = cell1;
            address.value = cell2;
            phone.value = cell3;
        }
    </script>
</html>
