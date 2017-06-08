<%@ Page Language="C#" AutoEventWireup="true" CodeFile="index.aspx.cs" Inherits="js_index" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title></title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />

    <link href="css/bootstrap.min.css" rel="stylesheet" />

    <link href="css/bookstore.css" rel="stylesheet" />
    
    <script src="js/jquery.min.js"></script>
    <script src="js/bootstrap.min.js"></script>
    <script src="js/docs.min.js"></script>
</head>
<body>
    <form id="form" runat="server">
        <asp:ScriptManager runat="server">
        </asp:ScriptManager>
        <asp:UpdatePanel runat="server" ChildrenAsTriggers="True">
            <ContentTemplate>
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

            </ContentTemplate>
        </asp:UpdatePanel>


        <div class="container" style="width: 100%">

            <div id="carousel-generic" class="carousel slide" data-ride="carousel" data-interval="3000" style="height:300px">
                <ol class="carousel-indicators" style="margin-bottom:-35px">
                    <li data-target="#carousel-example-generic" data-slide-to="0" class="active"></li>
                    <li data-target="#carousel-example-generic" data-slide-to="1"></li>
                    <li data-target="#carousel-example-generic" data-slide-to="2"></li>
                </ol>
                <div class="carousel-inner" role="listbox" style="height:330px">
                    <div class="item active">
                        <img src="image/carousel_1.jpg" style="height:330px" alt="First slide">
                    </div>
                    <div class="item">
                        <img src="image/carousel_2.jpg" style="height:330px" alt="Second slide">
                    </div>
                    <div class="item">
                        <img src="image/carousel_3.jpg" style="height:330px" alt="Third slide">
                    </div>
                </div>
                <a class="left carousel-control" href="#carousel-generic" role="button" data-slide="prev">
                    <span class="glyphicon glyphicon-chevron-left"></span>
                    <span class="sr-only">Previous</span>
                </a>
                <a class="right carousel-control" href="#carousel-generic" role="button" data-slide="next">
                    <span class="glyphicon glyphicon-chevron-right"></span>
                    <span class="sr-only">Next</span>
                </a>
            </div>

            <div class="row">
                <div class="col-sm-3 col-md-2 sidebar" style="margin-right:15px">
                    <ul class="nav nav-sidebar" id="categoryList" style="border-radius:4px; border:solid 1px #ccc; background-color:rgba(158, 151, 151, 0.09); -webkit-box-shadow: 0 0 10px #ddd;">
                        <li>
                            <a onclick="loadBooksData(0, 'edu')">教育</a></li>
                        <li>
                            <a onclick="loadBooksData(0, 'novel')">小说</a></li>
                        <li>
                            <a onclick="loadBooksData(0, 'art')">文艺</a></li>
                        <li>
                            <a onclick="loadBooksData(0, 'life')">生活</a></li>
                        <li>
                            <a onclick="loadBooksData(0, 'tech')">科技</a></li>
                    </ul>
                </div>

                <div class="col-xs-12 col-sm-9" style="border-left: solid 1px rgba(186, 177, 177, 0.52);margin-left:15px">
                    <div class="row" id="bookList">
                        <div style="margin: 8px auto; width: 92%; border-top: solid 1px #ccc; border-bottom: solid 1px #ccc; -webkit-box-shadow: 0 0 10px #ddd;">
                            <div style="margin: 14px 0; font-size: 14px; height: 18px; line-height: 18px;">
                                <div style="margin-left: 15px; float: left">
                                    <label id="label_bookNums">0</label>
                                    个结果，对应
                                    <label style="font-weight: 600">图书</label>
                                    :
                                    <label id="label_category" style="font-weight: 600; color: #c45500">文学</label>
                                </div>
                                <div style="float: right; margin-right: 15px;">
                                    排序 : 
                                    <div style="margin-left: 6px; float: right; border: solid 1px rgba(112, 109, 109, 0.43); width: 110px; -webkit-box-shadow: 0 0 10px #ddd;">
                                        <div id="dropdown_sort" class="dropdown">
                                            <a id="dropdown_name" class="dropdown-toggle" data-toggle="dropdown" style="margin: 0 auto; color: black; cursor: default; text-decoration-line: none;">价格 : 默认排序
                                            <b class="caret"></b>
                                            </a>
                                            <ul class="dropdown-menu">
                                                <li>
                                                    <a onclick="loadBooksData(0)">价格 : 默认排序</a>
                                                </li>
                                                <li>
                                                    <a onclick="loadBooksData(1)">价格 : 由低到高</a>
                                                </li>
                                                <li>
                                                    <a onclick="loadBooksData(2)">价格 : 由高到低</a>
                                                </li>
                                            </ul>
                                        </div>
                                    </div>
                                </div>
                                <div style="clear: both"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div style="height:60px">

            </div>
        </div>
    </form>
</body>


<script type="text/javascript">
    var username = "<%= Session["Username"] %>";
    var categ = 'edu';
    $(function () {
        window.onload = function () {
            loadBooksData(0, categ);
        };
    })
    function loadBooksData(sot, cat) {
        if (cat != null) {
            categ = cat;
        }
        if (sot == 0) $('#dropdown_name').html("价格 : 默认排序" + "<b class='caret'></b>");
        else if (sot == 1) $('#dropdown_name').html("价格 : 由低到高" + "<b class='caret'></b>");
        else if (sot == 2) $('#dropdown_name').html("价格 : 由高到低" + "<b class='caret'></b>");
        $.ajax({
            url: 'LoadData.ashx',
            type: 'get',
            data: {
                type: 'load_books_data',
                category: categ,
                sort: sot
            },
            dataType: 'html',
            timeout: 10000,
            success: function (result) {
                deleteBookItems();

                var jsonStart = result.indexOf("[HeaderStart]") + "[HeaderStart]".length;
                var jsonEnd = result.indexOf("[HeaderEnd]");
                var json = result.substring(jsonStart, jsonEnd);
                var obj = $.parseJSON(json);
                $('#label_category').text(obj.categoryName);
                $('#label_bookNums').text(obj.bookNums);

                var dataStart = result.indexOf("[DataStart]") + "[DataStart]".length;
                var dataEnd = result.indexOf("[DataEnd]");
                var data = result.substring(dataStart, dataEnd);
                $("#bookList").append(data);
            }
        });
    }
    function searchBooks() {
        var k = $('#input_search').val();
        if (k == "") return;
        $.ajax({
            url: 'LoadData.ashx',
            type: 'get',
            data: {
                type: 'search_books',
                key: k
            },
            dataType: 'html',
            timeout: 10000,
            success: function (result) {
                deleteBookItems();
                $("#bookList").append(result);
            }
        });
    }
    function deleteBookItems() {
        $('.book-show-div').remove();
    }
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
    function onInputSearchChange() {
        var k = $('#input_search').val();
        if (k.length == 1) {
            $.ajax({
                url: 'LoadData.ashx',
                type: 'get',
                data: {
                    type: 'search_book_name_list',
                    key: k
                },
                dataType: 'html',
                timeout: 10000,
                success: function (result) {
                    $('.book_name_option').remove();
                    $("#book_name_list").append(result);
                }
            });
        }
        $('book_name_list');
    }
</script>

</html>
