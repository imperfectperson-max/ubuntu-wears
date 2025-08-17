// server/models/Cart.js
const mongoose = require('mongoose');

const cartItemSchema = new mongoose.Schema({
  product: { 
    type: mongoose.Schema.Types.ObjectId, 
    ref: 'Product', 
    required: true 
  },
  // products disappear when stock is 0 (DISCUSS)
  // review
  quantity: { 
    type: Number, 
    default: 1, 
    min: 1 
  },
  price: { 
    type: Number, 
    required: true 
  }
});

const cartSchema = new mongoose.Schema({
  user: { 
    type: mongoose.Schema.Types.ObjectId, 
    ref: 'User', 
    required: true,
    unique: true 
  },
  items: [cartItemSchema],
  subtotal: { 
    type: Number, 
    default: 0 
  },
  deliveryFee: { 
    type: Number, 
    default: 99 // ZAR standard fee
  },
  discount: {
    code: String,
    amount: { type: Number, default: 0 },
    discountId: { type: mongoose.Schema.Types.ObjectId, ref: 'Discount' }
  },
  total: { 
    type: Number,
    default: function() {
      return (this.subtotal - (this.discount?.amount || 0)) + this.deliveryFee;
    }
  }
});

// Updated pre-save hook to handle discounts
cartSchema.pre('save', function(next) {
  this.subtotal = this.items.reduce((sum, item) => sum + (item.price * item.quantity), 0);
  this.total = (this.subtotal - (this.discount?.amount || 0)) + this.deliveryFee;
  next();
});

module.exports = mongoose.model('Cart', cartSchema);