/* ── LANDING PAGE SCRIPT ──────────────────────────────────────── */
'use strict';

// ── Sticky Nav ──────────────────────────────────────────────────
const nav = document.getElementById('nav');
let lastScrollY = window.scrollY;

window.addEventListener('scroll', () => {
  const scrollY = window.scrollY;
  if (scrollY > 20) {
    nav.classList.add('scrolled');
  } else {
    nav.classList.remove('scrolled');
  }
  lastScrollY = scrollY;
}, { passive: true });

// ── Mobile Hamburger ─────────────────────────────────────────────
const hamburger = document.getElementById('hamburger');
const mobileMenu = document.getElementById('mobileMenu');

hamburger.addEventListener('click', () => {
  const isOpen = mobileMenu.classList.toggle('open');
  hamburger.setAttribute('aria-expanded', isOpen);
  mobileMenu.setAttribute('aria-hidden', !isOpen);
});

// Close mobile menu on link click
mobileMenu.querySelectorAll('a').forEach(link => {
  link.addEventListener('click', () => {
    mobileMenu.classList.remove('open');
    hamburger.setAttribute('aria-expanded', 'false');
    mobileMenu.setAttribute('aria-hidden', 'true');
  });
});

// ── Scroll Reveal ───────────────────────────────────────────────
const revealObserver = new IntersectionObserver((entries) => {
  entries.forEach(entry => {
    if (entry.isIntersecting) {
      entry.target.classList.add('visible');
      revealObserver.unobserve(entry.target);
    }
  });
}, {
  threshold: 0.12,
  rootMargin: '0px 0px -40px 0px'
});

document.querySelectorAll('.reveal').forEach(el => {
  revealObserver.observe(el);
});

// ── Animated Counter ─────────────────────────────────────────────
function animateCounter(el) {
  const target = parseInt(el.dataset.target, 10);
  const duration = 1800;
  const startTime = performance.now();

  function update(now) {
    const elapsed = now - startTime;
    const progress = Math.min(elapsed / duration, 1);
    // Ease out cubic
    const eased = 1 - Math.pow(1 - progress, 3);
    const current = Math.round(eased * target);
    el.textContent = current.toLocaleString('en-IN');
    if (progress < 1) {
      requestAnimationFrame(update);
    }
  }
  requestAnimationFrame(update);
}

const counterObserver = new IntersectionObserver((entries) => {
  entries.forEach(entry => {
    if (entry.isIntersecting) {
      const num = entry.target.querySelector('.impact-stat__num');
      if (num && !num.dataset.animated) {
        num.dataset.animated = 'true';
        animateCounter(num);
      }
    }
  });
}, { threshold: 0.5 });

document.querySelectorAll('.impact-stat').forEach(el => {
  counterObserver.observe(el);
});

// ── Smooth active nav link highlighting ─────────────────────────
const sections = document.querySelectorAll('section[id]');
const navLinks = document.querySelectorAll('.nav__links a');

const sectionObserver = new IntersectionObserver((entries) => {
  entries.forEach(entry => {
    if (entry.isIntersecting) {
      const id = entry.target.getAttribute('id');
      navLinks.forEach(link => {
        link.style.color = '';
        link.style.background = '';
        if (link.getAttribute('href') === `#${id}`) {
          link.style.color = 'var(--green-600)';
          link.style.background = 'rgba(16,185,129,.08)';
        }
      });
    }
  });
}, { threshold: 0.4 });

sections.forEach(s => sectionObserver.observe(s));

// ── Parallax orbs on hero ────────────────────────────────────────
const heroOrbs = document.querySelectorAll('.hero .orb');
window.addEventListener('mousemove', (e) => {
  const x = (e.clientX / window.innerWidth - 0.5) * 30;
  const y = (e.clientY / window.innerHeight - 0.5) * 30;

  heroOrbs.forEach((orb, i) => {
    const factor = (i + 1) * 0.4;
    orb.style.transform = `translate(${x * factor}px, ${y * factor}px)`;
  });
}, { passive: true });

// ── Store buttons tooltip ────────────────────────────────────────
document.getElementById('playstore-btn').addEventListener('click', (e) => {
  e.preventDefault();
  showToast('🚀 Google Play coming soon!');
});
document.getElementById('appstore-btn').addEventListener('click', (e) => {
  e.preventDefault();
  showToast('🍎 App Store coming soon!');
});

function showToast(message) {
  let toast = document.getElementById('toast');
  if (!toast) {
    toast = document.createElement('div');
    toast.id = 'toast';
    toast.style.cssText = `
      position: fixed;
      bottom: 32px;
      left: 50%;
      transform: translateX(-50%) translateY(20px);
      background: #1e293b;
      color: white;
      padding: 12px 24px;
      border-radius: 999px;
      font-size: .9rem;
      font-weight: 600;
      font-family: 'Inter', sans-serif;
      box-shadow: 0 8px 32px rgba(0,0,0,.3);
      z-index: 9999;
      opacity: 0;
      transition: opacity .3s, transform .3s;
      border: 1px solid rgba(255,255,255,.1);
      white-space: nowrap;
    `;
    document.body.appendChild(toast);
  }
  toast.textContent = message;
  requestAnimationFrame(() => {
    toast.style.opacity = '1';
    toast.style.transform = 'translateX(-50%) translateY(0)';
  });
  setTimeout(() => {
    toast.style.opacity = '0';
    toast.style.transform = 'translateX(-50%) translateY(20px)';
  }, 2800);
}

// ── Feature card stagger on hover ───────────────────────────────
document.querySelectorAll('.feature-card').forEach(card => {
  card.addEventListener('mouseenter', () => {
    card.style.transition = 'all 0.22s cubic-bezier(.4,0,.2,1)';
  });
  card.addEventListener('mouseleave', () => {
    card.style.transition = 'all 0.28s cubic-bezier(.4,0,.2,1)';
  });
});

// ── Trigger reveal for elements already visible on load ──────────
window.addEventListener('load', () => {
  document.querySelectorAll('.reveal').forEach(el => {
    const rect = el.getBoundingClientRect();
    if (rect.top < window.innerHeight * 0.9) {
      el.classList.add('visible');
    }
  });
});

console.log('%c♻ EcoHabit Landing Page', 'color:#10b981;font-size:1.2rem;font-weight:bold');
console.log('%cContributed by Chandrika18', 'color:#94a3b8;font-size:.9rem');
