// server/controllers/wishlist.js

const Wishlist = require('../models/Wishlist');
const Product = require('../models/Product');

exports.addToWishlist = async (req, res) => {
  try {
    const { productId } = req.body;
    
    const product = await Product.findById(productId);
    if (!product) {
      return res.status(404).json({ error: 'Product not found' });
    }

    let wishlist = await Wishlist.findOne({ user: req.user._id });
    
    if (!wishlist) {
      wishlist = new Wishlist({ user: req.user._id, items: [] });
    }

    // Check if product already exists
    const existingItem = wishlist.items.find(item => 
      item.product.toString() === productId
    );
    
    if (existingItem) {
      return res.status(400).json({ error: 'Product already in wishlist' });
    }

    wishlist.items.push({ product: productId });
    await wishlist.save();
    
    res.status(201).json(wishlist);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Remove product from wishlist
exports.removeFromWishlist = async (req, res) => {
  try {
    const { productId } = req.params;
    const wishlist = await Wishlist.findOne({ user: req.user._id });
    if (!wishlist) return res.status(404).json({ error: 'Wishlist not found' });

    wishlist.items = wishlist.items.filter(item => item.product.toString() !== productId);
    await wishlist.save();

    res.json(wishlist);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Get user's wishlist
exports.getWishlist = async (req, res) => {
  try {
    const wishlist = await Wishlist.findOne({ user: req.user._id }).populate('items.product');
    res.json(wishlist || { items: [] });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Set price alert for a product
exports.setPriceAlert = async (req, res) => {
  const { productId, threshold } = req.body;

  await Wishlist.updateOne(
    { user: req.user._id, 'items.product': productId },
    { $set: { 'items.$.priceThreshold': threshold } }
  );

  res.json({ message: `Price alert set at ${threshold}` });
};

// SA-specific: Notify when product is back in stock
exports.setAvailabilityAlert = async (req, res) => {
  const { productId, notify } = req.body;
  
  await Wishlist.updateOne(
    { user: req.user._id, 'items.product': productId },
    { $set: { 'items.$.notifyWhenAvailable': notify } }
  );
  
  res.json({ message: notify ? 
    'You will be notified when this product is available' : 
    'Availability notifications disabled' 
  });
};