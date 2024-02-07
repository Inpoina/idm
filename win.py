import os

folder_path = "/sdcard/kampret/domar"

def dibayar(file_path):
    with open(file_path, 'r') as file:
        content = file.read()
        return content[-400:]

def main():
    output_list = []
    for file_name in os.listdir(folder_path):
        file_path = os.path.join(folder_path, file_name)
        if os.path.isfile(file_path):
            last_400_chars = dibayar(file_path)
            output_list.append(last_400_chars)
    return output_list

if __name__ == "__main__":
    ini = main()
    # Now you can use 'output' as your new variable containing the output.

    input_content = '\n'.join(ini)

    def ambil_karakter_setelah_secara_tunai(line):
        index_secara_tunai = line.find("SecaraTunai\":")
        if index_secara_tunai != -1:
            index_awal_karakter = index_secara_tunai + len("SecaraTunai\":")
            index_tanda_koma = line.find(".", index_awal_karakter)
            if index_tanda_koma != -1:
                return line[index_awal_karakter:index_tanda_koma]
        return ""

    def main(input_content):
        extracted_characters = []
        for line in input_content.split('\n'):
            karakter_setelah_secara_tunai = ambil_karakter_setelah_secara_tunai(line)
            if karakter_setelah_secara_tunai:
                extracted_characters.append(int(karakter_setelah_secara_tunai))  # Convert to integer
        return extracted_characters

    output_price = main(input_content)

    total_price = sum(output_price)

formatted_total_price = '{:,}'.format(total_price)
print("Total price:", formatted_total_price)

