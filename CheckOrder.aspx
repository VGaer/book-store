<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CheckOrder.aspx.cs" Inherits="CheckOrder" %>

<!DOCTYPE html>

<html >
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
      <link href="css/bootstrap.min.css" rel="stylesheet"/>
    <link href="css/style.css" rel="stylesheet"/>
       <script src="js/jquery.min.js"></script>
    <script src="js/bootstrap.min.js"></script>
    <style type="text/css">
        th {
            background-color:lightgrey;
            font-size:15px;
        }
        td {
        text-align:left;
        }
        .nav-tabs>li>a:hover{border-color:#eee #eee black}
        .nav-tabs>li.active>a,.nav-tabs>li.active>a:hover,.nav-tabs>li.active>a:focus
        {color:red}

    </style>
    <title>查看订单</title>
</head>
<body style="">
    <form id="form1" runat="server">
                 <nav class="navbar navbar-default" role="navigation">
                    <div class="container-fluid">
                        <div class="navbar-header">
                            <a class="navbar-brand" href="index.aspx">首页</a>
                        </div>                      
                        <div id="navbar" class="navbar-collapse collapse">
                            <ul class="nav navbar-nav navbar-right">
                                <li><a href="#" onclick="onAccountClick()">我的账户</a></li>
                                <li><a href="#" onclick="onOrderClick()">我的订单</a></li>
                                <li><a href="#" onclick="onCartClick()">购物车</a></li>
                            </ul>
                        </div>
                        <datalist id="book_name_list"></datalist>
                    </div>
                </nav>
        <label style="margin-bottom:5%"></label>
    <div class="boughtDiv container">
        	<div class="orderType" style="">
            <ul id="myTab" class="nav nav-tabs">
                <li class="active"><a href="#allOrder" style="font-size:20px;" data-toggle="tab"> 所有订单</a></li>         
                <li><a href="#waitPayOrder"  style="font-size:20px;" data-toggle="tab"> 待付款</a></li>  
                <li><a href="#waitDeliverOrder"  style="font-size:20px;" data-toggle="tab"> 待发货</a></li>  
                <li><a href="#waitGainOrder"  style="font-size:20px;" data-toggle="tab"> 待收货</a></li>  
                <li><a href="#waitCommentOrder"  style="font-size:20px;" data-toggle="tab"> 待评价</a></li>  
           </ul>
    </div>
         <asp:ScriptManager ID="ScriptManager1" runat="server"> </asp:ScriptManager>
          <asp:UpdatePanel ID="UpdatePanel1" runat="server" ChildrenAsTriggers="True" UpdateMode="Always">
            <ContentTemplate>
    <div id="myTabContent" class="tab-content">

        <div class="tab-pane fade in active" id="allOrder">
            <table Class="table" style="text-align:center;" ID="tb_allOrder" runat="server">
                            <tr>
                              <th>宝贝</th>
                              <th>单价</th>
                             <th>数量</th>
                             <th>实付款</th>
                              <th>交易操作</th>
                            </tr>       

                   </table>


        </div>
        <div class="tab-pane fade" id="waitPayOrder" >
            <table Class="table" style="text-align:center" ID="tb_waitPayOrder" runat="server">
                <tr>
                    <th>宝贝</th>
                    <th>单价</th>
                    <th>数量</th>
                    <th>实付款</th>
                    <th>交易操作</th>
                </tr> 
 
        </table>
        </div>
        <div class="tab-pane fade" id="waitDeliverOrder" >
            <table Class="table" style="text-align:center" ID="tb_waitDeliverOrder" runat="server">

                <tr>
                    <th>宝贝</th>
                    <th>单价</th>
                    <th>数量</th>
                    <th>实付款</th>
                    <th>交易操作</th>
                </tr>   
            
        </table>
        </div>
            <div class="tab-pane fade" id="waitGainOrder" >
            <table Class="table" style="text-align:center" ID="bt_waitTakeOrder" runat="server">
                <tr>
                    <th>宝贝</th>
                    <th>单价</th>
                    <th>数量</th>
                    <th>实付款</th>
                    <th>交易操作</th>
                </tr>                 
        </table>
        </div> 
        <div class="tab-pane fade" id="waitCommentOrder" >
            <table Class="table" style="text-align:center" ID="tb_waitCommentOrder" runat="server">
                <tr>
                    <th>宝贝</th>
                    <th>单价</th>
                    <th>数量</th>
                    <th>实付款</th>
                    <th>交易操作</th>
                </tr>                 
        </table>
        </div>
     
    </div> 
          </ContentTemplate>
        </asp:UpdatePanel>
        </div>
    </form>
</body>

    <script type="text/javascript">
        var username = "<%= Session["Username"] %>";
        //初始化
         $(function () {
        window.onload = function () {
            loadOrderData('load_allOrder');
            loadUnpayOrderData('load_unpayOrder');
            loadWaitDeliverOrderData('load_waitDeliverOrder');
            loadWaitCommentOrderData('load_waitCommentOrder');
            loadWaitGainOrderData('load_waitGainOrder');
            
        };
         })

        //加载所有订单数据
         function loadOrderData(categ) {
             $.ajax({
                 url: 'LoadOrderData.ashx',
                 type: 'get',
                 data: {
                     categ:categ,
                     Username:username,
                 },
                 dataType:'html',
                 timeout: 10000,
                 success: function (result) {
                     $("#allOrder").append(result);
                 }
             });
         }

        //加载待付款订单数据
         function loadUnpayOrderData(categ) {
             $.ajax({
                 url: 'LoadOrderData.ashx',
                 type: 'get',
                 data: {
                     categ: categ,
                     Username: username,
                 },
                 dataType: 'html',
                 timeout: 10000,
                 success: function (result) {
                     $("#waitPayOrder").append(result);
                 }
             });
         }

         //加载待发货订单数据
         function loadWaitDeliverOrderData(categ) {
             $.ajax({
                 url: 'LoadOrderData.ashx',
                 type: 'get',
                 data: {
                     categ: categ,
                     Username: username,
                 },
                 dataType: 'html',
                 timeout: 10000,
                 success: function (result) {
                     $("#waitDeliverOrder").append(result);
                 }
             });
         }
         //加载待收货订单数据
         function loadWaitGainOrderData(categ) {
             $.ajax({
                 url: 'LoadOrderData.ashx',
                 type: 'get',
                 data: {
                     categ: categ,
                     Username: username,
                 },
                 dataType: 'html',
                 timeout: 10000,
                 success: function (result) {
                     $("#waitGainOrder").append(result);
                 }
             });
         }

         //加载待评价订单数据
         function loadWaitCommentOrderData(categ) {
             $.ajax({
                 url: 'LoadOrderData.ashx',
                 type: 'get',
                 data: {
                     categ: categ,
                     Username: username,
                 },
                 dataType: 'html',
                 timeout: 10000,
                 success: function (result) {
                     $("#waitCommentOrder").append(result);
                 }
             });
         }

        //立即支付按钮事件
         function payButton(e) {
             self.location = "Alipay.aspx?orderId=" + e.getAttribute("name");
         }

        //删除订单
         function deleteOrder(e) {
             if (confirm("确定删除订单吗？")) {
         $.ajax({
                 url: 'DeleteOrderHandler.ashx',
                 type: 'get',
                 data: {
                     orderId: e.getAttribute("name"),
                 },
                 dataType: 'html',
                 timeout: 10000,
                 success: function (result) {
                     alert("删除成功！");
                     str = "[name=" + e.getAttribute("name") + "]";
                     $(str).attr("value", "已删除");
                     $(str).attr("disabled", "disabled");
                 }
             });
             }        
         }

        //确认收货按钮事件
         function gainButton(e) {
             if (confirm("确定收货吗？")) {
                 $.ajax({
                     url: 'GainHandler.ashx',
                     type: 'get',
                     data: {
                         orderId: e.getAttribute("name"),
                     },
                     dataType: 'html',
                     timeout: 10000,
                     success: function (result) {
                         alert("收货成功！");
                         str = "[name=" + e.getAttribute("name")+"]";
                         $(str).remove();
                     }
                 });

             } else {
                 return;
             }
         }

        //马上评价按钮事件
         function commentButton(e) {
             var comment;
             comment = prompt("请输入您的评价：");
             if (comment) {
                 $.ajax({
                     url: 'CommentHandler.ashx',
                     type: 'get',
                     data: {
                         orderId: e.getAttribute("name"),
                         comment:comment,
                     },
                     dataType: 'html',
                     timeout: 10000,
                     success: function (result) {
                         alert("评论成功！");
                         str = "[name=" + e.getAttribute("name") + "]";
                         $(str).remove();
                     }
                 });
             }
         }

        //提醒发货按钮事件
         function deliverButton(e) {
             str = "[name=" + e.getAttribute("name") + "]";
             alert("提醒成功！");
             $(str).remove();
         }

        //导航栏
        function onAccountClick() {
            if (username == "") self.location = "login.aspx";
            self.location = "Homepage.aspx";
        }
        function onOrderClick() {
            if (username == "") self.location = "login.aspx";
            self.location = "CheckOrder.aspx";
        }
        function onCartClick() {
            if (username == "") self.location = "login.aspx";
            self.location = "Cart.aspx";
        }

    </script>
</html>
