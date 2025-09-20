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
    public partial class Dashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            
            if (!IsAdminAuthenticated())
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                adminName.InnerText = Session["UserName"]?.ToString() ?? "Administrator";
                lastLogin.InnerText = Session["LastLogin"]?.ToString() ?? DateTime.Now.ToString("yyyy-MM-dd HH:mm");
                LoadDashboardData();
            }
        }

        private bool IsAdminAuthenticated()
        {
            return Session["IsAdmin"] != null && (bool)Session["IsAdmin"];
        }

        private void LoadDashboardData()
        {
            try
            {
                using (var client = new UbuntuWearsServiceClient())
                {
                    // Load dashboard stats
                    var statsResponse = client.GetDashboardStats();
                    if (statsResponse.Success && statsResponse.Data != null)
                    {
                        RenderStats(statsResponse.Data);
                    }
                    else
                    {
                        statsContainer.InnerHtml = "<div class='empty-state'>Unable to load dashboard statistics</div>";
                    }

                    // Load recent orders as activity
                    var ordersResponse = client.GetRecentOrders(5);
                    if (ordersResponse.Success && ordersResponse.Data != null)
                    {
                        RenderRecentActivity(ordersResponse.Data.ToList());
                    }
                    else
                    {
                        recentActivityContainer.InnerHtml = "<div class='empty-state'>No recent activity found</div>";
                    }
                }
            }
            catch (Exception ex)
            {
                statsContainer.InnerHtml = $"<div class='error-message'>Error loading dashboard: {HttpUtility.HtmlEncode(ex.Message)}</div>";
                recentActivityContainer.InnerHtml = "<div class='empty-state'>Unable to load recent activity</div>";
            }
        }

        private void RenderStats(DashboardStats stats)
        {
            StringBuilder sb = new StringBuilder();

            string statsHtml = $@"
                <div class='stat-card'>
                    <div class='stat-icon sales'>
                        <i class='fas fa-money-bill-wave'></i>
                    </div>
                    <div class='stat-content'>
                        <div class='stat-number'>R{stats.TotalSales:F2}</div>
                        <div class='stat-label'>Total Sales</div>
                    </div>
                </div>

                <div class='stat-card'>
                    <div class='stat-icon orders'>
                        <i class='fas fa-shopping-cart'></i>
                    </div>
                    <div class='stat-content'>
                        <div class='stat-number'>{stats.TotalOrders}</div>
                        <div class='stat-label'>Total Orders</div>
                    </div>
                </div>

                <div class='stat-card'>
                    <div class='stat-icon products'>
                        <i class='fas fa-tshirt'></i>
                    </div>
                    <div class='stat-content'>
                        <div class='stat-number'>{stats.TotalProducts}</div>
                        <div class='stat-label'>Products</div>
                    </div>
                </div>

                <div class='stat-card'>
                    <div class='stat-icon users'>
                        <i class='fas fa-users'></i>
                    </div>
                    <div class='stat-content'>
                        <div class='stat-number'>{stats.TotalUsers}</div>
                        <div class='stat-label'>Users</div>
                    </div>
                </div>

                <div class='stat-card'>
                    <div class='stat-icon pending'>
                        <i class='fas fa-clock'></i>
                    </div>
                    <div class='stat-content'>
                        <div class='stat-number'>{stats.PendingOrders}</div>
                        <div class='stat-label'>Pending Orders</div>
                    </div>
                </div>";

            sb.Append(statsHtml);
            statsContainer.InnerHtml = sb.ToString();
        }

        private void RenderRecentActivity(List<Order> orders)
        {
            StringBuilder sb = new StringBuilder();

            if (orders.Count == 0)
            {
                sb.Append("<div class='empty-state'>No recent orders found.</div>");
            }
            else
            {
                foreach (var order in orders)
                {
                    string timeAgo = GetTimeAgo(order.CreatedAt);
                    string iconClass = "order-activity";

                    string activityHtml = $@"
                        <div class='activity-item'>
                            <div class='activity-icon {iconClass}'>
                                <i class='fas fa-shopping-cart'></i>
                            </div>
                            <div class='activity-content'>
                                <h4>New Order #{order.OrderID}</h4>
                                <p>Customer: {HttpUtility.HtmlEncode(order.User.FirstName)} {HttpUtility.HtmlEncode(order.User.LastName)} - Amount: R{order.TotalAmount:F2}</p>
                            </div>
                            <div class='activity-time'>{timeAgo}</div>
                        </div>";

                    sb.Append(activityHtml);
                }
            }

            recentActivityContainer.InnerHtml = sb.ToString();
        }

        private string GetTimeAgo(DateTime time)
        {
            TimeSpan span = DateTime.Now - time;

            if (span.Days > 0) return $"{span.Days}d ago";
            if (span.Hours > 0) return $"{span.Hours}h ago";
            if (span.Minutes > 0) return $"{span.Minutes}m ago";

            return "Just now";
        }

        protected void btnRefresh_Click(object sender, EventArgs e)
        {
            LoadDashboardData();
        }

        protected override void RaisePostBackEvent(IPostBackEventHandler source, string eventArgument)
        {
            if (eventArgument == "RefreshData")
            {
                LoadDashboardData();
            }
            else
            {
                base.RaisePostBackEvent(source, eventArgument);
            }
        }
    }
}