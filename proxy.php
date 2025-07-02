<?php
// Tampilkan semua error
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

// Ambil input dari JS
$data = json_decode(file_get_contents("php://input"), true);
$url = $data['url'] ?? '';
$payload = json_encode($data['payload'] ?? []);

// Validasi file cookie.json
if (!file_exists("cookie.json")) {
    http_response_code(500);
    echo "❌ File cookie.json tidak ditemukan.";
    exit;
}

$raw = file_get_contents("cookie.json");
$json = json_decode($raw, true);

// Ambil cookies
$cookies = $json["cookies"] ?? [];
$cookieHeader = implode('; ', array_map(function($c) {
    return $c["name"] . "=" . $c["value"];
}, $cookies));

// Ambil USER_TOKEN dari localStorage
$token = null;
foreach ($json["origins"] ?? [] as $origin) {
    if ($origin["origin"] === "https://www.klikindomaret.com") {
        foreach ($origin["localStorage"] as $item) {
            if ($item["name"] === "USER_TOKEN") {
                $token = $item["value"];
                break 2;
            }
        }
    }
}

// Susun header
$headers = [
    'Content-Type: application/json',
    'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64)',
    'Referer: https://www.klikindomaret.com/',
    'Cookie: ' . $cookieHeader,
];

if ($token) {
    $headers[] = 'Authorization: Bearer ' . $token;
}

// Kirim request ke API KlikIndomaret
$ch = curl_init($url);
curl_setopt_array($ch, [
    CURLOPT_RETURNTRANSFER => true,
    CURLOPT_POST => true,
    CURLOPT_POSTFIELDS => $payload,
    CURLOPT_HTTPHEADER => $headers,
]);

$response = curl_exec($ch);
$err = curl_error($ch);
$httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
curl_close($ch);

// Jika error CURL
if ($err) {
    http_response_code(500);
    echo "❌ CURL Error: $err";
    exit;
}

// Balas hasil API
http_response_code($httpCode);
echo $response;
