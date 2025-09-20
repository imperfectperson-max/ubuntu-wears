using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ub_frontend.UbuntuWearsReference;

namespace ub_frontend.Admin
{
    public partial class AddProduct : System.Web.UI.Page
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
                
            }
        }

        private bool IsAdminAuthenticated()
        {
            return Session["IsAdmin"] != null && (bool)Session["IsAdmin"];
        }

        protected void btnSaveProduct_Click(object sender, EventArgs e)
        {
            try
            {
                // Validate required fields
                if (!ValidateForm())
                {
                    return;
                }

                int userId = Convert.ToInt32(Session["UserID"]);

                // Handle image upload
                string imageUrl = HandleImageUpload();

                // Use placeholder if no image uploaded (but don't fail the operation)
                if (string.IsNullOrEmpty(imageUrl))
                {
                    imageUrl = "https://via.placeholder.com/500x500?text=No+Image+Available";
                }

                var product = new Product
                {
                    Name = txtProductName.Text.Trim(),
                    Category = ddlProductCategory.SelectedValue,
                    Description = txtProductDescription.Text.Trim(),
                    Price = Convert.ToDecimal(txtProductPrice.Text),
                    Stock = Convert.ToInt32(txtProductStock.Text),
                    ImageURL = imageUrl,
                    isActive = cbProductActive.Checked,
                    DateAdded = DateTime.Now
                };

                using (var client = new UbuntuWearsServiceClient())
                {
                    var response = client.AddProduct(userId, product);

                    if (response.Success)
                    {
                        ShowSuccess("Product added successfully!");
                        ClearForm();

                        // Redirect to products list after successful addition
                        Response.AddHeader("REFRESH", "3;URL=Products.aspx");
                    }
                    else
                    {
                        ShowError("Error adding product: " + response.ErrorMessage);
                    }
                }
                
            }
            catch (FormatException)
            {
                ShowError("Please enter valid numeric values for price and stock.");
            }
            catch (Exception ex)
            {
                ShowError("Error adding product: " + ex.Message);
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
                        lblMessage.Text = "Invalid file type. Please upload an image file (JPG, PNG, GIF, BMP, WEBP).";
                        lblMessage.CssClass = "message error";
                        lblMessage.Visible = true;
                        return null;
                    }

                    // Validate file size (2MB max)
                    if (fileProductImage.PostedFile.ContentLength > 2 * 1024 * 1024)
                    {
                        lblMessage.Text = "File size too large. Maximum size is 2MB.";
                        lblMessage.CssClass = "message error";
                        lblMessage.Visible = true;
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
                    lblMessage.Text = "File access error: " + ioEx.Message;
                    lblMessage.CssClass = "message error";
                    lblMessage.Visible = true;
                    return null;
                }
                catch (Exception ex)
                {
                    lblMessage.Text = "Image upload failed: " + ex.Message;
                    lblMessage.CssClass = "message error";
                    lblMessage.Visible = true;
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

        private bool ValidateForm()
        {
            if (string.IsNullOrEmpty(txtProductName.Text.Trim()))
            {
                ShowError("Product name is required.");
                return false;
            }

            if (ddlProductCategory.SelectedIndex == 0)
            {
                ShowError("Please select a category.");
                return false;
            }

            if (string.IsNullOrEmpty(txtProductDescription.Text.Trim()))
            {
                ShowError("Product description is required.");
                return false;
            }

            if (!decimal.TryParse(txtProductPrice.Text, out decimal price) || price <= 0)
            {
                ShowError("Please enter a valid price greater than 0.");
                return false;
            }

            if (!int.TryParse(txtProductStock.Text, out int stock) || stock < 0)
            {
                ShowError("Please enter a valid stock quantity.");
                return false;
            }

            return true;
        }

        private void ClearForm()
        {
            txtProductName.Text = "";
            ddlProductCategory.SelectedIndex = 0;
            txtProductDescription.Text = "";
            txtProductPrice.Text = "";
            txtProductStock.Text = "";
            cbProductActive.Checked = true;

            // Clear file upload and preview
            fileProductImage.Dispose();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "clearPreview", "document.getElementById('imagePreview').innerHTML = '<div class=\"image-placeholder\">No image selected</div>';", true);
        }

        private void ShowSuccess(string message)
        {
            lblMessage.Text = message;
            lblMessage.CssClass = "message success";
            lblMessage.Visible = true;
        }

        private void ShowError(string message)
        {
            lblMessage.Text = message;
            lblMessage.CssClass = "message error";
            lblMessage.Visible = true;
        }
    }
}