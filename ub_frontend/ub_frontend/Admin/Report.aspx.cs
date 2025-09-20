using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ub_frontend.UbuntuWearsReference;

namespace ub_frontend.Admin
{
    public partial class Report : System.Web.UI.Page
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
                // Set default dates (last 30 days)
                txtStartDate.Text = DateTime.Now.AddDays(-30).ToString("yyyy-MM-dd");
                txtEndDate.Text = DateTime.Now.ToString("yyyy-MM-dd");

                // Load default report
                LoadSalesReport();
            }
        }

        private bool IsAdminAuthenticated()
        {
            return Session["IsAdmin"] != null && (bool)Session["IsAdmin"] &&
                   Session["UserID"] != null;
        }

        protected void ddlReportType_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (!IsAdminAuthenticated())
            {
                Response.Redirect("~/Admin/Login.aspx");
                return;
            }
            LoadSelectedReport();
        }

        protected void btnGenerate_Click(object sender, EventArgs e)
        {
            if (!IsAdminAuthenticated())
            {
                Response.Redirect("~/Admin/Login.aspx");
                return;
            }
            LoadSelectedReport();
        }

        protected void btnRefresh_Click(object sender, EventArgs e)
        {
            if (!IsAdminAuthenticated())
            {
                Response.Redirect("~/Admin/Login.aspx");
                return;
            }
            LoadSelectedReport();
        }

        private void LoadSelectedReport()
        {
            // Only validate dates for relevant reports
            if (ddlReportType.SelectedValue != "Inventory" && !ValidateDates())
                return;

            switch (ddlReportType.SelectedValue)
            {
                case "Sales":
                    LoadSalesReport();
                    break;
                case "Inventory":
                    LoadInventoryReport();
                    break;
                case "Customer":
                    LoadCustomerReport();
                    break;
                case "Invoices":
                    LoadInvoiceReport();
                    break;
            }
        }

        private bool ValidateDates()
        {
            if (string.IsNullOrEmpty(txtStartDate.Text) || string.IsNullOrEmpty(txtEndDate.Text))
            {
                ShowError("Please select both start and end dates.");
                return false;
            }

            DateTime startDate, endDate;
            if (!DateTime.TryParse(txtStartDate.Text, out startDate) || !DateTime.TryParse(txtEndDate.Text, out endDate))
            {
                ShowError("Invalid date format. Please use YYYY-MM-DD format.");
                return false;
            }

            if (startDate > endDate)
            {
                ShowError("Start date cannot be after end date.");
                return false;
            }

            return true;
        }

        private void LoadSalesReport()
        {
            try
            {
                DateTime startDate = DateTime.Parse(txtStartDate.Text);
                DateTime endDate = DateTime.Parse(txtEndDate.Text);

                using (var client = new UbuntuWearsServiceClient())
                {
                    var response = client.GenerateSalesReport(startDate, endDate);

                    if (response.Success && response.Data != null)
                    {
                        var salesReport = response.Data;

                        // Show only sales report panel
                        pnlSalesReport.Visible = true;
                        pnlInventoryReport.Visible = false;
                        pnlCustomerReport.Visible = false;
                        pnlInvoiceReport.Visible = false;

                        // Update statistics
                        totalSales.InnerText = $"R{salesReport.TotalSales:N2}";
                        totalOrders.InnerText = salesReport.TotalOrders.ToString("N0");
                        totalCustomers.InnerText = salesReport.TotalCustomers.ToString("N0");
                        avgOrderValue.InnerText = $"R{salesReport.AverageOrderValue:N2}";

                        // Bind sales by category
                        if (salesReport.SalesByCategories != null && salesReport.SalesByCategories.Any())
                        {
                            gvSalesByCategory.DataSource = salesReport.SalesByCategories;
                            gvSalesByCategory.DataBind();
                        }
                        else
                        {
                            gvSalesByCategory.DataSource = null;
                            gvSalesByCategory.DataBind();
                        }

                        // Bind top selling products
                        if (salesReport.TopSellingProducts != null && salesReport.TopSellingProducts.Any())
                        {
                            gvTopProducts.DataSource = salesReport.TopSellingProducts.Take(10);
                            gvTopProducts.DataBind();
                        }
                        else
                        {
                            gvTopProducts.DataSource = null;
                            gvTopProducts.DataBind();
                        }
                    }
                    else
                    {
                        ShowError("Error loading sales report: " + (response.ErrorMessage ?? "Unknown error"));
                    }
                }
            }
            catch (Exception ex)
            {
                ShowError("Error loading sales report: " + ex.Message);
            }
        }

        private void LoadInventoryReport()
        {
            try
            {
                using (var client = new UbuntuWearsServiceClient())
                {
                    var response = client.GenerateInventoryReport();

                    if (response.Success && response.Data != null)
                    {
                        var inventoryReport = response.Data;

                        // Show only inventory report panel
                        pnlSalesReport.Visible = false;
                        pnlInventoryReport.Visible = true;
                        pnlCustomerReport.Visible = false;
                        pnlInvoiceReport.Visible = false;

                        // Update statistics
                        totalProducts.InnerText = inventoryReport.TotalProducts.ToString("N0");
                        lowStock.InnerText = inventoryReport.LowStockProducts.ToString("N0");
                        outOfStock.InnerText = inventoryReport.OutOfStockProducts.ToString("N0");
                        totalInventoryValue.InnerText = $"R{inventoryReport.TotalInventoryValue:N2}";

                        // Bind inventory items
                        if (inventoryReport.InventoryItems != null && inventoryReport.InventoryItems.Any())
                        {
                            gvInventory.DataSource = inventoryReport.InventoryItems;
                            gvInventory.DataBind();
                        }
                        else
                        {
                            gvInventory.DataSource = null;
                            gvInventory.DataBind();
                        }
                    }
                    else
                    {
                        ShowError("Error loading inventory report: " + (response.ErrorMessage ?? "Unknown error"));
                    }
                }
            }
            catch (Exception ex)
            {
                ShowError("Error loading inventory report: " + ex.Message);
            }
        }

        private void LoadCustomerReport()
        {
            try
            {
                DateTime? startDate = DateTime.Parse(txtStartDate.Text);
                DateTime? endDate = DateTime.Parse(txtEndDate.Text);

                using (var client = new UbuntuWearsServiceClient())
                {
                    var response = client.GenerateCustomerReport(startDate, endDate);

                    if (response.Success && response.Data != null)
                    {
                        var customerReport = response.Data;

                        // Show only customer report panel
                        pnlSalesReport.Visible = false;
                        pnlInventoryReport.Visible = false;
                        pnlCustomerReport.Visible = true;
                        pnlInvoiceReport.Visible = false;

                        // Update statistics
                        totalCustomersCount.InnerText = customerReport.TotalCustomers.ToString("N0");
                        newCustomers.InnerText = customerReport.NewCustomers.ToString("N0");

                        // Bind top customers
                        if (customerReport.TopCustomers != null && customerReport.TopCustomers.Any())
                        {
                            gvTopCustomers.DataSource = customerReport.TopCustomers.Take(10);
                            gvTopCustomers.DataBind();
                        }
                        else
                        {
                            gvTopCustomers.DataSource = null;
                            gvTopCustomers.DataBind();
                        }
                    }
                    else
                    {
                        ShowError("Error loading customer report: " + (response.ErrorMessage ?? "Unknown error"));
                    }
                }
            }
            catch (Exception ex)
            {
                ShowError("Error loading customer report: " + ex.Message);
            }
        }

        private void LoadInvoiceReport()
        {
            try
            {
                DateTime? startDate = DateTime.Parse(txtStartDate.Text);
                DateTime? endDate = DateTime.Parse(txtEndDate.Text);

                using (var client = new UbuntuWearsServiceClient())
                {
                    var response = client.GetInvoices(startDate, endDate);

                    if (response.Success && response.Data != null)
                    {
                        // Show only invoice report panel
                        pnlSalesReport.Visible = false;
                        pnlInventoryReport.Visible = false;
                        pnlCustomerReport.Visible = false;
                        pnlInvoiceReport.Visible = true;

                        // Bind invoices
                        if (response.Data != null && response.Data.Any())
                        {
                            gvInvoices.DataSource = response.Data;
                            gvInvoices.DataBind();
                        }
                        else
                        {
                            gvInvoices.DataSource = null;
                            gvInvoices.DataBind();
                        }
                    }
                    else
                    {
                        ShowError("Error loading invoice report: " + (response.ErrorMessage ?? "Unknown error"));
                    }
                }
            }
            catch (Exception ex)
            {
                ShowError("Error loading invoice report: " + ex.Message);
            }
        }

        private void ShowError(string message)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "ShowError",
                $"alert('{HttpUtility.JavaScriptStringEncode(message)}');", true);
        }

        protected void gv_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                e.Row.Attributes["onmouseover"] = "this.style.backgroundColor='#f8f9fa';";
                e.Row.Attributes["onmouseout"] = "this.style.backgroundColor='';";
            }
        }
    }
}