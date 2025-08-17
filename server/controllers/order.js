// server/controllers/order.js
const Order = require('../models/Order');
const Cart = require('../models/Cart');
const invoiceService = require('../services/invoice');
const deliveryService = require('../services/courier');

exports.createOrder = async (req, res) => {
  try {
    const { shippingAddress, paymentMethod } = req.body;
    const cart = await Cart.findOne({ user: req.user._id }).populate('items.product');
    
    if (!cart || cart.items.length === 0) {
      return res.status(400).json({ error: 'Cart is empty' });
    }

    const order = new Order({
      user: req.user._id,
      items: cart.items.map(item => ({
        product: item.product._id,
        quantity: item.quantity,
        price: item.product.price,
        name: item.product.name
      })),
      subtotal: cart.subtotal,
      vat: cart.subtotal * 0.15, // 15% VAT
      deliveryFee: cart.deliveryFee,
      total: cart.total,
      paymentMethod,
      shippingAddress
    });

    await order.save();
    await deliveryService.createDelivery(order._id);
    await Cart.findByIdAndDelete(cart._id);
    
    res.status(201).json(order);
  } catch (error) {
    res.status(500).json({ error: 'Order processing failed', details: error.message });
  }
};

exports.generateInvoice = async (req, res) => {
  try {
    const order = await Order.findById(req.params.id);
    if (!order) {
      return res.status(404).json({ error: 'Order not found' });
    }
    if (!order.user.equals(req.user._id) && req.user.role !== 'admin') {
      return res.status(403).json({ error: 'Unauthorized' });
    }
    const filePath = await invoiceService.generateInvoice(order);
    res.download(filePath);
  } catch (error) {
    res.status(500).json({ error: 'Invoice generation failed' });
  }
};

exports.getUserOrders = async (req, res) => {
  try {
    const orders = await Order.find({ user: req.user._id }).sort({ createdAt: -1 });
    res.json(orders);
  } catch (error) {
    res.status(500).json({ error: 'Failed to fetch orders' });
  }
};