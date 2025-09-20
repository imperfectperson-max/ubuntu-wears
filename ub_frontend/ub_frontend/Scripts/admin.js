// admin.js - Admin specific functionality
const API_BASE = 'http://localhost:5000/api';

// Admin product management
async function getProducts() {
    try {
        const token = localStorage.getItem('token');
        const response = await fetch(`${API_BASE}/products`, {
            headers: {
                'Authorization': `Bearer ${token}`
            }
        });
        
        if (response.ok) {
            return await response.json();
        }
        throw new Error('Failed to fetch products');
    } catch (error) {
        console.error('Error fetching products:', error);
        return [];
    }
}

async function createProduct(productData) {
    try {
        const token = localStorage.getItem('token');
        const response = await fetch(`${API_BASE}/products`, {
            method: 'POST',
            headers: {
                'Authorization': `Bearer ${token}`,
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(productData)
        });
        
        if (response.ok) {
            return await response.json();
        }
        throw new Error('Failed to create product');
    } catch (error) {
        console.error('Error creating product:', error);
        return null;
    }
}

async function updateProduct(productId, productData) {
    try {
        const token = localStorage.getItem('token');
        const response = await fetch(`${API_BASE}/products/${productId}`, {
            method: 'PUT',
            headers: {
                'Authorization': `Bearer ${token}`,
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(productData)
        });
        
        if (response.ok) {
            return await response.json();
        }
        throw new Error('Failed to update product');
    } catch (error) {
        console.error('Error updating product:', error);
        return null;
    }
}

async function deleteProduct(productId) {
    try {
        const token = localStorage.getItem('token');
        const response = await fetch(`${API_BASE}/products/${productId}`, {
            method: 'DELETE',
            headers: {
                'Authorization': `Bearer ${token}`
            }
        });
        
        return response.ok;
    } catch (error) {
        console.error('Error deleting product:', error);
        return false;
    }
}

// Order management
async function getOrders() {
    try {
        const token = localStorage.getItem('token');
        const response = await fetch(`${API_BASE}/orders`, {
            headers: {
                'Authorization': `Bearer ${token}`
            }
        });
        
        if (response.ok) {
            return await response.json();
        }
        throw new Error('Failed to fetch orders');
    } catch (error) {
        console.error('Error fetching orders:', error);
        return [];
    }
}

async function updateOrderStatus(orderId, status) {
    try {
        const token = localStorage.getItem('token');
        const response = await fetch(`${API_BASE}/orders/${orderId}/status`, {
            method: 'PATCH',
            headers: {
                'Authorization': `Bearer ${token}`,
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ status })
        });
        
        return response.ok;
    } catch (error) {
        console.error('Error updating order status:', error);
        return false;
    }
}

// User management
async function getUsers() {
    try {
        const token = localStorage.getItem('token');
        const response = await fetch(`${API_BASE}/users`, {
            headers: {
                'Authorization': `Bearer ${token}`
            }
        });
        
        if (response.ok) {
            return await response.json();
        }
        throw new Error('Failed to fetch users');
    } catch (error) {
        console.error('Error fetching users:', error);
        return [];
    }
}

async function updateUser(userId, userData) {
    try {
        const token = localStorage.getItem('token');
        const response = await fetch(`${API_BASE}/users/${userId}`, {
            method: 'PUT',
            headers: {
                'Authorization': `Bearer ${token}`,
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(userData)
        });
        
        if (response.ok) {
            return await response.json();
        }
        throw new Error('Failed to update user');
    } catch (error) {
        console.error('Error updating user:', error);
        return null;
    }
}

// Reports and analytics
async function getSalesReport(startDate, endDate) {
    try {
        const token = localStorage.getItem('token');
        const response = await fetch(`${API_BASE}/reports/sales?startDate=${startDate}&endDate=${endDate}`, {
            headers: {
                'Authorization': `Bearer ${token}`
            }
        });
        
        if (response.ok) {
            return await response.json();
        }
        throw new Error('Failed to fetch sales report');
    } catch (error) {
        console.error('Error fetching sales report:', error);
        return null;
    }
}

// Admin authentication check
function requireAdminAuth() {
    const { isAuthenticated, user } = checkAuth();
    
    if (!isAuthenticated || user.role !== 'admin') {
        window.location.href = 'admin-login.html';
        return false;
    }
    
    return true;
}

// Initialize admin pages
function initAdminPage() {
    if (!requireAdminAuth()) return;
    
    // Load initial data based on current page
    const path = window.location.hash.substring(1) || 'dashboard';
    loadAdminSection(path);
}

// Load different admin sections
async function loadAdminSection(section) {
    switch (section) {
        case 'products':
            await loadProductsSection();
            break;
        case 'orders':
            await loadOrdersSection();
            break;
        case 'users':
            await loadUsersSection();
            break;
        case 'reports':
            await loadReportsSection();
            break;
        default:
            await loadDashboardSection();
    }
}

// Navigation handler
function setupAdminNavigation() {
    const navLinks = document.querySelectorAll('.admin-sidebar nav a');
    navLinks.forEach(link => {
        link.addEventListener('click', (e) => {
            e.preventDefault();
            const section = link.getAttribute('href').substring(1);
            window.location.hash = section;
            loadAdminSection(section);
            
            // Update active state
            navLinks.forEach(l => l.classList.remove('active'));
            link.classList.add('active');
        });
    });
}

// Initialize on page load
document.addEventListener('DOMContentLoaded', function() {
    initAdminPage();
    setupAdminNavigation();
    
    // Handle hash changes
    window.addEventListener('hashchange', function() {
        const section = window.location.hash.substring(1);
        loadAdminSection(section);
    });
});