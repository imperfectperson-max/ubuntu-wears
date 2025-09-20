using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ub_frontend.UbuntuWearsReference;

namespace ub_frontend.Admin
{
    public partial class Discount : System.Web.UI.Page
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
                LoadDiscounts();
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
                            int toggleDiscountId = Convert.ToInt32(eventArgument);
                            ToggleDiscountStatus(toggleDiscountId);
                            break;
                        case "EditDiscount":
                            int editDiscountId = Convert.ToInt32(eventArgument);
                            LoadDiscountForEdit(editDiscountId);
                            break;
                        case "DeleteDiscount":
                            int deleteDiscountId = Convert.ToInt32(eventArgument);
                            DeleteDiscount(deleteDiscountId);
                            break;
                    }
                }
            }
        }

        private bool IsAdminAuthenticated()
        {
            return Session["IsAdmin"] != null && (bool)Session["IsAdmin"];
        }

        private void LoadDiscounts()
        {
            try
            {
                // Check cache first
                var cachedDiscounts = Cache["AdminDiscounts"] as List<DiscountA>;
                if (cachedDiscounts != null)
                {
                    RenderDiscounts(cachedDiscounts);
                    return;
                }

                using (var client = new UbuntuWearsServiceClient())
                {
                    var response = client.GetAllDiscounts();
                    if (response.Success)
                    {
                        var discounts = response.Data.ToList();
                        // Cache for 2 minutes
                        Cache.Insert("AdminDiscounts", discounts, null,
                            DateTime.Now.AddMinutes(2), TimeSpan.Zero);
                        RenderDiscounts(discounts);
                    }
                    else
                    {
                        ShowError("Error loading discounts: " + response.ErrorMessage);
                    }
                }
            }
            catch (Exception ex)
            {
                ShowError($"Error loading discounts: {ex.Message}");
            }
        }

        private void RenderDiscounts(List<DiscountA> discounts)
        {
            string html = @"
            <table class='admin-grid'>
                <thead>
                    <tr>
                        <th>Discount Code</th>
                        <th>Description</th>
                        <th>Type</th>
                        <th>Value</th>
                        <th>Min Order</th>
                        <th>Max Uses</th>
                        <th>Used</th>
                        <th>Start Date</th>
                        <th>End Date</th>
                        <th>Active</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>";

            if (discounts != null && discounts.Count > 0)
            {
                foreach (var discount in discounts)
                {
                    string valueDisplay = discount.DiscountType == "Percentage" ? $"{discount.DiscountValue}%" : $"R{discount.DiscountValue:F2}";
                    string minOrderDisplay = discount.MinOrderAmount > 0 ? $"R{discount.MinOrderAmount:F2}" : "None";
                    string maxUsesDisplay = discount.MaxUses > 0 ? discount.MaxUses.ToString() : "Unlimited";

                    html += $@"
                        <tr>
                            <td><strong>{HttpUtility.HtmlEncode(discount.Code)}</strong></td>
                            <td>{HttpUtility.HtmlEncode(discount.Description)}</td>
                            <td>{HttpUtility.HtmlEncode(discount.DiscountType)}</td>
                            <td>{HttpUtility.HtmlEncode(valueDisplay)}</td>
                            <td>{HttpUtility.HtmlEncode(minOrderDisplay)}</td>
                            <td>{HttpUtility.HtmlEncode(maxUsesDisplay)}</td>
                            <td>{discount.UsedCount}</td>
                            <td>{discount.StartDate:dd MMM yyyy}</td>
                            <td>{discount.EndDate:dd MMM yyyy}</td>
                            <td>{(discount.IsActive ? "Yes" : "No")}</td>
                            <td>
                                <a href='javascript:void(0)' class='grid-action' onclick='editDiscount({discount.DiscountID})'>Edit</a>
                                <a href='javascript:void(0)' class='grid-action' onclick='toggleDiscountStatus({discount.DiscountID})'>
                                    {(discount.IsActive ? "Deactivate" : "Activate")}
                                </a>
                                <a href='javascript:void(0)' class='grid-action delete' onclick='deleteDiscount({discount.DiscountID})'>Delete</a>
                            </td>
                        </tr>";
                }
            }
            else
            {
                html += @"
                    <tr>
                        <td colspan='11' class='no-data'>No discounts found. Click 'Add New Discount' to create one.</td>
                    </tr>";
            }

            html += @"
                </tbody>
            </table>";

            discountsContainer.InnerHtml = html;
        }

        protected void btnAddDiscount_Click(object sender, EventArgs e)
        {
            litModalTitle.Text = "Add New Discount";
            hfDiscountId.Value = "0";
            ClearDiscountForm();
            ScriptManager.RegisterStartupScript(this, GetType(), "OpenDiscountModal", "setTimeout(function() { openDiscountModal(); }, 100);", true);
        }

        private void LoadDiscountForEdit(int discountId)
        {
            try
            {
                using (var client = new UbuntuWearsServiceClient())
                {
                    var response = client.GetDiscount(discountId);
                    if (response.Success)
                    {
                        litModalTitle.Text = "Edit Discount";
                        hfDiscountId.Value = discountId.ToString();

                        txtDiscountCode.Text = HttpUtility.HtmlDecode(response.Data.Code);
                        txtDiscountDescription.Text = HttpUtility.HtmlDecode(response.Data.Description);
                        ddlDiscountType.SelectedValue = response.Data.DiscountType;
                        txtDiscountValue.Text = response.Data.DiscountValue.ToString("F2");
                        txtMinOrderAmount.Text = response.Data.MinOrderAmount.ToString("F2");
                        txtMaxUses.Text = response.Data.MaxUses.ToString();
                        txtStartDate.Text = response.Data.StartDate.ToString("yyyy-MM-dd");
                        txtEndDate.Text = response.Data.EndDate.ToString("yyyy-MM-dd");
                        cbDiscountActive.Checked = response.Data.IsActive;

                        ScriptManager.RegisterStartupScript(this, GetType(), "OpenDiscountModal", "setTimeout(function() { openDiscountModal(); }, 100);", true);
                    }
                    else
                    {
                        ShowError("Error loading discount: " + response.ErrorMessage);
                    }
                }
            }
            catch (Exception ex)
            {
                ShowError($"Error loading discount: {ex.Message}");
            }
        }

        private void ToggleDiscountStatus(int discountId)
        {
            try
            {
                using (var client = new UbuntuWearsServiceClient())
                {
                    var response = client.ToggleDiscountStatus(discountId);
                    if (response.Success)
                    {
                        // Clear cache
                        Cache.Remove("AdminDiscounts");
                        ShowSuccess("Discount status updated successfully.");
                        LoadDiscounts();
                    }
                    else
                    {
                        ShowError("Error updating discount status: " + response.ErrorMessage);
                    }
                }
            }
            catch (Exception ex)
            {
                ShowError($"Error updating discount status: {ex.Message}");
            }
        }

        private void DeleteDiscount(int discountId)
        {
            try
            {
                using (var client = new UbuntuWearsServiceClient())
                {
                    var response = client.DeleteDiscount(discountId);
                    if (response.Success)
                    {
                        // Clear cache
                        Cache.Remove("AdminDiscounts");
                        ShowSuccess("Discount deleted successfully.");
                        LoadDiscounts();
                    }
                    else
                    {
                        ShowError("Error deleting discount: " + response.ErrorMessage);
                    }
                }
            }
            catch (Exception ex)
            {
                ShowError($"Error deleting discount: {ex.Message}");
            }
        }

        protected void btnSaveDiscount_Click(object sender, EventArgs e)
        {
            if (!ValidateDiscountForm())
            {
                ShowError("Please fill in all required fields correctly.");
                return;
            }

            try
            {
                var discount = new DiscountA
                {
                    DiscountID = Convert.ToInt32(hfDiscountId.Value),
                    Code = HttpUtility.HtmlEncode(txtDiscountCode.Text.Trim()),
                    Description = HttpUtility.HtmlEncode(txtDiscountDescription.Text.Trim()),
                    DiscountType = ddlDiscountType.SelectedValue,
                    DiscountValue = Convert.ToDecimal(txtDiscountValue.Text),
                    MinOrderAmount = string.IsNullOrEmpty(txtMinOrderAmount.Text) ? 0 : Convert.ToDecimal(txtMinOrderAmount.Text),
                    MaxUses = string.IsNullOrEmpty(txtMaxUses.Text) ? 0 : Convert.ToInt32(txtMaxUses.Text),
                    StartDate = Convert.ToDateTime(txtStartDate.Text),
                    EndDate = Convert.ToDateTime(txtEndDate.Text),
                    IsActive = cbDiscountActive.Checked
                };

                using (var client = new UbuntuWearsServiceClient())
                {
                    ServiceResponse response;

                    if (discount.DiscountID == 0)
                    {
                        response = client.CreateDiscount(discount);
                    }
                    else
                    {
                        response = client.UpdateDiscount(discount);
                    }

                    if (response.Success)
                    {
                        // Clear cache
                        Cache.Remove("AdminDiscounts");
                        ShowSuccess($"Discount {(discount.DiscountID == 0 ? "created" : "updated")} successfully.");
                        ScriptManager.RegisterStartupScript(this, GetType(), "CloseDiscountModal", "closeDiscountModal();", true);
                        LoadDiscounts();
                    }
                    else
                    {
                        ShowError($"Error saving discount: {response.ErrorMessage}");
                    }
                }
            }
            catch (Exception ex)
            {
                ShowError($"Error saving discount: {ex.Message}");
            }
        }

        private bool ValidateDiscountForm()
        {
            // Basic validation
            if (string.IsNullOrEmpty(txtDiscountCode.Text) ||
                ddlDiscountType.SelectedIndex == 0 ||
                string.IsNullOrEmpty(txtDiscountValue.Text) ||
                string.IsNullOrEmpty(txtStartDate.Text) ||
                string.IsNullOrEmpty(txtEndDate.Text))
            {
                return false;
            }

            // Date validation
            DateTime startDate, endDate;
            if (!DateTime.TryParse(txtStartDate.Text, out startDate) ||
                !DateTime.TryParse(txtEndDate.Text, out endDate))
            {
                return false;
            }

            if (endDate <= startDate)
            {
                return false;
            }

            // Discount value validation
            decimal discountValue;
            if (!decimal.TryParse(txtDiscountValue.Text, out discountValue) || discountValue <= 0)
            {
                return false;
            }

            if (ddlDiscountType.SelectedValue == "Percentage" && discountValue > 100)
            {
                return false;
            }

            // Max uses validation
            if (!string.IsNullOrEmpty(txtMaxUses.Text) &&
                (!int.TryParse(txtMaxUses.Text, out int maxUses) || maxUses < 0))
            {
                return false;
            }

            // Min order amount validation
            if (!string.IsNullOrEmpty(txtMinOrderAmount.Text) &&
                (!decimal.TryParse(txtMinOrderAmount.Text, out decimal minOrder) || minOrder < 0))
            {
                return false;
            }

            return true;
        }

        private void ClearDiscountForm()
        {
            txtDiscountCode.Text = "";
            txtDiscountDescription.Text = "";
            ddlDiscountType.SelectedIndex = 0;
            txtDiscountValue.Text = "";
            txtMinOrderAmount.Text = "";
            txtMaxUses.Text = "";
            txtStartDate.Text = "";
            txtEndDate.Text = "";
            cbDiscountActive.Checked = true;
        }

        private void ShowSuccess(string message)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "SuccessMessage",
                $"showNotification('{HttpUtility.JavaScriptStringEncode(message)}', 'success');", true);
        }

        private void ShowError(string message)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "ErrorMessage",
                $"showNotification('{HttpUtility.JavaScriptStringEncode(message)}', 'error');", true);
        }
    }
}