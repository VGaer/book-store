using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text.RegularExpressions;

public partial class register : System.Web.UI.Page
{
    book_storeDataContext db = new book_storeDataContext();
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    protected void btnSignUp_ServerClick(object sender, EventArgs e)
    {
        bool isValid = true;
        string username = iptUserName.Text;
        if (checkUserName() == false) isValid = false;
        string password = iptPassword.Text;
        if (checkPassword() == false) isValid = false;      
        string phone = iptPhone.Text;
        if (checkPhone() == false) isValid = false;       

        if (isValid == false)
            return;

        Account account = new Account();
        account.UserName = username;
        account.Password = password;
        account.Telephone = phone;
        db.Account.InsertOnSubmit(account);
        db.SubmitChanges();
        // 账号注册完成，跳转页面
        Response.Redirect("index.aspx");
        Session.Add("UserName", username);
        Session.Timeout = 600;
    }

    protected void iptUserName_TextChanged(object sender, EventArgs e)
    {
        checkUserName();
    }

    protected bool checkUserName()
    {
        string name = iptUserName.Text;
        if (name == "")
        {
            lbl_errorUserName.InnerText = "Username can't be blank.";
            return false;
        }
        var result = (from r in db.Account
                      where r.UserName == name
                      select r).FirstOrDefault();
        if (result != null)
        {
            lbl_errorUserName.InnerText = "Username is already taken.";
            return false;
        }
        else
        {
            lbl_errorUserName.InnerText = "";
            return true;
        }
    }

    protected void iptPassword_TextChanged(object sender, EventArgs e)
    {
        checkPassword();
    }

    protected bool checkPassword()
    {
        string password = iptPassword.Text;
        if (password == "")
        {
            lbl_errorPassword.InnerText = "Password can't be blank.";
            return false;
        }
        else if (password.Length < 6)
        {
            lbl_errorPassword.InnerText = "Password is too short (minimum is 6 characters).";
            return false;
        }
        else
        {
            lbl_errorPassword.InnerText = "";
            iptPassword.Attributes["value"] = iptPassword.Text;
            return true;
        }
    }


    protected void iptPhone_TextChanged(object sender, EventArgs e)
    {
        checkPhone();
    }

    protected bool checkPhone()
    {
        string phone = iptPhone.Text;
        if (phone == "")
        {
            lbl_errorPhone.InnerText = "The phone can't be blank.";
            return false;
        }
        Regex phoneRegex = new Regex(@"^1[3|4|5|8][0-9]\d{4,8}$");
        if (phoneRegex.IsMatch(phone) == false)
        {
            lbl_errorPhone.InnerText = "The phone number is invalid.";
            return false;
        }
        else
        {
            lbl_errorPhone.InnerText = "";
            return true;
        }
    }
   
}