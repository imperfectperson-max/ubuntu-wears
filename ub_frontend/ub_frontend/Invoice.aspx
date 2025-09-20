<%@ Page Title="Invoice" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Invoice.aspx.cs" Inherits="ub_frontend.Invoice" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Ubuntu Wears - Invoice
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .invoice-container {
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        
        .invoice-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid #e9ecef;
        }
        
        .company-info h1 {
            color: #2c3e50;
            margin-bottom: 10px;
        }
        
        .invoice-details {
            text-align: right;
        }
        
        .invoice-details h2 {
            color: #3498db;
            margin-bottom: 10px;
        }
        
        .invoice-info {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .info-section {
            padding: 15px;
            background: #f8f9fa;
            border-radius: 8px;
        }
        
        .info-section h3 {
            margin: 0 0 10px 0;
            color: #2c3e50;
            font-size: 16px;
        }
        
        .info-section p {
            margin: 5px 0;
            color: #6c757d;
        }
        
        .invoice-items {
            margin-bottom: 30px;
        }
        
        .invoice-table {
            width: 100%;
            border-collapse: collapse;
        }
        
        .invoice-table th {
            background: #3498db;
            color: white;
            padding: 12px;
            text-align: left;
        }
        
        .invoice-table td {
            padding: 12px;
            border-bottom: 1px solid #e9ecef;
        }
        
        .invoice-table tr:nth-child(even) {
            background: #f8f9fa;
        }
        
        .invoice-summary {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .summary-section {
            padding: 15px;
            background: #f8f9fa;
            border-radius: 8px;
        }
        
        .summary-item {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
        }
        
        .summary-total {
            font-weight: bold;
            font-size: 18px;
            border-top: 2px solid #3498db;
            padding-top: 10px;
        }
        
        .invoice-actions {
            display: flex;
            justify-content: center;
            gap: 15px;
            margin-top: 30px;
        }
        
        .btn-print {
            padding: 10px 20px;
            background: #28a745;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
        }
        
        .btn-download {
            padding: 10px 20px;
            background: #6c757d;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
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
            .invoice-header {
                flex-direction: column;
                gap: 20px;
            }
            
            .invoice-details {
                text-align: left;
            }
            
            .invoice-info {
                grid-template-columns: 1fr;
            }
            
            .invoice-summary {
                grid-template-columns: 1fr;
            }
        }
        
        @media print {
            .invoice-actions {
                display: none;
            }
            
            .invoice-container {
                box-shadow: none;
                padding: 0;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <div class="invoice-container">
        <div id="invoiceContent" runat="server">
            <!-- Invoice content will be rendered here using StringBuilder -->
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="ScriptContent" runat="server">
    <script>
        function printInvoice() {
            window.print();
        }
        
        function downloadInvoice() {
            // Implement PDF download functionality
            alert('PDF download functionality would be implemented here');
        }
    </script>
</asp:Content>