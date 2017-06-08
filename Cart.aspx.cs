using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Cart : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    [System.Web.Services.WebMethod]
    public static int CreateOrder(int[] idArray, int[] amountArray, decimal totalMoney, string userName)
    {
        book_storeDataContext db = new book_storeDataContext();
        Order order = new Order();
        order.UserName = userName;
        order.Cost = totalMoney;
        db.Order.InsertOnSubmit(order);
        db.SubmitChanges();

        for(int i = 0, size = idArray.Count(); i < size; i++)
        {
            OrderDetail orderDetail = new OrderDetail();
            orderDetail.OrderId = order.Id;
            orderDetail.BookId = idArray[i];           
            orderDetail.Amount = amountArray[i];
            db.OrderDetail.InsertOnSubmit(orderDetail);         
        } 
        db.SubmitChanges();

        return order.Id;
    }
}