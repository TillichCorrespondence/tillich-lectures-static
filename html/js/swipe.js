// Swipe Navigation for Touch Devices


document.addEventListener('DOMContentLoaded', function() {
    
    const prevUrl = document.getElementById('prev-url')?.textContent;
    const nextUrl = document.getElementById('next-url')?.textContent;
    
    // Variables to track the touch position
    let touchStartX = 0;  // Where the finger first touched
    let touchEndX = 0;    // Where the finger lifted off
    
    // Minimum distance (in pixels) for a swipe to be recognized
    const minSwipeDistance = 50;    
    
    function handleTouchStart(event) {
        // Get the X coordinate of where the finger touched
        touchStartX = event.changedTouches[0].screenX;
    }    
    
    function handleTouchEnd(event) {
        // Get the X coordinate of where the finger lifted
        touchEndX = event.changedTouches[0].screenX;            

        // Now determine the swipe direction
        handleSwipe();
    }
    
    /**
     * Determines the swipe direction and navigates accordingly
     */
    function handleSwipe() {
        // Calculate how far the finger moved
        const swipeDistance = touchEndX - touchStartX;
        
        // Swipe RIGHT (finger moved from left to right)
        // This means: go to PREVIOUS page
        if (swipeDistance > minSwipeDistance) {
            // Check if there is a previous page to go to
            if (prevUrl && prevUrl.endsWith('.html')) {
                console.log('Swiped right - going to previous page');
                window.location.href = prevUrl;
            }
        }
        
        // Swipe LEFT (finger moved from right to left)
        // This means: go to NEXT page
        else if (swipeDistance < -minSwipeDistance) {
            // Check if there is a next page to go to
            if (nextUrl && nextUrl.endsWith('.html')) {
                console.log('Swiped left - going to next page');
                window.location.href = nextUrl;
            }
        }
        
        // If the distance is less than minSwipeDistance, we ignore it
        // This handles accidental touches or small movements
    }
    
   
    document.addEventListener('touchstart', handleTouchStart, false);
    document.addEventListener('touchend', handleTouchEnd, false);
    
    console.log('Swipe navigation initialized');
});