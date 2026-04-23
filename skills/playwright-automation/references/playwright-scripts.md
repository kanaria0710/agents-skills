# Playwright Script Patterns

## Project Setup

For a one-off script (no package.json needed):

```bash
# In any directory
npm install playwright
node script.js
```

For a project with package.json:

```bash
npm init -y
npm install playwright
npx playwright install chromium
```

---

## Screenshot Patterns

### Basic URL Screenshot

```javascript
const { chromium } = require('playwright');

(async () => {
  const browser = await chromium.launch();
  const page = await browser.newPage();
  await page.goto('https://example.com');
  await page.screenshot({ path: 'screenshot.png' });
  await browser.close();
})();
```

### Full Page Screenshot

```javascript
await page.screenshot({ path: 'fullpage.png', fullPage: true });
```

### Element-Only Screenshot

```javascript
const element = await page.$('.my-component');
await element.screenshot({ path: 'element.png' });
```

### Multiple Screenshots (e.g., slide-by-slide)

```javascript
const { chromium } = require('playwright');

(async () => {
  const browser = await chromium.launch();
  const page = await browser.newPage();
  await page.setViewportSize({ width: 1280, height: 720 });

  const urls = [
    'https://example.com/slide1',
    'https://example.com/slide2',
    'https://example.com/slide3',
  ];

  for (let i = 0; i < urls.length; i++) {
    await page.goto(urls[i]);
    await page.waitForLoadState('networkidle');
    await page.screenshot({ path: `slide-${i + 1}.png` });
  }

  await browser.close();
})();
```

### Screenshot with Custom Viewport

```javascript
const browser = await chromium.launch();
const context = await browser.newContext({
  viewport: { width: 1920, height: 1080 },
});
const page = await context.newPage();
```

---

## Navigation Patterns

### Open Local HTML File

```javascript
// Must use absolute file:// path
await page.goto('file:///Users/username/project/index.html');
```

Helper to build file URL:

```javascript
const path = require('path');
const filePath = path.resolve('/Users/username/slide/output.html');
await page.goto(`file://${filePath}`);
```

### Wait for Page Load

```javascript
// Wait for network to be idle (useful for dynamic content)
await page.goto(url, { waitUntil: 'networkidle' });

// Wait for DOM content loaded
await page.goto(url, { waitUntil: 'domcontentloaded' });
```

---

## Interaction Patterns

### Click

```javascript
await page.click('button');                        // by tag
await page.click('#submit');                       // by id
await page.click('.btn-primary');                  // by class
await page.click('text=Submit');                   // by visible text
await page.click('[data-testid="submit-btn"]');    // by data attribute
```

### Fill Input

```javascript
await page.fill('input[name="username"]', 'myuser');
await page.fill('textarea', 'Hello, world!');
```

### Select Dropdown

```javascript
await page.selectOption('select#color', 'blue');
```

### Wait for Element

```javascript
await page.waitForSelector('.loaded');
await page.waitForSelector('#result', { state: 'visible' });
```

### Wait for Fixed Time

```javascript
await page.waitForTimeout(2000); // 2 seconds
```

---

## Data Extraction

### Get Text

```javascript
const text = await page.textContent('h1');
console.log(text);
```

### Get All Matching Elements

```javascript
const items = await page.$$eval('li', els => els.map(el => el.textContent));
console.log(items);
```

### Get Attribute

```javascript
const href = await page.getAttribute('a.link', 'href');
```

---

## Context and Multiple Pages

```javascript
const browser = await chromium.launch();
const context = await browser.newContext();

// Open multiple pages
const page1 = await context.newPage();
const page2 = await context.newPage();

await page1.goto('https://example.com');
await page2.goto('https://another.com');

// Close all
await context.close();
await browser.close();
```

---

## Headless vs. Headed Mode

```javascript
// Headless (default) — no visible browser window
const browser = await chromium.launch({ headless: true });

// Headed — shows browser window
const browser = await chromium.launch({ headless: false });
```

Use headed mode for debugging or when visual confirmation is needed.

---

## Error Handling Template

```javascript
const { chromium } = require('playwright');

(async () => {
  let browser;
  try {
    browser = await chromium.launch();
    const page = await browser.newPage();

    await page.goto('https://example.com', { timeout: 30000 });
    await page.screenshot({ path: 'output.png' });

    console.log('✓ 完了');
  } catch (error) {
    console.error('✗ エラー:', error.message);
    process.exit(1);
  } finally {
    if (browser) await browser.close();
  }
})();
```
