<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Homepage.aspx.cs" Inherits="Homepage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />

    <link href="css/bootstrap.min.css" rel="stylesheet" />

    <link href="css/bookstore.css" rel="stylesheet" />

    <script src="js/jquery.min.js"></script>
    <script src="js/bootstrap.min.js"></script>
    <script src="js/modal.js"></script>

    <style>
        #addressModalBody input {
            width: 85%;
            margin-left: 20px;
        }

        #addressModalBody p {
            margin: 0 0 20px;
            line-height: 1.7;
            font-size: 16px;
            color: #404040;
            overflow-x: hidden;
        }
    </style>
</head>
<body>
    <form runat="server">
        <div>
            <nav class="navbar navbar-default" role="navigation">
                <div class="container-fluid">
                    <div class="navbar-header">
                        <a class="navbar-brand" href="index.aspx">首页</a>
                    </div>
                    <input id="input_search" list="book_name_list" type="text" class="form-control" style="width: 650px; height: 35px; margin-top: 7px; margin-left: 14%; float: left" onkeyup="onInputSearchChange()" />
                    <button id="btn_search" type="submit" class="btn btn-success" style="margin-left: 4px; float: left; margin-top: 7px;" onclick="searchBooks()">搜索</button>
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
        </div>

        <div class="container">
            <div id="div_addressList" style="margin-left:65px">
                <a href="#" onclick="showAddressModal()">
                    <div class="box col-xs-4" style="height: 250px; border: dashed; text-align: center; border-color: rgba(196, 185, 185, 0.48); margin-left: 25px; margin-bottom: 25px">
                        <h4 style="font-weight: 700; font-size: 25px; line-height: 220px">新地址</h4>
                    </div>
                </a>
            </div>
        </div>

        <div class="modal fade" id="addressModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                        <span>
                            <label class="modal-title" style="font-size:16px;font-weight:600">个人信息</label>
                            <label id="lable_errorMsg" style="font-size: 16px; color: #dd3939; font-weight: 400; margin-left:20px"></label>
                        </span>
                    </div>
                    <div id="addressModalBody" class="modal-body" style="text-align: right">
                        <p>收货人<asp:TextBox ID="label_receiver" runat="server" /></p>
                        <p>收货地址<asp:TextBox ID="label_address" runat="server" /></p>
                        <p>邮政编码<asp:TextBox ID="label_zipcode" runat="server" /></p>
                        <p>电话号码<asp:TextBox ID="label_telephone" runat="server" /></p>
                    </div>
                    <div class="modal-footer">
                        <asp:HiddenField ID="label_addressId" runat="server"/>
                        <asp:Button ID="btn_addressClick" type="button" class="btn btn-primary" Text="确定" runat="server" OnClick="btn_addressClick_Click"></asp:Button>
                        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    </div>
                </div>
            </div>
        </div>

        <div class="modal fade" id="deleteModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-dialog" style="width:300px">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                        <h4 class="modal-title">Warning</h4>
                    </div>
                    <div class="modal-body">你确定要删除该地址吗？（该操作无法撤回）</div>
                    <div class="modal-footer">   
                        <label id="label_deleteId" style="visibility:hidden" runat="server"></label>    
                        <button type="button" class="btn btn-primary" onclick="deleteAddressData()">确定</button>                                    
                        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    </div>                
                </div>
            </div>
        </div>

    </form>
</body>

<script type="text/javascript">
    var user_name = "<%= Session["Username"] %>";
    $(function () {
        if (user_name == "") self.location = "login.aspx";
        $.ajax({
            url: 'LoadData.ashx',
            type: 'get',
            data: {
                type: 'load_delivery_address_data',
                username: user_name
            },
            dataType: 'html',
            timeout: 10000,
            success: function (result) {
                $('#div_addressList').append(result);
            }
        });
    })
    function onAccountClick() {
        self.location = "Homepage.aspx";
    }
    function onOrderClick() {
        self.location = "CheckOrder.aspx";
    }
    function onCartClick() {
        self.location = 'Cart.aspx';
    }
    function showAddressModal(adId)
    {
        if (adId == null) {
            $('#<%=btn_addressClick.ClientID%>').val('添加');
            $('#<%=label_addressId.ClientID%>').val('');
            $('#<%=label_receiver.ClientID%>').val('');
            $('#<%=label_address.ClientID%>').val('');
            $('#<%=label_zipcode.ClientID%>').val('');
            $('#<%=label_telephone.ClientID%>').val('');
            $('#addressModal').modal('show');          
        }
        else {
            $.ajax({
                url: 'LoadData.ashx',
                type: 'get',
                data: {
                    type: 'get_delivery_address_data',
                    addressId: adId
                },
                dataType: 'html',
                timeout: 10000,
                success: function (result) {
                    $('#<%=btn_addressClick.ClientID%>').val('确认修改');
                    $('#<%=label_addressId.ClientID%>').val(adId);
                    $('#addressModal').modal('show');                   
                    setAddressData(result);
                }
            });
         }
    }
    function setAddressData(data) {
        var obj = $.parseJSON(data);
        $('#<%=label_receiver.ClientID%>').val(obj.receiver);
        $('#<%=label_address.ClientID%>').val(obj.address);
        $('#<%=label_zipcode.ClientID%>').val(obj.zipcode);
        $('#<%=label_telephone.ClientID%>').val(obj.telephone);
    }
    function showDeleteModal(id) {
        $('#label_deleteId').text(id);
        $('#deleteModal').modal('show');
    }
    function deleteAddressData() {
        var id = $('#label_deleteId').text();
        $.ajax({
            url: 'LoadData.ashx',
            type: 'get',
            data: {
                type: 'delete_delivery_address_data',
                addressId: id
            },
            dataType: 'html',
            timeout: 10000,
            success: function (result) {
                self.location.reload(true);
            }
        })
    }
</script>

</html>
