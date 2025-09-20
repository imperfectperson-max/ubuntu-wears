document.addEventListener('DOMContentLoaded', function() {
            const wrapper = document.querySelector('.wrapper');
            const loginLink = document.querySelector('.register-link');
            const registerLink = document.querySelector('.login-link');
            
            loginLink.addEventListener('click', (e) => {
                e.preventDefault();
                wrapper.classList.add('active');
            });
            
            registerLink.addEventListener('click', (e) => {
                e.preventDefault();
                wrapper.classList.remove('active');
            });

            // Form submissions
            document.getElementById('loginForm').addEventListener('submit', async (e) => {
                e.preventDefault();
                const email = document.getElementById('loginEmail').value;
                const password = document.getElementById('loginPassword').value;
                
                const result = await loginUser(email, password);
                if (result.success) {
                    window.location.href = 'index.html';
                } else {
                    alert('Login failed: ' + result.error);
                }
            });

            document.getElementById('registerForm').addEventListener('submit', async (e) => {
                e.preventDefault();
                const name = document.getElementById('registerName').value;
                const email = document.getElementById('registerEmail').value;
                const password = document.getElementById('registerPassword').value;
                const confirmPassword = document.getElementById('registerConfirmPassword').value;
                const phoneNumber = document.getElementById('registerPhone').value;
                
                if (password !== confirmPassword) {
                    alert('Passwords do not match!');
                    return;
                }
                
                const result = await registerUser({ name, email, password, phoneNumber });
                if (result.success) {
                    window.location.href = 'index.html';
                } else {
                    alert('Registration failed: ' + result.error);
                }
            });

            function handleResponsiveToggle() {
                if (window.innerWidth <= 768) {
                    loginLink.addEventListener('click', (e) => {
                        e.preventDefault();
                        wrapper.classList.add('active');
                    }); 
                    registerLink.addEventListener('click', (e) => { 
                        e.preventDefault();
                        wrapper.classList.remove('active');
                    });
                } else {
                    wrapper.classList.remove('active');
                }
            }
            
            handleResponsiveToggle();
            window.addEventListener('resize', handleResponsiveToggle);
        });