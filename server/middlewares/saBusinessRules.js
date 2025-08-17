// server/middleware/saBusinessRules.js

module.exports = {
  validateBusinessPeriod: (req, res, next) => {
    const { startDate, endDate } = req.query;
    const diff = new Date(endDate) - new Date(startDate);
    
    if (diff > 90 * 24 * 60 * 60 * 1000) { // 90 days max
      return res.status(400).json({ error: 'Report period too long' });
    }
    next();
  },

  validateSAAddress: (address) => {
    return /^[a-zA-Z0-9\s,]{5,} \d{4}, (Gauteng|Western Cape|KwaZulu-Natal|Eastern Cape|Free State|North West|Northern Cape|Mpumalanga|Limpopo)$/i
      .test(address);
  }
};