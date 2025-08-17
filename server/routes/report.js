// server/routes/report.js
const express = require('express');
const router = express.Router();
const reportController = require('../controllers/report');
const { authMiddleware, adminMiddleware } = require('../middlewares/authMiddleware');
const saBusinessRules = require('../middlewares/saBusinessRules');
const { check } = require('express-validator');

router.get(
  '/sales',
  authMiddleware,
  adminMiddleware,
  [
    check('startDate', 'Start date is required').isISO8601(),
    check('endDate', 'End date is required').isISO8601()
  ],
  saBusinessRules.validateBusinessPeriod,
  reportController.getSalesReport
);

module.exports = router;