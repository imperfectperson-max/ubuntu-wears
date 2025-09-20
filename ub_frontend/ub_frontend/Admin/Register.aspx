<%@ Page Title="Admin Register" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="ub_frontend.Admin.Register" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Ubuntu Wears - Admin Regsiter
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <div class="admin-auth-container">
        <div class="admin-auth-header">
            <h1><i class="fas fa-user-shield"></i> Admin Registration</h1>
            <p>Create administrator account for Ubuntu Wears</p>
        </div>

        <div class="admin-auth-form">
            <asp:Panel ID="pnlRegister" runat="server" DefaultButton="btnRegister">

    <!-- Validation Summary -->
    <asp:ValidationSummary ID="vsRegisterSummary" runat="server" 
        ValidationGroup="RegisterGroup"
        ShowSummary="true"
        ShowMessageBox="false"
        ForeColor="Red"
        HeaderText="Please fix the following errors:" />

    <div class="form-row">
        <div class="form-group">
            <label for="txtFirstName">First Name *</label>
            <asp:TextBox ID="txtFirstName" runat="server" placeholder="First name"></asp:TextBox>
            <asp:RequiredFieldValidator ID="rfvFirstName" runat="server" 
                ControlToValidate="txtFirstName"
                ErrorMessage="First name is required" ForeColor="Red"
                ValidationGroup="RegisterGroup">*</asp:RequiredFieldValidator>
        </div>
        <div class="form-group">
            <label for="txtLastName">Last Name *</label>
            <asp:TextBox ID="txtLastName" runat="server" placeholder="Last name"></asp:TextBox>
            <asp:RequiredFieldValidator ID="rfvLastName" runat="server" 
                ControlToValidate="txtLastName"
                ErrorMessage="Last name is required" ForeColor="Red"
                ValidationGroup="RegisterGroup">*</asp:RequiredFieldValidator>
        </div>
    </div>

    <div class="form-group">
        <label for="txtEmail">Email Address *</label>
        <asp:TextBox ID="txtEmail" runat="server" placeholder="Admin email"></asp:TextBox>
        <asp:RequiredFieldValidator ID="rfvEmail" runat="server" 
            ControlToValidate="txtEmail"
            ErrorMessage="Email is required" ForeColor="Red"
            ValidationGroup="RegisterGroup">*</asp:RequiredFieldValidator>
        <asp:RegularExpressionValidator ID="revEmail" runat="server" 
            ControlToValidate="txtEmail"
            ValidationExpression="^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$"
            ErrorMessage="Enter a valid email" ForeColor="Red"
            ValidationGroup="RegisterGroup">*</asp:RegularExpressionValidator>
    </div>

    <div class="form-group">
        <label for="txtUsername">Username *</label>
        <asp:TextBox ID="txtUsername" runat="server" placeholder="Admin username"></asp:TextBox>
        <asp:RequiredFieldValidator ID="rfvUsername" runat="server" 
            ControlToValidate="txtUsername"
            ErrorMessage="Username is required" ForeColor="Red"
            ValidationGroup="RegisterGroup">*</asp:RequiredFieldValidator>
    </div>

    <div class="form-group">
        <label for="txtPassword">Password *</label>
        <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" placeholder="Create secure password"></asp:TextBox>
        <asp:RequiredFieldValidator ID="rfvPassword" runat="server" 
            ControlToValidate="txtPassword"
            ErrorMessage="Password is required" ForeColor="Red"
            ValidationGroup="RegisterGroup">*</asp:RequiredFieldValidator>
    </div>

    <div class="form-group">
        <label for="txtConfirmPassword">Confirm Password *</label>
        <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" placeholder="Confirm password"></asp:TextBox>
        <asp:RequiredFieldValidator ID="rfvConfirmPassword" runat="server" 
            ControlToValidate="txtConfirmPassword"
            ErrorMessage="Confirm password is required" ForeColor="Red"
            ValidationGroup="RegisterGroup">*</asp:RequiredFieldValidator>
        <asp:CompareValidator ID="cvPasswords" runat="server" 
            ControlToCompare="txtPassword" ControlToValidate="txtConfirmPassword"
            ErrorMessage="Passwords do not match" ForeColor="Red"
            ValidationGroup="RegisterGroup">*</asp:CompareValidator>
    </div>

    <div class="form-group">
        <label for="txtPhone">Phone Number</label>
        <asp:TextBox ID="txtPhone" runat="server" placeholder="Phone number"></asp:TextBox>
        <asp:RegularExpressionValidator ID="revPhone" runat="server" 
            ControlToValidate="txtPhone"
            ValidationExpression="^\+?\d{7,15}$"
            ErrorMessage="Enter a valid phone number" ForeColor="Red" Display="Dynamic"
            ValidationGroup="RegisterGroup"></asp:RegularExpressionValidator>
    </div>

    <div class="form-group">
        <label for="txtAdminCode">Admin Authorization Code *</label>
        <asp:TextBox ID="txtAdminCode" runat="server" TextMode="Password" placeholder="Enter admin authorization code"></asp:TextBox>
        <asp:RequiredFieldValidator ID="rfvAdminCode" runat="server" 
            ControlToValidate="txtAdminCode"
            ErrorMessage="Authorization code is required" ForeColor="Red"
            ValidationGroup="RegisterGroup">*</asp:RequiredFieldValidator>
        <small class="form-help">Contact system administrator for authorization code</small>
    </div>

    <div class="form-group">
        <label class="checkbox">
            <asp:CheckBox ID="cbTerms" runat="server" />
            <span>I agree to the <a href="../Terms.aspx">Terms and Conditions</a> and understand admin privileges</span>
        </label>
    </div>

    <asp:Button ID="btnRegister" runat="server" 
        Text="Create Admin Account" 
        CssClass="btn-primary btn-full" 
        OnClick="btnRegister_Click"
        CausesValidation="true"
        ValidationGroup="RegisterGroup" />

    <div class="admin-auth-footer">
        <p>Already have an admin account? 
            <asp:HyperLink ID="lnkLogin" runat="server" NavigateUrl="~/Admin/Login.aspx">Login here</asp:HyperLink>
        </p>
        <p>Regular user? 
            <asp:HyperLink ID="lnkUserRegister" runat="server" NavigateUrl="~/Register.aspx">User registration</asp:HyperLink>
        </p>
    </div>

</asp:Panel>

        </div>
    </div>
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="ScriptContent" runat="server">
</asp:Content>
