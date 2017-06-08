using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

public partial class bookShow : System.Web.UI.Page
{
    book_storeDataContext db = new book_storeDataContext();
    int bookId=-1;
    protected void Page_Load(object sender, EventArgs e)
    {       
            bookId = getBookId();
            bindBookInfo(bookId); 
            
      
        ScriptManager1.RegisterAsyncPostBackControl(btn_addNum);
        ScriptManager1.RegisterAsyncPostBackControl(btn_decNUm);
        ScriptManager1.RegisterAsyncPostBackControl(btn_commit);

    }

    public int getBookId() {
          int bookId;
            string strBookId =Request["bookId"];
            if (null==strBookId)
            {
                return -1;
            }
            int.TryParse(strBookId,out bookId) ;
        return bookId;
    }

    public void bindBookInfo(int bookId) {
        if (-1 == bookId) { return; }
        //绑定图书信息
        var book = (from r in db.Book
                   where r.Id == bookId
                   select r).FirstOrDefault();
        if (null != book.PicIntro) {
             book_img.ImageUrl = "image/" + book.BookPic; 
        }          
        book_title.Text = book.Name;       
        textbox_bookPrice.Text = book.Price.ToString();
        textbox_sales.Text = book.Sales.ToString();
        textbox_stock.Text = book.Stock.ToString();
        textbox_author.Text = book.Author.ToString();
        div_brief.InnerHtml = book.BriefIntro.ToString();
        if (null != book.PicIntro) {
            img_picInfo.ImageUrl = "image/" + book.PicIntro;
        }
        //评论

        var rs = from r in db.Comment
                 where r.BookId == bookId
                 select r;
        textbox_commentNum.Text= rs.Count().ToString();
        foreach (var comment in rs) {
            HtmlTableRow row=new HtmlTableRow();
            HtmlTableCell cellContent=new HtmlTableCell();
            HtmlTableCell cellTime = new HtmlTableCell();
            HtmlTableCell cellUser = new HtmlTableCell();
            cellContent.InnerHtml = comment.Content;
            cellTime.InnerHtml = comment.Time.ToShortDateString();
            cellUser.InnerHtml = comment.UserName;
            row.Cells.Add(cellContent);
            row.Cells.Add(cellTime);
            row.Cells.Add(cellUser);
            table_comment.Rows.Add(row);
        }       
    }

    protected void btn_addNum_Click(object sender, EventArgs e)
    {
        addOrDec_Click(1);
    }

    protected void btn_decNUm_Click(object sender, EventArgs e)
    {
        addOrDec_Click(-1);
    }
    protected void addOrDec_Click(int flag)
    {
        if (-1 == bookId) { return; }
        var rs = (from r in db.Book
                  where r.Id == bookId
                  select r.Stock).FirstOrDefault();
        int stock = rs;
        int buyNum;
        int.TryParse(textbox_buyNumber.Text, out buyNum);
        switch (flag) {
            case 1:
                if (buyNum >= stock)
                    {
                        textbox_buyNumber.Text = stock.ToString();
                        return;
                    }
                    else
                    {
                        textbox_buyNumber.Text = (buyNum + 1).ToString();
                    }
                break;
            case -1:
                if (buyNum <=1)
                {
                    textbox_buyNumber.Text = 1.ToString();
                    return;
                }
                else
                {
                    textbox_buyNumber.Text = (buyNum -1).ToString();
                }
                break;
        }     
    }

    protected void btn_commit_Click(object sender, EventArgs e)
    {
        int amount;
        int.TryParse(textbox_buyNumber.Text,out amount);
        if (null==Session["Username"]) {
            Response.Redirect("login.aspx");
            return;
        }
        Order order = new Order();
        var price = (from r in db.Book
                     where r.Id == bookId
                     select r.Price).FirstOrDefault();
        order.Cost = price * amount;
        order.UserName = Session["Username"].ToString();
        db.Order.InsertOnSubmit(order);
        db.SubmitChanges();
        OrderDetail detail = new OrderDetail();
        if (-1==bookId) { return; }
        detail.BookId = bookId;
        detail.OrderId = order.Id;
        detail.Amount = amount;
        db.OrderDetail.InsertOnSubmit(detail);
        db.SubmitChanges();
          Response.Redirect("BuyInfoPage.aspx?orderId="+order.Id, false);
       
    }

    protected void btn_addShoppingCar_Click(object sender, EventArgs e)
    {
        int number;
        int.TryParse(textbox_buyNumber.Text, out number);
        if (null == Session["Username"])
        {
            Response.Redirect("login.aspx");
            return;
        }
        ShopCart cart = new ShopCart();
        cart.UserName = Session["Username"].ToString();
        if (-1 == bookId)
        { return;
        }
        cart.BookId = bookId;
        cart.Amount = number;
        db.ShopCart.InsertOnSubmit(cart);
        db.SubmitChanges();
        Response.Redirect("succeedToAddOrder.aspx");
    }
}