const reduceMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;

// Blocks of sections 2–5 fade in once, when they scroll into view.
const revealEls = document.querySelectorAll<HTMLElement>('[data-reveal]');

if (reduceMotion || !('IntersectionObserver' in window)) {
  revealEls.forEach((el) => el.classList.add('is-visible'));
} else {
  const io = new IntersectionObserver(
    (entries) => {
      for (const entry of entries) {
        if (!entry.isIntersecting) continue;
        entry.target.classList.add('is-visible');
        io.unobserve(entry.target);
      }
    },
    { threshold: 0.2 },
  );
  revealEls.forEach((el) => io.observe(el));
}

// Photo focus follows the scroll position:
// "out" — the photo blurs and fades as it leaves (an acquaintance is forgotten),
// "in" — the photo comes into focus (the connection is back).
const blurEls = document.querySelectorAll<HTMLElement>('[data-blur]');
const clamp01 = (value: number) => Math.min(1, Math.max(0, value));

const updateBlur = () => {
  const vh = window.innerHeight;
  blurEls.forEach((el) => {
    const top = el.getBoundingClientRect().top;
    if (el.dataset.blur === 'out') {
      const p = clamp01((vh * 0.7 - top) / (vh * 0.55));
      el.style.filter = `blur(${(p * 9).toFixed(2)}px) grayscale(${(p * 0.85).toFixed(2)})`;
    } else {
      const p = clamp01((vh * 0.95 - top) / (vh * 0.6));
      el.style.filter = `blur(${((1 - p) * 16).toFixed(2)}px)`;
    }
  });
};

if (!reduceMotion && blurEls.length > 0) {
  let ticking = false;
  const onScroll = () => {
    if (ticking) return;
    ticking = true;
    requestAnimationFrame(() => {
      updateBlur();
      ticking = false;
    });
  };
  window.addEventListener('scroll', onScroll, { passive: true });
  window.addEventListener('resize', onScroll);
  updateBlur();
}
