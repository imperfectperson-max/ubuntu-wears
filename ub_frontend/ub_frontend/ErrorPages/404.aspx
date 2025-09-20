<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="404.aspx.cs" Inherits="ub_frontend.ErrorPages._404" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Page Not Found
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
	<h1>404 - Page Not Found</h1>
    <p>The page you are looking for does not exist.</p>
    <a href="~/Default.aspx">Return to Home</a>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="ScriptContent" runat="server">
</asp:Content>
