// cart.js - Cart functionality
const API_BASE = 'http://localhost:5000/api';

class CartManager {
    constructor() {
        this.cart = null;
        this.discount = null;
        this.init();
    }

    async init() {
        await this.loadCart();
        this.updateUI();
        this.setupEventListeners();
    }

    async loadCart() {
        try {
            const token = localStorage.getItem('token');
            if (!token) {
                this.showLoginPrompt();
                return;
            }

            const response = await fetch(`${API_BASE}/cart`, {
                headers: {
                    'Authorization': `Bearer ${token}`
                }
            });

            if (response.ok) {
                this.cart = await response.json();
            } else if (response.status === 404) {
                this.cart = { items: [], subtotal: 0, deliveryFee: 99, total: 99 };
            } else {
                throw new Error('Failed to load cart');
            }
        } catch (error) {
            console.error('Error loading cart:', error);
            this.cart = { items: [], subtotal: 0, deliveryFee: 99, total: 99 };
        }
    }

    async addToCart(productId, quantity = 1) {
        try {
            const token = localStorage.getItem('token');
            if (!token) {
                this.showLoginPrompt();
                return false;
            }

            const response = await fetch(`${API_BASE}/cart/add-item`, {
                method: 'POST',
                headers: {
                    'Authorization': `Bearer ${token}`,
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ productId, quantity })
            });

            if (response.ok) {
                await this.loadCart();
                this.updateUI();
                this.showNotification('Product added to cart!');
                return true;
            }
            return false;
        } catch (error) {
            console.error('Error adding to cart:', error);
            return false;
        }
    }

    async updateQuantity(productId, newQuantity) {
        if (newQuantity < 1) {
            await this.removeFromCart(productId);
            return;
        }

        try {
            const token = localStorage.getItem('token');
            const response = await fetch(`${API_BASE}/cart/update-item`, {
                method: 'PUT',
                headers: {
                    'Authorization': `Bearer ${token}`,
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ productId, quantity: newQuantity })
            });

            if (response.ok) {
                await this.loadCart();
                this.updateUI();
            }
        } catch (error) {
            console.error('Error updating quantity:', error);
        }
    }

    async removeFromCart(productId) {
        try {
            const token = localStorage.getItem('token');
            const response = await fetch(`${API_BASE}/cart/remove-item/${productId}`, {
                method: 'DELETE',
                headers: {
                    'Authorization': `Bearer ${token}`
                }
            });

            if (response.ok) {
                await this.loadCart();
                this.updateUI();
                this.showNotification('Product removed from cart');
            }
        } catch (error) {
            console.error('Error removing from cart:', error);
        }
    }

    async applyDiscount(code) {
        try {
            const token = localStorage.getItem('token');
            const response = await fetch(`${API_BASE}/discounts/apply`, {
                method: 'POST',
                headers: {
                    'Authorization': `Bearer ${token}`,
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ code, cartId: this.cart._id })
            });

            if (response.ok) {
                const result = await response.json();
                this.discount = result.discount;
                this.cart = result.cart;
                this.updateUI();
                this.showNotification('Discount applied successfully!');
                return true;
            } else {
                const error = await response.json();
                this.showNotification(error.error || 'Invalid discount code');
                return false;
            }
        } catch (error) {
            console.error('Error applying discount:', error);
            return false;
        }
    }

    removeDiscount() {
        this.discount = null;
        this.cart.discount = null;
        this.cart.total = this.cart.subtotal + this.cart.deliveryFee;
        this.updateUI();
    }

    updateUI() {
        this.updateCartItems();
        this.updateSummary();
        this.updateCartCount();
    }

    updateCartItems() {
        const container = document.getElementById('cartItemsContainer');
        const emptyState = document.querySelector('.cart-empty');

        if (!this.cart || this.cart.items.length === 0) {
            container.innerHTML = '';
            emptyState.style.display = 'block';
            return;
        }

        emptyState.style.display = 'none';
        container.innerHTML = this.cart.items.map(item => `
            <div class="cart-item" data-product-id="${item.product._id}">
                <img src="${item.product.images[0]?.url || 'https://via.placeholder.com/80'}" 
                     alt="${item.product.name}" class="item-image">
                <div class="item-details">
                    <div class="item-name">${item.product.name}</div>
                    <div class="item-price">R${item.price}</div>
                    <div class="item-stock ${item.product.stock < 5 ? 'low' : ''}">
                        ${item.product.stock < 5 ? 'Almost sold out' : 'In stock'}
                    </div>
                </div>
                <div class="quantity-controls">
                    <button class="quantity-btn minus" onclick="cartManager.updateQuantity('${item.product._id}', ${item.quantity - 1})">-</button>
                    <input type="number" class="quantity-input" value="${item.quantity}" 
                           min="1" max="${item.product.stock}" 
                           onchange="cartManager.updateQuantity('${item.product._id}', this.value)">
                    <button class="quantity-btn plus" onclick="cartManager.updateQuantity('${item.product._id}', ${item.quantity + 1})">+</button>
                </div>
                <button class="remove-btn" onclick="cartManager.removeFromCart('${item.product._id}')">
                    <i class="fas fa-trash"></i>
                </button>
            </div>
        `).join('');
    }

    updateSummary() {
        if (!this.cart) return;

        document.getElementById('subtotal').textContent = `R${this.cart.subtotal.toFixed(2)}`;
        document.getElementById('vat').textContent = `R${(this.cart.subtotal * 0.15).toFixed(2)}`;
        document.getElementById('deliveryFee').textContent = `R${this.cart.deliveryFee.toFixed(2)}`;
        document.getElementById('totalAmount').textContent = `R${this.cart.total.toFixed(2)}`;

        // Update discount display
        const discountElement = document.querySelector('.discount-applied');
        if (this.discount) {
            discountElement.style.display = 'flex';
            document.getElementById('discountAmount').textContent = `-R${this.discount.amount.toFixed(2)}`;
        } else {
            discountElement.style.display = 'none';
        }
    }

    updateCartCount() {
        const countElements = document.querySelectorAll('.cart-count');
        const count = this.cart ? this.cart.items.reduce((total, item) => total + item.quantity, 0) : 0;
        
        countElements.forEach(el => {
            el.textContent = count;
            el.style.display = count > 0 ? 'inline' : 'none';
        });
    }

    async proceedToCheckout() {
        // Validate address and phone number
        const address = document.getElementById('autocomplete-address').value;
        const phone = document.getElementById('phone-number').value;

        if (!address || !phone) {
            this.showNotification('Please complete your delivery information');
            return;
        }

        try {
            const token = localStorage.getItem('token');
            const response = await fetch(`${API_BASE}/orders`, {
                method: 'POST',
                headers: {
                    'Authorization': `Bearer ${token}`,
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    shippingAddress: address,
                    phoneNumber: phone,
                    paymentMethod: 'PayFast' // Default payment method
                })
            });

            if (response.ok) {
                const order = await response.json();
                window.location.href = `checkout.html?orderId=${order._id}`;
            } else {
                throw new Error('Failed to create order');
            }
        } catch (error) {
            console.error('Error proceeding to checkout:', error);
            this.showNotification('Error creating order. Please try again.');
        }
    }

    showLoginPrompt() {
        if (confirm('You need to be logged in to use the cart. Would you like to login now?')) {
            window.location.href = 'login.html';
        }
    }

    showNotification(message, type = 'info') {
        // Create notification element
        const notification = document.createElement('div');
        notification.className = `notification ${type}`;
        notification.innerHTML = `
            <span>${message}</span>
            <button onclick="this.parentElement.remove()">&times;</button>
        `;
        
        document.body.appendChild(notification);
        
        // Auto-remove after 3 seconds
        setTimeout(() => {
            if (notification.parentElement) {
                notification.remove();
            }
        }, 3000);
    }

    setupEventListeners() {
        // Quantity input validation
        document.addEventListener('change', (e) => {
            if (e.target.classList.contains('quantity-input')) {
                const productId = e.target.closest('.cart-item').dataset.productId;
                const quantity = parseInt(e.target.value);
                
                if (isNaN(quantity) || quantity < 1) {
                    e.target.value = 1;
                    this.updateQuantity(productId, 1);
                } else {
                    this.updateQuantity(productId, quantity);
                }
            }
        });

        // Discount form submission
        document.querySelector('.discount-form')?.addEventListener('submit', (e) => {
            e.preventDefault();
            const code = document.getElementById('discountCode').value;
            if (code) {
                this.applyDiscount(code);
            }
        });
    }
}

// Initialize cart manager
let cartManager;

document.addEventListener('DOMContentLoaded', function() {
    cartManager = new CartManager();
});

// Global functions for HTML onclick attributes
function applyDiscount() {
    const code = document.getElementById('discountCode').value;
    if (code) {
        cartManager.applyDiscount(code);
    }
}

function removeDiscount() {
    cartManager.removeDiscount();
}

function proceedToCheckout() {
    cartManager.proceedToCheckout();
}