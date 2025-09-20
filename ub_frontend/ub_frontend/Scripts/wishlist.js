// wishlist.js - Wishlist functionality
const API_BASE = 'http://localhost:5000/api';

class WishlistManager {
    constructor() {
        this.wishlist = null;
        this.init();
    }

    async init() {
        await this.loadWishlist();
        this.updateUI();
    }

    async loadWishlist() {
        try {
            const token = localStorage.getItem('token');
            if (!token) {
                this.showLoginPrompt();
                return;
            }

            const response = await fetch(`${API_BASE}/wishlist`, {
                headers: {
                    'Authorization': `Bearer ${token}`
                }
            });

            if (response.ok) {
                this.wishlist = await response.json();
            } else if (response.status === 404) {
                this.wishlist = { items: [] };
            } else {
                throw new Error('Failed to load wishlist');
            }
        } catch (error) {
            console.error('Error loading wishlist:', error);
            this.wishlist = { items: [] };
        }
    }

    async addToWishlist(productId) {
        try {
            const token = localStorage.getItem('token');
            if (!token) {
                this.showLoginPrompt();
                return false;
            }

            const response = await fetch(`${API_BASE}/wishlist/add`, {
                method: 'POST',
                headers: {
                    'Authorization': `Bearer ${token}`,
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ productId })
            });

            if (response.ok) {
                await this.loadWishlist();
                this.updateUI();
                this.showNotification('Added to wishlist!');
                return true;
            }
            return false;
        } catch (error) {
            console.error('Error adding to wishlist:', error);
            return false;
        }
    }

    async removeFromWishlist(productId) {
        try {
            const token = localStorage.getItem('token');
            const response = await fetch(`${API_BASE}/wishlist/remove/${productId}`, {
                method: 'DELETE',
                headers: {
                    'Authorization': `Bearer ${token}`
                }
            });

            if (response.ok) {
                await this.loadWishlist();
                this.updateUI();
                this.showNotification('Removed from wishlist');
            }
        } catch (error) {
            console.error('Error removing from wishlist:', error);
        }
    }

    async moveToCart(productId) {
        try {
            // First add to cart
            const added = await cartManager.addToCart(productId, 1);
            if (added) {
                // Then remove from wishlist
                await this.removeFromWishlist(productId);
            }
        } catch (error) {
            console.error('Error moving to cart:', error);
        }
    }

    updateUI() {
        const container = document.getElementById('wishlistItems');
        const emptyState = document.querySelector('.wishlist-empty');

        if (!this.wishlist || this.wishlist.items.length === 0) {
            container.innerHTML = '';
            emptyState.style.display = 'block';
            return;
        }

        emptyState.style.display = 'none';
        container.innerHTML = this.wishlist.items.map(item => `
            <div class="wishlist-item" data-product-id="${item.product._id}">
                ${item.product.stock < 5 ? '<div class="wishlist-item-badge">Low Stock</div>' : ''}
                <img src="${item.product.images[0]?.url || 'https://via.placeholder.com/300'}" 
                     alt="${item.product.name}" class="wishlist-item-image">
                <div class="wishlist-item-content">
                    <h3 class="wishlist-item-name">${item.product.name}</h3>
                    <div class="wishlist-item-price">R${item.product.price}</div>
                    <div class="wishlist-item-availability ${item.product.stock > 0 ? 'in-stock' : 'out-of-stock'}">
                        ${item.product.stock > 0 ? 'In stock' : 'Out of stock'}
                    </div>
                    ${item.priceThreshold ? `
                        <div class="price-alert">
                            <i class="fas fa-bell"></i> Alert set at R${item.priceThreshold}
                        </div>
                    ` : ''}
                    <div class="wishlist-item-actions">
                        <button class="wishlist-btn btn-add-cart" onclick="wishlistManager.moveToCart('${item.product._id}')">
                            <i class="fas fa-shopping-cart"></i> Add to Cart
                        </button>
                        <button class="wishlist-btn btn-remove" onclick="wishlistManager.removeFromWishlist('${item.product._id}')">
                            <i class="fas fa-trash"></i> Remove
                        </button>
                    </div>
                </div>
            </div>
        `).join('');
    }

    showLoginPrompt() {
        if (confirm('You need to be logged in to use the wishlist. Would you like to login now?')) {
            window.location.href = '../login/login.html';
        }
    }

    showNotification(message, type = 'info') {
        // Reuse the same notification function from cart.js
        const notification = document.createElement('div');
        notification.className = `notification ${type}`;
        notification.innerHTML = `
            <span>${message}</span>
            <button onclick="this.parentElement.remove()">&times;</button>
        `;
        
        document.body.appendChild(notification);
        
        setTimeout(() => {
            if (notification.parentElement) {
                notification.remove();
            }
        }, 3000);
    }
}

// Initialize wishlist manager
let wishlistManager;

document.addEventListener('DOMContentLoaded', function() {
    wishlistManager = new WishlistManager();
});

// Global function to add products to wishlist from product pages
function addToWishlist(productId) {
    if (!wishlistManager) {
        wishlistManager = new WishlistManager();
    }
    wishlistManager.addToWishlist(productId);
}