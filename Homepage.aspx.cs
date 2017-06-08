using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Homepage : System.Web.UI.Page
{
    book_storeDataContext db = new book_storeDataContext();
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    protected void btn_addressClick_Click(object sender, EventArgs e)
    {
        if (label_addressId.Value == "")
        {
            DeliveryAddress da = new DeliveryAddress();
            da.Receiver = label_receiver.Text;
            da.Address = label_address.Text;
            da.Zipcode = label_zipcode.Text;
            da.Telephone = label_telephone.Text;
            da.UserName = Session["Username"].ToString();
            db.DeliveryAddress.InsertOnSubmit(da);
            db.SubmitChanges();
        }
        else
        {
            int id = int.Parse(label_addressId.Value);
            DeliveryAddress da = (from r in db.DeliveryAddress
                                  where r.Id == id
                                  select r).First();
            if (da == null) return;
            da.Receiver = label_receiver.Text;
            da.Address = label_address.Text;
            da.Zipcode = label_zipcode.Text;
            da.Telephone = label_telephone.Text;
            db.SubmitChanges();
        }
    }
}