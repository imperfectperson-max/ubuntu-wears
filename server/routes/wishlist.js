// server/routes/wishlist.js

const express = require('express');
const router = express.Router();
const wishlistController = require('../controllers/wishlist');
const { authMiddleware } = require('../middlewares/authMiddleware');
const { check } = require('express-validator');

// Input validation
const validateProductId = [
  check('productId', 'Product ID is required').isMongoId()
];

// Add product to wishlist
router.post(
  '/add',
  authMiddleware,
  validateProductId,
  wishlistController.addToWishlist
);

// Remove product from wishlist
router.delete(
  '/remove/:productId',
  authMiddleware,
  check('productId').isMongoId(),
  wishlistController.removeFromWishlist
);

// Get user's wishlist
router.get(
  '/',
  authMiddleware,
  wishlistController.getWishlist
);

// SA-specific: Notify when product is available
router.post(
  '/notify-available',
  authMiddleware,
  validateProductId,
  wishlistController.setAvailabilityAlert
);

// SA-specific: Price threshold alert
router.post(
  '/price-alert',
  authMiddleware,
  [
    ...validateProductId,
    check('threshold', 'Price threshold must be positive').isFloat({ min: 0 })
  ],
  wishlistController.setPriceAlert
);

module.exports = router;
