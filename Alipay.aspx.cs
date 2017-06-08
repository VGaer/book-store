using System;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Threading;
using System.Collections;
using System.Collections.Specialized;
using System.Collections.Generic;
using System.Text;
using Aop.Api;
using Aop.Api.Util;
using Aop.Api.Request;
using Aop.Api.Response;
using Aop.Api.Domain;

public partial class Alipay : System.Web.UI.Page
{
    IAopClient alipayClient = new DefaultAopClient(Config.serverUrl, Config.appId, Config.merchant_private_key, Config.format, Config.version, Config.sign_type, Config.alipay_public_key, Config.charset, true);
    book_storeDataContext db = new book_storeDataContext();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request["orderId"] != null)
        {
            int orderId = int.Parse(Request["orderId"]);
            var orders =  from r in db.Order
                           where r.Id == orderId
                           select r;

            if (orders.Count() == 0)
            {
                // 订单不存在
                lbl_price.Text = "订单不存在!";
                ScriptManager.RegisterStartupScript(this.register_event, this.GetType(), "setPayStatusEvent", "setPayStatus('')", true);
            }
            else
            {
                CreateQrCode(orders.First());
            }
        }
        else
        {
            lbl_price.Text = "订单为空!";
            ScriptManager.RegisterStartupScript(this.register_event, this.GetType(), "setPayStatusEvent", "setPayStatus('')", true);
        }         
    }

    void CreateQrCode(Order order)
    {
        lbl_price.Text = "¥" + order.Cost;

        AlipayTradePrecreateRequest request = new AlipayTradePrecreateRequest();

        AlipayTradePrecreateModel model = new AlipayTradePrecreateModel();
        
        model.Body = "购书商城";
        model.Subject = "书单";
        model.TotalAmount = order.Cost.ToString();
        DateTime dateTime = (DateTime)order.Time;
        model.OutTradeNo = dateTime.ToString("yyyyMMdd") + order.Id;
        model.TimeoutExpress = "30m";
        request.SetBizModel(model);

        label_merchant.Text = model.Body;
        label_orderName.Text = model.Subject;
        label_tradeId.Text = model.OutTradeNo;
        label_time.Text = dateTime.ToString();

        AlipayTradePrecreateResponse response = alipayClient.Execute(request);

        string qrCode = HttpUtility.HtmlEncode(response.QrCode);

        StringBuilder printQrCode = new StringBuilder();
        printQrCode.Append("$('#qrcodeCanvas').qrcode({" +
                "width: 140," +
                "height: 140," +
                "text: \"" + qrCode + "\"" +
            "});");
        this.Page.ClientScript.RegisterStartupScript(this.Page.GetType(), "",
            printQrCode.ToString(), true);

        if (order.PayState == true)
        {
            ScriptManager.RegisterStartupScript(this.register_event, this.GetType(), "setPayStatusEvent", "setPayStatus('true')", true);
        }
        else
        {
            List<object> parameters = new List<object>();
            parameters.Add(model);
            parameters.Add(order);
            Thread loopQueryThread = new Thread(LoopQuery);
            loopQueryThread.Start(parameters);
            ScriptManager.RegisterStartupScript(this.register_event, this.GetType(), "setPayStatusEvent", "setPayStatus('false')", true);
        }
    }

    public void LoopQuery(object paras)
    {
        List<object> parameters = paras as List<object>;
        AopObject payModel = parameters[0] as AopObject;
        int interval = 4000;
        int times = 20 * 1000 * 60 / interval;
        string tradeStatus = "";

        // 轮询一分钟
        for (int i = 1; i <= times; i++)
        {
            tradeStatus = GetOrderPayStatus(payModel);
            if (tradeStatus == "WAIT_BUYER_PAY" || tradeStatus == null)
            {
                Thread.Sleep(interval);
                continue;
            }
            else break;
        }

        // TRADE_SUCCESS | TRADE_CLOSED | WAIT_BUYER_PAY

        if (tradeStatus == "TRADE_SUCCESS")
        {
            Order order = parameters[1] as Order;
            order.PayState = true;
            db.SubmitChanges();

            var books = from r in db.ShopCart
                        join p in db.OrderDetail
                        on r.BookId equals p.BookId
                        join t in db.Order
                        on p.OrderId equals t.Id
                        select r;
            if (books.Count() > 0)
            {
                db.ShopCart.DeleteAllOnSubmit(books);


            }
            var orderDetails = from r in db.OrderDetail
                               where r.OrderId == order.Id
                               select r;
            var book_amount= from p in orderDetails
                              join t in db.Book
                              on p.BookId equals t.Id
                              select new { t, p.Amount };
            foreach (var item in book_amount)
            {
                item.t.Sales += item.Amount;
                item.t.Stock -= item.Amount;
            }
            db.SubmitChanges();
        }
        // 如果查询超时或失败，执行退款操作
        else
        {
            CancelOrder(payModel);
        }
    }

    private string GetOrderPayStatus(AopObject model)
    {
        AlipayTradeQueryRequest payRequst = new AlipayTradeQueryRequest();
        AopObject payModel = model as AopObject;
        payRequst.SetBizModel(payModel);

        Dictionary<string, string> paramsDict = (Dictionary<string, string>)payRequst.GetParameters();
        AlipayTradeQueryResponse payResponse = null;
        payResponse = alipayClient.Execute(payRequst);

        return payResponse.TradeStatus;
    }

    public AlipayTradeCancelResponse CancelOrder(AopObject bizModel)
    {
        AlipayTradeCancelRequest cancelRequest = new AlipayTradeCancelRequest();
        cancelRequest.SetBizModel(bizModel);
        AlipayTradeCancelResponse cancelResponse = alipayClient.Execute(cancelRequest);
        if (null != cancelResponse)
        {
            if (cancelResponse.Code == ResultCode.FAIL && cancelResponse.RetryFlag == "Y")
            {
                Thread cancelThread = new Thread(cancelOrderRetry);
                cancelThread.Start(bizModel);
            }
        }
        return cancelResponse;
    }

    public void cancelOrderRetry(object model)
    {
        int retryCount = 50;
        AopObject bizModel = model as AopObject;
        for (int i = 0; i < retryCount; ++i)
        {
            Thread.Sleep(10000);
            AlipayTradeCancelRequest cancelRequest = new AlipayTradeCancelRequest();
            cancelRequest.SetBizModel(bizModel);
            AlipayTradeCancelResponse cancelResponse = alipayClient.Execute(cancelRequest);

            if (null != cancelResponse)
            {
                if (cancelResponse.Code == ResultCode.FAIL)
                {
                    if (cancelResponse.RetryFlag == "N")
                    {
                        break;
                    }
                }
                if ((cancelResponse.Code == ResultCode.SUCCESS))
                {
                    break;
                }
            }
            if (i == retryCount - 1)
            {
                // 处理到最后一次，还是未撤销成功，需要将此订单标记
            }
        }
    }
    protected void btn_goodsDetail_Click(object sender, EventArgs e)
    {
        Response.Redirect("CheckOrder.aspx");
    }
}