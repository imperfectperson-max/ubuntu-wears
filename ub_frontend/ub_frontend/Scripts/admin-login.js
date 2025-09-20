// admin-login.js - Admin login functionality

document.addEventListener('DOMContentLoaded', function() {
    const adminLoginForm = document.getElementById('adminLoginForm');
    
    if (adminLoginForm) {
        adminLoginForm.addEventListener('submit', async (e) => {
            e.preventDefault();
            
            const email = document.getElementById('adminEmail').value;
            const password = document.getElementById('adminPassword').value;
            
            if (!email || !password) {
                showNotification('Please fill in all fields', 'error');
                return;
            }
            
            try {
                const result = await loginUser(email, password);
                
                if (result.success) {
                    // Check if user is actually an admin
                    if (result.data.user.role === 'admin') {
                        showNotification('Login successful! Redirecting...', 'success');
                        setTimeout(() => {
                            window.location.href = '../admin/admin-dashboard.html';
                        }, 1500);
                    } else {
                        showNotification('Access denied. Admin privileges required.', 'error');
                        logoutUser();
                    }
                } else {
                    showNotification('Login failed: ' + result.error, 'error');
                }
            } catch (error) {
                console.error('Login error:', error);
                showNotification('Login failed. Please try again.', 'error');
            }
        });
    }
    
    // Add loading state to button
    const submitButton = adminLoginForm?.querySelector('button[type="submit"]');
    if (submitButton) {
        const originalText = submitButton.textContent;
        
        adminLoginForm.addEventListener('submit', function() {
            submitButton.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Logging in...';
            submitButton.disabled = true;
        });
        
        // Reset button state if form submission fails
        setTimeout(() => {
            submitButton.textContent = originalText;
            submitButton.disabled = false;
        }, 3000);
    }
});

// Notification function
function showNotification(message, type = 'info') {
    // Remove existing notifications
    const existingNotifications = document.querySelectorAll('.custom-notification');
    existingNotifications.forEach(notification => notification.remove());
    
    const notification = document.createElement('div');
    notification.className = `custom-notification ${type}`;
    notification.innerHTML = `
        <span>${message}</span>
        <button onclick="this.parentElement.remove()">&times;</button>
    `;
    
    // Add styles if not already added
    if (!document.getElementById('notification-styles')) {
        const styles = document.createElement('style');
        styles.id = 'notification-styles';
        styles.textContent = `
            .custom-notification {
                position: fixed;
                top: 20px;
                right: 20px;
                padding: 1rem 1.5rem;
                background: white;
                border-left: 4px solid indigo;
                border-radius: 5px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.15);
                display: flex;
                align-items: center;
                gap: 1rem;
                z-index: 10000;
                animation: slideIn 0.3s ease;
            }
            .custom-notification.success {
                border-left-color: #28a745;
            }
            .custom-notification.error {
                border-left-color: #dc3545;
            }
            .custom-notification button {
                background: none;
                border: none;
                font-size: 1.2rem;
                cursor: pointer;
                color: #666;
            }
            @keyframes slideIn {
                from { transform: translateX(100%); opacity: 0; }
                to { transform: translateX(0); opacity: 1; }
            }
        `;
        document.head.appendChild(styles);
    }
    
    document.body.appendChild(notification);
    
    // Auto-remove after 5 seconds
    setTimeout(() => {
        if (notification.parentElement) {
            notification.remove();
        }
    }, 5000);
}