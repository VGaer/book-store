<%@ WebHandler Language="C#" Class="BackstageDataLoad" %>

using System;
using System.Web;
using System.Web.SessionState;

public class BackstageDataLoad : IHttpHandler, IRequiresSessionState {

    public void ProcessRequest(HttpContext context) {
        if (null == context.Request.UrlReferrer) {
            return;
        }
        string type = context.Request["type"].ToString();
        switch (type) {
            case "GridRow":
                setRowIndex(context);
                break;
            case "btnGridRowAdd":
                setAddRowIndex(context);
                break;
            default:
                break;
        }
    }

    public bool IsReusable
    {
        get {
            return false;
        }
    }

    public void setRowIndex(HttpContext context) {
        context.Session.Add("RowIndex", context.Request["row"]);
    }

    public void setAddRowIndex(HttpContext context) {
        context.Session.Add("RowCategoryName", context.Request["categoryName"]);
    }
}