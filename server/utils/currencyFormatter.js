// server/utils/currencyFormatter.js
module.exports = {
  formatZAR: (amount) => {
    return new Intl.NumberFormat('en-ZA', {
      style: 'currency',
      currency: 'ZAR'
    }).format(amount);
  },

  parseZAR: (formattedString) => {
    return parseFloat(
      formattedString
        .replace(/[^0-9.,]/g, '')
        .replace(',', '.')
    );
  }
};