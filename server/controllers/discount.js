// server/controllers/discount.js

const Discount = require('../models/Discount');
const Cart = require('../models/Cart'); // make sure you have Cart model imported

// Create new discount (admin)
exports.createDiscount = async (req, res) => {
  try {
    const discount = new Discount({
      ...req.body,
      createdBy: req.user._id
    });

    await discount.save();
    res.status(201).json(discount);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};

// Update discount (admin)
exports.updateDiscount = async (req, res) => {
  try {
    const discount = await Discount.findByIdAndUpdate(
      req.params.id,
      req.body,
      { new: true, runValidators: true }
    );

    if (!discount) return res.status(404).json({ error: 'Discount not found' });
    res.json(discount);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};

// Delete discount (admin)
exports.deleteDiscount = async (req, res) => {
  try {
    const discount = await Discount.findByIdAndDelete(req.params.id);
    if (!discount) return res.status(404).json({ error: 'Discount not found' });
    res.json({ message: 'Discount deleted' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Get discount by code (public)
exports.getDiscount = async (req, res) => {
  try {
    const discount = await Discount.findOne({ code: req.params.code, isActive: true });
    if (!discount) return res.status(404).json({ error: 'Discount not found' });
    res.json(discount);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// List all active discounts (public)
exports.listActiveDiscounts = async (req, res) => {
  try {
    const discounts = await Discount.find({ isActive: true });
    res.json(discounts);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Apply discount to a cart
exports.applyDiscount = async (req, res) => {
  const { code, cartId } = req.body;

  try {
    const discount = await Discount.findOne({
      code,
      isActive: true,
      validFrom: { $lte: new Date() },
      validUntil: { $gte: new Date() }
    });

    if (!discount) {
      return res.status(404).json({ error: 'Invalid or expired discount code' });
    }

    const cart = await Cart.findById(cartId);
    if (!cart) return res.status(404).json({ error: 'Cart not found' });

    // Check minimum order amount
    if (discount.minOrderAmount > cart.subtotal) {
      return res.status(400).json({ error: `Minimum order amount of R${discount.minOrderAmount} required` });
    }

    // Calculate discount
    let discountAmount = discount.discountType === 'percentage'
      ? cart.subtotal * (discount.value / 100)
      : discount.value;

    cart.discount = {
      code: discount.code,
      amount: discountAmount,
      discountId: discount._id
    };
    cart.total = cart.subtotal - discountAmount + cart.deliveryFee;

    await cart.save();
    res.json(cart);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
