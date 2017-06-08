using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class succeedToAddOrder : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    protected void btn_contiShop_Click(object sender, EventArgs e)
    {
        Response.Redirect("index.aspx");
    }



    protected void btn_payOrder_Click(object sender, EventArgs e)
    {
        Response.Redirect("Cart.aspx");
    }
}