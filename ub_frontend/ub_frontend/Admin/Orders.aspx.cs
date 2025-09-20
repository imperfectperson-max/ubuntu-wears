using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ub_frontend.UbuntuWearsReference;

namespace ub_frontend.Admin
{
    public partial class Orders : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            

            if (!IsAdminAuthenticated())
            {
                Response.Redirect("~/Admin/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadOrders();
            }
        }

        protected override void RaisePostBackEvent(IPostBackEventHandler source, string eventArgument)
        {
            // Check authentication before processing any postback
            if (!IsAdminAuthenticated())
            {
                Response.Redirect("~/Admin/Login.aspx");
                return;
            }

            if (eventArgument.StartsWith("UPDATE_STATUS|"))
            {
                var parts = eventArgument.Split('|');
                if (parts.Length == 3)
                {
                    UpdateOrderStatus(parts[1] + "|" + parts[2]);
                }
            }
            else
            {
                base.RaisePostBackEvent(source, eventArgument);
            }
        }

        private bool IsAdminAuthenticated()
        {
            return Session["IsAdmin"] != null && (bool)Session["IsAdmin"] &&
                   Session["UserID"] != null;
        }

        private void LoadOrders()
        {
            try
            {
                using (var client = new UbuntuWearsServiceClient())
                {
                    var response = client.GetAllOrders();
                    if (response.Success && response.Data != null)
                    {
                        RenderOrders(response.Data.ToList());
                    }
                    else
                    {
                        ShowError("Error loading orders: " + response.ErrorMessage);
                    }
                }
            }
            catch (Exception ex)
            {
                ShowError("Error loading orders: " + ex.Message);
            }
        }

        private void RenderOrders(List<Order> orders)
        {
            StringBuilder sb = new StringBuilder();

            // Apply status filter if selected
            if (!string.IsNullOrEmpty(ddlStatusFilter.SelectedValue))
            {
                orders = orders.FindAll(o =>
                    o.Status.ToString() == ddlStatusFilter.SelectedValue ||
                    o.Status == ddlStatusFilter.SelectedValue);
            }

            if (orders.Count == 0)
            {
                sb.Append("<div class='empty-data'>No orders found.</div>");
            }
            else
            {
                foreach (var order in orders)
                {
                    string statusClass = GetStatusClass(order.Status.ToString());

                    string orderHtml = $@"
                        <div class='order-card' data-order-id='{order.OrderID}'>
                            <div class='order-header'>
                                <span class='order-id'>Order #{order.OrderID}</span>
                                <span class='order-date'>{order.CreatedAt:yyyy-MM-dd HH:mm}</span>
                            </div>
                            <div class='order-customer'>{HttpUtility.HtmlEncode(order.User.FirstName)} {HttpUtility.HtmlEncode(order.User.LastName)}</div>
                            <div class='order-amount'>R{order.TotalAmount:F2}</div>
                            <div class='order-status {statusClass}'>{HttpUtility.HtmlEncode(order.Status.ToString())}</div>
                            <div class='order-payment'>Payment: {HttpUtility.HtmlEncode(order.PaymentStatus)}</div>
                            <select class='status-dropdown' onchange='updateOrderStatus({order.OrderID}, this)'>
                                <option value='Processing' {(order.Status.ToString() == "Processing" ? "selected" : "")}>Processing</option>
                                <option value='Shipped' {(order.Status.ToString() == "Shipped" ? "selected" : "")}>Shipped</option>
                                <option value='Delivered' {(order.Status.ToString() == "Delivered" ? "selected" : "")}>Delivered</option>
                                <option value='Cancelled' {(order.Status.ToString() == "Cancelled" ? "selected" : "")}>Cancelled</option>
                            </select>
                            <div class='order-actions'>
                                <button class='btn btn-info' onclick='viewOrderDetails({order.OrderID})'>View Details</button>
                            </div>
                        </div>";

                    sb.Append(orderHtml);
                }
            }

            ordersContainer.InnerHtml = sb.ToString();
        }

        private string GetStatusClass(string status)
        {
            switch (status?.ToLower())
            {
                case "processing":
                    return "status-processing";
                case "shipped":
                    return "status-shipped";
                case "delivered":
                    return "status-delivered";
                case "cancelled":
                    return "status-cancelled";
                default:
                    return "status-processing";
            }
        }

        protected void ddlStatusFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (!IsAdminAuthenticated())
            {
                Response.Redirect("~/Admin/Login.aspx");
                return;
            }
            LoadOrders();
        }

        public void UpdateOrderStatus(string orderIdAndStatus)
        {
            if (!IsAdminAuthenticated())
            {
                Response.Redirect("~/Admin/Login.aspx");
                return;
            }

            if (string.IsNullOrEmpty(orderIdAndStatus)) return;

            var parts = orderIdAndStatus.Split('|');
            if (parts.Length != 2) return;

            int orderId = int.Parse(parts[0]);
            string newStatus = parts[1];

            try
            {
                using (var client = new UbuntuWearsServiceClient())
                {
                    var response = client.UpdateOrderStatus(orderId, newStatus);
                    if (response.Success)
                    {
                        // Reload orders to reflect the change
                        LoadOrders();
                    }
                    else
                    {
                        ShowError("Error updating order status: " + response.ErrorMessage);
                    }
                }
            }
            catch (Exception ex)
            {
                ShowError("Error updating order status: " + ex.Message);
            }
        }

        private void ShowError(string message)
        {
            lblMessage.Text = HttpUtility.HtmlEncode(message);
            lblMessage.CssClass = "message error";
            lblMessage.Visible = true;
        }
    }
}