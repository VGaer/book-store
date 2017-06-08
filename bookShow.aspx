<%@ Page Language="C#" AutoEventWireup="true" CodeFile="bookShow.aspx.cs" Inherits="bookShow" %>

<!DOCTYPE html>

<html>
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />

    <link href="css/bootstrap.min.css" rel="stylesheet">
     <link href="css/bookShowStyle.css" rel="stylesheet">
    <script src="js/jquery.min.js"></script>
    <script src="js/bootstrap.min.js"></script>
</head>
<body>
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

        <div class="container" style="width:100%">
            <div class="book-pic" style="text-align:right;"> 
                <asp:Image id="book_img" style="width:300px;height:300px;margin-right:50px" runat="server"/>
            </div>

            <div class="book-info" style="text-align:left;">
                <br />
                <asp:TextBox ID="book_title" Text="" style="border-width:0px;font-size:30px;" runat="server" ReadOnly="true"></asp:TextBox>
                <br />
                  <div >
                   作者:&nbsp&nbsp&nbsp&nbsp<asp:TextBox ID="textbox_author" style="border-width:0px;font-size:20px;" Text="" runat="server" ReadOnly="true"></asp:TextBox>
                </div>
                <br />
                  <div >
                   价格(元):&nbsp&nbsp&nbsp&nbsp<asp:TextBox ID="textbox_bookPrice" style="border-width:0px;color:red;font-size:50px;" Text="0" runat="server" ReadOnly="true"></asp:TextBox>
                </div>
                <br /><br />
                <div style="width:100%">
               <div style="width:20%; position: relative; float: left;">
                   <span>
                   <input  readonly="readonly" value="销量：" style="border-width:0px;position: relative; float: left;width:30%"/>
                  <asp:TextBox ID="textbox_sales" style="border-width:0px;color:red;float: left;width:30%" Text="0" runat="server" ReadOnly="true"></asp:TextBox>
              </span>
                    </div>
                 <div style="width:30%; position: relative; float: left;">
                       <span>
                   <input  readonly="readonly" value="累计评价：" style="border-width:0px;position: relative; float: left;width:35%"/>
                 <asp:TextBox ID="textbox_commentNum" style="border-width:0px;color:red;float: left;width:30%" Text="0" runat="server" ReadOnly="true"></asp:TextBox>
               </span>
                           </div>
                    <br /><br />
                </div>
               <div style="width:100%;">
                  <div style="width:20%">
                      <asp:ScriptManager ID="ScriptManager1" runat="server"> </asp:ScriptManager>
                      <span>
                          <input  readonly="readonly" value="数量:" style="border-width:0px;position: relative; float: left;width:25%"/>
                <asp:UpdatePanel ID="UpdatePanel_buyNum" runat="server" RenderMode="Inline" UpdateMode="Conditional">
                    <ContentTemplate>
                          <asp:TextBox ID="textbox_buyNumber" OnKeyPress="if((event.keyCode>=48)&&(event.keyCode <=57)) {event.returnValue=true;} else{event.returnValue=false;}" style=" position: relative; float: left;width:30%" runat="server" Text="1" MaxLength="5" ></asp:TextBox>
               </ContentTemplate>
                      <Triggers>
                <asp:AsyncPostBackTrigger ControlID="btn_addNum" EventName="Click" />
                <asp:AsyncPostBackTrigger ControlID="btn_decNUm" EventName="Click" />
                <asp:AsyncPostBackTrigger ControlID="btn_commit" EventName="Click" />
            </Triggers>
                        </asp:UpdatePanel>
                    </span>
                       </div>
                  <div style=" position: relative; float:left;width:20%">
                    <asp:Button   ID="btn_addNum" style="" Text="+"  OnClick="btn_addNum_Click" runat="server"/>
                    <asp:Button   ID="btn_decNUm" style="" Text="-"  OnClick="btn_decNUm_Click"  runat="server"/>件
                </div>

                    <div style=" position: relative; float: left;width:20%">   
                        <span>
                  库存:<asp:TextBox ID="textbox_stock" style="border-width:0px;width:25%" Text="0" runat="server" ReadOnly="true" ></asp:TextBox>件
                        </span>                  
                       
                    </div>
                    </div>
                <br /><br /><br />
                <div style="float:left;position:relative;width:50%">
                <asp:Button  type="button" Class="btn btn-lg btn-danger"  OnClick="btn_commit_Click"  ID="btn_commit"  Text="立即购买" runat="server"/>
             &nbsp&nbsp&nbsp&nbsp&nbsp <asp:Button  ID="btn_addShoppingCar" OnClick="btn_addShoppingCar_Click" Text="加入购物车" type="button" Class="btn btn-lg btn-danger" runat="server"/>
                     </div>
            </div>
           
        </div>

        <div class="container" style="width:100%">
           
            <div style="position: relative;float:right;width: 80%;">
            <ul id="myTab" class="nav nav-tabs">
    <li class="active"><a href="#info" data-toggle="tab"> 商品详情</a></li>         
    <li><a href="#comment" data-toggle="tab"> 累计评价</a></li>  
           </ul>
           <div id="myTabContent" class="tab-content">
               <div class="tab-pane fade in active" id="info">
                   <br /> 
                   <h3>图书简介</h3>              
                   <div id="div_brief" runat="server" style="width:80%;letter-spacing:3px; font-size:18px; line-height:23px; margin-bottom:20px"></div>
                    <div style="margin-bottom:50px; border-top:solid 1px #ada2a2; width:80%"></div>
                   <h3>图书特色</h3>
                   <asp:Image  ID="img_picInfo" runat="server" ImageUrl="/Wopop_files/okgreen.png" style="margin-bottom:100px"/>
                   <div style="margin-bottom:100px; border-top:solid 1px #ada2a2; width:80%"></div>
               </div>
               <div class="tab-pane fade " id="comment">
                   <Table Class="table table-striped" style="font-size:13px;width:80%" ID="table_comment" runat="server">

                   </Table>
               </div>
           </div>
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
            self.location = "CheckOrder.aspx";
        }
        function onCartClick() {
            if (username == "") self.location = "login.aspx";
            self.location = "Cart.aspx";
        }
     function loadBookComment(bookId) {
         $.ajax({
             url: 'LoadBookComment',
             type: 'get',
             data: {
                 bookId:bookId
             },
             dataType: 'html',
             timeout: 10000,
             success: function (result) {
                
             }
         });
     }
 </script>
</html>
