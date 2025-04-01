import os

folder_path = "/sdcard/kampret/domar"  # Update your folder path here

def dibayar(file_path):
    with open(file_path, 'r', encoding='utf-8') as file:
        content = file.read(1200)  # Read only the first 1200 characters
        return content

def ambil_karakter_setelah_ambil_tunai(line):
    index_ambil_tunai = line.find("AmbilTunai\":")
    if index_ambil_tunai != -1:
        index_awal_karakter = index_ambil_tunai + len("AmbilTunai\":")
        index_tanda_koma = line.find(",", index_awal_karakter)
        if index_tanda_koma != -1:
            return line[index_awal_karakter:index_tanda_koma].strip()
    return ""

def get_total_ambil_tunai():
    output_list = []

    for file_name in os.listdir(folder_path):
        file_path = os.path.join(folder_path, file_name)
        if os.path.isfile(file_path):
            first_1200_chars = dibayar(file_path)
            output_list.append(first_1200_chars)
    
    input_content = '\n'.join(output_list)

    extracted_characters = []
    for line in input_content.split('\n'):
        karakter_setelah_ambil_tunai = ambil_karakter_setelah_ambil_tunai(line)
        if karakter_setelah_ambil_tunai:
            try:
                extracted_characters.append(float(karakter_setelah_ambil_tunai))
            except ValueError:
                pass  

    total_sum = sum(extracted_characters)
    total_sum_int = int(total_sum)
    formatted_result = f"{total_sum_int:,}"
    
    return formatted_result  # Return result instead of printing

if __name__ == "__main__":
    print(f"Total sum of 'AmbilTunai': {get_total_ambil_tunai()}")
