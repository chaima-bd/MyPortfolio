// Get the button
let goToTopBtn = document.getElementById("goToTopBtn");

// Show the button when the user scrolls down 20px from the top
window.onscroll = function() {
    scrollFunction();
};

function scrollFunction() {
    if (document.body.scrollTop > 20 || document.documentElement.scrollTop > 20) {
        goToTopBtn.style.display = "block";
    } else {
        goToTopBtn.style.display = "none";
    }
}

// Scroll to the top when the button is clicked with a smooth animation
function topFunction() {
    window.scrollTo({
        top: 0,
        behavior: 'smooth' // Smooth scrolling
    });
}
