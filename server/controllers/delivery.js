// server/controllers/delivery.js

const axios = require('axios');

exports.createDelivery = async (order) => {
  const response = await axios.post('https://api.thecourierguy.co.za/v1/deliveries', {
    customer: {
      name: order.user.name,
      email: order.user.email,
      phone: order.user.phone // SA format: "+27721234567"
    },
    // dynamic in terms of the seller
    collection_address: "Ubuntu Wears Warehouse, Johannesburg",
    delivery_address: order.shippingAddress,
    parcels: order.items.map(item => ({
      description: item.name,
      quantity: item.quantity
    })),
    special_instructions: "Fragile items",
    service_type: "ONDEMAND"
  }, {
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${process.env.COURIERGUY_API_KEY}`
    }
  });

  // Save tracking number to order
  order.delivery.trackingNumber = response.data.tracking_number;
  await order.save();
  
  return response.data;
};