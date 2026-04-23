# Marp + Playwright Integration

Marp `.md` files cannot be opened directly by Playwright as slides.
You must first convert or serve them as HTML.

---

## Option 1: Convert to HTML, then Screenshot

### Step 1: Export Marp slide to HTML

```bash
marp ~/slide/my-presentation.md --output ~/slide/my-presentation.html
```

### Step 2: Open HTML with Playwright and take screenshot

```javascript
const { chromium } = require('playwright');
const path = require('path');

(async () => {
  const browser = await chromium.launch();
  const page = await browser.newPage();

  // Set viewport to match slide aspect ratio (16:9)
  await page.setViewportSize({ width: 1280, height: 720 });

  const filePath = path.resolve('/Users/username/slide/my-presentation.html');
  await page.goto(`file://${filePath}`);
  await page.waitForLoadState('networkidle');

  await page.screenshot({ path: '/Users/username/slide/slide-preview.png' });
  console.log('スクリーンショット保存完了');

  await browser.close();
})();
```

---

## Option 2: Use Marp Server, then Screenshot

### Step 1: Start Marp server (in background)

```bash
marp --server ~/slide/ &
```

Default URL: `http://localhost:8080`

### Step 2: Open slides in Playwright

```javascript
const { chromium } = require('playwright');

(async () => {
  const browser = await chromium.launch();
  const page = await browser.newPage();
  await page.setViewportSize({ width: 1280, height: 720 });

  // Marp server serves .md files directly
  await page.goto('http://localhost:8080/my-presentation.md');
  await page.waitForLoadState('networkidle');

  await page.screenshot({ path: 'preview.png' });
  await browser.close();
})();
```

### Step 3: Stop Marp server after use

```bash
kill %1
# or
pkill -f "marp --server"
```

---

## Capture All Slides as Individual PNGs

Marp HTML uses navigation to move between slides. To capture each slide:

```javascript
const { chromium } = require('playwright');
const path = require('path');

(async () => {
  const browser = await chromium.launch();
  const page = await browser.newPage();
  await page.setViewportSize({ width: 1280, height: 720 });

  const filePath = path.resolve('/Users/username/slide/my-presentation.html');
  await page.goto(`file://${filePath}`);
  await page.waitForLoadState('networkidle');

  // Count total slides
  const totalSlides = await page.evaluate(() => {
    return document.querySelectorAll('section').length;
  });

  console.log(`総スライド数: ${totalSlides}`);

  for (let i = 0; i < totalSlides; i++) {
    // Navigate to each slide section
    await page.evaluate((index) => {
      const sections = document.querySelectorAll('section');
      sections.forEach((s, j) => {
        s.style.display = j === index ? 'flex' : 'none';
      });
    }, i);

    await page.screenshot({
      path: `/Users/username/slide/slide-${String(i + 1).padStart(2, '0')}.png`,
    });
    console.log(`スライド ${i + 1}/${totalSlides} 保存`);
  }

  await browser.close();
  console.log('全スライドのスクリーンショット完了');
})();
```

---

## Notes

- Use `waitForLoadState('networkidle')` to ensure Marp CSS/fonts are fully loaded before screenshotting
- Viewport `1280x720` matches the default Marp 16:9 aspect ratio
- For `4:3` slides, use `1024x768`
- Exported HTML files from Marp include all assets inline — no network required
