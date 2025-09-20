<%@ Page Title="Admin Orders" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Orders.aspx.cs" Inherits="ub_frontend.Admin.Orders" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Ubuntu Wears - Manage Orders
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <div class="admin-container">
        <h2>Manage Orders</h2>
        
        <div class="admin-controls">
            <asp:DropDownList ID="ddlStatusFilter" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlStatusFilter_SelectedIndexChanged" CssClass="filter-dropdown">
                <asp:ListItem Value="">All Statuses</asp:ListItem>
                <asp:ListItem Value="Processing">Processing</asp:ListItem>
                <asp:ListItem Value="Shipped">Shipped</asp:ListItem>
                <asp:ListItem Value="Delivered">Delivered</asp:ListItem>
                <asp:ListItem Value="Cancelled">Cancelled</asp:ListItem>
            </asp:DropDownList>
        </div>

        <div id="ordersContainer" runat="server" class="orders-grid">
            <!-- Orders will be dynamically populated here -->
        </div>

        <asp:Label ID="lblMessage" runat="server" CssClass="message" Visible="false"></asp:Label>
    </div>
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="ScriptContent" runat="server">
    <style>
        .admin-container {
            padding: 20px;
            max-width: 1400px;
            margin: 0 auto;
        }
        
        .admin-controls {
            margin-bottom: 20px;
        }
        
        .filter-dropdown {
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
            margin-right: 10px;
        }
        
        .orders-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }
        
        .order-card {
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 15px;
            background-color: #fff;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        .order-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 1px solid #eee;
        }
        
        .order-id {
            font-weight: bold;
            color: #6c757d;
        }
        
        .order-date {
            font-size: 12px;
            color: #6c757d;
        }
        
        .order-customer {
            font-size: 16px;
            font-weight: bold;
            margin-bottom: 5px;
        }
        
        .order-amount {
            font-size: 18px;
            font-weight: bold;
            color: #28a745;
            margin-bottom: 10px;
        }
        
        .order-status {
            display: inline-block;
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: bold;
            margin-bottom: 10px;
        }
        
        .status-processing {
            background-color: #fff3cd;
            color: #856404;
        }
        
        .status-shipped {
            background-color: #d1ecf1;
            color: #0c5460;
        }
        
        .status-delivered {
            background-color: #d4edda;
            color: #155724;
        }
        
        .status-cancelled {
            background-color: #f8d7da;
            color: #721c24;
        }
        
        .order-payment {
            font-size: 14px;
            margin-bottom: 10px;
        }
        
        .order-actions {
            display: flex;
            gap: 10px;
            margin-top: 15px;
        }
        
        .btn {
            padding: 6px 12px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
        }
        
        .btn-info {
            background-color: #17a2b8;
            color: white;
        }
        
        .status-dropdown {
            padding: 6px;
            border: 1px solid #ddd;
            border-radius: 4px;
            width: 100%;
            margin-bottom: 10px;
        }
        
        .message {
            margin-top: 20px;
            padding: 10px;
            border-radius: 4px;
            background-color: #f8d7da;
            color: #721c24;
        }
        
        .empty-data {
            text-align: center;
            padding: 40px;
            color: #6c757d;
            font-style: italic;
            grid-column: 1 / -1;
        }
    </style>

    <script>
        function updateOrderStatus(orderId, selectElement) {
            const newStatus = selectElement.value;

            // Use PageMethods or hidden field approach instead of __doPostBack
            __doPostBack('', 'UPDATE_STATUS|' + orderId + '|' + newStatus);
        }

        function viewOrderDetails(orderId) {
            window.location.href = 'OrderDetails.aspx?id=' + orderId;
        }
    </script>
</asp:Content>