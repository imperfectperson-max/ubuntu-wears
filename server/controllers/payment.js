// server/controllers/payment.js
const payfastService = require('../services/payFast');
const Order = require('../models/Order');

exports.initiatePayment = async (req, res) => {
  try {
    const { orderId } = req.body;
    const order = await Order.findById(orderId);
    
    if (!order) {
      return res.status(404).json({ error: 'Order not found' });
    }

    const paymentUrl = payfastService.generatePaymentUrl({
      amount: order.total,
      item_name: `Order #${order._id}`,
      email_address: req.user.email,
      m_payment_id: order._id.toString()
    });

    res.json({ paymentUrl });
  } catch (error) {
    res.status(500).json({ 
      error: 'Payment initiation failed',
      details: error.message 
    });
  }
};

exports.handleWebhook = async (req, res) => {
  try {
    const isValid = payfastService.validateNotification(req.body);
    if (!isValid) return res.status(400).send('Invalid signature');

    await Order.findByIdAndUpdate(
      req.body.m_payment_id,
      { paymentStatus: 'completed' }
    );

    res.status(200).send('OK');
  } catch (error) {
    res.status(500).send('Webhook processing failed');
  }
};