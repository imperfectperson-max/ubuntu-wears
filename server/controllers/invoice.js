// server/controllers/invoice.js
const pdfService = require('../services/pdfService');
const Order = require('../models/Order');

exports.generateInvoice = async (req, res) => {
  const order = await Order.findById(req.params.id);
  const filePath = await pdfService.createInvoice(order);
  
  res.download(filePath, `invoice_${order._id}.pdf`, () => {
    // Optional: Delete file after sending - DISCUSS
  });
};