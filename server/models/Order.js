// server/models/Order.js
const mongoose = require('mongoose');

const orderSchema = new mongoose.Schema({
  user: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  items: [{
    product: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Product',
      required: true
    },
    name: {
      type: String,
      required: true
    },
    quantity: {
      type: Number,
      required: true,
      min: 1
    },
    price: {
      type: Number,
      required: true,
      min: 0
    }
  }],
  subtotal: {
    type: Number,
    required: true,
    min: 0
  },
  vat: {
    type: Number,
    required: true,
    min: 0
  },
  deliveryFee: {
    type: Number,
    required: true,
    min: 0,
    default: 99 // ZAR
  },
  discount: {
    code: String,
    amount: {
      type: Number,
      default: 0,
      min: 0
    }
  },
  total: {
    type: Number,
    required: true,
    min: 0
  },
  paymentMethod: {
    type: String,
    enum: ['PayFast', 'EFT', 'Credit Card'],
    required: true
  },
  paymentStatus: {
    type: String,
    enum: ['pending', 'completed', 'failed', 'refunded'],
    default: 'pending'
  },
  delivery: {
    method: {
      type: String,
      enum: ['Courier Guy', 'Pargo', 'Takealot'],
      required: true
    },
    trackingNumber: String,
    status: {
      type: String,
      enum: ['processing', 'dispatched', 'in-transit', 'delivered', 'failed'],
      default: 'processing'
    }
  },
  shippingAddress: {
    street: {
      type: String,
      required: true
    },
    city: {
      type: String,
      required: true
    },
    postalCode: {
      type: String,
      required: true
    },
    province: {
      type: String,
      enum: ['Gauteng', 'Western Cape', 'KZN', 'Eastern Cape', 'Free State', 'North West', 'Northern Cape', 'Mpumalanga', 'Limpopo'],
      required: true
    }
  }
}, {
  timestamps: true
});

// Indexes
orderSchema.index({ user: 1 });
orderSchema.index({ createdAt: -1 });
orderSchema.index({ 'delivery.status': 1 });
orderSchema.index({ paymentStatus: 1 });

module.exports = mongoose.model('Order', orderSchema);