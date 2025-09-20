<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ProductDetail.aspx.cs" Inherits="ub_frontend.ProductDetail" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Ubuntu Wears - Product Detail
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .product-detail-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        
        .product-detail {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 40px;
            margin-bottom: 60px;
        }
        
        .product-image-container {
            position: relative;
        }
        
        .product-main-image {
            width: 100%;
            height: 500px;
            object-fit: cover;
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        
        .product-info {
            padding: 20px 0;
        }
        
        .product-title {
            font-size: 2.5rem;
            color: #2c3e50;
            margin-bottom: 10px;
        }
        
        .product-category {
            color: #6c757d;
            font-size: 1.1rem;
            margin-bottom: 20px;
        }
        
        .product-price {
            font-size: 2rem;
            color: #28a745;
            font-weight: bold;
            margin-bottom: 20px;
        }
        
        .product-description {
            color: #6c757d;
            line-height: 1.6;
            margin-bottom: 30px;
        }
        
        .product-meta {
            margin-bottom: 30px;
        }
        
        .meta-item {
            display: flex;
            align-items: center;
            margin-bottom: 10px;
        }
        
        .meta-item i {
            width: 20px;
            margin-right: 10px;
            color: #3498db;
        }
        
        .product-actions {
            display: flex;
            gap: 15px;
            margin-bottom: 30px;
        }
        
        .quantity-selector {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .quantity-btn {
            width: 40px;
            height: 40px;
            border: 1px solid #ddd;
            background: white;
            border-radius: 4px;
            cursor: pointer;
            font-size: 18px;
        }
        
        .quantity-input {
            width: 60px;
            height: 40px;
            text-align: center;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 16px;
        }
        
        .add-to-cart-btn {
            padding: 15px 30px;
            background: #3498db;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 16px;
            font-weight: bold;
        }
        
        .add-to-cart-btn:hover {
            background: #2980b9;
        }
        
        .add-to-cart-btn:disabled {
            background: #6c757d;
            cursor: not-allowed;
        }
        
        .wishlist-btn {
            padding: 15px;
            background: #e74c3c;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 16px;
        }
        
        .wishlist-btn:hover {
            background: #c0392b;
        }
        
        .out-of-stock {
            color: #dc3545;
            font-weight: bold;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .related-products {
            margin-top: 60px;
        }
        
        .related-title {
            font-size: 2rem;
            color: #2c3e50;
            margin-bottom: 30px;
            text-align: center;
        }
        
        .related-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 25px;
        }
        
        .not-found {
            text-align: center;
            padding: 60px 20px;
        }
        
        .not-found i {
            font-size: 64px;
            color: #ffc107;
            margin-bottom: 20px;
        }
        
        .not-found h2 {
            color: #2c3e50;
            margin-bottom: 10px;
        }
        
        .not-found p {
            color: #6c757d;
            margin-bottom: 20px;
        }
        
        @media (max-width: 768px) {
            .product-detail {
                grid-template-columns: 1fr;
            }
            
            .product-main-image {
                height: 300px;
            }
            
            .product-actions {
                flex-direction: column;
            }
            
            .quantity-selector {
                justify-content: center;
            }
        }

    </style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <div class="product-detail-container">
        <div id="productDetailContent" runat="server">
            <!-- Product detail will be rendered here using StringBuilder -->
        </div>
        
        <div id="relatedProductsContent" runat="server" class="related-products">
            <!-- Related products will be rendered here using StringBuilder -->
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="ScriptContent" runat="server">
    <script>
        function updateQuantity(change) {
            const input = document.getElementById('txtQuantity');
            let quantity = parseInt(input.value) || 1;
            quantity = Math.max(1, Math.min(10, quantity + change));
            input.value = quantity;
        }

        function addToCart(productId) {
            const quantity = document.getElementById('txtQuantity').value;
            __doPostBack('AddToCart', `${productId}|${quantity}`);
        }

        function addToWishlist(productId) {
            __doPostBack('AddToWishlist', productId);
        }

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