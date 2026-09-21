(function () {
  "use strict";
  var LS_FAV = "dalni:favorites";
  var body = document.body;
  var mode = body.dataset.nav === "overlay" ? "overlay" : "solid";
  var page = (location.pathname.split("/").pop() || "index.html").toLowerCase();

  function favCount() {
    try { var v = JSON.parse(localStorage.getItem(LS_FAV) || "[]"); return Array.isArray(v) ? v.length : 0; } catch (e) { return 0; }
  }
  function hasResults() {
    try { return !!sessionStorage.getItem("aiTravelResults"); } catch (e) { return false; }
  }

  var style = document.createElement("style");
  style.textContent = [
    ".tatreez-pattern{background-image:url(\"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='64' height='64'%3E%3Cpath d='M32 4 L60 32 L32 60 L4 32 Z' fill='none' stroke='%234b5a3a' stroke-width='3' stroke-dasharray='3 3' stroke-linecap='square'/%3E%3Cpath d='M32 16 L48 32 L32 48 L16 32 Z' fill='none' stroke='%23a6572e' stroke-width='2' stroke-dasharray='2 2' stroke-linecap='square'/%3E%3Crect x='29' y='29' width='6' height='6' fill='%23a6572e'/%3E%3Cpath d='M32 4 L36 10 L32 13 L28 10 Z' fill='%234b5a3a'/%3E%3Cpath d='M60 32 L54 36 L51 32 L54 28 Z' fill='%234b5a3a'/%3E%3Cpath d='M32 60 L28 54 L32 51 L36 54 Z' fill='%234b5a3a'/%3E%3Cpath d='M4 32 L10 28 L13 32 L10 36 Z' fill='%234b5a3a'/%3E%3Ccircle cx='32' cy='0' r='1.4' fill='%23a6572e'/%3E%3Ccircle cx='64' cy='32' r='1.4' fill='%23a6572e'/%3E%3Ccircle cx='32' cy='64' r='1.4' fill='%23a6572e'/%3E%3Ccircle cx='0' cy='32' r='1.4' fill='%23a6572e'/%3E%3C/svg%3E\");background-size:64px 64px;background-repeat:repeat}",
    "#site-menu{max-height:0;overflow:hidden;transition:max-height .3s ease}",
    "#site-menu.open{max-height:460px}",
    ".nav-link{position:relative}",
    ".nav-link[aria-current='page']::after{content:'';position:absolute;inset-inline:0;bottom:-8px;height:2px;border-radius:2px;background:currentColor}",
    "a:focus-visible,button:focus-visible,select:focus-visible,input:focus-visible{outline:2px solid var(--ring);outline-offset:2px}",
    "@media (prefers-reduced-motion:reduce){*,*::before,*::after{scroll-behavior:auto!important;transition-duration:.01ms!important;animation-duration:.01ms!important;animation-delay:0ms!important}}"
  ].join("\n");
  document.head.appendChild(style);

  var overlay = mode === "overlay";
  var headerCls = overlay
    ? "absolute inset-x-0 top-0 z-30 border-b border-hero-foreground/20 text-hero-foreground"
    : "sticky top-0 z-40 border-b border-border bg-card/90 text-foreground backdrop-blur-md";
  var hover = overlay ? "hover:text-copper" : "hover:text-terracotta";
  var cta = overlay
    ? "bg-sand text-foreground hover:bg-sand/90"
    : "bg-primary text-primary-foreground hover:bg-primary/90";
  var menuBg = overlay ? "border-hero-foreground/20 bg-hero/95 backdrop-blur-md" : "border-border bg-card";
  var badgeCls = overlay ? "bg-sand text-foreground" : "bg-terracotta text-terracotta-foreground";

  /* ---------- الروابط حسب الصفحة ----------
     الرئيسية: تتنقل بين سكشنات الصفحة نفسها + CTA للفورم.
     باقي الصفحات: تتبع رحلة المستخدم (تفضيلات ← توصيات ← محفوظة). */
  var onSaved = page === "results.html" && /[?&]tab=saved/.test(location.search);
  var links;
  if (overlay) {
    links = [
      { t: "كيف يعمل", h: "#how" },
      { t: "وجهات مختارة", h: "#places" },
      { t: "المحفوظة", h: "results.html?tab=saved", saved: true }
    ];
  } else {
    links = [
      { t: "الرئيسية", h: "index.html" },
      { t: "خطط رحلتك", h: "preferences.html", cur: page === "preferences.html" }
    ];
    if (hasResults()) {
      links.push({ t: "توصياتي", h: "results.html", cur: (page === "results.html" && !onSaved) || page === "place.html" });
    }
    links.push({ t: "المحفوظة", h: "results.html?tab=saved", cur: onSaved, saved: true });
  }

  function linkHTML(l, extra) {
    return '<a href="' + l.h + '" class="nav-link ' + extra + " " + hover + ' transition-colors"' +
      (l.cur ? ' aria-current="page"' : "") + ">" + l.t +
      (l.saved ? ' <span data-fav-count class="ms-1 hidden min-w-5 rounded-full px-1.5 py-0.5 text-center text-[11px] font-bold ' + badgeCls + '">0</span>' : "") +
      "</a>";
  }

  var ctaDesktop = overlay
    ? '<a href="preferences.html" class="hidden items-center rounded-md px-5 py-2.5 text-sm font-bold transition-all hover:-translate-y-0.5 lg:inline-flex ' + cta + '">خطط رحلتك</a>'
    : "";
  var ctaMobile = overlay
    ? '<li class="pt-1"><a href="preferences.html" class="block rounded-md px-3 py-2.5 text-center font-bold transition-colors ' + cta + '">خطط رحلتك</a></li>'
    : "";

  var header = document.createElement("header");
  header.id = "site-header";
  header.className = headerCls;
  header.innerHTML =
    '<div class="mx-auto flex h-16 max-w-7xl items-center justify-between gap-4 px-5 sm:h-20 sm:px-8">' +
    '<a href="index.html" class="flex items-center gap-3" aria-label="دلني — الرئيسية">' +
    '<span class="grid size-11 shrink-0 place-items-center rounded-xl bg-background/95 p-1 sm:size-12"><img src="assets/logo.png" alt="" class="h-full w-full object-contain" /></span>' +
    '<span class="font-display text-lg font-extrabold">دلني</span>' +
    "</a>" +
    '<nav class="hidden items-center gap-7 text-sm font-semibold lg:flex" aria-label="التنقل الرئيسي">' +
    links.map(function (l) { return linkHTML(l, ""); }).join("") +
    "</nav>" +
    '<div class="flex items-center gap-2">' +
    ctaDesktop +
    '<button type="button" id="menu-toggle" class="grid size-10 place-items-center lg:hidden" aria-label="فتح القائمة" aria-expanded="false" aria-controls="site-menu">' +
    '<i data-lucide="menu" class="size-5" id="menu-icon-open"></i><i data-lucide="x" class="hidden size-5" id="menu-icon-close"></i>' +
    "</button>" +
    "</div>" +
    "</div>" +
    '<nav id="site-menu" class="border-t lg:hidden ' + menuBg + '" aria-label="التنقل - موبايل">' +
    '<ul class="flex flex-col gap-1 px-5 py-4 text-sm font-semibold">' +
    links.map(function (l) { return "<li>" + linkHTML(l, "block rounded-lg px-3 py-2.5") + "</li>"; }).join("") +
    ctaMobile +
    "</ul>" +
    "</nav>";
  body.insertBefore(header, body.firstChild);

  if (body.dataset.footer !== "off") {
    var cities = [["القدس", "Jerusalem"], ["بيت لحم", "Bethlehem"], ["نابلس", "Nablus"], ["الخليل", "Hebron"], ["رام الله", "Ramallah"],
    ["أريحا", "Jericho"], ["جنين", "Jenin"], ["طولكرم", "Tulkarm"], ["قلقيلية", "Qalqilya"], ["طوباس", "Tubas"]];
    var soc = "grid size-9 place-items-center rounded-full border border-border text-muted-foreground transition-colors hover:border-terracotta hover:text-terracotta";
    var footer = document.createElement("footer");
    footer.className = "relative overflow-hidden border-t bg-card text-foreground";
    footer.innerHTML =
      '<div class="tatreez-pattern absolute inset-y-0 left-0 w-1/4 opacity-[0.08]"></div>' +
      '<div class="relative mx-auto max-w-7xl px-5 py-14 sm:px-8">' +
      '<div class="grid gap-10 sm:grid-cols-2 md:grid-cols-4">' +
      '<div class="md:col-span-2">' +
      '<div class="flex items-center gap-3"><span class="grid size-12 shrink-0 place-items-center rounded-xl bg-background/90 p-1"><img src="assets/logo.png" alt="" class="h-full w-full object-contain" /></span><span class="font-display text-lg font-extrabold">دلني</span></div>' +
      '<p class="mt-4 max-w-sm text-sm leading-7 text-muted-foreground">نساعدك تكتشف فلسطين من زاوية أقرب لك — وجهات حقيقية، مرتبة بذكاء حسب اهتماماتك وميزانيتك.</p>' +
      '<div class="mt-5 flex items-center gap-3">' +
      '<a href="#" aria-label="إنستغرام" class="' + soc + '"><i data-lucide="instagram" class="size-4"></i></a>' +
      '<a href="#" aria-label="فيسبوك" class="' + soc + '"><i data-lucide="facebook" class="size-4"></i></a>' +
      '<a href="mailto:hello@aitravelsquad.ps" aria-label="راسلنا" class="' + soc + '"><i data-lucide="mail" class="size-4"></i></a>' +
      "</div>" +
      "</div>" +
      "<div>" +
      '<h2 class="font-display text-sm font-bold">استكشف</h2>' +
      '<ul class="mt-4 space-y-3 text-sm text-muted-foreground">' +
      '<li><a href="index.html" class="transition-colors hover:text-terracotta">الرئيسية</a></li>' +
      '<li><a href="preferences.html" class="transition-colors hover:text-terracotta">خطط رحلتك</a></li>' +
      '<li><a href="index.html#places" class="transition-colors hover:text-terracotta">وجهات مختارة</a></li>' +
      '<li><a href="index.html#how" class="transition-colors hover:text-terracotta">كيف يعمل</a></li>' +
      "</ul>" +
      "</div>" +
      "<div>" +
      '<h2 class="font-display text-sm font-bold">مدن نغطّيها</h2>' +
      '<ul class="mt-4 grid grid-cols-2 gap-x-4 gap-y-3 text-sm text-muted-foreground">' +
      cities.map(function (c) { return '<li><a href="preferences.html?city=' + c[1] + '" class="transition-colors hover:text-terracotta">' + c[0] + "</a></li>"; }).join("") +
      "</ul>" +
      "</div>" +
      "</div>" +
      '<div class="mt-12 flex flex-col items-center justify-between gap-3 border-t border-border pt-6 text-xs text-muted-foreground sm:flex-row"><span>© 2026 دلني. جميع الحقوق محفوظة.</span><span>نكتشف فلسطين بعيون جديدة</span></div>' +
      "</div>";
    body.appendChild(footer);
  }

  var toggle = document.getElementById("menu-toggle");
  var menu = document.getElementById("site-menu");
  function setMenu(open) {
    menu.classList.toggle("open", open);
    toggle.setAttribute("aria-expanded", String(open));
    toggle.setAttribute("aria-label", open ? "إغلاق القائمة" : "فتح القائمة");
    document.getElementById("menu-icon-open").classList.toggle("hidden", open);
    document.getElementById("menu-icon-close").classList.toggle("hidden", !open);
  }
  toggle.addEventListener("click", function () { setMenu(!menu.classList.contains("open")); });
  menu.querySelectorAll("a").forEach(function (a) { a.addEventListener("click", function () { setMenu(false); }); });
  document.addEventListener("keydown", function (e) { if (e.key === "Escape") setMenu(false); });

  function refreshFavBadge() {
    var n = favCount();
    document.querySelectorAll("[data-fav-count]").forEach(function (el) {
      el.textContent = n;
      el.classList.toggle("hidden", n === 0);
    });
  }
  window.addEventListener("storage", function (e) { if (e.key === LS_FAV) refreshFavBadge(); });
  refreshFavBadge();

  var normName = function (s) { return String(s || "").toLowerCase().replace(/[^a-z0-9\u0600-\u06ff]+/g, " ").trim(); };
  var imgPromise;
  window.Dalni = {
    LS_FAV: LS_FAV,
    refreshFavBadge: refreshFavBadge,
    HIDDEN_TRIP_TYPES: ["Family"],
    normName: normName,
    imageIndex: function () {
      if (!imgPromise) {
        imgPromise = fetch("assets/places.json")
          .then(function (r) { return r.ok ? r.json() : []; })
          .then(function (list) {
            var m = new Map();
            (Array.isArray(list) ? list : []).forEach(function (p) {
              if (p && p.name && p.image) m.set(normName(p.name), { image: p.image, credit: p.imageCredit || "" });
            });
            return m;
          })
          .catch(function () { return new Map(); });
      }
      return imgPromise;
    }
  };

  if (window.lucide) window.lucide.createIcons();
})();