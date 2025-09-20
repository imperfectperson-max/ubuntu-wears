using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ub_frontend.UbuntuWearsReference;

namespace ub_frontend.Admin
{
    public partial class Products : System.Web.UI.Page
    {
        private int CurrentPage
        {
            get => ViewState["CurrentPage"] as int? ?? 1;
            set => ViewState["CurrentPage"] = value;
        }
        private const int PageSize = 10;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsAdminAuthenticated())
            {
                Response.Redirect("~/Admin/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadProducts();
            }
            else
            {
                // Handle postback events
                string eventTarget = Request["__EVENTTARGET"];
                string eventArgument = Request["__EVENTARGUMENT"];

                if (!string.IsNullOrEmpty(eventTarget))
                {
                    switch (eventTarget)
                    {
                        case "ToggleStatus":
                            int toggleProductId = Convert.ToInt32(eventArgument);
                            ToggleProductStatus(toggleProductId);
                            break;
                        case "DeleteProduct":
                            int deleteProductId = Convert.ToInt32(eventArgument);
                            DeleteProduct(deleteProductId);
                            break;
                        case "EditProduct":
                            int editProductId = Convert.ToInt32(eventArgument);
                            LoadProductForEdit(editProductId);
                            break;
                    }
                }
            }
        }

        private bool IsAdminAuthenticated()
        {
            return Session["IsAdmin"] != null && (bool)Session["IsAdmin"];
        }

        private void LoadProducts()
        {
            using (var client = new UbuntuWearsServiceClient())
            {
                var item1 = client.GetProducts();
               
                // Check if all calls succeeded
                if (item1.Success)
                {
                    // Combine all product lists
                    var allProducts = new List<ProductEntity>();
                    if (item1.Data != null) allProducts.AddRange(item1.Data);

                    // Apply filters
                    var filteredProducts = ApplyFilters(allProducts.ToList());

                    // Apply pagination
                    int totalProducts = filteredProducts.Count;
                    var pagedProducts = filteredProducts
                        .Skip((CurrentPage - 1) * PageSize)
                        .Take(PageSize)
                        .ToList();

                    RenderProducts(pagedProducts);
                    SetupPagination(totalProducts);
                }
            }
        }


        private void RenderProducts(List<ProductEntity> products)
        {
            string html = @"
            <table class='admin-grid'>
                <thead>
                    <tr>
                        <th>Image</th>
                        <th>Product Name</th>
                        <th>Category</th>
                        <th>Price</th>
                        <th>Stock</th>
                        <th>Active</th>
                        <th>Added On</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>";

            foreach (var product in products)
            {
                html += $@"
                    <tr>
                        <td>
                            <img src='{HttpUtility.HtmlEncode(product.ImageURL)}' alt='{HttpUtility.HtmlEncode(product.Name)}' 
                                 class='product-thumb' onerror='this.src=\""https://via.placeholder.com/50\""' />
                        </td>
                        <td>{HttpUtility.HtmlEncode(product.Name)}</td>
                        <td>{HttpUtility.HtmlEncode(product.Category)}</td>
                        <td>R{product.Price:F2}</td>
                        <td>{product.Stock}</td>
                        <td>{(product.isActive ? "Yes" : "No")}</td>
                        <td>{product.DateAdded:dd MMM yyyy}</td>
                        <td>
                            <a href='javascript:void(0)' class='grid-action' onclick='editProduct({product.ProductID})'>Edit</a>
                            <a href='javascript:void(0)' class='grid-action danger' onclick='toggleProductStatus({product.ProductID})'>
                                {(product.isActive ? "Delete" : "Activate")}
                            </a>
                            
                        </td>
                    </tr>";
            }

            html += @"
                </tbody>
            </table>";

            if (products.Count == 0)
            {
                html = "<div class='no-data'>No products found</div>";
            }

            productsContainer.InnerHtml = html;
        }

        private List<ProductEntity> ApplyFilters(List<ProductEntity> products)
        {
            var filtered = products;

            // Category filter
            if (!string.IsNullOrEmpty(ddlCategory.SelectedValue))
            {
                filtered = filtered.Where(p => p.Category == ddlCategory.SelectedValue).ToList();
            }

            // Status filter
            if (!string.IsNullOrEmpty(ddlStatus.SelectedValue))
            {
                bool isActive = bool.Parse(ddlStatus.SelectedValue);
                filtered = filtered.Where(p => p.isActive == isActive).ToList();
            }

            // Search filter
            if (!string.IsNullOrEmpty(txtSearch.Text.Trim()))
            {
                string searchTerm = txtSearch.Text.Trim().ToLower();
                filtered = filtered.Where(p =>
                    p.Name.ToLower().Contains(searchTerm) ||
                    (p.Description != null && p.Description.ToLower().Contains(searchTerm)) ||
                    p.Category.ToLower().Contains(searchTerm)
                ).ToList();
            }

            return filtered;
        }

        private void SetupPagination(int totalProducts)
        {
            int totalPages = (int)Math.Ceiling((double)totalProducts / PageSize);

            litCurrentPage.Text = CurrentPage.ToString();
            litTotalPages.Text = totalPages.ToString();

            btnPrev.Enabled = CurrentPage > 1;
            btnNext.Enabled = CurrentPage < totalPages;
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            CurrentPage = 1;
            LoadProducts();
        }

        protected void ddlCategory_SelectedIndexChanged(object sender, EventArgs e)
        {
            CurrentPage = 1;
            LoadProducts();
        }

        protected void ddlStatus_SelectedIndexChanged(object sender, EventArgs e)
        {
            CurrentPage = 1;
            LoadProducts();
        }

        protected void btnPrev_Click(object sender, EventArgs e)
        {
            if (CurrentPage > 1)
            {
                CurrentPage--;
                LoadProducts();
            }
        }

        protected void btnNext_Click(object sender, EventArgs e)
        {
            CurrentPage++;
            LoadProducts();
        }

        protected void btnAddProduct_Click(object sender, EventArgs e)
        {
            Response.Redirect("Admin/AddProduct.aspx");
            litModalTitle.Text = "Add New Product";
            hfProductId.Value = "0";
            txtProductName.Text = "";
            txtProductDescription.Text = "";
            txtProductPrice.Text = "";
            txtProductStock.Text = "";
            txtImageURL.Text = "";
            ddlProductCategory.SelectedIndex = 0;
            cbProductActive.Checked = true;

            ScriptManager.RegisterStartupScript(this, GetType(), "OpenModal", "openProductModal();", true);
        }

        private void LoadProductForEdit(int productId)
        {
            using (var client = new UbuntuWearsServiceClient())
            {
                var response = client.GetProduct(productId);
                if (response.Success && response.Data != null)
                {
                    var product = response.Data;
                    hfProductId.Value = productId.ToString();
                    txtProductName.Text = product.Name;
                    ddlProductCategory.SelectedValue = product.Category;
                    txtProductDescription.Text = product.Description;
                    txtProductPrice.Text = product.Price.ToString("F2");
                    txtProductStock.Text = product.Stock.ToString();
                    txtImageURL.Text = product.ImageURL;
                    cbProductActive.Checked = product.isActive;

                    litModalTitle.Text = "Edit Product";
                    ScriptManager.RegisterStartupScript(this, GetType(), "OpenModal", "openProductModal();", true);

                    hfProductId.Value = Convert.ToString(productId);
                }
            }
        }

        private void ToggleProductStatus(int productId)
        {
            int userId = Convert.ToInt32(Session["UserID"]);

            using (var client = new UbuntuWearsServiceClient())
            {
                var response = client.GetProduct(productId);
                if (response.Success && response.Data != null)
                {
                    var product = response.Data;
                    product.isActive = !product.isActive;

                    Product product1 = new Product
                    {
                        ProductID = product.ProductID,
                        Name = product.Name,
                        Description = product.Description,
                        Price = product.Price,
                        Stock = product.Stock,
                        Category = product.Category,
                        ImageURL = product.ImageURL,
                        isActive = product.isActive,
                        DateAdded = product.DateAdded
                    };
                    var updateResponse = client.UpdateProduct(userId, product1);
                    if (updateResponse.Success)
                    {
                        LoadProducts();
                        ShowSuccess($"Product {(product.isActive ? "activated" : "deactivated")} successfully.");
                    }
                }
            }
        }

        private void DeleteProduct(int productId)
        {
            int userId = Convert.ToInt32(Session["UserID"]);

            using (var client = new UbuntuWearsServiceClient())
            {
                var response = client.DeleteProduct(userId, productId);
                if (response.Success)
                {
                    LoadProducts();
                    ShowSuccess("Product deleted successfully.");
                }
                else
                {
                    ShowError("Error deleting product: " + response.ErrorMessage);
                }
            }
        }

        protected void btnSaveProduct_Click(object sender, EventArgs e)
        {
            int userId = Convert.ToInt32(Session["UserID"]);
            int productId = Convert.ToInt32(hfProductId.Value);

            var product = new Product
            {
                ProductID = productId,
                Name = txtProductName.Text.Trim(),
                Category = ddlProductCategory.SelectedValue,
                Description = txtProductDescription.Text.Trim(),
                Price = Convert.ToDecimal(txtProductPrice.Text),
                Stock = Convert.ToInt32(txtProductStock.Text),
                ImageURL = txtImageURL.Text.Trim(),
                isActive = cbProductActive.Checked
            };

            using (var client = new UbuntuWearsServiceClient())
            {
                ServiceResponse response;

                if (productId == 0)
                {
                    // Add new product
                    response = client.AddProduct(userId, product);
                }
                else
                {
                    // Update existing product
                    response = client.UpdateProduct(userId, product);
                }

                if (response.Success)
                {
                    LoadProducts();
                    ScriptManager.RegisterStartupScript(this, GetType(), "CloseModal", "closeModal();", true);
                    ShowSuccess($"Product {(productId == 0 ? "added" : "updated")} successfully.");
                }
                else
                {
                    ShowError("Error saving product: " + response.ErrorMessage);
                }
            }
        }

        private void ClearProductForm()
        {
            txtProductName.Text = "";
            ddlProductCategory.SelectedIndex = 0;
            txtProductDescription.Text = "";
            txtProductPrice.Text = "";
            txtProductStock.Text = "";
            txtImageURL.Text = "";
            cbProductActive.Checked = true;
        }

        private void ShowSuccess(string message)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "SuccessMessage",
                $"showNotification('{message}', 'success');", true);
        }

        private void ShowError(string message)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "ErrorMessage",
                $"showNotification('{message}', 'error');", true);
        }

       
        protected void btnEditProduct_Click(object sender, EventArgs e)
        {
            Response.Redirect("EditProduct.aspx");
        }
    }
}