// server/routes/payment.js
const express = require('express');
const router = express.Router();
const paymentController = require('../controllers/payment');
const { authMiddleware } = require('../middlewares/authMiddleware');
const { check } = require('express-validator');

// Initiate PayFast payment
router.post('/payfast', 
  authMiddleware,
  [
    check('orderId', 'Order ID is required').isMongoId(),
    check('amount', 'Amount must be positive').isFloat({ min: 0 })
  ],
  paymentController.initiatePayment
);

// PayFast webhook (no auth needed but verify IP)
router.post('/webhook', 
  paymentController.handleWebhook
);

module.exports = router;