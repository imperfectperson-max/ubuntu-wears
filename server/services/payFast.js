// server/services/payFast.js
const crypto = require('crypto');
const config = require('../config/payfast');

module.exports = {
  generatePaymentUrl: (data) => {
    if (!config.merchantId || !config.merchantKey) {
      throw new Error('PayFast merchant credentials not configured');
    }

    const payload = {
      merchant_id: config.merchantId,
      merchant_key: config.merchantKey,
      ...data,
      return_url: `${process.env.FRONTEND_URL}/payment-success`,
      cancel_url: `${process.env.FRONTEND_URL}/payment-cancelled`,
      notify_url: `${process.env.API_URL}/api/payments/webhook`,
      m_payment_id: data.orderId || Date.now().toString()
    };

    // Validate required fields
    if (!payload.amount || !payload.item_name) {
      throw new Error('Amount and item_name are required');
    }

    const signature = crypto
      .createHash('md5')
      .update(new URLSearchParams(payload).toString() + `&passphrase=${config.passphrase}`)
      .digest('hex');

    return `${config.urls.process}?${new URLSearchParams({ ...payload, signature })}`;
  },

  validateNotification: (data) => {
    if (!data.signature) return false;
    
    const localSignature = crypto
      .createHash('md5')
      .update(new URLSearchParams(data).toString() + `&passphrase=${config.passphrase}`)
      .digest('hex');

    return crypto.timingSafeEqual(
      Buffer.from(localSignature),
      Buffer.from(data.signature)
    );
  }
};