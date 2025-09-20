<%@ Page Title="Manage Products" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Products.aspx.cs" Inherits="ub_frontend.Admin.Products" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Ubuntu Wears - Manage Products
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .admin-products {
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
        }
        
        .admin-header h1 {
            color: #2c3e50;
            margin: 0;
            font-size: 28px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .admin-header h1 i {
            color: #3498db;
        }
        
        .admin-actions {
            display: flex;
            gap: 15px;
        }
        
        .btn-primary, .btn-secondary, .pagination-btn {
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.2s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }
        
        .btn-primary {
            background-color: #3498db;
            color: white;
        }
        
        .btn-primary:hover {
            background-color: #2980b9;
        }
        
        .btn-secondary {
            background-color: #95a5a6;
            color: white;
        }
        
        .btn-secondary:hover {
            background-color: #7f8c8d;
        }
        
        .products-filter {
            background: white;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
        }
        
        .filter-controls {
            display: flex;
            gap: 15px;
            align-items: end;
            flex-wrap: wrap;
        }
        
        .filter-controls .form-group {
            display: flex;
            flex-direction: column;
            min-width: 180px;
        }
        
        .filter-controls label {
            font-weight: 600;
            margin-bottom: 5px;
            color: #2c3e50;
            font-size: 13px;
        }
        
        .search-input, .filter-controls select {
            padding: 10px;
            border: 1px solid #ced4da;
            border-radius: 4px;
            font-size: 14px;
            transition: border-color 0.2s ease;
        }
        
        .search-input:focus, .filter-controls select:focus {
            border-color: #3498db;
            outline: none;
            box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.1);
        }
        
        .products-container {
            background: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
            margin-bottom: 20px;
        }
        
        .admin-grid {
            width: 100%;
            border-collapse: collapse;
        }
        
        .admin-grid th {
            background-color: #f8f9fa;
            padding: 15px;
            text-align: left;
            font-weight: 600;
            color: #2c3e50;
            border-bottom: 2px solid #e9ecef;
        }
        
        .admin-grid td {
            padding: 15px;
            border-bottom: 1px solid #e9ecef;
            vertical-align: middle;
        }
        
        .admin-grid tr:hover {
            background-color: #f8f9fa;
        }
        
        .product-thumb {
            width: 50px;
            height: 50px;
            object-fit: cover;
            border-radius: 4px;
            border: 1px solid #dee2e6;
        }
        
        .grid-action {
            color: #3498db;
            text-decoration: none;
            margin-right: 15px;
            font-size: 13px;
            font-weight: 500;
            cursor: pointer;
        }
        
        .grid-action:hover {
            text-decoration: underline;
        }
        
        .grid-action.danger {
            color: #e74c3c;
        }
        
        .no-data {
            padding: 40px;
            text-align: center;
            color: #6c757d;
            font-style: italic;
        }
        
        .no-data i {
            font-size: 48px;
            margin-bottom: 15px;
            display: block;
            color: #bdc3c7;
        }
        
        .pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 20px;
            margin-top: 30px;
        }
        
        .pagination-btn {
            background-color: #3498db;
            color: white;
            min-width: 80px;
            justify-content: center;
        }
        
        .pagination-btn:disabled {
            background-color: #bdc3c7;
            cursor: not-allowed;
        }
        
        .pagination-btn:hover:not(:disabled) {
            background-color: #2980b9;
        }
        
        .pagination-info {
            color: #6c757d;
            font-weight: 500;
        }
        
        /* Modal Styles */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            align-items: center;
            justify-content: center;
        }
        
        .modal-content {
            background-color: white;
            border-radius: 10px;
            width: 90%;
            max-width: 700px;
            max-height: 90vh;
            overflow-y: auto;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
        }
        
        .modal-content.large {
            max-width: 900px;
        }
        
        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 20px;
            border-bottom: 1px solid #e9ecef;
        }
        
        .modal-header h2 {
            margin: 0;
            color: #2c3e50;
            font-size: 22px;
        }
        
        .modal-close {
            background: none;
            border: none;
            font-size: 24px;
            cursor: pointer;
            color: #6c757d;
            padding: 0;
            width: 30px;
            height: 30px;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .modal-close:hover {
            color: #2c3e50;
        }
        
        .modal-body {
            padding: 20px;
        }
        
        .form-row {
            display: flex;
            gap: 20px;
            margin-bottom: 20px;
        }
        
        .form-group {
            flex: 1;
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #2c3e50;
        }
        
        .form-group input, .form-group select, .form-group textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #ced4da;
            border-radius: 4px;
            font-size: 14px;
            transition: border-color 0.2s ease;
        }
        
        .form-group input:focus, .form-group select:focus, .form-group textarea:focus {
            border-color: #3498db;
            outline: none;
            box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.1);
        }
        
        .form-group textarea {
            min-height: 80px;
            resize: vertical;
        }
        
        .checkbox {
            display: flex;
            align-items: center;
            gap: 10px;
            cursor: pointer;
        }
        
        .checkbox input[type="checkbox"] {
            width: auto;
            margin: 0;
        }
        
        .modal-actions {
            display: flex;
            gap: 15px;
            justify-content: flex-end;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #e9ecef;
        }
        
        /* Status badges */
        .status-badge {
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 500;
        }
        
        .status-active {
            background-color: #d4edda;
            color: #155724;
        }
        
        .status-inactive {
            background-color: #f8d7da;
            color: #721c24;
        }
        
        /* Notification styles */
        .notification {
            position: fixed;
            top: 20px;
            right: 20px;
            padding: 15px 20px;
            border-radius: 6px;
            color: white;
            font-weight: 500;
            z-index: 1100;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            animation: slideIn 0.3s ease;
        }
        
        .notification.success {
            background-color: #27ae60;
        }
        
        .notification.error {
            background-color: #e74c3c;
        }
        
        @keyframes slideIn {
            from {
                transform: translateX(100%);
                opacity: 0;
            }
            to {
                transform: translateX(0);
                opacity: 1;
            }
        }
        
        /* Responsive adjustments */
        @media (max-width: 992px) {
            .filter-controls {
                flex-direction: column;
                align-items: stretch;
            }
            
            .filter-controls .form-group {
                min-width: auto;
            }
            
            .form-row {
                flex-direction: column;
                gap: 0;
            }
            
            .admin-grid {
                display: block;
                overflow-x: auto;
            }
        }
        
        @media (max-width: 768px) {
            .admin-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 15px;
            }
            
            .admin-actions {
                width: 100%;
                justify-content: flex-end;
            }
            
            .modal-content {
                width: 95%;
                margin: 20px;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <div class="admin-products">
        <div class="admin-header">
            <h1><i class="fas fa-tshirt"></i> Product Management</h1>
            <div class="admin-actions">
                <asp:Button ID="btnAddProduct" runat="server" Text="Add New Product" CssClass="btn-primary" 
                    OnClick="btnAddProduct_Click" />
                <asp:Button ID="btnEditProduct" runat="server" Text="Edit Product" CssClass="btn-primary" 
                    OnClick="btnEditProduct_Click" />
            </div>
        </div>

        <div class="products-filter">
            <div class="filter-controls">
                <div class="form-group">
                    <label for="<%= txtSearch.ClientID %>">Search Products</label>
                    <asp:TextBox ID="txtSearch" runat="server" placeholder="Search by name, description..." CssClass="search-input"></asp:TextBox>
                </div>
                <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn-secondary" OnClick="btnSearch_Click" />
                
                <div class="form-group">
                    <label for="<%= ddlCategory.ClientID %>">Category</label>
                    <asp:DropDownList ID="ddlCategory" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlCategory_SelectedIndexChanged">
                        <asp:ListItem Value="">All Categories</asp:ListItem>
                        <asp:ListItem>Zulu</asp:ListItem>
                        <asp:ListItem>Xhosa</asp:ListItem>
                        <asp:ListItem>Swazi</asp:ListItem>
                        <asp:ListItem>SouthNdebele</asp:ListItem>
                        <asp:ListItem>BaTswana</asp:ListItem>
                        <asp:ListItem>BaSotho</asp:ListItem>
                        <asp:ListItem>BaPedi</asp:ListItem>
                        <asp:ListItem>Tsonga</asp:ListItem>
                        <asp:ListItem>Venda</asp:ListItem>
                    </asp:DropDownList>
                </div>
                
                <div class="form-group">
                    <label for="<%= ddlStatus.ClientID %>">Status</label>
                    <asp:DropDownList ID="ddlStatus" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlStatus_SelectedIndexChanged">
                        <asp:ListItem Value="">All Status</asp:ListItem>
                        <asp:ListItem Value="true">Active</asp:ListItem>
                        <asp:ListItem Value="false">Inactive</asp:ListItem>
                    </asp:DropDownList>
                </div>
            </div>
        </div>

        <div id="productsContainer" runat="server" class="products-container">
            <!-- Products will be rendered here via innerHTML -->
        </div>

        <div class="pagination">
            <asp:Button ID="btnPrev" runat="server" Text="Previous" CssClass="pagination-btn" OnClick="btnPrev_Click" Enabled="false" />
            <span class="pagination-info">Page <asp:Literal ID="litCurrentPage" runat="server" /> of <asp:Literal ID="litTotalPages" runat="server" /></span>
            <asp:Button ID="btnNext" runat="server" Text="Next" CssClass="pagination-btn" OnClick="btnNext_Click" Enabled="false" />
        </div>
    </div>

    <!-- Add/Edit Product Modal -->
    <div class="modal" id="productModal" style="display: none;">
        <div class="modal-content large">
            <div class="modal-header">
                <h2><asp:Literal ID="litModalTitle" runat="server" /></h2>
                <button type="button" class="modal-close" onclick="closeModal()">&times;</button>
            </div>
            <div class="modal-body">
                <asp:Panel ID="pnlProductForm" runat="server" DefaultButton="btnSaveProduct">
                    <div class="form-row">
                        <div class="form-group">
                            <label for="txtProductName">Product Name *</label>
                            <asp:TextBox ID="txtProductName" runat="server" required="true"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <label for="ddlProductCategory">Category *</label>
                            <asp:DropDownList ID="ddlProductCategory" runat="server" required="true">
                                <asp:ListItem Value="">Select Category</asp:ListItem>
                                <asp:ListItem>Zulu</asp:ListItem>
                                <asp:ListItem>Xhosa</asp:ListItem>
                                <asp:ListItem>Swazi</asp:ListItem>
                                <asp:ListItem>SouthNdebele</asp:ListItem>
                                <asp:ListItem>BaTswana</asp:ListItem>
                                <asp:ListItem>BaSotho</asp:ListItem>
                                <asp:ListItem>BaPedi</asp:ListItem>
                                <asp:ListItem>Tsonga</asp:ListItem>
                                <asp:ListItem>Venda</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="txtProductDescription">Description</label>
                        <asp:TextBox ID="txtProductDescription" runat="server" TextMode="MultiLine" Rows="3"></asp:TextBox>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="txtProductPrice">Price (R) *</label>
                            <asp:TextBox ID="txtProductPrice" runat="server" TextMode="Number" step="0.01" min="0" required="true"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <label for="txtProductStock">Stock Quantity *</label>
                            <asp:TextBox ID="txtProductStock" runat="server" TextMode="Number" min="0" required="true"></asp:TextBox>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="txtImageURL">Image URL</label>
                        <asp:TextBox ID="txtImageURL" runat="server" placeholder="https://example.com/image.jpg"></asp:TextBox>
                    </div>

                    <div class="form-group">
                        <label class="checkbox">
                            <asp:CheckBox ID="cbProductActive" runat="server" Checked="true" />
                            <span>Product is active</span>
                        </label>
                    </div>

                    <div class="modal-actions">
                        <asp:Button ID="btnSaveProduct" runat="server" Text="Save Product" CssClass="btn-primary" OnClick="btnSaveProduct_Click" />
                        <button type="button" class="btn-secondary" onclick="closeModal()">Cancel</button>
                    </div>

                    <asp:HiddenField ID="hfProductId" runat="server" Value="0" />
                </asp:Panel>
            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="ScriptContent" runat="server">
    <script>
        function openProductModal() {
            document.getElementById('productModal').style.display = 'flex';
        }

        function closeModal() {
            document.getElementById('productModal').style.display = 'none';
        }

        // Close modal when clicking outside
        window.onclick = function (event) {
            var modal = document.getElementById('productModal');
            if (event.target === modal) {
                closeModal();
            }
        }

        function toggleProductStatus(productId) {
            if (confirm('Are you sure you want to change the product status?')) {
                __doPostBack('ToggleStatus', productId);
            }
        }

        function deleteProduct(productId) {
            if (confirm('Are you sure you want to delete this product? This action cannot be undone.')) {
                window.location.href = 'DeleteProduct.aspx?id=' + productId;
            }
        }

        function editProduct(productId) {
            window.location.href = 'EditProduct.aspx?id=' + productId;
        }

        function showNotification(message, type) {
            // Remove any existing notifications
            var existingNotifications = document.querySelectorAll('.notification');
            existingNotifications.forEach(function (notification) {
                notification.remove();
            });

            // Create new notification
            var notification = document.createElement('div');
            notification.className = 'notification ' + type;
            notification.textContent = message;

            document.body.appendChild(notification);

            // Remove notification after 5 seconds
            setTimeout(function () {
                notification.remove();
            }, 5000);
        }
    </script>
</asp:Content>