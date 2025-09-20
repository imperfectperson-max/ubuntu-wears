using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ub_frontend.UbuntuWearsReference;

namespace ub_frontend
{
    public partial class Invoice : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["UserID"] == null)
                {
                    Response.Redirect("~/Login.aspx?returnUrl=" + Server.UrlEncode(Request.Url.ToString()));
                    return;
                }

                if (!string.IsNullOrEmpty(Request.QueryString["orderId"]))
                {
                    int orderId;
                    if (int.TryParse(Request.QueryString["orderId"], out orderId))
                    {
                        LoadInvoice(orderId);
                    }
                    else
                    {
                        ShowNotFound();
                    }
                }
                else
                {
                    ShowNotFound();
                }
            }
        }

        private void LoadInvoice(int orderId)
        {
            using (var client = new UbuntuWearsServiceClient())
            {
                var response = client.GenerateInvoice(orderId);
                if (response.Success && response.Data != null)
                {
                    RenderInvoice(response.Data);
                }
                else
                {
                    ShowNotFound();
                }
            }
        }

        private void RenderInvoice(InvoiceEntity invoice)
        {
            StringBuilder sb = new StringBuilder();

            string invoiceHtml = $@"
                <div class='invoice-header'>
                    <div class='company-info'>
                        <h1>Ubuntu Wears</h1>
                        <p>123 Fashion Street</p>
                        <p>Johannesburg, 2000</p>
                        <p>South Africa</p>
                    </div>
                    
                    <div class='invoice-details'>
                        <h2>INVOICE</h2>
                        <p><strong>Invoice #:</strong> {invoice.InvoiceNumber}</p>
                        <p><strong>Date:</strong> {invoice.InvoiceDate:dd MMMM yyyy}</p>
                        <p><strong>Due Date:</strong> {invoice.DueDate:dd MMMM yyyy}</p>
                    </div>
                </div>
                
                <div class='invoice-info'>
                    <div class='info-section'>
                        <h3>Bill To</h3>
                        <p><strong>{invoice.Customer.FirstName} {invoice.Customer.LastName}</strong></p>
                        <p>{invoice.Customer.Email}</p>
                        <p>{invoice.Customer.PhoneNumber}</p>
                    </div>
                    
                    <div class='info-section'>
                        <h3>Order Details</h3>
                        <p><strong>Order #:</strong> {invoice.OrderID}</p>
                        <p><strong>Order Date:</strong> {invoice.Order.CreatedAt:dd MMMM yyyy}</p>
                        <p><strong>Status:</strong> {invoice.Order.Status}</p>
                    </div>
                </div>
                
                <div class='invoice-items'>
                    <table class='invoice-table'>
                        <thead>
                            <tr>
                                <th>Description</th>
                                <th>Quantity</th>
                                <th>Unit Price</th>
                                <th>Total</th>
                            </tr>
                        </thead>
                        <tbody>";

            foreach (var item in invoice.InvoiceItems)
            {
                invoiceHtml += $@"
                            <tr>
                                <td>{HttpUtility.HtmlEncode(item.Product.Name)}</td>
                                <td>{item.Quantity}</td>
                                <td>R{item.UnitPrice:F2}</td>
                                <td>R{item.TotalPrice:F2}</td>
                            </tr>";
            }

            invoiceHtml += $@"
                        </tbody>
                    </table>
                </div>
                
                <div class='invoice-summary'>
                    <div class='summary-section'>
                        <h3>Payment Information</h3>
                        <p><strong>Payment Method:</strong> {invoice.Order.PaymentStatus}</p>
                        <p><strong>Payment Status:</strong> {invoice.Status}</p>
                    </div>
                    
                    <div class='summary-section'>
                        <h3>Order Summary</h3>
                        <div class='summary-item'>
                            <span>Subtotal:</span>
                            <span>R{invoice.TotalAmount:F2}</span>
                        </div>
                        <div class='summary-item'>
                            <span>Tax (15%):</span>
                            <span>R{invoice.TaxAmount:F2}</span>
                        </div>
                        <div class='summary-item'>
                            <span>Discount:</span>
                            <span>R{invoice.DiscountAmount:F2}</span>
                        </div>
                        <div class='summary-item summary-total'>
                            <span>Total:</span>
                            <span>R{invoice.GrandTotal:F2}</span>
                        </div>
                    </div>
                </div>
                
                <div class='invoice-actions'>
                    <button type='button' class='btn-print' onclick='printInvoice()'>
                        <i class='fas fa-print'></i> Print Invoice
                    </button>
                    <button type='button' class='btn-download' onclick='downloadInvoice()'>
                        <i class='fas fa-download'></i> Download PDF
                    </button>
                </div>";

            sb.Append(invoiceHtml);
            invoiceContent.InnerHtml = sb.ToString();
        }

        private void ShowNotFound()
        {
            StringBuilder sb = new StringBuilder();

            string notFoundHtml = @"
                <div class='not-found'>
                    <i class='fas fa-exclamation-triangle'></i>
                    <h2>Invoice Not Found</h2>
                    <p>The requested invoice could not be found.</p>
                    <a href='Orders.aspx' class='btn-primary'>Back to Orders</a>
                </div>";

            sb.Append(notFoundHtml);
            invoiceContent.InnerHtml = sb.ToString();
        }
    }
}