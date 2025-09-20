// auth.js - Authentication functions
const API_BASE = 'http://localhost:5000/api';

// Check if user is logged in
function checkAuth() {
    const token = localStorage.getItem('token');
    const user = JSON.parse(localStorage.getItem('user'));
    
    return { isAuthenticated: !!token, user };
}

// Login function
async function loginUser(email, password) {
    try {
        const response = await fetch(`${API_BASE}/auth/login`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ email, password })
        });
        
        const data = await response.json();
        
        if (response.ok) {
            localStorage.setItem('token', data.token);
            localStorage.setItem('user', JSON.stringify(data.user));
            return { success: true, data };
        } else {
            return { success: false, error: data.msg || 'Login failed' };
        }
    } catch (error) {
        return { success: false, error: 'Network error. Please try again.' };
    }
}

// Register function
async function registerUser(userData) {
    try {
        const response = await fetch(`${API_BASE}/auth/register`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(userData)
        });
        
        const data = await response.json();
        
        if (response.ok) {
            localStorage.setItem('token', data.token);
            localStorage.setItem('user', JSON.stringify(data.user));
            return { success: true, data };
        } else {
            return { success: false, error: data.msg || 'Registration failed' };
        }
    } catch (error) {
        return { success: false, error: 'Network error. Please try again.' };
    }
}

// Logout function
function logoutUser() {
    localStorage.removeItem('token');
    localStorage.removeItem('user');
    localStorage.removeItem('userRole');
    window.location.href = 'index.html';
}

// Show/hide content based on authentication
function updateUIForAuth() {
    const { isAuthenticated, user } = checkAuth();
    
    // Update header buttons
    const authButtons = document.querySelector('.user-actions');
    if (authButtons) {
        if (isAuthenticated) {
            authButtons.innerHTML = `
                <a href="profile.html"><i class="fas fa-user"></i>${user.name}</a>
                <a href="#" onclick="logoutUser()"><i class="fas fa-sign-out-alt"></i>Logout</a>
                <a href="wishlist.html"><i class="fas fa-heart"></i>Wishlist</a>
                <a href="cart.html"><i class="fas fa-shopping-cart"></i>Cart</a>
            `;
        } else {
            authButtons.innerHTML = `
                <a href="login.html"><i class="fas fa-user"></i>Sign In</a>
                <a href="#"><i class="fas fa-box"></i>Orders</a>
                <a href="#"><i class="fas fa-heart"></i>Wishlist</a>
                <a href="cart.html"><i class="fas fa-shopping-cart"></i>Cart</a>
            `;
        }
    }
    
    // Show/hide protected content
    document.querySelectorAll('.auth-only').forEach(el => {
        el.style.display = isAuthenticated ? 'block' : 'none';
    });
    
    document.querySelectorAll('.guest-only').forEach(el => {
        el.style.display = isAuthenticated ? 'none' : 'block';
    });
}