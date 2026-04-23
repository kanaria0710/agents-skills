# Playwright Troubleshooting

## Installation Issues

### `playwright: command not found` / `npx playwright` fails

**Cause**: Playwright not installed.

**Fix**:
```bash
npm install -g playwright
npx playwright install chromium
```

---

### `Error: browserType.launch: Executable doesn't exist`

**Cause**: Playwright installed but browsers not downloaded.

**Fix**:
```bash
npx playwright install chromium
# or install all browsers:
npx playwright install
```

---

### Permission error during npm install

**Fix**:
```bash
# Use npx without global install
npx playwright --version

# Or change npm global prefix
mkdir ~/.npm-global
npm config set prefix '~/.npm-global'
export PATH=~/.npm-global/bin:$PATH
npm install -g playwright
```

---

## Script Errors

### `Error: Cannot find module 'playwright'`

**Cause**: Playwright not installed in the current directory.

**Fix**:
```bash
npm install playwright
node script.js
```

---

### `TimeoutError: page.goto: Timeout 30000ms exceeded`

**Cause**: Page is taking too long to load, or URL is unreachable.

**Fix**:
```javascript
// Increase timeout
await page.goto(url, { timeout: 60000 });

// Or wait for less strict condition
await page.goto(url, { waitUntil: 'domcontentloaded' });
```

---

### `Error: page.click: Element is not visible`

**Cause**: Element exists in DOM but is hidden or not yet rendered.

**Fix**:
```javascript
// Wait until visible before clicking
await page.waitForSelector('#button', { state: 'visible' });
await page.click('#button');
```

---

### `Error: page.click: strict mode violation`

**Cause**: Selector matches multiple elements.

**Fix**: Use a more specific selector:
```javascript
// Instead of a broad selector:
await page.click('button');

// Use a specific one:
await page.click('button#submit');
await page.click('button:has-text("送信")');
```

---

## Local File Issues

### Local HTML file not loading / blank page

**Cause 1**: Relative path instead of absolute path.

**Fix**: Always use absolute paths with `file://`:
```javascript
const path = require('path');
const absPath = path.resolve('/Users/username/slide/index.html');
await page.goto(`file://${absPath}`);
```

**Cause 2**: File doesn't exist at the given path.

**Fix**: Verify the file exists:
```bash
ls -la /Users/username/slide/index.html
```

---

### Images/CSS not loading in local HTML

**Cause**: Local files referenced by relative paths may be blocked.

**Fix**: Use `--allow-file-access-from-files` flag (Chromium):
```javascript
const browser = await chromium.launch({
  args: ['--allow-file-access-from-files'],
});
```

---

## Screenshot Issues

### Screenshot is blank / all white

**Cause**: Page not fully loaded before screenshot.

**Fix**:
```javascript
await page.goto(url, { waitUntil: 'networkidle' });
// Additional wait for animations
await page.waitForTimeout(500);
await page.screenshot({ path: 'output.png' });
```

---

### Screenshot cuts off content

**Cause**: Viewport too small.

**Fix**:
```javascript
await page.setViewportSize({ width: 1920, height: 1080 });
// Or use fullPage option
await page.screenshot({ path: 'output.png', fullPage: true });
```

---

### Screenshot output path error

**Cause**: Output directory doesn't exist.

**Fix**:
```javascript
const fs = require('fs');
const outputDir = '/Users/username/screenshots';
fs.mkdirSync(outputDir, { recursive: true });
await page.screenshot({ path: `${outputDir}/output.png` });
```

---

## Marp-Specific Issues

### Marp `.md` file shows raw Markdown instead of slides

**Cause**: Playwright opens `.md` as plain text, not Marp slides.

**Fix**: Convert to HTML first, then open:
```bash
marp ~/slide/my-presentation.md --output ~/slide/my-presentation.html
```
Then open the `.html` file. See `marp-integration.md`.

---

### Marp HTML slide styles not applied

**Cause**: Page loaded before CSS/fonts finished.

**Fix**:
```javascript
await page.goto(`file://${filePath}`, { waitUntil: 'networkidle' });
await page.waitForTimeout(300); // wait for font rendering
await page.screenshot({ path: 'output.png' });
```
