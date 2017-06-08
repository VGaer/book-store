using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class BackstageLogin : System.Web.UI.Page
{
    book_storeDataContext db = new book_storeDataContext();
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    protected void btnSignIn_Click(object sender, EventArgs e)
    {
        string username = iptUsername.Value;
        string password = iptPassword.Value;
        var result = (from r in db.Admin
                      where r.UserName == username
                      select r).FirstOrDefault();
        if (result == null)
        {
            // 账户名不存在
            loginError.Visible = true;
            lblError.InnerText = "Incorrect username or password.";
        }
        else
        {
            if (result.Password != password)
            {
                // 密码错误
                loginError.Visible = true;
                lblError.InnerText = "Incorrect username or password.";
            }
            else
            {
                // 登录成功，跳转页面
                Response.Redirect("Backstage.aspx", false);     
                Session.Add("AdminName", result.UserName);
                Session.Timeout=600;            }
        }
    }
}