// server/server.js
require('dotenv').config();
const express = require('express');
const path = require('path');
const connectDB = require('./config/db');
const securityMiddlewares = require('./middlewares/security');
const errorHandler = require('./middlewares/errorMiddleware').errorHandler;

// Initialize app
const app = express();

// Database connection
connectDB();

// Security middlewares
app.use(securityMiddlewares.secureHeaders);
app.use('/api', securityMiddlewares.limiter);
app.use(securityMiddlewares.sanitizeMongo);
app.use(securityMiddlewares.xssClean);
app.use(securityMiddlewares.hpp);
app.use(securityMiddlewares.cors);

// Body parsers
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Static files
app.use('/public', express.static(path.join(__dirname, 'public')));

// API Routes
app.use('/api/auth', require('./routes/auth'));
app.use('/api/users', require('./routes/user'));
app.use('/api/products', require('./routes/products'));
app.use('/api/cart', require('./routes/cart'));
app.use('/api/orders', require('./routes/order'));
app.use('/api/wishlist', require('./routes/wishlist'));
app.use('/api/discounts', require('./routes/discount'));
app.use('/api/payments', require('./routes/payment'));
app.use('/api/reports', require('./routes/report'));

// Error handling
app.use(errorHandler);

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));