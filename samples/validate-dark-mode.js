/*
  Validate Mermaid charts text color in dark mode using Playwright.
  - Navigates to running app URL
  - Waits for Mermaid diagrams to render
  - Toggles dark mode
  - Verifies SVG text fill and HTML label color are white
*/

const { chromium } = require('playwright');

async function run() {
  const url = process.env.URL || 'http://127.0.0.1:3001/index.html';
  const browser = await chromium.launch({ headless: true });
  const context = await browser.newContext();
  const page = await context.newPage();
  let failed = false;

  try {
    console.log(`Navigating to ${url}...`);
    const resp = await page.goto(url, { waitUntil: 'domcontentloaded', timeout: 30000 });
    if (!resp || !resp.ok()) {
      const status = resp ? resp.status() : 'no response';
      throw new Error(`Failed to load page (status: ${status})`);
    }

    // Wait for presentation to load and Mermaid elements to appear
    await page.waitForSelector('.mermaid', { timeout: 30000 });

    // Wait for initial mermaid render
    await page.waitForFunction(() => {
      const elements = Array.from(document.querySelectorAll('.mermaid'));
      return elements.length > 0 && elements.every(el => el.getAttribute('data-processed') === 'true');
    }, { timeout: 30000 });

    // Toggle dark mode (starts from auto -> dark)
    await page.click('#theme-toggle');

    // Wait for re-render after theme toggle
    await page.waitForFunction(() => {
      const elements = Array.from(document.querySelectorAll('.mermaid'));
      return elements.length > 0 && elements.every(el => el.getAttribute('data-processed') === 'true');
    }, { timeout: 30000 });

    // Give layout a moment to settle
    await page.waitForTimeout(250);

    // Check any SVG text element fill
    const svgTextFill = await page.evaluate(() => {
      const t = document.querySelector('.mermaid svg text, .mermaid svg tspan');
      if (!t) return null;
      return getComputedStyle(t).fill;
    });

    if (!svgTextFill) {
      throw new Error('No SVG text/tspan found inside Mermaid');
    }

    console.log('Computed SVG text fill:', svgTextFill);

    const isSvgTextWhite = /rgb\(\s*255\s*,\s*255\s*,\s*255\s*\)/i.test(svgTextFill) || svgTextFill.toLowerCase() === '#fff' || svgTextFill.toLowerCase() === '#ffffff' || svgTextFill.toLowerCase() === 'white';
    if (!isSvgTextWhite) {
      console.error('SVG text is not white in dark mode');
      failed = true;
    }

    // If any HTML label exists, ensure its color is white
    const hasHtmlLabel = await page.evaluate(() => !!document.querySelector('.mermaid svg foreignObject div'));
    if (hasHtmlLabel) {
      const htmlLabelColor = await page.evaluate(() => {
        const el = document.querySelector('.mermaid svg foreignObject div');
        return el ? getComputedStyle(el).color : null;
      });
      console.log('Computed HTML label color:', htmlLabelColor);
      const isHtmlLabelWhite = /rgb\(\s*255\s*,\s*255\s*,\s*255\s*\)/i.test(htmlLabelColor || '') || (htmlLabelColor || '').toLowerCase() === '#fff' || (htmlLabelColor || '').toLowerCase() === '#ffffff' || (htmlLabelColor || '').toLowerCase() === 'white';
      if (!isHtmlLabelWhite) {
        console.error('HTML label (foreignObject div) is not white in dark mode');
        failed = true;
      }
    } else {
      console.log('No HTML label found in diagrams (foreignObject). Skipping that check.');
    }

    if (failed) {
      throw new Error('Dark mode validation failed');
    }

    console.log('Dark mode validation passed: chart text is white.');
  } catch (err) {
    console.error(err.stack || String(err));
    process.exitCode = 1;
  } finally {
    await browser.close();
  }
}

run();


