using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ub_frontend.UbuntuWearsReference;

namespace ub_frontend.Admin
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            
            if (!IsPostBack && Session["IsAdmin"] != null && (bool)Session["IsAdmin"])
            {
                Response.Redirect("~/Admin/Dashboard.aspx");
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text;

            try
            {
                using (var client = new UbuntuWearsServiceClient())
                {
                    var response = client.Login(email, password);
                    if (response.Success && response.Data != null)
                    {
                        // Store user information in session first
                        Session["UserID"] = response.Data.UserID;
                        Session["UserName"] = response.Data.FirstName + " " + response.Data.LastName;
                        Session["UserEmail"] = response.Data.Email;
                        Session["UserType"] = response.Data.UserType;

                        // Check if user is admin
                        bool isAdmin = client.IsAdmin(response.Data.UserID);

                        if (!isAdmin)
                        {
                            ShowError("Access denied. Admin privileges required.");
                            // Clear admin session if any
                            Session["IsAdmin"] = false;
                            return;
                        }

                        Session["IsAdmin"] = true;
                        Response.Redirect("~/Admin/Dashboard.aspx");
                    }
                    else
                    {
                        ShowError("Invalid email or password. Please try again.");
                    }
                }
            }
            catch (Exception ex)
            {
                ShowError("An error occurred while logging in: " + ex.Message);
            }
        }

        private void ShowError(string message)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "LoginError",
                $"alert('{message.Replace("'", "\\'")}');", true);
        }
    }
}