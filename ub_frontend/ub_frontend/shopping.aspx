<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="shopping.aspx.cs" Inherits="ub_frontend.shopping" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Heritage Threads | Traditional Attire</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        :root {
            --primary: #8a1538;
            --secondary: #d4af37;
            --light: #f8f5f0;
            --dark: #2a2a2a;
            --success: #28a745;
            --danger: #dc3545;
        }

        body {
            background-color: #f9f9f9;
            color: var(--dark);
            line-height: 1.6;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 15px;
        }

        /* Header Styles */
        header {
            background-color: white;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .header-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 0;
        }

        .logo {
            display: flex;
            align-items: center;
        }

        .logo h1 {
            color: var(--primary);
            font-size: 24px;
            font-weight: 700;
        }

        .logo span {
            color: var(--secondary);
        }

        nav ul {
            display: flex;
            list-style: none;
        }

        nav ul li {
            margin-left: 25px;
        }

        nav ul li a {
            text-decoration: none;
            color: var(--dark);
            font-weight: 500;
            transition: color 0.3s;
        }

        nav ul li a:hover {
            color: var(--primary);
        }

        .header-icons {
            display: flex;
            align-items: center;
        }

        .cart-icon, .wishlist-icon {
            position: relative;
            margin-left: 20px;
            cursor: pointer;
        }

        .icon-badge {
            position: absolute;
            top: -8px;
            right: -8px;
            background-color: var(--primary);
            color: white;
            border-radius: 50%;
            width: 18px;
            height: 18px;
            font-size: 12px;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        /* Page Content */
        .page {
            display: none;
            padding: 30px 0;
            min-height: calc(100vh - 200px);
        }

        .page.active {
            display: block;
        }

        /* Product Grid */
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
            background-color: var(--secondary);
        }

        .products-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 25px;
            margin-top: 20px;
        }

        .product-card {
            background: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.05);
            transition: transform 0.3s, box-shadow 0.3s;
        }

        .product-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 6px 12px rgba(0, 0, 0, 0.1);
        }

        .product-image {
            height: 200px;
            overflow: hidden;
            position: relative;
        }

        .product-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.5s;
        }

        .product-card:hover .product-image img {
            transform: scale(1.05);
        }

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
            transition: background 0.3s, color 0.3s;
        }

        .wishlist-btn:hover {
            background: var(--primary);
            color: white;
        }

        .cart-btn:hover {
            background: var(--secondary);
            color: white;
        }

        .product-info {
            padding: 15px;
        }

        .product-title {
            font-weight: 600;
            margin-bottom: 8px;
            color: var(--dark);
        }

        .product-price {
            color: var(--primary);
            font-weight: 700;
            font-size: 18px;
            margin-bottom: 12px;
        }

        .product-description {
            color: #666;
            font-size: 14px;
            margin-bottom: 15px;
        }

        /* Cart & Wishlist */
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
            color: var(--danger);
            cursor: pointer;
            font-size: 14px;
            display: flex;
            align-items: center;
        }

        .remove-btn i {
            margin-right: 5px;
        }

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

        .discount-message {
            font-size: 14px;
            margin-top: 8px;
            padding: 8px 12px;
            border-radius: 4px;
        }

        .discount-success {
            background-color: rgba(40, 167, 69, 0.2);
            color: var(--success);
        }

        .discount-error {
            background-color: rgba(220, 53, 69, 0.2);
            color: var(--danger);
        }

        .discount-item {
            display: flex;
            justify-content: space-between;
            color: var(--success);
            font-weight: 600;
        }

        .grand-total {
            display: flex;
            justify-content: space-between;
            font-weight: 700;
            font-size: 18px;
            margin-top: 15px;
            padding-top: 15px;
            border-top: 1px solid #eee;
        }

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
            background: #75122d;
        }

        /* Checkout Form */
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

        .form-row {
            display: flex;
            gap: 20px;
        }

        .form-row .form-group {
            flex: 1;
        }

        /* Invoice */
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

        /* Footer */
        footer {
            background: var(--dark);
            color: white;
            padding: 40px 0 20px;
        }

        .footer-content {
            display: flex;
            justify-content: space-between;
            flex-wrap: wrap;
            margin-bottom: 30px;
        }

        .footer-column {
            flex: 1;
            min-width: 200px;
            margin-bottom: 20px;
        }

        .footer-column h3 {
            color: var(--secondary);
            margin-bottom: 20px;
            font-size: 18px;
        }

        .footer-column ul {
            list-style: none;
        }

        .footer-column ul li {
            margin-bottom: 10px;
        }

        .footer-column ul li a {
            color: #ddd;
            text-decoration: none;
            transition: color 0.3s;
        }

        .footer-column ul li a:hover {
            color: var(--secondary);
        }

        .copyright {
            text-align: center;
            padding-top: 20px;
            border-top: 1px solid #444;
            color: #aaa;
            font-size: 14px;
        }

        /* Responsive */
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
    </style>
</head>
<body>
    <!-- Header -->
    <header>
        <div class="container">
            <div class="header-content">
                <div class="logo">
                    <h1>Heritage<span>Threads</span></h1>
                </div>
                <nav>
                    <ul>
                        <li><a href="#" class="nav-link" data-page="index">Home</a></li>
                        <li><a href="#" class="nav-link" data-page="cart">Cart</a></li>
                        <li><a href="#" class="nav-link" data-page="wishlist">Wishlist</a></li>
                    </ul>
                </nav>
                <div class="header-icons">
                    <div class="cart-icon" id="cartIcon">
                        <i class="fas fa-shopping-cart fa-lg"></i>
                        <span class="icon-badge" id="cartCount">0</span>
                    </div>
                    <div class="wishlist-icon" id="wishlistIcon">
                        <i class="fas fa-heart fa-lg"></i>
                        <span class="icon-badge" id="wishlistCount">0</span>
                    </div>
                </div>
            </div>
        </div>
    </header>

    <!-- Main Content -->
    <div class="container">
        <!-- Index Page -->
        <div id="index" class="page active">
            <h2 class="section-title">Featured Traditional Attire</h2>
            <div class="products-grid" id="productsGrid">
                <!-- Products will be loaded here by JavaScript -->
            </div>
        </div>

        <!-- Cart Page -->
        <div id="cart" class="page">
            <h2 class="section-title">Your Shopping Cart</h2>
            <div class="cart-items" id="cartItems">
                <!-- Cart items will be loaded here by JavaScript -->
            </div>
            <div class="cart-total">
                <h3>Order Summary</h3>
                <div class="total-item">
                    <span>Subtotal:</span>
                    <span id="cartSubtotal">$0.00</span>
                </div>
                
                <!-- Discount Section -->
                <div class="discount-section">
                    <h4>Apply Discount Code</h4>
                    <div class="discount-input">
                        <input type="text" id="discountCode" placeholder="Enter discount code">
                        <button id="applyDiscount">Apply</button>
                    </div>
                    <div id="discountMessage" class="discount-message"></div>
                </div>
                
                <div class="total-item" id="discountRow" style="display: none;">
                    <span>Discount:</span>
                    <span id="cartDiscount">-$0.00</span>
                </div>
                
                <div class="total-item">
                    <span>Shipping:</span>
                    <span id="cartShipping">$0.00</span>
                </div>
                <div class="total-item">
                    <span>Tax:</span>
                    <span id="cartTax">$0.00</span>
                </div>
                <div class="grand-total">
                    <span>Total:</span>
                    <span id="cartTotal">$0.00</span>
                </div>
                <a href="#" class="checkout-btn" id="checkoutBtn">Proceed to Checkout</a>
            </div>
        </div>

        <!-- Checkout Page -->
        <div id="checkout" class="page">
            <h2 class="section-title">Checkout</h2>
            <div class="form-row">
                <div class="checkout-form">
                    <h3>Shipping Information</h3>
                    <div class="form-group">
                        <label for="fullName">Full Name</label>
                        <input type="text" id="fullName" class="form-control" placeholder="Your full name">
                    </div>
                    <div class="form-group">
                        <label for="email">Email Address</label>
                        <input type="email" id="email" class="form-control" placeholder="Your email address">
                    </div>
                    <div class="form-group">
                        <label for="address">Shipping Address</label>
                        <input type="text" id="address" class="form-control" placeholder="Your shipping address">
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label for="city">City</label>
                            <input type="text" id="city" class="form-control" placeholder="City">
                        </div>
                        <div class="form-group">
                            <label for="zipCode">ZIP Code</label>
                            <input type="text" id="zipCode" class="form-control" placeholder="ZIP Code">
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
                        <span>Subtotal:</span>
                        <span id="checkoutSubtotal">$0.00</span>
                    </div>
                    
                    <div class="total-item" id="checkoutDiscountRow" style="display: none;">
                        <span>Discount:</span>
                        <span id="checkoutDiscount">-$0.00</span>
                    </div>
                    
                    <div class="total-item">
                        <span>Shipping:</span>
                        <span id="checkoutShipping">$0.00</span>
                    </div>
                    <div class="total-item">
                        <span>Tax:</span>
                        <span id="checkoutTax">$0.00</span>
                    </div>
                    <div class="grand-total">
                        <span>Total:</span>
                        <span id="checkoutTotal">$0.00</span>
                    </div>
                    <a href="#" class="place-order-btn" id="placeOrderBtn">Place Order</a>
                </div>
            </div>
        </div>

        <!-- Invoice Page -->
        <div id="invoice" class="page">
            <h2 class="section-title">Order Confirmation</h2>
            <div class="invoice">
                <div class="invoice-header">
                    <h2>HeritageThreads</h2>
                    <p>123 Traditional Way, Culture City</p>
                    <p>Phone: (123) 456-7890 | Email: info@heritagethreads.com</p>
                </div>
                <div class="invoice-details">
                    <div>
                        <h3>Invoice #: HT-2023-001</h3>
                        <p>Date: <span id="invoiceDate"></span></p>
                    </div>
                    <div>
                        <h3>Ship To:</h3>
                        <p id="invoiceCustomer">Customer Name</p>
                        <p id="invoiceAddress">Customer Address</p>
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
                        <!-- Invoice items will be loaded here by JavaScript -->
                    </tbody>
                </table>
                <div class="invoice-total">
                    <p>Subtotal: <span id="invoiceSubtotal">$0.00</span></p>
                    
                    <p id="invoiceDiscountRow" style="display: none;">
                        Discount: <span id="invoiceDiscount">-$0.00</span>
                    </p>
                    
                    <p>Shipping: <span id="invoiceShipping">$0.00</span></p>
                    <p>Tax: <span id="invoiceTax">$0.00</span></p>
                    <p><strong>Grand Total: <span id="invoiceTotal">$0.00</span></strong></p>
                </div>
                <p>Thank you for your purchase! Your order will be shipped within 2-3 business days.</p>
                <a href="#" class="continue-shopping" data-page="index">Continue Shopping</a>
            </div>
        </div>

        <!-- Wishlist Page -->
        <div id="wishlist" class="page">
            <h2 class="section-title">Your Wishlist</h2>
            <div class="wishlist-items" id="wishlistItems">
                <!-- Wishlist items will be loaded here by JavaScript -->
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer>
        <div class="container">
            <div class="footer-content">
                <div class="footer-column">
                    <h3>HeritageThreads</h3>
                    <p>Bringing traditional attire to the modern world with quality and style.</p>
                </div>
                <div class="footer-column">
                    <h3>Quick Links</h3>
                    <ul>
                        <li><a href="#" data-page="index">Home</a></li>
                        <li><a href="#" data-page="cart">Cart</a></li>
                        <li><a href="#" data-page="wishlist">Wishlist</a></li>
                    </ul>
                </div>
                <div class="footer-column">
                    <h3>Customer Service</h3>
                    <ul>
                        <li><a href="#">Contact Us</a></li>
                        <li><a href="#">Shipping Policy</a></li>
                        <li><a href="#">Returns & Exchanges</a></li>
                    </ul>
                </div>
                <div class="footer-column">
                    <h3>Connect With Us</h3>
                    <ul>
                        <li><a href="#"><i class="fab fa-facebook"></i> Facebook</a></li>
                        <li><a href="#"><i class="fab fa-instagram"></i> Instagram</a></li>
                        <li><a href="#"><i class="fab fa-pinterest"></i> Pinterest</a></li>
                    </ul>
                </div>
            </div>
            <div class="copyright">
                <p>&copy; 2023 HeritageThreads. All rights reserved.</p>
            </div>
        </div>
    </footer>

    <script>
        // Sample product data
        const products = [
            {
                id: 1,
                name: "Embroidered Abaya",
                price: 89.99,
                image: "https://images.unsplash.com/photo-1594633312681-425c7b97ccd1?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NXx8YWJheWF8ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60",
                description: "Beautiful black abaya with intricate embroidery details."
            },
            {
                id: 2,
                name: "Silk Saree",
                price: 129.99,
                image: "https://images.unsplash.com/photo-1603274991177-e3728493a440?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTB8fHNhcmVlfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60",
                description: "Elegant silk saree with golden border and matching blouse."
            },
            {
                id: 3,
                name: "Kente Cloth",
                price: 74.99,
                image: "https://images.unsplash.com/photo-1588850790165-5d517ead7873?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8a2VudGUlMjBjbG90aHxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60",
                description: "Traditional African kente cloth with vibrant patterns."
            },
            {
                id: 4,
                name: "Japanese Kimono",
                price: 159.99,
                image: "https://images.unsplash.com/photo-1556306535-38febf6783e7?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTJ8fGphcGFuZXNlJTIwa2ltb25vfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60",
                description: "Authentic Japanese kimono with obi belt and traditional patterns."
            },
            {
                id: 5,
                name: "Indian Sherwani",
                price: 199.99,
                image: "https://images.unsplash.com/photo-1603251578193-98d31cbb5dbb?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTB8fHNoZXJ3YW5pfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60",
                description: "Regal sherwani for weddings and special occasions."
            },
            {
                id: 6,
                name: "Hanbok Dress",
                price: 119.99,
                image: "https://images.unsplash.com/photo-1631671831360-49dfaed1b0d9?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8aGFuYm9rfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60",
                description: "Traditional Korean hanbok in vibrant colors with delicate embroidery."
            }
        ];

        // Discount codes
        const discountCodes = {
            "WELCOME10": { type: "percentage", value: 10, minPurchase: 0 },
            "TRADITIONAL15": { type: "percentage", value: 15, minPurchase: 100 },
            "FREESHIP": { type: "shipping", value: 0, minPurchase: 50 },
            "SAVE20": { type: "fixed", value: 20, minPurchase: 75 }
        };

        // Initialize cart and wishlist
        let cart = JSON.parse(localStorage.getItem('cart')) || [];
        let wishlist = JSON.parse(localStorage.getItem('wishlist')) || [];
        let activeDiscount = JSON.parse(localStorage.getItem('activeDiscount')) || null;

        // DOM Elements
        const pages = document.querySelectorAll('.page');
        const navLinks = document.querySelectorAll('.nav-link');
        const cartIcon = document.getElementById('cartIcon');
        const wishlistIcon = document.getElementById('wishlistIcon');
        const cartCount = document.getElementById('cartCount');
        const wishlistCount = document.getElementById('wishlistCount');
        const productsGrid = document.getElementById('productsGrid');
        const cartItems = document.getElementById('cartItems');
        const wishlistItems = document.getElementById('wishlistItems');
        const checkoutBtn = document.getElementById('checkoutBtn');
        const placeOrderBtn = document.getElementById('placeOrderBtn');
        const discountCodeInput = document.getElementById('discountCode');
        const applyDiscountBtn = document.getElementById('applyDiscount');
        const discountMessage = document.getElementById('discountMessage');

        // Display products on the index page
        function displayProducts() {
            productsGrid.innerHTML = '';
            products.forEach(product => {
                const isInWishlist = wishlist.some(item => item.id === product.id);
                
                const productCard = document.createElement('div');
                productCard.className = 'product-card';
                productCard.innerHTML = `
                    <div class="product-image">
                        <img src="${product.image}" alt="${product.name}">
                        <div class="product-actions">
                            <div class="action-btn wishlist-btn ${isInWishlist ? 'active' : ''}" data-id="${product.id}">
                                <i class="fas fa-heart"></i>
                            </div>
                            <div class="action-btn cart-btn" data-id="${product.id}">
                                <i class="fas fa-shopping-cart"></i>
                            </div>
                        </div>
                    </div>
                    <div class="product-info">
                        <h3 class="product-title">${product.name}</h3>
                        <p class="product-price">$${product.price.toFixed(2)}</p>
                        <p class="product-description">${product.description}</p>
                    </div>
                `;
                productsGrid.appendChild(productCard);
            });

            // Add event listeners to product action buttons
            document.querySelectorAll('.wishlist-btn').forEach(btn => {
                btn.addEventListener('click', (e) => {
                    const productId = parseInt(e.currentTarget.getAttribute('data-id'));
                    toggleWishlist(productId);
                });
            });

            document.querySelectorAll('.cart-btn').forEach(btn => {
                btn.addEventListener('click', (e) => {
                    const productId = parseInt(e.currentTarget.getAttribute('data-id'));
                    addToCart(productId);
                });
            });
        }

        // Display cart items
        function displayCart() {
            cartItems.innerHTML = '';
            
            if (cart.length === 0) {
                cartItems.innerHTML = '<p>Your cart is empty.</p>';
                updateCartSummary();
                return;
            }
            
            cart.forEach(item => {
                const product = products.find(p => p.id === item.id);
                const cartItem = document.createElement('div');
                cartItem.className = 'cart-item';
                cartItem.innerHTML = `
                    <div class="cart-item-image">
                        <img src="${product.image}" alt="${product.name}">
                    </div>
                    <div class="cart-item-details">
                        <h3 class="cart-item-title">${product.name}</h3>
                        <p class="cart-item-price">$${product.price.toFixed(2)}</p>
                        <div class="cart-item-actions">
                            <div class="quantity">
                                <button class="quantity-btn" data-id="${product.id}" data-action="decrease">-</button>
                                <input type="number" class="quantity-input" value="${item.quantity}" min="1" data-id="${product.id}">
                                <button class="quantity-btn" data-id="${product.id}" data-action="increase">+</button>
                            </div>
                            <button class="remove-btn" data-id="${product.id}">
                                <i class="fas fa-trash"></i> Remove
                            </button>
                        </div>
                    </div>
                `;
                cartItems.appendChild(cartItem);
            });

            // Add event listeners to cart item buttons
            document.querySelectorAll('.quantity-btn').forEach(btn => {
                btn.addEventListener('click', (e) => {
                    const productId = parseInt(e.currentTarget.getAttribute('data-id'));
                    const action = e.currentTarget.getAttribute('data-action');
                    updateCartQuantity(productId, action);
                });
            });

            document.querySelectorAll('.quantity-input').forEach(input => {
                input.addEventListener('change', (e) => {
                    const productId = parseInt(e.currentTarget.getAttribute('data-id'));
                    const quantity = parseInt(e.currentTarget.value) || 1;
                    setCartQuantity(productId, quantity);
                });
            });

            document.querySelectorAll('.remove-btn').forEach(btn => {
                btn.addEventListener('click', (e) => {
                    const productId = parseInt(e.currentTarget.getAttribute('data-id'));
                    removeFromCart(productId);
                });
            });

            updateCartSummary();
        }

        // Display wishlist items
        function displayWishlist() {
            wishlistItems.innerHTML = '';
            
            if (wishlist.length === 0) {
                wishlistItems.innerHTML = '<p>Your wishlist is empty.</p>';
                return;
            }
            
            wishlist.forEach(item => {
                const product = products.find(p => p.id === item.id);
                const wishlistItem = document.createElement('div');
                wishlistItem.className = 'wishlist-item';
                wishlistItem.innerHTML = `
                    <div class="wishlist-item-image">
                        <img src="${product.image}" alt="${product.name}">
                    </div>
                    <div class="wishlist-item-details">
                        <h3 class="wishlist-item-title">${product.name}</h3>
                        <p class="wishlist-item-price">$${product.price.toFixed(2)}</p>
                        <div class="wishlist-item-actions">
                            <button class="remove-btn" data-id="${product.id}">
                                <i class="fas fa-trash"></i> Remove
                            </button>
                            <button class="checkout-btn add-to-cart-from-wishlist" data-id="${product.id}">
                                <i class="fas fa-shopping-cart"></i> Add to Cart
                            </button>
                        </div>
                    </div>
                `;
                wishlistItems.appendChild(wishlistItem);
            });

            // Add event listeners to wishlist item buttons
            document.querySelectorAll('.wishlist-item .remove-btn').forEach(btn => {
                btn.addEventListener('click', (e) => {
                    const productId = parseInt(e.currentTarget.getAttribute('data-id'));
                    removeFromWishlist(productId);
                });
            });

            document.querySelectorAll('.add-to-cart-from-wishlist').forEach(btn => {
                btn.addEventListener('click', (e) => {
                    const productId = parseInt(e.currentTarget.getAttribute('data-id'));
                    addToCart(productId);
                });
            });
        }

        // Calculate discount
        function calculateDiscount(subtotal) {
            if (!activeDiscount) return 0;
            
            const discount = discountCodes[activeDiscount];
            if (subtotal < discount.minPurchase) return 0;
            
            if (discount.type === "percentage") {
                return subtotal * (discount.value / 100);
            } else if (discount.type === "fixed") {
                return discount.value;
            } else if (discount.type === "shipping") {
                return 0; // Handled separately in shipping calculation
            }
            
            return 0;
        }

        // Update cart summary
        function updateCartSummary() {
            const subtotal = cart.reduce((total, item) => {
                const product = products.find(p => p.id === item.id);
                return total + (product.price * item.quantity);
            }, 0);
            
            // Calculate discount
            const discountAmount = calculateDiscount(subtotal);
            
            // Calculate shipping (free if discount type is shipping and min purchase met)
            let shipping = subtotal > 0 ? 9.99 : 0;
            if (activeDiscount && discountCodes[activeDiscount].type === "shipping" && subtotal >= discountCodes[activeDiscount].minPurchase) {
                shipping = 0;
            }
            
            const tax = (subtotal - discountAmount) * 0.08; // 8% tax on discounted amount
            const total = subtotal - discountAmount + shipping + tax;
            
            // Update cart page
            document.getElementById('cartSubtotal').textContent = `$${subtotal.toFixed(2)}`;
            
            // Show/hide discount row
            const discountRow = document.getElementById('discountRow');
            if (discountAmount > 0) {
                discountRow.style.display = 'flex';
                document.getElementById('cartDiscount').textContent = `-$${discountAmount.toFixed(2)}`;
            } else {
                discountRow.style.display = 'none';
            }
            
            document.getElementById('cartShipping').textContent = `$${shipping.toFixed(2)}`;
            document.getElementById('cartTax').textContent = `$${tax.toFixed(2)}`;
            document.getElementById('cartTotal').textContent = `$${total.toFixed(2)}`;
            
            // Update checkout page
            document.getElementById('checkoutSubtotal').textContent = `$${subtotal.toFixed(2)}`;
            
            const checkoutDiscountRow = document.getElementById('checkoutDiscountRow');
            if (discountAmount > 0) {
                checkoutDiscountRow.style.display = 'flex';
                document.getElementById('checkoutDiscount').textContent = `-$${discountAmount.toFixed(2)}`;
            } else {
                checkoutDiscountRow.style.display = 'none';
            }
            
            document.getElementById('checkoutShipping').textContent = `$${shipping.toFixed(2)}`;
            document.getElementById('checkoutTax').textContent = `$${tax.toFixed(2)}`;
            document.getElementById('checkoutTotal').textContent = `$${total.toFixed(2)}`;
            
            // Update cart count
            const itemCount = cart.reduce((count, item) => count + item.quantity, 0);
            cartCount.textContent = itemCount;
            
            // Save to localStorage
            localStorage.setItem('cart', JSON.stringify(cart));
            localStorage.setItem('activeDiscount', JSON.stringify(activeDiscount));
        }

        // Update invoice
        function updateInvoice() {
            const subtotal = cart.reduce((total, item) => {
                const product = products.find(p => p.id === item.id);
                return total + (product.price * item.quantity);
            }, 0);
            
            // Calculate discount
            const discountAmount = calculateDiscount(subtotal);
            
            // Calculate shipping (free if discount type is shipping and min purchase met)
            let shipping = subtotal > 0 ? 9.99 : 0;
            if (activeDiscount && discountCodes[activeDiscount].type === "shipping" && subtotal >= discountCodes[activeDiscount].minPurchase) {
                shipping = 0;
            }
            
            const tax = (subtotal - discountAmount) * 0.08;
            const total = subtotal - discountAmount + shipping + tax;
            
            document.getElementById('invoiceSubtotal').textContent = `$${subtotal.toFixed(2)}`;
            
            // Show/hide discount row
            const invoiceDiscountRow = document.getElementById('invoiceDiscountRow');
            if (discountAmount > 0) {
                invoiceDiscountRow.style.display = 'block';
                document.getElementById('invoiceDiscount').textContent = `-$${discountAmount.toFixed(2)}`;
            } else {
                invoiceDiscountRow.style.display = 'none';
            }
            
            document.getElementById('invoiceShipping').textContent = `$${shipping.toFixed(2)}`;
            document.getElementById('invoiceTax').textContent = `$${tax.toFixed(2)}`;
            document.getElementById('invoiceTotal').textContent = `$${total.toFixed(2)}`;
            
            // Set invoice date
            const now = new Date();
            document.getElementById('invoiceDate').textContent = now.toLocaleDateString();
            
            // Set customer info
            const fullName = document.getElementById('fullName').value || 'Customer Name';
            const address = document.getElementById('address').value || 'Customer Address';
            document.getElementById('invoiceCustomer').textContent = fullName;
            document.getElementById('invoiceAddress').textContent = address;
            
            // Display invoice items
            const invoiceItems = document.getElementById('invoiceItems');
            invoiceItems.innerHTML = '';
            
            cart.forEach(item => {
                const product = products.find(p => p.id === item.id);
                const row = document.createElement('tr');
                row.innerHTML = `
                    <td>${product.name}</td>
                    <td>${item.quantity}</td>
                    <td>$${product.price.toFixed(2)}</td>
                    <td>$${(product.price * item.quantity).toFixed(2)}</td>
                `;
                invoiceItems.appendChild(row);
            });
        }

        // Apply discount code
        function applyDiscountCode() {
            const code = discountCodeInput.value.trim().toUpperCase();
            
            if (!code) {
                showDiscountMessage('Please enter a discount code.', 'error');
                return;
            }
            
            if (!discountCodes[code]) {
                showDiscountMessage('Invalid discount code.', 'error');
                return;
            }
            
            const discount = discountCodes[code];
            const subtotal = cart.reduce((total, item) => {
                const product = products.find(p => p.id === item.id);
                return total + (product.price * item.quantity);
            }, 0);
            
            if (subtotal < discount.minPurchase) {
                showDiscountMessage(`Minimum purchase of $${discount.minPurchase} required for this code.`, 'error');
                return;
            }
            
            activeDiscount = code;
            localStorage.setItem('activeDiscount', JSON.stringify(activeDiscount));
            
            let message = 'Discount applied successfully! ';
            if (discount.type === "percentage") {
                message += `${discount.value}% off your order.`;
            } else if (discount.type === "fixed") {
                message += `$${discount.value} off your order.`;
            } else if (discount.type === "shipping") {
                message += 'Free shipping on your order!';
            }
            
            showDiscountMessage(message, 'success');
            updateCartSummary();
        }

        // Show discount message
        function showDiscountMessage(message, type) {
            discountMessage.textContent = message;
            discountMessage.className = 'discount-message';
            
            if (type === 'success') {
                discountMessage.classList.add('discount-success');
            } else if (type === 'error') {
                discountMessage.classList.add('discount-error');
            }
        }

        // Add to cart function
        function addToCart(productId) {
            const existingItem = cart.find(item => item.id === productId);
            
            if (existingItem) {
                existingItem.quantity += 1;
            } else {
                cart.push({ id: productId, quantity: 1 });
            }
            
            displayCart();
            showNotification('Item added to cart!');
        }

        // Remove from cart function
        function removeFromCart(productId) {
            cart = cart.filter(item => item.id !== productId);
            displayCart();
            showNotification('Item removed from cart.');
        }

        // Update cart quantity
        function updateCartQuantity(productId, action) {
            const item = cart.find(item => item.id === productId);
            
            if (item) {
                if (action === 'increase') {
                    item.quantity += 1;
                } else if (action === 'decrease' && item.quantity > 1) {
                    item.quantity -= 1;
                }
                
                displayCart();
            }
        }

        // Set cart quantity
        function setCartQuantity(productId, quantity) {
            const item = cart.find(item => item.id === productId);
            
            if (item) {
                item.quantity = quantity;
                displayCart();
            }
        }

        // Toggle wishlist
        function toggleWishlist(productId) {
            const index = wishlist.findIndex(item => item.id === productId);
            
            if (index === -1) {
                wishlist.push({ id: productId });
                showNotification('Added to wishlist!');
            } else {
                wishlist.splice(index, 1);
                showNotification('Removed from wishlist.');
            }
            
            // Update wishlist count
            wishlistCount.textContent = wishlist.length;
            
            // Save to localStorage
            localStorage.setItem('wishlist', JSON.stringify(wishlist));
            
            // Update product display to reflect wishlist status
            displayProducts();
            displayWishlist();
        }

        // Remove from wishlist
        function removeFromWishlist(productId) {
            wishlist = wishlist.filter(item => item.id !== productId);
            
            // Update wishlist count
            wishlistCount.textContent = wishlist.length;
            
            // Save to localStorage
            localStorage.setItem('wishlist', JSON.stringify(wishlist));
            
            displayWishlist();
            displayProducts();
            showNotification('Removed from wishlist.');
        }

        // Show notification
        function showNotification(message) {
            // Create notification element
            const notification = document.createElement('div');
            notification.textContent = message;
            notification.style.position = 'fixed';
            notification.style.bottom = '20px';
            notification.style.right = '20px';
            notification.style.backgroundColor = 'var(--primary)';
            notification.style.color = 'white';
            notification.style.padding = '10px 20px';
            notification.style.borderRadius = '4px';
            notification.style.boxShadow = '0 2px 10px rgba(0, 0, 0, 0.2)';
            notification.style.zIndex = '1000';
            
            document.body.appendChild(notification);
            
            // Remove notification after 3 seconds
            setTimeout(() => {
                notification.style.opacity = '0';
                notification.style.transition = 'opacity 0.5s';
                setTimeout(() => {
                    document.body.removeChild(notification);
                }, 500);
            }, 3000);
        }

        // Navigation functions
        function navigateTo(pageId) {
            // Hide all pages
            pages.forEach(page => {
                page.classList.remove('active');
            });
            
            // Show the selected page
            document.getElementById(pageId).classList.add('active');
            
            // Update displays if needed
            if (pageId === 'cart') {
                displayCart();
            } else if (pageId === 'wishlist') {
                displayWishlist();
            } else if (pageId === 'index') {
                displayProducts();
            }
        }

        // Initialize the application
        function initApp() {
            // Display initial counts
            const cartItemCount = cart.reduce((count, item) => count + item.quantity, 0);
            cartCount.textContent = cartItemCount;
            wishlistCount.textContent = wishlist.length;
            
            // Display initial content
            displayProducts();
            
            // Add event listeners to navigation links
            navLinks.forEach(link => {
                link.addEventListener('click', (e) => {
                    e.preventDefault();
                    const pageId = e.currentTarget.getAttribute('data-page');
                    navigateTo(pageId);
                });
            });
            
            // Add event listeners to header icons
            cartIcon.addEventListener('click', () => navigateTo('cart'));
            wishlistIcon.addEventListener('click', () => navigateTo('wishlist'));
            
            // Add event listener to checkout button
            checkoutBtn.addEventListener('click', (e) => {
                e.preventDefault();
                if (cart.length > 0) {
                    navigateTo('checkout');
                } else {
                    showNotification('Your cart is empty!');
                }
            });
            
            // Add event listener to place order button
            placeOrderBtn.addEventListener('click', (e) => {
                e.preventDefault();
                
                // Simple form validation
                const fullName = document.getElementById('fullName').value;
                const email = document.getElementById('email').value;
                const address = document.getElementById('address').value;
                
                if (!fullName || !email || !address) {
                    showNotification('Please fill out all required fields.');
                    return;
                }
                
                updateInvoice();
                navigateTo('invoice');
                
                // Clear the cart and discount
                cart = [];
                activeDiscount = null;
                localStorage.setItem('cart', JSON.stringify(cart));
                localStorage.setItem('activeDiscount', JSON.stringify(activeDiscount));
                cartCount.textContent = '0';
                
                // Reset discount UI
                discountCodeInput.value = '';
                discountMessage.textContent = '';
                discountMessage.className = 'discount-message';
            });
            
            // Add event listener to apply discount button
            applyDiscountBtn.addEventListener('click', applyDiscountCode);
            
            // Add event listener for Enter key in discount input
            discountCodeInput.addEventListener('keypress', (e) => {
                if (e.key === 'Enter') {
                    applyDiscountCode();
                }
            });
            
            // Add event listeners to continue shopping links
            document.querySelectorAll('.continue-shopping').forEach(link => {
                link.addEventListener('click', (e) => {
                    e.preventDefault();
                    navigateTo('index');
                });
            });
            
            // Add event listeners to footer links
            document.querySelectorAll('.footer-column a').forEach(link => {
                link.addEventListener('click', (e) => {
                    const pageId = e.currentTarget.getAttribute('data-page');
                    if (pageId) {
                        e.preventDefault();
                        navigateTo(pageId);
                    }
                });
            });
        }

        // Start the application
        initApp();
    </script>
</body>
</html>