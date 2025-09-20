<%@ Page Title="Add Product" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AddProduct.aspx.cs" Inherits="ub_frontend.Admin.AddProduct" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Ubuntu Wears - Add Product
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <div class="admin-container">
        <div class="admin-header">
            <h1><i class="fas fa-plus-circle"></i> Add New Product</h1>
            <asp:HyperLink ID="lnkBack" runat="server" NavigateUrl="~/Admin/Products.aspx" CssClass="btn-back">
                <i class="fas fa-arrow-left"></i> Back to Products
            </asp:HyperLink>
        </div>

        <div class="product-form-container">
            <asp:Panel ID="pnlProductForm" runat="server" DefaultButton="btnSaveProduct">
                <div class="form-row">
                    <div class="form-group">
                        <label for="txtProductName">Product Name *</label>
                        <asp:TextBox ID="txtProductName" runat="server" CssClass="form-control" required="true"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label for="ddlProductCategory">Category *</label>
                        <asp:DropDownList ID="ddlProductCategory" runat="server" CssClass="form-control" required="true">
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
                            <asp:ListItem>Africans</asp:ListItem>
                            <asp:ListItem>Nguni</asp:ListItem>
                            <asp:ListItem>Sotho-Tswana</asp:ListItem>
                            <asp:ListItem>Other</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>

                <div class="form-group">
                    <label for="txtProductDescription">Description *</label>
                    <asp:TextBox ID="txtProductDescription" runat="server" TextMode="MultiLine" Rows="4" CssClass="form-control" required="true"></asp:TextBox>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="txtProductPrice">Price (R) *</label>
                        <asp:TextBox ID="txtProductPrice" runat="server" TextMode="Number" step="0.01" min="0" CssClass="form-control" required="true"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label for="txtProductStock">Stock Quantity *</label>
                        <asp:TextBox ID="txtProductStock" runat="server" TextMode="Number" min="0" CssClass="form-control" required="true"></asp:TextBox>
                    </div>
                </div>

                <div class="form-group">
                    <label for="fileProductImage">Product Image</label>
                    <asp:FileUpload ID="fileProductImage" runat="server" CssClass="form-control" accept="image/*" />
                    <small class="form-text">Recommended size: 500x500px. Supported formats: JPG, PNG, GIF, BMP, WEBP. Max file size: 2MB</small>
                    <div class="image-preview mt-2" id="imagePreview">
                        <div class="image-placeholder">No image selected</div>
                    </div>
                </div>

                <div class="form-group">
                    <div class="form-check">
                        <asp:CheckBox ID="cbProductActive" runat="server" Checked="true" CssClass="form-check-input" />
                        <label class="form-check-label" for="cbProductActive">Product is active</label>
                    </div>
                </div>

                <div class="form-actions">
                    <asp:Button ID="btnSaveProduct" runat="server" Text="Save Product" CssClass="btn btn-primary" OnClick="btnSaveProduct_Click" />
                    <asp:HyperLink ID="btnCancel" runat="server" NavigateUrl="~/Admin/Products.aspx" CssClass="btn btn-secondary">Cancel</asp:HyperLink>
                </div>
            </asp:Panel>

            <asp:Label ID="lblMessage" runat="server" CssClass="message" Visible="false"></asp:Label>
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
            flex-wrap: wrap;
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
        
        .product-form-container {
            background: white;
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
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
        
        label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #2c3e50;
        }
        
        .form-control {
            width: 100%;
            padding: 10px;
            border: 1px solid #ced4da;
            border-radius: 4px;
            font-size: 14px;
            transition: border-color 0.2s ease;
        }
        
        .form-control:focus {
            border-color: #3498db;
            outline: none;
            box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.1);
        }
        
        textarea.form-control {
            min-height: 120px;
            resize: vertical;
        }
        
        .form-text {
            display: block;
            margin-top: 5px;
            color: #6c757d;
            font-size: 12px;
        }
        
        .form-check {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .form-check-input {
            width: 18px;
            height: 18px;
        }
        
        .form-check-label {
            margin-bottom: 0;
        }
        
        .form-actions {
            display: flex;
            gap: 15px;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #e9ecef;
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
        
        .btn-secondary {
            background-color: #95a5a6;
            color: white;
        }
        
        .btn-secondary:hover {
            background-color: #7f8c8d;
        }
        
        .image-preview {
            margin-top: 15px;
            text-align: center;
        }
        
        .image-preview img {
            max-width: 200px;
            max-height: 200px;
            border-radius: 8px;
            border: 1px solid #e9ecef;
        }
        
        .image-placeholder {
            width: 200px;
            height: 150px;
            border: 2px dashed #ced4da;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #6c757d;
            font-style: italic;
            margin: 0 auto;
        }
        
        .message {
            margin-top: 20px;
            padding: 15px;
            border-radius: 6px;
            font-weight: 500;
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
        
        .mt-2 {
            margin-top: 10px;
        }
        
        @media (max-width: 768px) {
            .form-row {
                flex-direction: column;
                gap: 0;
            }
            
            .admin-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }
            
            .admin-header h1 {
                font-size: 24px;
            }
            
            .product-form-container {
                padding: 20px;
            }
            
            .form-actions {
                flex-direction: column;
            }
            
            .btn {
                width: 100%;
                justify-content: center;
            }
        }
    </style>

    <script>
        function previewImage(input) {
            const preview = document.getElementById('imagePreview');
            if (input.files && input.files[0]) {
                const reader = new FileReader();
                reader.onload = function (e) {
                    preview.innerHTML = `<img src="${e.target.result}" alt="Preview" class="img-preview" style="max-width: 200px; max-height: 200px; border-radius: 8px;">`;
                }
                reader.readAsDataURL(input.files[0]);
            } else {
                preview.innerHTML = '<div class="image-placeholder">No image selected</div>';
            }
        }

        // Attach event listener to file input
        document.addEventListener('DOMContentLoaded', function () {
            const fileInput = document.getElementById('<%= fileProductImage.ClientID %>');
            if (fileInput) {
                fileInput.addEventListener('change', function () {
                    previewImage(this);
                });
            }
        });

        // Client-side validation for file size and type
        function validateFile(input) {
            if (input.files && input.files[0]) {
                const file = input.files[0];
                const maxSize = 2 * 1024 * 1024; // 2MB
                const allowedTypes = ['image/jpeg', 'image/png', 'image/gif', 'image/bmp', 'image/webp'];

                if (file.size > maxSize) {
                    alert('File size too large. Maximum size is 2MB.');
                    input.value = '';
                    document.getElementById('imagePreview').innerHTML = '<div class="image-placeholder">No image selected</div>';
                    return false;
                }

                if (!allowedTypes.includes(file.type)) {
                    alert('Invalid file type. Please upload an image file (JPG, PNG, GIF, BMP, WEBP).');
                    input.value = '';
                    document.getElementById('imagePreview').innerHTML = '<div class="image-placeholder">No image selected</div>';
                    return false;
                }
            }
            return true;
        }
    </script>
</asp:Content>