import requests
import re

def get_prayer_times(url="https://namazvakitleri.diyanet.gov.tr/tr-TR/9543/kucukcekmece-icin-namaz-vakti"):
    response = requests.get(url)

    if response.status_code != 200:
        return "Failed to retrieve the page."

    prayer_times = {
        match[0]: match[1]
        for match in re.findall(r'var _(\w+)Time = "(\d{2}:\d{2})";', response.text)
    }

    formatted_prayer_names = {
        "imsak": "İmsak",
        "gunes": "Güneş",
        "ogle": "Öğle",
        "ikindi": "İkindi",
        "aksam": "Akşam",
        "yatsi": "Yatsı"
    }

    prayer_output = "\n".join(
        f"{formatted_prayer_names[key]}: {value}" for key, value in prayer_times.items()
    )

    hijri_date_match = re.search(r'<div class="ti-hicri">(.*?)<\/div>', response.text)
    miladi_date_match = re.search(r'<div class="ti-miladi">(.*?)<\/div>', response.text)

    hijri_date = f"Hijri Date: {hijri_date_match.group(1).strip()}" if hijri_date_match else "Hijri date not found."
    miladi_date = f"Miladi Date: {miladi_date_match.group(1).strip()}" if miladi_date_match else "Miladi date not found."

    return f"{prayer_output}\n\n{hijri_date}\n{miladi_date}"

if __name__ == "__main__":
    result = get_prayer_times()
    print(result)
