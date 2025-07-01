const { chromium } = require('playwright');
const fs = require('fs');

(async () => {
  const browser = await chromium.launch({ headless: false });
  const page = await browser.newPage();

  await page.goto('https://www.klikindomaret.com/login');

  await page.fill('input[name="email"]', 'EMAIL_KAMU');
  await page.fill('input[name="password"]', 'PASSWORD_KAMU');
  await page.click('button[type="submit"]');

  await page.waitForTimeout(5000); // tunggu redirect

  // Ambil token dari localStorage atau cookie
  const token = await page.evaluate(() => localStorage.getItem('accessToken'));

  if (token) {
    fs.writeFileSync('klikindomaret_token.txt', token);
    console.log('✅ Token berhasil disimpan.');
  } else {
    console.log('❌ Token tidak ditemukan.');
  }

  await browser.close();
})();
