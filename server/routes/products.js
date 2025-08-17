// server\routes\products.js 
const express = require('express');
const router = express.Router();
const { check } = require('express-validator');
const upload = require('../config/multer');
const productController = require('../controllers/products');
const { authMiddleware, adminMiddleware } = require('../middlewares/authMiddleware');

// Product validation
const validateProduct = [
  check('name', 'Name is required').trim().notEmpty(),
  check('price', 'Price must be positive').isFloat({ min: 0 }),
  check('category', 'Category is required').notEmpty(),
  check('stock', 'Stock must be integer').optional().isInt({ min: 0 })
];

// Get all products
router.get('/', productController.getProducts);

// Get single product
router.get('/:id', 
  check('id').isMongoId(),
  productController.getProductById
);

// Create product (admin only)
router.post(
  '/',
  authMiddleware,
  adminMiddleware,
  upload.array('images', 5),
  validateProduct,
  productController.createProduct
);

// Update product (admin only)
router.put(
  '/:id',
  authMiddleware,
  adminMiddleware,
  upload.array('images', 5),
  check('id').isMongoId(),
  validateProduct,
  productController.updateProduct
);

// Delete product (admin only)
router.delete(
  '/:id',
  authMiddleware,
  adminMiddleware,
  check('id').isMongoId(),
  productController.deleteProduct
);

module.exports = router;