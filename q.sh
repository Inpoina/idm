find /storage/emulated/0/kampret/query/ -type f -name "*" -exec awk -v start="DaftarIndex" -v end="KumpulanBarangJualString" '
BEGIN {
  RS = "\r?\n"  # Handle Windows/Unix line endings
}
{
  # Extract the filename from the full path
  basename = FILENAME
  gsub(".*/", "", basename)  # Remove directory components

  # Calculate short name (last 3 characters of the filename)
  if (!processed[FILENAME]) {
    shortName = substr(basename, length(basename) > 2 ? length(basename)-2 : 1, 3)
    filenames[FILENAME] = shortName
    processed[FILENAME] = 1
  }

  # Find start/end markers
  startPos = index($0, start)
  endPos = index($0, end)

  # If markers are valid, extract text and append to results
  if (startPos > 0 && endPos > startPos) {
    extracted = substr($0, startPos + length(start), endPos - (startPos + length(start)))
    results[FILENAME] = (results[FILENAME] ? results[FILENAME] " " : "") extracted
  }
}
END {
  # Print all results (one line per file)
  for (file in results) {
    print  results[file]
  }
}' {} + > results2.txt
