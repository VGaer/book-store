<%@ WebHandler Language="C#" Class="LoadData" %>

using System;
using System.Web;
using System.Data;
using System.Text;
using System.Linq;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;

public class LoadData : IHttpHandler
{

    book_storeDataContext db = new book_storeDataContext();

    public void ProcessRequest(HttpContext context)
    {
        if (null == context.Request.UrlReferrer)
        {
            context.Response.Write("");
            return;
        }
        string type = context.Request["type"].ToString();
        switch (type)
        {
            case "load_books_data":
                LoadBooksData(context);
                break;
            case "search_books":
                SearchBooks(context);
                break;
            case "load_cart_data":
                LoadCartData(context);
                break;
            case "delete_cart_data":
                DeleteCartData(context);
                break;
            case "search_book_name_list":
                SearchBookNameList(context);
                break;
            case "load_delivery_address_data":
                LoadDeliveryAddressData(context);
                break;
            case "get_delivery_address_data":
                GetDeliveryAddressData(context);
                break;
            case "delete_delivery_address_data":
                DeleteDeliveryAddressData(context);
                break;
            case "get_pay_status":
                GetPayStatus(context);
                break;
        }
    }

    private void LoadBooksData(HttpContext context)
    {
        StringBuilder result = new StringBuilder();
        string category = context.Request["category"].ToString();
        int sortType = int.Parse(context.Request["sort"].ToString());

        IQueryable<Book> books = null;
        if(sortType == 0)
        {
            books = from r in db.Book
                    where r.CategoryName == category
                    select r;
        }
        else if(sortType == 1)
        {
            books = from r in db.Book
                    where r.CategoryName == category
                    orderby r.Price ascending
                    select r;
        }
        else if (sortType == 2)
        {
            books = from r in db.Book
                    where r.CategoryName == category
                    orderby r.Price descending
                    select r;
        }

        

        int length = books.Count();
        Book[] bookArray = books.ToArray();

        string categoryName = GetCategoryName(category);
        string bookNums = length == 0 ? "0" : "1 - " + length;

        result.Append("[HeaderStart]");
        result.Append("{");     
        result.AppendFormat("\"categoryName\": \"{0}\",", categoryName);
        result.AppendFormat("\"bookNums\": \"{0}\"", bookNums); 
        result.Append("}");
        result.Append("[HeaderEnd]");

        result.Append("[DataStart]");
        foreach (var book in bookArray)
        {
            result.Append(GetBookItem(book));
        }
        result.Append("[DataEnd]");
        context.Response.ContentType = "text/html";
        context.Response.Write(result);
    }

    private string GetCategoryName(string category)
    {
        string categoryName = "";
        if (category == "edu") categoryName = "教育";
        else if (category == "novel") categoryName = "小说";
        else if (category == "art") categoryName = "文艺";
        else if (category == "life") categoryName = "生活";
        else if (category == "tech") categoryName = "科技";
        return categoryName;
    }

    private void SearchBooks(HttpContext context)
    {
        StringBuilder result = new StringBuilder();
        string bookName = "%" + context.Request["key"].ToString() + "%";
        var books = from r in db.Book
                    where System.Data.Linq.SqlClient.SqlMethods.Like(r.Name, bookName)
                    select r;
        if (books.Count() == 0) return;

        int length = books.Count();
        Book[] bookArray = books.ToArray();

        foreach (var book in bookArray)
        {
            result.Append(GetBookItem(book));
        }

        context.Response.ContentType = "text/html";
        context.Response.Write(result);
    }

    private string GetBookItem(Book book)
    {
        if (book == null) return "";
        string curPath = System.Web.HttpContext.Current.Request.MapPath("/");
        string templatePath = curPath + "template/MiniBookItem.html";
        StringBuilder htmltext = new StringBuilder();
        try
        {
            using (StreamReader sr = new StreamReader(templatePath))
            {
                String line;
                while ((line = sr.ReadLine()) != null)
                {
                    htmltext.Append(line);
                    htmltext.Append("\n");
                }
                sr.Close();
            }
        }
        catch
        {

        }
        string price = "¥" + book.Price.ToString();
        string src = "image/" + book.Name.ToString() + ".jpg";
        string link = "bookShow.aspx";
        htmltext.Replace("#book_link#", link + "?bookId=" + book.Id);
        htmltext.Replace("#book_src#", src);
        htmltext.Replace("#book_name#", book.Name);
        htmltext.Replace("#book_price#", price);
        return htmltext.ToString();
    }

    private void LoadCartData(HttpContext context)
    {
        StringBuilder result = new StringBuilder();
        string UserName = context.Request["username"].ToString();
        var cartList = from r in db.ShopCart
                       where r.UserName == UserName
                       select r;
        
        if (cartList.Count() == 0)
        {
            context.Response.Write("CART_EMPTY");
            return;
        }

        int length = cartList.Count();
        ShopCart[] cartArray = cartList.ToArray();

        // 添加头部数据
        result.Append("[HeaderStart]");
        result.Append("{ \"size\":" + length + "}");
        result.Append("[HeaderEnd]");

        result.Append("[DataStart]");
        for (int i = 0; i < length; i++)
        {
            result.Append(GetCartItem(cartArray[i], i));
        }
        result.Append("[DataEnd]");
        
        context.Response.ContentType = "text/html";
        context.Response.Write(result);
    }

    private string GetCartItem(ShopCart cart, int index)
    {
        if (cart == null) return "";
        string curPath = System.Web.HttpContext.Current.Request.MapPath("/");
        string templatePath = curPath + "template/CartShowItem.html";
        StringBuilder htmltext = new StringBuilder();
        try
        {
            using (StreamReader sr = new StreamReader(templatePath))
            {
                String line;
                while ((line = sr.ReadLine()) != null)
                {
                    htmltext.Append(line);
                    htmltext.Append("\n");
                }
                sr.Close();
            }
        }
        catch
        {

        }

        var book = (from r in db.Book
                    where r.Id == cart.BookId
                    select r).First();
        if (book == null) return "";

        string price = book.Price.ToString();
        string src = "image/" + book.Name.ToString() + ".jpg";
        string link = "bookShow.aspx?bookId=" + book.Id;
        string itemId = index.ToString();
        htmltext.Replace("$item_id$", itemId);
        htmltext.Replace("#cart_book_id#", book.Id.ToString());
        htmltext.Replace("$delete_cart_parm$", "'cart_div_" + itemId + "', " + book.Id);
        htmltext.Replace("#book_link#", link);
        htmltext.Replace("#book_src#", src);
        htmltext.Replace("#book_name#", book.Name);
        htmltext.Replace("#book_price#", price);
        htmltext.Replace("#cart_amount#", cart.Amount.ToString());
        return htmltext.ToString();
    }
    
    private void DeleteCartData(HttpContext context)
    {
        string username = context.Request["username"].ToString();
        int bookId = int.Parse(context.Request["bookId"]);

        var cart = (from r in db.ShopCart
                   where r.UserName == username && r.BookId == bookId
                   select r).First();

        if (cart == null) return; 
              
        db.ShopCart.DeleteOnSubmit(cart);
        db.SubmitChanges();
    }
    
    private void SearchBookNameList(HttpContext context)
    {
        string key = context.Request["key"].ToString();
        var books = from r in db.Book
                    where System.Data.Linq.SqlClient.SqlMethods.Like(r.Name, key + "%")
                    orderby r.Name.Length ascending
                    select r;
        StringBuilder result = new StringBuilder();
        Book[] bookArray = books.ToArray();
        for (int i = 0, len = books.Count(); i < len; i++)
        {
            result.AppendFormat("<option class='book_name_option'>{0}</option>", bookArray[i].Name);
        }
        context.Response.ContentType = "text/html";
        context.Response.Write(result);
    }

    private void LoadDeliveryAddressData(HttpContext context)
    {
        StringBuilder result = new StringBuilder();
        string username = context.Request["username"].ToString();
        var dalist = from r in db.DeliveryAddress
                    where r.UserName == username
                    select r;
        if (dalist.Count() == 0) return;

        int length = dalist.Count();
        DeliveryAddress[] daArray = dalist.ToArray();

        foreach (var da in daArray)
        {
            result.Append(GetDeliveryAddressItem(da));
        }

        context.Response.ContentType = "text/html";
        context.Response.Write(result);
    }

    private string GetDeliveryAddressItem(DeliveryAddress da)
    {
        string curPath = System.Web.HttpContext.Current.Request.MapPath("/");
        string templatePath = curPath + "template/AddressItem.html";
        StringBuilder htmltext = new StringBuilder();
        try
        {
            using (StreamReader sr = new StreamReader(templatePath))
            {
                String line;
                while ((line = sr.ReadLine()) != null)
                {
                    htmltext.Append(line);
                    htmltext.Append("\n");
                }
                sr.Close();
            }
        }
        catch
        {

        }
        
        htmltext.Replace("$da_id$", da.Id.ToString());    
        htmltext.Replace("#da_receiver#", da.Receiver);    
        htmltext.Replace("#da_address#", da.Address);      
        htmltext.Replace("#da_zipcode#", da.Zipcode);
        htmltext.Replace("#da_telephone#", da.Telephone);

        return htmltext.ToString();
    }

    private void GetDeliveryAddressData(HttpContext context)
    {
        int id = int.Parse(context.Request["addressId"].ToString());
        var address = (from r in db.DeliveryAddress
                       where r.Id == id
                       select r).First();

        if (address == null) return;

        StringBuilder json = new StringBuilder();
        json.Append("{");
        json.AppendFormat("\"receiver\":\"{0}\",", address.Receiver);
        json.AppendFormat("\"address\":\"{0}\",", address.Address);
        json.AppendFormat("\"zipcode\":\"{0}\",", address.Zipcode);
        json.AppendFormat("\"telephone\":\"{0}\"", address.Telephone);
        json.Append("}");

        context.Response.ContentType = "text/html";
        context.Response.Write(json);
    }

    private void DeleteDeliveryAddressData(HttpContext context)
    {
        int id = int.Parse(context.Request["addressId"].ToString());
        var address = (from r in db.DeliveryAddress
                       where r.Id == id
                       select r).First();
        if (address == null) return;
        db.DeliveryAddress.DeleteOnSubmit(address);
        db.SubmitChanges();
    }
    
    private void GetPayStatus(HttpContext context)
    {
        string strOrder = context.Request["orderId"];
        if (strOrder == "") return;
        int orderId = int.Parse(strOrder);
        var order = (from r in db.Order
                     where r.Id == orderId
                     select r).First();
        string payStatus = order.PayState == true ? "PAY_SUCCESS" : "PAY_FAIL";
        context.Response.ContentType = "text/html";
        context.Response.Write(payStatus);
    }
   
    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
}