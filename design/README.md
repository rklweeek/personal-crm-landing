# Handoff: лендинг «Личная CRM»

## Overview
Одностраничный статичный лендинг личной CRM. Единственное целевое действие — перейти в приложение (все кнопки ведут на один URL). Две раскладки: мобильная (390px) и десктопная (до 1280px контента).

Стек реализации: **Astro + Tailwind CSS 4**, статичная сборка (`output: 'static'`), без UI-фреймворков. Анимации — небольшой vanilla-скрипт.

## About the Design Files
Файлы в `design/` — **дизайн-референсы в HTML**: прототипы, показывающие внешний вид и поведение. Это не продакшен-код. Задача — воссоздать их в Astro + Tailwind 4 по принятым там паттернам (компоненты `.astro`, утилиты Tailwind, токены в `@theme`).

Открыть референсы: запустить любой статичный сервер в папке `design/` (например `npx serve design`) и открыть `Landing Desktop.dc.html` и `Landing Mobile.dc.html`. Пунктирные рамки и промпты в макетах — служебные (по умолчанию скрыты), в продакшен не переносить.

## Fidelity
**High-fidelity.** Цвета, шрифты, размеры, отступы, тексты и анимации финальные. Верстать пиксель-в-пиксель.

---

## Design Tokens

### Цвета
| Токен | Hex | Использование |
|---|---|---|
| `ink` | `#282828` | основной текст, фон кнопок |
| `accent` | `#F15534` | акцентные слова в заголовках, стрелки в кнопках, номера, точка напоминания |
| `paper` | `#FAF8F4` | фон страницы, фон чётных секций, фон карточек выгод |
| `white` | `#FFFFFF` | фон секций «Проблема» и «Выгоды», карточка контакта |
| `muted` | `#5F5B55` | основной вторичный текст (подзаголовки, описания) |
| `subtle` | `#8A857D` | мелкие подписи, даты, футер |
| `bubble` | `#F3F0EA` | фон «пузырей» с вопросами, теги |
| `line` | `#E3DFD7` | разделители списков, линия футера |
| `line-soft` | `#EEE9E1` | разделитель внутри карточки контакта |

Tailwind 4 (`src/styles/global.css`):
```css
@import "tailwindcss";
@theme {
  --color-ink: #282828;
  --color-accent: #F15534;
  --color-paper: #FAF8F4;
  --color-muted: #5F5B55;
  --color-subtle: #8A857D;
  --color-bubble: #F3F0EA;
  --color-line: #E3DFD7;
  --color-line-soft: #EEE9E1;
  --font-sans: "Onest", system-ui, sans-serif;
  --font-mono: "JetBrains Mono", ui-monospace, monospace;
  --ease-out-soft: cubic-bezier(.2,.7,.2,1);
}
body { background: var(--color-paper); color: var(--color-ink); -webkit-font-smoothing: antialiased; }
a { text-decoration: none; }
```

### Шрифты
- **Onest** 400 / 500 / 600 — весь текст. Кириллица обязательна.
- **JetBrains Mono** 400 / 500 — номера 01–04, тег на фото, «ИСТОРИЯ», футер.
- Подключение: `@fontsource/onest`, `@fontsource/jetbrains-mono` (self-host) — предпочтительно; либо Google Fonts.

### Типографика
Все заголовки (h1, h2): Onest 600, `text-transform: uppercase`, `text-wrap: balance`.

| Элемент | Mobile | Desktop | line-height | letter-spacing |
|---|---|---|---|---|
| H1 hero | 34px, по центру | `clamp(40px, 5.4vw, 72px)`, слева | 1.04 / 1.0 | -0.025em / -0.03em |
| H2 разделов | 27px | `clamp(32px, 3.6vw, 48px)` | 1.04 | -0.025em |
| H2 финального CTA | 31px, по центру | `clamp(36px, 4.4vw, 60px)`, по центру | 1.04 / 1.02 | -0.025em / -0.03em |
| Подзаголовок hero / CTA | 16px, muted | 19px, muted | 1.5 | — |
| Абзац «Проблема» | 16px | 19px | 1.55 | — |
| Пузырь-вопрос | 17px | 20px | 1.35 | — |
| Итоговая фраза «Проблема» | 18px / 500 | `clamp(22px, 2vw, 28px)` / 500 | 1.45 / 1.35 | — |
| Название функции (01–04) | 14px / 600 / uppercase, ls .03em | 16px | — | — |
| Описание функции | 15px, muted | 17px | 1.5 | — |
| Итоговая фраза «Решение» | 19px / 500 | 22px / 500 | 1.35 / 1.4 | — |
| Заголовок выгоды | 12.5px / 600 / uppercase, ls .03em | 14px | 1.3 | — |
| Описание выгоды | 13.5px, muted | 16px | 1.45 / 1.5 | — |
| Логотип «Личная CRM» | 14px / 600 / uppercase, ls .04em | 15px | — | — |
| Ссылка «Открыть» в шапке | 12px / 500 / uppercase, ls .04em, нижняя граница 1px accent | 13px | — | — |
| Кнопка | 16px / 500 | 17px / 500 | — | — |
| Номера 01–04 | Mono 11px accent | Mono 12px | — | — |
| Футер | Mono 10px uppercase, ls .06em, subtle | Mono 11px | — | — |

### Радиусы
- Фото: **без рамок и скруглений.** Края растворяются в фоне через `mask-image` (см. «Фото без рамок»)
- Кнопки: pill (`border-radius: 9999px`), высота 56–58px mobile, 60–62px desktop
- Карточка контакта: 24px / 28px; блок напоминания внутри: 14px / 16px
- Карточки выгод: 16px / 20px
- Пузыри: `18px 18px 18px 4px` (левые), `18px 18px 4px 18px` (правый); desktop 22px и 6px
- Теги: 14px / 16px; тег на фото hero: 12px / 14px

### Тени
- Карточка контакта: `0 24px 50px -30px rgba(40,40,40,.35)` (mobile), `0 30px 60px -36px rgba(40,40,40,.35)` (desktop)

### Отступы
- Mobile: горизонтальный padding секций 24px; вертикальный 56px (hero — снизу 40px; CTA — 64px сверху, 40px снизу); gap внутри секций 24px.
- Desktop: контейнер `max-width: 1280px; padding-inline: 48px`; вертикальный padding секций 120px (CTA — 128px сверху); hero снизу 96px.

---

## Структура страницы
Тексты — **дословно** как ниже (финальная версия; в `copy/personal-crm-landing.md` исходный текст, заголовок раздела «Выгоды» в нём устарел).

Порядок секций и фон: Hero (`paper`) → Проблема (`white`) → Решение (`paper`) → Выгоды (`white`) → Призыв (`paper`) + футер.

Лучше делать один Astro-компонент на секцию (`Hero.astro`, `Problem.astro`, `Solution.astro`, `Benefits.astro`, `FinalCta.astro`) и общий `AppButton.astro`.

### 1. Hero
**Шапка:** слева «Личная CRM», справа ссылка «Открыть» (→ URL приложения). Mobile: padding 20px 24px. Desktop: padding 28px 0.

**H1:** «Не теряйте связь с **важными людьми**» — «важными людьми» цветом `accent`.

**Фото** `assets/hero-friends.png` (друзья за кухонным столом), `object-fit: cover`, почти фоновое, без рамки.
- Mobile: на всю ширину экрана (без боковых отступов), под H1 (margin-top 8px), высота 540px, маска `linear-gradient(180deg, transparent 0%, #000 18%, #000 76%, transparent 100%)`. Подзаголовок идёт сразу после фото (margin-top 0), попадает на прозрачный край.
- Desktop: секция `min-height: clamp(620px, calc(100vh - 90px), 860px)`, текст по центру по вертикали. Фото — `position:absolute; top:0; bottom:0; right:0; left: calc(max(48px, (100vw - 1280px)/2 + 48px) + min(540px, 40vw) + 16px)` (начинается строго правее текстовой колонки, до правого края окна), маска из двух градиентов: `linear-gradient(90deg, transparent 0%, #000 34%)` ∩ `linear-gradient(180deg, transparent 0%, #000 14%, #000 72%, transparent 100%)` (`mask-composite: intersect`). Текстовая колонка `max-width: min(540px, 40vw)`; фото никогда не заходит под текст ни на одной ширине.
- Шапка на десктопе вынесена над секцией hero (отдельный `<header>`), фото начинается под ней.
- Плашка (mobile: left 24px, bottom 150px; desktop: справа по краю контейнера, bottom 22%): фон `rgba(250,248,244,.94)`, radius 12/14px, padding 10px 12px / 12px 14px, Mono 10px / 12px. Строки: «Марина · познакомились в Казани» (500), «написать в пятницу →» (accent).

**Подзаголовок:** «Личная CRM для друзей, коллег, партнёров и новых знакомых. Соберите контакты, историю общения и планы на следующую встречу в одном месте.» Mobile — под фото (margin-top 24px), по центру. Desktop — под H1 в левой колонке, `max-width: 480px`.

**Кнопка:** «Открыть приложение →», фон `ink`, текст белый, стрелка `accent`. Mobile: на всю ширину, margin-top 24px. Desktop: по ширине содержимого, padding-inline 32px.

**Desktop-сетка:** `grid-template-columns: repeat(auto-fit, minmax(min(100%, 440px), 1fr)); gap: 56px; align-items: center`; левая колонка — flex column, gap 32px.

### 2. Проблема
- H2: «Знакомств много. **Помнить всё — сложно**» (вторая фраза — accent).
- Фото `assets/problem-cards.webp` (визитки и бейджи на столе), без рамки. Mobile — на всю ширину экрана (margin 0 -24px), высота 380px, вертикальная маска 16% / 80%. Desktop — правая колонка, высота 540px, выходит за колонку (margin -40px -48px), маска-виньетка `radial-gradient(ellipse 52% 52% at 50% 50%, #000 34%, transparent 100%)`; слева H2 + абзац (gap 28px).
- Абзац: «После знакомства кажется, что вы всё запомните. Через месяц уже трудно найти переписку, вспомнить детали разговора и вернуться к обещанному.»
- Три пузыря-вопроса, фон `bubble`, padding 14px 16px / 24px 26px:
  - «Кто из знакомых мог бы помочь с этой задачей?»
  - «Мы договаривались созвониться — когда именно?»
  - «Давно не общались. С чего теперь начать?»
  - Mobile: колонка, gap 12px, max-width 290px, чередование лево / право / лево (как переписка). Desktop: 3 в ряд (`repeat(auto-fit, minmax(min(100%,280px),1fr))`, gap 20px), средний смещён вниз на 32px.
- Итоговая фраза: «Без понятной системы даже ценные знакомства **постепенно теряются из виду.**» (вторая часть — accent). Desktop: max-width 760px.
- Desktop: вертикальный gap между блоками секции 64px.

### 3. Решение
- H2: «Всё, что важно знать о человеке, — **под рукой**» (desktop: max-width 900px).
- **Карточка контакта** (вёрстка, не картинка): фон white, padding 20px / 28px, gap 16px / 20px, тень (см. токены). Desktop: левая колонка, max-width 480px.
  - Аватар-круг 56px / 68px (фото на выбор; в макете пустой) + «Марина Лебедева» (600, 19px / 22px) + «Продюсер · познакомились в Казани» (13px / 14px, subtle).
  - Теги-пилюли (фон `bubble`, 12px / 13px, padding 5px 10px / 6px 12px): «#конференции», «#медиа», «#партнёры».
  - Блок «ИСТОРИЯ» (Mono 10px / 11px, subtle), верхняя граница `line-soft`, две строки сеткой `52px / 60px + 1fr`:
    - «12 сен» — «Обсудили подкаст о городских проектах. Обещал прислать контакты звукорежиссёра.»
    - «03 авг» — «Познакомились на конференции, сидели рядом на панели.»
  - Напоминание: фон `paper`, radius 14/16px, «Отправить контакты» (500) / «Напоминание · пятница» (subtle) + справа точка 10px `accent`.
- **Список функций** (4 строки): сетка `36px / 48px + 1fr`, padding 18px 0 / 24px 0, граница сверху `line`, у последней ещё снизу.
  - 01 «Карточка контакта.» — «Где познакомились, чем занимается человек и что вас связывает.»
  - 02 «История общения.» — «Главное из встреч и переписок, общие идеи и договорённости.»
  - 03 «Напоминания.» — «Написать после знакомства, узнать о новом проекте или поздравить с важной датой.»
  - 04 «Поиск и теги.» — «Нужные люди по сфере, интересам или контексту знакомства.»
- Итоговая фраза: «После разговора — короткая заметка и следующий шаг. Перед встречей — быстрый взгляд на историю.»
- Desktop: двухколоночная сетка `repeat(auto-fit, minmax(min(100%,420px),1fr))`, gap 64px, `align-items: start`; справа список + фраза (gap 40px).

### 4. Выгоды
- H2: «Больше внимания и **заботы** людям.» — только слово «заботы» accent.
- Фото `assets/benefits-reunion.webp` (друзья обнимаются у кафе), почти фоновое. Mobile — на всю ширину экрана, высота 480px. Desktop — на всю ширину окна (`margin-inline: calc(50% - 50vw)`), высота `clamp(440px, 48vw, 760px)`. Маска `linear-gradient(180deg, transparent 0%, #000 18%, #000 78%, transparent 100%)` растворяет фото в белом фоне секции; H2 над фото, карточки под ним, текст на фото не накладывается.
- 4 карточки (фон `paper`, padding 16px / 24px, gap 8px / 12px). Mobile: сетка 2×2, gap 12px. Desktop: `repeat(auto-fit, minmax(min(100%,190px),1fr))`, gap 16px (4 в ряд).
  - «Спокойнее в повседневных делах.» — «Не нужно постоянно прокручивать в голове, кому вы ещё не ответили.»
  - «Увереннее в общении.» — «Проще продолжить разговор с учётом того, что важно собеседнику.»
  - «Надёжнее в договорённостях.» — «Ваши слова чаще превращаются в действия, укрепляя доверие.»
  - «Больше возможностей для сотрудничества.» — «Легче увидеть, кого пригласить в проект или познакомить друг с другом.»

### 5. Призыв + футер
Всё по центру.
- Портрет `assets/cta-portrait.webp` без рамки: mobile — на всю ширину, высота 340px; desktop — `width: min(100%, 820px)`, высота 420px. Маска-виньетка `radial-gradient(ellipse 58% 58% at 50% 50%, #000 38%, transparent 100%)`.
- H2: «С кем вы давно хотели **связаться?**» (desktop: max-width 820px).
- Текст: «Начните с одного человека: добавьте контакт, запишите важную деталь и выберите день для сообщения.» (desktop: max-width 540px).
- Кнопка «Добавить первый контакт →» (тот же стиль, ведёт в приложение). Mobile — на всю ширину; desktop — по содержимому, padding-inline 36px.
- Футер: граница сверху `line`, padding-top 16px / 20px, слева «Личная CRM», справа «2026». Отступ сверху 40px / 112px.

---

## Interactions & Behavior

### Ссылки
Все три точки — «Открыть» в шапке, кнопка hero, финальная кнопка — ведут на один URL приложения. Вынести в env: `PUBLIC_APP_URL`. Hover на ссылках и кнопках: `opacity: .85`. Добавить видимый `:focus-visible` (outline 2px accent, offset 3px).

### Анимации
**Hero (при загрузке):**
1. H1: fade + translateY(18–20px → 0), 900ms, ease-out cubic, задержка 200ms.
2. Фото: `filter: blur(16px → 0)` (desktop 18px) и `scale(1.12 → 1)` (desktop 1.1 → 1), 3200ms, smoothstep / `ease-in-out`. Ключевая идея: размытое воспоминание становится чётким.
3. Подзаголовок: fade + translateY, 900ms, задержка ~2400–2600ms (после того как фото почти проявилось).
4. Кнопка: то же, задержка ~2700–2900ms.
5. Плашка «Марина…»: то же, задержка 3300ms.

Реализуется CSS-анимациями (`@keyframes` + `animation-delay`) без JS.

**Появление при скролле** (все блоки секций 2–5: заголовки, фото, абзацы, пузыри, строки списка, карточки, кнопка): изначально `opacity: 0; transform: translateY(22px)` (desktop 28px). При пересечении viewport (IntersectionObserver, `threshold: 0.2`, один раз) — `opacity: 1; transform: none`, transition 900ms `cubic-bezier(.2,.7,.2,1)`.

**Смысловые эффекты с фото — привязаны к прокрутке** (не к таймеру; фильтр пересчитывается на каждый scroll в rAF):
- Фото «Проблема» (`data-blur="out"`): `p = clamp((vh*0.7 - top) / (vh*0.55), 0, 1)`, `filter: blur(p*9px) grayscale(p*0.85)`. Пока фото внизу экрана — чёткое; по мере прокрутки размывается и выцветает. Смысл — знакомство забывается.
- Фото «Выгоды» и портрет в CTA (`data-blur="in"`): `p = clamp((vh*0.95 - top) / (vh*0.6), 0, 1)`, `filter: blur((1-p)*16px)`. Проявляется по мере прокрутки. Смысл — связь вернулась.
- Transition для filter: `.25s linear` (сглаживание между кадрами).

Пример скрипта (`src/scripts/reveal.ts`, подключить в layout):
```ts
const els = document.querySelectorAll<HTMLElement>('[data-reveal]');
const io = new IntersectionObserver((entries) => {
  for (const e of entries) {
    if (!e.isIntersecting) continue;
    const el = e.target as HTMLElement;
    el.classList.add('is-visible');
    if (el.dataset.blur === 'out') setTimeout(() => el.classList.add('is-faded'), 1200);
    io.unobserve(el);
  }
}, { threshold: 0.2 });
els.forEach((el) => io.observe(el));

const blurEls = document.querySelectorAll<HTMLElement>('[data-blur]');
let ticking = false;
const update = () => {
  const vh = innerHeight;
  blurEls.forEach((el) => {
    const top = el.getBoundingClientRect().top;
    if (el.dataset.blur === 'out') {
      const p = Math.min(1, Math.max(0, (vh * 0.7 - top) / (vh * 0.55)));
      el.style.filter = `blur(${p * 9}px) grayscale(${p * 0.85})`;
    } else {
      const p = Math.min(1, Math.max(0, (vh * 0.95 - top) / (vh * 0.6)));
      el.style.filter = `blur(${(1 - p) * 16}px)`;
    }
  });
  ticking = false;
};
addEventListener('scroll', () => { if (!ticking) { ticking = true; requestAnimationFrame(update); } }, { passive: true });
addEventListener('resize', update);
update();
```
### Фото без рамок
Все фото без скруглений и теней: края растворяются в фоне секции через `mask-image` (+ `-webkit-mask-image`). В Tailwind 4 — утилиты `mask-*` или arbitrary values: `[mask-image:linear-gradient(...)]`. Маска на обёртке, blur/scale — на внутреннем слое, чтобы размытие не «вытекало» за маску.

Начальное скрытое состояние вешать через класс на `<html>` (например `js`), чтобы без JS контент был виден.

**`prefers-reduced-motion: reduce`:** отключить все transform/blur-анимации, показывать контент сразу.

### Адаптив
- Mobile-раскладка — до `lg` (1024px); десктопная — от `lg`. Между 768 и 1024 можно оставить мобильную структуру с контейнером `max-width: 640px` по центру либо включить desktop-сетку с `md` — обе сетки в макете рассчитаны на перенос колонок через `auto-fit`.
- Шрифты заголовков на десктопе уже fluid (`clamp`).

## State Management
Нет. Статичная страница; единственная динамика — CSS-анимации и IntersectionObserver.

## Assets
| Файл | Где | Источник |
|---|---|---|
| `assets/hero-friends.png` | Hero | предоставлено заказчиком (AI-генерация) |
| `assets/problem-cards.webp` | Проблема | предоставлено заказчиком |
| `assets/benefits-reunion.webp` | Выгоды | предоставлено заказчиком |
| `assets/cta-portrait.webp` | Призыв | предоставлено заказчиком |

Хранить в `src/assets/` и выводить через `astro:assets` `<Image>` / `<Picture>` (avif/webp, `widths` под 390/780 и 640/1280), `alt` — краткое описание сцены. Hero-изображение — `loading="eager"`, `fetchpriority="high"`; остальные — lazy. Аватар в карточке контакта в макете пустой (серый круг `bubble`) — можно оставить так или добавить фото.

Иконок нет: стрелки «→» — текстовые символы.

## SEO / meta (рекомендуется)
`<html lang="ru">`, `<title>Личная CRM — не теряйте связь с важными людьми</title>`, meta description = подзаголовок hero, OG-изображение — кроп hero-фото.

## Files
- `design/Landing Desktop.dc.html` — десктопный референс
- `design/Landing Mobile.dc.html` — мобильный референс (390px)
- `design/support.js`, `design/image-slot.js`, `design/.image-slots.state.json`, `design/assets/` — нужны только чтобы референсы открылись с картинками
- `assets/` — финальные изображения для продакшена
- `copy/personal-crm-landing.md` — исходный текст лендинга
