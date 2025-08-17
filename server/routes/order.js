// server/routes/order.js

const express = require('express');
const router = express.Router();
const orderController = require('../controllers/order');
const { authMiddleware } = require('../middlewares/authMiddleware');
const saBusinessRules = require('../middlewares/saBusinessRules');
const { check } = require('express-validator');

// Order validation
const validateOrder = [
  check('shippingAddress.street', 'Street address is required').notEmpty(),
  check('shippingAddress.city', 'City is required').notEmpty(),
  check('shippingAddress.postalCode', 'Postal code is required').notEmpty(),
  check('shippingAddress.province', 'Invalid province')
    .isIn(['Gauteng', 'Western Cape', 'KZN', 'Eastern Cape', 'Free State', 'North West', 'Northern Cape', 'Mpumalanga', 'Limpopo']),
  check('paymentMethod', 'Invalid payment method')
    .isIn(['PayFast', 'EFT', 'Credit Card'])
];

// Create order
router.post(
  '/',
  authMiddleware,
  validateOrder,
  saBusinessRules.validateSAAddress,
  orderController.createOrder
);

// Get order invoice
router.get(
  '/:id/invoice',
  authMiddleware,
  check('id').isMongoId(),
  orderController.generateInvoice
);

// Get user orders
router.get(
  '/my-orders',
  authMiddleware,
  orderController.getUserOrders
);

module.exports = router;