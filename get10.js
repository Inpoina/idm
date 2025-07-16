const axios = require('axios');
const fs = require('fs');

// Array of User-Agent strings
const userAgents = [
  'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Mobile Safari/537.36',
  'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
  'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.93 Safari/537.36',
  'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:87.0) Gecko/20100101 Firefox/87.0',
  'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/92.0.4515.159 Safari/537.36',
  // Add more user agents as needed
];

// Randomly select a User-Agent from the array
const randomUserAgent = userAgents[Math.floor(Math.random() * userAgents.length)];

const refreshToken = fs.readFileSync('refreshToken.txt', 'utf8').trim();

async function ambilUserToken() {
  try {
    const response = await axios.post(
      'https://ap-mc.klikindomaret.com/assets-klikidmsearch/api/post/customer/api/webapp/authentication/refresh-token',
      {
        refreshToken,
        accessToken: '', // Tidak wajib, bisa dikosongkan
        type: 'CORE'
      },
      {
        headers: {
          'Content-Type': 'application/json',
          'Origin': 'https://www.klikindomaret.com',
          'Referer': 'https://www.klikindomaret.com/',
          'User-Agent': randomUserAgent  // Use randomly selected User-Agent
        }
      }
    );

    const tokenBaru = response.data?.data?.accessToken;
    if (tokenBaru) {
      fs.writeFileSync('token.txt', tokenBaru);
      console.log('✅ Berhasil ambil user_token dan simpan di token.txt');
      console.log('🔑 accessToken:', tokenBaru);
    } else {
      console.log('❌ Token tidak ditemukan di response:', response.data);
    }
  } catch (error) {
    console.error('❌ Gagal ambil token:', error.response?.data || error.message);
  }
}

ambilUserToken();
