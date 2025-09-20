<%@ Page Title="Admin Dashboard" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="ub_frontend.Admin.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Admin Dashboard - Ubuntu Wears
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="admin-dashboard">
        <div class="admin-header">
            <h1><i class="fas fa-tachometer-alt"></i> Admin Dashboard</h1>
            <div class="admin-actions">
                <span>Welcome, <span id="adminName" runat="server"></span></span>
                <span class="last-login">Last login: <span id="lastLogin" runat="server"></span></span>
                <asp:Button ID="btnRefresh" runat="server" Text="Refresh Data" CssClass="refresh-btn" OnClick="btnRefresh_Click" />
            </div>
        </div>

        <div id="statsContainer" runat="server" class="dashboard-stats">
            <!-- Stats will be dynamically populated here -->
        </div>

        <div class="dashboard-grid">
            <div class="dashboard-section quick-actions">
                <h2><i class="fas fa-bolt"></i> Quick Actions</h2>
                <div class="action-grid">
                    <a href="Products.aspx" class="action-card">
                        <div class="action-icon">
                            <i class="fas fa-tshirt"></i>
                        </div>
                        <div class="action-content">
                            <h3>Manage Products</h3>
                            <p>Add, edit, or remove products</p>
                        </div>
                    </a>

                    <a href="Orders.aspx" class="action-card">
                        <div class="action-icon">
                            <i class="fas fa-shopping-cart"></i>
                        </div>
                        <div class="action-content">
                            <h3>View Orders</h3>
                            <p>Process and manage orders</p>
                        </div>
                    </a>

                    <a href="Users.aspx" class="action-card">
                        <div class="action-icon">
                            <i class="fas fa-users"></i>
                        </div>
                        <div class="action-content">
                            <h3>Manage Users</h3>
                            <p>View and manage user accounts</p>
                        </div>
                    </a>

                    <a href="Report.aspx" class="action-card">
                        <div class="action-icon">
                            <i class="fas fa-chart-bar"></i>
                        </div>
                        <div class="action-content">
                            <h3>View Reports</h3>
                            <p>Sales and analytics reports</p>
                        </div>
                    </a>
                </div>
            </div>

            <div class="dashboard-section recent-activity">
                <h2><i class="fas fa-history"></i> Recent Activity</h2>
                <div id="recentActivityContainer" runat="server" class="activity-list">
                    <!-- Recent activity will be dynamically populated here -->
                </div>
            </div>
        </div>

        <div class="dashboard-section system-info">
            <h2><i class="fas fa-info-circle"></i> System Information</h2>
            <div class="info-grid">
                <div class="info-card">
                    <i class="fas fa-server"></i>
                    <div class="info-content">
                        <h3>Server Status</h3>
                        <p id="serverStatus" runat="server">Online</p>
                    </div>
                </div>

                <div class="info-card">
                    <i class="fas fa-database"></i>
                    <div class="info-content">
                        <h3>Database</h3>
                        <p id="dbStatus" runat="server">Connected</p>
                    </div>
                </div>

                <div class="info-card">
                    <i class="fas fa-shield-alt"></i>
                    <div class="info-content">
                        <h3>Security</h3>
                        <p id="securityStatus" runat="server">Protected</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ScriptContent" runat="server">
    <style>
        .admin-dashboard {
            padding: 20px;
            max-width: 1400px;
            margin: 0 auto;
        }
        
        .admin-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 15px;
            border-bottom: 2px solid #e9ecef;
            flex-wrap: wrap;
            gap: 15px;
        }
        
        .admin-header h1 {
            color: #2c3e50;
            margin: 0;
            font-size: 28px;
        }
        
        .admin-header h1 i {
            margin-right: 10px;
            color: #3498db;
        }
        
        .admin-actions {
            display: flex;
            flex-direction: column;
            align-items: flex-end;
            gap: 5px;
        }
        
        .admin-actions span {
            font-weight: 500;
            color: #6c757d;
        }
        
        .last-login {
            font-size: 12px;
            color: #6c757d;
        }
        
        .refresh-btn {
            padding: 8px 16px;
            background-color: #3498db;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 5px;
        }
        
        .refresh-btn:hover {
            background-color: #2980b9;
        }
        
        .dashboard-stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            display: flex;
            align-items: center;
            transition: transform 0.2s ease;
        }
        
        .stat-card:hover {
            transform: translateY(-2px);
        }
        
        .stat-icon {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 15px;
            font-size: 24px;
        }
        
        .stat-icon.sales { background-color: #e3f2fd; color: #1976d2; }
        .stat-icon.orders { background-color: #fff3cd; color: #856404; }
        .stat-icon.products { background-color: #d4edda; color: #155724; }
        .stat-icon.users { background-color: #f3e5f5; color: #7b1fa2; }
        .stat-icon.revenue { background-color: #fff3e0; color: #f57c00; }
        .stat-icon.pending { background-color: #ffebee; color: #d32f2f; }
        
        .stat-content {
            flex: 1;
        }
        
        .stat-number {
            font-size: 24px;
            font-weight: bold;
            color: #2c3e50;
            margin-bottom: 5px;
        }
        
        .stat-label {
            color: #6c757d;
            font-size: 14px;
        }
        
        .stat-trend {
            font-size: 12px;
            margin-top: 5px;
        }
        
        .trend-up { color: #28a745; }
        .trend-down { color: #dc3545; }
        
        .dashboard-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
            margin-bottom: 30px;
        }
        
        .dashboard-section {
            background: white;
            border-radius: 10px;
            padding: 25px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        
        .dashboard-section h2 {
            color: #2c3e50;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 1px solid #e9ecef;
            font-size: 20px;
        }
        
        .dashboard-section h2 i {
            margin-right: 10px;
            color: #3498db;
        }
        
        .action-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
        }
        
        .action-card {
            display: flex;
            align-items: center;
            padding: 20px;
            background: #f8f9fa;
            border-radius: 8px;
            text-decoration: none;
            color: inherit;
            transition: all 0.2s ease;
        }
        
        .action-card:hover {
            background: #e9ecef;
            transform: translateY(-2px);
            text-decoration: none;
            color: inherit;
        }
        
        .action-icon {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background: #007bff;
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 15px;
            font-size: 20px;
        }
        
        .action-content h3 {
            margin: 0 0 5px 0;
            color: #2c3e50;
            font-size: 16px;
        }
        
        .action-content p {
            margin: 0;
            color: #6c757d;
            font-size: 14px;
        }
        
        .activity-list {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }
        
        .activity-item {
            display: flex;
            align-items: center;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 8px;
            border-left: 4px solid #007bff;
        }
        
        .activity-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: #e3f2fd;
            color: #1976d2;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 15px;
            font-size: 16px;
        }
        
        .activity-content {
            flex: 1;
        }
        
        .activity-content h4 {
            margin: 0 0 5px 0;
            color: #2c3e50;
            font-size: 14px;
        }
        
        .activity-content p {
            margin: 0;
            color: #6c757d;
            font-size: 12px;
        }
        
        .activity-time {
            color: #6c757d;
            font-size: 11px;
            text-align: right;
        }
        
        .system-info {
            margin-bottom: 30px;
        }
        
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
        }
        
        .info-card {
            display: flex;
            align-items: center;
            padding: 20px;
            background: #f8f9fa;
            border-radius: 8px;
        }
        
        .info-card i {
            font-size: 24px;
            color: #007bff;
            margin-right: 15px;
        }
        
        .info-content h3 {
            margin: 0 0 5px 0;
            color: #2c3e50;
            font-size: 14px;
        }
        
        .info-content p {
            margin: 0;
            color: #28a745;
            font-size: 13px;
            font-weight: 500;
        }
        
        .empty-state {
            text-align: center;
            padding: 40px;
            color: #6c757d;
            font-style: italic;
        }
        
        @media (max-width: 992px) {
            .dashboard-grid {
                grid-template-columns: 1fr;
            }
        }
        
        @media (max-width: 768px) {
            .action-grid {
                grid-template-columns: 1fr;
            }
            
            .admin-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }
            
            .admin-actions {
                align-items: flex-start;
            }
            
            .dashboard-stats {
                grid-template-columns: 1fr;
            }
            
            .info-grid {
                grid-template-columns: 1fr;
            }
        }
        
        @media (max-width: 576px) {
            .admin-dashboard {
                padding: 10px;
            }
            
            .dashboard-section {
                padding: 15px;
            }
            
            .stat-card {
                flex-direction: column;
                text-align: center;
            }
            
            .stat-icon {
                margin-right: 0;
                margin-bottom: 15px;
            }
            
            .activity-item {
                flex-direction: column;
                text-align: center;
            }
            
            .activity-icon {
                margin-right: 0;
                margin-bottom: 10px;
            }
            
            .activity-time {
                text-align: center;
                margin-top: 10px;
            }
        }
    </style>

    <script>
        function refreshDashboard() {
            const btn = document.getElementById('<%= btnRefresh.ClientID %>');
            btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Refreshing...';
            btn.disabled = true;

            setTimeout(function () {
                __doPostBack('RefreshData', '');
            }, 1000);
        }
    </script>
</asp:Content>