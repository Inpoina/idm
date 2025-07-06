const axios = require('axios');
const fs = require('fs');

// Membaca refresh token dari file
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
          'User-Agent': 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Mobile Safari/537.36'
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
