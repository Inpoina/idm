#!/data/data/com.termux/files/usr/bin/bash

# Path file atau folder lokal
FILE_PATH="$1"

# Remote Google Drive (sesuai konfigurasi)
REMOTE_NAME="gdrive"

# Folder tujuan di Google Drive (kosong = root)
DEST_FOLDER="stok"

# Langkah 1: Hapus isi tujuan
echo "Menghapus isi Google Drive di folder '$DEST_FOLDER'..."
rclone purge "$REMOTE_NAME:$DEST_FOLDER" --fast-list

# Langkah 2: Upload dengan optimasi kecepatan
echo "Mengupload '$FILE_PATH' ke Google Drive dengan mode cepat..."
rclone copy "$FILE_PATH" "$REMOTE_NAME:$DEST_FOLDER" \
  --transfers=8 \
  --checkers=16 \
  --drive-chunk-size=64M \
  --fast-list \
  --progress

echo "Upload selesai."
