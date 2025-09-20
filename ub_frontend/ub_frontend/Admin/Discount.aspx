<%@ Page Title="Manage Discounts" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Discount.aspx.cs" Inherits="ub_frontend.Admin.Discount" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Ubuntu Wears - Manage Discounts
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <div class="admin-discounts">
        <div class="admin-header">
            <h1><i class="fas fa-tag"></i> Discount Management</h1>
            <div class="admin-actions">
                <asp:Button ID="btnAddDiscount" runat="server" Text="Add New Discount" CssClass="btn-primary" 
                    OnClick="btnAddDiscount_Click" />
            </div>
        </div>

        <div class="discounts-content">
            <div class="discounts-list">
                <div id="discountsContainer" runat="server" class="discounts-container">
                    <!-- Discounts will be rendered here via innerHTML -->
                </div>
            </div>
        </div>
    </div>

    <!-- Add/Edit Discount Modal -->
    <div class="modal" id="discountModal" style="display: none;">
        <div class="modal-content">
            <div class="modal-header">
                <h2><asp:Literal ID="litModalTitle" runat="server" /></h2>
                <button type="button" class="modal-close" onclick="closeDiscountModal()">&times;</button>
            </div>
            <div class="modal-body">
                <div id="discountErrorMessage" class="error-message" style="display: none;"></div>
                
                <asp:Panel ID="pnlDiscountForm" runat="server" DefaultButton="btnSaveDiscount">
                    <div class="form-group">
                        <label for="txtDiscountCode">Discount Code *</label>
                        <asp:TextBox ID="txtDiscountCode" runat="server" required="true" placeholder="SUMMER2024" MaxLength="50"></asp:TextBox>
                    </div>

                    <div class="form-group">
                        <label for="txtDiscountDescription">Description</label>
                        <asp:TextBox ID="txtDiscountDescription" runat="server" TextMode="MultiLine" Rows="2" placeholder="Summer sale discount" MaxLength="255"></asp:TextBox>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="ddlDiscountType">Discount Type *</label>
                            <asp:DropDownList ID="ddlDiscountType" runat="server" required="true">
                                <asp:ListItem Value="">Select Type</asp:ListItem>
                                <asp:ListItem Value="Percentage">Percentage (%)</asp:ListItem>
                                <asp:ListItem Value="FixedAmount">Fixed Amount (R)</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="form-group">
                            <label for="txtDiscountValue">Discount Value *</label>
                            <asp:TextBox ID="txtDiscountValue" runat="server" TextMode="Number" step="0.01" min="0" required="true" placeholder="10.00"></asp:TextBox>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="txtMinOrderAmount">Minimum Order Amount (R)</label>
                            <asp:TextBox ID="txtMinOrderAmount" runat="server" TextMode="Number" step="0.01" min="0" placeholder="0.00"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <label for="txtMaxUses">Maximum Uses</label>
                            <asp:TextBox ID="txtMaxUses" runat="server" TextMode="Number" min="0" placeholder="Unlimited"></asp:TextBox>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="txtStartDate">Start Date *</label>
                            <asp:TextBox ID="txtStartDate" runat="server" TextMode="Date" required="true"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <label for="txtEndDate">End Date *</label>
                            <asp:TextBox ID="txtEndDate" runat="server" TextMode="Date" required="true"></asp:TextBox>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="checkbox">
                            <asp:CheckBox ID="cbDiscountActive" runat="server" Checked="true" />
                            <span>Discount is active</span>
                        </label>
                    </div>

                    <div class="modal-actions">
                        <asp:Button ID="btnSaveDiscount" runat="server" Text="Save Discount" CssClass="btn-primary" OnClick="btnSaveDiscount_Click" OnClientClick="return validateDiscountForm();" />
                        <button type="button" class="btn-secondary" onclick="closeDiscountModal()">Cancel</button>
                    </div>

                    <asp:HiddenField ID="hfDiscountId" runat="server" Value="0" />
                </asp:Panel>
            </div>
        </div>
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
        .admin-discounts {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        
        .admin-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid #e9ecef;
        }
        
        .admin-header h1 {
            color: #2c3e50;
            margin: 0;
        }
        
        .admin-header h1 i {
            margin-right: 10px;
            color: #3498db;
        }
        
        .admin-actions {
            display: flex;
            gap: 15px;
        }
        
        .btn-primary {
            padding: 10px 20px;
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
            padding: 10px 20px;
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
        
        .discounts-container {
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        
        .admin-grid {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        
        .admin-grid th,
        .admin-grid td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #e9ecef;
        }
        
        .admin-grid th {
            background-color: #f8f9fa;
            font-weight: bold;
            color: #2c3e50;
        }
        
        .admin-grid tr:hover {
            background-color: #f8f9fa;
        }
        
        .grid-action {
            color: #007bff;
            text-decoration: none;
            margin-right: 10px;
            cursor: pointer;
        }
        
        .grid-action:hover {
            text-decoration: underline;
        }

        .grid-action.delete {
            color: #dc3545;
        }

        .grid-action.delete:hover {
            color: #c82333;
        }
        
        .no-data {
            text-align: center;
            padding: 40px;
            color: #6c757d;
            font-style: italic;
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
            max-width: 600px;
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
        
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
        }
        
        .form-group {
            margin-bottom: 15px;
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
            padding: 10px 12px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 14px;
        }
        
        .form-group textarea {
            resize: vertical;
            min-height: 60px;
        }
        
        .checkbox {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .modal-actions {
            display: flex;
            gap: 10px;
            margin-top: 20px;
        }
        
        .error-message {
            color: #dc3545;
            font-size: 14px;
            margin-bottom: 15px;
            padding: 10px;
            background-color: #f8d7da;
            border-radius: 4px;
            display: none;
        }
        
        @media (max-width: 768px) {
            .admin-header {
                flex-direction: column;
                gap: 15px;
                align-items: flex-start;
            }
            
            .form-row {
                grid-template-columns: 1fr;
            }
            
            .admin-grid {
                font-size: 12px;
            }
            
            .admin-grid th,
            .admin-grid td {
                padding: 8px;
            }
        }
    </style>

    <script>
        function openDiscountModal() {
            document.getElementById('discountModal').style.display = 'flex';
        }

        function closeDiscountModal() {
            document.getElementById('discountModal').style.display = 'none';
            document.getElementById('discountErrorMessage').style.display = 'none';
        }

        window.onclick = function (event) {
            var modal = document.getElementById('discountModal');
            if (event.target === modal) {
                closeDiscountModal();
            }
        }

        function toggleDiscountStatus(discountId) {
            if (confirm('Are you sure you want to change the status of this discount?')) {
                showLoading();
                __doPostBack('ToggleStatus', discountId);
            }
        }

        function editDiscount(discountId) {
            showLoading();
            __doPostBack('EditDiscount', discountId);
        }

        function deleteDiscount(discountId) {
            if (confirm('Are you sure you want to delete this discount? This action cannot be undone.')) {
                showLoading();
                __doPostBack('DeleteDiscount', discountId);
            }
        }

        function validateDiscountForm() {
            const code = document.getElementById('<%= txtDiscountCode.ClientID %>').value;
            const type = document.getElementById('<%= ddlDiscountType.ClientID %>').value;
            const value = document.getElementById('<%= txtDiscountValue.ClientID %>').value;
            const startDate = document.getElementById('<%= txtStartDate.ClientID %>').value;
            const endDate = document.getElementById('<%= txtEndDate.ClientID %>').value;

            if (!code || !type || !value || !startDate || !endDate) {
                showDiscountError('Please fill in all required fields.');
                return false;
            }

            // Validate dates
            const start = new Date(startDate);
            const end = new Date(endDate);

            if (end <= start) {
                showDiscountError('End date must be after start date.');
                return false;
            }

            // Validate discount value
            const discountValue = parseFloat(value);
            if (discountValue <= 0) {
                showDiscountError('Discount value must be greater than 0.');
                return false;
            }

            if (type === 'Percentage' && discountValue > 100) {
                showDiscountError('Percentage discount cannot exceed 100%.');
                return false;
            }

            // Validate max uses
            const maxUses = document.getElementById('<%= txtMaxUses.ClientID %>').value;
            if (maxUses && (isNaN(maxUses) || parseInt(maxUses) < 0)) {
                showDiscountError('Maximum uses must be a positive number.');
                return false;
            }

            // Validate min order amount
            const minOrder = document.getElementById('<%= txtMinOrderAmount.ClientID %>').value;
            if (minOrder && (isNaN(minOrder) || parseFloat(minOrder) < 0)) {
                showDiscountError('Minimum order amount must be a positive number.');
                return false;
            }

            showLoading();
            return true;
        }

        function showDiscountError(message) {
            const errorDiv = document.getElementById('discountErrorMessage');
            errorDiv.innerHTML = message;
            errorDiv.style.display = 'block';

            // Scroll to error
            errorDiv.scrollIntoView({ behavior: 'smooth' });
        }

        function showLoading() {
            document.getElementById('loadingOverlay').style.display = 'block';
        }

        function hideLoading() {
            document.getElementById('loadingOverlay').style.display = 'none';
        }

        // Add event listener to form submission
        document.getElementById('<%= btnSaveDiscount.ClientID %>').addEventListener('click', function (e) {
            if (!validateDiscountForm()) {
                e.preventDefault();
                hideLoading();
            }
        });

        // Hide loading overlay after 5 seconds (safety net)
        setTimeout(function () {
            hideLoading();
        }, 5000);

        // Handle page load complete
        window.addEventListener('load', function () {
            hideLoading();
        });
    </script>
</asp:Content>