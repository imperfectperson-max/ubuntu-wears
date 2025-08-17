// server/routes/discount.js
const express = require('express');
const router = express.Router();
const discountController = require('../controllers/discount');
const { authMiddleware, adminMiddleware } = require('../middlewares/authMiddleware');
const { check } = require('express-validator');

// Discount validation
const validateDiscount = [
  check('code', 'Discount code is required').trim().notEmpty(),
  check('discountType', 'Invalid discount type').isIn(['percentage', 'fixed']),
  check('value', 'Value must be positive').isFloat({ min: 0 }),
  check('validUntil', 'Invalid date').optional().isISO8601()
];

// Admin-only routes
router.post(
  '/',
  authMiddleware,
  adminMiddleware,
  validateDiscount,
  discountController.createDiscount
);

router.patch(
  '/:id',
  authMiddleware,
  adminMiddleware,
  validateDiscount,
  discountController.updateDiscount
);

router.delete(
  '/:id',
  authMiddleware,
  adminMiddleware,
  discountController.deleteDiscount
);

// Public routes
router.get(
  '/:code',
  check('code').trim().notEmpty(),
  discountController.getDiscount
);

router.get(
  '/',
  discountController.listActiveDiscounts
);

module.exports = router;
