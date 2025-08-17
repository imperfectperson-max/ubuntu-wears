// server/service/courier.js

const axios = require('axios');
const config = require('../config/courier');
const Order = require('../models/Order');

module.exports = {
  createDelivery: async (orderId) => {
    const order = await Order.findById(orderId).populate('user');
    
    const response = await axios.post(
      `${config.baseUrl}/deliveries`,
      {
        customer: {
          name: order.user.name,
          phone: order.user.phone.replace(/^0/, '+27'),
          email: order.user.email
        },
        parcels: order.items.map(item => ({
          description: item.name.substring(0, 100),
          quantity: item.quantity,
          weight: 0.5 // Default weight in kg
        })),
        collection_address: config.defaultOrigin,
        delivery_address: order.shippingAddress,
        service_type: config.services.standard
      },
      {
        headers: {
          'Api-Key': config.apiKey,
          'Account-Code': config.accountCode
        }
      }
    );

    return response.data.tracking_number;
  }
};