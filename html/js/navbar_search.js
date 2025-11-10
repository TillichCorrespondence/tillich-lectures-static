document.addEventListener('DOMContentLoaded', function() {
    const searchForm = document.getElementById('searchForm');
    
    if (searchForm) {
        searchForm.addEventListener('submit', function(event) {
            event.preventDefault();
            
            const searchInput = document.getElementById('searchInput');
            const query = searchInput.value.trim();
            
            if (query) {
                const searchUrl = 'search.html?tillich-lectures[query]=' + 
                    encodeURIComponent(query);
                
                window.location.href = searchUrl;
            }
        });
    }
});