<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Products.aspx.cs" Inherits="ub_frontend.Products" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Ubuntu Wears - Products
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .products-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        
        .products-header {
            text-align: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid #e9ecef;
        }
        
        .products-header h1 {
            color: #2c3e50;
            margin-bottom: 10px;
        }
        
        .products-filter {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }
        
        .filter-options {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
        }
        
        .filter-options select {
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 6px;
            min-width: 200px;
        }
        
        .product-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 25px;
            margin-bottom: 40px;
        }
        
        .product-tile {
            background: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        
        .product-tile:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 15px rgba(0,0,0,0.15);
        }
        
        .product-image {
            height: 250px;
            overflow: hidden;
        }
        
        .product-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.3s ease;
        }
        
        .product-tile:hover .product-image img {
            transform: scale(1.05);
        }
        
        .product-info {
            padding: 20px;
        }
        
        .product-info h3 {
            margin: 0 0 8px 0;
            color: #2c3e50;
            font-size: 16px;
            line-height: 1.3;
        }
        
        .product-category {
            color: #6c757d;
            font-size: 14px;
            margin: 0 0 8px 0;
        }
        
        .product-price {
            color: #28a745;
            font-weight: bold;
            font-size: 18px;
            margin: 0 0 15px 0;
        }
        
        .product-actions {
            display: flex;
            gap: 10px;
        }
        
        .add-to-cart-btn {
            flex: 1;
            padding: 10px;
            background: #3498db;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            text-align: center;
            text-decoration: none;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 5px;
        }
        
        .add-to-cart-btn:hover {
            background: #2980b9;
        }
        
        .wishlist-btn {
            padding: 10px;
            background: #e74c3c;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            text-decoration: none;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .wishlist-btn:hover {
            background: #c0392b;
        }
        
        .no-products {
            text-align: center;
            padding: 60px 20px;
            background: white;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        
        .no-products i {
            font-size: 64px;
            color: #6c757d;
            margin-bottom: 20px;
        }
        
        .no-products h2 {
            color: #2c3e50;
            margin-bottom: 10px;
        }
        
        .no-products p {
            color: #6c757d;
            margin-bottom: 20px;
        }
        
        .products-pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 15px;
            margin-top: 30px;
        }
        
        .pagination-btn {
            padding: 10px 20px;
            border: 1px solid #3498db;
            background: white;
            color: #3498db;
            border-radius: 6px;
            cursor: pointer;
        }
        
        .pagination-btn:hover:not(:disabled) {
            background: #3498db;
            color: white;
        }
        
        .pagination-btn:disabled {
            border-color: #6c757d;
            color: #6c757d;
            cursor: not-allowed;
        }
        
        .pagination-info {
            color: #6c757d;
            font-weight: 500;
        }
        
        @media (max-width: 768px) {
            .filter-options {
                flex-direction: column;
            }
            
            .filter-options select {
                min-width: 100%;
            }
            
            .product-grid {
                grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
                gap: 20px;
            }
            
            .product-actions {
                flex-direction: column;
            }
        }
		
		/* Navigation styles */
        
        /* Page Content - SPA (Single Page Application) style navigation */
        .page {
            display: none; /* All pages hidden by default */
            padding: 30px 0;
            min-height: calc(100vh - 200px); /* Minimum height to push footer down */
        }

        .page.active {
            display: block; /* Only active page is shown */
        }

        /* Section title with decorative underline */
        .section-title {
            text-align: center;
            margin-bottom: 30px;
            color: var(--primary);
            position: relative;
            padding-bottom: 15px;
        }

        .section-title:after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 50%;
            transform: translateX(-50%);
            width: 80px;
            height: 3px;
            background-color: var(--secondary); /* Gold underline */
        }

        /* Product grid using CSS Grid for responsive layout */
        .products-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr)); /* Responsive columns */
            gap: 25px;
            margin-top: 20px;
        }

        /* Individual product card */
        .product-card {
            background: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.05);
            transition: transform 0.3s, box-shadow 0.3s; /* Smooth hover effects */
        }

        .product-card:hover {
            transform: translateY(-5px); /* Lift effect on hover */
            box-shadow: 0 6px 12px rgba(0, 0, 0, 0.1); /* Enhanced shadow on hover */
        }

        .product-image {
            height: 200px;
            overflow: hidden;
            position: relative;
        }

        .product-image img {
            width: 100%;
            height: 100%;
            object-fit: cover; /* Ensure images fill container properly */
            transition: transform 0.5s; /* Smooth zoom effect */
        }

        .product-card:hover .product-image img {
            transform: scale(1.05); /* Zoom in slightly on hover */
        }

        /* Action buttons overlay on product image */
        .product-actions {
            position: absolute;
            top: 10px;
            right: 10px;
            display: flex;
            flex-direction: column;
        }

        .action-btn {
            width: 35px;
            height: 35px;
            border-radius: 50%;
            background: white;
            display: flex;
            justify-content: center;
            align-items: center;
            margin-bottom: 8px;
            cursor: pointer;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            transition: background 0.3s, color 0.3s; /* Smooth color transitions */
        }

        .wishlist-btn:hover {
            background: var(--primary);
            color: white;
        }

        .cart-btn:hover {
            background: var(--secondary);
            color: white;
        }

        /* Product information section */
        .product-info {
            padding: 15px;
        }

        .product-title {
            font-weight: 600;
            margin-bottom: 8px;
            color: var(--dark);
        }

        .product-price {
            color: var(--primary); /* Primary color for price */
            font-weight: 700;
            font-size: 18px;
            margin-bottom: 12px;
        }

        .product-description {
            color: #666;
            font-size: 14px;
            margin-bottom: 15px;
        }

        /* Cart & Wishlist item styles */
        .cart-items, .wishlist-items {
            margin-bottom: 30px;
        }

        .cart-item, .wishlist-item {
            display: flex;
            background: white;
            border-radius: 8px;
            overflow: hidden;
            margin-bottom: 15px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.05);
        }

        .cart-item-image, .wishlist-item-image {
            width: 120px;
            height: 120px;
        }

        .cart-item-image img, .wishlist-item-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .cart-item-details, .wishlist-item-details {
            padding: 15px;
            flex-grow: 1;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .cart-item-title, .wishlist-item-title {
            font-weight: 600;
            margin-bottom: 8px;
        }

        .cart-item-price, .wishlist-item-price {
            color: var(--primary);
            font-weight: 700;
            margin-bottom: 8px;
        }

        /* Action buttons in cart/wishlist items */
        .cart-item-actions, .wishlist-item-actions {
            display: flex;
            align-items: center;
            margin-top: 10px;
        }

        .quantity {
            display: flex;
            align-items: center;
            margin-right: 15px;
        }

        .quantity-btn {
            width: 30px;
            height: 30px;
            background: var(--light);
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        .quantity-input {
            width: 40px;
            height: 30px;
            text-align: center;
            margin: 0 5px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }

        .remove-btn {
            background: none;
            border: none;
            color: var(--danger); /* Red color for remove action */
            cursor: pointer;
            font-size: 14px;
            display: flex;
            align-items: center;
        }

        .remove-btn i {
            margin-right: 5px;
        }

        /* Order summary section */
        .cart-total, .checkout-summary {
            background: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.05);
            margin-bottom: 20px;
        }

        .cart-total h3, .checkout-summary h3 {
            margin-bottom: 15px;
            color: var(--primary);
            border-bottom: 1px solid #eee;
            padding-bottom: 10px;
        }

        .total-item {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
        }

        /* Discount section styles */
        .discount-section {
            margin: 15px 0;
            padding: 15px;
            background-color: var(--light);
            border-radius: 8px;
        }

        .discount-input {
            display: flex;
            margin-bottom: 10px;
        }

        .discount-input input {
            flex-grow: 1;
            padding: 10px 15px;
            border: 1px solid #ddd;
            border-radius: 4px 0 0 4px;
            font-size: 16px;
        }

        .discount-input button {
            padding: 10px 15px;
            background: var(--primary);
            color: white;
            border: none;
            border-radius: 0 4px 4px 0;
            cursor: pointer;
            font-weight: 600;
        }

        /* Messages for discount application */
        .discount-message {
            font-size: 14px;
            margin-top: 8px;
            padding: 8px 12px;
            border-radius: 4px;
        }

        .discount-success {
            background-color: rgba(40, 167, 69, 0.2); /* Light green for success */
            color: var(--success);
        }

        .discount-error {
            background-color: rgba(220, 53, 69, 0.2); /* Light red for error */
            color: var(--danger);
        }

        .discount-item {
            display: flex;
            justify-content: space-between;
            color: var(--success); /* Green for discount amount */
            font-weight: 600;
        }

        /* Grand total with top border */
        .grand-total {
            display: flex;
            justify-content: space-between;
            font-weight: 700;
            font-size: 18px;
            margin-top: 15px;
            padding-top: 15px;
            border-top: 1px solid #eee;
        }

        /* Checkout and order buttons */
        .checkout-btn, .place-order-btn {
            display: block;
            width: 100%;
            padding: 12px;
            background: var(--primary);
            color: white;
            border: none;
            border-radius: 4px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.3s;
            margin-top: 20px;
            text-align: center;
            text-decoration: none;
        }

        .checkout-btn:hover, .place-order-btn:hover {
            background: #75122d; /* Darker shade of primary color */
        }

        /* Checkout form styles */
        .checkout-form {
            background: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.05);
            margin-bottom: 30px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
        }

        .form-control {
            width: 100%;
            padding: 10px 15px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 16px;
        }

        /* Form row for side-by-side inputs */
        .form-row {
            display: flex;
            gap: 20px;
        }

        .form-row .form-group {
            flex: 1;
        }

        /* Invoice styles */
        .invoice {
            background: white;
            border-radius: 8px;
            padding: 30px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.05);
            max-width: 800px;
            margin: 0 auto;
        }

        .invoice-header {
            text-align: center;
            margin-bottom: 30px;
        }

        .invoice-details {
            display: flex;
            justify-content: space-between;
            margin-bottom: 30px;
        }

        .invoice-items {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 30px;
        }

        .invoice-items th, .invoice-items td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }

        .invoice-items th {
            background: var(--light);
            font-weight: 600;
        }

        .invoice-total {
            text-align: right;
        }

        .continue-shopping {
            display: block;
            text-align: center;
            margin-top: 30px;
            color: var(--primary);
            font-weight: 500;
            text-decoration: none;
        }

        /* Responsive design for mobile devices */
        @media (max-width: 768px) {
            .header-content {
                flex-direction: column;
                text-align: center;
            }
            
            nav ul {
                margin-top: 15px;
                justify-content: center;
            }
            
            .header-icons {
                margin-top: 15px;
            }
            
            .form-row {
                flex-direction: column;
                gap: 0;
            }
            
            .cart-item, .wishlist-item {
                flex-direction: column;
            }
            
            .cart-item-image, .wishlist-item-image {
                width: 100%;
                height: 200px;
            }
            
            .discount-input {
                flex-direction: column;
            }
            
            .discount-input input {
                border-radius: 4px;
                margin-bottom: 10px;
            }
            
            .discount-input button {
                border-radius: 4px;
            }
        }
        /**/
        /* Cart, Wishlist, Checkout and Invoice Styles */
.cart-item, .wishlist-item {
    display: flex;
    margin-bottom: 20px;
    padding: 15px;
    border: 1px solid #e0e0e0;
    border-radius: 8px;
    background-color: #fff;
}

.cart-item-image, .wishlist-item-image {
    width: 120px;
    height: 120px;
    margin-right: 20px;
    overflow: hidden;
    border-radius: 4px;
}

.cart-item-image img, .wishlist-item-image img {
    width: 100%;
    height: 100%;
    object-fit: cover;
}

.cart-item-details, .wishlist-item-details {
    flex: 1;
}

.cart-item-title, .wishlist-item-title {
    margin: 0 0 10px 0;
    font-size: 18px;
    color: #333;
}

.cart-item-price, .wishlist-item-price {
    margin: 0 0 15px 0;
    font-size: 16px;
    font-weight: bold;
    color: #e74c3c;
}

.cart-item-actions, .wishlist-item-actions {
    display: flex;
    align-items: center;
    gap: 15px;
}

.quantity {
    display: flex;
    align-items: center;
}

.quantity-btn {
    width: 30px;
    height: 30px;
    background-color: #f8f9fa;
    border: 1px solid #ced4da;
    border-radius: 4px;
    cursor: pointer;
    font-weight: bold;
}

.quantity-input {
    width: 40px;
    height: 30px;
    margin: 0 5px;
    text-align: center;
    border: 1px solid #ced4da;
    border-radius: 4px;
}

.remove-btn {
    padding: 8px 12px;
    background-color: #e74c3c;
    color: white;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    font-size: 14px;
}

.remove-btn:hover {
    background-color: #c0392b;
}

.cart-summary, .checkout-summary, .invoice-summary {
    margin-top: 30px;
    padding: 20px;
    border: 1px solid #e0e0e0;
    border-radius: 8px;
    background-color: #f8f9fa;
}

.summary-row {
    display: flex;
    justify-content: space-between;
    margin-bottom: 10px;
    padding-bottom: 10px;
    border-bottom: 1px solid #e0e0e0;
}

.summary-row:last-child {
    border-bottom: none;
    font-weight: bold;
    font-size: 18px;
}

.checkout-form {
    margin-top: 30px;
}

.form-group {
    margin-bottom: 20px;
}

.form-group label {
    display: block;
    margin-bottom: 5px;
    font-weight: bold;
}

.form-group input, .form-group select {
    width: 100%;
    padding: 10px;
    border: 1px solid #ced4da;
    border-radius: 4px;
    font-size: 16px;
}

.discount-section {
    margin: 20px 0;
    padding: 15px;
    border: 1px solid #e0e0e0;
    border-radius: 8px;
    background-color: #f8f9fa;
}

.discount-input {
    display: flex;
    gap: 10px;
}

.discount-input input {
    flex: 1;
}

.discount-message {
    margin-top: 10px;
    padding: 10px;
    border-radius: 4px;
}

.discount-success {
    background-color: #d4edda;
    color: #155724;
    border: 1px solid #c3e6cb;
}

.discount-error {
    background-color: #f8d7da;
    color: #721c24;
    border: 1px solid #f5c6cb;
}

.invoice {
    padding: 30px;
    border: 1px solid #e0e0e0;
    border-radius: 8px;
    background-color: #fff;
}

.invoice-header {
    text-align: center;
    margin-bottom: 30px;
}

.invoice-details {
    display: flex;
    justify-content: space-between;
    margin-bottom: 30px;
}

.invoice-table {
    width: 100%;
    border-collapse: collapse;
    margin-bottom: 30px;
}

.invoice-table th, .invoice-table td {
    padding: 12px;
    text-align: left;
    border-bottom: 1px solid #e0e0e0;
}

.invoice-table th {
    background-color: #f8f9fa;
    font-weight: bold;
}

.invoice-totals {
    width: 50%;
    margin-left: auto;
}

.invoice-total-row {
    display: flex;
    justify-content: space-between;
    padding: 10px 0;
    border-bottom: 1px solid #e0e0e0;
}

.invoice-total-row:last-child {
    font-weight: bold;
    font-size: 18px;
    border-bottom: none;
}

.empty-state {
    text-align: center;
    padding: 40px 0;
}

.empty-state i {
    font-size: 64px;
    color: #bdc3c7;
    margin-bottom: 20px;
}

.empty-state p {
    font-size: 18px;
    color: #7f8c8d;
    margin-bottom: 20px;
}

.continue-shopping {
    display: inline-block;
    padding: 10px 20px;
    background-color: #3498db;
    color: white;
    text-decoration: none;
    border-radius: 4px;
    font-weight: bold;
}

.continue-shopping:hover {
    background-color: #2980b9;
}

/* Notification styles */
        .notification {
            position: fixed;
            top: 20px;
            right: 20px;
            padding: 15px 20px;
            border-radius: 5px;
            color: white;
            z-index: 1000;
            opacity: 0;
            transform: translateX(100%);
            transition: opacity 0.3s, transform 0.3s;
        }
        
        .notification.show {
            opacity: 1;
            transform: translateX(0);
        }
        
        .notification.success {
            background-color: #28a745;
        }
        
        .notification.error {
            background-color: #dc3545;
        }
        
        /* Navigation for SPA pages */
        .spa-nav {
            display: flex;
            justify-content: center;
            margin: 20px 0;
            gap: 15px;
        }
        
        .spa-nav-btn {
            padding: 10px 20px;
            background: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 5px;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .spa-nav-btn:hover {
            background: #e9ecef;
        }
        
        .spa-nav-btn.active {
            background: #3498db;
            color: white;
            border-color: #3498db;
        }
    </style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <div class="products-container">
        <!-- SPA Navigation -->
        <div class="spa-nav">
            <button class="spa-nav-btn active" data-page="products">Products</button>
            <button class="spa-nav-btn" data-page="cart">Cart</button>
            <button class="spa-nav-btn" data-page="wishlist">Wishlist</button>
            <button class="spa-nav-btn" data-page="confirmation" >Confirmation</button>
        </div>

        
        <!-- Products Page -->
        <section id="products" class="page active">
		<div class="products-header">
            <h1>
                <asp:Literal ID="litCategoryTitle" runat="server" />
                <asp:Literal ID="litSearchTitle" runat="server" />
            </h1>
            <p>
                <asp:Literal ID="litProductCount" runat="server" />
            </p>
        </div>

        <div class="products-filter">
            <div class="filter-options">
                <asp:DropDownList ID="ddlSortBy" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlSortBy_SelectedIndexChanged">
                    <asp:ListItem Text="Newest First" Value="newest" Selected="True" />
                    <asp:ListItem Text="Price: Low to High" Value="price_asc" />
                    <asp:ListItem Text="Price: High to Low" Value="price_desc" />
                    <asp:ListItem Text="Name: A to Z" Value="name_asc" />
                    <asp:ListItem Text="Name: Z to A" Value="name_desc" />
                </asp:DropDownList>

                <asp:DropDownList ID="ddlCategory" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlCategory_SelectedIndexChanged">
                    <asp:ListItem Text="All Categories" Value="" />
                    <asp:ListItem Text="Zulu" Value="Zulu" />
                    <asp:ListItem Text="Xhosa" Value="Xhosa" />
                    <asp:ListItem Text="Swazi" Value="Swazi" />
                    <asp:ListItem Text="South Ndebele" Value="SouthNdebele" />
                    <asp:ListItem Text="BaTswana" Value="BaTswana" />
                    <asp:ListItem Text="BaSotho" Value="BaSotho" />
                    <asp:ListItem Text="BaPedi" Value="BaPedi" />
                    <asp:ListItem Text="Tsonga" Value="Tsonga" />
                    <asp:ListItem Text="Venda" Value="Venda" />
                </asp:DropDownList>
            </div>
        </div>

            <div id="productsGrid" runat="server" class="products-grid">
                <!-- Refendering here -->
                <div class="product-card">
                    <div class="product-image">
                        <img src="/placeholder-image.jpg" alt="Product 1">
                        <div class="product-actions">
                            <div class="action-btn wishlist-btn" data-id="1">
                                <i class="fas fa-heart"></i>
                            </div>
                            <div class="action-btn cart-btn" data-id="1">
                                <i class="fas fa-shopping-cart"></i>
                            </div>
                        </div>
                    </div>
                    
                </div>
            </div>
            
            <div class="products-pagination" runat="server" id="divPagination">
                <asp:Button ID="btnPrev" runat="server" Text="Previous" OnClick="btnPrev_Click" 
                    CssClass="pagination-btn" />
                <span class="pagination-info">
                    Page <asp:Literal ID="litCurrentPage" runat="server" /> of 
                    <asp:Literal ID="litTotalPages" runat="server" />
                </span>
                <asp:Button ID="btnNext" runat="server" Text="Next" OnClick="btnNext_Click" 
                    CssClass="pagination-btn" />
            </div>
        </section>
        
        <!-- Shopping Cart Page -->
        <section id="cart" class="page">
            <h2 class="section-title">Your Shopping Cart</h2>
            <div class="cart-content">
                <div class="cart-items" id="cartItems">
                    <!-- Cart items will be dynamically generated here -->
                    <div class="empty-state" id="emptyCart" style="display: none;">
                        <i class="fas fa-shopping-cart"></i>
                        <p>Your cart is empty</p>
                        <a href="#" class="continue-shopping" data-page="products">Continue Shopping</a>
                    </div>
                </div>
                <div class="cart-total">
                    <h3>Order Summary</h3>
                    <div class="total-item">
                        <span>Subtotal</span>
                        <span id="cartSubtotal">R0.00</span>
                    </div>
                    <div class="discount-section">
                        <div class="discount-input">
                            <input type="text" id="discountCode" placeholder="Enter discount code">
                            <button id="applyDiscount" style="background-color: indigo; color: white; padding: 10px 20px; border: none; cursor: pointer;">Apply</button>
                        </div>
                        <div id="discountMessage"></div>
                    </div>
                    <div class="discount-item" id="discountRow" style="display: none;">
                        <span>Discount</span>
                        <span id="discountAmount">-R0.00</span>
                    </div>
                    <div class="grand-total">
                        <span>Total</span>
                        <span id="cartTotal">R0.00</span>
                    </div>
                    <button class="checkout-btn" id="checkoutBtn" style="background-color: indigo; color: white; padding: 10px 20px; border: none; cursor: pointer;">Proceed to Checkout</button>
                </div>
            </div>
        </section>

        <!-- Wishlist Page -->
        <section id="wishlist" class="page">
            <h2 class="section-title">Your Wishlist</h2>
            <div class="wishlist-items" id="wishlistItems">
                <!-- Wishlist items will be dynamically generated here -->
                <div class="empty-state" id="emptyWishlist" style="display: none;">
                    <i class="fas fa-heart"></i>
                    <p>Your wishlist is empty</p>
                    <a href="#" class="continue-shopping" data-page="products">Continue Shopping</a>
                </div>
            </div>
        </section>

        <!-- Checkout Page -->
        <section id="checkout" class="page">
            <h2 class="section-title">Checkout</h2>
            <div class="checkout-content">
                <div class="checkout-form">
                    <h3>Shipping Information</h3>
                    <div class="form-row">
                        <div class="form-group">
                            <label for="firstName">First Name</label>
                            <input type="text" id="firstName" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label for="lastName">Last Name</label>
                            <input type="text" id="lastName" class="form-control" required>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="email">Email Address</label>
                        <input type="email" id="email" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label for="address">Shipping Address</label>
                        <input type="text" id="address" class="form-control" required>
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label for="city">City</label>
                            <input type="text" id="city" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label for="zipCode">ZIP Code</label>
                            <input type="text" id="zipCode" class="form-control" required>
                        </div>
                    </div>
					<h3>Payment Information</h3>
                    <div class="form-group">
                        <label for="cardNumber">Card Number</label>
                        <input type="text" id="cardNumber" class="form-control" placeholder="0000 0000 0000 0000">
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label for="expDate">Expiration Date</label>
                            <input type="text" id="expDate" class="form-control" placeholder="MM/YY">
                        </div>
                        <div class="form-group">
                            <label for="cvv">CVV</label>
                            <input type="text" id="cvv" class="form-control" placeholder="123">
                        </div>
                    </div>
                </div>
                <div class="checkout-summary">
                    <h3>Order Summary</h3>
                    <div class="total-item">
                        <span>Subtotal</span>
                        <span id="checkoutSubtotal">R0.00</span>
                    </div>
                    <div class="discount-item" id="checkoutDiscountRow" style="display: none;">
                        <span>Discount</span>
                        <span id="checkoutDiscount">-R0.00</span>
                    </div>
					<div class="total-item">
                        <span>Shipping:</span>
                        <span id="checkoutShipping">R0.00</span>
                    </div>
                    <div class="total-item">
                        <span>Tax:</span>
                        <span id="checkoutTax">R0.00</span>
                    </div>
                    <div class="grand-total">
                        <span>Total</span>
                        <span id="checkoutTotal">R0.00</span>
                    </div>
                    <button class="place-order-btn" id="placeOrderBtn" style="background-color: indigo; color: white; padding: 10px 20px; border: none; cursor: pointer; onClick=placeOrder()">Place Order</button>
                </div>
            </div>
        </section>

        <!-- Order Confirmation Page -->
<section id="confirmation" class="page">
    <div class="invoice">
        <div class="invoice-header">
            <h2>Order Confirmation</h2>
            <p>Thank you for your purchase!</p>
        </div>
        <div class="invoice-details">
            <div>
                <p><strong>Order ID:</strong> <span id="orderId">HT-12345</span></p>
                <p><strong>Order Date:</strong> <span id="orderDate"></span></p>
            </div>
            <div>
                <p><strong>Ship to:</strong></p>
                <p id="shipAddress"></p>
            </div>
        </div>
        <table class="invoice-items">
            <thead>
                <tr>
                    <th>Product</th>
                    <th>Quantity</th>
                    <th>Price</th>
                    <th>Total</th>
                </tr>
            </thead>
            <tbody id="invoiceItems">
                <!-- Invoice items will be dynamically generated here -->
            </tbody>
        </table>
        <div class="invoice-total">
            <p>Subtotal: <span id="invoiceSubtotal">R0.00</span></p>
            <p id="invoiceDiscountRow" style="display: none;">
                Discount: <span id="invoiceDiscount">-R0.00</span>
            </p>
            <p>Shipping: <span id="invoiceShipping">R0.00</span></p>
            <p>Tax: <span id="invoiceTax">R0.00</span></p>
            <p><strong>Total: <span id="invoiceTotal">R0.00</span></strong></p>
        </div>
        <a href="#" class="continue-shopping" data-page="products">Continue Shopping</a>
    </div>
</section>
    </div>
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="ScriptContent" runat="server">
    <script>
        // Get cart and wishlist from server-side session
        let cart = <%= GetCartJson() %> || [];
        let wishlist = <%= GetWishlistJson() %> || [];
        let activeDiscount = JSON.parse(localStorage.getItem('activeDiscount')) || null;

        // Discount codes
        const discountCodes = {
            "WELCOME10": { type: "percentage", value: 10, minPurchase: 0 },
            "TRADITIONAL15": { type: "percentage", value: 15, minPurchase: 100 },
            "FREESHIP": { type: "shipping", value: 0, minPurchase: 50 },
            "SAVE20": { type: "fixed", value: 20, minPurchase: 75 }
        };

        // DOM Elements
        const pages = document.querySelectorAll('.page');
        const navButtons = document.querySelectorAll('.spa-nav-btn');
        const cartItemsContainer = document.getElementById('cartItems');
        const wishlistItemsContainer = document.getElementById('wishlistItems');
        const checkoutBtn = document.getElementById('checkoutBtn');
        const placeOrderBtn = document.getElementById('placeOrderBtn');
        const discountCodeInput = document.getElementById('discountCode');
        const applyDiscountBtn = document.getElementById('applyDiscount');
        const discountMessage = document.getElementById('discountMessage');
        const continueShoppingLinks = document.querySelectorAll('.continue-shopping');

        // Function to show notification
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

        // Function to add product to cart
        function addToCart(productId, productName, productPrice, productImage) {
            // Check if user is logged in
            const isLoggedIn = <%= Session["UserID"] != null ? "true" : "false" %>;

            if (!isLoggedIn) {
                showNotification('Please log in to add items to cart', 'error');
                setTimeout(() => {
                    window.location.href = 'Login.aspx?returnUrl=' + encodeURIComponent(window.location.href);
                }, 2000);
                return;
            }

            // Use __doPostBack to call server-side method
            __doPostBack('AddToCart', productId.toString());
        }

        // Function to add product to wishlist
        function addToWishlist(productId, productName, productPrice, productImage) {
            // Check if user is logged in
            const isLoggedIn = <%= Session["UserID"] != null ? "true" : "false" %>;

            if (!isLoggedIn) {
                showNotification('Please log in to add items to wishlist', 'error');
                setTimeout(() => {
                    window.location.href = 'Login.aspx?returnUrl=' + encodeURIComponent(window.location.href);
                }, 2000);
                return;
            }

            // Use __doPostBack to call server-side method
            __doPostBack('AddToWishlist', productId.toString());
        }

        // Function to update cart count in navigation
        function updateCartCount() {
            const cartCount = document.querySelector('.cart-count');
            if (cartCount) {
                const totalItems = cart.reduce((sum, item) => sum + item.Quantity, 0);
                cartCount.textContent = totalItems;
                cartCount.style.display = totalItems > 0 ? 'block' : 'none';
            }
        }

        // Function to update wishlist count in navigation
        function updateWishlistCount() {
            const wishlistCount = document.querySelector('.wishlist-count');
            if (wishlistCount) {
                wishlistCount.textContent = wishlist.length;
                wishlistCount.style.display = wishlist.length > 0 ? 'block' : 'none';
            }
        }

        // Function to show a specific page
        function showPage(pageId) {
            pages.forEach(page => page.classList.remove('active'));
            document.getElementById(pageId).classList.add('active');

            navButtons.forEach(btn => {
                if (btn.dataset.page === pageId) {
                    //btn.classList.add('active');
                    //if (pageId === 'confirmation') {
                    //    btn.style.display = 'block';
                    //}
                } else {
                    btn.classList.remove('active');
                    //if (btn.dataset.page === 'confirmation' && pageId !== 'confirmation') {
                    //    btn.style.display = 'none';
                    //}
                }
            });

            if (pageId === 'cart') {
                updateCartDisplay();
            } else if (pageId === 'wishlist') {
                updateWishlistDisplay();
            }
        }

        // Function to update cart display
        function updateCartDisplay() {
            const emptyCart = document.getElementById('emptyCart');
            const cartItems = document.getElementById('cartItems');

            if (cart.length === 0) {
                emptyCart.style.display = 'block';
                cartItems.innerHTML = '';
            } else {
                emptyCart.style.display = 'none';
                let cartHTML = '';

                cart.forEach(item => {
                    const total = item.Price * item.Quantity;
                    const imageUrl = item.ImageURL || '/placeholder-image.jpg';

                    cartHTML += `
                <div class="cart-item" data-id="${item.ProductID}">
                    <div class="cart-item-image">
                        <img src="${imageUrl}" alt="${item.Name}">
                    </div>
                    <div class="cart-item-details">
                        <h4 class="cart-item-title">${item.Name}</h4>
                        <div class="cart-item-price">R${item.Price.toFixed(2)}</div>
                        <div class="cart-item-actions">
                            <div class="quantity">
                                <button class="quantity-btn minus" data-id="${item.ProductID}">-</button>
                                <input type="text" class="quantity-input" value="${item.Quantity}" readonly>
                                <button class="quantity-btn plus" data-id="${item.ProductID}">+</button>
                            </div>
                            <button class="remove-btn" data-id="${item.ProductID}">
                                <i class="fas fa-trash"></i> Remove
                            </button>
                        </div>
                    </div>
                    <div class="cart-item-total">
                        R${total.toFixed(2)}
                    </div>
                </div>
            `;
                });
                cartItems.innerHTML = cartHTML;

                // Add event listeners
                document.querySelectorAll('quantity-btn plus').forEach(btn => {
                    btn.addEventListener('click', () => {
                        const id = parseInt(btn.dataset.id);
                        const item = cart.find(item => item.ProductID === id);
                        if (item) {
                            item.Quantity += 1;
                            updateCartOnServer();
                        }
                    });
                });

                document.querySelectorAll('quantity-btn minus').forEach(btn => {
                    btn.addEventListener('click', () => {
                        const id = parseInt(btn.dataset.id);
                        const item = cart.find(item => item.ProductID === id);
                        if (item) {
                            if (item.Quantity > 1) {
                                item.Quantity -= 1;
                            } else {
                                cart = cart.filter(cartItem => cartItem.ProductID !== id);
                            }
                            updateCartOnServer();
                        }
                    });
                });

                document.querySelectorAll('.remove-btn').forEach(btn => {
                    btn.addEventListener('click', () => {
                        const id = parseInt(btn.dataset.id);
                        cart = cart.filter(item => item.ProductID !== id);
                        updateCartOnServer();
                        showNotification('Item removed from cart', 'success');
                    });
                });
            }

            updateCartTotals();
        }

        // Function to update cart on server
        function updateCartOnServer() {
            // You can implement AJAX call here to update server-side cart
            // For now, we'll just update the display
            updateCartDisplay();
            updateCartCount();
        }

        // Function to update cart totals
        function updateCartTotals() {
            const subtotal = cart.reduce((sum, item) => sum + (item.Price * item.Quantity), 0);
            document.getElementById('cartSubtotal').textContent = `R${subtotal.toFixed(2)}`;

            let discountAmount = 0;
            let shipping = subtotal > 1000 ? 0 : 100;
            let tax = subtotal * 0.15;
            let total = subtotal + tax + shipping;

            if (activeDiscount) {
                const discount = discountCodes[activeDiscount.code];
                if (discount) {
                    if (discount.type === 'percentage') {
                        discountAmount = subtotal * (discount.value / 100);
                    } else if (discount.type === 'fixed') {
                        discountAmount = discount.value;
                    } else if (discount.type === 'shipping') {
                        shipping = 0;
                    }

                    total = subtotal - discountAmount + tax + shipping;

                    document.getElementById('discountRow').style.display = 'flex';
                    document.getElementById('discountAmount').textContent = `-R${discountAmount.toFixed(2)}`;
                }
            } else {
                document.getElementById('discountRow').style.display = 'none';
            }

            document.getElementById('checkoutShipping').textContent = `R${shipping.toFixed(2)}`;
            document.getElementById('checkoutTax').textContent = `R${tax.toFixed(2)}`;
            document.getElementById('cartTotal').textContent = `R${total.toFixed(2)}`;

            if (document.getElementById('checkout').classList.contains('active')) {
                document.getElementById('checkoutSubtotal').textContent = `R${subtotal.toFixed(2)}`;
                if (activeDiscount) {
                    document.getElementById('checkoutDiscountRow').style.display = 'flex';
                    document.getElementById('checkoutDiscount').textContent = `-R${discountAmount.toFixed(2)}`;
                } else {
                    document.getElementById('checkoutDiscountRow').style.display = 'none';
                }
                document.getElementById('checkoutShipping').textContent = `R${shipping.toFixed(2)}`;
                document.getElementById('checkoutTax').textContent = `R${tax.toFixed(2)}`;
                document.getElementById('checkoutTotal').textContent = `R${total.toFixed(2)}`;
            }
        }

        // Function to update wishlist display
        function updateWishlistDisplay() {
            const emptyWishlist = document.getElementById('emptyWishlist');
            const wishlistItems = document.getElementById('wishlistItems');

            if (wishlist.length === 0) {
                emptyWishlist.style.display = 'block';
                wishlistItems.innerHTML = '';
            } else {
                emptyWishlist.style.display = 'none';
                let wishlistHTML = '';

                wishlist.forEach(item => {
                    const imageUrl = item.ImageURL || '/placeholder-image.jpg';

                    wishlistHTML += `
                <div class="wishlist-item" data-id="${item.ProductID}">
                    <div class="wishlist-item-image">
                        <img src="${imageUrl}" alt="${item.Name}">
                    </div>
                    <div class="wishlist-item-details">
                        <h4 class="wishlist-item-title">${item.Name}</h4>
                        <div class="wishlist-item-price">R${item.Price.toFixed(2)}</div>
                        <div class="wishlist-item-actions">
                            <button class="add-to-cart-btn" data-id="${item.ProductID}" 
                                    data-name="${item.Name}" data-price="${item.Price}" 
                                    data-image="${imageUrl}">
                                <i class="fas fa-shopping-cart"></i> Add to Cart
                            </button>
                            <button class="remove-btn" data-id="${item.ProductID}">
                                <i class="fas fa-trash"></i> Remove
                            </button>
                        </div>
                    </div>
                </div>
            `;
                });
                wishlistItems.innerHTML = wishlistHTML;

                // Add event listeners
                document.querySelectorAll('.wishlist-item .add-to-cart-btn').forEach(btn => {
                    btn.addEventListener('click', () => {
                        const id = parseInt(btn.dataset.id);
                        const name = btn.dataset.name;
                        const price = parseFloat(btn.dataset.price);
                        const image = btn.dataset.image;
                        addToCart(id, name, price, image);
                    });
                });

                document.querySelectorAll('.wishlist-item .remove-btn').forEach(btn => {
                    btn.addEventListener('click', () => {
                        const id = parseInt(btn.dataset.id);
                        wishlist = wishlist.filter(item => item.ProductID !== id);
                        updateWishlistOnServer();
                        showNotification('Removed from wishlist', 'success');
                    });
                });
            }
        }

        // Function to update wishlist on server
        function updateWishlistOnServer() {
            // You can implement AJAX call here to update server-side wishlist
            updateWishlistDisplay();
            updateWishlistCount();
        }

        // Function to apply discount code
        function applyDiscount() {
            const code = discountCodeInput.value.trim().toUpperCase();

            if (!code) {
                discountMessage.textContent = 'Please enter a discount code';
                discountMessage.style.color = '#dc3545';
                return;
            }

            if (!discountCodes[code]) {
                discountMessage.textContent = 'Invalid discount code';
                discountMessage.style.color = '#dc3545';
                return;
            }

            const discount = discountCodes[code];
            const subtotal = cart.reduce((sum, item) => sum + (item.Price * item.Quantity), 0);

            if (subtotal < discount.minPurchase) {
                discountMessage.textContent = `Minimum purchase of R${discount.minPurchase} required`;
                discountMessage.style.color = '#dc3545';
                return;
            }

            activeDiscount = { code: code };
            localStorage.setItem('activeDiscount', JSON.stringify(activeDiscount));

            discountMessage.textContent = 'Discount applied successfully!';
            discountMessage.style.color = '#28a745';

            updateCartTotals();
        }

        // Function to process checkout
        function processCheckout() {
            if (cart.length === 0) {
                showNotification('Your cart is empty', 'error');
                return;
            }

            showPage('checkout');

            const subtotal = cart.reduce((sum, item) => sum + (item.Price * item.Quantity), 0);
            document.getElementById('checkoutSubtotal').textContent = `R${subtotal.toFixed(2)}`;

            let discountAmount = 0;
            let total = subtotal;

            if (activeDiscount) {
                const discount = discountCodes[activeDiscount.code];
                if (discount) {
                    if (discount.type === 'percentage') {
                        discountAmount = subtotal * (discount.value / 100);
                    } else if (discount.type === 'fixed') {
                        discountAmount = discount.value;
                    }

                    total = subtotal - discountAmount;

                    document.getElementById('checkoutDiscountRow').style.display = 'flex';
                    document.getElementById('checkoutDiscount').textContent = `-R${discountAmount.toFixed(2)}`;
                }
            } else {
                document.getElementById('checkoutDiscountRow').style.display = 'none';
            }

            document.getElementById('checkoutTotal').textContent = `R${total.toFixed(2)}`;
        }

        function placeOrder() {
            const firstName = document.getElementById('firstName').value;
            const lastName = document.getElementById('lastName').value;
            const email = document.getElementById('email').value;
            const address = document.getElementById('address').value;
            const city = document.getElementById('city').value;
            const zipCode = document.getElementById('zipCode').value;
            const cardNumber = document.getElementById('cardNumber').value;
            const expDate = document.getElementById('expDate').value;
            const cvv = document.getElementById('cvv').value;

            if (!firstName || !lastName || !email || !address || !city || !zipCode || !cardNumber || !expDate || !cvv) {
                showNotification('Please fill all required fields', 'error');
                return;
            }

            showNotification('Processing your order...', 'success');

            const orderId = 'HT-' + Math.floor(10000 + Math.random() * 90000);
            const orderDate = new Date().toLocaleDateString();
            const subtotal = cart.reduce((sum, item) => sum + (item.Price * item.Quantity), 0);

            let discountAmount = 0;
            let total = subtotal;

            if (activeDiscount) {
                const discount = discountCodes[activeDiscount.code];
                if (discount) {
                    if (discount.type === 'percentage') {
                        discountAmount = subtotal * (discount.value / 100);
                    } else if (discount.type === 'fixed') {
                        discountAmount = discount.value;
                    }
                    total = subtotal - discountAmount;
                }
            }

            // Update invoice details
            document.getElementById('orderId').textContent = orderId;
            document.getElementById('orderDate').textContent = orderDate;
            document.getElementById('shipAddress').textContent = `${firstName} ${lastName}, ${address}, ${city}, ${zipCode}`;

            // Generate invoice items
            let invoiceItemsHTML = '';
            cart.forEach(item => {
                const itemTotal = item.Price * item.Quantity;
                invoiceItemsHTML += `
            <tr>
                <td>${item.Name}</td>
                <td>${item.Quantity}</td>
                <td>R${item.Price.toFixed(2)}</td>
                <td>R${itemTotal.toFixed(2)}</td>
            </tr>
        `;
            });
            document.getElementById('invoiceItems').innerHTML = invoiceItemsHTML;

            // Update invoice totals
            document.getElementById('invoiceSubtotal').textContent = `R${subtotal.toFixed(2)}`;
            document.getElementById('invoiceTotal').textContent = `R${total.toFixed(2)}`;

            if (discountAmount > 0) {
                document.getElementById('invoiceDiscountRow').style.display = 'block';
                document.getElementById('invoiceDiscount').textContent = `-R${discountAmount.toFixed(2)}`;
            } else {
                document.getElementById('invoiceDiscountRow').style.display = 'none';
            }

            // Clear cart and discount
            cart = [];
            activeDiscount = null;
            localStorage.removeItem('activeDiscount');
            updateCartCount();

            // Show confirmation page
            showPage('confirmation');
        }

        // Event Listeners
        document.addEventListener('DOMContentLoaded', function () {
            updateCartCount();
            updateWishlistCount();

            navButtons.forEach(btn => {
                btn.addEventListener('click', () => {
                    showPage(btn.dataset.page);
                });
            });

            // Add event listeners to product buttons
            document.addEventListener('click', function (e) {
                if (e.target.closest('.add-to-cart-btn')) {
                    const btn = e.target.closest('.add-to-cart-btn');
                    const productId = parseInt(btn.dataset.id);
                    const productName = btn.dataset.name;
                    const productPrice = parseFloat(btn.dataset.price);
                    const productImage = btn.dataset.image;
                    addToCart(productId, productName, productPrice, productImage);
                }

                if (e.target.closest('.wishlist-btn')) {
                    const btn = e.target.closest('.wishlist-btn');
                    const productId = parseInt(btn.dataset.id);
                    const productName = btn.dataset.name;
                    const productPrice = parseFloat(btn.dataset.price);
                    const productImage = btn.dataset.image;
                    addToWishlist(productId, productName, productPrice, productImage);
                }
            });

            checkoutBtn.addEventListener('click', processCheckout);
            placeOrderBtn.addEventListener('click', placeOrder);
            applyDiscountBtn.addEventListener('click', applyDiscount);

            continueShoppingLinks.forEach(link => {
                link.addEventListener('click', function (e) {
                    e.preventDefault();
                    showPage(this.dataset.page);
                });
            });
        });

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