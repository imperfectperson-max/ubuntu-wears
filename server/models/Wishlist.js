// server/models/Wishlist.js

const mongoose = require('mongoose');

const wishlistSchema = new mongoose.Schema({
  user: { 
    type: mongoose.Schema.Types.ObjectId, 
    ref: 'User', 
    required: true,
    unique: true // One wishlist per user
  },
  items: [{
    product: { 
      type: mongoose.Schema.Types.ObjectId, 
      ref: 'Product',
      required: true 
    },
    addedAt: { 
      type: Date, 
      default: Date.now 
    },
    // SA-specific fields
    notifyWhenAvailable: {
      type: Boolean,
      default: false
    },
    priceAlertThreshold: Number // ZAR amount for price drop alerts
  }],
  createdAt: { 
    type: Date, 
    default: Date.now 
  }
});

// Index for faster queries
wishlistSchema.index({ user: 1, 'items.product': 1 });

module.exports = mongoose.model('Wishlist', wishlistSchema);