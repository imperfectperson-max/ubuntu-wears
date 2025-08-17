// server/models/Discount.js
const mongoose = require('mongoose');

const discountSchema = new mongoose.Schema({
  code: { 
    type: String, 
    required: true,
    unique: true,
    uppercase: true
  },
  description: String,
  discountType: {
    type: String,
    enum: ['percentage', 'fixed'],
    required: true
  },
  value: { 
    type: Number, 
    required: true,
    min: 0,
    // For percentage: max 100, for fixed: no max but validate in middleware
    validate: {
      validator: function(v) {
        return this.discountType === 'percentage' ? v <= 100 : true;
      },
      message: 'Percentage discount cannot exceed 100%'
    }
  },
  minOrderAmount: { type: Number, default: 0 }, // Minimum cart total to apply
  validFrom: { type: Date, default: Date.now },
  validUntil: Date,
  maxUses: { type: Number, default: null }, // null = unlimited
  usedCount: { type: Number, default: 0 },
  isActive: { type: Boolean, default: true },
  appliesTo: {
    type: String,
    enum: ['all', 'categories', 'products'],
    default: 'all'
  },
  categories: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Category' }],
  products: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Product' }],
  createdBy: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true }
}, { timestamps: true });

module.exports = mongoose.model('Discount', discountSchema);