using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ub_frontend.UbuntuWearsReference;

namespace ub_frontend
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && Session["UserID"] != null)
            {
                Response.Redirect("~/Default.aspx");
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text;

            using (var client = new UbuntuWearsServiceClient())
            {
                var response = client.Login(email, password);
                if (response.Success && response.Data != null)
                {
                    // Store user information in session
                    Session["UserID"] = response.Data.UserID;
                    Session["UserName"] = response.Data.FirstName + " " + response.Data.LastName;
                    Session["UserEmail"] = response.Data.Email;
                    Session["UserType"] = response.Data.UserType;

                    // Check if user is admin
                    bool isAdmin = client.IsAdmin(response.Data.UserID);
                    Session["IsAdmin"] = isAdmin;

                    // Redirect based on user type or return URL
                    string returnUrl = Request.QueryString["returnUrl"];
                    if (!string.IsNullOrEmpty(returnUrl))
                    {
                        Response.Redirect(returnUrl);
                    }
                    else if (isAdmin)
                    {
                        Response.Redirect("~/Admin/Dashboard.aspx");
                    }
                    else
                    {
                        Response.Redirect("~/Default.aspx");
                    }
                }
                else
                {
                    ShowError("Invalid email or password. Please try again.");
                }
            }
        }

        private void ShowError(string message)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "LoginError",
                $"showNotification('{message}', 'error');", true);
        }
    }
}