// ---------- API config ----------
const API_BASE_URL = 'http://localhost:5286'; // لازم يطابق البورت يلي شغال عليه الباك اند

async function postRecommendations(payload) {
  let response;
  try {
    response = await fetch(`${API_BASE_URL}/api/recommendations`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(payload)
    });
  } catch (networkErr) {
    throw new Error('تعذر الاتصال بالسيرفر. تأكد إنه شغال وحاول مرة ثانية.');
  }

  if (!response.ok) {
    let message = 'حدث خطأ أثناء جلب النتائج. حاول مرة ثانية.';
    if (response.status === 400) message = 'بيانات التفضيلات غير صحيحة.';
    else if (response.status === 404) message = 'لا توجد أماكن متاحة حاليًا بقاعدة البيانات.';
    else if (response.status >= 500) message = 'في مشكلة بالسيرفر، جرب بعد شوي.';
    throw new Error(message);
  }

  return response.json();
}

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
