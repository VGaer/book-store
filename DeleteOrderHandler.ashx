<%@ WebHandler Language="C#" Class="DeleteOrderHandler" %>

using System;
using System.Web;
using System.Linq;

public class DeleteOrderHandler : IHttpHandler {
    book_storeDataContext db = new book_storeDataContext();
    public void ProcessRequest (HttpContext context) {
        if(null==context.Request.UrlReferrer){
            context.Response.Write("");
            return;
        }
        //获取订单号
        int orderId;
        int.TryParse(context.Request["orderId"],out orderId);
        var details = from r in db.OrderDetail  //子订单
                      where r.OrderId == orderId
                      select r;
        if (details.Count()!=0) {  //删除子订单
            db.OrderDetail.DeleteAllOnSubmit(details);
            db.SubmitChanges();
        }
        var orders = from r in db.Order
                     where r.Id == orderId
                     select r;
        if (orders.Count()!=0) {  //删除订单
                db.Order.DeleteAllOnSubmit(orders);
                db.SubmitChanges();
        }

        context.Response.ContentType = "text/html";
        context.Response.Write("1");
    }

    public bool IsReusable {
        get {
            return false;
        }
    }

}