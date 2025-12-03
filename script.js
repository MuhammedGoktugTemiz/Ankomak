// Resim galerisi fonksiyonları
        const thumbnails = document.querySelectorAll('.thumbnail');
        const mainImage = document.getElementById('mainImage');
        const images = [



            'img/Makinalar/donutmakinesi.jpg',
            'img/Makinalar/donut/5.jpg',
            'img/Makinalar/donut/2.jpg',
            'img/Makinalar/donut/3.jpg',
            'img/Makinalar/donut/4.jpg',
            
        ];
        let currentImageIndex = 0;

        function changeMainImage(src, thumbnail) {
            mainImage.src = src;
            currentImageIndex = images.indexOf(src);
            
            // Aktif thumbnail'i güncelle
            thumbnails.forEach(t => t.classList.remove('active'));
            thumbnail.classList.add('active');
        }

        // Lightbox fonksiyonları
        function openLightbox(src) {
            const lightboxModal = document.getElementById('lightboxModal');
            const lightboxImage = document.getElementById('lightboxImage');
            
            lightboxImage.src = src;
            lightboxModal.style.display = 'block';
            document.body.style.overflow = 'hidden';
        }

        function closeLightbox() {
            const lightboxModal = document.getElementById('lightboxModal');
            lightboxModal.style.display = 'none';
            document.body.style.overflow = 'auto';
        }

        function changeLightboxImage(direction) {
            currentImageIndex += direction;
            
            // Döngüsel geçiş
            if (currentImageIndex >= images.length) {
                currentImageIndex = 0;
            } else if (currentImageIndex < 0) {
                currentImageIndex = images.length - 1;
            }
            
            document.getElementById('lightboxImage').src = images[currentImageIndex];
            
            // Ana resmi ve thumbnail'i güncelle
            mainImage.src = images[currentImageIndex];
            thumbnails.forEach(t => t.classList.remove('active'));
            thumbnails[currentImageIndex].classList.add('active');
        }

        // Klavye kontrolü
        document.addEventListener('keydown', function(event) {
            const lightboxModal = document.getElementById('lightboxModal');
            
            if (lightboxModal.style.display === 'block') {
                if (event.key === 'Escape') {
                    closeLightbox();
                } else if (event.key === 'ArrowLeft') {
                    changeLightboxImage(-1);
                } else if (event.key === 'ArrowRight') {
                    changeLightboxImage(1);
                }
            }
        });

        // Mobil menü fonksiyonları
        const menuButton = document.getElementById('menuButton');
        const mobileMenu = document.getElementById('mobileMenu');
        const closeMenu = document.getElementById('closeMenu');
        
        menuButton.addEventListener('click', () => {
            mobileMenu.classList.toggle('hidden');
        });
        
        closeMenu.addEventListener('click', () => {
            mobileMenu.classList.add('hidden');
        });