using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ub_frontend.UbuntuWearsReference;

namespace ub_frontend
{
    public partial class Register : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && Session["UserID"] != null)
            {
                Response.Redirect("~/Default.aspx");
            }
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            // Server-side validation
            if (!Page.IsValid)
            {
                ShowError("Please fill in all required fields correctly.");
                return;
            }

            if (!cbTerms.Checked)
            {
                ShowError("Please accept the terms and conditions.");
                return;
            }

            var newUser = new User
            {
                FirstName = txtFirstName.Text.Trim(),
                LastName = txtLastName.Text.Trim(),
                Email = txtEmail.Text.Trim(),
                Username = txtEmail.Text.Trim(),
                PhoneNumber = txtPhone.Text.Trim(),
                UserType = "Customer"
            };

            try
            {
                using (var client = new UbuntuWearsServiceClient())
                {
                    var response = client.Register(newUser, txtPassword.Text);

                    if (response != null && response.Success && response.Data != null)
                    {
                        // Auto-login
                        Session["UserID"] = response.Data.UserID;
                        Session["UserName"] = $"{response.Data.FirstName} {response.Data.LastName}";
                        Session["UserEmail"] = response.Data.Email;
                        Session["UserType"] = response.Data.UserType;

                        ShowSuccess("Account created successfully! Redirecting...");
                        Response.AddHeader("REFRESH", "2;URL=Default.aspx");
                    }
                    else
                    {
                        ShowError(response?.ErrorMessage ?? "Registration failed. Please try again.");
                    }
                }
            }
            catch (Exception ex)
            {
                ShowError("An error occurred: " + ex.Message);
            }
        }

        private void ShowError(string message)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "RegisterError",
                $"alert('{message}');", true);
        }

        private void ShowSuccess(string message)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "RegisterSuccess",
                $"alert('{message}');", true);
        }
    }
}