using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ub_frontend.UbuntuWearsReference;

namespace ub_frontend
{
    public partial class SiteMaster : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                UpdateCartCount();
                UpdateUserLinks();
                UpdateAdminMenu();
            }
        }

        private void UpdateAdminMenu()
        {
            // Check if user is admin and show/hide admin menu
            if (Session["IsAdmin"] != null && (bool)Session["IsAdmin"])
            {
                adminMenu.Visible = true;
            }
            else
            {
                adminMenu.Visible = false;
            }
        }

        public void UpdateCartCount()
        {
            if (Session["UserID"] != null)
            {
                int userId = Convert.ToInt32(Session["UserID"]);
                using (var client = new UbuntuWearsServiceClient())
                {
                    var response = client.GetCartItems(userId);
                    if (response.Success && response.Data != null)
                    {
                        //litCartCount.Text = response.Data.Count().ToString();
                    }
                }
            }
            else
            {
                // litCartCount.Text = "0";
            }
        }

        private void UpdateUserLinks()
        {
            if (Session["UserID"] != null)
            {
                // User is logged in
                lnkSignIn.Text = "<i class='fas fa-user'></i><span class='action-text'>My Account</span>";
                lnkSignIn.NavigateUrl = "~/Account.aspx";
                lnkRegister.Visible = false;
                lnkLogout.Visible = true;

                // Show user-specific menu items
                lnkOrders.Visible = true;
                // lnkWishlist.Visible = true;
            }
            else
            {
                // User is not logged in
                lnkSignIn.Text = "<i class='fas fa-user'></i><span class='action-text'>Sign In</span>";
                lnkSignIn.NavigateUrl = "~/Login.aspx";
                lnkRegister.Visible = true;
                lnkLogout.Visible = false;

                // Hide user-specific menu items
                lnkOrders.Visible = false;
                // lnkWishlist.Visible = false;
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            string searchTerm = txtSearch.Text.Trim();
            if (!string.IsNullOrEmpty(searchTerm))
            {
                Response.Redirect($"~/Products.aspx?search={Server.UrlEncode(searchTerm)}");
            }
        }
    }
}