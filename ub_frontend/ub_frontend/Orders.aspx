<%@ Page Title="Manage Orders" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Orders.aspx.cs" Inherits="ub_frontend.Orders1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Ubuntu Wears - My Orders
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .orders-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        
        .orders-header {
            text-align: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid #e9ecef;
        }
        
        .orders-header h1 {
            color: #2c3e50;
            margin-bottom: 10px;
        }
        
        .orders-filter {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            margin-bottom: 30px;
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
        }
        
        .filter-btn {
            padding: 10px 20px;
            border: 2px solid #3498db;
            background: white;
            color: #3498db;
            border-radius: 6px;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .filter-btn:hover, .filter-btn.active {
            background: #3498db;
            color: white;
        }
        
        .orders-content {
            margin-bottom: 40px;
        }
        
        .orders-list {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }
        
        .order-card {
            background: white;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        
        .order-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 15px rgba(0,0,0,0.15);
        }
        
        .order-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
            padding-bottom: 15px;
            border-bottom: 1px solid #e9ecef;
        }
        
        .order-info {
            display: flex;
            flex-direction: column;
            gap: 5px;
        }
        
        .order-status {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .status-badge {
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
            text-transform: uppercase;
        }
        
        .status-processing {
            background-color: #fff3cd;
            color: #856404;
            border: 1px solid #ffeaa7;
        }
        
        .status-shipped {
            background-color: #d1ecf1;
            color: #0c5460;
            border: 1px solid #bee5eb;
        }
        
        .status-delivered {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        
        .status-cancelled {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        .status-unknown {
            background-color: #e2e3e5;
            color: #383d41;
            border: 1px solid #d6d8db;
        }
        
        .order-items {
            margin-bottom: 15px;
        }
        
        .order-item {
            display: flex;
            align-items: center;
            gap: 15px;
            padding: 10px 0;
            border-bottom: 1px solid #f8f9fa;
        }
        
        .order-item:last-child {
            border-bottom: none;
        }
        
        .order-item img {
            width: 60px;
            height: 60px;
            object-fit: cover;
            border-radius: 6px;
        }
        
        .item-info {
            flex: 1;
        }
        
        .item-info h4 {
            margin: 0 0 5px 0;
            color: #2c3e50;
        }
        
        .item-info p {
            margin: 0;
            color: #6c757d;
            font-size: 14px;
        }
        
        .order-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-top: 15px;
            border-top: 1px solid #e9ecef;
        }
        
        .order-total {
            font-weight: bold;
            color: #2c3e50;
            font-size: 18px;
        }
        
        .order-actions {
            display: flex;
            gap: 10px;
        }
        
        .btn-primary, .btn-secondary {
            padding: 8px 16px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        
        .btn-primary {
            background: #3498db;
            color: white;
        }
        
        .btn-primary:hover {
            background: #2980b9;
        }
        
        .btn-secondary {
            background: #6c757d;
            color: white;
        }
        
        .btn-secondary:hover {
            background: #5a6268;
        }
        
        .no-orders {
            text-align: center;
            padding: 60px 20px;
            background: white;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        
        .no-orders i {
            font-size: 64px;
            color: #6c757d;
            margin-bottom: 20px;
        }
        
        .no-orders h2 {
            color: #2c3e50;
            margin-bottom: 10px;
        }
        
        .no-orders p {
            color: #6c757d;
            margin-bottom: 20px;
        }
        
        @media (max-width: 768px) {
            .order-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }
            
            .order-footer {
                flex-direction: column;
                gap: 15px;
                align-items: flex-start;
            }
            
            .order-actions {
                width: 100%;
                justify-content: space-between;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <div class="orders-container">
        <div class="orders-header">
            <h1><i class="fas fa-box"></i> My Orders</h1>
            <p>Track your orders and view order history</p>
        </div>

        <div class="orders-filter">
            <asp:Button ID="btnAll" runat="server" Text="All Orders" CssClass="filter-btn" CommandArgument="all" OnCommand="btnFilter_Command" />
            <asp:Button ID="btnProcessing" runat="server" Text="Processing" CssClass="filter-btn" CommandArgument="Processing" OnCommand="btnFilter_Command" />
            <asp:Button ID="btnShipped" runat="server" Text="Shipped" CssClass="filter-btn" CommandArgument="Shipped" OnCommand="btnFilter_Command" />
            <asp:Button ID="btnDelivered" runat="server" Text="Delivered" CssClass="filter-btn" CommandArgument="Delivered" OnCommand="btnFilter_Command" />
            <asp:Button ID="btnCancelled" runat="server" Text="Cancelled" CssClass="filter-btn" CommandArgument="Cancelled" OnCommand="btnFilter_Command" />
        </div>

        <div class="orders-content">
            <asp:ListView ID="lvOrders" runat="server" OnItemDataBound="lvOrders_ItemDataBound">
                <LayoutTemplate>
                    <div class="orders-list">
                        <asp:PlaceHolder ID="itemPlaceholder" runat="server" />
                    </div>
                </LayoutTemplate>

                <ItemTemplate>
                    <div class="order-card">
                        <div class="order-header">
                            <div class="order-info">
                                <span id="spnOrderId" runat="server"></span>
                                <span id="spnOrderDate" runat="server"></span>
                            </div>
                            <div class="order-status">
                                <span id="spnStatus" runat="server" class="status-badge"></span>
                            </div>
                        </div>

                        <div class="order-items">
                            <asp:Repeater ID="rptOrderItems" runat="server" OnItemDataBound="rptOrderItems_ItemDataBound">
                                <ItemTemplate>
                                    <div class="order-item">
                                        <img id="imgItem" runat="server" />
                                        <div class="item-info">
                                            <h4 id="h4ItemName" runat="server"></h4>
                                            <p id="pItemDetails" runat="server"></p>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>

                        <div class="order-footer">
                            <div id="divOrderTotal" runat="server"></div>
                            <div class="order-actions">
                                <asp:Button ID="btnViewDetails" runat="server" Text="View Details" CssClass="btn-secondary"
                                    OnCommand="btnViewDetails_Command" />
                                <asp:Button ID="btnViewInvoice" runat="server" Text="View Invoice" CssClass="btn-secondary"
                                    OnCommand="btnViewInvoice_Command" />
                                <asp:Button ID="btnReorder" runat="server" Text="Reorder" CssClass="btn-primary"
                                    OnCommand="btnReorder_Command" />
                            </div>
                        </div>
                    </div>
                </ItemTemplate>

                <EmptyDataTemplate>
                    <div class="no-orders">
                        <i class="fas fa-box-open"></i>
                        <h2>No orders found</h2>
                        <p>Start shopping to see your orders here</p>
                        <asp:HyperLink ID="lnkStartShopping" runat="server" NavigateUrl="~/Products.aspx" CssClass="btn-primary">
                            Start Shopping
                        </asp:HyperLink>
                    </div>
                </EmptyDataTemplate>
            </asp:ListView>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="ScriptContent" runat="server">
    <script>
        function showNotification(message, type) {
            const notification = document.createElement('div');
            notification.className = `notification ${type}`;
            notification.textContent = message;
            document.body.appendChild(notification);

            setTimeout(() => notification.classList.add('show'), 100);

            setTimeout(() => {
                notification.classList.remove('show');
                setTimeout(() => notification.remove(), 300);
            }, 3000);
        }

        // Add notification styles
        const style = document.createElement('style');
        style.textContent = `
            .notification {
                position: fixed;
                top: 20px;
                right: 20px;
                padding: 15px 20px;
                border-radius: 6px;
                color: white;
                font-weight: 500;
                z-index: 1000;
                opacity: 0;
                transform: translateY(-20px);
                transition: all 0.3s ease;
            }
            
            .notification.show {
                opacity: 1;
                transform: translateY(0);
            }
            
            .notification.success {
                background-color: #28a745;
            }
            
            .notification.error {
                background-color: #dc3545;
            }
        `;
        document.head.appendChild(style);
    </script>
</asp:Content>