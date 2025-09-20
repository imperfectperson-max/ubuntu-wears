using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ub_frontend.UbuntuWearsReference;

namespace ub_frontend.Admin
{
    public partial class EditProduct : System.Web.UI.Page
    {
        private int productId;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsAdminAuthenticated())
            {
                Response.Redirect("~/Admin/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                if (!int.TryParse(Request.QueryString["id"], out productId))
                {
                    ShowNotFound();
                    return;
                }

                LoadProduct(productId);
            }
        }

        private bool IsAdminAuthenticated()
        {
            return Session["IsAdmin"] != null && (bool)Session["IsAdmin"];
        }

        private void LoadProduct(int productId)
        {
            try
            {
                using (var client = new UbuntuWearsServiceClient())
                {
                    var response = client.GetProduct(productId);
                    if (response.Success && response.Data != null)
                    {
                        var product = response.Data;
                        PopulateForm(product);
                    }
                    else
                    {
                        ShowNotFound();
                    }
                }
            }
            catch (Exception ex)
            {
                ShowError("Error loading product: " + ex.Message);
            }
        }

        private void PopulateForm(ProductEntity product)
        {
            hfProductId.Value = product.ProductID.ToString();
            txtProductName.Text = product.Name;
            txtProductDescription.Text = product.Description;
            txtProductPrice.Text = product.Price.ToString("F2");
            txtProductStock.Text = product.Stock.ToString();

            // Set category
            ListItem categoryItem = ddlProductCategory.Items.FindByValue(product.Category);
            if (categoryItem != null)
            {
                ddlProductCategory.ClearSelection();
                categoryItem.Selected = true;
            }

            // Set active status
            cbProductActive.Checked = product.isActive;

            // Display current image
            if (!string.IsNullOrEmpty(product.ImageURL))
            {
                imgCurrentImage.ImageUrl = product.ImageURL;
                imgCurrentImage.Visible = true;
                imgCurrentImage.AlternateText = product.Name;
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
            {
                return;
            }

            try
            {
                if (!int.TryParse(hfProductId.Value, out productId) || productId == 0)
                {
                    ShowError("Invalid product ID");
                    return;
                }

                int userId = Convert.ToInt32(Session["UserID"]);

                // Handle image upload
                string imageUrl = HandleImageUpload();

                using (var client = new UbuntuWearsServiceClient())
                {
                    // Get the existing product first to preserve the image URL if no new image is uploaded
                    var getResponse = client.GetProduct(productId);
                    if (!getResponse.Success)
                    {
                        ShowError("Product not found: " + getResponse.ErrorMessage);
                        return;
                    }

                    var existingProduct = getResponse.Data;

                    var product = new Product
                    {
                        ProductID = productId,
                        Name = txtProductName.Text.Trim(),
                        Description = txtProductDescription.Text.Trim(),
                        Price = decimal.Parse(txtProductPrice.Text),
                        Stock = int.Parse(txtProductStock.Text),
                        Category = ddlProductCategory.SelectedValue,
                        ImageURL = string.IsNullOrEmpty(imageUrl) ? existingProduct.ImageURL : imageUrl,
                        isActive = cbProductActive.Checked,
                        DateAdded = existingProduct.DateAdded
                    };

                    var response = client.UpdateProduct(userId, product);
                    if (response.Success)
                    {
                        ShowSuccess("Product updated successfully!");
                        // Reload the product to show updated data
                        LoadProduct(productId);
                    }
                    else
                    {
                        ShowError("Error updating product: " + response.ErrorMessage);
                    }
                }
            }
            catch (FormatException)
            {
                ShowError("Please enter valid numeric values for price and stock.");
            }
            catch (Exception ex)
            {
                ShowError("Error updating product: " + ex.Message);
            }
            finally
            {
                // Hide loading overlay
                ScriptManager.RegisterStartupScript(this, GetType(), "HideLoading", "document.getElementById('loadingOverlay').style.display = 'none';", true);
            }
        }

        private string HandleImageUpload()
        {
            if (fileProductImage.HasFile && fileProductImage.PostedFile != null)
            {
                try
                {
                    // Validate file type
                    string fileExtension = System.IO.Path.GetExtension(fileProductImage.FileName).ToLower();
                    string[] allowedExtensions = { ".jpg", ".jpeg", ".png", ".gif", ".bmp", ".webp" };

                    if (!allowedExtensions.Contains(fileExtension))
                    {
                        ShowError("Invalid file type. Please upload an image file (JPG, PNG, GIF, BMP, WEBP).");
                        return null;
                    }

                    // Validate file size (2MB max)
                    if (fileProductImage.PostedFile.ContentLength > 2 * 1024 * 1024)
                    {
                        ShowError("File size too large. Maximum size is 2MB.");
                        return null;
                    }

                    // Create directory if it doesn't exist
                    string imagesDir = Server.MapPath("~/Images/Products/");
                    if (!System.IO.Directory.Exists(imagesDir))
                    {
                        System.IO.Directory.CreateDirectory(imagesDir);
                    }

                    // Generate unique filename
                    string cleanFileName = System.IO.Path.GetFileNameWithoutExtension(fileProductImage.FileName);
                    cleanFileName = CleanFileName(cleanFileName); // Remove special characters
                    string fileName = $"{cleanFileName}_{DateTime.Now:yyyyMMddHHmmss}{fileExtension}";
                    string filePath = System.IO.Path.Combine(imagesDir, fileName);

                    fileProductImage.SaveAs(filePath);

                    return $"/Images/Products/{fileName}";
                }
                catch (System.IO.IOException ioEx)
                {
                    ShowError("File access error: " + ioEx.Message);
                    return null;
                }
                catch (Exception ex)
                {
                    ShowError("Image upload failed: " + ex.Message);
                    return null;
                }
            }

            return null;
        }

        private string CleanFileName(string fileName)
        {
            // Remove invalid characters from filename
            var invalidChars = System.IO.Path.GetInvalidFileNameChars();
            return new string(fileName.Where(ch => !invalidChars.Contains(ch)).ToArray()).Replace(" ", "_");
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Admin/Products.aspx");
        }

        private void ShowNotFound()
        {
            pnlProductForm.Visible = false;
            pnlNotFound.Visible = true;
        }

        private void ShowError(string message)
        {
            lblMessage.Text = message;
            lblMessage.CssClass = "message error";
            lblMessage.Visible = true;
        }

        private void ShowSuccess(string message)
        {
            lblMessage.Text = message;
            lblMessage.CssClass = "message success";
            lblMessage.Visible = true;
        }
    }
}