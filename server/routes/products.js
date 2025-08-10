// server\routes\products.js 
const express = require('express');
const router = express.Router();
const { check } = require('express-validator');
const multer = require('multer');
const upload = multer({ storage: require('../config/multer') });

// Make sure the path is correct
const productController = require('../controllers/products');

// Get all products
router.get('/', productController.getProducts);

// Get single product
router.get('/:id', productController.getProductById);

// Create product (admin only)
router.post(
  '/',
  upload.array('images', 5),
  [
    check('name', 'Name is required').notEmpty(),
    check('price', 'Price must be positive').isFloat({ min: 0 }),
    check('category', 'Category is required').notEmpty()
  ],
  productController.createProduct
);

// Update product (admin only)
router.put(
  '/:id',
  upload.array('images', 5),
  productController.updateProduct
);

// Delete product (admin only)
router.delete('/:id', productController.deleteProduct);

module.exports = router;