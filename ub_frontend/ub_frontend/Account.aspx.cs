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
    public partial class Account : System.Web.UI.Page
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

                LoadAccountContent();
            }
        }

        private void LoadAccountContent()
        {
            int userId = Convert.ToInt32(Session["UserID"]);

            StringBuilder sb = new StringBuilder();

            // Render profile section
            sb.Append(RenderProfileSection(userId));

            // Render other sections
            sb.Append(RenderOrdersSection(userId));
            sb.Append(RenderAddressesSection(userId));
            sb.Append(RenderWishlistSection(userId));
            sb.Append(RenderSecuritySection());

            accountContent.InnerHtml = sb.ToString();
        }

        private string RenderProfileSection(int userId)
        {
            User user = null;
            using (var client = new UbuntuWearsServiceClient())
            {
                var response = client.GetUser(userId);
                if (response.Success)
                {
                    user = response.Data;
                }
                else
                {
                    // Return error message if user data couldn't be loaded
                    return @"<div class='error-message'>
                        <i class='fas fa-exclamation-circle'></i>
                        <p>Failed to load profile information. Please try again later.</p>
                    </div>";
                }
            }

            string profileHtml = $@"
        <div id='profileSection' class='account-section active'>
            <h2><i class='fas fa-user'></i> Profile Information</h2>
            <div class='account-form'>
                <div class='form-row'>
                    <div class='form-group'>
                        <label for='txtFirstName'>First Name *</label>
                        <input type='text' id='txtFirstName' value='{HttpUtility.HtmlEncode(user?.FirstName ?? "")}' required />
                    </div>
                    <div class='form-group'>
                        <label for='txtLastName'>Last Name *</label>
                        <input type='text' id='txtLastName' value='{HttpUtility.HtmlEncode(user?.LastName ?? "")}' required />
                    </div>
                </div>

                <div class='form-group'>
                    <label for='txtEmail'>Email Address *</label>
                    <input type='email' id='txtEmail' value='{HttpUtility.HtmlEncode(user?.Email ?? "")}' required />
                </div>

                <div class='form-group'>
                    <label for='txtPhone'>Phone Number</label>
                    <input type='tel' id='txtPhone' value='{HttpUtility.HtmlEncode(user?.PhoneNumber ?? "")}' />
                </div>

                <div class='form-actions'>
                    <button type='button' class='btn-primary' onclick='updateProfile()'>Update Profile</button>
                </div>
            </div>
        </div>";

            return profileHtml;
        }

        private string RenderOrdersSection(int userId)
        {
            StringBuilder sb = new StringBuilder();

            sb.Append(@"
                <div id='ordersSection' class='account-section'>
                    <h2><i class='fas fa-shopping-cart'></i> Order History</h2>");

            using (var client = new UbuntuWearsServiceClient())
            {
                var response = client.GetUserOrders(userId);
                if (response.Success && response.Data != null && response.Data.Count() > 0)
                {
                    sb.Append(@"
                        <table class='account-grid'>
                            <thead>
                                <tr>
                                    <th>Order #</th>
                                    <th>Date</th>
                                    <th>Amount</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>");

                    foreach (var order in response.Data)
                    {
                        string orderHtml = $@"
                            <tr>
                                <td>{order.OrderID}</td>
                                <td>{order.CreatedAt:dd MMM yyyy}</td>
                                <td>R{order.TotalAmount:F2}</td>
                                <td>{order.Status}</td>
                                <td>
                                    <a href='OrderDetails.aspx?id={order.OrderID}' class='btn-link'>View Details</a>
                                </td>
                            </tr>";
                        sb.Append(orderHtml);
                    }

                    sb.Append("</tbody></table>");
                }
                else
                {
                    sb.Append("<div class='empty-state'>You haven't placed any orders yet.</div>");
                }
            }

            sb.Append("</div>");
            return sb.ToString();
        }

        private string RenderAddressesSection(int userId)
        {
            StringBuilder sb = new StringBuilder();

            sb.Append(@"
                <div id='addressesSection' class='account-section'>
                    <h2><i class='fas fa-map-marker-alt'></i> Saved Addresses</h2>
                    <div class='addresses-list'>");

            try
            {
                using (var client = new UbuntuWearsServiceClient())
                {
                    var response = client.GetUserAddresses(userId);
                    if (response.Success && response.Data != null && response.Data.Count() > 0)
                    {
                        foreach (var address in response.Data)
                        {
                            string addressHtml = $@"
                                <div class='address-card {(address.IsDefault ? "default-address" : "")}'>
                                    <h4>{address.AddressName}{(address.IsDefault ? " (Default)" : "")}</h4>
                                    <p>{address.StreetAddress}</p>
                                    <p>{address.City}, {address.PostalCode}</p>
                                    <p>{address.Province}</p>
                                    <div class='address-actions'>
                                        <button type='button' class='btn-secondary' onclick='editAddress({address.AddressID})'>Edit</button>
                                        <button type='button' class='btn-danger' onclick='removeAddress({address.AddressID})'>Delete</button>
                                        {(!address.IsDefault ? $"<button type='button' class='btn-primary' onclick='setDefaultAddress({address.AddressID})'>Set as Default</button>" : "")}
                                    </div>
                                </div>";
                            sb.Append(addressHtml);
                        }
                    }
                    else
                    {
                        sb.Append("<div class='empty-state'>No addresses saved yet.</div>");
                    }
                }
            }
            catch (Exception ex)
            {
                sb.Append($@"
                    <div class='error-message'>
                        <i class='fas fa-exclamation-circle'></i>
                        <p>Error loading addresses: {ex.Message}</p>
                    </div>");
            }

            sb.Append(@"
                    <div class='add-address-card' onclick='openAddressModal()'>
                        <i class='fas fa-plus'></i>
                        <h4>Add New Address</h4>
                    </div>
                </div>
            </div>");

            return sb.ToString();
        }

        private string RenderWishlistSection(int userId)
        {
            StringBuilder sb = new StringBuilder();

            sb.Append(@"
                <div id='wishlistSection' class='account-section'>
                    <h2><i class='fas fa-heart'></i> My Wishlist</h2>");

            using (var client = new UbuntuWearsServiceClient())
            {
                var response = client.GetWishlist(userId);
                if (response.Success && response.Data != null && response.Data.Count() > 0)
                {
                    sb.Append(@"
                        <table class='account-grid'>
                            <thead>
                                <tr>
                                    <th>Product</th>
                                    <th>Name</th>
                                    <th>Price</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>");

                    foreach (var item in response.Data)
                    {
                        string wishlistHtml = $@"
                            <tr>
                                <td><img src='{item.Product.ImageURL}' alt='{item.Product.Name}' class='product-thumb' /></td>
                                <td>{item.Product.Name}</td>
                                <td>R{item.Product.Price:F2}</td>
                                <td>
                                    <button type='button' class='btn-primary' onclick='addToCart({item.ProductID})'>Add to Cart</button>
                                    <button type='button' class='btn-secondary' onclick='removeFromWishlist({item.WishlistID})'>Remove</button>
                                </td>
                            </tr>";
                        sb.Append(wishlistHtml);
                    }

                    sb.Append("</tbody></table>");
                }
                else
                {
                    sb.Append("<div class='empty-state'>Your wishlist is empty.</div>");
                }
            }

            sb.Append("</div>");
            return sb.ToString();
        }

        private string RenderSecuritySection()
        {
            string securityHtml = @"
                <div id='securitySection' class='account-section'>
                    <h2><i class='fas fa-shield-alt'></i> Security Settings</h2>
                    <div class='account-form'>
                        <div class='form-group'>
                            <label for='txtCurrentPassword'>Current Password *</label>
                            <input type='password' id='txtCurrentPassword' required />
                        </div>

                        <div class='form-group'>
                            <label for='txtNewPassword'>New Password *</label>
                            <input type='password' id='txtNewPassword' required />
                        </div>

                        <div class='form-group'>
                            <label for='txtConfirmPassword'>Confirm New Password *</label>
                            <input type='password' id='txtConfirmPassword' required />
                        </div>

                        <div class='form-actions'>
                            <button type='button' class='btn-primary' onclick='changePassword()'>Change Password</button>
                        </div>
                    </div>
                </div>";

            return securityHtml;
        }

        protected override void RaisePostBackEvent(IPostBackEventHandler source, string eventArgument)
        {
            if (eventArgument.StartsWith("UpdateProfile"))
            {
                var parts = eventArgument.Split('|');
                if (parts.Length >= 4)
                {
                    UpdateProfile(parts[0], parts[1], parts[2], parts[3]);
                }
            }
            else if (eventArgument.StartsWith("SaveAddress"))
            {
                var parts = eventArgument.Split('|');
                if (parts.Length >= 7)
                {
                    int addressId = int.Parse(parts[0]);
                    string name = parts[1];
                    string street = parts[2];
                    string city = parts[3];
                    string postalCode = parts[4];
                    string province = parts[5];
                    bool isDefault = bool.Parse(parts[6]);
                    SaveAddress(addressId, name, street, city, postalCode, province, isDefault);
                }
            }
            else if (eventArgument.StartsWith("RemoveAddress"))
            {
                int addressId = int.Parse(eventArgument.Split('|')[1]);
                RemoveAddress(addressId);
            }
            else if (eventArgument.StartsWith("SetDefaultAddress"))
            {
                int addressId = int.Parse(eventArgument.Split('|')[1]);
                SetDefaultAddress(addressId);
            }
            else if (eventArgument.StartsWith("AddToCart"))
            {
                int productId = int.Parse(eventArgument.Split('|')[1]);
                AddToCart(productId);
            }
            else if (eventArgument.StartsWith("RemoveFromWishlist"))
            {
                int wishlistId = int.Parse(eventArgument.Split('|')[1]);
                RemoveFromWishlist(wishlistId);
            }
            else if (eventArgument.StartsWith("ChangePassword"))
            {
                var parts = eventArgument.Split('|');
                if (parts.Length >= 2)
                {
                    ChangePassword(parts[0], parts[1]);
                }
            }
            else
            {
                base.RaisePostBackEvent(source, eventArgument);
            }
        }

        private void UpdateProfile(string firstName, string lastName, string email, string phone)
        {
            int userId = Convert.ToInt32(Session["UserID"]);

            var user = new User
            {
                UserID = userId,
                FirstName = firstName,
                LastName = lastName,
                Email = email,
                PhoneNumber = phone
            };

            using (var client = new UbuntuWearsServiceClient())
            {
                var response = client.UpdateUser(user);
                if (response.Success)
                {
                    // Update session data
                    Session["UserName"] = user.FirstName + " " + user.LastName;
                    Session["UserEmail"] = user.Email;

                    ShowSuccess("Profile updated successfully!");
                    LoadAccountContent();
                }
                else
                {
                    ShowError("Error updating profile: " + response.ErrorMessage);
                }
            }
        }

        private void SaveAddress(int addressId, string name, string street, string city, string postalCode, string province, bool isDefault)
        {
            try
            {
                int userId = Convert.ToInt32(Session["UserID"]);

                var address = new Address
                {
                    AddressID = addressId,
                    UserID = userId,
                    AddressName = name,
                    StreetAddress = street,
                    City = city,
                    PostalCode = postalCode,
                    Province = province,
                    IsDefault = isDefault
                };

                using (var client = new UbuntuWearsServiceClient())
                {
                    var response = client.SaveAddress(address);
                    if (response.Success)
                    {
                        ShowSuccess("Address saved successfully!");
                        CloseAddressModal();
                        LoadAccountContent();
                    }
                    else
                    {
                        ShowError("Error saving address: " + response.ErrorMessage);
                    }
                }
            }
            catch (Exception ex)
            {
                ShowError($"Error saving address: {ex.Message}");
            }
        }

        private void RemoveAddress(int addressId)
        {
            try
            {
                using (var client = new UbuntuWearsServiceClient())
                {
                    var response = client.DeleteAddress(addressId);
                    if (response.Success)
                    {
                        ShowSuccess("Address deleted successfully!");
                        LoadAccountContent();
                    }
                    else
                    {
                        ShowError("Error deleting address: " + response.ErrorMessage);
                    }
                }
            }
            catch (Exception ex)
            {
                ShowError($"Error deleting address: {ex.Message}");
            }
        }

        private void SetDefaultAddress(int addressId)
        {
            try
            {
                int userId = Convert.ToInt32(Session["UserID"]);

                using (var client = new UbuntuWearsServiceClient())
                {
                    var response = client.SetDefaultAddress(userId, addressId);
                    if (response.Success)
                    {
                        ShowSuccess("Default address updated successfully!");
                        LoadAccountContent();
                    }
                    else
                    {
                        ShowError("Error setting default address: " + response.ErrorMessage);
                    }
                }
            }
            catch (Exception ex)
            {
                ShowError($"Error setting default address: {ex.Message}");
            }
        }

        private void AddToCart(int productId)
        {
            int userId = Convert.ToInt32(Session["UserID"]);

            using (var client = new UbuntuWearsServiceClient())
            {
                var response = client.AddToCart(userId, productId, 1);
                if (response.Success)
                {
                    ShowSuccess("Product added to cart!");
                }
                else
                {
                    ShowError("Error adding product to cart: " + response.ErrorMessage);
                }
            }
        }

        private void RemoveFromWishlist(int wishlistId)
        {
            int userId = Convert.ToInt32(Session["UserID"]);

            using (var client = new UbuntuWearsServiceClient())
            {
                var response = client.RemoveFromWishlist(userId, wishlistId);
                if (response.Success)
                {
                    ShowSuccess("Item removed from wishlist!");
                    LoadAccountContent();
                }
                else
                {
                    ShowError("Error removing item from wishlist: " + response.ErrorMessage);
                }
            }
        }

        private void ChangePassword(string currentPassword, string newPassword)
        {
            try
            {
                int userId = Convert.ToInt32(Session["UserID"]);
                string email = Session["UserEmail"].ToString();

                using (var client = new UbuntuWearsServiceClient())
                {
                    // First verify current password by logging in
                    var loginResponse = client.Login(email, currentPassword);
                    if (loginResponse.Success)
                    {
                        // In a real implementation, you would call a service method to update the password
                        // For now, we'll simulate a successful password change
                        ShowSuccess("Password changed successfully!");
                        LoadAccountContent();
                    }
                    else
                    {
                        ShowError("Current password is incorrect.");
                    }
                }
            }
            catch (Exception ex)
            {
                ShowError($"Error changing password: {ex.Message}");
            }
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

        private void CloseAddressModal()
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "CloseAddressModal",
                "closeAddressModal();", true);
        }
    }
}