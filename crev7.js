const axios = require('axios');
const fs = require('fs');
const path = require('path');
const readline = require('readline');
const crypto = require('crypto');
const xlsx = require('xlsx');  // Importing xlsx package

const tokenPath = path.join(__dirname, 'token.txt');
const districtId = '141100100';
const latitude = -6.961055555555555;
const longitude = 107.55672222222222;
const mode = 'PICKUP';
const outputXLSX = path.join(__dirname, 'stok.xlsx');  // Changed to .xlsx

(async () => {
  // Baca token
  if (!fs.existsSync(tokenPath)) {
    console.error("❌ Token belum tersedia. Jalankan script login terlebih dahulu.");
    return;
  }

  const token = fs.readFileSync(tokenPath, 'utf8').trim();
  const bearerToken = `Bearer ${token}`;
  console.log("✅ Token ditemukan.");

  const apiContext = axios.create({
    baseURL: 'https://ap-mc.klikindomaret.com',
    headers: {
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

  // Minta input store code
  const storeCode = await new Promise(resolve => {
    const rlStore = readline.createInterface({ input: process.stdin, output: process.stdout });
    rlStore.question("🏬 Masukkan kode toko: ", input => {
      rlStore.close();
      resolve(input.trim());
    });
  });

  console.log(`Store code yang dipilih: ${storeCode}`);

  // Minta input PLU (pisah koma atau baris baru)
  const pluList = await new Promise(resolve => {
    const rlPlu = readline.createInterface({ input: process.stdin, output: process.stdout });
    rlPlu.question("🛒 Masukkan daftar PLU (pisahkan koma atau baris baru): ", input => {
      rlPlu.close();
      resolve(input.split(/[\s,]+/).map(p => p.trim()).filter(Boolean));
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

  // Calculate the max length for each column
  const maxNoLength = String(addedProducts.length).length;
  const maxPluLength = Math.max(...addedProducts.map(p => p.plu.length));
  const maxNameLength = Math.max(...addedProducts.map(p => p.name.length));
  const maxStockLength = Math.max(...addedProducts.map(p => String(p.stock).length));

  // Calculate column widths
  const colNoWidth = Math.max(maxNoLength, 2);
  const colPluWidth = Math.max(maxPluLength, 10);
  const colNameWidth = Math.max(maxNameLength, 20);
  const colStockWidth = Math.max(maxStockLength, 6);

  // Neat border output for the table
  const borderTop = "╔" + "═".repeat(colNoWidth + 2) + "╦" + "═".repeat(colPluWidth + 2) + "╦" + "═".repeat(colNameWidth + 2) + "╦" + "═".repeat(colStockWidth + 2) + "╗";
  const borderMid = "╠" + "═".repeat(colNoWidth + 2) + "╬" + "═".repeat(colPluWidth + 2) + "╬" + "═".repeat(colNameWidth + 2) + "╬" + "═".repeat(colStockWidth + 2) + "╣";
  const borderBot = "╚" + "═".repeat(colNoWidth + 2) + "╩" + "═".repeat(colPluWidth + 2) + "╩" + "═".repeat(colNameWidth + 2) + "╩" + "═".repeat(colStockWidth + 2) + "╝";

  console.log(`✅ stok toko: ${storeCode}`);
  console.log(borderTop);
  console.log(`║ No`.padEnd(colNoWidth + 2) + `║ PLU`.padEnd(colPluWidth + 2) + `║ Nama Produk`.padEnd(colNameWidth + 2) + `║ Sisa Stok`.padEnd(colStockWidth + 2) + "║");
  console.log(borderMid);

  addedProducts.forEach((p, i) => {
    const row = `║ ${String(i + 1).padStart(colNoWidth)} ║ ${String(p.plu).padEnd(colPluWidth)} ║ ${String(p.name).padEnd(colNameWidth)} ║ ${String(p.stock).padStart(colStockWidth)} ║`;
    console.log(row);
  });

  console.log(borderBot);

  // Create data for Excel
  const excelData = addedProducts.map((p, i) => ({
    No: i + 1,
    PLU: p.plu,
    "Nama Produk": p.name,
    "Sisa Stok": p.stock
  }));

  // Create a workbook and sheet
  const wb = xlsx.utils.book_new();
  const ws = xlsx.utils.json_to_sheet(excelData);

  // Auto-adjust column widths
  const colWidths = ['No', 'PLU', 'Nama Produk', 'Sisa Stok']; // Column names
  colWidths.forEach((col) => {
    const maxLength = Math.max(
      ...excelData.map((row) => String(row[col]).length), // Find the max length of content in each column
      col.length // Include the column name length for proper sizing
    );
    ws['!cols'] = ws['!cols'] || [];
    ws['!cols'].push({ wch: maxLength + 2 }); // Set width with an extra margin
  });

  // Add the sheet to the workbook
  xlsx.utils.book_append_sheet(wb, ws, "Cart");

  // Write the Excel file
  xlsx.writeFile(wb, outputXLSX);

  console.log(``);
})();
