// server/config/courier.js
module.exports = {
  apiKey: process.env.COURIER_API_KEY,
  accountCode: process.env.COURIER_ACCOUNT_CODE,
  baseUrl: 'https://api.thecourierguy.co.za/v1',
  // Edit later
  defaultOrigin: process.env.WAREHOUSE_ADDRESS || '123 Main St, Johannesburg, SA',
  services: {
    standard: 'ONDEMAND',
    express: 'EXPRESS'
  }
};
