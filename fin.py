import getpass
import requests
from bs4 import BeautifulSoup
import os

# URL of the webpage
url = "https://wificost.my.id/kampretsh/"

# Send a GET request to the URL
response = requests.get(url)

# Check if the request was successful (status code 200)
if response.status_code == 200:
    # Parse the HTML content of the page
    soup = BeautifulSoup(response.content, "html.parser")
    # Find the title of the page
    title = soup.title.string.strip()
    

    # Set the password based on the title
    password = title

    # Prompt the user for input
    input_password = getpass.getpass("Enter the password: ")

    # Check if the input password matches the set password
    if input_password == password:
        # Execute your command here
        print("Access granted. Running the command...")
        # Your command goes here
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
        def clear_screen():
            os.system('cls' if os.name == 'nt' else 'clear')
        
        stor =int(input("stor:"))
        tartun =int(input("tartun:"))
        final = total_price - stor - tartun
        final2 = '{:,}'.format(final)
        stor2 = '{:,}'.format(stor)
        tartun2 = '{:,}'.format(tartun)
        
        clear_screen()
        """print("total:",formatted_total_price)
        print("stor:",stor2)
        print("tartun:",tartun2)
        print("aktual kas:",final2)
        """
        # Define fixed widths for alignment
        width = 16
        
        # Print variables with right alignment
        print(f"total : {formatted_total_price:>{width}}")
        print(f"stor  : {stor2:>16}")
        print(f"tartun: {tartun2:>16}")
        print("________________________ -")
        print(f"aktual kas: {final2:>12}")
    else:
        print("Access denied. Incorrect password.")
else:
    print("Error:", response.status_code)
