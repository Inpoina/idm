#!/bin/bash

# Define the file
file="token.txt"

# Prompt user for new content
echo "Masukkan isi baru untuk file $file:"
read new_content

# Update the file with the new content
echo "$new_content" > "$file"

# Optional: Confirm the new content
echo "File telah diperbarui dengan isi baru."
