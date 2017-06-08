<%@ WebHandler Language="C#" Class="CommentHandler" %>

using System;
using System.Web;
using System.Linq;

public class CommentHandler : IHttpHandler {
    book_storeDataContext db = new book_storeDataContext();
    public void ProcessRequest (HttpContext context) {
        if(null==context.Request.UrlReferrer){
            context.Response.Write("");
            return;
        }
        //获取订单号
        int orderId;
        int.TryParse(context.Request["orderId"],out orderId);
        var order = (from r in db.Order
                     where r.Id == orderId&&r.CommentState==false
                     select r).FirstOrDefault();
        if (order == null)
        {
            return;
        }
        var books = from r in db.OrderDetail
                    where r.OrderId == order.Id
                    select r;
        if (books.Count()==0) { return; }
        foreach (var book in books) {
            Comment com = new Comment();
            com.UserName = order.UserName;
            com.BookId = book.BookId;
            com.Content = context.Request["comment"];
            com.Time = DateTime.Now;
            db.Comment.InsertOnSubmit(com);
            db.SubmitChanges();
        }
        order.CommentState = true;
            db.SubmitChanges();
         context.Response.ContentType = "text/html";
        context.Response.Write("1");
    }

    public bool IsReusable {
        get {
            return false;
        }
    }

}