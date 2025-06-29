const { request } = require('playwright');
const fs = require('fs');
const path = require('path');
const readline = require('readline');
const crypto = require('crypto');

const tokenPath = path.join(__dirname, 'klikindomaret_token.txt');
const storeCode = 'TVE8';
const districtId = '141100100';
const latitude = -6.961055555555555;
const longitude = 107.55672222222222;
const mode = 'PICKUP';

(async () => {
  // Baca token
  if (!fs.existsSync(tokenPath)) {
    console.error("❌ Token belum tersedia. Jalankan script login terlebih dahulu.");
    return;
  }

  const token = fs.readFileSync(tokenPath, 'utf8');
  const bearerToken = `Bearer ${token}`;
  console.log("✅ Token ditemukan.");

  // Siapkan request context
  const apiContext = await request.newContext({
    baseURL: 'https://ap-mc.klikindomaret.com',
    extraHTTPHeaders: {
      'authorization': bearerToken,
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

  // Minta input PLU dari user
  const rl = readline.createInterface({ input: process.stdin, output: process.stdout });
  const pluList = await new Promise(resolve => {
    rl.question("🛒 Masukkan daftar PLU (pisahkan koma): ", input => {
      rl.close();
      resolve(input.split(',').map(p => p.trim()).filter(Boolean));
    });
  });

  // Tambah semua PLU ke cart
  const addedProducts = [];

  for (const plu of pluList) {
    console.log(`🔎 Mencari data untuk PLU: ${plu}...`);

    // Endpoint add-to-cart
    const res = await apiContext.post(
      '/assets-klikidmcore/api/post/cart-xpress/api/webapp/cart/add-to-cart',
      {
        data: {
          storeCode,
          districtId,
          latitude,
          longitude,
          mode,
          products: [{ plu, qty: 1 }]
        }
      }
    );

    if (!res.ok()) {
      console.error(`❌ Gagal tambah PLU ${plu} (HTTP ${res.status()})`);
      continue;
    }

    const json = await res.json();
    const prod = json?.data?.products?.[0];

    if (prod) {
      addedProducts.push({
        plu: prod.plu,
        name: prod.productName,
        stock: prod.stock
      });
    } else {
      console.log(`⚠️ PLU ${plu} tidak ditemukan atau tidak bisa ditambahkan.`);
    }
  }

  if (addedProducts.length === 0) {
    console.log("❌ Tidak ada produk valid untuk ditambahkan.");
    return;
  }

  // Tampilkan isi cart
  console.log("✅ Produk berhasil ditambahkan ke cart:");
  addedProducts.forEach((p, i) => {
    console.log(`${i + 1}.\n   PLU        : ${p.plu}\n   Nama Produk: ${p.name}\n   Sisa Stok  : ${p.stock}\n---`);
  });

  // Hapus semua isi cart via update-cart kosong
  const clearPayload = {
    storeCode,
    districtId,
    latitude,
    longitude,
    mode,
    products: []
  };

  const clearRes = await apiContext.post(
    '/assets-klikidmorder/api/post/cart-xpress/api/webapp/cart/update-cart',
    { data: clearPayload }
  );

  if (clearRes.ok()) {
    console.log("🧼 Semua produk berhasil dihapus dari cart.");
  } else {
    console.error(`❌ Gagal hapus cart (HTTP ${clearRes.status()})`);
    console.error(await clearRes.text());
  }
})();
