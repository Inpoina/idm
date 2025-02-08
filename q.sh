find /storage/emulated/0/kampret/query/ -type f -name "*" -exec awk -v start="DaftarIndex" -v end="KumpulanBarangJualString" '
{
  # Cari posisi start dan end
  startPos = index($0, start)
  endPos = index($0, end)

  # Jika kedua marker ditemukan dalam urutan yang benar
  if (startPos > 0 && endPos > startPos) {
    # Hitung posisi awal ekstraksi (2 karakter setelah "DaftarIndex")
    extractStart = startPos + length(start) + 2
    
    # Hitung panjang ekstraksi (hingga 4 karakter sebelum "KumpulanBarangJualString")
    extractLength = (endPos - 4) - extractStart

    # Pastikan panjang ekstraksi valid
    if (extractLength > 0) {
      extracted = substr($0, extractStart, extractLength)
      print extracted
    }
  }
}' {} + > results2.txt
