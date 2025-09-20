using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using ub_frontend.UbuntuWearsReference;

namespace ub_frontend
{
    public partial class Orders1 : System.Web.UI.Page
    {
        private string CurrentFilter => ViewState["CurrentFilter"] as string ?? "all";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["UserID"] == null)
                {
                    Response.Redirect("~/Login.aspx?returnUrl=" + Server.UrlEncode(Request.Url.ToString()));
                    return;
                }
                LoadOrders();
                SetActiveFilterButton();
            }
        }

        private void LoadOrders()
        {
            if (Session["UserID"] == null || !int.TryParse(Session["UserID"].ToString(), out int userId))
            {
                return;
            }

            using (var client = new UbuntuWearsServiceClient())
            {
                List<OrderEntity> orders;

                if (CurrentFilter == "all")
                {
                    var response = client.GetUserOrders(userId);
                    orders = response.Success ? response.Data.ToList() : new List<OrderEntity>();
                }
                else
                {
                    var response = client.GetOrdersByCategory(CurrentFilter);
                    orders = response.Success ? response.Data.ToList() : new List<OrderEntity>();
                }

                lvOrders.DataSource = orders;
                lvOrders.DataBind();
            }
        }

        private void SetActiveFilterButton()
        {
            // Remove active class from all buttons
            btnAll.CssClass = "filter-btn";
            btnProcessing.CssClass = "filter-btn";
            btnShipped.CssClass = "filter-btn";
            btnDelivered.CssClass = "filter-btn";
            btnCancelled.CssClass = "filter-btn";

            // Add active class to the current filter button
            switch (CurrentFilter.ToLower())
            {
                case "all":
                    btnAll.CssClass = "filter-btn active";
                    break;
                case "processing":
                    btnProcessing.CssClass = "filter-btn active";
                    break;
                case "shipped":
                    btnShipped.CssClass = "filter-btn active";
                    break;
                case "delivered":
                    btnDelivered.CssClass = "filter-btn active";
                    break;
                case "cancelled":
                    btnCancelled.CssClass = "filter-btn active";
                    break;
            }
        }

        protected void lvOrders_ItemDataBound(object sender, ListViewItemEventArgs e)
        {
            if (e.Item.ItemType == ListViewItemType.DataItem)
            {
                var order = (OrderEntity)e.Item.DataItem;

                var spnOrderId = (HtmlGenericControl)e.Item.FindControl("spnOrderId");
                var spnOrderDate = (HtmlGenericControl)e.Item.FindControl("spnOrderDate");
                var spnStatus = (HtmlGenericControl)e.Item.FindControl("spnStatus");
                var divOrderTotal = (HtmlGenericControl)e.Item.FindControl("divOrderTotal");
                var btnViewDetails = (Button)e.Item.FindControl("btnViewDetails");
                var btnViewInvoice = (Button)e.Item.FindControl("btnViewInvoice");
                var btnReorder = (Button)e.Item.FindControl("btnReorder");

                spnOrderId.InnerHtml = $"Order #{order.OrderID}";
                spnOrderDate.InnerHtml = $"Placed on {order.CreatedAt:dd MMM yyyy}";
                spnStatus.InnerHtml = order.Status;
                spnStatus.Attributes["class"] = "status-badge " + GetStatusClass(order);
                divOrderTotal.InnerHtml = $"Total: R{order.TotalAmount:F2}";

                // attach IDs to buttons
                btnViewDetails.CommandArgument = order.OrderID.ToString();
                btnViewInvoice.CommandArgument = order.OrderID.ToString();
                btnReorder.CommandArgument = order.OrderID.ToString();

                // Hide reorder button for cancelled orders
                if (order.Status.Equals("Cancelled", StringComparison.OrdinalIgnoreCase))
                {
                    btnReorder.Visible = false;
                }

                // bind repeater items
                var rptOrderItems = (Repeater)e.Item.FindControl("rptOrderItems");
                rptOrderItems.DataSource = order.OrderItems;
                rptOrderItems.DataBind();
            }
        }

        protected void rptOrderItems_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                var item = (OrderItemEntity)e.Item.DataItem;

                var imgItem = (HtmlImage)e.Item.FindControl("imgItem");
                var h4ItemName = (HtmlGenericControl)e.Item.FindControl("h4ItemName");
                var pItemDetails = (HtmlGenericControl)e.Item.FindControl("pItemDetails");

                imgItem.Src = item?.Product?.ImageURL ?? "https://via.placeholder.com/60";
                imgItem.Alt = item?.Product?.Name ?? "Product";
                h4ItemName.InnerHtml = item?.Product?.Name ?? "Product";
                pItemDetails.InnerHtml = $"Qty: {item?.Quantity ?? 0} × R{item?.Price:F2}";
            }
        }

        private string GetStatusClass(OrderEntity order)
        {
            if (order == null || string.IsNullOrWhiteSpace(order.Status))
                return "status-unknown";

            switch (order.Status.ToLowerInvariant())
            {
                case "processing": return "status-processing";
                case "shipped": return "status-shipped";
                case "delivered": return "status-delivered";
                case "cancelled": return "status-cancelled";
                default: return "status-unknown";
            }
        }

        protected void btnFilter_Command(object sender, CommandEventArgs e)
        {
            ViewState["CurrentFilter"] = e.CommandArgument.ToString();
            LoadOrders();
            SetActiveFilterButton();
        }

        protected void btnViewDetails_Command(object sender, CommandEventArgs e)
        {
            int orderId = Convert.ToInt32(e.CommandArgument);
            Response.Redirect($"~/OrderDetails.aspx?id={orderId}");
        }

        protected void btnViewInvoice_Command(object sender, CommandEventArgs e)
        {
            int orderId = Convert.ToInt32(e.CommandArgument);
            Response.Redirect($"~/Invoice.aspx?orderId={orderId}");
        }

        protected void btnReorder_Command(object sender, CommandEventArgs e)
        {
            int orderId = Convert.ToInt32(e.CommandArgument);
            int userId = Convert.ToInt32(Session["UserID"]);

            using (var client = new UbuntuWearsServiceClient())
            {
                var response = client.GetOrder(orderId);
                if (response.Success && response.Data != null)
                {
                    foreach (var item in response.Data.OrderItems)
                    {
                        client.AddToCart(userId, item.ProductID, item.Quantity);
                    }

                    SiteMaster master = (SiteMaster)Master;
                    master.UpdateCartCount();

                    ShowSuccess("Items added to cart successfully!");
                    Response.Redirect("~/Cart.aspx");
                }
            }
        }

        private void ShowSuccess(string message)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "OrdersSuccess",
                $"showNotification('{message}', 'success');", true);
        }
    }
}