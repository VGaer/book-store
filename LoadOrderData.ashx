<%@ WebHandler Language="C#" Class="LoadOrderData" %>

using System;
using System.Web;
using System.Linq;
using System.Text;
using System.IO;

public class LoadOrderData : IHttpHandler {

    book_storeDataContext db = new book_storeDataContext();

    public void ProcessRequest (HttpContext context) {
        if(null==context.Request.UrlReferrer){
            context.Response.Write("");
            return;
        }
        //获取用户名
        string Username = context.Request["Username"].ToString();
        if (null == Username)
        {
            context.Response.Redirect("login.aspx");
        }
        //获取订单信息
        var orders = from r in db.Order
                     where r.UserName == Username
                     orderby r.Time descending
                     select r;
        int orderCount = orders.Count();
        if (orderCount == 0) { return; }
        string categ = context.Request["categ"].ToString();

        //分类处理不同状态的订单
        switch (categ) {
            case "load_allOrder":
                context.Response.Write(LoadOrder(orders));
                break;

            case "load_unpayOrder":
                var unpayOrder = from r in orders
                                 where r.PayState == false
                                 select r;
                if (unpayOrder.Count()==0) { return; }
                context.Response.Write(LoadOrder(unpayOrder));
                break;

            case "load_waitDeliverOrder":
                var waitDeliverOrder = from r in orders
                                       where r.DeliverState == false&&r.PayState==true
                                       select r;
                if (waitDeliverOrder.Count()==0) { return; }
                context.Response.Write(LoadOrder(waitDeliverOrder));
                break;

             case "load_waitGainOrder":
                var waitGainOrder = from r in orders
                                       where r.GainState == false&&r.DeliverState==true
                                       select r;
                if (waitGainOrder.Count()==0) { return; }
                context.Response.Write(LoadOrder(waitGainOrder));
                break;

            case "load_waitCommentOrder":
                var waitCommentOrder = from r in orders
                                       where r.GainState == true&&r.CommentState==false
                                       select r;
                if (waitCommentOrder.Count()==0) { return; }
                context.Response.Write(LoadOrder(waitCommentOrder));
                break;
        }
    }


    //加载所有订单的函数
    public string LoadOrder(System.Linq.IQueryable<Order> rs) {
        StringBuilder table=new StringBuilder();
        foreach (var order in rs) {
            table.Append(tableFactory(order));
        }
        return table.ToString();
    }


    //订单信息转换为表格的函数
    public string tableFactory(Order order) {
        string status;
        if (order.PayState == false) { status = "unPay"; }
        else if (order.DeliverState == false) { status = "unDeliver"; }
        else if (order.GainState == false) { status = "unGain"; }
        else if (order.CommentState==false) { status = "unComment"; }
        else { status = "finish"; }
        string curPath = System.Web.HttpContext.Current.Request.MapPath("/");
        string templatePath = curPath + "template/OrderItem.html";
        StringBuilder tableHtml = new StringBuilder(); //每个订单为一个table
        StringBuilder htmltext; //table的单行数据
        //多表连接查询 Book-OrderDetail
        var orderDetails = from r in db.OrderDetail
                           join b in db.Book on r.BookId equals b.Id
                           where r.OrderId==order.Id
                           select new{
                               Id=r.Id,
                               BookId=r.BookId,
                               OrderId=r.OrderId,
                               Amount=r.Amount,
                               unti_price=b.Price,
                               BookName=b.Name
                           };
        if (null == orderDetails) { return ""; };

        decimal total_price=0;     //总价
        int flag=1;              //如果是订单的第一项，添加数量、总价和交易处理
        foreach (var detail in orderDetails) {         //计算总价
            total_price = total_price+ detail.Amount * detail.unti_price;
        }
        //生成订单表格开始
        tableHtml.Append("<table Class=\"table\">");
        tableHtml.Append("<label style=\"font-size:20px;color:#3399FF;\">订单号:#orderId#</label>");
        tableHtml.Replace("#orderId#", order.Id.ToString());
        foreach (var detail in orderDetails) {
            htmltext = new StringBuilder();
            using (StreamReader sr = new StreamReader(templatePath)) {
                string line;
                while ((line = sr.ReadLine()) != null) {
                    htmltext.Append(line);
                    htmltext.Append("\n");
                }
                sr.Close();
            }
            htmltext.Replace("#book-name#",detail.BookName);
            htmltext.Replace("#book-price#",detail.unti_price.ToString());
            htmltext.Replace("#book-amount#",detail.Amount.ToString());
            if (flag == 1)
            {

                htmltext.Replace("#book-total#", total_price.ToString());
                htmltext.Replace("#operation#", operFactory(status, order.Id));
                flag++;
            }
            else {
                htmltext.Replace("#book-total#", "");
                htmltext.Replace("#operation#", "");
            }
            tableHtml.Append(htmltext);

        }
        tableHtml.Append("</table><br/>");
        return tableHtml.ToString();
    }


    //交易操作处理的函数
    public string operFactory(string status,int orderId) {
        //分类处理不同状态的订单
        StringBuilder op;
        switch (status) {
            case "finish":
                op =new StringBuilder("<input type=\"button\" class=\"btn btn-sm btn-success\" value=\"交易结束\" disabled=\"disabled\"") ;
                return op.ToString(); ;

            case "unPay":
                op =new StringBuilder("<input type=\"button\" name=\"#orderId#\" class=\"btn btn-sm btn-info\" onclick=\"payButton(this)\" value=\"立即支付\" />&nbsp;&nbsp;<input type=\"button\" name=\"#orderId#\" class=\"btn btn-sm btn-danger\" onclick=\"deleteOrder(this)\" value=\"删除订单\" />") ;
                op.Replace("#orderId#",orderId.ToString());
                return op.ToString();

            case "unDeliver":
                op=new StringBuilder(" <input type=\"button\" name=\"#orderId#\"  class=\"btn btn-sm btn-info\" onclick=\"deliverButton(this)\" value=\"提醒发货\" />");
                op.Replace("#orderId#",orderId.ToString());
                return op.ToString();

            case "unGain":
                op=new StringBuilder(" <input type=\"button\" name=\"#orderId#\"  class=\"btn btn-sm btn-info\" onclick=\"gainButton(this)\" value=\"确认收货\" />");
                op.Replace("#orderId#",orderId.ToString());
                return op.ToString();

            case "unComment":
                op=new StringBuilder(" <input type=\"button\" name=\"#orderId#\"  class=\"btn btn-sm btn-info\" onclick=\"commentButton(this)\" value=\"马上评价\" />");
                op.Replace("#orderId#",orderId.ToString());
                return op.ToString();
            default:
                return "";

        }
    }


    public bool IsReusable {
        get {
            return false;
        }
    }

}