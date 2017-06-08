using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class CheckOrder : System.Web.UI.Page
{
    String Username;
    book_storeDataContext db = new book_storeDataContext();
    protected void Page_Load(object sender, EventArgs e)
    {

        if (null==Session["Username"]) {
            Response.Redirect("login.aspx");
            return;
        }
        Username = Session["Username"].ToString();
        var orders = from r in db.Order
                    where r.UserName == Username
                    select r;
        if (null==orders) {
            return;
        }
        foreach (var order in orders) {
            int id = order.Id;
            var details = from r in db.OrderDetail
                          where r.OrderId == id
                          select r;

        }
    }
}