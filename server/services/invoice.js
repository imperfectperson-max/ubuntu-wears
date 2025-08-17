// server/services/invoice.js
const PDFDocument = require('pdfkit');
const path = require('path');
const fs = require('fs');

module.exports = {
  generateInvoice: (order) => {
    const doc = new PDFDocument();
    const filePath = path.join(__dirname, '../../public/invoices', `invoice_${order._id}.pdf`);

    // SA Business Header
    doc.fontSize(16).text('Ubuntu Wears', { align: 'center' });
    doc.fontSize(10).text('VAT No: ' + (process.env.VAT_NUMBER || '1234567890'), { align: 'center' });
    doc.moveDown();

    // Invoice Details
    doc.fontSize(12).text(`Invoice #${order._id}`, { underline: true });
    doc.text(`Date: ${new Date(order.createdAt).toLocaleDateString('en-ZA')}`);
    doc.moveDown();

    // Customer Info
    doc.fontSize(10).text(`Customer: ${order.user.name}`);
    doc.text(`Email: ${order.user.email}`);
    doc.moveDown();

    // Items Table
    const tableTop = 200;
    doc.font('Helvetica-Bold');
    doc.text('Description', 50, tableTop);
    doc.text('Qty', 300, tableTop);
    doc.text('Price (ZAR)', 400, tableTop, { width: 100, align: 'right' });
    doc.font('Helvetica');

    let y = tableTop + 20;
    order.items.forEach(item => {
      doc.text(item.name, 50, y);
      doc.text(item.quantity.toString(), 300, y);
      doc.text(item.price.toFixed(2), 400, y, { width: 100, align: 'right' });
      y += 20;
    });

    // Totals
    doc.moveDown();
    doc.text(`Subtotal: R${order.subtotal.toFixed(2)}`, { align: 'right' });
    doc.text(`VAT (15%): R${order.vat.toFixed(2)}`, { align: 'right' });
    doc.text(`Delivery: R${order.deliveryFee.toFixed(2)}`, { align: 'right' });
    doc.font('Helvetica-Bold');
    doc.text(`Total: R${order.total.toFixed(2)}`, { align: 'right' });

    doc.pipe(fs.createWriteStream(filePath));
    doc.end();

    return filePath;
  }
};