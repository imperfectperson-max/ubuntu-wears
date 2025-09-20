 function selectRole(role) {
            localStorage.setItem('userRole', role);
            if (role === 'admin') {
                window.location.href = '../admin/admin-login.html';
            }
            else if (role === 'client') {
                window.location.href = '../login/login.html';
            } 
            else {
                window.location.href = 'index.html';
            }
        }

        // Check if user is already logged in
        document.addEventListener('DOMContentLoaded', function() {
            const token = localStorage.getItem('token');
            if (token) {
                window.location.href = 'index.html';
            }
        });
