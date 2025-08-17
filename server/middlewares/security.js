// server/middlewares/security.js
const helmet = require('helmet');
const rateLimit = require('express-rate-limit');
const mongoSanitize = require('express-mongo-sanitize');
const xss = require('xss-clean');
const hpp = require('hpp');
const cors = require('cors');

// Set security HTTP headers
exports.secureHeaders = () => helmet();   // ✅ wrap in a function

// Limit requests from same API
exports.limiter = rateLimit({
  max: 100,
  windowMs: 60 * 60 * 1000,
  message: 'Too many requests from this IP, please try again in an hour!'
});

// Data sanitization against NoSQL query injection
exports.sanitizeMongo = mongoSanitize();

// Data sanitization against XSS
exports.xssClean = xss();

// Prevent parameter pollution
exports.hpp = hpp();

// Enable CORS
exports.cors = cors({
  origin: process.env.FRONTEND_URL || 'http://localhost:3000',
  credentials: true
});
