// Tema claro/escuro
function toggleTheme() {
  const body = document.body;
  const icon = document.querySelector('.theme-toggle');
  if (body.classList.contains('light')) {
    body.classList.remove('light');
    icon.textContent = '🌙';
  } else {
    body.classList.add('light');
    icon.textContent = '☀️';
  }
}

// Animação suave ao rolar
const cards = document.querySelectorAll('.card');
const observer = new IntersectionObserver((entries) => {
  entries.forEach(entry => {
    if (entry.isIntersecting) {
      entry.target.style.opacity = 1;
      entry.target.style.transform = 'translateY(0)';
    }
  });
}, { threshold: 0.2 });

cards.forEach(card => {
  card.style.opacity = 0;
  card.style.transform = 'translateY(20px)';
  card.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
  observer.observe(card);
});
