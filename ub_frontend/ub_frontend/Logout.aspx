<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Logout.aspx.cs" Inherits="ub_frontend.Logout" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Logout - Ubuntu Wears
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div style="text-align: center; padding: 100px;">
        <h2>Logging out...</h2>
        <p>Please wait while we securely log you out.</p>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ScriptContent" runat="server">
    <script>
        // Redirect immediately after page loads
        window.onload = function() {
            setTimeout(function() {
                window.location.href = 'Default.aspx';
            }, 1000); // 1 second delay
        };
    </script>
</asp:Content>