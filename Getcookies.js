const axios = require('axios');
const fs = require('fs');
const path = require('path');
const readline = require('readline');
const crypto = require('crypto');

const cookiePath = path.join(__dirname, 'klikindomaret_cookie.txt');
const storeCode = 'TVE8';
const districtId = '141100100';
const latitude = -6.961055555555555;
const longitude = 107.55672222222222;
const mode = 'PICKUP';
const outputCSV = path.join(__dirname, 'hasil_cart.csv');

(async () => {
  // Baca cookie
  if (!fs.existsSync(cookiePath)) {
    console.error("❌ File cookie belum ditemukan. Buat file 'klikindomaret_cookie.txt' berisi string cookie.");
    return;
  }

  const cookie = fs.readFileSync(cookiePath, 'utf8').trim();
  if (!cookie) {
    console.error("❌ File cookie kosong. Harap isi dengan string cookie dari browser.");
    return;
  }

  console.log("✅ Cookie ditemukan.");

  const apiContext = axios.create({
    baseURL: 'https://ap-mc.klikindomaret.com',
    headers: {
      'cookie': cookie,
      'accept': 'application/json, text/plain, */*',
      'content-type': 'application/json',
      'origin': 'https://www.klikindomaret.com',
      'referer': 'https://www.klikindomaret.com/',
      'user-agent': 'Mozilla/5.0',
      'x-correlation-id': crypto.randomUUID(),
      'Request-Time': new Date().toISOString(),
      'apps': JSON.stringify({
        app_version: 'Mozilla/5.0',
        device_class: 'browser|browser',
        device_family: 'none',
        device_id: 'auto-id',
        os_name: 'Linux',
        os_version: 'x86_64'
      })
    }
  });

  // Minta input PLU
  const rl = readline.createInterface({ input: process.stdin, output: process.stdout });
  const pluList = await new Promise(resolve => {
    rl.question("🛒 Masukkan daftar PLU (pisahkan koma): ", input => {
      rl.close();
      resolve(input.split(',').map(p => p.trim()).filter(Boolean));
    });
  });

  const addedProducts = [];

  for (const plu of pluList) {
    console.log(`🔎 Mencari data untuk PLU: ${plu}...`);
    try {
      const res = await apiContext.post(
        '/assets-klikidmcore/api/post/cart-xpress/api/webapp/cart/add-to-cart',
        {
          storeCode,
          districtId,
          latitude,
          longitude,
          mode,
          products: [{ plu, qty: 1 }]
        }
      );

      const products = res.data?.data?.products || [];
      const matchedProduct = products.find(p => p.plu === plu);

      if (matchedProduct) {
        addedProducts.push({
          plu: matchedProduct.plu,
          name: matchedProduct.productName,
          stock: matchedProduct.stock
        });
      } else {
        console.log(`⚠️ PLU ${plu} tidak ditemukan atau tidak bisa ditambahkan.`);
      }

      // Kosongkan cart setelah selesai satu PLU
      await apiContext.post(
        '/assets-klikidmorder/api/post/cart-xpress/api/webapp/cart/update-cart',
        {
          storeCode,
          districtId,
          latitude,
          longitude,
          mode,
          products: []
        }
      );
    } catch (err) {
      console.error(`❌ Gagal tambah PLU ${plu}: ${err.response?.status || err.message}`);
    }
  }

  if (addedProducts.length === 0) {
    console.log("❌ Tidak ada produk valid untuk ditambahkan.");
    return;
  }

  // Tampilkan hasil
  console.log("✅ Produk berhasil ditambahkan ke cart:");
  addedProducts.forEach((p, i) => {
    console.log(`${i + 1}.\n   PLU        : ${p.plu}\n   Nama Produk: ${p.name}\n   Sisa Stok  : ${p.stock}\n---`);
  });

  // Simpan ke file CSV
  const csvHeader = 'No,PLU,Nama Produk,Sisa Stok';
  const csvRows = addedProducts.map((p, i) => `${i + 1},"${p.plu}","${p.name.replace(/"/g, '""')}","${p.stock}"`);
  const csvContent = [csvHeader, ...csvRows].join('\n');

  fs.writeFileSync(outputCSV, csvContent, 'utf8');
  console.log(`📄 Data berhasil disimpan ke file: ${outputCSV}`);
})();
