// server\routes\auth.js 
const express = require('express');
const router = express.Router();
const { check } = require('express-validator');
const { register, login } = require('../controllers/auth');

// Register User
router.post('/register', [
  check('name', 'Name is required').notEmpty(),
  check('email', 'Please include a valid email').isEmail(),
  check('password', 'Password must be at least 6 characters').isLength({ min: 6 })
], register);

// Login User
router.post('/login', [
  check('email', 'Please include a valid email').isEmail(),
  check('password', 'Password is required').exists()
], login);

module.exports = router;