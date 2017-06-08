using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

public partial class BuyInfoPage : System.Web.UI.Page
{
    book_storeDataContext db = new book_storeDataContext();
    String Username;
    int bookId;
    int orderId;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (null == Request["orderId"]) { return; }
        int.TryParse(Request["orderId"], out orderId);

        if (null==Session["Username"]) {
            Response.Redirect("login.aspx");
        }
        Username = Session["Username"].ToString();
        setDeliInfo();
    }
    //绑定收货信息表格数据
    protected void setDeliInfo() {
        var rs = from r in db.DeliveryAddress
                 where r.UserName == Username
                 select r;
        int count=0;
        HtmlTableCell receiver, address, zipcode, phone,button;
        HtmlTableRow row;
        foreach (var r in rs) {
            count++;
            row = new HtmlTableRow();
            receiver = new HtmlTableCell();
            address= new HtmlTableCell();
            zipcode= new HtmlTableCell();
            phone= new HtmlTableCell();
            button= new HtmlTableCell();
            receiver.InnerHtml = r.Receiver;
            address.InnerHtml = r.Address;
            zipcode.InnerHtml = r.Zipcode;
            phone.InnerHtml = r.Telephone;
            button.InnerHtml = "<button id="+count+" onclick=\"setInfo(this)\">选择</button";
            row.Cells.Add(receiver);
            row.Cells.Add(zipcode);
            row.Cells.Add(address);
            row.Cells.Add(phone);
            row.Cells.Add(button);
            tb_deliveryInfo.Rows.Add(row);
        }
    }
    protected void btn_commit_Click(object sender, EventArgs e)
    {
        string receiver = input_receiver.Value;
        string address = textbox_address.Text;
        string postcode = input_postcode.Value;
        string phone = input_phone.Value;
        if (null==receiver||null==address||null==postcode||null==phone) {
            label_warn.Text = "以上信息不能为空！";
            return;
        }

        var order = (from r in db.Order
                     where r.Id == orderId
                     select r).FirstOrDefault();
        if (null==order) { return; }
            order.UserName = Session["Username"].ToString();
            order.Address = address;
            order.Receiver = receiver;
            order.Phone = phone;
            order.Time = DateTime.Now;
            db.SubmitChanges();
        Response.Redirect("Alipay.aspx?orderId="+order.Id);
    }

    protected void btn_cancal_Click(object sender, EventArgs e)
    {
        var order = (from r in db.Order
                     where r.Id == orderId
                     select r).FirstOrDefault();
        var details = from r in db.OrderDetail
                      where r.OrderId == orderId
                      select r;
        if (details.Count()!=0) {
            db.OrderDetail.DeleteAllOnSubmit(details);
            db.SubmitChanges();
        }
        if(null!=order) {
            db.Order.DeleteOnSubmit(order);
            db.SubmitChanges();
        }
        Response.Redirect("index.aspx");
    }
}