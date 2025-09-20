document.addEventListener('DOMContentLoaded', function () {
    // Mobile menu toggle
    const mobileMenuToggle = document.querySelector('.mobile-menu-toggle');
    const mainNav = document.querySelector('.main-nav');

    mobileMenuToggle.addEventListener('click', function () {
        mainNav.classList.toggle('active');
        this.querySelector('i').classList.toggle('fa-bars');
        this.querySelector('i').classList.toggle('fa-times');
    });

    // Close dropdowns when clicking outside on mobile
    document.addEventListener('click', function (e) {
        if (window.innerWidth <= 992 && !e.target.closest('.main-nav') && !e.target.closest('.mobile-menu-toggle')) {
            mainNav.classList.remove('active');
            mobileMenuToggle.querySelector('i').classList.add('fa-bars');
            mobileMenuToggle.querySelector('i').classList.remove('fa-times');
        }
    });

    // Slider functionality (from previous implementation)
    const slides = document.querySelectorAll('.slide');
    const dots = document.querySelectorAll('.dot');
    const prevBtn = document.querySelector('.prev');
    const nextBtn = document.querySelector('.next');
    let currentSlide = 0;
    const slideCount = slides.length;

    function showSlide(index) {
        slides.forEach(slide => slide.classList.remove('active'));
        dots.forEach(dot => dot.classList.remove('active'));

        slides[index].classList.add('active');
        dots[index].classList.add('active');
        currentSlide = index;
    }

    function nextSlide() {
        currentSlide = (currentSlide + 1) % slideCount;
        showSlide(currentSlide);
    }

    function prevSlide() {
        currentSlide = (currentSlide - 1 + slideCount) % slideCount;
        showSlide(currentSlide);
    }

    nextBtn.addEventListener('click', nextSlide);
    prevBtn.addEventListener('click', prevSlide);

    dots.forEach((dot, index) => {
        dot.addEventListener('click', () => showSlide(index));
    });

    let slideInterval = setInterval(nextSlide, 5000);
    const slider = document.querySelector('.hero-slider');
    slider.addEventListener('mouseenter', () => clearInterval(slideInterval));
    slider.addEventListener('mouseleave', () => {
        slideInterval = setInterval(nextSlide, 5000);
    });

    showSlide(0);
});

document.addEventListener('DOMContentLoaded', function () {
    // Quantity controls
    const quantityControls = document.querySelectorAll('.quantity-controls');

    quantityControls.forEach(control => {
        const minusBtn = control.querySelector('.minus');
        const plusBtn = control.querySelector('.plus');
        const input = control.querySelector('.quantity-input');

        minusBtn.addEventListener('click', () => {
            let value = parseInt(input.value);
            if (value > 1) {
                input.value = value - 1;
            }
        });

        plusBtn.addEventListener('click', () => {
            let value = parseInt(input.value);
            input.value = value + 1;
        });

        input.addEventListener('change', () => {
            if (isNaN(input.value) || input.value < 1) {
                input.value = 1;
            }
        });
    });

    // Remove items
    const removeBtns = document.querySelectorAll('.remove-btn');

    removeBtns.forEach(btn => {
        btn.addEventListener('click', function () {
            this.closest('.offer-item').remove();
            // Here you would update the cart summary
        });
    });

    // Checkbox select
    const checkboxes = document.querySelectorAll('.item-checkbox input');

    checkboxes.forEach(checkbox => {
        checkbox.addEventListener('change', function () {
            // Here you would update the cart summary based on selection
        });
    });
});


function initializeBallAnimation() {
    const balls = document.querySelectorAll('.ball');
    const colorSplash = document.querySelector('.color-splash');
    const centerX = window.innerWidth / 2 - 20; // 20 is half the ball size
    const centerY = window.innerHeight / 2 - 20;

    // Set initial positions outside viewport
    balls.forEach((ball, index) => {
        let startX, startY;

        // Position balls from different directions
        switch (index) {
            case 0: // top left
                startX = -100;
                startY = -100;
                break;
            case 1: // top
                startX = 0;
                startY = -100;
                break;
            case 2: // top right
                startX = window.innerWidth + 100;
                startY = -100;
                break;
            case 3: // right
                startX = window.innerWidth + 100;
                startY = 0;
                break;
            case 4: // bottom right
                startX = window.innerWidth + 100;
                startY = window.innerHeight + 100;
                break;
            case 5: // bottom
                startX = 0;
                startY = window.innerHeight + 100;
                break;
            case 6: // bottom left
                startX = -100;
                startY = window.innerHeight + 100;
                break;
            case 7: // left
                startX = -100;
                startY = 0;
                break;
        }

        // Set CSS custom properties
        ball.style.setProperty('--start-x', `${startX}px`);
        ball.style.setProperty('--start-y', `${startY}px`);

        // Animate ball
        ball.style.animation = `ballEnter 2s ease-out forwards ${index * 0.1}s`;
    });

    // Trigger color splash after all balls arrive
    setTimeout(() => {
        // Get random colors from the balls
        const color1 = getComputedStyle(balls[Math.floor(Math.random() * balls.length)]).backgroundColor;
        const color2 = getComputedStyle(balls[Math.floor(Math.random() * balls.length)]).backgroundColor;

        colorSplash.style.setProperty('--color1', color1);
        colorSplash.style.setProperty('--color2', color2);
        colorSplash.style.animation = 'colorSplash 3s ease-out forwards';

        // Change background color of the page
        document.body.style.background = `linear-gradient(135deg, ${color1}, ${color2})`;
    }, 2000);

    // Reset animation when it completes
    setTimeout(() => {
        balls.forEach(ball => {
            ball.style.animation = 'none';
            void ball.offsetWidth; // Trigger reflow
            ball.style.animation = null;
        });

        colorSplash.style.animation = 'none';
        void colorSplash.offsetWidth;
        colorSplash.style.animation = null;

        // Reinitialize after a delay
        setTimeout(initializeBallAnimation, 5000);
    }, 5000);
}

// Start the animation when page loads
window.addEventListener('load', initializeBallAnimation);

// Reinitialize on resize
window.addEventListener('resize', () => {
    const balls = document.querySelectorAll('.ball');
    balls.forEach(ball => {
        ball.style.animation = 'none';
    });
    document.querySelector('.color-splash').style.animation = 'none';

    setTimeout(initializeBallAnimation, 100);
});