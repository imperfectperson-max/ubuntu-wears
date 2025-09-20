<%@ Page Title="Register" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="ub_frontend.Register" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Ubuntu Wears - Register
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <div class="auth-container">
        <div class="auth-header">
            <h1><i class="fas fa-user-plus"></i> Create Account</h1>
            <p>Join the Ubuntu Wears community</p>
        </div>

        <div class="auth-form">
            <asp:Panel ID="pnlRegister" runat="server" DefaultButton="btnRegister">

                <div class="form-row">
                    <div class="form-group">
                        <label for="txtFirstName">First Name</label>
                        <asp:TextBox ID="txtFirstName" runat="server" placeholder="First name"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvFirstName" runat="server" ControlToValidate="txtFirstName" 
                            ErrorMessage="First name is required" ForeColor="Red">*</asp:RequiredFieldValidator>
                    </div>
                    <div class="form-group">
                        <label for="txtLastName">Last Name</label>
                        <asp:TextBox ID="txtLastName" runat="server" placeholder="Last name"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvLastName" runat="server" ControlToValidate="txtLastName" 
                            ErrorMessage="Last name is required" ForeColor="Red">*</asp:RequiredFieldValidator>
                    </div>
                </div>

                <div class="form-group">
                    <label for="txtEmail">Email Address</label>
                    <asp:TextBox ID="txtEmail" runat="server" placeholder="Enter your email"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail"
                        ErrorMessage="Email is required" ForeColor="Red">*</asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="txtEmail"
                        ValidationExpression="^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$"
                        ErrorMessage="Enter a valid email" ForeColor="Red">*</asp:RegularExpressionValidator>
                </div>

                <div class="form-group">
                    <label for="txtPassword">Password</label>
                    <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" placeholder="Create a password"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ControlToValidate="txtPassword"
                        ErrorMessage="Password is required" ForeColor="Red">*</asp:RequiredFieldValidator>
                </div>

                <div class="form-group">
                    <label for="txtConfirmPassword">Confirm Password</label>
                    <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" placeholder="Confirm your password"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvConfirmPassword" runat="server" ControlToValidate="txtConfirmPassword"
                        ErrorMessage="Confirm password is required" ForeColor="Red">*</asp:RequiredFieldValidator>
                    <asp:CompareValidator ID="cvPasswords" runat="server" ControlToCompare="txtPassword" ControlToValidate="txtConfirmPassword"
                        ErrorMessage="Passwords do not match" ForeColor="Red">*</asp:CompareValidator>
                </div>

                <div class="form-group">
                    <label for="txtPhone">Phone Number</label>
                    <asp:TextBox ID="txtPhone" runat="server" placeholder="Phone number"></asp:TextBox>
                    <asp:RegularExpressionValidator ID="revPhone" runat="server" ControlToValidate="txtPhone"
                        ValidationExpression="^\+?\d{7,15}$"
                        ErrorMessage="Enter a valid phone number" ForeColor="Red" Display="Dynamic"></asp:RegularExpressionValidator>
                </div>

                <div class="form-group">
                    <label class="checkbox">
                        <asp:CheckBox ID="cbTerms" runat="server" />
                        <span>I agree to the <a href="Terms.aspx">Terms and Conditions</a></span>
                    </label>
                </div>

                <asp:Button ID="btnRegister" runat="server" Text="Create Account" CssClass="btn-primary btn-full" OnClick="btnRegister_Click" />

                <div class="auth-footer">
                    <p>Already have an account? <asp:HyperLink ID="lnkLogin" runat="server" NavigateUrl="~/Login.aspx">Login here</asp:HyperLink></p>
                </div>

            </asp:Panel>
        </div>
    </div>
</asp:Content>


<asp:Content ID="Content4" ContentPlaceHolderID="ScriptContent" runat="server">
</asp:Content>
