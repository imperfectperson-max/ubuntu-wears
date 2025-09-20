// orders.js - Orders functionality
const API_BASE = 'http://localhost:5000/api';

class OrdersManager {
    constructor() {
        this.orders = [];
        this.currentPage = 1;
        this.totalPages = 1;
        this.currentFilter = 'all';
        this.init();
    }

    async init() {
        await this.loadOrders();
        this.setupEventListeners();
        this.updateUI();
    }

    async loadOrders(page = 1, filter = 'all') {
        try {
            const token = localStorage.getItem('token');
            if (!token) {
                this.showLoginPrompt();
                return;
            }

            const response = await fetch(`${API_BASE}/orders/my-orders?page=${page}&filter=${filter}`, {
                headers: {
                    'Authorization': `Bearer ${token}`
                }
            });

            if (response.ok) {
                const data = await response.json();
                this.orders = data.orders;
                this.currentPage = data.currentPage;
                this.totalPages = data.totalPages;
                this.currentFilter = filter;
            } else {
                throw new Error('Failed to load orders');
            }
        } catch (error) {
            console.error('Error loading orders:', error);
            // Show demo data for development
            this.showDemoData();
        }
    }

    async loadOrderDetails(orderId) {
        try {
            const token = localStorage.getItem('token');
            const response = await fetch(`${API_BASE}/orders/${orderId}`, {
                headers: {
                    'Authorization': `Bearer ${token}`
                }
            });

            if (response.ok) {
                return await response.json();
            }
            throw new Error('Failed to load order details');
        } catch (error) {
            console.error('Error loading order details:', error);
            return null;
        }
    }

    async downloadInvoice(orderId) {
        try {
            const token = localStorage.getItem('token');
            const response = await fetch(`${API_BASE}/invoice/${orderId}`, {
                headers: {
                    'Authorization': `Bearer ${token}`
                }
            });

            if (response.ok) {
                const blob = await response.blob();
                const url = window.URL.createObjectURL(blob);
                const a = document.createElement('a');
                a.href = url;
                a.download = `invoice-${orderId}.pdf`;
                document.body.appendChild(a);
                a.click();
                window.URL.revokeObjectURL(url);
                document.body.removeChild(a);
            }
        } catch (error) {
            console.error('Error downloading invoice:', error);
            this.showNotification('Error downloading invoice', 'error');
        }
    }

    async reorder(orderId) {
        try {
            const token = localStorage.getItem('token');
            const response = await fetch(`${API_BASE}/orders/${orderId}/reorder`, {
                method: 'POST',
                headers: {
                    'Authorization': `Bearer ${token}`
                }
            });

            if (response.ok) {
                this.showNotification('Items added to cart for reorder');
                // Update cart count
                if (typeof cartManager !== 'undefined') {
                    await cartManager.loadCart();
                    cartManager.updateCartCount();
                }
                return true;
            }
            return false;
        } catch (error) {
            console.error('Error reordering:', error);
            return false;
        }
    }

    updateUI() {
        this.updateOrdersList();
        this.updatePagination();
        this.updateFilterButtons();
    }

    updateOrdersList() {
        const container = document.getElementById('ordersList');
        const emptyState = document.querySelector('.orders-empty');

        if (this.orders.length === 0) {
            container.innerHTML = '';
            emptyState.style.display = 'block';
            return;
        }

        emptyState.style.display = 'none';
        container.innerHTML = this.orders.map(order => `
            <div class="order-card" data-order-id="${order._id}">
                <div class="order-header">
                    <div>
                        <div class="order-id">Order #${order._id.slice(-8).toUpperCase()}</div>
                        <div class="order-date">Placed on ${new Date(order.createdAt).toLocaleDateString()}</div>
                    </div>
                    <div class="order-status status-${order.paymentStatus}">
                        ${this.formatStatus(order.paymentStatus)}
                    </div>
                </div>

                <div class="order-summary">
                    <div class="order-summary-item">
                        <span class="order-label">Items</span>
                        <span class="order-value">${order.items.length} product(s)</span>
                    </div>
                    <div class="order-summary-item">
                        <span class="order-label">Total Amount</span>
                        <span class="order-value">R${order.total.toFixed(2)}</span>
                    </div>
                    <div class="order-summary-item">
                        <span class="order-label">Payment Method</span>
                        <span class="order-value">${order.paymentMethod}</span>
                    </div>
                </div>

                <div class="order-items">
                    ${order.items.slice(0, 2).map(item => `
                        <div class="order-item">
                            <img src="${item.product?.images?.[0]?.url || 'https://via.placeholder.com/60'}" 
                                 alt="${item.name}" class="order-item-image">
                            <div class="order-item-details">
                                <div class="order-item-name">${item.name}</div>
                                <div class="order-item-price">R${item.price} × ${item.quantity}</div>
                            </div>
                        </div>
                    `).join('')}
                    ${order.items.length > 2 ? `
                        <div class="order-item">
                            <div class="order-item-details">
                                <div class="order-item-name">+${order.items.length - 2} more items</div>
                            </div>
                        </div>
                    ` : ''}
                </div>

                <div class="order-actions">
                    <button class="order-btn btn-view" onclick="ordersManager.viewOrder('${order._id}')">
                        <i class="fas fa-eye"></i> View Details
                    </button>
                    ${order.delivery?.trackingNumber ? `
                        <button class="order-btn btn-track" onclick="ordersManager.trackOrder('${order._id}')">
                            <i class="fas fa-truck"></i> Track Order
                        </button>
                    ` : ''}
                    <button class="order-btn btn-reorder" onclick="ordersManager.reorder('${order._id}')">
                        <i class="fas fa-redo"></i> Reorder
                    </button>
                    <button class="order-btn btn-invoice" onclick="ordersManager.downloadInvoice('${order._id}')">
                        <i class="fas fa-download"></i> Invoice
                    </button>
                </div>
            </div>
        `).join('');
    }

    updatePagination() {
        const pagination = document.getElementById('ordersPagination');
        const prevBtn = document.getElementById('prevPage');
        const nextBtn = document.getElementById('nextPage');
        const pageInfo = document.getElementById('pageInfo');

        if (this.totalPages > 1) {
            pagination.style.display = 'flex';
            prevBtn.disabled = this.currentPage === 1;
            nextBtn.disabled = this.currentPage === this.totalPages;
            pageInfo.textContent = `Page ${this.currentPage} of ${this.totalPages}`;
        } else {
            pagination.style.display = 'none';
        }
    }

    updateFilterButtons() {
        document.querySelectorAll('.filter-btn').forEach(btn => {
            btn.classList.remove('active');
            if (btn.dataset.filter === this.currentFilter) {
                btn.classList.add('active');
            }
        });
    }

    formatStatus(status) {
        const statusMap = {
            'pending': 'Pending',
            'processing': 'Processing',
            'shipped': 'Shipped',
            'delivered': 'Delivered',
            'cancelled': 'Cancelled',
            'completed': 'Completed'
        };
        return statusMap[status] || status;
    }

    async viewOrder(orderId) {
        const order = await this.loadOrderDetails(orderId);
        if (order) {
            this.showOrderModal(order);
        }
    }

    showOrderModal(order) {
        const modal = document.getElementById('orderModal');
        const details = document.getElementById('orderDetails');
        
        details.innerHTML = `
            <div class="order-details-grid">
                <div>
                    <div class="order-details-section">
                        <h3>Order Summary</h3>
                        <div class="order-summary">
                            <div class="order-summary-item">
                                <span class="order-label">Order ID</span>
                                <span class="order-value">${order._id}</span>
                            </div>
                            <div class="order-summary-item">
                                <span class="order-label">Order Date</span>
                                <span class="order-value">${new Date(order.createdAt).toLocaleString()}</span>
                            </div>
                            <div class="order-summary-item">
                                <span class="order-label">Status</span>
                                <span class="order-value status-${order.paymentStatus}">
                                    ${this.formatStatus(order.paymentStatus)}
                                </span>
                            </div>
                            <div class="order-summary-item">
                                <span class="order-label">Total Amount</span>
                                <span class="order-value">R${order.total.toFixed(2)}</span>
                            </div>
                        </div>
                    </div>

                    <div class="order-details-section">
                        <h3>Delivery Information</h3>
                        <div class="delivery-info">
                            <p><strong>Address:</strong> ${order.shippingAddress?.street}, ${order.shippingAddress?.city}</p>
                            <p><strong>Province:</strong> ${order.shippingAddress?.province}</p>
                            <p><strong>Postal Code:</strong> ${order.shippingAddress?.postalCode}</p>
                            ${order.delivery?.trackingNumber ? `
                                <p><strong>Tracking Number:</strong> ${order.delivery.trackingNumber}</p>
                                <p><strong>Courier:</strong> ${order.delivery.method}</p>
                            ` : ''}
                        </div>
                    </div>
                </div>

                <div>
                    <div class="order-details-section">
                        <h3>Payment Information</h3>
                        <div class="payment-info">
                            <p><strong>Method:</strong> ${order.paymentMethod}</p>
                            <p><strong>Status:</strong> ${order.paymentStatus}</p>
                            <p><strong>Subtotal:</strong> R${order.subtotal.toFixed(2)}</p>
                            <p><strong>VAT (15%):</strong> R${order.vat.toFixed(2)}</p>
                            <p><strong>Delivery Fee:</strong> R${order.deliveryFee.toFixed(2)}</p>
                            <p><strong>Total:</strong> R${order.total.toFixed(2)}</p>
                        </div>
                    </div>

                    ${order.delivery?.trackingNumber ? `
                        <div class="order-details-section">
                            <h3>Tracking Information</h3>
                            <div class="tracking-steps">
                                ${this.getTrackingSteps(order)}
                            </div>
                        </div>
                    ` : ''}
                </div>
            </div>

            <div class="order-details-section">
                <h3>Order Items</h3>
                <div class="order-items">
                    ${order.items.map(item => `
                        <div class="order-item">
                            <img src="${item.product?.images?.[0]?.url || 'https://via.placeholder.com/60'}" 
                                 alt="${item.name}" class="order-item-image">
                            <div class="order-item-details">
                                <div class="order-item-name">${item.name}</div>
                                <div class="order-item-price">R${item.price} × ${item.quantity}</div>
                                <div class="order-item-total">R${(item.price * item.quantity).toFixed(2)}</div>
                            </div>
                        </div>
                    `).join('')}
                </div>
            </div>
        `;

        modal.style.display = 'block';
    }

    getTrackingSteps(order) {
        const steps = [
            { status: 'processing', label: 'Processing', icon: 'fas fa-cog' },
            { status: 'shipped', label: 'Shipped', icon: 'fas fa-truck' },
            { status: 'delivered', label: 'Delivered', icon: 'fas fa-check' }
        ];

        return steps.map(step => {
            const isCompleted = this.isStepCompleted(order, step.status);
            const isActive = order.paymentStatus === step.status;
            
            return `
                <div class="tracking-step ${isCompleted ? 'step-completed' : ''} ${isActive ? 'step-active' : ''}">
                    <div class="step-icon">
                        <i class="${step.icon}"></i>
                    </div>
                    <div class="step-label">${step.label}</div>
                </div>
            `;
        }).join('');
    }

    isStepCompleted(order, stepStatus) {
        const statusOrder = ['processing', 'shipped', 'delivered'];
        const currentIndex = statusOrder.indexOf(order.paymentStatus);
        const stepIndex = statusOrder.indexOf(stepStatus);
        return currentIndex >= stepIndex;
    }

    trackOrder(orderId) {
        // Implement tracking functionality
        this.showNotification('Tracking feature coming soon!', 'info');
    }

    setupEventListeners() {
        // Filter buttons
        document.querySelectorAll('.filter-btn').forEach(btn => {
            btn.addEventListener('click', () => {
                this.loadOrders(1, btn.dataset.filter);
            });
        });

        // Pagination buttons
        document.getElementById('prevPage').addEventListener('click', () => {
            if (this.currentPage > 1) {
                this.loadOrders(this.currentPage - 1, this.currentFilter);
            }
        });

        document.getElementById('nextPage').addEventListener('click', () => {
            if (this.currentPage < this.totalPages) {
                this.loadOrders(this.currentPage + 1, this.currentFilter);
            }
        });

        // Modal close
        window.addEventListener('click', (e) => {
            const modal = document.getElementById('orderModal');
            if (e.target === modal) {
                this.closeModal();
            }
        });
    }

    closeModal() {
        document.getElementById('orderModal').style.display = 'none';
    }

    showLoginPrompt() {
        if (confirm('You need to be logged in to view orders. Would you like to login now?')) {
            window.location.href = '../login/login.html';
        }
    }

    showNotification(message, type = 'info') {
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

    showDemoData() {
        // Demo data for development
        this.orders = [
            {
                _id: 'order123',
                items: [
                    {
                        product: {
                            images: [{ url: 'https://via.placeholder.com/60' }],
                            name: 'Zulu Beaded Necklace'
                        },
                        name: 'Zulu Beaded Necklace',
                        price: 250,
                        quantity: 1
                    }
                ],
                total: 250,
                subtotal: 217.39,
                vat: 32.61,
                deliveryFee: 99,
                paymentMethod: 'PayFast',
                paymentStatus: 'delivered',
                shippingAddress: {
                    street: '123 Main St',
                    city: 'Johannesburg',
                    province: 'Gauteng',
                    postalCode: '2000'
                },
                delivery: {
                    trackingNumber: 'TRK123456789',
                    method: 'Courier Guy'
                },
                createdAt: new Date('2024-01-15')
            }
        ];
        this.currentPage = 1;
        this.totalPages = 1;
        this.updateUI();
    }
}

// Initialize orders manager
let ordersManager;

document.addEventListener('DOMContentLoaded', function() {
    ordersManager = new OrdersManager();
});

// Global functions for modal
function closeModal() {
    if (ordersManager) {
        ordersManager.closeModal();
    }
}