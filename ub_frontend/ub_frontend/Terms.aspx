<%@ Page Title="Terms and Conditions" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Terms.aspx.cs" Inherits="ub_frontend.Terms" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Ubuntu Wears - Terms and Conditions
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="terms-container">
        <div class="terms-header">
            <h1><i class="fas fa-file-contract"></i> Terms and Conditions</h1>
            <p>Last Updated: <asp:Literal ID="litLastUpdated" runat="server" Text="January 1, 2025" /></p>
        </div>

        <div class="terms-content">
            <div class="terms-nav">
                <h3>Quick Navigation</h3>
                <ul>
                    <li><a href="#acceptance">Acceptance of Terms</a></li>
                    <li><a href="#account">Account Registration</a></li>
                    <li><a href="#products">Products and Pricing</a></li>
                    <li><a href="#orders">Ordering Process</a></li>
                    <li><a href="#payments">Payments</a></li>
                    <li><a href="#shipping">Shipping and Delivery</a></li>
                    <li><a href="#returns">Returns and Refunds</a></li>
                    <li><a href="#intellectual">Intellectual Property</a></li>
                    <li><a href="#privacy">Privacy Policy</a></li>
                    <li><a href="#limitation">Limitation of Liability</a></li>
                    <li><a href="#changes">Changes to Terms</a></li>
                </ul>
            </div>

            <div class="terms-sections">
                <section id="acceptance" class="terms-section">
                    <h2>1. Acceptance of Terms</h2>
                    <p>By accessing and using the Ubuntu Wears website (the "Site"), you accept and agree to be bound by the terms and provision of this agreement.</p>
                    <p>These Terms and Conditions apply to all users of the Site, including without limitation users who are browsers, vendors, customers, merchants, and/or contributors of content.</p>
                </section>

                <section id="account" class="terms-section">
                    <h2>2. Account Registration</h2>
                    <p>To access certain features of the Site, you may be required to register for an account. You agree to:</p>
                    <ul>
                        <li>Provide accurate, current, and complete information during the registration process</li>
                        <li>Maintain and promptly update your account information</li>
                        <li>Maintain the security of your password and accept all risks of unauthorized access to your account</li>
                        <li>Notify us immediately of any unauthorized use of your account</li>
                        <li>Be responsible for all activities that occur under your account</li>
                    </ul>
                </section>

                <section id="products" class="terms-section">
                    <h2>3. Products and Pricing</h2>
                    <p>Ubuntu Wears makes every effort to display our products and their colors as accurately as possible. However, we cannot guarantee that your computer monitor's display of any color will be accurate.</p>
                    <p>We reserve the right to:</p>
                    <ul>
                        <li>Limit the quantities of any products that we offer</li>
                        <li>Discontinue any product at any time</li>
                        <li>Modify product prices without notice</li>
                        <li>Refuse any order you place with us</li>
                    </ul>
                </section>

                <section id="orders" class="terms-section">
                    <h2>4. Ordering Process</h2>
                    <p>When you place an order through our Site, you are offering to purchase a product subject to these Terms. All orders are subject to availability and confirmation of the order price.</p>
                    <p>We may require additional verification for certain orders. Order confirmation does not constitute our acceptance of your order.</p>
                </section>

                <section id="payments" class="terms-section">
                    <h2>5. Payments</h2>
                    <p>We accept various payment methods including credit cards, debit cards, and other payment methods as indicated on the Site.</p>
                    <p>You represent and warrant that:</p>
                    <ul>
                        <li>The payment information you provide is true, correct, and complete</li>
                        <li>You are duly authorized to use such payment method</li>
                        <li>Charges incurred by you will be honored by your payment method company</li>
                    </ul>
                </section>

                <section id="shipping" class="terms-section">
                    <h2>6. Shipping and Delivery</h2>
                    <p>Shipping times and delivery dates are estimates only and are not guaranteed. We are not responsible for delays caused by shipping carriers or other factors beyond our control.</p>
                    <p>Shipping costs are calculated based on the delivery address and the products ordered. Risk of loss and title for products pass to you upon delivery to the carrier.</p>
                </section>

                <section id="returns" class="terms-section">
                    <h2>7. Returns and Refunds</h2>
                    <p>We accept returns within 30 days of delivery for most items in their original condition. Some products may have different return policies as specified at the time of purchase.</p>
                    <p>To initiate a return:</p>
                    <ul>
                        <li>Contact our customer service team</li>
                        <li>Provide your order number and reason for return</li>
                        <li>Follow the return instructions provided</li>
                    </ul>
                    <p>Refunds will be processed to the original payment method within 7-10 business days after we receive and inspect the returned item.</p>
                </section>

                <section id="intellectual" class="terms-section">
                    <h2>8. Intellectual Property</h2>
                    <p>All content included on this Site, such as text, graphics, logos, images, audio clips, digital downloads, and data compilations, is the property of Ubuntu Wears or its content suppliers and protected by international copyright laws.</p>
                    <p>The Ubuntu Wears name and logo are trademarks of Ubuntu Wears. You may not use these marks without our prior written permission.</p>
                </section>

                <section id="privacy" class="terms-section">
                    <h2>9. Privacy Policy</h2>
                    <p>Your use of the Site is also governed by our Privacy Policy. Please review our Privacy Policy, which also governs the Site and informs users of our data collection practices.</p>
                    <p>By using the Site, you consent to all actions taken by us with respect to your information in compliance with the Privacy Policy.</p>
                </section>

                <section id="limitation" class="terms-section">
                    <h2>10. Limitation of Liability</h2>
                    <p>In no event shall Ubuntu Wears, its directors, officers, employees, or agents be liable for any indirect, consequential, exemplary, incidental, special, or punitive damages, including lost profit damages.</p>
                    <p>Our total liability to you for all losses, damages, and causes of action shall not exceed the amount paid by you, if any, for accessing this Site.</p>
                </section>

                <section id="changes" class="terms-section">
                    <h2>11. Changes to Terms</h2>
                    <p>We reserve the right to update, change, or replace any part of these Terms and Conditions by posting updates and changes to our Site.</p>
                    <p>It is your responsibility to check our Site periodically for changes. Your continued use of or access to our Site following the posting of any changes constitutes acceptance of those changes.</p>
                </section>

                <div class="terms-contact">
                    <h3>Contact Information</h3>
                    <p>If you have any questions about these Terms and Conditions, please contact us:</p>
                    <ul>
                        <li>Email: legal@ubuntuwears.com</li>
                        <li>Phone: +27 123 456 7890</li>
                        <li>Address: 123 Ubuntu Street, Cultural District, Johannesburg, South Africa</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ScriptContent" runat="server">
     <style>
        /* === Terms & Conditions Page Styling === */
        .terms-container {
            max-width: 1200px;
            margin: 40px auto;
            padding: 30px;
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 6px 15px rgba(0,0,0,0.08);
            font-family: "Segoe UI", Arial, sans-serif;
            line-height: 1.7;
            color: #333;
        }

        .terms-header {
            text-align: center;
            margin-bottom: 40px;
        }
        .terms-header h1 {
            font-size: 2.2rem;
            color: #222;
            margin-bottom: 10px;
        }
        .terms-header i {
            color: #4CAF50;
            margin-right: 8px;
        }
        .terms-header p {
            font-size: 0.9rem;
            color: #777;
        }

        .terms-content {
            display: flex;
            gap: 30px;
        }

        .terms-nav {
            flex: 1;
            max-width: 250px;
            background: #f9f9f9;
            border-radius: 10px;
            padding: 20px;
            position: sticky;
            top: 20px;
            height: fit-content;
        }
        .terms-nav h3 {
            font-size: 1.1rem;
            margin-bottom: 15px;
            color: #444;
        }
        .terms-nav ul {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        .terms-nav ul li {
            margin: 10px 0;
        }
        .terms-nav ul li a {
            text-decoration: none;
            color: #555;
            font-size: 0.95rem;
            transition: color 0.3s ease;
        }
        .terms-nav ul li a:hover,
        .terms-nav ul li a.active {
            color: #4CAF50;
            font-weight: 600;
        }

        .terms-sections {
            flex: 3;
        }
        .terms-section {
            margin-bottom: 40px;
        }
        .terms-section h2 {
            font-size: 1.5rem;
            margin-bottom: 15px;
            color: #222;
            border-left: 4px solid #4CAF50;
            padding-left: 10px;
        }
        .terms-section p,
        .terms-section ul {
            font-size: 1rem;
            color: #444;
        }
        .terms-section ul {
            margin: 10px 0 0 20px;
            list-style: disc;
        }
        .terms-section ul li {
            margin: 5px 0;
        }

        .terms-contact {
            padding: 20px;
            background: #f4f9f6;
            border-left: 4px solid #4CAF50;
            border-radius: 8px;
            margin-top: 50px;
        }
        .terms-contact h3 {
            margin-bottom: 10px;
            color: #2e7d32;
        }
        .terms-contact ul {
            list-style: none;
            padding: 0;
        }
        .terms-contact ul li {
            margin: 5px 0;
            font-size: 0.95rem;
        }

        @media (max-width: 992px) {
            .terms-content {
                flex-direction: column;
            }
            .terms-nav {
                max-width: 100%;
                margin-bottom: 30px;
                position: relative;
            }
        }
    </style>
    <script>
        // Smooth scrolling for navigation links
        document.querySelectorAll('.terms-nav a').forEach(link => {
            link.addEventListener('click', function(e) {
                e.preventDefault();
                const targetId = this.getAttribute('href').substring(1);
                const targetElement = document.getElementById(targetId);
                
                if (targetElement) {
                    targetElement.scrollIntoView({
                        behavior: 'smooth',
                        block: 'start'
                    });
                }
            });
        });

        // Highlight current section in navigation
        window.addEventListener('scroll', function() {
            const sections = document.querySelectorAll('.terms-section');
            const navLinks = document.querySelectorAll('.terms-nav a');
            
            let currentSection = '';
            
            sections.forEach(section => {
                const sectionTop = section.offsetTop;
                const sectionHeight = section.clientHeight;
                
                if (window.scrollY >= sectionTop - 100) {
                    currentSection = section.getAttribute('id');
                }
            });
            
            navLinks.forEach(link => {
                link.classList.remove('active');
                if (link.getAttribute('href') === '#' + currentSection) {
                    link.classList.add('active');
                }
            });
        });
    </script>
</asp:Content>