// checkout.js - Checkout functionality
const API_BASE = 'http://localhost:5000/api';

class CheckoutManager {
    constructor() {
        this.order = null;
        this.paymentMethod = 'PayFast';
        this.init();
    }

    async init() {
        await this.loadOrderData();
        this.setupEventListeners();
        this.updateUI();
    }

    async loadOrderData() {
        try {
            const urlParams = new URLSearchParams(window.location.search);
            const orderId = urlParams.get('orderId');
            
            if (!orderId) {
                this.showError('No order specified');
                return;
            }

            const token = localStorage.getItem('token');
            const response = await fetch(`${API_BASE}/orders/${orderId}`, {
                headers: {
                    'Authorization': `Bearer ${token}`
                }
            });

            if (response.ok) {
                this.order = await response.json();
                this.populateUserData();
            } else {
                throw new Error('Failed to load order data');
            }
        } catch (error) {
            console.error('Error loading order data:', error);
            this.showDemoData();
        }
    }

    populateUserData() {
        const user = JSON.parse(localStorage.getItem('user'));
        if (user) {
            document.getElementById('firstName').value = user.name.split(' ')[0] || '';
            document.getElementById('lastName').value = user.name.split(' ').slice(1).join(' ') || '';
            document.getElementById('email').value = user.email || '';
            document.getElementById('phone').value = user.phoneNumber || '';
            
            if (user.address) {
                document.getElementById('address').value = user.address.street || '';
                document.getElementById('city').value = user.address.city || '';
                document.getElementById('postalCode').value = user.address.postalCode || '';
                document.getElementById('province').value = user.address.province || '';
            }
        }
    }

    async processPayment() {
        if (!this.validateForms()) {
            this.showError('Please complete all required fields');
            return;
        }

        try {
            const shippingData = this.getShippingData();
            const paymentData = this.getPaymentData();

            const token = localStorage.getItem('token');
            const response = await fetch(`${API_BASE}/payments/process`, {
                method: 'POST',
                headers: {
                    'Authorization': `Bearer ${token}`,
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    orderId: this.order._id,
                    shippingData,
                    paymentData
                })
            });

            if (response.ok) {
                const result = await response.json();
                
                if (result.paymentUrl) {
                    // Redirect to payment gateway
                    window.location.href = result.paymentUrl;
                } else {
                    // Payment processed successfully
                    this.showSuccess('Payment processed successfully!');
                    setTimeout(() => {
                        window.location.href = `order-confirmation.html?orderId=${this.order._id}`;
                    }, 2000);
                }
            } else {
                throw new Error('Payment processing failed');
            }
        } catch (error) {
            console.error('Error processing payment:', error);
            this.showError('Payment processing failed. Please try again.');
        }
    }

    validateForms() {
        const forms = document.querySelectorAll('form');
        let isValid = true;

        forms.forEach(form => {
            if (!form.checkValidity()) {
                form.reportValidity();
                isValid = false;
            }
        });

        return isValid;
    }

    getShippingData() {
        return {
            firstName: document.getElementById('firstName').value,
            lastName: document.getElementById('lastName').value,
            email: document.getElementById('email').value,
            phone: document.getElementById('phone').value,
            address: document.getElementById('address').value,
            city: document.getElementById('city').value,
            postalCode: document.getElementById('postalCode').value,
            province: document.getElementById('province').value,
            saveAddress: document.getElementById('saveAddress').checked
        };
    }

    getPaymentData() {
        const selectedMethod = document.querySelector('input[name="paymentMethod"]:checked');
        return {
            method: selectedMethod ? selectedMethod.value : 'PayFast'
        };
    }

    updateUI() {
        if (this.order) {
            this.updateOrderSummary();
        }
    }

    updateOrderSummary() {
        document.getElementById('summarySubtotal').textContent = `R${this.order.subtotal.toFixed(2)}`;
        document.getElementById('summaryVat').textContent = `R${this.order.vat.toFixed(2)}`;
        document.getElementById('summaryDelivery').textContent = `R${this.order.deliveryFee.toFixed(2)}`;
        document.getElementById('summaryTotal').textContent = `R${this.order.total.toFixed(2)}`;

        if (this.order.discount) {
            document.getElementById('summaryDiscount').textContent = `-R${this.order.discount.amount.toFixed(2)}`;
            document.querySelector('.summary-line.discount').style.display = 'flex';
        } else {
            document.querySelector('.summary-line.discount').style.display = 'none';
        }
    }

    setupEventListeners() {
        // Payment method selection
        document.querySelectorAll('input[name="paymentMethod"]').forEach(radio => {
            radio.addEventListener('change', (e) => {
                this.paymentMethod = e.target.value;
                this.updatePaymentUI();
            });
        });

        // Form validation
        document.querySelectorAll('input, select').forEach(input => {
            input.addEventListener('blur', () => {
                this.validateField(input);
            });
        });

        // Save address checkbox
        document.getElementById('saveAddress').addEventListener('change', (e) => {
            if (e.target.checked) {
                this.saveUserAddress();
            }
        });
    }

    updatePaymentUI() {
        // Update UI based on selected payment method
        const paymentMethods = document.querySelectorAll('.payment-method');
        paymentMethods.forEach(method => {
            method.classList.remove('selected');
        });

        const selectedMethod = document.querySelector(`input[value="${this.paymentMethod}"]`);
        if (selectedMethod) {
            selectedMethod.closest('.payment-method').classList.add('selected');
        }
    }

    async saveUserAddress() {
        const addressData = this.getShippingData();
        
        try {
            const token = localStorage.getItem('token');
            const response = await fetch(`${API_BASE}/users/address`, {
                method: 'PUT',
                headers: {
                    'Authorization': `Bearer ${token}`,
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    address: {
                        street: addressData.address,
                        city: addressData.city,
                        postalCode: addressData.postalCode,
                        province: addressData.province
                    }
                })
            });

            if (response.ok) {
                this.showNotification('Address saved successfully', 'success');
            }
        } catch (error) {
            console.error('Error saving address:', error);
        }
    }

    validateField(field) {
        if (!field.checkValidity()) {
            field.classList.add('invalid');
        } else {
            field.classList.remove('invalid');
        }
    }

    showError(message) {
        this.showNotification(message, 'error');
    }

    showSuccess(message) {
        this.showNotification(message, 'success');
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
        }, 5000);
    }

    showDemoData() {
        // Demo data for development
        this.order = {
            _id: 'demo123',
            subtotal: 250,
            vat: 37.50,
            deliveryFee: 99,
            total: 386.50,
            items: [
                {
                    product: {
                        images: [{ url: 'https://via.placeholder.com/50' }],
                        name: 'Zulu Beaded Necklace'
                    },
                    name: 'Zulu Beaded Necklace',
                    price: 250,
                    quantity: 1
                }
            ]
        };
        this.updateUI();
    }
}

// Initialize checkout manager
let checkoutManager;

document.addEventListener('DOMContentLoaded', function() {
    checkoutManager = new CheckoutManager();
});

// Global function for payment processing
function processPayment() {
    if (checkoutManager) {
        checkoutManager.processPayment();
    }
}