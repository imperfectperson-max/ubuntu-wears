<%@ Page Title="Edit Product" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="EditProduct.aspx.cs" Inherits="ub_frontend.Admin.EditProduct" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Ubuntu Wears - Edit Product
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <div class="admin-container">
        <div class="admin-header">
            <h1><i class="fas fa-edit"></i> Edit Product</h1>
            <asp:HyperLink ID="lnkBack" runat="server" NavigateUrl="~/Admin/Products.aspx" CssClass="btn-back">
                <i class="fas fa-arrow-left"></i> Back to Products
            </asp:HyperLink>
        </div>

        <div class="product-form-container">
            <asp:Panel ID="pnlProductForm" runat="server" CssClass="product-form" DefaultButton="btnSave">
                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label" for="productName">Product Name *</label>
                        <asp:TextBox ID="txtProductName" runat="server" CssClass="form-control" required="true"></asp:TextBox>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label" for="productPrice">Price (R) *</label>
                        <asp:TextBox ID="txtProductPrice" runat="server" CssClass="form-control" TextMode="Number" step="0.01" min="0" required="true"></asp:TextBox>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label" for="productDescription">Description *</label>
                    <asp:TextBox ID="txtProductDescription" runat="server" CssClass="form-control form-textarea" TextMode="MultiLine" Rows="4" required="true"></asp:TextBox>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label" for="productStock">Stock Quantity *</label>
                        <asp:TextBox ID="txtProductStock" runat="server" CssClass="form-control" TextMode="Number" min="0" required="true"></asp:TextBox>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label" for="productCategory">Category *</label>
                        <asp:DropDownList ID="ddlProductCategory" runat="server" CssClass="form-control" required="true">
                            <asp:ListItem Value="">Select Category</asp:ListItem>
                            <asp:ListItem Value="Zulu">Zulu</asp:ListItem>
                            <asp:ListItem Value="Xhosa">Xhosa</asp:ListItem>
                            <asp:ListItem Value="Swazi">Swazi</asp:ListItem>
                            <asp:ListItem Value="SouthNdebele">South Ndebele</asp:ListItem>
                            <asp:ListItem Value="BaTswana">BaTswana</asp:ListItem>
                            <asp:ListItem Value="BaSotho">BaSotho</asp:ListItem>
                            <asp:ListItem Value="BaPedi">BaPedi</asp:ListItem>
                            <asp:ListItem Value="Tsonga">Tsonga</asp:ListItem>
                            <asp:ListItem Value="Venda">Venda</asp:ListItem>
                            <asp:ListItem Value="Africans">Africans</asp:ListItem>
                            <asp:ListItem Value="Nguni">Nguni</asp:ListItem>
                            <asp:ListItem Value="Sotho-Tswana">Sotho-Tswana</asp:ListItem>
                            <asp:ListItem Value="Other">Other</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label" for="productImage">Product Image</label>
                    <asp:FileUpload ID="fileProductImage" runat="server" CssClass="form-control" accept="image/*" onchange="previewImage(this)" />
                    
                    <div class="image-preview" id="imagePreviewContainer" runat="server">
                        <asp:Image ID="imgCurrentImage" runat="server" CssClass="current-image" Visible="false" />
                        <img id="imagePreview" class="image-preview-img" style="display: none;" />
                        <div class="image-preview-text" id="imagePreviewText">Image preview will appear here</div>
                    </div>
                </div>

                <div class="form-group">
                    <label class="checkbox">
                        <asp:CheckBox ID="cbProductActive" runat="server" Checked="true" />
                        <span>Product is active</span>
                    </label>
                </div>

                <div class="form-actions">
                    <asp:Button ID="btnSave" runat="server" Text="Save Changes" CssClass="btn btn-primary" OnClick="btnSave_Click" OnClientClick="return validateProductForm();" />
                    <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn btn-secondary" OnClick="btnCancel_Click" CausesValidation="false" />
                </div>

                <asp:HiddenField ID="hfProductId" runat="server" Value="0" />
            </asp:Panel>

            <asp:Panel ID="pnlNotFound" runat="server" CssClass="not-found" Visible="false">
                <i class="fas fa-exclamation-triangle"></i>
                <h2>Product Not Found</h2>
                <p>The product you're trying to edit does not exist or has been removed.</p>
                <asp:HyperLink ID="lnkBackToProducts" runat="server" NavigateUrl="~/Admin/Products.aspx" CssClass="btn btn-primary">
                    <i class="fas fa-arrow-left"></i> Back to Products
                </asp:HyperLink>
            </asp:Panel>
        </div>

        <asp:Label ID="lblMessage" runat="server" CssClass="message" Visible="false"></asp:Label>
    </div>

    <!-- Loading Overlay -->
    <div id="loadingOverlay" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(255,255,255,0.8); z-index: 9999;">
        <div style="position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%);">
            <i class="fas fa-spinner fa-spin fa-3x" style="color: #007bff;"></i>
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
        
        .btn-back {
            padding: 10px 15px;
            background-color: #6c757d;
            color: white;
            text-decoration: none;
            border-radius: 4px;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }
        
        .btn-back:hover {
            background-color: #5a6268;
            text-decoration: none;
            color: white;
        }
        
        .product-form-container {
            background: white;
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        
        .product-form {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }
        
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }
        
        .form-group {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }
        
        .form-label {
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 5px;
        }
        
        .form-control {
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 16px;
            transition: border-color 0.2s ease;
        }
        
        .form-control:focus {
            border-color: #007bff;
            outline: none;
            box-shadow: 0 0 0 3px rgba(0, 123, 255, 0.1);
        }
        
        .form-textarea {
            resize: vertical;
            min-height: 100px;
        }
        
        .image-preview {
            margin-top: 10px;
            border: 2px dashed #ddd;
            border-radius: 8px;
            padding: 20px;
            text-align: center;
            min-height: 200px;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
        }
        
        .current-image {
            max-width: 100%;
            max-height: 200px;
            border-radius: 4px;
            margin-bottom: 10px;
        }
        
        .image-preview-img {
            max-width: 100%;
            max-height: 200px;
            border-radius: 4px;
            margin-bottom: 10px;
        }
        
        .image-preview-text {
            color: #6c757d;
            font-style: italic;
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
        
        .form-actions {
            display: flex;
            gap: 15px;
            margin-top: 20px;
            padding-top: 20px;
            border-top: 1px solid #e9ecef;
        }
        
        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 16px;
            font-weight: 500;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
        }
        
        .btn-primary {
            background-color: #007bff;
            color: white;
        }
        
        .btn-primary:hover {
            background-color: #0056b3;
        }
        
        .btn-secondary {
            background-color: #6c757d;
            color: white;
        }
        
        .btn-secondary:hover {
            background-color: #545b62;
        }
        
        .not-found {
            text-align: center;
            padding: 40px;
            color: #6c757d;
        }
        
        .not-found i {
            font-size: 48px;
            color: #ffc107;
            margin-bottom: 20px;
        }
        
        .not-found h2 {
            color: #2c3e50;
            margin-bottom: 15px;
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
        
        @media (max-width: 768px) {
            .form-row {
                grid-template-columns: 1fr;
            }
            
            .admin-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 15px;
            }
            
            .form-actions {
                flex-direction: column;
            }
            
            .btn {
                width: 100%;
                justify-content: center;
            }
        }
        
        @media (max-width: 576px) {
            .admin-container {
                padding: 15px;
            }
            
            .product-form-container {
                padding: 20px;
            }
        }
    </style>

    <script>
        function previewImage(input) {
            const preview = document.getElementById('imagePreview');
            const previewText = document.getElementById('imagePreviewText');
            const currentImage = document.getElementById('<%= imgCurrentImage.ClientID %>');
            const container = document.getElementById('<%= imagePreviewContainer.ClientID %>');

            if (input.files && input.files[0]) {
                // Show loading state
                previewText.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Loading image...';
                previewText.style.display = 'block';
                preview.style.display = 'none';

                const reader = new FileReader();
                reader.onload = function (e) {
                    preview.style.display = 'block';
                    preview.src = e.target.result;
                    previewText.style.display = 'none';

                    if (currentImage) {
                        currentImage.style.display = 'none';
                    }

                    // Remove any background image from container
                    container.style.backgroundImage = 'none';
                }

                reader.onerror = function () {
                    previewText.innerHTML = 'Error loading image. Please try another file.';
                    previewText.style.display = 'block';
                    preview.style.display = 'none';
                }

                reader.readAsDataURL(input.files[0]);
            } else {
                preview.style.display = 'none';
                previewText.style.display = 'block';
                previewText.innerHTML = 'Image preview will appear here';

                if (currentImage && currentImage.src) {
                    currentImage.style.display = 'block';
                }
            }
        }

        function validateProductForm() {
            const name = document.getElementById('<%= txtProductName.ClientID %>').value;
            const price = document.getElementById('<%= txtProductPrice.ClientID %>').value;
            const stock = document.getElementById('<%= txtProductStock.ClientID %>').value;
            const category = document.getElementById('<%= ddlProductCategory.ClientID %>').value;

            if (!name || !price || !stock || !category) {
                alert('Please fill in all required fields.');
                return false;
            }

            if (parseFloat(price) <= 0) {
                alert('Price must be greater than 0.');
                return false;
            }

            if (parseInt(stock) < 0) {
                alert('Stock cannot be negative.');
                return false;
            }

            // Show loading overlay
            document.getElementById('loadingOverlay').style.display = 'block';
            return true;
        }

        // Add event listener to form submission
        document.getElementById('<%= btnSave.ClientID %>').addEventListener('click', function (e) {
            if (!validateProductForm()) {
                e.preventDefault();
            }
        });

        // Hide loading overlay if validation fails and page doesn't post back
        setTimeout(function () {
            document.getElementById('loadingOverlay').style.display = 'none';
        }, 3000);
    </script>
</asp:Content>