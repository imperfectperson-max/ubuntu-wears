// server/routes/cart.js
const express = require('express');
const router = express.Router();
const { 
  addItem, 
  removeItem, 
  getCart, 
  clearCart 
} = require('../controllers/cart');
const { authMiddleware } = require('../middlewares/authMiddleware');
const { check } = require('express-validator');

// Input validation
const validateAddItem = [
  check('productId', 'Product ID is required').notEmpty().isMongoId(),
  check('quantity', 'Quantity must be at least 1').isInt({ min: 1 })
];

// Add item to cart
router.post('/add-item', authMiddleware, validateAddItem, addItem);

// Remove item from cart
router.delete('/remove-item/:productId', 
  authMiddleware,
  check('productId').isMongoId(),
  removeItem
);

// Get user cart
router.get('/', authMiddleware, getCart);

// Clear cart
router.delete('/clear', authMiddleware, clearCart);

module.exports = router;