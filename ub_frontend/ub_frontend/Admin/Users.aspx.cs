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
    public partial class Users : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            if (!IsAdminAuthenticated())
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadUsers();
            }
        }

        private bool IsAdminAuthenticated()
        {
            return Session["IsAdmin"] != null && (bool)Session["IsAdmin"];
        }

        private void LoadUsers()
        {
            try
            {
                using (var client = new UbuntuWearsServiceClient())
                {
                    var response = client.GetUsers();
                    if (response.Success && response.Data != null)
                    {
                        RenderUsers(response.Data.ToList());
                    }
                    else
                    {
                        ShowError("Error loading users: " + response.ErrorMessage);
                    }
                }
            }
            catch (Exception ex)
            {
                ShowError("Error loading users: " + ex.Message);
            }
        }

        private void RenderUsers(List<UserEntity> users)
        {
            StringBuilder sb = new StringBuilder();

            // Filter users based on search
            string searchTerm = txtSearchUsers.Text.Trim().ToLower();
            var filteredUsers = users;

            if (!string.IsNullOrEmpty(searchTerm))
            {
                filteredUsers = users.Where(u =>
                    u.FirstName.ToLower().Contains(searchTerm) ||
                    u.LastName.ToLower().Contains(searchTerm) ||
                    u.Email.ToLower().Contains(searchTerm) ||
                    u.Username.ToLower().Contains(searchTerm) ||
                    u.UserType.ToLower().Contains(searchTerm)
                ).ToList();
            }

            if (filteredUsers.Count == 0)
            {
                sb.Append("<tr><td colspan='7' class='empty-data'>No users found.</td></tr>");
            }
            else
            {
                foreach (var user in filteredUsers)
                {
                    string userTypeClass = user.UserType == "Admin" ? "user-type-admin" : "user-type-customer";

                    string userHtml = $@"
    <tr>
        <td>{user.UserID}</td>
        <td>{HttpUtility.HtmlEncode(user.FirstName)} {HttpUtility.HtmlEncode(user.LastName)}</td>
        <td>{HttpUtility.HtmlEncode(user.Username)}</td>
        <td>{HttpUtility.HtmlEncode(user.Email)}</td>
        <td>{HttpUtility.HtmlEncode(user.PhoneNumber)}</td>
        <td><span class='user-type {userTypeClass}'>{user.UserType}</span></td>
        <td>{user.DataCreated:yyyy-MM-dd}</td>
        <td class='user-actions'>
            <a href='UserDetails.aspx?id={user.UserID}' class='btn btn-view' title='View Details'>
                <i class='fas fa-eye'></i>
            </a>
            <a href='EditUser.aspx?id={user.UserID}' class='btn btn-edit' title='Edit User'>
                <i class='fas fa-edit'></i>
            </a>
            <a href='DeleteUser.aspx?id={user.UserID}' class='btn btn-delete' title='Delete User' 
               onclick='return confirmDelete({user.UserID}, ""{HttpUtility.JavaScriptStringEncode(user.FirstName + " " + user.LastName)}"")'>
                <i class='fas fa-trash'></i>
            </a>
        </td>
    </tr>";


                    sb.Append(userHtml);
                }
}

string tableHtml = $@"
                <table class='users-table'>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Username</th>
                            <th>Email</th>
                            <th>Phone</th>
                            <th>Type</th>
                            <th>Joined</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        {sb.ToString()}
                    </tbody>
                </table>";

usersContainer.InnerHtml = tableHtml;
        }

        protected void btnSearch_Click(object sender, EventArgs e)
{
    LoadUsers();
}

protected void btnClear_Click(object sender, EventArgs e)
{
    txtSearchUsers.Text = "";
    LoadUsers();
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