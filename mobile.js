// ========================================
// ANKOMAK - ENHANCED MOBILE FUNCTIONALITY
// Modern Mobile-First JavaScript
// ========================================

document.addEventListener('DOMContentLoaded', function() {
  // ========================================
  // MOBILE MENU SYSTEM
  // ========================================
  
  const navbar = document.getElementById("navbar");
  const menuButton = document.getElementById("menuButton");
  const mobileMenu = document.getElementById("mobileMenu");
  const closeMenu = document.getElementById("closeMenu");
  
  // Navbar scroll effect with enhanced mobile support
  if (navbar) {
    let lastScrollY = window.scrollY;
    let ticking = false;

    function updateNavbar() {
      const scrollY = window.scrollY;
      
      if (scrollY > 50) {
        navbar.classList.add("scrolled");
      } else {
        navbar.classList.remove("scrolled");
      }

      // Hide navbar on scroll down, show on scroll up (mobile only)
      if (window.innerWidth <= 768) {
        if (scrollY > lastScrollY && scrollY > 100) {
          navbar.style.transform = 'translateY(-100%)';
        } else {
          navbar.style.transform = 'translateY(0)';
        }
      }

      lastScrollY = scrollY;
      ticking = false;
    }

    function requestTick() {
      if (!ticking) {
        requestAnimationFrame(updateNavbar);
        ticking = true;
      }
    }

    window.addEventListener("scroll", requestTick, { passive: true });
  }

  // Enhanced mobile menu functionality
  function createBackdrop() {
    // Eğer backdrop zaten varsa, yeniden oluşturma
    let backdrop = document.querySelector('.mobile-menu-backdrop');
    
    if (!backdrop) {
      backdrop = document.createElement('div');
      backdrop.className = 'mobile-menu-backdrop';
      backdrop.style.opacity = '0';
      // Backdrop'i mobil menüden önce ekle (z-index için)
      if (mobileMenu && mobileMenu.parentNode) {
        mobileMenu.parentNode.insertBefore(backdrop, mobileMenu);
      } else {
        document.body.appendChild(backdrop);
      }
    }
    
    // Animate backdrop in
    requestAnimationFrame(() => {
      backdrop.style.opacity = '1';
    });
    
    return backdrop;
  }

  function removeBackdrop() {
    const backdrop = document.querySelector('.mobile-menu-backdrop');
    if (backdrop) {
      backdrop.style.opacity = '0';
      setTimeout(() => {
        if (backdrop.parentNode) {
          backdrop.parentNode.removeChild(backdrop);
        }
      }, 300);
    }
  }

  function openMobileMenu() {
    if (mobileMenu) {
      // Prevent body scroll
      document.body.style.overflow = 'hidden';
      document.body.style.position = 'fixed';
      document.body.style.width = '100%';
      document.body.classList.add('mobile-menu-open');
      
      // Show menu
      mobileMenu.classList.remove("hidden");
      mobileMenu.classList.add("flex");
      
      // Create backdrop (sadece mobil menünün arkasında)
      const backdrop = createBackdrop();
      
      // Backdrop'e tıklanınca menüyü kapat
      backdrop.addEventListener('touchstart', (e) => {
        e.preventDefault();
        closeMobileMenu();
      }, { passive: false });
      
      backdrop.addEventListener('click', (e) => {
        e.preventDefault();
        closeMobileMenu();
      });
      
      // Add escape key listener
      document.addEventListener('keydown', handleEscapeKey);
      
      // Focus management
      const firstLink = mobileMenu.querySelector('a');
      if (firstLink) {
        setTimeout(() => firstLink.focus(), 100);
      }
    }
  }

  function closeMobileMenu() {
    if (mobileMenu) {
      // Restore body scroll
      document.body.style.overflow = '';
      document.body.style.position = '';
      document.body.style.width = '';
      document.body.classList.remove('mobile-menu-open');
      
      // Hide menu
      mobileMenu.classList.add("hidden");
      mobileMenu.classList.remove("flex");
      
      // Remove backdrop
      removeBackdrop();
      
      // Remove escape key listener
      document.removeEventListener('keydown', handleEscapeKey);
      
      // Return focus to menu button
      if (menuButton) {
        setTimeout(() => menuButton.focus(), 100);
      }
    }
  }

  function handleEscapeKey(e) {
    if (e.key === 'Escape') {
      closeMobileMenu();
    }
  }

  // Event listeners for mobile menu
  if (menuButton && mobileMenu && closeMenu) {
    menuButton.addEventListener("click", openMobileMenu);
    closeMenu.addEventListener("click", closeMobileMenu);

    // Close menu when clicking on links
    const mobileMenuLinks = mobileMenu.querySelectorAll('a');
    mobileMenuLinks.forEach(link => {
      link.addEventListener('click', () => {
        setTimeout(closeMobileMenu, 150);
      });
    });

    // Touch gestures for mobile menu
    let startY = 0;
    let currentY = 0;
    let isDragging = false;

    mobileMenu.addEventListener('touchstart', (e) => {
      startY = e.touches[0].clientY;
      isDragging = true;
    }, { passive: true });

    mobileMenu.addEventListener('touchmove', (e) => {
      if (!isDragging) return;
      
      currentY = e.touches[0].clientY;
      const diff = startY - currentY;
      
      // If swiping down more than 100px, close menu
      if (diff < -100) {
        closeMobileMenu();
        isDragging = false;
      }
    }, { passive: true });

    mobileMenu.addEventListener('touchend', () => {
      isDragging = false;
    }, { passive: true });
  }

  // ========================================
  // MOBILE DROPDOWN FUNCTIONALITY
  // ========================================
  
  function toggleMobileDropdown(id, btn) {
    const submenu = document.getElementById(id);
    const arrow = btn.querySelector(".arrow");
    
    if (submenu && arrow) {
      const isHidden = submenu.classList.contains('hidden');
      
      // Close all other dropdowns
      document.querySelectorAll('.mobile-submenu > div').forEach(menu => {
        if (menu.id !== id) {
          menu.classList.add('hidden');
          const otherArrow = menu.previousElementSibling?.querySelector('.arrow');
          if (otherArrow) {
            otherArrow.classList.remove('rotate-180');
          }
        }
      });
      
      // Toggle current dropdown
      submenu.classList.toggle('hidden');
      arrow.classList.toggle('rotate-180');
      
      // Smooth animation
      if (!isHidden) {
        submenu.style.maxHeight = '0';
        submenu.style.overflow = 'hidden';
        submenu.style.transition = 'max-height 0.3s ease';
        
        setTimeout(() => {
          submenu.style.maxHeight = submenu.scrollHeight + 'px';
        }, 10);
      } else {
        submenu.style.maxHeight = submenu.scrollHeight + 'px';
        submenu.style.overflow = 'hidden';
        submenu.style.transition = 'max-height 0.3s ease';
        
        setTimeout(() => {
          submenu.style.maxHeight = '0';
        }, 10);
      }
    }
  }

  // Make toggleMobileDropdown globally available
  window.toggleMobileDropdown = toggleMobileDropdown;

  // ========================================
  // ACTIVE PAGE HIGHLIGHTING
  // ========================================
  
  function setActivePage() {
    const currentPath = window.location.pathname;
    const navLinks = document.querySelectorAll('.navbar ul li a, .mobile-menu-link');
    
    navLinks.forEach(link => {
      link.classList.remove('active');
      const href = link.getAttribute('href');
      
      if (href === currentPath || 
          (currentPath.endsWith('/') && href === 'index.html') ||
          (currentPath.includes(href.replace('.html', '')))) {
        link.classList.add('active');
      }
    });
  }

  setActivePage();

  // ========================================
  // ENHANCED BANNER SLIDER
  // ========================================
  
  const slides = document.querySelectorAll('.banner-slide');
  const dots = document.querySelectorAll('.slider-dot');
  const prevArrow = document.querySelector('.slider-arrow.prev');
  const nextArrow = document.querySelector('.slider-arrow.next');
  
  if (slides.length > 0) {
    let currentSlide = 0;
    const slideInterval = 5000;
    let slideTimer;
    let isUserInteracting = false;
    
    function goToSlide(n) {
      slides[currentSlide].classList.remove('active');
      if (dots[currentSlide]) {
      dots[currentSlide].classList.remove('active');
      }
      
      currentSlide = (n + slides.length) % slides.length;
      
      slides[currentSlide].classList.add('active');
      if (dots[currentSlide]) {
      dots[currentSlide].classList.add('active');
      }
    }
    
    function nextSlide() {
      goToSlide(currentSlide + 1);
    }
    
    function prevSlide() {
      goToSlide(currentSlide - 1);
    }
    
    function startSlider() {
      if (!isUserInteracting) {
      slideTimer = setInterval(nextSlide, slideInterval);
      }
    }
    
    function stopSlider() {
      clearInterval(slideTimer);
    }
    
    // Start slider
    startSlider();
    
    // Dot navigation
    dots.forEach((dot, index) => {
      dot.addEventListener('click', () => {
        isUserInteracting = true;
        stopSlider();
        goToSlide(index);
        setTimeout(() => {
          isUserInteracting = false;
        startSlider();
        }, 3000);
      });
    });
    
    // Arrow navigation
    if (nextArrow) {
      nextArrow.addEventListener('click', () => {
        isUserInteracting = true;
        stopSlider();
        nextSlide();
        setTimeout(() => {
          isUserInteracting = false;
        startSlider();
        }, 3000);
      });
    }
    
    if (prevArrow) {
      prevArrow.addEventListener('click', () => {
        isUserInteracting = true;
        stopSlider();
        prevSlide();
        setTimeout(() => {
          isUserInteracting = false;
        startSlider();
        }, 3000);
      });
    }
    
    // Touch/swipe support for mobile
    const banner = document.querySelector('.banner');
    if (banner && window.innerWidth <= 768) {
      let startX = 0;
      let startY = 0;
      let isSwipe = false;
      
      banner.addEventListener('touchstart', (e) => {
        startX = e.touches[0].clientX;
        startY = e.touches[0].clientY;
        isSwipe = false;
      }, { passive: true });
      
      banner.addEventListener('touchmove', (e) => {
        if (!isSwipe) {
          const deltaX = Math.abs(e.touches[0].clientX - startX);
          const deltaY = Math.abs(e.touches[0].clientY - startY);
          isSwipe = deltaX > deltaY && deltaX > 50;
        }
      }, { passive: true });
      
      banner.addEventListener('touchend', (e) => {
        if (isSwipe) {
          const deltaX = e.changedTouches[0].clientX - startX;
          
          if (Math.abs(deltaX) > 50) {
            isUserInteracting = true;
            stopSlider();
            
            if (deltaX > 0) {
              prevSlide();
            } else {
              nextSlide();
            }
            
            setTimeout(() => {
              isUserInteracting = false;
              startSlider();
            }, 3000);
          }
        }
      }, { passive: true });
    }
    
    // Pause on hover (desktop only)
    if (banner && window.innerWidth > 768) {
      banner.addEventListener('mouseenter', stopSlider);
      banner.addEventListener('mouseleave', startSlider);
    }
  }

  // ========================================
  // MOBILE MACHINE SLIDER
  // ========================================
  
  const machineSlider = document.getElementById('machineSlider');
  const prevBtn = document.getElementById('prevBtn');
  const nextBtn = document.getElementById('nextBtn');
  
  if (machineSlider) {
    const cardWidth = 320;
    const gap = 24;
    const scrollAmount = cardWidth + gap;
    
    // Touch scroll for mobile
    if (window.innerWidth <= 768) {
      let isScrolling = false;
      let startX = 0;
      let scrollLeft = 0;
      
      machineSlider.addEventListener('touchstart', (e) => {
        isScrolling = true;
        startX = e.touches[0].pageX - machineSlider.offsetLeft;
        scrollLeft = machineSlider.scrollLeft;
      }, { passive: true });
      
      machineSlider.addEventListener('touchmove', (e) => {
        if (!isScrolling) return;
        e.preventDefault();
        const x = e.touches[0].pageX - machineSlider.offsetLeft;
        const walk = (x - startX) * 2;
        machineSlider.scrollLeft = scrollLeft - walk;
      });
      
      machineSlider.addEventListener('touchend', () => {
        isScrolling = false;
      }, { passive: true });
    }
    
    // Button navigation (desktop)
    if (prevBtn && nextBtn) {
      prevBtn.addEventListener('click', () => {
        machineSlider.scrollBy({
          left: -scrollAmount,
          behavior: 'smooth'
        });
      });
      
      nextBtn.addEventListener('click', () => {
        machineSlider.scrollBy({
          left: scrollAmount,
          behavior: 'smooth'
        });
      });
    }
    
    // Auto-scroll functionality
    let autoScroll = setInterval(() => {
      if (machineSlider.scrollLeft >= machineSlider.scrollWidth - machineSlider.clientWidth) {
        machineSlider.scrollTo({
          left: 0,
          behavior: 'smooth'
        });
      } else {
        machineSlider.scrollBy({
          left: scrollAmount,
          behavior: 'smooth'
        });
      }
    }, 4000);
    
    // Pause auto-scroll on interaction
    machineSlider.addEventListener('mouseenter', () => {
      clearInterval(autoScroll);
    });
    
    machineSlider.addEventListener('mouseleave', () => {
      autoScroll = setInterval(() => {
        if (machineSlider.scrollLeft >= machineSlider.scrollWidth - machineSlider.clientWidth) {
          machineSlider.scrollTo({
            left: 0,
            behavior: 'smooth'
          });
        } else {
          machineSlider.scrollBy({
            left: scrollAmount,
            behavior: 'smooth'
          });
        }
      }, 4000);
    });
  }

  // ========================================
  // MOBILE OPTIMIZATIONS
  // ========================================
  
  // Lazy loading for images
  if ('IntersectionObserver' in window) {
    const imageObserver = new IntersectionObserver((entries, observer) => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          const img = entry.target;
          img.src = img.dataset.src;
          img.classList.remove('lazy');
          observer.unobserve(img);
        }
      });
    });
    
    document.querySelectorAll('img[data-src]').forEach(img => {
      imageObserver.observe(img);
    });
  }
  
  // Smooth scrolling for anchor links
  document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
      e.preventDefault();
      const target = document.querySelector(this.getAttribute('href'));
      if (target) {
        target.scrollIntoView({
          behavior: 'smooth',
          block: 'start'
        });
      }
    });
  });
  
  // Touch feedback for interactive elements
  document.querySelectorAll('.machine-card, .button, .btn').forEach(element => {
    element.addEventListener('touchstart', function() {
      this.style.transform = 'scale(0.98)';
    }, { passive: true });
    
    element.addEventListener('touchend', function() {
      this.style.transform = '';
    }, { passive: true });
  });
  
  // ========================================
  // PERFORMANCE OPTIMIZATIONS
  // ========================================
  
  // Debounce resize events
  let resizeTimeout;
  window.addEventListener('resize', () => {
    clearTimeout(resizeTimeout);
    resizeTimeout = setTimeout(() => {
      // Recalculate slider positions if needed
      if (machineSlider) {
        machineSlider.scrollLeft = 0;
      }
    }, 250);
  });
  
  // Preload critical images
  const criticalImages = [
    'img/anko_logo.png',
    'img/arkaplan/KAYAN1.jpeg'
  ];
  
  criticalImages.forEach(src => {
    const img = new Image();
    img.src = src;
  });
  
  // ========================================
  // ACCESSIBILITY ENHANCEMENTS
  // ========================================
  
  // Keyboard navigation for mobile menu
  if (mobileMenu) {
    mobileMenu.addEventListener('keydown', (e) => {
      const links = Array.from(mobileMenu.querySelectorAll('a, button'));
      const currentIndex = links.indexOf(document.activeElement);
      
      switch(e.key) {
        case 'ArrowDown':
          e.preventDefault();
          const nextIndex = (currentIndex + 1) % links.length;
          links[nextIndex].focus();
          break;
        case 'ArrowUp':
          e.preventDefault();
          const prevIndex = currentIndex === 0 ? links.length - 1 : currentIndex - 1;
          links[prevIndex].focus();
          break;
        case 'Home':
          e.preventDefault();
          links[0].focus();
          break;
        case 'End':
          e.preventDefault();
          links[links.length - 1].focus();
          break;
      }
    });
  }
  
  // Focus management for modals
  document.querySelectorAll('.modal, .image-modal').forEach(modal => {
    modal.addEventListener('keydown', (e) => {
      if (e.key === 'Escape') {
        const closeBtn = modal.querySelector('.close, .close-modal');
        if (closeBtn) {
          closeBtn.click();
        }
      }
    });
  });
  
  // ========================================
  // ANALYTICS & TRACKING
  // ========================================
  
  // Track mobile menu usage
  if (menuButton) {
    menuButton.addEventListener('click', () => {
      // Analytics tracking could go here
      console.log('Mobile menu opened');
    });
  }
  
  // Track machine card clicks
  document.querySelectorAll('.machine-card').forEach(card => {
    card.addEventListener('click', () => {
      const machineName = card.querySelector('h3')?.textContent || 'Unknown';
      console.log(`Machine clicked: ${machineName}`);
    });
  });
  
  console.log('ANKOMAK Mobile functionality loaded successfully');
});

// ========================================
// UTILITY FUNCTIONS
// ========================================

// Check if device is mobile
function isMobile() {
  return window.innerWidth <= 768 || /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent);
}

// Smooth scroll to element
function smoothScrollTo(element, offset = 0) {
  const targetPosition = element.offsetTop - offset;
  window.scrollTo({
    top: targetPosition,
    behavior: 'smooth'
  });
}

// Format phone number for mobile
function formatPhoneNumber(phone) {
  const cleaned = phone.replace(/\D/g, '');
  const match = cleaned.match(/^(\d{3})(\d{3})(\d{4})$/);
  if (match) {
    return '(' + match[1] + ') ' + match[2] + '-' + match[3];
  }
  return phone;
}

// Make utility functions globally available
window.isMobile = isMobile;
window.smoothScrollTo = smoothScrollTo;
window.formatPhoneNumber = formatPhoneNumber;