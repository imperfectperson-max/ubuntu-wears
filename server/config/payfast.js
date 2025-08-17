// server/config/payfast.js
module.exports = {
  merchantId: process.env.PAYFAST_MERCHANT_ID,
  merchantKey: process.env.PAYFAST_MERCHANT_KEY,
  passphrase: process.env.PAYFAST_PASSPHRASE,
  sandbox: process.env.NODE_ENV !== 'production',
  urls: {
    process: 'https://www.payfast.co.za/eng/process',
    validate: 'https://www.payfast.co.za/eng/query/validate'
  },
  saFeeStructure: {
    eft: 0,    // Free EFT transfers
    creditCard: 0.0195 // 1.95% fee
  }
};