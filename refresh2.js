const axios = require('axios');
const fs = require('fs');

// GANTI DENGAN REFRESH TOKEN ANDA (dari file HAR)
const refreshToken = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJzdWIiOiJjdXN0LTIyNjk5NDhAa2xpa2luZG9tYXJldC5jb20iLCJpc0VtcGxveWVlIjoiZmFsc2UiLCJleHRlcm5hbEN1c3RvbWVySWQiOiI5YjcyMjVkMy1iZGE2LTRlNGYtYWYwNC01ZWQyNWFjNGFjYmUiLCJuYmYiOjE3NTE1Mzc4ODQsInNjb3BlIjoibW9iaWxlIiwiaXNEcmFmdCI6ImZhbHNlIiwiY3VzdG9tZXJJZCI6IjIyNjk5NDgiLCJleHAiOjE3NTQxMjk4ODQsInNpZCI6Ijc0MTliZGM1LTZiZTYtNGMzZi05YTY1LTcxMjhlZjY1Yzg2MyIsInVzZXJuYW1lIjoiY3VzdC0yMjY5OTQ4QGtsaWtpbmRvbWFyZXQuY29tIn0.T_8kIzrx-ogmuFb2peX92_K87xfyPz3mh9_L4CVaVZhuO8ddFLNkpYuuZ6IKGxYTPlyycO0vVl-_BoofAjQUWq5Jl6qFt4DE3-2o5Us9-5QEyf8ysRZwNE3Hz479aujSL903pege6QrDovErq5tP9mdmgloGAAU3-58V6kH5p5DQ60EfVYSZn2XiUmLxi01QbI-HG2v8TY9AT2xu8a6ODGc5wggoGg0_n8Te6c4gGigCqYt7H5pUVHw9M6Wl2pkUTA2IrBgrRtTIwGB1ZbUW12pWkV1kbsHOdnAkoxu8IXlHmU81FbU6e5VK4VgeutGq1F-uMSt3WviTkGxRuOz5FlWynShyRhZpXd_pDYdBUpoCrzSO9YS--cxHuRJtHQ1niddouFfLdm5Fy7NriOcKNjfOVS7YPMNGJ3bhSe3cX4F7kVijxRuqxdXY2lYobqOzEBVZmwrsRjvYflI2tyXRAS62JfImqxHxpd81dzIcqtD6B6QFHfyfP7rirAkm3WrkvXycPUOjLaulDEzLVi1CfwRsUw3upgH-ytwCeqch7ibvdRB-1wVPhCUoCLEzTWfdIQn4LdNA0iEyGER2p3OnKJTOWR52AGm7lYPKzWFFzKHtIiGXkcdX9H8NqFUTiq9wTY66ZX8dKzBIgAzQ5nXZXXKJnCTS2lj4FvxzYQ4bPFs';

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
      fs.writeFileSync('token.json', JSON.stringify({ token: tokenBaru }, null, 2));
      console.log('✅ Berhasil ambil user_token dan simpan di token.json');
      console.log('🔑 accessToken:', tokenBaru);
    } else {
      console.log('❌ Token tidak ditemukan di response:', response.data);
    }
  } catch (error) {
    console.error('❌ Gagal ambil token:', error.response?.data || error.message);
  }
}

ambilUserToken();
