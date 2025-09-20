<%@ Page Title="Delete Product" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="DeleteProduct.aspx.cs" Inherits="ub_frontend.Admin.DeleteProduct" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Ubuntu Wears - Delete Product
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <div class="admin-container">
        <div class="admin-header">
            <h1><i class="fas fa-trash"></i> Delete Product</h1>
            <asp:HyperLink ID="lnkBack" runat="server" NavigateUrl="~/Admin/Products.aspx" CssClass="btn-back">
                <i class="fas fa-arrow-left"></i> Back to Products
            </asp:HyperLink>
        </div>

        <div class="delete-confirmation">
            <asp:Panel ID="pnlDeleteConfirm" runat="server" Visible="true">
                <div class="confirmation-warning">
                    <i class="fas fa-exclamation-triangle"></i>
                    <h3>Are you sure you want to delete this product?</h3>
                    <p>This action cannot be undone. All product data will be permanently removed from the system.</p>
                </div>

                <div class="product-preview" id="productPreview" runat="server">
                    <!-- Product details will be populated here -->
                </div>

                <div class="form-actions">
                    <asp:Button ID="btnConfirmDelete" runat="server" Text="Yes, Delete Product" 
                        CssClass="btn btn-danger" OnClick="btnConfirmDelete_Click" />
                    <asp:HyperLink ID="lnkCancel" runat="server" NavigateUrl="~/Admin/Products.aspx" 
                        CssClass="btn btn-secondary">Cancel</asp:HyperLink>
                </div>
            </asp:Panel>

            <asp:Panel ID="pnlDeleteSuccess" runat="server" Visible="false">
                <div class="success-message">
                    <i class="fas fa-check-circle"></i>
                    <h3>Product Deleted Successfully</h3>
                    <p>The product has been successfully deleted from the system.</p>
                    <asp:HyperLink ID="lnkBackToProducts" runat="server" NavigateUrl="~/Admin/Products.aspx" 
                        CssClass="btn btn-primary">Back to Products</asp:HyperLink>
                </div>
            </asp:Panel>

            <asp:Panel ID="pnlError" runat="server" Visible="false">
                <div class="error-message">
                    <i class="fas fa-exclamation-circle"></i>
                    <h3>Error Deleting Product</h3>
                    <asp:Label ID="lblErrorMessage" runat="server"></asp:Label>
                    <asp:HyperLink ID="lnkErrorBack" runat="server" NavigateUrl="~/Admin/Products.aspx" 
                        CssClass="btn btn-secondary">Back to Products</asp:HyperLink>
                </div>
            </asp:Panel>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="ScriptContent" runat="server">
    <style>
        .admin-container {
            padding: 20px;
            max-width: 800px;
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
            color: #e74c3c;
        }
        
        .btn-back {
            padding: 8px 16px;
            background-color: #6c757d;
            color: white;
            border: none;
            border-radius: 4px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }
        
        .btn-back:hover {
            background-color: #5a6268;
            color: white;
            text-decoration: none;
        }
        
        .delete-confirmation {
            background: white;
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        
        .confirmation-warning {
            text-align: center;
            margin-bottom: 30px;
            padding: 20px;
            background-color: #fff3cd;
            border: 1px solid #ffeaa7;
            border-radius: 8px;
            color: #856404;
        }
        
        .confirmation-warning i {
            font-size: 48px;
            margin-bottom: 15px;
            display: block;
            color: #f39c12;
        }
        
        .confirmation-warning h3 {
            margin: 10px 0;
            color: #856404;
        }
        
        .product-preview {
            border: 1px solid #e9ecef;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 30px;
            display: flex;
            gap: 20px;
        }
        
        .product-image {
            width: 120px;
            height: 120px;
            object-fit: cover;
            border-radius: 6px;
            border: 1px solid #dee2e6;
        }
        
        .product-details {
            flex: 1;
        }
        
        .product-details h4 {
            margin: 0 0 10px 0;
            color: #2c3e50;
            font-size: 18px;
        }
        
        .product-details p {
            margin: 5px 0;
            color: #6c757d;
        }
        
        .product-details .price {
            font-weight: bold;
            color: #27ae60;
            font-size: 16px;
        }
        
        .product-details .stock {
            font-weight: 500;
        }
        
        .form-actions {
            display: flex;
            gap: 15px;
            justify-content: center;
        }
        
        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 500;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 5px;
            transition: all 0.2s ease;
        }
        
        .btn-primary {
            background-color: #3498db;
            color: white;
        }
        
        .btn-primary:hover {
            background-color: #2980b9;
        }
        
        .btn-danger {
            background-color: #e74c3c;
            color: white;
        }
        
        .btn-danger:hover {
            background-color: #c0392b;
        }
        
        .btn-secondary {
            background-color: #95a5a6;
            color: white;
        }
        
        .btn-secondary:hover {
            background-color: #7f8c8d;
        }
        
        .success-message, .error-message {
            text-align: center;
            padding: 30px;
        }
        
        .success-message i {
            font-size: 64px;
            color: #27ae60;
            margin-bottom: 20px;
        }
        
        .error-message i {
            font-size: 64px;
            color: #e74c3c;
            margin-bottom: 20px;
        }
        
        .success-message h3, .error-message h3 {
            color: #2c3e50;
            margin-bottom: 15px;
        }
        
        .success-message p, .error-message p {
            color: #6c757d;
            margin-bottom: 25px;
        }
    </style>
</asp:Content>