// server/controllers/report.js

const Order = require('../models/Order');

exports.getSalesReport = async (req, res) => {
  const { startDate, endDate } = req.query;
  
  const report = await Order.aggregate([
    {
      $match: {
        createdAt: { 
          $gte: new Date(startDate), 
          $lte: new Date(endDate) 
        },
        paymentStatus: 'completed'
      }
    },
    {
      $group: {
        _id: null,
        totalSales: { $sum: '$total' },
        vatCollected: { $sum: { $multiply: ['$total', 0.15] } }, // SA VAT
        popularCategory: { 
          $max: { 
            category: '$items.category', 
            count: { $size: '$items' } 
          } 
        }
      }
    }
  ]);

  res.json({
    period: `${startDate} to ${endDate}`,
    currency: 'ZAR',
    ...report[0]
  });
};