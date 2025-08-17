// server/services/pdfServices.js

const PDFDocument = require('pdfkit');
const fs = require('fs');
const path = require('path');
const { formatZAR } = require('../utils/currencyFormatter');

module.exports = {
  createInvoice: async (order) => {
    try {
      // Ensure invoices directory exists
      const invoiceDir = path.join(__dirname, '../../public/invoices');
      if (!fs.existsSync(invoiceDir)) {
        fs.mkdirSync(invoiceDir, { recursive: true });
      }

      const doc = new PDFDocument();
      const filePath = path.join(invoiceDir, `invoice_${order._id}.pdf`);
      
      // SA VAT-compliant header
      doc.fontSize(12)
         .text(`VAT No: ${process.env.VAT_NUMBER || '1234567890'}`, { align: 'right' })
         .moveDown();

      // Invoice details
      doc.fontSize(16).text('INVOICE', { align: 'center', underline: true });
      doc.fontSize(10).text(`Invoice #: ${order._id}`);
      doc.text(`Date: ${new Date(order.createdAt).toLocaleDateString('en-ZA')}`);
      doc.moveDown();

      // Customer information
      doc.fontSize(12).text('BILL TO:', { underline: true });
      doc.text(`Name: ${order.user.name}`);
      doc.text(`Email: ${order.user.email}`);
      doc.moveDown();

      // Items table
      const tableTop = 200;
      doc.font('Helvetica-Bold');
      doc.text('Description', 50, tableTop);
      doc.text('Qty', 300, tableTop);
      doc.text('Price', 400, tableTop, { width: 100, align: 'right' });
      doc.font('Helvetica');

      let y = tableTop + 20;
      order.items.forEach(item => {
        doc.text(item.name, 50, y);
        doc.text(item.quantity.toString(), 300, y);
        doc.text(formatZAR(item.price), 400, y, { width: 100, align: 'right' });
        y += 20;
      });

      // Totals
      doc.moveDown();
      doc.text(`Subtotal: ${formatZAR(order.subtotal)}`, { align: 'right' });
      doc.text(`VAT (15%): ${formatZAR(order.vat)}`, { align: 'right' });
      doc.text(`Delivery: ${formatZAR(order.deliveryFee)}`, { align: 'right' });
      doc.font('Helvetica-Bold');
      doc.text(`Total: ${formatZAR(order.total)}`, { align: 'right' });

      doc.pipe(fs.createWriteStream(filePath));
      doc.end();

      return filePath;
    } catch (error) {
      console.error('Invoice generation failed:', error);
      throw new Error('Failed to generate invoice');
    }
  }
};