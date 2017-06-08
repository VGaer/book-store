<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Cart.aspx.cs" Inherits="Cart" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />

    <link href="css/bootstrap.min.css" rel="stylesheet" />
    <link href="css/bookstore.css" rel="stylesheet" />

    <script src="js/jquery.min.js"></script>
</head>
<body>
    <form id="form1" runat="server">
        <div>
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
                </div>
            </nav>
        </div>
        <div class="container">
            <div class="row">
                <div style="float: left; width: 70%">
                    <h3>购物车</h3>
                    <div style="float:right">
                        <label style="font-size:18px; font-weight:200">全选</label>
                        <input id="cart_cb_chooseAllItems" type="checkbox" style="width: 20px; height: 20px; margin-left:15px;" onclick="chooseAllItems()" />
                    </div>
                    <div id="cartList">
                    </div>
                </div>

                <div class="panel panel-default" style="width: 20%; float: left; margin-left: 100px; margin-top: 50px; word-break: break-all">
                    <div class="panel-body">
                        您的订单可享受免费配送。 请在订单信息确认页面选择快递送货上门。
                    </div>
                    <div class="panel-body" style="border-top: solid; border-width: 1px; border-color: rgba(162, 156, 156, 0.35); background-color: rgba(192, 181, 181, 0.15); width: 100%">
                        <div style="text-align: center">
                            <label style="font-size: 22px; font-weight: 400">
                                <label>小计(</label>
                                <label id="lbl_goodsNum">0</label>
                                <label>件商品):</label>
                            </label>
                            <label style="font-size: 22px; color: #e22424; font-weight: 400">
                                ¥
                                <label id="lbl_totalMoney">0</label>
                            </label>
                            <br />
                            <button id="btn_settleAccount" class="btn btn-default" style="clear: both; margin: 0, auto; width: 60%;" onclick="settleAccount()">进入结算中心</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <asp:ScriptManager runat="server" EnablePageMethods="true"></asp:ScriptManager>
    </form>
</body>

<script type="text/javascript">
    var user_name = "<%= Session["Username"] %>";
    var lastIndex = 0;
    $(function () {
        window.onload = function () {
            loadCartData();
        };
    })
    function loadCartData() {
        if (user_name == "") {
            self.location = "login.aspx";
            return;
        }
        $.ajax({
            url: 'LoadData.ashx',
            type: 'get',
            data: {
                type: 'load_cart_data',
                username: user_name
            },
            dataType: 'html',
            timeout: 10000,
            success: function (result) {
                if (result == "CART_EMPTY") {
                    alert("当前购物车为空");
                }
                else {
                    var jsonStr = result.substring(result.indexOf("[HeaderStart]") + "[HeaderStart]".length, result.indexOf("[HeaderEnd"));
                    var obj = $.parseJSON(jsonStr);

                    var data = result.substring(result.indexOf("[DataStart]") + "[DataStart]".length, result.indexOf("[DataEnd]"));
                    $("#cartList").append(data);
                    lastIndex = obj.size - 1;
                }
            }
        });
    }
    function deleteCartItem(cartItemId, bookId_) {
        $.ajax({
            url: 'LoadData.ashx',
            type: 'get',
            data: {
                type: 'delete_cart_data',
                username: user_name,
                bookId: bookId_
            },
            dataType: 'html',
            timeout: 10000,
            success: function (result) {
                $('#' + cartItemId).remove();
                caculateMoney();
            }
        });
    }
    function caculateMoney() {
        var index = 0;
        var goodsNum = 0;
        var totalMoney = 0;
        while (index <= lastIndex) {
            if ($('#cart_div_' + index) != null) {
                if ($('#cart_cb_' + index).is(':checked')) {
                    goodsNum = goodsNum + 1;
                    totalMoney = totalMoney + parseFloat($('#cart_price_' + index).text()) * parseInt($('#cart_amount_' + index).val());
                }
            }
            index = index + 1;
        }
        $('#lbl_goodsNum').html(goodsNum);
        $("#lbl_totalMoney").html(totalMoney.toFixed(2));
    }
    function settleAccount() {
        var totalMoney = parseFloat($("#lbl_totalMoney").html()).toFixed(2);
        var idArray = new Array();
        var amountArray = new Array();
        var index = 0;
        var count = 0;
        while (index <= lastIndex) {
            if ($('#cart_div_' + index) != null) {
                if ($('#cart_cb_' + index).is(':checked')) {
                    idArray[count] = parseInt($('#cart_book_id_' + index).text());
                    amountArray[count] = parseInt($('#cart_amount_' + index).val());
                    count = count + 1;
                }
            }
            index = index + 1;
        }
        if (count == 0)
            return;
        PageMethods.CreateOrder(idArray, amountArray, totalMoney, user_name, function (orderId) {
            self.location = "BuyInfoPage.aspx?orderId=" + orderId;
        });
    }
    function onAccountClick() {
        if (user_name == "") self.location = "login.aspx";
        self.location = "Homepage.aspx";
    }
    function onOrderClick() {
        if (user_name == "") self.location = "login.aspx";
        self.location = "CheckOrder.aspx";
    }
    function onCartClick() {
        if (user_name == "") self.location = "login.aspx";
        self.location = 'Cart.aspx';
    }
    function chooseAllItems() {
        var index = 0;
        var isSelected = $('#cart_cb_chooseAllItems').prop('checked');
        while (index <= lastIndex) {
            if ($('#cart_div_' + index) != null) {
                $('#cart_cb_' + index).prop('checked', isSelected);
            }
            index = index + 1;
        }
        caculateMoney();
    }
</script>
</html>
