<%@ Page Title="Manage Users" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Users.aspx.cs" Inherits="ub_frontend.Admin.Users" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Ubuntu Wears - Manage Users
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <div class="admin-container">
        <div class="admin-header">
            <h1><i class="fas fa-users"></i> Manage Users</h1>
        </div>
        
        <div class="admin-controls">
            <asp:TextBox ID="txtSearchUsers" runat="server" placeholder="Search users..." CssClass="search-input"></asp:TextBox>
            <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn btn-primary" OnClick="btnSearch_Click" />
            <asp:Button ID="btnClear" runat="server" Text="Clear" CssClass="btn btn-secondary" OnClick="btnClear_Click" />
        </div>

        <div class="users-table-container">
            <div id="usersContainer" runat="server" class="users-table">
                <!-- Users will be dynamically populated here -->
            </div>
        </div>

        <asp:Label ID="lblMessage" runat="server" CssClass="message" Visible="false"></asp:Label>
    </div>
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="ScriptContent" runat="server">
    <style>
        .admin-container {
            padding: 20px;
            max-width: 1200px;
            margin: 0 auto;
        }
        
        .admin-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 15px;
            border-bottom: 2px solid #e9ecef;
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
        
        .admin-controls {
            margin-bottom: 20px;
            display: flex;
            gap: 10px;
            align-items: center;
            flex-wrap: wrap;
        }
        
        .search-input {
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            min-width: 250px;
        }
        
        .users-table-container {
            overflow-x: auto;
        }
        
        .users-table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        
        .users-table th {
            background-color: #f8f9fa;
            padding: 15px;
            text-align: left;
            font-weight: 600;
            color: #2c3e50;
            border-bottom: 2px solid #e9ecef;
        }
        
        .users-table td {
            padding: 15px;
            border-bottom: 1px solid #e9ecef;
        }
        
        .users-table tr:hover {
            background-color: #f8f9fa;
        }
        
        .user-type {
            display: inline-block;
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: bold;
        }
        
        .user-type-customer {
            background-color: #e3f2fd;
            color: #1976d2;
        }
        
        .user-type-admin {
            background-color: #f3e5f5;
            color: #7b1fa2;
        }
        
        .user-actions {
            display: flex;
            gap: 8px;
        }
        
        .btn {
            padding: 6px 12px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }
        
        .btn-view {
            background-color: #17a2b8;
            color: white;
        }
        
        .btn-edit {
            background-color: #ffc107;
            color: #212529;
        }
        
        .btn-delete {
            background-color: #dc3545;
            color: white;
        }
        
        .btn-primary {
            background-color: #007bff;
            color: white;
        }
        
        .btn-secondary {
            background-color: #6c757d;
            color: white;
        }
        
        .message {
            margin-top: 20px;
            padding: 10px;
            border-radius: 4px;
        }
        
        .message.success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        
        .message.error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        .empty-data {
            text-align: center;
            padding: 40px;
            color: #6c757d;
            font-style: italic;
            grid-column: 1 / -1;
        }
        
        @media (max-width: 768px) {
            .admin-controls {
                flex-direction: column;
                align-items: stretch;
            }
            
            .search-input {
                min-width: unset;
                width: 100%;
            }
            
            .users-table {
                font-size: 14px;
            }
            
            .users-table th,
            .users-table td {
                padding: 10px;
            }
            
            .user-actions {
                flex-direction: column;
            }
        }
        
        @media (max-width: 576px) {
            .admin-container {
                padding: 10px;
            }
            
            .users-table {
                font-size: 12px;
            }
            
            .users-table th,
            .users-table td {
                padding: 8px 5px;
            }
            
            .btn {
                padding: 4px 8px;
                font-size: 12px;
            }
        }
    </style>

    <script>
        function confirmDelete(userId, userName) {
            return confirm('Are you sure you want to delete user: ' + userName + '? This action cannot be undone.');
        }
    </script>
</asp:Content>