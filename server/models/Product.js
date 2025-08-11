// server\models\Products.js 
const mongoose = require('mongoose');

const productSchema = new mongoose.Schema({
  name: { type: String, required: true },
  description: { type: String, required: true },
  price: { type: Number, required: true },
  category: { type: String, required: true },
  images: [{ type: String }], // Array of image filenames
  stock: { type: Number, default: 0 },
  createdAt: { type: Date, default: Date.now }
}, {
  toJSON: { virtuals: true },
  toObject: { virtuals: true }
});

// Virtual for full image URLs
productSchema.virtual('imageUrls').get(function() {
  return this.images.map(image => `/public/uploads/${image}`);
});

module.exports = mongoose.model('Product', productSchema);