using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class AddBook : System.Web.UI.Page {
    book_storeDataContext db = new book_storeDataContext();
    protected void Page_Load(object sender, EventArgs e) {
        if (!IsPostBack) {
        }
    }

    protected void btnAddBook_Click(object sender, EventArgs e) {
        try {
            Book bk = new Book();
            bk.CategoryName = Session["RowCategoryName"].ToString();
            bk.Name = tbBookName.Text;
            bk.Price = decimal.Parse(tbPrice.Text);
            bk.Stock = int.Parse(tbStock.Text);
            bk.Author = tbAuthor.Text;
            bk.Publisher = tbPublisher.Text;
            bk.PbTime = DateTime.Parse(tbPbTime.Text);
            bk.BriefIntro = tbBrief.Text;
            db.Book.InsertOnSubmit(bk);
            db.SubmitChanges();
            SuccessDiv.Visible = true;
            Response.Write("<script language=javascript>");
            Response.Write("window.close();");
            Response.Write("</script>");
        }
        catch (Exception er) {
            AlertDiv.Visible = true;
            //lblAlert.Text = er.ToString();
        }
    }
}