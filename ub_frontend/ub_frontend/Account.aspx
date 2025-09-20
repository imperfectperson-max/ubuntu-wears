<%@ Page Title="My Account" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Account.aspx.cs" Inherits="ub_frontend.Account" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Ubuntu Wears - My Account
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <div class="account-container">
        <div class="account-header">
            <h1><i class="fas fa-user-circle"></i> My Account</h1>
            <p>Manage your personal information and preferences</p>
        </div>

        <div class="account-content">
            <div class="account-sidebar">
                <div class="account-nav">
                    <button class="account-nav-btn active" data-section="profile" onclick="showSection('profile')">
                        <i class="fas fa-user"></i> Profile Information
                    </button>
                    <button class="account-nav-btn" data-section="orders" onclick="showSection('orders')">
                        <i class="fas fa-shopping-cart"></i> Order History
                    </button>
                    <button class="account-nav-btn" data-section="addresses" onclick="showSection('addresses')">
                        <i class="fas fa-map-marker-alt"></i> Addresses
                    </button>
                    <button class="account-nav-btn" data-section="wishlist" onclick="showSection('wishlist')">
                        <i class="fas fa-heart"></i> Wishlist
                    </button>
                    <button class="account-nav-btn" data-section="security" onclick="showSection('security')">
                        <i class="fas fa-shield-alt"></i> Security
                    </button>
                </div>
                
                <div class="account-stats">
                    <div class="stat-item">
                        <i class="fas fa-box"></i>
                        <span class="stat-number" id="orderCount">0</span>
                        <span class="stat-label">Orders</span>
                    </div>
                    <div class="stat-item">
                        <i class="fas fa-heart"></i>
                        <span class="stat-number" id="wishlistCount">0</span>
                        <span class="stat-label">Wishlist Items</span>
                    </div>
                </div>
            </div>

            <div class="account-main">
                <div id="accountContent" runat="server">
                    <!-- Account content will be dynamically populated here -->
                </div>
            </div>
        </div>
    </div>

    <!-- Add Address Modal -->
    <div class="modal" id="addressModal" style="display: none;">
        <div class="modal-content">
            <div class="modal-header">
                <h2>Add New Address</h2>
                <button type="button" class="modal-close" onclick="closeAddressModal()">&times;</button>
            </div>
            <div class="modal-body">
                <div class="form-group">
                    <label for="txtAddressName">Address Name *</label>
                    <input type="text" id="txtAddressName" placeholder="Home, Work, etc." required />
                </div>

                <div class="form-group">
                    <label for="txtStreetAddress">Street Address *</label>
                    <textarea id="txtStreetAddress" rows="2" required></textarea>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="txtCity">City *</label>
                        <input type="text" id="txtCity" required />
                    </div>
                    <div class="form-group">
                        <label for="txtPostalCode">Postal Code *</label>
                        <input type="text" id="txtPostalCode" required />
                    </div>
                </div>

                <div class="form-group">
                    <label for="ddlProvince">Province *</label>
                    <select id="ddlProvince" required>
                        <option value="">Select Province</option>
                        <option>Gauteng</option>
                        <option>Western Cape</option>
                        <option>KwaZulu-Natal</option>
                        <option>Eastern Cape</option>
                        <option>Free State</option>
                        <option>North West</option>
                        <option>Northern Cape</option>
                        <option>Mpumalanga</option>
                        <option>Limpopo</option>
                    </select>
                </div>

                <div class="form-group">
                    <label class="checkbox">
                        <input type="checkbox" id="cbDefaultAddress" />
                        <span>Set as default delivery address</span>
                    </label>
                </div>

                <div class="modal-actions">
                    <button type="button" class="btn-primary" onclick="saveAddress()">Save Address</button>
                    <button type="button" class="btn-secondary" onclick="closeAddressModal()">Cancel</button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="ScriptContent" runat="server">
    <style>
        .account-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        
        .account-header {
            text-align: center;
            margin-bottom: 30px;
        }
        
        .account-header h1 {
            color: #2c3e50;
            margin-bottom: 10px;
        }
        
        .account-header h1 i {
            margin-right: 10px;
            color: #3498db;
        }
        
        .account-header p {
            color: #6c757d;
            font-size: 16px;
        }
        
        .account-content {
            display: grid;
            grid-template-columns: 250px 1fr;
            gap: 30px;
        }
        
        .account-sidebar {
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            height: fit-content;
        }
        
        .account-nav {
            display: flex;
            flex-direction: column;
            gap: 10px;
            margin-bottom: 30px;
        }
        
        .account-nav-btn {
            display: flex;
            align-items: center;
            padding: 12px 15px;
            border: none;
            background: #f8f9fa;
            color: #6c757d;
            border-radius: 6px;
            cursor: pointer;
            transition: all 0.2s ease;
            text-align: left;
        }
        
        .account-nav-btn:hover {
            background: #e9ecef;
            color: #2c3e50;
        }
        
        .account-nav-btn.active {
            background: #007bff;
            color: white;
        }
        
        .account-nav-btn i {
            margin-right: 10px;
            width: 16px;
        }
        
        .account-stats {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
        }
        
        .stat-item {
            text-align: center;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 6px;
        }
        
        .stat-item i {
            font-size: 20px;
            color: #007bff;
            margin-bottom: 5px;
        }
        
        .stat-number {
            display: block;
            font-size: 18px;
            font-weight: bold;
            color: #2c3e50;
        }
        
        .stat-label {
            font-size: 12px;
            color: #6c757d;
        }
        
        .account-main {
            background: white;
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        
        .account-section {
            display: none;
        }
        
        .account-section.active {
            display: block;
        }
        
        .account-section h2 {
            color: #2c3e50;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 1px solid #e9ecef;
        }
        
        .account-section h2 i {
            margin-right: 10px;
            color: #3498db;
        }
        
        .account-form {
            max-width: 600px;
        }
        
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: 500;
            color: #2c3e50;
        }
        
        .form-group input,
        .form-group textarea,
        .form-group select {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 14px;
            transition: border-color 0.2s ease;
        }
        
        .form-group input:focus,
        .form-group textarea:focus,
        .form-group select:focus {
            outline: none;
            border-color: #007bff;
            box-shadow: 0 0 0 2px rgba(0, 123, 255, 0.25);
        }
        
        .form-actions {
            margin-top: 30px;
        }
        
        .btn-primary {
            padding: 12px 24px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 500;
        }
        
        .btn-primary:hover {
            background-color: #0056b3;
        }
        
        .btn-secondary {
            padding: 12px 24px;
            background-color: #6c757d;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 500;
        }
        
        .btn-secondary:hover {
            background-color: #545b62;
        }
        
        .btn-danger {
            padding: 12px 24px;
            background-color: #dc3545;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 500;
        }
        
        .btn-danger:hover {
            background-color: #c82333;
        }
        
        .btn-link {
            color: #007bff;
            text-decoration: none;
            background: none;
            border: none;
            cursor: pointer;
            font-size: 14px;
        }
        
        .btn-link:hover {
            text-decoration: underline;
        }
        
        .account-grid {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        
        .account-grid th,
        .account-grid td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #e9ecef;
        }
        
        .account-grid th {
            background-color: #f8f9fa;
            font-weight: bold;
            color: #2c3e50;
        }
        
        .account-grid tr:hover {
            background-color: #f8f9fa;
        }
        
        .product-thumb {
            width: 50px;
            height: 50px;
            object-fit: cover;
            border-radius: 4px;
        }
        
        .addresses-list {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }
        
        .address-card {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 20px;
            border-left: 4px solid #007bff;
        }
        
        .address-card h4 {
            margin: 0 0 10px 0;
            color: #2c3e50;
        }
        
        .address-card p {
            margin: 0 0 5px 0;
            color: #6c757d;
        }
        
        .address-actions {
            display: flex;
            gap: 10px;
            margin-top: 15px;
        }
        
        .add-address-card {
            background: #e7f3ff;
            border: 2px dashed #007bff;
            border-radius: 8px;
            padding: 30px;
            text-align: center;
            cursor: pointer;
            transition: all 0.2s ease;
        }
        
        .add-address-card:hover {
            background: #d4e7ff;
        }
        
        .add-address-card i {
            font-size: 24px;
            color: #007bff;
            margin-bottom: 10px;
        }
        
        .add-address-card h4 {
            margin: 0;
            color: #007bff;
        }
        
        .modal {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 1000;
        }
        
        .modal-content {
            background: white;
            border-radius: 10px;
            width: 90%;
            max-width: 500px;
            max-height: 90vh;
            overflow-y: auto;
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
        }
        
        .modal-close {
            background: none;
            border: none;
            font-size: 24px;
            cursor: pointer;
            color: #6c757d;
        }
        
        .modal-body {
            padding: 20px;
        }
        
        .modal-actions {
            display: flex;
            gap: 10px;
            margin-top: 20px;
        }
        
        .checkbox {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .empty-state {
            text-align: center;
            padding: 40px;
            color: #6c757d;
            font-style: italic;
        }
        
        .error-message {
            color: #dc3545;
            font-size: 14px;
            margin-bottom: 15px;
            padding: 10px;
            background-color: #f8d7da;
            border-radius: 4px;
        }
        
        .feature-coming-soon {
            text-align: center;
            padding: 40px;
            color: #6c757d;
        }
        
        .feature-coming-soon i {
            font-size: 48px;
            margin-bottom: 15px;
            color: #6c757d;
        }
        
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
        
        @media (max-width: 768px) {
            .account-content {
                grid-template-columns: 1fr;
            }
            
            .account-sidebar {
                order: 2;
            }
            
            .account-main {
                order: 1;
            }
            
            .form-row {
                grid-template-columns: 1fr;
            }
            
            .addresses-list {
                grid-template-columns: 1fr;
            }
        }
        .default-address {
    border-left: 4px solid #28a745 !important;
}

.address-card h4 {
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.address-badge {
    background-color: #28a745;
    color: white;
    padding: 2px 8px;
    border-radius: 4px;
    font-size: 12px;
    font-weight: normal;
}

.address-actions {
    display: flex;
    gap: 8px;
    margin-top: 15px;
    flex-wrap: wrap;
}

.address-actions button {
    padding: 6px 12px;
    font-size: 12px;
}

.modal {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(0, 0, 0, 0.5);
    display: flex;
    align-items: center;
    justify-content: center;
    z-index: 1000;
}

.modal-content {
    background: white;
    border-radius: 10px;
    width: 90%;
    max-width: 500px;
    max-height: 90vh;
    overflow-y: auto;
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
}

.modal-close {
    background: none;
    border: none;
    font-size: 24px;
    cursor: pointer;
    color: #6c757d;
}

.modal-body {
    padding: 20px;
}

.modal-actions {
    display: flex;
    gap: 10px;
    margin-top: 20px;
}

.checkbox {
    display: flex;
    align-items: center;
    gap: 10px;
}
    </style>

    <script>
        let currentSection = 'profile';
        let editingAddressId = 0;

        function showSection(section) {
            // Hide all sections
            document.querySelectorAll('.account-section').forEach(sec => {
                sec.style.display = 'none';
            });

            // Show selected section
            document.getElementById(section + 'Section').style.display = 'block';

            // Update active nav button
            document.querySelectorAll('.account-nav-btn').forEach(btn => {
                btn.classList.remove('active');
            });
            document.querySelector(`[data-section="${section}"]`).classList.add('active');

            currentSection = section;
        }

        function openAddressModal(addressId = 0) {
            editingAddressId = addressId;

            if (addressId > 0) {
                // Load address data for editing
                document.getElementById('txtAddressName').value = '';
                document.getElementById('txtStreetAddress').value = '';
                document.getElementById('txtCity').value = '';
                document.getElementById('txtPostalCode').value = '';
                document.getElementById('ddlProvince').value = '';
                document.getElementById('cbDefaultAddress').checked = false;

                // In a real implementation, you would load the address data via AJAX
                // For now, we'll just show the modal and the server will handle loading
                document.querySelector('.modal-header h2').textContent = 'Edit Address';
            } else {
                // Clear form for new address
                document.getElementById('txtAddressName').value = '';
                document.getElementById('txtStreetAddress').value = '';
                document.getElementById('txtCity').value = '';
                document.getElementById('txtPostalCode').value = '';
                document.getElementById('ddlProvince').value = '';
                document.getElementById('cbDefaultAddress').checked = false;

                document.querySelector('.modal-header h2').textContent = 'Add New Address';
            }

            document.getElementById('addressModal').style.display = 'flex';
        }

        function closeAddressModal() {
            document.getElementById('addressModal').style.display = 'none';
            editingAddressId = 0;
        }

        function saveAddress() {
            const addressName = document.getElementById('txtAddressName').value;
            const streetAddress = document.getElementById('txtStreetAddress').value;
            const city = document.getElementById('txtCity').value;
            const postalCode = document.getElementById('txtPostalCode').value;
            const province = document.getElementById('ddlProvince').value;
            const isDefault = document.getElementById('cbDefaultAddress').checked;

            if (!addressName || !streetAddress || !city || !postalCode || !province) {
                showNotification('Please fill in all required fields.', 'error');
                return;
            }

            // Call server-side method to save address
            __doPostBack('SaveAddress', `${editingAddressId}|${addressName}|${streetAddress}|${city}|${postalCode}|${province}|${isDefault}`);
        }

        function removeAddress(addressId) {
            if (confirm('Are you sure you want to delete this address?')) {
                __doPostBack('RemoveAddress', addressId);
            }
        }

        function setDefaultAddress(addressId) {
            if (confirm('Set this address as your default delivery address?')) {
                __doPostBack('SetDefaultAddress', addressId);
            }
        }

        function addToCart(productId) {
            __doPostBack('AddToCart', productId);
        }

        function removeFromWishlist(wishlistId) {
            if (confirm('Are you sure you want to remove this item from your wishlist?')) {
                __doPostBack('RemoveFromWishlist', wishlistId);
            }
        }

        function updateProfile() {
            const firstName = document.getElementById('txtFirstName').value;
            const lastName = document.getElementById('txtLastName').value;
            const email = document.getElementById('txtEmail').value;
            const phone = document.getElementById('txtPhone').value;

            if (!firstName || !lastName || !email) {
                showNotification('Please fill in all required fields.', 'error');
                return;
            }

            __doPostBack('UpdateProfile', `${firstName}|${lastName}|${email}|${phone}`);
        }

        function changePassword() {
            const currentPassword = document.getElementById('txtCurrentPassword').value;
            const newPassword = document.getElementById('txtNewPassword').value;
            const confirmPassword = document.getElementById('txtConfirmPassword').value;

            if (!currentPassword || !newPassword || !confirmPassword) {
                showNotification('Please fill in all password fields.', 'error');
                return;
            }

            if (newPassword !== confirmPassword) {
                showNotification('New passwords do not match.', 'error');
                return;
            }

            if (newPassword.length < 6) {
                showNotification('Password must be at least 6 characters long.', 'error');
                return;
            }

            __doPostBack('ChangePassword', `${currentPassword}|${newPassword}`);
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

        // Initialize page
        document.addEventListener('DOMContentLoaded', function () {
            showSection('profile');
            loadAccountStats();
        });

        function loadAccountStats() {
            // This would typically be loaded from server via AJAX
            // For now, we'll set placeholder values
            try {
                using(var client = new UbuntuWearsServiceClient())
                    {
                        int userId = Convert.ToInt32(Session["UserID"]);

                // Get order count
                var ordersResponse = client.GetUserOrders(userId);
                if (ordersResponse.Success) {
                    document.getElementById('orderCount').textContent = ordersResponse.Data.Count.ToString();
                }

                // Get wishlist count
                var wishlistResponse = client.GetWishlist(userId);
                if (wishlistResponse.Success) {
                    document.getElementById('wishlistCount').textContent = wishlistResponse.Data.Count.ToString();
                }
            }
        } catch {
            // Fallback to placeholder values if there's an error
            document.getElementById('orderCount').textContent = '0';
            document.getElementById('wishlistCount').textContent = '0';
        }
        }

        // Close modal when clicking outside
        window.onclick = function (event) {
            const modal = document.getElementById('addressModal');
            if (event.target === modal) {
                closeAddressModal();
            }
        }
    </script>
</asp:Content>