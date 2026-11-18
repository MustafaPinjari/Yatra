import puppeteer from 'puppeteer-core';
import fs from 'fs';
import path from 'path';

const edgePath = 'C:\\Program Files (x86)\\Microsoft\\Edge\\Application\\msedge.exe';
const outDir = path.resolve('../../docs/design/screenshots');

if (!fs.existsSync(outDir)) {
  fs.mkdirSync(outDir, { recursive: true });
}

async function clickButtonByText(page, text) {
  return page.evaluate((btnText) => {
    const buttons = Array.from(document.querySelectorAll('button'));
    const target = buttons.find((b) => b.textContent && b.textContent.includes(btnText));
    if (target) {
      target.click();
      return true;
    }
    return false;
  }, text);
}

async function capture() {
  console.log('Launching Edge browser at:', edgePath);
  const browser = await puppeteer.launch({
    executablePath: edgePath,
    headless: true,
    args: ['--no-sandbox', '--disable-setuid-sandbox', '--disable-gpu'],
  });

  const page = await browser.newPage();
  await page.setViewport({ width: 1440, height: 950, deviceScaleFactor: 2 });

  console.log('Navigating to http://localhost:3000 ...');
  await page.goto('http://localhost:3000', { waitUntil: 'networkidle0', timeout: 30000 });

  // 1. Capture Master Passenger Home in Phone Frame
  console.log('Capturing: 01-passenger-phone-frame.png');
  await page.screenshot({ path: path.join(outDir, '01-passenger-phone-frame.png') });

  // 2. Click Operator Portal
  console.log('Capturing: 02-operator-portal.png');
  await clickButtonByText(page, 'Operator Portal');
  await new Promise((r) => setTimeout(r, 800));
  await page.screenshot({ path: path.join(outDir, '02-operator-portal.png') });

  // 3. Click Government Intelligence Portal
  console.log('Capturing: 03-govt-intelligence-portal.png');
  await clickButtonByText(page, 'Govt Intelligence');
  await new Promise((r) => setTimeout(r, 800));
  await page.screenshot({ path: path.join(outDir, '03-govt-intelligence-portal.png') });

  // 4. Return to Passenger App and cycle through each screen tab
  await clickButtonByText(page, 'Passenger App');
  await new Promise((r) => setTimeout(r, 600));

  // A. Intro Screen
  console.log('Capturing: 04-passenger-intro.png');
  await clickButtonByText(page, 'A. Introduction Screen');
  await new Promise((r) => setTimeout(r, 600));
  await page.screenshot({ path: path.join(outDir, '04-passenger-intro.png') });

  // C. Journey Planner
  console.log('Capturing: 05-passenger-journey-planner.png');
  await clickButtonByText(page, 'C. Journey Planner');
  await new Promise((r) => setTimeout(r, 600));
  await page.screenshot({ path: path.join(outDir, '05-passenger-journey-planner.png') });

  // D. Live Bus Tracking
  console.log('Capturing: 06-passenger-live-tracking.png');
  await clickButtonByText(page, 'D. Live Bus Tracking');
  await new Promise((r) => setTimeout(r, 600));
  await page.screenshot({ path: path.join(outDir, '06-passenger-live-tracking.png') });

  // E. Boarding Assistance
  console.log('Capturing: 07-passenger-boarding-assistance.png');
  await clickButtonByText(page, 'E. Boarding Assistance');
  await new Promise((r) => setTimeout(r, 600));
  await page.screenshot({ path: path.join(outDir, '07-passenger-boarding-assistance.png') });

  // F. Accessible Stops
  console.log('Capturing: 08-passenger-accessible-stops.png');
  await clickButtonByText(page, 'F. Accessible Stops');
  await new Promise((r) => setTimeout(r, 600));
  await page.screenshot({ path: path.join(outDir, '08-passenger-accessible-stops.png') });

  await browser.close();
  console.log('All screenshots captured successfully into:', outDir);
}

capture().catch((err) => {
  console.error('Error during capture:', err);
  process.exit(1);
});
