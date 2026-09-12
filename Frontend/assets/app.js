// ---------- Shared data ----------
const PLACES = [
  {
    id: 1,
    name: "Sebastia",
    city: "Nablus",
    type: "Historical",
    score: 92,
    image: "https://images.unsplash.com/photo-1544198365-f5d60b6d8190?q=80&w=1200&auto=format&fit=crop",
    description: "Ancient ruins of the Roman city of Samaria-Sebaste, featuring a well-preserved theater, temple, and colonnaded street overlooking olive groves."
  },
  {
    id: 2,
    name: "Wadi Qelt",
    city: "Jericho",
    type: "Nature",
    score: 88,
    image: "https://images.unsplash.com/photo-1509316785289-025f5b846b35?q=80&w=1200&auto=format&fit=crop",
    description: "A dramatic desert canyon with a monastery carved into the cliffside, popular for hiking trails and stunning valley views."
  },
  {
    id: 3,
    name: "Church of the Nativity",
    city: "Bethlehem",
    type: "Historical",
    score: 95,
    image: "https://images.unsplash.com/photo-1548013146-72479768bada?q=80&w=1200&auto=format&fit=crop",
    description: "One of the oldest working churches in the world, built over the traditional site of the birth of Jesus, with mosaics dating back centuries."
  },
  {
    id: 4,
    name: "Old City Ramparts",
    city: "Jerusalem",
    type: "Family",
    score: 84,
    image: "https://images.unsplash.com/photo-1552423314-cf29ab68ad73?q=80&w=1200&auto=format&fit=crop",
    description: "Walk the ancient city walls for panoramic views over the Old City, its markets, domes, and rooftops, a great outing for all ages."
  },
  {
    id: 5,
    name: "Hisham's Palace",
    city: "Jericho",
    type: "Historical",
    score: 90,
    image: "https://images.unsplash.com/photo-1583417319070-4a69db38a482?q=80&w=1200&auto=format&fit=crop",
    description: "Umayyad-era palace ruins famous for their intricate mosaic floor, considered one of the finest surviving examples in the region."
  },
  {
    id: 6,
    name: "Battir Terraces",
    city: "Bethlehem",
    type: "Nature",
    score: 86,
    image: "https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?q=80&w=1200&auto=format&fit=crop",
    description: "UNESCO-listed ancient irrigated terraces still farmed today, with gentle walking trails and panoramic valley viewpoints."
  }
];

// ---------- Shared UI wiring ----------
document.addEventListener('DOMContentLoaded', () => {
  const menuBtn = document.getElementById('menuBtn');
  const navLinks = document.getElementById('navLinks');
  if (menuBtn && navLinks) {
    menuBtn.addEventListener('click', (e) => {
      e.stopPropagation();
      navLinks.classList.toggle('open');
    });
    navLinks.querySelectorAll('a').forEach(a =>
      a.addEventListener('click', () => navLinks.classList.remove('open'))
    );
    document.addEventListener('click', (e) => {
      if (navLinks.classList.contains('open') && !navLinks.contains(e.target) && e.target !== menuBtn) {
        navLinks.classList.remove('open');
      }
    });
    document.addEventListener('keydown', (e) => {
      if (e.key === 'Escape') navLinks.classList.remove('open');
    });
  }

  const current = document.body.getAttribute('data-page');
  if (current) {
    document.querySelectorAll('.nav-links a[data-page]').forEach(a => {
      const isActive = a.getAttribute('data-page') === current;
      a.classList.toggle('active', isActive);
      if (isActive) a.setAttribute('aria-current', 'page');
    });
  }
});

function handleImageError(imgEl) {
  imgEl.classList.add('img-error');
  const parentThumb = imgEl.closest('.thumb');
  if (parentThumb) parentThumb.classList.add('img-error');
}

// ---------- Snackbar ----------
let toastTimer;
function toast(msg) {
  let el = document.getElementById('snackbar');
  if (!el) {
    el = document.createElement('div');
    el.id = 'snackbar';
    document.body.appendChild(el);
  }
  el.textContent = msg;
  el.classList.add('show');
  clearTimeout(toastTimer);
  toastTimer = setTimeout(() => el.classList.remove('show'), 2200);
}

// ---------- Match overlay ----------
function showMatchOverlay(message, onDone) {
  let el = document.getElementById('matchOverlay');
  if (!el) {
    el = document.createElement('div');
    el.id = 'matchOverlay';
    el.className = 'match-overlay';
    el.innerHTML = '<div class="spinner"></div><p></p>';
    document.body.appendChild(el);
  }
  el.querySelector('p').textContent = message;
  requestAnimationFrame(() => el.classList.add('show'));
  setTimeout(onDone, 700);
}

// ---------- Helpers ----------
function getQueryParam(name) {
  return new URLSearchParams(window.location.search).get(name);
}

function savePreferences(prefs) {
  sessionStorage.setItem('travelPreferences', JSON.stringify(prefs));
}

function loadPreferences() {
  try {
    return JSON.parse(sessionStorage.getItem('travelPreferences')) || null;
  } catch (e) {
    return null;
  }
}
