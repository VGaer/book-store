using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

public class Config
{
    //支付宝公钥
    public static string alipay_public_key = GetCurrentPath() + "pem/alipay-public-key.txt";

    //开发者私钥
    public static string merchant_private_key = GetCurrentPath() + "pem/private-key.pem";

    //开发者公钥
    public static string merchant_public_key = GetCurrentPath() + "pem/public-key.pem";

    //应用ID
    public static string appId = "2016080400162037";

    //合作伙伴ID：partnerID
    public static string pid = "";

    //支付宝网关
    public static string serverUrl = "https://openapi.alipaydev.com/gateway.do";
    public static string mapiUrl = "https://mapi.alipay.com/gateway.do";
    public static string monitorUrl = "http://mcloudmonitor.com/gateway.do";

    //编码，无需修改
    public static string charset = "utf-8";
    //签名类型
    public static string sign_type = "RSA2";
    //版本号，无需修改
    public static string version = "1.0";
    //格式
    public static string format = "json";

    private static string GetCurrentPath()
    {
        string curPath = System.Web.HttpContext.Current.Request.MapPath("/");
        return curPath;
    }
}