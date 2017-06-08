using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class _Backstage : System.Web.UI.Page
{
    book_storeDataContext db = new book_storeDataContext();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (null == Session["AdminName"])
            Response.Redirect("BackstageLogin.aspx");
        if (!IsPostBack)
        {
            indexPanel.Visible = true;
            CategoryPanel.Visible = false;
            UserPanel.Visible = false;
            OrderPanel.Visible = false;
            bindCategory();
            bindUser();
            bindOrder();
            txtUsername.Text = Session["AdminName"].ToString();
            ScriptMgr1.RegisterAsyncPostBackControl(btnRefreshCategory);
            ScriptMgr1.RegisterAsyncPostBackControl(refreshUser);
            ScriptMgr1.RegisterAsyncPostBackControl(refreshOrder);
        }
    }

    //更新表数据
    public void bindCategory()
    {
        var rs = from r in db.Category
                 select r;
        CategoryGridView.DataSource = rs;
        CategoryGridView.DataKeyNames = new string[] { "Id" };//主键  
        CategoryGridView.DataBind();
    }

    //更新表数据
    public void bindUser()
    {
        var rs = from r in db.Account
                 select r;
        UserGridView.DataSource = rs;
        UserGridView.DataKeyNames = new string[] { "UserName" };//主键  
        UserGridView.DataBind();
    }

    public void bindOrder()
    {
        var rs = from r in db.Order
                 select r;
        OrderGridView.DataSource = rs;
        OrderGridView.DataKeyNames = new string[] { "Id" };
        OrderGridView.DataBind();
    }

    public void bindBook(GridView sender)
    {
        int index = int.Parse(Session["RowIndex"].ToString()) - 1;
        var category = CategoryGridView.Rows[index].Cells[1].Text;
        var rs = from r in db.Book
                 where r.CategoryName == category
                 select r;
        sender.DataSource = rs;
        sender.DataKeyNames = new string[] { "Id" };
        sender.DataBind();
    }

    private void bindBookDetail(GridView sender)
    {
        int index = int.Parse(Session["RowIndex"].ToString()) - 1;
        //var orderId = OrderGridView.Rows[index].Cells[0].Text;
        var rs = from a in db.OrderDetail
                 join b in db.Book on
                 a.BookId equals b.Id
                 select new
                 {
                     Id = a.BookId,
                     Name = b.Name,
                     Amount = a.Amount,
                     Stock = b.Stock
                 };
        sender.DataSource = rs;
        sender.DataKeyNames = new string[] { "Id" };
        sender.DataBind();
    }

    //界面切换
    protected void btn_Click(object sender, EventArgs e)
    {
        CategoryPanel.Visible = false;
        UserPanel.Visible = false;
        OrderPanel.Visible = false;
        indexPanel.Visible = true;
    }

    protected void CategoryManager_Click(object sender, EventArgs e)
    {
        indexPanel.Visible = false;
        UserPanel.Visible = false;
        OrderPanel.Visible = false;
        CategoryPanel.Visible = true;
    }

    protected void UserManager_Click(object sender, EventArgs e)
    {
        indexPanel.Visible = false;
        CategoryPanel.Visible = false;
        OrderPanel.Visible = false;
        UserPanel.Visible = true;
    }
    protected void OrderManager_Click(object sender, EventArgs e)
    {
        indexPanel.Visible = false;
        CategoryPanel.Visible = false;
        UserPanel.Visible = false;
        OrderPanel.Visible = true;
    }

    protected void Quit_Click(object sender, EventArgs e)
    {
        Response.Redirect("BackstageLogin.aspx");
    }

    protected void CategoryGridView_RowCommand(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            GridView oGridView = (GridView)e.Row.FindControl("BookGridView");
            if (oGridView != null)
            {
                var rs = from r in db.Book
                         where r.CategoryName == e.Row.Cells[1].Text
                         select r;
                oGridView.DataSource = rs;
                oGridView.DataKeyNames = new string[] { "Id" };
                oGridView.DataBind();
            }
        }
    }

    protected void BookGridView_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        GridView a = sender as GridView;
        a.PageIndex = e.NewPageIndex;
        bindBook(a);
    }

    //刷新整个分类板块
    protected void btnRefreshCategory_Click(object sender, EventArgs e)
    {
        bindCategory();
    }

    protected void CategoryGridView_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        CategoryGridView.PageIndex = e.NewPageIndex;
        bindCategory();
    }

    protected void BookGridView_RowEditing(object sender, GridViewEditEventArgs e)
    {
        GridView a = sender as GridView;
        a.EditIndex = e.NewEditIndex;
    }

    protected void BookGridView_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        GridView a = sender as GridView;
        var rs = from r in db.Book
                 where r.Id.ToString() == a.DataKeys[e.RowIndex].Value.ToString()
                 select r;
        db.Book.DeleteAllOnSubmit(rs);
        db.SubmitChanges();
        bindBook(a);
    }

    protected void BookGridView_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
    {
        GridView a = sender as GridView;
        a.EditIndex = -1;
        bindBook(a);
    }

    protected void BookGridView_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {
        NumberFormatInfo nfi = new NumberFormatInfo();
        GridView a = sender as GridView;
        var temp = db.Book.Single(r => r.Id.ToString() == a.Rows[e.RowIndex].Cells[0].Text);
        if (((TextBox)(a.Rows[e.RowIndex].Cells[1].Controls[0])).Text != "")
            temp.Name = ((TextBox)(a.Rows[e.RowIndex].Cells[1].Controls[0])).Text;
        if (((TextBox)(a.Rows[e.RowIndex].Cells[2].Controls[0])).Text != "")
            temp.Price = decimal.Parse(((TextBox)(a.Rows[e.RowIndex].Cells[2].Controls[0])).Text);
        if (((TextBox)(a.Rows[e.RowIndex].Cells[3].Controls[0])).Text != "")
            temp.Stock = int.Parse(((TextBox)(a.Rows[e.RowIndex].Cells[3].Controls[0])).Text);
        db.SubmitChanges();
        a.EditIndex = -1;
        bindBook(a);
    }

    protected void refreshUser_Click(object sender, EventArgs e)
    {
        bindUser();
    }

    protected void refreshOrder_Click(object sender, EventArgs e)
    {
        bindOrder();
    }

    protected void OrderGridView_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        GridView a = sender as GridView;
        a.PageIndex = e.NewPageIndex;
        bindOrder();
    }

    protected void OrderGridView_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType != DataControlRowType.DataRow) return;
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            GridView oGridView = (GridView)e.Row.FindControl("BookDetailGridView");
            Button btn = (Button)e.Row.FindControl("sendGoods");

            string str = e.Row.Cells[1].Text;
            if (str == "已付款")
                btn.Visible = true;
            else
                btn.Visible = false;

            if (oGridView != null)
            {
                var rs = from a in db.OrderDetail
                         join b in db.Book on
                         a.BookId equals b.Id
                         where a.OrderId == int.Parse(e.Row.Cells[0].Text)
                         select new
                         {
                             Id = a.BookId,
                             Name = b.Name,
                             Amount = a.Amount,
                             Stock = b.Stock
                         };
                oGridView.DataSource = rs;
                oGridView.DataKeyNames = new string[] { "Id" };
                oGridView.DataBind();
            }
        }
    }

    protected void OrderGridView_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "sendGood")
        {
            GridViewRow gvr = (GridViewRow)((Control)e.CommandSource).Parent.Parent;
            Button btn = (Button)gvr.Cells[8].FindControl("sendGoods");
            Order od = db.Order.Single(r => r.Id == int.Parse(OrderGridView.DataKeys[gvr.RowIndex].Value.ToString()));
            od.DeliverState = true;
            db.SubmitChanges();
            refreshOrder_Click(null, null);
        }
    }

    protected void BookDetailGridView_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        GridView a = sender as GridView;
        a.PageIndex = e.NewPageIndex;
        bindBookDetail(a);
    }
}