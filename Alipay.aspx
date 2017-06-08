<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Alipay.aspx.cs" Inherits="Alipay" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />

    <link href="css/bootstrap.min.css" rel="stylesheet" />

    <script type="text/javascript" src="js/jquery.min.js"></script>
    <script type="text/javascript" src="js/jquery.qrcode.min.js"></script>
    <script type="text/javascript">
        function setPayStatus(success) {
            if (success == 'true') {
                $('#div_paySuccess').show();
            }
            else {
                $('#div_paySuccess').hide();
                if(success == 'false')
                    window.setInterval(function () { getPayStatus(); }, 3000);
            }
        }
    </script>
</head>
<body style="background-color:rgba(150, 148, 148, 0.23)">
    <form id="form" runat="server">
        <nav class="navbar navbar-default" role="navigation">
            <div class="container-fluid">
                <div class="navbar-header">
                    <a class="navbar-brand" href="index.aspx">首页</a>
                </div>
                <div id="navbar" class="navbar-collapse collapse">
                    <ul class="nav navbar-nav navbar-right">
                        <li><a href="Homepage.aspx">我的账户</a></li>
                        <li><a href="CheckOrder.aspx">我的订单</a></li>
                        <li><a href="Cart.aspx">购物车</a></li>
                    </ul>
                </div>
            </div>
        </nav>
        <div class="container" style="text-align: center; margin-top: 50px;">
            <div id="div_paySuccess" class="panel panel-default" style="word-break: break-all; position: absolute; margin-left: -160px;">
                <div class="panel-body" style="border-top: solid; border-width: 1px; border-color: #ffffff; background-color: rgba(192, 181, 181, 0.15); width: 240px;">
                    <div style="text-align: center">
                        <label style="font-size: 16px; font-weight: 300;">
                            该订单已成功支付!
                        </label>
                        <br />
                        <asp:Button runat="server" ID="btn_goodsDetail" class="btn btn-default" style="clear: both; margin: 0, auto; width: 70%; height: 23px; font-size:14px; line-height:14px" OnClick="btn_goodsDetail_Click" Text="查看订单"></asp:Button>
                    </div>
                </div>
            </div>

            <div style="width: 70%; border-radius: 4px; border: solid; border-color: rgba(238, 224, 224, 0.51); margin: 0 auto; background-color:#ffffff">
                <div style="margin: 30px auto; width: 70%">
                    <label style="font-size: 16px; margin-bottom: 10px">扫一扫付款</label>
                    <br />
                    <asp:Label ID="lbl_price" runat="server" Style="color: #ff6a00;" Text="¥666.66" Font-Size="X-Large"></asp:Label>
                    <br />
                    <div id="qrcodeCanvas" style="margin-top: 18px"></div>
                    <hr />
                    <div style="margin: 10px auto">
                        <div style="float: left;">商家</div>
                        <div style="float: right;"><asp:label ID="label_merchant" runat="server"></asp:label></div>
                        <div style="clear: both;"></div>
                    </div>
                    <div style="margin: 10px auto">
                        <div style="float: left;">商品名称</div>
                        <div style="float: right;"><asp:label ID="label_orderName" runat="server"></asp:label></div>
                        <div style="clear: both;"></div>
                    </div>
                    <div style="margin: 10px auto">
                        <div style="float: left;">交易单号</div>
                        <div style="float: right;"><asp:label ID="label_tradeId" runat="server"></asp:label></div>
                        <div style="clear: both;"></div>
                    </div>
                    <div style="margin: 10px auto">
                        <div style="float: left;">创建时间</div>
                        <div style="float: right;"><asp:label ID="label_time" runat="server"></asp:label></div>
                        <div style="clear: both;"></div>
                    </div>
                    <hr />
                    <p>请使用支付宝扫一扫</p>
                    <p>扫描二维码完成支付</p>
                </div>

            </div>
        </div>

        <div>
            <asp:ScriptManager runat="server"></asp:ScriptManager>
            <asp:UpdatePanel runat="server">
                <ContentTemplate>
                    <asp:Button ID="register_event" runat="server" Visible="false"></asp:Button>
                </ContentTemplate>
                <Triggers>
                    <asp:PostBackTrigger ControlID="register_event" />
                </Triggers>
            </asp:UpdatePanel>
            <asp:HiddenField ID="label_orderId" runat="server"/>
        </div>
    </form>
</body>

<script type="text/javascript">
    var order_id = getUrlParam('orderId');
    function getPayStatus() {
        $.ajax({
            url: 'LoadData.ashx',
            type: 'get',
            data: {
                type: 'get_pay_status',
                orderId: order_id
            },
            dataType: 'html',
            timeout: 10000,
            success: function (result) {
                if (result == 'PAY_SUCCESS') {
                    self.location.reload();
                }
            }
        });
    }
    function getUrlParam(name) {
        var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)");
        var r = window.location.search.substr(1).match(reg);
        if (r != null) return unescape(r[2]); return null;
    }
</script>

</html>
