---
name: playwright-automation
description: Automates browser operations using Playwright CLI, including opening URLs/local files, taking screenshots, and interacting with web pages. Handles Playwright and browser installation check/auto-install. Use when user asks to "Playwrightでスクリーンショットを撮る", "ブラウザを自動操作する", "Playwrightで開く", "take a screenshot with Playwright", "automate browser", or "open file in browser".
compatibility: Requires Node.js. Playwright browsers auto-installed if missing. macOS/Linux/Windows compatible.
metadata:
  category: automation
  tags: [playwright, browser, automation, screenshot]
---

# Playwright Browser Automation

Automate browser operations using Playwright CLI: open URLs/local files, take screenshots, interact with pages.

## Critical Rules

- Always check Playwright installation before any operation
- Use absolute paths when referencing local files
- Default browser is Chromium unless user specifies otherwise
- When writing scripts, use async/await pattern with proper browser cleanup (`browser.close()`)
- Always confirm the output path/result with the user after execution

---

## Phase 1: Environment Check

### Check Playwright CLI

```bash
npx playwright --version
```

If this fails, Node.js may be missing:

```bash
node --version
npm --version
```

If Node.js is missing, inform the user:
> "Node.js が必要です。https://nodejs.org からインストールしてください。"

### Install Playwright

```bash
npm install -g playwright
```

Or for project-local install:

```bash
npm install playwright
```

### Install Browsers

After installing Playwright, install the required browser:

```bash
# Chromium only (recommended for most cases)
npx playwright install chromium

# All browsers
npx playwright install
```

Verify browser is available:

```bash
npx playwright --version
```

---

## Phase 2: Determine Operation

Based on user request, select the appropriate operation:

| User intent | Operation |
|-------------|-----------|
| スクリーンショットを撮りたい | → Screenshot |
| ページを開きたい / 確認したい | → Open in browser |
| ローカルファイルを開きたい | → Open local file |
| クリック・入力などの操作をしたい | → Page interaction script |
| 複数ステップの自動化 | → Custom script |

---

## Phase 3: Operations

### Screenshot

**Via CLI (simple, single URL):**

```bash
npx playwright screenshot <url> <output-path.png>
```

Example:
```bash
npx playwright screenshot https://example.com ~/Desktop/example.png
```

**Via script (local file or advanced options):**

```javascript
const { chromium } = require('playwright');

(async () => {
  const browser = await chromium.launch();
  const page = await browser.newPage();

  // For local file: use file:// with absolute path
  await page.goto('file:///Users/username/slide/my-slide.html');

  // Full page screenshot
  await page.screenshot({ path: 'output.png', fullPage: true });

  await browser.close();
})();
```

Run with:
```bash
node script.js
```

For viewport-specific screenshots:
```javascript
await page.setViewportSize({ width: 1280, height: 720 });
await page.screenshot({ path: 'output.png' });
```

See `references/playwright-scripts.md` for more screenshot patterns.

---

### Open Local File

To open a local HTML/Markdown file in the browser:

```javascript
const { chromium } = require('playwright');

(async () => {
  const browser = await chromium.launch({ headless: false }); // headless: false = visible browser
  const page = await browser.newPage();
  await page.goto('file:///absolute/path/to/file.html');

  // Keep open until manually closed
  await page.waitForTimeout(30000);
  await browser.close();
})();
```

**Note on Marp files**: Marp `.md` files must be converted to HTML or served via `marp --server` before Playwright can open them. See `references/marp-integration.md`.

---

### Page Interaction

For click, type, wait, and other page interactions:

```javascript
const { chromium } = require('playwright');

(async () => {
  const browser = await chromium.launch();
  const page = await browser.newPage();
  await page.goto('https://example.com');

  // Click
  await page.click('button#submit');

  // Type into input
  await page.fill('input[name="email"]', 'test@example.com');

  // Wait for element
  await page.waitForSelector('.result');

  // Get text content
  const text = await page.textContent('.result');
  console.log(text);

  await browser.close();
})();
```

See `references/playwright-scripts.md` for selector strategies and common patterns.

---

### Custom Multi-Step Script

When the user needs a sequence of operations:

1. Ask for the full sequence of steps
2. Write a single script covering all steps
3. Add error handling with try/catch
4. Execute and report results

Template:

```javascript
const { chromium } = require('playwright');

(async () => {
  const browser = await chromium.launch();
  const context = await browser.newContext();
  const page = await context.newPage();

  try {
    // Step 1
    await page.goto('<url>');

    // Step 2
    // ... operations ...

    // Step 3
    await page.screenshot({ path: 'result.png' });

    console.log('完了しました');
  } catch (error) {
    console.error('エラー:', error.message);
  } finally {
    await browser.close();
  }
})();
```

---

## Phase 4: Execution and Results

After running the script or CLI command:

1. Confirm the output file exists (for screenshots)
2. Report the result to the user
3. If an error occurred, consult `references/troubleshooting.md`

---

## Troubleshooting

See `references/troubleshooting.md` for common issues:
- Playwright not found
- Browser not installed
- Local file not loading
- Selector not found
- Timeout errors
