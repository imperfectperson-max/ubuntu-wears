<%@ Page Title="Reports" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Report.aspx.cs" Inherits="ub_frontend.Admin.Report" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Ubuntu Wears - Reports
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <div class="admin-reports">
        <div class="admin-header">
            <h1><i class="fas fa-chart-bar"></i> Reports & Analytics</h1>
            <div class="header-actions">
                <asp:Button ID="btnRefresh" runat="server" Text="Refresh Data" CssClass="btn-secondary" OnClick="btnRefresh_Click" />
            </div>
        </div>

        <div class="reports-content">
            <div class="report-filters">
                <div class="filter-section">
                    <h3><i class="fas fa-filter"></i> Filter Reports</h3>
                    <div class="filter-controls">
                        <div class="form-group">
                            <label for="ddlReportType">Report Type</label>
                            <asp:DropDownList ID="ddlReportType" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddlReportType_SelectedIndexChanged">
                                <asp:ListItem Value="Sales">Sales Report</asp:ListItem>
                                <asp:ListItem Value="Inventory">Inventory Report</asp:ListItem>
                                <asp:ListItem Value="Customer">Customer Report</asp:ListItem>
                                <asp:ListItem Value="Invoices">Invoice Report</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        
                        <div class="form-group" id="dateRangeSection" runat="server">
                            <label for="txtStartDate">Start Date</label>
                            <asp:TextBox ID="txtStartDate" runat="server" TextMode="Date" CssClass="form-control"></asp:TextBox>
                        </div>
                        
                        <div class="form-group" id="endDateSection" runat="server">
                            <label for="txtEndDate">End Date</label>
                            <asp:TextBox ID="txtEndDate" runat="server" TextMode="Date" CssClass="form-control"></asp:TextBox>
                        </div>
                        
                        <div class="form-group">
                            <asp:Button ID="btnGenerate" runat="server" Text="Generate Report" CssClass="btn-primary" OnClick="btnGenerate_Click" />
                        </div>
                    </div>
                </div>
            </div>

            <div class="report-results">
                <asp:Panel ID="pnlSalesReport" runat="server" Visible="false" CssClass="report-panel">
                    <h3><i class="fas fa-shopping-cart"></i> Sales Report</h3>
                    <div class="report-stats">
                        <div class="stat-card">
                            <div class="stat-icon sales">
                                <i class="fas fa-money-bill-wave"></i>
                            </div>
                            <div class="stat-content">
                                <div class="stat-number" id="totalSales" runat="server">R0.00</div>
                                <div class="stat-label">Total Sales</div>
                            </div>
                        </div>
                        
                        <div class="stat-card">
                            <div class="stat-icon orders">
                                <i class="fas fa-receipt"></i>
                            </div>
                            <div class="stat-content">
                                <div class="stat-number" id="totalOrders" runat="server">0</div>
                                <div class="stat-label">Total Orders</div>
                            </div>
                        </div>
                        
                        <div class="stat-card">
                            <div class="stat-icon customers">
                                <i class="fas fa-users"></i>
                            </div>
                            <div class="stat-content">
                                <div class="stat-number" id="totalCustomers" runat="server">0</div>
                                <div class="stat-label">Total Customers</div>
                            </div>
                        </div>
                        
                        <div class="stat-card">
                            <div class="stat-icon avg-order">
                                <i class="fas fa-chart-line"></i>
                            </div>
                            <div class="stat-content">
                                <div class="stat-number" id="avgOrderValue" runat="server">R0.00</div>
                                <div class="stat-label">Avg Order Value</div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="report-data">
                        <div class="data-section">
                            <h4>Sales by Category</h4>
                            <div class="table-container">
                                <asp:GridView ID="gvSalesByCategory" runat="server" CssClass="report-table" AutoGenerateColumns="false" GridLines="None"
                                    OnRowDataBound="gv_RowDataBound" EmptyDataText="No sales data available for the selected period.">
                                    <Columns>
                                        <asp:BoundField DataField="Category" HeaderText="Category" ItemStyle-Width="40%" />
                                        <asp:BoundField DataField="TotalSales" HeaderText="Total Sales" DataFormatString="R{0:N2}" ItemStyle-Width="30%" ItemStyle-HorizontalAlign="Right" />
                                        <asp:BoundField DataField="TotalItems" HeaderText="Items Sold" DataFormatString="{0:N0}" ItemStyle-Width="30%" ItemStyle-HorizontalAlign="Right" />
                                    </Columns>
                                </asp:GridView>
                            </div>
                        </div>
                        
                        <div class="data-section">
                            <h4>Top Selling Products</h4>
                            <div class="table-container">
                                <asp:GridView ID="gvTopProducts" runat="server" CssClass="report-table" AutoGenerateColumns="false" GridLines="None"
                                    OnRowDataBound="gv_RowDataBound" EmptyDataText="No product data available.">
                                    <Columns>
                                        <asp:BoundField DataField="ProductName" HeaderText="Product" ItemStyle-Width="40%" />
                                        <asp:BoundField DataField="QuantitySold" HeaderText="Quantity Sold" DataFormatString="{0:N0}" ItemStyle-Width="30%" ItemStyle-HorizontalAlign="Right" />
                                        <asp:BoundField DataField="TotalRevenue" HeaderText="Total Revenue" DataFormatString="R{0:N2}" ItemStyle-Width="30%" ItemStyle-HorizontalAlign="Right" />
                                    </Columns>
                                </asp:GridView>
                            </div>
                        </div>
                    </div>
                </asp:Panel>
                
                <asp:Panel ID="pnlInventoryReport" runat="server" Visible="false" CssClass="report-panel">
                    <h3><i class="fas fa-boxes"></i> Inventory Report</h3>
                    <div class="report-stats">
                        <div class="stat-card">
                            <div class="stat-icon products">
                                <i class="fas fa-tshirt"></i>
                            </div>
                            <div class="stat-content">
                                <div class="stat-number" id="totalProducts" runat="server">0</div>
                                <div class="stat-label">Total Products</div>
                            </div>
                        </div>
                        
                        <div class="stat-card">
                            <div class="stat-icon lowstock">
                                <i class="fas fa-exclamation-triangle"></i>
                            </div>
                            <div class="stat-content">
                                <div class="stat-number" id="lowStock" runat="server">0</div>
                                <div class="stat-label">Low Stock Items</div>
                            </div>
                        </div>
                        
                        <div class="stat-card">
                            <div class="stat-icon outofstock">
                                <i class="fas fa-times-circle"></i>
                            </div>
                            <div class="stat-content">
                                <div class="stat-number" id="outOfStock" runat="server">0</div>
                                <div class="stat-label">Out of Stock</div>
                            </div>
                        </div>
                        
                        <div class="stat-card">
                            <div class="stat-icon value">
                                <i class="fas fa-coins"></i>
                            </div>
                            <div class="stat-content">
                                <div class="stat-number" id="totalInventoryValue" runat="server">R0.00</div>
                                <div class="stat-label">Total Inventory Value</div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="inventory-table">
                        <h4>Inventory Summary</h4>
                        <div class="table-container">
                            <asp:GridView ID="gvInventory" runat="server" CssClass="report-table" AutoGenerateColumns="false" GridLines="None"
                                OnRowDataBound="gv_RowDataBound" EmptyDataText="No inventory data available.">
                                <Columns>
                                    <asp:BoundField DataField="ProductName" HeaderText="Product Name" ItemStyle-Width="30%" />
                                    <asp:BoundField DataField="CurrentStock" HeaderText="Current Stock" DataFormatString="{0:N0}" ItemStyle-Width="15%" ItemStyle-HorizontalAlign="Right" />
                                    <asp:BoundField DataField="UnitPrice" HeaderText="Unit Price" DataFormatString="R{0:N2}" ItemStyle-Width="15%" ItemStyle-HorizontalAlign="Right" />
                                    <asp:BoundField DataField="TotalValue" HeaderText="Total Value" DataFormatString="R{0:N2}" ItemStyle-Width="20%" ItemStyle-HorizontalAlign="Right" />
                                    <asp:BoundField DataField="StockStatus" HeaderText="Status" ItemStyle-Width="20%" />
                                </Columns>
                            </asp:GridView>
                        </div>
                    </div>
                </asp:Panel>
                
                <asp:Panel ID="pnlCustomerReport" runat="server" Visible="false" CssClass="report-panel">
                    <h3><i class="fas fa-user-friends"></i> Customer Report</h3>
                    <div class="report-stats">
                        <div class="stat-card">
                            <div class="stat-icon totalcust">
                                <i class="fas fa-user-plus"></i>
                            </div>
                            <div class="stat-content">
                                <div class="stat-number" id="totalCustomersCount" runat="server">0</div>
                                <div class="stat-label">Total Customers</div>
                            </div>
                        </div>
                        
                        <div class="stat-card">
                            <div class="stat-icon newcust">
                                <i class="fas fa-user-check"></i>
                            </div>
                            <div class="stat-content">
                                <div class="stat-number" id="newCustomers" runat="server">0</div>
                                <div class="stat-label">New Customers</div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="customer-data">
                        <div class="data-section">
                            <h4>Top Customers by Spending</h4>
                            <div class="table-container">
                                <asp:GridView ID="gvTopCustomers" runat="server" CssClass="report-table" AutoGenerateColumns="false" GridLines="None"
                                    OnRowDataBound="gv_RowDataBound" EmptyDataText="No customer data available.">
                                    <Columns>
                                        <asp:BoundField DataField="CustomerName" HeaderText="Customer" ItemStyle-Width="40%" />
                                        <asp:BoundField DataField="TotalSpent" HeaderText="Total Spent" DataFormatString="R{0:N2}" ItemStyle-Width="30%" ItemStyle-HorizontalAlign="Right" />
                                        <asp:BoundField DataField="TotalOrders" HeaderText="Total Orders" DataFormatString="{0:N0}" ItemStyle-Width="30%" ItemStyle-HorizontalAlign="Right" />
                                    </Columns>
                                </asp:GridView>
                            </div>
                        </div>
                    </div>
                </asp:Panel>
                
                <asp:Panel ID="pnlInvoiceReport" runat="server" Visible="false" CssClass="report-panel">
                    <h3><i class="fas fa-file-invoice-dollar"></i> Invoice Report</h3>
                    
                    <div class="invoice-data">
                        <div class="data-section">
                            <h4>Invoices</h4>
                            <div class="table-container">
                                <asp:GridView ID="gvInvoices" runat="server" CssClass="report-table" AutoGenerateColumns="false" GridLines="None"
                                    OnRowDataBound="gv_RowDataBound" EmptyDataText="No invoices found for the selected period.">
                                    <Columns>
                                        <asp:BoundField DataField="InvoiceNumber" HeaderText="Invoice #" ItemStyle-Width="15%" />
                                        <asp:BoundField DataField="InvoiceDate" HeaderText="Date" DataFormatString="{0:dd MMM yyyy}" ItemStyle-Width="15%" />
                                        <asp:TemplateField HeaderText="Customer" ItemStyle-Width="20%">
                                            <ItemTemplate>
                                                <%# Eval("Customer.FirstName") + " " + Eval("Customer.LastName") %>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:BoundField DataField="TotalAmount" HeaderText="Amount" DataFormatString="R{0:N2}" ItemStyle-Width="15%" ItemStyle-HorizontalAlign="Right" />
                                        <asp:BoundField DataField="TaxAmount" HeaderText="Tax" DataFormatString="R{0:N2}" ItemStyle-Width="15%" ItemStyle-HorizontalAlign="Right" />
                                        <asp:BoundField DataField="GrandTotal" HeaderText="Total" DataFormatString="R{0:N2}" ItemStyle-Width="15%" ItemStyle-HorizontalAlign="Right" />
                                        <asp:BoundField DataField="Status" HeaderText="Status" ItemStyle-Width="15%" />
                                    </Columns>
                                </asp:GridView>
                            </div>
                        </div>
                    </div>
                </asp:Panel>
            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="ScriptContent" runat="server">
    <style>
        .admin-reports {
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
        
        .header-actions {
            display: flex;
            gap: 10px;
        }
        
        .reports-content {
            display: flex;
            flex-direction: column;
            gap: 30px;
        }
        
        .report-filters {
            background: white;
            border-radius: 10px;
            padding: 25px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        
        .filter-section h3 {
            color: #2c3e50;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 1px solid #e9ecef;
            font-size: 18px;
        }
        
        .filter-section h3 i {
            margin-right: 10px;
            color: #3498db;
        }
        
        .filter-controls {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
            align-items: flex-end;
        }
        
        .filter-controls .form-group {
            margin-bottom: 0;
        }
        
        .report-results {
            display: flex;
            flex-direction: column;
            gap: 30px;
        }
        
        .report-panel {
            background: white;
            border-radius: 10px;
            padding: 25px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        
        .report-panel h3 {
            color: #2c3e50;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 1px solid #e9ecef;
            font-size: 20px;
        }
        
        .report-panel h3 i {
            margin-right: 10px;
            color: #3498db;
        }
        
        .report-stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            display: flex;
            align-items: center;
            transition: transform 0.2s ease;
        }
        
        .stat-card:hover {
            transform: translateY(-2px);
        }
        
        .stat-icon {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 15px;
            font-size: 24px;
        }
        
        .stat-icon.sales { background-color: #e3f2fd; color: #1976d2; }
        .stat-icon.orders { background-color: #fff3cd; color: #856404; }
        .stat-icon.customers { background-color: #d4edda; color: #155724; }
        .stat-icon.avg-order { background-color: #f3e5f5; color: #7b1fa2; }
        .stat-icon.products { background-color: #f3e5f5; color: #7b1fa2; }
        .stat-icon.lowstock { background-color: #fff3e0; color: #f57c00; }
        .stat-icon.outofstock { background-color: #ffebee; color: #d32f2f; }
        .stat-icon.value { background-color: #e8f5e9; color: #388e3c; }
        .stat-icon.totalcust { background-color: #e8f5e9; color: #388e3c; }
        .stat-icon.newcust { background-color: #e3f2fd; color: #1976d2; }
        
        .stat-content {
            flex: 1;
        }
        
        .stat-number {
            font-size: 24px;
            font-weight: bold;
            color: #2c3e50;
            margin-bottom: 5px;
        }
        
        .stat-label {
            color: #6c757d;
            font-size: 14px;
        }
        
        .report-data, .customer-data, .invoice-data {
            display: flex;
            flex-direction: column;
            gap: 30px;
        }
        
        .data-section {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 20px;
        }
        
        .data-section h4 {
            margin: 0 0 15px 0;
            color: #2c3e50;
            font-size: 16px;
            padding-bottom: 10px;
            border-bottom: 1px solid #e9ecef;
        }
        
        .table-container {
            overflow-x: auto;
        }
        
        .report-table {
            width: 100%;
            border-collapse: collapse;
        }
        
        .report-table th, .report-table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #e9ecef;
        }
        
        .report-table th {
            background-color: #e9ecef;
            font-weight: 600;
            color: #2c3e50;
        }
        
        .report-table tr:hover {
            background-color: #f8f9fa;
        }
        
        .empty-data {
            padding: 20px;
            text-align: center;
            color: #6c757d;
            font-style: italic;
        }
        
        .inventory-table {
            margin-top: 30px;
        }
        
        .inventory-table h4 {
            margin: 0 0 15px 0;
            color: #2c3e50;
            font-size: 16px;
            padding-bottom: 10px;
            border-bottom: 1px solid #e9ecef;
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
        
        @media (max-width: 768px) {
            .admin-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }
            
            .filter-controls {
                flex-direction: column;
                align-items: stretch;
            }
            
            .report-stats {
                grid-template-columns: 1fr;
            }
            
            .stat-card {
                flex-direction: column;
                text-align: center;
            }
            
            .stat-icon {
                margin-right: 0;
                margin-bottom: 10px;
            }
            
            .report-panel, .report-filters {
                padding: 15px;
            }
            
            .data-section {
                padding: 15px;
            }
            
            .report-table th, .report-table td {
                padding: 8px;
                font-size: 14px;
            }
        }
        
        @media (max-width: 576px) {
            .admin-reports {
                padding: 10px;
            }
            
            .report-table th, .report-table td {
                padding: 6px;
                font-size: 12px;
            }
        }
    </style>
</asp:Content>