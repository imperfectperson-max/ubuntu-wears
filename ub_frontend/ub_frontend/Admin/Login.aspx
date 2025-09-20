<%@ Page Title="Admin Login" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="ub_frontend.Admin.Login" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Ubuntu Wears - Admin Login
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <div class="admin-auth-container">
        <div class="admin-auth-header">
            <h1><i class="fas fa-user-shield"></i> Admin Login</h1>
            <p>Administrative dashboard access</p>
        </div>

        <div class="admin-auth-form">
            <asp:ScriptManager ID="ScriptManager1" runat="server" />

<asp:Panel ID="pnlLogin" runat="server" DefaultButton="btnLogin">
    <div class="form-group">
        <label for="txtEmail">Email Address</label>
        <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" placeholder="Admin email"></asp:TextBox>
        <asp:RequiredFieldValidator ID="rfvEmail" runat="server" 
            ControlToValidate="txtEmail"
            ErrorMessage="Email is required" 
            ForeColor="Red" 
            Display="Dynamic"
            ValidationGroup="LoginGroup" />
    </div>

    <div class="form-group">
        <label for="txtPassword">Password</label>
        <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" placeholder="Admin password"></asp:TextBox>
        <asp:RequiredFieldValidator ID="rfvPassword" runat="server" 
            ControlToValidate="txtPassword"
            ErrorMessage="Password is required" 
            ForeColor="Red" 
            Display="Dynamic"
            ValidationGroup="LoginGroup" />
    </div>

    <div class="form-options">
        <label class="checkbox">
            <asp:CheckBox ID="cbRememberMe" runat="server" />
            <span>Remember me</span>
        </label>
    </div>

    <asp:Button ID="btnLogin" runat="server" 
        Text="Login as Admin" 
        CssClass="btn-primary btn-full" 
        OnClick="btnLogin_Click"
        CausesValidation="true"
        ValidationGroup="LoginGroup" />

    <div class="admin-auth-footer">
        <p>Need admin access? 
            <asp:HyperLink ID="lnkContact" runat="server" NavigateUrl="~/Contact.aspx">Contact system administrator</asp:HyperLink>
        </p>
        <p>Regular user? 
            <asp:HyperLink ID="lnkUserLogin" runat="server" NavigateUrl="~/Login.aspx">User login</asp:HyperLink>
        </p>
    </div>
</asp:Panel>

        </div>
    </div>
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="ScriptContent" runat="server">
</asp:Content>
