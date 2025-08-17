// server\routes\auth.js 
const express = require('express');
const router = express.Router();
const { check } = require('express-validator');
const { register, login } = require('../controllers/auth');

// Input validation middleware
const validateRegister = [
  check('name', 'Name is required').trim().notEmpty(),
  check('phoneNumber', 'Valid SA phone number required')
    .trim()
    .notEmpty()
    .matches(/^(\+27|0)[6-8][0-9]{8}$/),
  check('email', 'Please include a valid email').isEmail().normalizeEmail(),
  check('password', 'Password must be at least 6 characters').isLength({ min: 6 })
];

const validateLogin = [
  check('email', 'Please include a valid email').isEmail().normalizeEmail(),
  check('password', 'Password is required').exists()
];

// Register User
router.post('/register', validateRegister, register);

// Login User
router.post('/login', validateLogin, login);

module.exports = router;