// server/utils/saTaxCalculator.js

module.exports = {
  calculateVAT: (amount) => {
    // SA VAT rate is 15%
    return parseFloat((amount * 0.15).toFixed(2));
  },

  calculateTotalWithVAT: (amount) => {
    const vat = this.calculateVAT(amount);
    return parseFloat((amount + vat).toFixed(2));
  },

  validateVATNumber: (vatNumber) => {
    // Basic SA VAT number validation (10 digits starting with 4)
    return /^4\d{9}$/.test(vatNumber);
  }
};