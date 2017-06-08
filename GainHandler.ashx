<%@ WebHandler Language="C#" Class="GainHandler" %>

using System;
using System.Web;
using System.Linq;
using System.Text;

public class GainHandler : IHttpHandler {
    book_storeDataContext db = new book_storeDataContext();
    public void ProcessRequest (HttpContext context) {
        if(null==context.Request.UrlReferrer){
            context.Response.Write("");
            return;
        }
        //获取订单号
        int orderId;
        int.TryParse(context.Request["orderId"].ToString(),out orderId);
        var order = (from r in db.Order
                     where r.Id == orderId&&r.GainState==false
                     select r).FirstOrDefault();
        if (order == null)
        {
            return;
        }
        order.GainState = true;
            db.SubmitChanges();

    }

    public bool IsReusable {
        get {
            return false;
        }
    }

}