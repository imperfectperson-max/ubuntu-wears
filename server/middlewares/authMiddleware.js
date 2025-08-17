// server/middlewares/authMiddleware.js
const jwt = require('jsonwebtoken');
const { AppError } = require('./errorMiddleware');

const authMiddleware = (req, res, next) => {
  const authHeader = req.header('Authorization');
  if (!authHeader?.startsWith('Bearer ')) {
    throw new AppError('Access denied. No token provided.', 401);
  }

  const token = authHeader.split(' ')[1];
  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.user = decoded;
    next();
  } catch (ex) {
    throw new AppError('Invalid token', 400);
  }
};

const adminMiddleware = (req, res, next) => {
  if (req.user.role !== 'admin') {
    throw new AppError(`Role (${req.user.role}) is not allowed to access this resource`, 403);
  }
  next();
};

module.exports = { authMiddleware, adminMiddleware };
