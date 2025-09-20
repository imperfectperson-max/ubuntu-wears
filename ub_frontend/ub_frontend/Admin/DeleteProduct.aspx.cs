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
    public partial class DeleteProduct : System.Web.UI.Page
    {
        private int productId;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsAdminAuthenticated())
            {
                Response.Redirect("~/Admin/Login.aspx");
                return;
            }

            // Get product ID from query string
            if (!int.TryParse(Request.QueryString["id"], out productId))
            {
                ShowError("Invalid product ID.");
                pnlDeleteConfirm.Visible = false;
                pnlError.Visible = true;
                return;
            }

            if (!IsPostBack)
            {
                LoadProductData();
            }
        }

        private bool IsAdminAuthenticated()
        {
            return Session["IsAdmin"] != null && (bool)Session["IsAdmin"];
        }

        private void LoadProductData()
        {
            try
            {
                using (var client = new UbuntuWearsServiceClient())
                {
                    var response = client.GetProduct(productId);
                    if (response.Success && response.Data != null)
                    {
                        var product = response.Data;
                        RenderProductPreview(product);
                    }
                    else
                    {
                        ShowError("Product not found: " + response.ErrorMessage);
                        pnlDeleteConfirm.Visible = false;
                        pnlError.Visible = true;
                    }
                }
            }
            catch (Exception ex)
            {
                ShowError("Error loading product: " + ex.Message);
                pnlDeleteConfirm.Visible = false;
                pnlError.Visible = true;
            }
        }

        private void RenderProductPreview(ProductEntity product)
        {
            StringBuilder sb = new StringBuilder();

            string imageHtml = string.IsNullOrEmpty(product.ImageURL)
                ? "<div class='image-placeholder'><i class='fas fa-image'></i> No image</div>"
                : $"<img src='{HttpUtility.HtmlAttributeEncode(product.ImageURL)}' alt='{HttpUtility.HtmlAttributeEncode(product.Name)}' class='product-image'>";

            string html = $@"
                <div class='product-image-container'>
                    {imageHtml}
                </div>
                <div class='product-details'>
                    <h4>{HttpUtility.HtmlEncode(product.Name)}</h4>
                    <p class='category'><strong>Category:</strong> {HttpUtility.HtmlEncode(product.Category)}</p>
                    <p class='price'><strong>Price:</strong> R{product.Price:F2}</p>
                    <p class='stock'><strong>Stock:</strong> {product.Stock} units</p>
                    <p class='status'><strong>Status:</strong> {(product.isActive ? "Active" : "Inactive")}</p>
                    <p class='added-date'><strong>Added:</strong> {product.DateAdded:dd MMM yyyy}</p>
                </div>";

            productPreview.InnerHtml = html;
        }

        protected void btnConfirmDelete_Click(object sender, EventArgs e)
        {
            try
            {
                using (var client = new UbuntuWearsServiceClient())
                {
                    if (Session["UserID"] == null || !int.TryParse(Session["UserID"].ToString(), out int userId))
                    {
                        ShowError("User session expired. Please log in again.");
                        Response.Redirect("~/Admin/Login.aspx");
                        return;
                    }

                    var response = client.DeleteProduct(userId, productId);

                    if (response.Success)
                    {
                        pnlDeleteConfirm.Visible = false;
                        pnlDeleteSuccess.Visible = true;
                        pnlError.Visible = false;
                    }
                    else
                    {
                        ShowError("Error deleting product: " + response.ErrorMessage);
                        pnlDeleteConfirm.Visible = false;
                        pnlError.Visible = true;
                    }
                }
            }
            catch (Exception ex)
            {
                ShowError("Error deleting product: " + ex.Message);
                pnlDeleteConfirm.Visible = false;
                pnlError.Visible = true;
            }
        }

        private void ShowError(string message)
        {
            lblErrorMessage.Text = HttpUtility.HtmlEncode(message);
        }
    }
}