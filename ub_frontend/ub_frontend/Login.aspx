<%@ Page Title="Customer Login" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="ub_frontend.Login" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Ubuntu Wears - Login
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <div class="auth-container">
        <div class="auth-header">
            <h1><i class="fas fa-user-circle"></i> Login</h1>
            <p>Welcome back to Ubuntu Wears</p>
        </div>

        <div class="auth-form">
            <asp:Panel ID="pnlLogin" runat="server" DefaultButton="btnLogin">
                <div class="form-group">
                    <label for="txtEmail">Email Address</label>
                    <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" placeholder="Enter your email" required="true"></asp:TextBox>
                </div>

                <div class="form-group">
                    <label for="txtPassword">Password</label>
                    <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" placeholder="Enter your password" required="true"></asp:TextBox>
                </div>

                <div class="form-options">
                    <label class="checkbox">
                        <asp:CheckBox ID="cbRememberMe" runat="server" />
                        <span>Remember me</span>
                    </label>
                    <asp:HyperLink ID="lnkForgotPassword" runat="server" NavigateUrl="~/ForgotPassword.aspx">Forgot Password?</asp:HyperLink>
                </div>

                <asp:Button ID="btnLogin" runat="server" Text="Login" CssClass="btn-primary btn-full" OnClick="btnLogin_Click" />
                
                <div class="auth-divider">
                    <span>or</span>
                </div>

                <div class="auth-footer">
                    <p>Don't have an account? <asp:HyperLink ID="lnkRegister" runat="server" NavigateUrl="~/Register.aspx">Sign up here</asp:HyperLink></p>
                </div>
            </asp:Panel>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="ScriptContent" runat="server">
</asp:Content>
